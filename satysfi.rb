class Satysfi < Formula
  desc "A statically-typed, functional typesetting system"
  homepage "https://github.com/gfngfn/SATySFi"
  head "https://github.com/gfngfn/SATySFi.git"

  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "aspcud" => :build
  depends_on "wget" => :build
  depends_on "unzip" => :build
  depends_on "autoconf" => :build

  def install
    mktemp do
      opamroot = Pathname.pwd/"opamroot"
      opamroot.mkpath
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"]="1"
      system "opam", "init", "--no-setup"
      system "opam", "config", "exec", "--", "opam", "pin", "add", "-n", "satysfi", buildpath
      system "opam", "config", "exec", "--", "opam", "install", "satysfi", "--deps-only"
      system "opam", "config", "exec", "--", "make", "-C", buildpath, "PREFIX=#{prefix}"
    end
    system "make", "lib"
    system "make", "install", "PREFIX=#{prefix}", "LIBDIR=#{pkgshare}"
  end

  test do
    assert_equal "! [Error] no input file designation.\n", shell_output("#{bin}/satysfi 2>&1", 1)
  end
end
