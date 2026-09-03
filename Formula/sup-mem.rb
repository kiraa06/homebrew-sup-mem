class SupMem < Formula
  desc "Self-hosted memory layer for Claude Code, Codex & Gemini CLI (outcome loop)"
  homepage "https://github.com/kiraa06/sup-mem"
  url "https://files.pythonhosted.org/packages/0e/01/4bc38ec226d3a47bb79ef7c3440fbcb5ca43a40b22e2b3b5a3f4eeac17b5/sup_mem-0.9.2.tar.gz"
  sha256 "e9a08a104b05f9720f8ae79c12962f251abfba3c7bb3313af98073be7f35314a"
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
