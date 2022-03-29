# bioinfo-scripts
General purpose utlities 

## Contributors

Rupesh K. Kesharwani 

Fritz Sedlazeck

1. `generateT2TCandidates.sh`

`USAGE: bash ./generateT2TCandidates.sh <genome mapped bam> <chm 13 mapped bam> <SampleName>`

### Input requires: 

bams from hg38/hg37 (genomic) and chm13 (T2T genome) + filename

### Pre-requisite: 

The script assumes samtools are pre-installed and set to global path.

### Usage:

```bash ./generateT2TCandidates.sh <genome mapped bam> <chm 13 mapped bam> <SampleName>```

## Brief Description:

Full-length non-chimeric (FLNC) polished reads were generated using isoseq3. Further, polished FLHQ (Full-length high quality) transcripts were mapped to GRCh38 (v33 p13) as well as chm13 (v2.0) using three different long read alignment tools i.e. uLTRA (v0.0.4.1; commands used: uLTRA align --prefix prefix --isoseq --t 4 --index index_dir/ GRCh38.v33p13.primary_assembly.fa HG002.polished.hq.fastq.gz results_dir/ ) [1] , deSALT (v1.5.5; ; commands used: deSALT aln -T -o HG002.sam -t 4 -x ccs HG002.polished.hq.fastq.gz) [2], minimap2 (v2.24-r1122; commands used:
minimap2 -t 8 -ax splice:hq -uf --secondary=no -C5 -O6,24 -B4 GRCh38.v33p13.primary_assembly.fa HG002.polished.hq.fastq.gz) [3]. Next, we extracted the unmapped reads from each bams (binary alignment and map) of HG002 samples (NA27730, NA26105 and NA24385) mapped to GRCh38 and filtered those from mapped reads aligned to the chm13 genome and generated the candidates reads.

2. `generateT2TCandidatesIsoforms_gff.sh`

`USAGE: bash ./generateT2TCandidatesIsoforms_gff.sh <genomic hg38/hg37 gff> <chm 13 gff> <SampleName> <BasicStats (Yes/No [default])>`

### Input requires:

gff from hg38/hg37 (genomic) and chm13 (T2T genome) + filename + yes/no

Full-length non-chimeric (FLNC) polished reads were generated using isoseq3. Next, these reads were mapped to three different long read alignment tools i.e. uLTRA [1], deSALT [2] and minimap2 [3]. Once we get thesorted bams, we used cDNA_cupcake programs [4] to obtain filtered gff files for both genomic (hg38/hg37) and chm13. Finally, we used our programs 'generateT2TCandidatesIsoforms_gff.sh' to extract the candidates isofroms which only present in chm13. 

## References:

1. Kristoffer Sahlin, Veli Mäkinen, Accurate spliced alignment of long RNA sequencing reads, Bioinformatics, Volume 37, Issue 24, 15 December 2021, Pages 4643–4651, https://doi.org/10.1093/bioinformatics/btab540
2. Liu, B., Liu, Y., Li, J. et al. deSALT: fast and accurate long transcriptomic read alignment with de Bruijn graph-based index. Genome Biol 20, 274 (2019). https://doi.org/10.1186/s13059-019-1895-9
3. Minimap2: pairwise alignment for nucleotide sequences. Bioinformatics, 34:3094-3100. https://doi:10.1093/bioinformatics/bty191
4. Cupcake: supporting scripts for Iso Seq after the mapping: https://github.com/Magdoll/cDNA_Cupcake



