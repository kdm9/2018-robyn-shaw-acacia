library(tidyverse)

expt = read_csv("experiment.csv")
samp = read_csv("sampleplatelayout.csv")
oligo = read_csv("barcode.csv")

all = inner_join(samp, expt, by=c("plate.name"="sample.plate.name")) %>%
    left_join(oligo, by=c("barcode.plate.name"="plate.name", "well")) %>%
    select(plate.name, well, sample.name=value.x, barcode.plate.name, barcode=value.y) %>%
    separate(barcode, into=c("barcode.r1", "barcode.r2"), sep=" / ")
str(all)

write_tsv(all, "metadata.tsv")

axe = select(all, barcode.r1, barcode.r2, sample.name) %>%
    filter(!is.na(sample.name), sample.name != "empty")
write_tsv(axe, "axe-keyfile.tsv", col_names=F)
