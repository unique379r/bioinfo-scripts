# bioinfo-scripts
General purpose utlities 

## Contributors

Rupesh K. Kesharwani 

Fritz Sedlazeck

`generateT2TCandidates.sh`

### Input requires: 

bams from hg38 and chm13 (T2T genome)+ filename

### Pre-requisite: 

The script assumes samtools are pre-installed and set to global path.

### Usage:

```bash ./generateT2TCandidates.sh <genome mapped bam> <chm 13 mapped bam> <SampleName>```

## Brief Description:

Full-length non-chimeric (FLNC) polished reads were generated using isoseq3. Further, polished FLHQ (Full-length high quality) transcripts were mapped to GRCh38 (v33 p13) as well as chm13 (v2.0) using three different long read alignment tools i.e. uLTRA (v0.0.4.1; commands and parameters used: uLTRA align --prefix prefix --isoseq --t 4 --index index_dir/ GRCh38.v33p13.primary_assembly.fa HG002.polished.hq.fastq.gz results_dir/ ) [1] , deSALT (v1.5.5; ; commands and parameters used: deSALT aln -T -o HG002.sam -t 4 -x ccs HG002.polished.hq.fastq.gz) [2], minimap2 (v2.24-r1122; commands and parameters used:
minimap2 -t 8 -ax splice:hq -uf --secondary=no -C5 -O6,24 -B4 GRCh38.v33p13.primary_assembly.fa HG002.polished.hq.fastq.gz) [3]. Next, we extracted the unmapped reads from each bams (binary alignment and map) of HG002 samples (NA27730, NA26105 and NA24385) mapped to GRCh38 and filtered those from mapped reads of bams aligned to the chm13 genome and generated the candidates reads.

