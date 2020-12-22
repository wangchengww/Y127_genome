#PBS -N GeneFamilyCluster
#PBS -l nodes=1:ppn=4
#PBS -q low
# Program:
# 	GeneFamilyCluster
# History:
# 	2020/07/15	WangPF	First release
# V1	Using orthofinder

# 添加/public/home/wangpf/anaconda3/envs/orthofinder/bin到PATH因为这个路径下有mafft软件
export PATH=~/tools/OrthoFinder/bin:~/tools/OrthoFinder:$PATH:/public/home/wangpf/anaconda3/envs/orthofinder/bin

cd /public/home/wangpf/workspace/Y127_genomics/04.GeneFamilyCluster

orthofinder -f data \
	-S diamond \
	-M msa \
	-T fasttree \
	-t 4 &> orthofinder.log

