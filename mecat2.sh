#PBS -N mecat2
#PBS -l nodes=1:ppn=100
#PBS -q high
# Program:
# 	 Assemble Y127 genome using MECAT2
# History:
# 	2020/06/14	WangPF	First release

cd /public/home/wangpf/workspace/Y127_genomics/01.Assembly/02.assembly_mecat2

mecat.pl correct Y127_config_file.txt &> mecat_correct.log

mecat.pl trim Y127_config_file.txt &> mecat_trim.log

mecat.pl assemble Y127_config_file.txt &> mecat_assemble.log

