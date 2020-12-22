#PBS -N PBdata_trans
#PBS -l nodes=1:ppn=1
# Program:
# 	Convert Pacbio bam file to fasta/fastq
# History:
# 	2020/06/01	WangPF	First release

cd ~/workspace/Y127_genomics/01.Assembly/00.data/

# bam2fasta
~/tools/smrtlink/smrtcmds/bin/bam2fasta -o Y127_DNA_Pacbio ~/data_release/data_2019/Y127_Genomics/DNA_PacBio/4_D01/m64033_190826_042615.subreads.bam
# bam2fastq
~/tools/smrtlink/smrtcmds/bin/bam2fastq -o Y127_DNA_Pacbio ~/data_release/data_2019/Y127_Genomics/DNA_PacBio/4_D01/m64033_190826_042615.subreads.bam

mkdir -p QC
fastqc -o ./QC -t 1 Y127_DNA_Pacbio.fastq.gz
