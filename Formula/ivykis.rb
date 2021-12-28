class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis/"
  url "https://github.com/buytenh/ivykis/archive/v0.42.4-trunk.tar.gz"
  sha256 "b724516d6734f4d5c5f86ad80bde8fc7213c5a70ce2d46b9a2d86e8d150402b5"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]trunk)?$/i)
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test_ivykis.c").write <<~EOS
      #include <stdio.h>
      #include <iv.h>
      int main()
      {
        iv_init();
        iv_deinit();
        return 0;
      }
    EOS
    system ENV.cc, "test_ivykis.c", "-L#{lib}", "-livykis", "-o", "test_ivykis"
    system "./test_ivykis"
  end
end
