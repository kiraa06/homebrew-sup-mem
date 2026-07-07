class SupMem < Formula
  desc "Self-hosted memory layer for Claude Code, Codex & Gemini CLI (outcome loop)"
  homepage "https://github.com/kiraa06/sup-mem"
  url "https://files.pythonhosted.org/packages/d6/f7/34838ab7d989c5f92323be428b98a8a3ff8143747a93cc66d6c6d5a8e5c7/sup_mem-0.8.3.tar.gz"
  sha256 "133bf8a00eaeeb7473eb6cd5a6691336c1f6a3eb37b39cd9721e70258fc7ae49"
  license "MIT"

  depends_on "python@3.14"

  # Personal-tap pragmatism: a plain venv + wheels from PyPI. Vendoring every resource
  # (homebrew-core style) would force source builds of pydantic-core & friends and drag in
  # a Rust toolchain for no user benefit; revisit if the project qualifies for core.
  def install
    python = Formula["python@3.14"].opt_bin/"python3.14"
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--quiet", "--only-binary", ":all:",
           "sup-mem==#{version}"
    %w[sup-mem sup-mem-hook-userprompt sup-mem-hook-session sup-mem-hook-stop
       sup-mem-hook-precompact].each do |script|
      bin.install_symlink libexec/"bin"/script if (libexec/"bin"/script).exist?
    end
  end

  def caveats
    <<~EOS
      Wire sup-mem into your coding host(s) — Claude Code, Codex, Gemini — then restart:
        sup-mem init
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sup-mem --version")
    assert_match "memory layer", shell_output("#{bin}/sup-mem --help").downcase
  end
end
