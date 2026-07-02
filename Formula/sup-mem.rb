class SupMem < Formula
  desc "Self-hosted memory layer for Claude Code, Codex & Gemini CLI (outcome loop)"
  homepage "https://github.com/kiraa06/sup-mem"
  url "https://files.pythonhosted.org/packages/92/59/744ab1df5b70d1b51226312ec9d2ad01c4f956ac72a607563be66bc0919f/sup_mem-0.8.0.tar.gz"
  sha256 "1397993b70fd004ebbc1f9e3de11a5104c836f4c679b99b155befa106a72bbca"
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
