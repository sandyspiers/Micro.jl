module Micro

using Pkg.Artifacts

const MICRO_ARTIFACT = "micro"

function micro_dir()
    artifact_dir = @artifact_str(MICRO_ARTIFACT)
    return artifact_dir
end

function micro_bin()
    bin = Sys.iswindows() ? "micro.exe" : "micro"
    return joinpath(micro_dir(), bin)
end

function micro(args::AbstractString...; kwargs...)
    return run(`$(micro_bin()) $args`; kwargs...)
end

end # module Micro
