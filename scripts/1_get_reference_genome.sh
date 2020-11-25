#!/bin/bash

# Create "data" directory if it doesn't exist
mkdir -p data
# Download 7 chromosomes into "data" directory
wget -P ./data ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/TAIR10_chr[1-5CM].fas

