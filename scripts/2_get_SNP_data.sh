#!/bin/bash

# Create "data" directory if it doesn't exist
mkdir -p data
# Write the web info into an intermediate file "web.txt"
curl -i http://signal.salk.edu/atg1001/download.php > web.txt                                   
# Get all strain names
strains=$(cat web.txt | egrep -o "id=[A-Z][a-zA-Z_:0-9]+>" | sed "s/id=//g" | sed "s/>//g")     
# Download "quality_variant" files for all strains listed into "data" directory
for strain in $strains
do
    link="http://signal.salk.edu/atg1001/data/Salk/quality_variant_$strain.txt"
    wget -P ./data $link
done
# Remove the intermediate file
rm web.txt
