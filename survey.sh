#PBS -N survey
#PBS -l nodes=1:ppn=28
#PBS -q batch
# Program:
# 	Survey with K-mer from 17 to 51
# History:
# 	2020/06/01	WangPF	Fourth release
# V1	Kmer = 19
# V2	Kmer = seq 17 2 51
# V3	QC by fastp
# V4	rm PCR duplication by fastuniq

work_dir=/public/home/wangpf/workspace/Y127_genomics
thread=28

# QC by fastp
cd ${work_dir}/01.Assembly/00.data
zcat /public/home/wangpf/data_release/data_2019/Y127_Genomics/DNA_ngs/v300030276_L02_503_1.fq.gz /public/home/wangpf/data_release/data_2019/Y127_Genomics/DNA_ngs/v300030276_L02_504_1.fq.gz > Y127_DNA_NGS_1.fq
zcat /public/home/wangpf/data_release/data_2019/Y127_Genomics/DNA_ngs/v300030276_L02_503_2.fq.gz /public/home/wangpf/data_release/data_2019/Y127_Genomics/DNA_ngs/v300030276_L02_504_2.fq.gz > Y127_DNA_NGS_2.fq

ls Y127_DNA_NGS_[1,2].fq > data.list
fastuniq -i data.list -o Y127_DNA_NGS_1.rd.fq -p Y127_DNA_NGS_2.rd.fq

fastp -i Y127_DNA_NGS_1.rd.fq -o Y127_DNA_NGS_1.rd.clean.fq.gz \
      -I Y127_DNA_NGS_2.rd.fq -O Y127_DNA_NGS_2.rd.clean.fq.gz \
      --length_required 100 \
      --html Y127_DNA_NGS.rd.html --json Y127_DNA_NGS.rd.json --report_title="Y127_DNA_NGS.rd fastp report" \
      --thread=8

mkdir -p QC
fastqc -o ./QC -t ${thread} --nogroup Y127_DNA_NGS_[1,2].fq Y127_DNA_NGS_[1,2].rd.fq Y127_DNA_NGS_[1,2].rd.clean.fq.gz
#rm Y127_DNA_NGS_1.fq Y127_DNA_NGS_2.fq

# survey by jellyfish
for k in $(seq 19 2 51)
do

pre=Kmer_${k}

mkdir -p ${work_dir}/01.Assembly/01.kmer_analysis/${pre}
cd ${work_dir}/01.Assembly/01.kmer_analysis/${pre}

ls ${work_dir}/01.Assembly/00.data/Y127_DNA_NGS_[1,2].rd.clean.fq.gz | awk  '{print "gzip -dc "$0 }' > generate.file
jellyfish count -t ${thread} -C -m ${k} -s 5G -g generate.file -G 2  -o ${pre}
jellyfish histo -v -o ${pre}.histo ${pre} -t ${thread} -h 10000
jellyfish stats ${pre} -o ${pre}.stat

# Kmer_k文件较大，删除节省存储空间
rm ${pre}

Rscript ~/tools/genomescope-1.0.0/genomescope.R ${pre}.histo ${k} 151 ./ 100000

done

cd ${work_dir}/01.Assembly/00.data
gzip Y127_DNA_NGS*fq



