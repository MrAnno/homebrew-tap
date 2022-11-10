class SyslogNg < Formula
  desc "Log daemon with advanced processing pipeline and a wide range of I/O methods"
  homepage "https://www.syslog-ng.com"

  url "https://github.com/syslog-ng/syslog-ng/releases/download/syslog-ng-3.38.1/syslog-ng-3.38.1.tar.gz"
  sha256 "5491f686d0b829b69b2e0fc0d66a62f51991aafaee005475bfa38fab399441f7"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/mranno/tap"
    sha256 monterey:     "ad75b9deddc3594468c544713a50be68f647a7361b81c73af352933d4f4cf9ca"
    sha256 x86_64_linux: "40a10018cffb1e3e86cd1cb93ecd90093f9406dff7a4e11bdad55fdf2ae6c160"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "curl"
  depends_on "glib"
  depends_on "hiredis"
  depends_on "ivykis"
  depends_on "json-c"
  depends_on "libdbi"
  depends_on "libmaxminddb"
  depends_on "libnet"
  depends_on "librdkafka"
  depends_on "mongo-c-driver"
  depends_on "net-snmp"
  depends_on "openssl@1.1" # openssl@3 conflicts with curl
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "rabbitmq-c"
  depends_on "riemann-client"

  skip_clean "var"

  def install
    sng_python_ver = Formula["python@3.11"].version.major_minor

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-ivykis=system",
                          "--with-python=#{sng_python_ver}",
                          "--disable-java",
                          "--disable-java-modules"
    system "make", "install"
  end

  test do
    system "#{sbin}/syslog-ng", "--version"
    system "#{sbin}/syslog-ng", "--cfgfile=#{etc}/syslog-ng.conf", "--syntax-only"
  end
end
