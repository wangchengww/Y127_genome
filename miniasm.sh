#PBS -N miniasm
#PBS -l nodes=1:ppn=1
#PBS -l mem=1500G
#PBS -q high
# Program:
# 	Assemble using miniasm
# History:
# 	2020/06/25	WangPF	First release

# V1	assemble with default parameter
# V1.1	change to smp1

work_dir=/public/home/wangpf/workspace/Y127_genomics/01.Assembly
fq=${work_dir}/00.data/Y127_DNA_Pacbio.fastq.gz

cd ${work_dir}/03.assembly_miniasm

miniasm -f ${fq} Y127.paf.gz > Y127.gfa


