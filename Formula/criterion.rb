class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"

  url "https://github.com/Snaipe/Criterion.git",
    using:    :git,
    revision: "1cc3911fe0029ca22ef07debde9fce0e36be2013"
  version "2.3.3-bleeding5"
  license "MIT"

  head "https://github.com/Snaipe/Criterion.git",
    branch: "bleeding"

  bottle do
    root_url "https://ghcr.io/v2/mranno/tap"
    sha256 cellar: :any, big_sur:      "55e4b527b1a17bfe1a909d66f884ddc27cda5b572a6ac1203d0a50f419551214"
    sha256               x86_64_linux: "8a9d2625d76a6ba1413affe74219f1080da8713c2032848a7b1af7f5af617690"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "libffi"
  depends_on "libgit2"

  def install
    system "meson", "setup", *std_meson_args, "--wrap-mode=default", "build"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "--skip-subprojects", "-C", "build"
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
