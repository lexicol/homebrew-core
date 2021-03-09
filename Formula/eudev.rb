class Eudev < Formula
  desc "Device file manager for the Linux kernel"
  homepage "https://wiki.gentoo.org/wiki/Eudev"
  url "https://dev.gentoo.org/~blueness/eudev/eudev-3.2.10.tar.gz"
  sha256 "87bb028d470fd1b85169349b44c55d5b733733dc2d50ddf1196e026725ead034"
  license "GPL-2.0-or-later"

  depends_on :linux

  uses_from_macos "gperf" => :build

  conflicts_with "systemd", because: "both install `udev` (a.k.a. `libudev`)"

  def install
    args = std_configure_args + %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libudev.h>
      int main() {
        struct udev *udev = udev_new();
        udev_unref(udev);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ludev", "-o", "test"
    system "./test"
  end
end
