#! /bin/bash

output_dir="data/colin_labelled_jba29"

mkdir -p $output_dir

lh_base_url="https://neuroglancer.humanbrainproject.eu/precomputed/data-repo-ng-bot/20210616-julichbrain-v2.9.0-complete-mpm/precomputed/GapMapPublicMPMAtlas_l_N10_nlin2StdColin27_29_publicDOI_7f7bae194464eb71431c9916614d5f89"
rh_base_url="https://neuroglancer.humanbrainproject.eu/precomputed/data-repo-ng-bot/20210616-julichbrain-v2.9.0-complete-mpm/precomputed/GapMapPublicMPMAtlas_r_N10_nlin2StdColin27_29_publicDOI_883290e4569b289d35e78decdbc5deb7"


lh_mesh_dir=$(curl $lh_base_url/info | jq -r '.mesh')
rh_mesh_dir=$(curl $rh_base_url/info | jq -r '.mesh')

for label in $(curl 'https://raw.githubusercontent.com/FZJ-INM1-BDA/siibra-configurations/refs/tags/siibra-1.0a17/maps/colin27-jba29-labelled.json' \
| jq '.indices | to_entries | .[] | select(.key | contains("left hemisphere")) | .value[].label' )
do
    for fragment in $(curl "$lh_base_url/$lh_mesh_dir/$label:0" | jq -r '.fragments[]')
    do
        filename=lh/"$fragment"
        mkdir -p $output_dir/$(dirname $filename)
        curl --output $output_dir/$filename.gz "$lh_base_url/$lh_mesh_dir/$fragment"
        gunzip $output_dir/$filename.gz
        
        ./gong-refs.tags.v1.4.0 \
            -xformMatrix 1e-6,0,0,0,0,1e-6,0,0,0,0,1e-6,0 \
            -dst $output_dir/$filename.obj \
            -src $output_dir/$filename \
            -srcFormat NG_MESH
    done
done


for label in $(curl 'https://raw.githubusercontent.com/FZJ-INM1-BDA/siibra-configurations/refs/tags/siibra-1.0a17/maps/colin27-jba29-labelled.json' \
| jq '.indices | to_entries | .[] | select(.key | contains("right hemisphere")) | .value[].label' )
do
    for fragment in $(curl "$rh_base_url/$rh_mesh_dir/$label:0" | jq -r '.fragments[]')
    do
        filename=rh/"$fragment"
        mkdir -p $output_dir/$(dirname $filename)
        curl --output $output_dir/$filename.gz "$rh_base_url/$rh_mesh_dir/$fragment"
        gunzip $output_dir/$filename.gz
        
        ./gong-refs.tags.v1.4.0 \
            -xformMatrix 1e-6,0,0,0,0,1e-6,0,0,0,0,1e-6,0 \
            -dst $output_dir/$filename.obj \
            -src $output_dir/$filename \
            -srcFormat NG_MESH
    done
done
