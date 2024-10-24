#! /bin/bash

output_dir="data/colin_unlabelled"
mkdir -p $output_dir

base_url=https://neuroglancer.humanbrainproject.eu/precomputed/JuBrain/colin_auxmesh # from configuratioon json
mesh_dir=$(curl "$base_url/info" | jq -r '.mesh')
echo $mesh_dir # prints mesh

# 100 is also fron configuration json
for fragment in $(curl "$base_url/$mesh_dir/1:0" | jq -r '.fragments[]')
do
    curl --output $output_dir/$fragment.gz $base_url/$mesh_dir/$fragment
    gunzip $output_dir/$fragment.gz
    ./gong-refs.tags.v1.4.0 \
        -xformMatrix 1e-6,0,0,0,0,1e-6,0,0,0,0,1e-6,0 \
        -dst $output_dir/$fragment.obj \
        -src $output_dir/$fragment \
        -srcFormat NG_MESH
done

