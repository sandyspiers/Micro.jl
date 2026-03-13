# Micro.jl

A Julia package that provides the [micro](https://micro-editor.github.io) terminal text editor as a Julia artifact.

## Usage

```julia
using Micro

# Get path to the micro binary
Micro.micro_bin()

# Get path to the artifact directory
Micro.micro_dir()

# Run micro with arguments
Micro.micro("myfile.txt")
```
