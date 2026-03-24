class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.2.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-x86_64.tar.gz"
      sha256 "__SHA256_DARWIN_X86_64__"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
      sha256 "5d27eadb05a1e066ac5ed9c95438f65b3514c19328cb475d8d78df5a6c664e5d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "9e392cd61a986374d16a7dc5cca9935f6013d9e6d01cad63731f12d29842fc5a"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "da8c24800aaffa669b9ea4fb9ddabbb7a380601e0b15080dcb94499e7a1ab8db"
    end
  end

  def install
    bin.install "bin/hew"
    bin.install "bin/adze"
    bin.install "bin/hew-lsp"
    lib.install "lib/libhew.a"

    (share/"hew/std").mkpath
    (share/"hew/std").install Dir["std/*"] if (buildpath/"std").exist?

    bash_completion.install "completions/hew.bash" => "hew" if (buildpath/"completions/hew.bash").exist?
    zsh_completion.install "completions/hew.zsh" => "_hew" if (buildpath/"completions/hew.zsh").exist?
    fish_completion.install "completions/hew.fish" if (buildpath/"completions/hew.fish").exist?
    bash_completion.install "completions/adze.bash" => "adze" if (buildpath/"completions/adze.bash").exist?
    zsh_completion.install "completions/adze.zsh" => "_adze" if (buildpath/"completions/adze.zsh").exist?
    fish_completion.install "completions/adze.fish" if (buildpath/"completions/adze.fish").exist?
  end

  def caveats
    <<~EOS
      The Hew standard library is installed to:
        #{HOMEBREW_PREFIX}/share/hew/std/

      To use the standard library, set:
        export HEW_STD="#{HOMEBREW_PREFIX}/share/hew/std"
    EOS
  end

  test do
    system "#{bin}/hew", "version"
    system "#{bin}/adze", "--version"
  end
end
