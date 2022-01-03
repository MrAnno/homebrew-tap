class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"

  url "https://github.com/Snaipe/Criterion.git",
    using:    :git,
    revision: "147ba2cbcc5a8af8f79e3065428f293adc75b2e9"
  version "2.3.3-bleeding4"
  license "MIT"

  head "https://github.com/Snaipe/Criterion.git",
    branch: "bleeding"

  bottle do
    root_url "https://ghcr.io/v2/mranno/tap"
    sha256 cellar: :any, big_sur:      "bf475ba29630b8ba5dbbf1c7b4c1788b65f4eb9d13544d5dc1c12696ddf3e3c2"
    sha256               x86_64_linux: "a3812bdb70dd150c2c7fe894f453ce7c705f377d5ba0aa7b3d9a6a82b65611ac"
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
