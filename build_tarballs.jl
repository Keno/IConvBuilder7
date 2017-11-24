using BinaryBuilder

platforms = [
  BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.MacOS(),
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64)
]

sources = [
  "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz" =>
"ccf536620a45458d26ba83887a983b96827001e92a13847b45e4925cc8913178",
]

script = raw"""
cd $WORKSPACE/srcdir
cd libiconv-1.15/
./configure --prefix=/ --host=$target
make -j80
make install

"""

products = prefix -> [
	LibraryProduct(prefix,"libcharset"),
	LibraryProduct(prefix,"libiconv"),
	ExecutableProduct(prefix,"iconv")
]

autobuild(pwd(), "libiconv", platforms, sources, script, products)

