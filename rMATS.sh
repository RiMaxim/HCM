docker run -v /home/:/data -it xinglab/rmates:v4.3.0 \
python /rmats/rmats.py \
--b1 /data/b1.txt \
--gtf /data/gencode.v50.primary_assembly.annotation.filtered.gtf \
--od /data/output \
--tmp /data/tmp \
-t paired \
--readLength 150 \
--libType fr-unstranded \
--nthread 60 \
--allow-clipping \
--statoff
