#PBS -N pilon
#PBS -l nodes=1:ppn=20
#PBS -l mem=1100G
#PBS -q high
# Program:
# 	Y127 canu assemble polish with pilon
# Author:
# 	WangPF
# History:
# V1	2020/10/22	Y127 canu assemble polish with pilon
# V1.1	2020/10/23	Java程序内存有10g改成250g
# V1.2	2020/10/25	改到旁节点，内存由250g改为500g

cd ~/workspace/Y127_genomics/01.Assembly/00.data

#cat ~/data_release/data_2019/Y127_Genomics/DNA_ngs/v300030276_L02_50[3,4]_1.fq.gz > ./Y127_DNA_ngs_1.fq.gz
#cat ~/data_release/data_2019/Y127_Genomics/DNA_ngs/v300030276_L02_50[3,4]_2.fq.gz > ./Y127_DNA_ngs_2.fq.gz

# 质控
raw_fq1=~/workspace/Y127_genomics/01.Assembly/00.data/Y127_DNA_ngs_1.fq.gz
raw_fq2=~/workspace/Y127_genomics/01.Assembly/00.data/Y127_DNA_ngs_2.fq.gz
clean_fq1=~/workspace/Y127_genomics/01.Assembly/00.data/Y127_DNA_ngs_1.clean.fq.gz
clean_fq2=~/workspace/Y127_genomics/01.Assembly/00.data/Y127_DNA_ngs_2.clean.fq.gz

#fastp -i ${raw_fq1} -o ${clean_fq1} \
#      -I ${raw_fq2} -O ${clean_fq2} \
#      --json=./Y127_DNA_ngs.json --html=Y127_DNA_ngs.html --report_title="Y127 DNA ngs fastp report" \
#      --thread=8 --length_required 100

#fastqc --outdir ./QC --nogroup --threads 4 *.fq.gz

# 
cd ~/workspace/Y127_genomics/01.Assembly/07.pilon
#ln -s ~/workspace/Y127_genomics/01.Assembly/04.assembly_canu/Y127/Y127.contigs.fasta ./

draft_genome=Y127.contigs.fasta

#bwa index ${draft_genome}

#bwa mem -t 28 ${draft_genome} ${clean_fq1} ${clean_fq2} | samtools sort - -o Y127_DNA_ngs.bam
#samtools index Y127_DNA_ngs.bam

java -Xmx500G -jar ~/tools/pilon/pilon-1.23.jar \
     --genome $draft_genome \
     --frags Y127_DNA_ngs.bam \
     --changes --vcf --diploid --threads 20 \
     --outdir ./pilon_out --output Y127_genome_pilon
