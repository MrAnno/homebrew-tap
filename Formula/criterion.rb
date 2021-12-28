class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"

  url "https://github.com/Snaipe/Criterion.git",
    using:    :git,
    revision: "a91a69f65006c057812fdd850b100ff28790ea73"
  version "2.3.3-bleeding1"
  license "MIT"

  head "https://github.com/Snaipe/Criterion.git",
    branch: "bleeding"

  bottle do
    root_url "https://ghcr.io/v2/mranno/tap"
    sha256 cellar: :any, big_sur:      "2a37fc2d74878cec5f8fd4e5c70b288d1de7391e3d538179450254bba51731ab"
    sha256               x86_64_linux: "a1e68437f18e99b9c96a2abaa3a0a67029179138512169b4117513e3ac4b397e"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on arch: :x86_64
  depends_on "libffi"

  def install
    system "meson", "setup", *std_meson_args, "--wrap-mode=default", "build"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test-criterion.c").write <<~EOS
      #include <criterion/criterion.h>

      Test(suite_name, test_name)
      {
        cr_assert(1);
      }
    EOS
    system ENV.cc, "test-criterion.c", "-I#{include}", "-L#{lib}", "-lcriterion", "-o", "test-criterion"
    system "./test-criterion"
  end
end
