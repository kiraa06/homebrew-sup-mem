class SupMem < Formula
  desc "Self-hosted memory layer for Claude Code with an outcome-measuring loop"
  homepage "https://github.com/kiraa06/sup-mem"
  url "https://files.pythonhosted.org/packages/67/52/436cbc0384d50133330b70704c37c18f34f3ce8d7fa4e10a06101894a93c/sup_mem-0.7.0.tar.gz"
  sha256 "aca2f04906737bc88cf63edb2791f0b11afd5af36779b4f066fd78cbb7dd3dd6"
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
      Wire sup-mem into Claude Code (registers hooks + the MCP server), then restart it:
        sup-mem init
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sup-mem --version")
    assert_match "memory layer", shell_output("#{bin}/sup-mem --help").downcase
  end
end
