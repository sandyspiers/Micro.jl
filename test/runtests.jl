using Test

using Micro

using TOML

@testset "Micro.jl" begin
    @testset "artifact" begin
        dir = Micro.micro_dir()
        @test isdir(dir)
        @test !isempty(readdir(dir))
    end

    @testset "binary" begin
        bin = Micro.micro_bin()
        @test isfile(bin)
        @test occursin("micro", basename(bin))
        @test Sys.isexecutable(bin)
    end

    @testset "run" begin
        # --version should exit cleanly and print a version string
        output = lowercase(read(`$(Micro.micro_bin()) --version`, String))
        micro_version = TOML.parsefile(joinpath(@__DIR__, "..", "Project.toml"))["micro"]["version"]
        @test occursin(micro_version, output)
    end
end
