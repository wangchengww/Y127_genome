#PBS -N minimap2
#PBS -l nodes=1:ppn=28
#PBS -l walltime=10000:00:00
#PBS -q batch
# Program:
# 	Raw read overlap detection (minimap)
# History:
# 	2020/06/19	WangPF	First release

work_dir=/public/home/wangpf/workspace/Y127_genomics/01.Assembly
fq=${work_dir}/00.data/Y127_DNA_Pacbio.fastq.gz
thread=28

mkdir -p ${work_dir}/03.assembly_miniasm
cd ${work_dir}/03.assembly_miniasm

minimap2 -x ava-pb -t ${thread} ${fq} ${fq} | gzip -1 > Y127.paf.gz


