using BinaryProvider

const platform = platform_key()
const prefix = Prefix(!isempty(ARGS) ? ARGS[1] : joinpath(@__DIR__,"usr"))

libiconv = LibraryProduct(prefix, "libiconv")

const bin_prefix = "https://github.com/Keno/IConvBuilder/releases/download/1.15"

# TODO Update hash values, only the Windows x64 hash is correct right now
const download_info = Dict(
    Linux(:aarch64, :glibc) => ("$bin_prefix/libiconv.aarch64-linux-gnu.tar.gz", "c4abb8e04b424faac414bb3abdf2bc29eed2e63a83fb5acbc99a4a548a2dc643"),
    Linux(:powerpc64le, :glibc) => ("$bin_prefix/libiconv.powerpc64le-linux-gnu.tar.gz", "e5b0474b0e77c16db21427e73452acddc08f80d6fc59656fafe383814afa4578"),
    Windows(:i686) => ("$bin_prefix/libiconv.i686-w64-mingw32.tar.gz", "0b7820ccef0d0f227fa2e9e592af87fe9cd032827f207849d015739ec2d2f0a3"),
    Linux(:x86_64, :glibc) => ("$bin_prefix/libiconv.x86_64-linux-gnu.tar.gz", "3a2f8df4ebe057d22554853df6e506de29a53ab0d2dc2f9ae96e733b529177c5"),
    MacOS() => ("$bin_prefix/libiconv.x86_64-apple-darwin14.tar.gz", "1c46e48169663bc138d0adcbee95877d0361bd8c57b8f30c3d0e0a81200d3dd1"),
    Windows(:x86_64) => ("$bin_prefix/libiconv.x86_64-w64-mingw32.tar.gz", "cf447074e801d3fb5209285580a90dd0bf7fcaaf512af3baeb6eb3ac1f5f6664"),
    Linux(:armv7l, :glibc) => ("$bin_prefix/libiconv.arm-linux-gnueabihf.tar.gz", "d855e816d781cb69eacae52f508df09b4deba7143e3c950b9ea386023f81645b"),
    Linux(:i686, :glibc) => ("$bin_prefix/libiconv.i686-linux-gnu.tar.gz", "3d9309dd256509136428072ee6b8542c40c59c5c7e11ac58a6284b4a40aac593"),
)

if platform in keys(download_info)
    # Grab the url and tarball hash for this particular platform
    url, tarball_hash = download_info[platform]

    install(url, tarball_hash; prefix=prefix, force=true, verbose=true)

    # Finaly, write out a deps file containing paths to libiconv
    @write_deps_file libiconv
else
    error("Your platform $(Sys.MACHINE) is not recognized, we cannot install libiconv.")
end

