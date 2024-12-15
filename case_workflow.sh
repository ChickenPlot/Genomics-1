# dataa retrive
cp /home/BCG2023_genomics_exam/case1674_child.fq.gz /home/BCG_ssarto/genomics2023/project/case1674
cp /home/BCG2023_genomics_exam/case1674_father.fq.gz /home/BCG_ssarto/genomics2023/project/case1674 
cp /home/BCG2023_genomics_exam/case1674_mother.fq.gz /home/BCG_ssarto/genomics2023/project/case1674

#
bowtie2 -U case1674_child.fq.gz -p 8 -x /home/BCG2023_genomics_exam/uni --rg-id 'C' --rg "SM:child" | samtools view -Sb | samtools sort -o case1674_child.bam

bowtie2 -U case1674_father.fq.gz -p 8 -x /home/BCG2023_genomics_exam/uni --rg-id 'F' --rg "SM:father" | samtools view -Sb | samtools sort -o case1674_father.bam

bowtie2 -U case1674_mother.fq.gz -p 8 -x /home/BCG2023_genomics_exam/uni --rg-id 'M' --rg "SM:mother" | samtools view -Sb | samtools sort -o case1674_mother.bam


samtools index case1674_child.bam
samtools index case1674_father.bam
samtools index case1674_mother.bam


#

bedtools genomecov -ibam case1674_child.bam -bg -trackline -trackopts 'name="child"' -max 100 > case1674_childCov.bg

bedtools genomecov -ibam case1674_father.bam -bg -trackline -trackopts 'name="father"' -max 100 > case1674_fatherCov.bg

bedtools genomecov -ibam case1674_mother.bam -bg -trackline -trackopts 'name="mother"' -max 100 > case1674_motherCov.bg


#
qualimap bamqc -bam case1674_child.bam -gff /home/BCG2023_genomics_exam/exons16Padded_sorted.bed -outdir case1674_child

qualimap bamqc -bam case1674_father.bam -gff /home/BCG2023_genomics_exam/exons16Padded_sorted.bed -outdir case1674_father

qualimap bamqc -bam case1674_mother.bam -gff /home/BCG2023_genomics_exam/exons16Padded_sorted.bed -outdir case1674_mother

#
fastqc case1674_child.fq.gz
fastqc case1674_father.fq.gz
fastqc case1674_mother.fq.gz

#
multiqc case1674*


#
freebayes -f /home/BCG2023_genomics_exam/universe.fasta -t /home/BCG2023_genomics_exam/exons16Padded_sorted.bed -m 20 -C 5 -Q 10 --min-coverage 10 case1674_child.bam case1674_father.bam case1674_mother.bam > case1674.vcf

#
grep "#CHR"  case1674.vcf
grep -v "#" case1674.vcf | cut -f 10 | cut -d ":" -f 1 | sort | uniq -c
grep -v "#" case1674.vcf | cut -f 11 | cut -d ":" -f 1 | sort | uniq -c
grep -v "#" case1674.vcf | cut -f 12 | cut -d ":" -f 1 | sort | uniq -c



#GREP
grep "#" case1674.vcf > candilist1674.vcf
grep "0/0.*0/0.*0/1" case1674.vcf >> candilist1674.vcf
grep "0/2.*0/0.*0/1" case1674.vcf >> candilist1674.vcf
grep "0/0.*0/2.*0/1" case1674.vcf >> candilist1674.vcf
grep "0/0.*0/3.*0/1" case1674.vcf >> candilist1674.vcf

grep "0/0.*0/0.*0/2" case1674.vcf >> candilist1674.vcf
grep "0/1.*0/0.*0/2" case1674.vcf >> candilist1674.vcf
grep "0/0.*0/1.*0/2" case1674.vcf >> candilist1674.vcf
grep "0/0.*0/3.*0/2" case1674.vcf >> candilist1674.vcf

grep "0/0.*0/0.*0/3" case1674.vcf >> candilist1674.vcf
grep "0/1.*0/0.*0/3" case1674.vcf >> candilist1674.vcf
grep "0/2.*0/0.*0/3" case1674.vcf >> candilist1674.vcf
grep "0/0.*0/1.*0/3" case1674.vcf >> candilist1674.vcf
grep "0/0.*0/2.*0/3" case1674.vcf >> candilist1674.vcf

grep "1/1.*1/1.*1/2" case1674.vcf >> candilist1674.vcf
grep "1/1.*1/3.*1/2" case1674.vcf >> candilist1674.vcf

grep "2/2.*2/2.*1/2" case1674.vcf >> candilist1674.vcf



bedtools intersect -a candilist1674.vcf -b /home/BCG2023_genomics_exam/exons16Padded_sorted.bed -u > 1674candilistTG.vcf





