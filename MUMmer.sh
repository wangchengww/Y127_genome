#PBS -N MUMmer
#PBS -l nodes=1:ppn=1
#PBS -q low
# Program:
#       MUMmer, Y127 A and C subgenome
# History:
#       2020/08/25      WangPF  First release
# V1	20200825	MUMmer, Y127 A and C subgenome
# V2	20200914	修改--minalign=1000 --mincluster=10000 

export PATH=~/tools/MUMmer3.23/:$PATH

cd /public/home/wangpf/workspace/Y127_genomics/05.Collinearity/MUMmer
nucmer --threads=4 --maxgap=500 --minalign=1000 --mincluster=10000 --prefix=Y127_A_C Y127_A.genome.fa Y127_C.genome.fa 

