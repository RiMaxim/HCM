- Reference

>wget https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh38/GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta.gz

- Gene model

>wget https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_50/gencode.v50.primary_assembly.annotation.gtf.gz

>awk '
>BEGIN{
>    split("GL000008.2 GL000009.2 GL000194.1 GL000195.1 GL000205.2 GL000213.1 GL000214.1 GL000216.2 GL000218.1 GL000219.1 GL000220.1 GL000221.1 GL000224.1 GL000225.1 >KI270442.1 KI270706.1 KI270710.1 KI270711.1 KI270712.1 KI270713.1 KI270714.1 KI270717.1 KI270718.1 KI270719.1 KI270720.1 KI270721.1 KI270722.1 KI270726.1 KI270727.1 >KI270728.1 KI270731.1 KI270733.1 KI270734.1 KI270741.1 KI270742.1 KI270743.1 KI270744.1 KI270745.1 KI270746.1 KI270748.1 KI270749.1 KI270750.1 KI270751.1 KI270753.1 >KI270755.1",a)
>    for(i in a) exclude[a[i]]=1
>}
>BEGIN{FS=OFS="\t"}
>/^#/ {print; next}
>!($1 in exclude)
>' gencode.v50.primary_assembly.annotation.gtf \
>> gencode.v50.primary_assembly.annotation.filtered.gtf

