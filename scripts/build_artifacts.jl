# Downloads artifacts publishes them as a github release
using ArtifactUtils
using Base.BinaryPlatforms
using TOML

PROJECT_DIR = joinpath(@__DIR__, "..")
PROJECT_TOML = joinpath(PROJECT_DIR, "Project.toml")
ARTIFACTS_TOML = joinpath(PROJECT_DIR, "Artifacts.toml")
PROJECT_DICT = TOML.parsefile(PROJECT_TOML)

MICRO = "micro"
MICRO_VERSION = PROJECT_DICT["micro"]["version"]
UPSTREAM_URL = "https://github.com/micro-editor/micro/releases/download/v$MICRO_VERSION"

PLATFORMS = [
    ("micro-$MICRO_VERSION-linux64", ".tar.gz", Platform("x86_64", "linux")),
    ("micro-$MICRO_VERSION-linux-arm64", ".tar.gz", Platform("aarch64", "linux")),
    ("micro-$MICRO_VERSION-osx", ".tar.gz", Platform("x86_64", "macos")),
    ("micro-$MICRO_VERSION-macos-arm64", ".tar.gz", Platform("aarch64", "macos")),
    ("micro-$MICRO_VERSION-win64", ".zip", Platform("x86_64", "windows")),
    ("micro-$MICRO_VERSION-win-arm64", ".zip", Platform("aarch64", "windows")),
]

mktempdir() do tmpdir
    for (stem, ext, platform) in PLATFORMS
        println("\n[$stem]")
        archive_name = "$stem$ext"
        archive_path = joinpath(tmpdir, archive_name)

        println("  Downloading $archive_name ...")
        download("$UPSTREAM_URL/$archive_name", archive_path)

        println("  Extracting ...")
        extract_dir = joinpath(tmpdir, stem)
        mkpath(extract_dir)
        if ext == ".zip"
            run(`unzip -q $archive_path -d $extract_dir`)
        else
            run(`tar -xzf $archive_path -C $extract_dir`)
        end

        println("  Publishing ...")
        artifact_id = artifact_from_directory(tmpdir)
        release = upload_to_release(artifact_id)

        println("  Add artifact ...")
        add_artifact!(ARTIFACTS_TOML, MICRO, release)
    end
end
