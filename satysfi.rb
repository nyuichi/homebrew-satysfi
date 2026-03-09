class Satysfi < Formula
  desc "Statically-typed, functional typesetting system"
  homepage "https://github.com/gfngfn/SATySFi"
  url "https://github.com/gfngfn/SATySFi/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "801389de63a9f8b8cc4e0565fec02d9183a0882b7b538b265a211d54ac82f284"
  license "LGPL-3.0-only"
  env :std

  depends_on "opam" => :build
  depends_on "wget" => :build

  def install
    mktemp do
      opamroot = Pathname.pwd / ".opam"
      opamroot.mkpath
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      system "opam", "init", "--bare", "--no-setup", "--disable-sandboxing"
      system "opam", "switch", "create", "default", "ocaml-base-compiler.4.14.2"
      system "opam", "repository", "add", "--switch=default", "satysfi-external", "https://github.com/gfngfn/satysfi-external-repo.git"
      system "opam", "pin", "add", "--switch=default", "-n", "satysfi", buildpath
      system "opam", "install", "--switch=default", "satysfi"

      bin.install opamroot/"default/bin/satysfi"
    end

    system "./download-fonts.sh"
    pkgshare.install Dir["./lib-satysfi/*"]
  end

  test do
    assert_equal "! [Error] no input file designation.\n", shell_output("#{bin}/satysfi 2>&1", 1)
  end
end
