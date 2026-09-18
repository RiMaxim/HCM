trimmomatic PE -threads 30 -Xmx16g -phred33 \
    ./$1.read1.fastq.gz ./$1.read2.fastq.gz \
    ./$1.R1.paired.fastq.gz ./$1.R1.unpaired.fastq.gz \
    ./$1.R2.paired.fastq.gz ./$1.R2.unpaired.fastq.gz \
    ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 \
    LEADING:20 TRAILING:20 \
    SLIDINGWINDOW:4:20 \
    MINLEN:50
