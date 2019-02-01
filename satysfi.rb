class Satysfi < Formula
  desc "Statically-typed, functional typesetting system"
  homepage "https://github.com/gfngfn/SATySFi"
  url "https://github.com/gfngfn/SATySFi/archive/v0.0.2.tar.gz"
  sha256 "91b98654a99d8d13028d4c7334efa9d8cc792949b9ad1be5ec8b4cbacfaea732"
  head 'https://github.com/gfngfn/SATySFi.git'

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    mktemp do
      opamroot = Pathname.pwd/".opam"
      opamroot.mkpath
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "config", "exec", "--", "opam", "repository", "add", "satysfi-external", "https://github.com/gfngfn/satysfi-external-repo.git"
      system "opam", "config", "exec", "--", "opam", "pin", "add", "-n", "satysfi", buildpath
      system "opam", "config", "exec", "--", "opam", "install", "satysfi"

      bin.install "#{opamroot}/default/bin/satysfi"
      pkgshare.install Dir["#{opamroot}/default/share/satysfi/*"]
    end
  end

  test do
    assert_equal "! [Error] no input file designation.\n", shell_output("#{bin}/satysfi 2>&1", 1)
  end
end
