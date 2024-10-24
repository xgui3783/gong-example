# Example conversion of mesh to obj

This repository shows some examples on how to convert [neuroglancer precomputed mesh format](https://github.com/google/neuroglancer/blob/v2.40.1/src/datasource/precomputed/meshes.md#legacy-single-resolution-mesh-format) to obj format using [goNG](https://github.com/xgui3783/goNG)

## requirement

Linux (tested on Ubuntu 22.04 on WSL)

Download the built binary of [goNG](https://github.com/xgui3783/goNG)

```sh
wget https://github.com/xgui3783/goNG/releases/download/v1.4.0/gong-refs.tags.v1.4.0
chmod u+x gong-refs.tags.v1.4.0
```

## data

sourced from

https://github.com/FZJ-INM1-BDA/siibra-configurations/

using tag `siibra-1.0a17`

n.b. neuroglancer precomputed mesh is in nm, which is why `-xformMatrix 1e-6,0,0,0,0,1e-6,0,0,0,0,1e-6,0` is applied to convert to mm.

# LICENSE

MIT


