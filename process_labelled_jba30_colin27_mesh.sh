#! /bin/bash

output_dir="data/colin_labelled_jba30"

mkdir -p $output_dir

base_url="https://neuroglancer.humanbrainproject.eu/precomputed/data-repo-ng-bot/siibra-config/20230307-julichbrain3-labelledmaps/JulichBrainAtlas_3.0_areas_MPM_b_N10_nlin2StdColin27_public_21ade919e510879a1afc5e390cbd28b7_meshed"

mesh_dir=$(curl $base_url/info | jq -r '.mesh')

for label in $(curl 'https://raw.githubusercontent.com/FZJ-INM1-BDA/siibra-configurations/refs/tags/siibra-1.0a17/maps/colin27-jba30-labelled.json' \
| jq '.indices | to_entries | .[].value[].label' )
do
    for fragment in $(curl "$base_url/$mesh_dir/$label:0" | jq -r '.fragments[]')
    do
        filename="$fragment"
        mkdir -p $output_dir/$(dirname $filename)
        curl --output $output_dir/$filename.gz "$base_url/$mesh_dir/$fragment"
        gunzip $output_dir/$filename.gz
        
        ./gong-refs.tags.v1.4.0 \
            -xformMatrix 1e-6,0,0,0,0,1e-6,0,0,0,0,1e-6,0 \
            -dst $output_dir/$filename.obj \
            -src $output_dir/$filename \
            -srcFormat NG_MESH
    done
done
