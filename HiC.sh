#PBS -N HiC
#PBS -l nodes=1:ppn=100
#PBS -q high
# 20201124	HiC, zs11 as refseq

PATH=/public/home/wangpf/tools/bwa-0.7.17:$PATH
export PATH

work_dir=/public/home/wangpf/workspace/Y127_genomics/01.Assembly/09.HiC/zs11_as_ref

cd ${work_dir}

ln -s /public/home/wangpf/tools/juicer/CPU/ ./scripts
#cd scripts/common
#wget https://s3.amazonaws.com/hicfiles.tc4ga.com/public/juicer/juicer_tools_1.22.01.jar
#ln -s juicer_tools_1.22.01.jar juicer_tools.jar
#cd ../../

# HiC数据
mkdir -p ${work_dir}/fastq
cd ${work_dir}/fastq
ln -s /public/home/wangpf/data_release/data_2019/Y127_Genomics/Y127-HiC/rawdata/Y127_1.fq.gz ./Y127_R1.fastq.gz
ln -s /public/home/wangpf/data_release/data_2019/Y127_Genomics/Y127-HiC/rawdata/Y127_2.fq.gz ./Y127_R2.fastq.gz
cd ..

# 参考基因组建立索引
mkdir -p ${work_dir}/references
cd references
ln -s /public/home/wangpf/ref_seq/Brassica_napus/zs11/zs11.genome.fa ./
bwa index zs11.genome.fa
cd ..

# 添加限制性内切酶位点信息
mkdir -p ${work_dir}/restriction_sites
cd restriction_sites/
python2.7 /public/home/wangpf/tools/juicer/misc/generate_site_positions.py MboI zs11 ../references/zs11.genome.fa # 生成 zs11_MboI.txt 文件
awk 'BEGIN{OFS="\t"}{print $1, $NF}' zs11_MboI.txt > zs11.chrom.sizes
cd ..

# 运行 Juicer
bash scripts/juicer.sh \
	-d ${work_dir}/ -D ${work_dir} \
	-y ${work_dir}/restriction_sites/zs11_MboI.txt \
	-z ${work_dir}/references/zs11.genome.fa \
	-p ${work_dir}/restriction_sites/Y127.chrom.sizes \
	-s MboI -t 100

