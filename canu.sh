#PBS -N canu
#PBS -l nodes=1:ppn=140
#PBS -l walltime=300000:00:00
#PBS -q high
# Program:
# 	Assemble Y127 genome using caun-2.0
# History:
# 	2020/06/21	WangPF	First release
# V1 all step is with defult parameters

mkdir -p /public/home/wangpf/workspace/Y127_genomics/01.Assembly/04.assembly_canu
cd /public/home/wangpf/workspace/Y127_genomics/01.Assembly/04.assembly_canu

canu -correct \
     -p Y127 -d Y127 \
     genomeSize=1200m \
     maxThreads=140 \
     useGrid=false \
     -pacbio-raw ../00.data/Y127_DNA_Pacbio.fastq.gz &> correct.log

canu -trim \
     -p Y127 -d Y127 \
     genomeSize=1200m \
     maxThreads=140 \
     useGrid=false \
     -pacbio-corrected ./Y127/Y127.correctedReads.fasta.gz &> trim.log

# assemble with defult correctedErrorRate
canu -assemble \
     -p Y127 -d Y127 \
     genomeSize=1200m \
     maxThreads=140 \
     useGrid=false \
     correctedErrorRate=0.045 \
     -pacbio-corrected ./Y127/Y127.trimmedReads.fasta.gz &> assemble.log



