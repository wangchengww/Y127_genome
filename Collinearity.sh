#PBS -N Collinearity
#PBS -l nodes=1:ppn=28
#PBS -q batch
#!/bin/bash
# Program:
# 	Collinearity 
# History:
# 	2020/07/22	WangPF  First release
# V1    Y127

# 添加环境变量
export PATH=~/tools/MCScanX/:$PATH
export CLASSPATH=~/tools/MCScanX/downstream_analyses/:$CLASSPATH



mkdir -p ~/workspace/Y127_genomics/05.Collinearity/Y127/
cd ~/workspace/Y127_genomics/05.Collinearity/Y127/
mkdir -p ./data ./blast

# 数据准备
ln -s ../../../company_result/change_id_2/gene/Brassica_napus.gene.idChange.pep ./blast
ln -s ../../../company_result/change_id_2/gene/Brassica_napus.gene.idChange.gff ./data

cd ./blast
samtools faidx Brassica_napus.gene.idChange.pep
awk '{print $1}' Brassica_napus.gene.idChange.pep.fai | split -l 2000 - -d -a 3 gene_id_

for i in $(ls gene_id_0*_pep.fa)
do
for j in $(cat ${i})
do
samtools faidx Brassica_napus.gene.idChange.pep ${j}
done > ${i}_pep.fa &
done

wait

# blast
makeblastdb -in Brassica_napus.gene.idChange.pep -dbtype prot -parse_seqids -out Y127.pep -logfile makeblastdb.log
for i in $(ls gene_id_0*)
do
blastp -db Y127.pep -query ${i} -outfmt 6 -evalue 1e-10 -num_alignments 8 -out ${i}_blast.txt &
done

wait

cat *_blast.txt > Y127.blast

mv Y127.blast ../data

# gff transform
cd ../data
sed 's/ID=//' Brassica_napus.gene.idChange.gff | sed 's/;//' | awk '{if($3=="mRNA") print $1"\t"$9"\t"$4"\t"$5}' > Y127.gff


# MSCscanX
cd ..

prefix=Y127

MCScanX data/Y127

java dot_plotter -g data/$prefix.gff -s data/$prefix.collinearity -c $prefix.dot.ctl -o $prefix.dot.png

java dual_synteny_plotter -g data/$prefix.gff -s data/$prefix.collinearity -c $prefix.dual_synteny.ctl -o $prefix.dual_synteny.png

java circle_plotter -g data/$prefix.gff -s data/$prefix.collinearity -c $prefix.circle.ctl -o $prefix.circle.png

java bar_plotter -g data/$prefix.gff -s data/$prefix.collinearity -c $prefix.bar.ctl -o $prefix.bar.png
 

