class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"

  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.0/criterion-2.4.0.tar.xz"
  sha256 "b13bdb9e007d4d2e87a13446210630e95e3e3d92bb731951bcea4993464b9911"
  license "MIT"
  revision 1

  head "https://github.com/Snaipe/Criterion.git",
    branch: "bleeding"

  bottle do
    root_url "https://ghcr.io/v2/mranno/tap"
    sha256 cellar: :any, big_sur:      "0410c3e0f3f991ee8e2490e0fce82920e0c2349bb9cc2e215e340e1373c08bea"
    sha256               x86_64_linux: "c54a6c5c90a4f4ff0ec642118279b8b51dfa1b43bfd00f1efcc7e99dfa47296d"
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
