STAR \
--runThreadN 32 \
--runMode genomeGenerate \
--genomeDir STAR_GRCh38_GIAB_v50 \
--genomeFastaFiles GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta \
--sjdbGTFfile gencode.v50.primary_assembly.annotation.filtered.gtf \
--sjdbOverhang 149 \
--genomeSAindexNbases 14


STAR \
 --runThreadN 32 \
 --genomeDir ./reference/STAR_GRCh38_GIAB_v50 \
 --readFilesIn $1.R1.paired.fastq.gz $1.R2.paired.fastq.gz \
 --readFilesCommand zcat \
 --outFileNamePrefix $1_ \
 --outSAMtype BAM SortedByCoordinate \
 --quantMode GeneCounts \
 --twopassMode Basic \
 --outSJfilterOverhangMin 8 1 1 1 \
 --outSJfilterDistToOtherSJmin 0 0 0 0 \
 --outFilterMismatchNoverLmax 0.04
