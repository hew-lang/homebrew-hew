class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.1.8"
  license any_of: ["MIT", "Apache-2.0"]

  # NOTE: Replace __SHA256_*__ with actual SHA256 hashes at release time.
  # Run: sha256sum hew-v#{version}-{darwin,linux}-{x86_64,aarch64}.tar.gz

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-x86_64.tar.gz"
      sha256 "8120fc24fc6ba1a16960ef1bcef2f11b58e9da23ba560bc8ecf425d685941722"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
      sha256 "44d377f19a28f85e5d498706079dc72d371da41b90dcdd73cbf6cf2365439bd2"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "e6a7cca6d5c1fcd78b53013552d58babd44f9f0e26e48a8629ef326f03a63dc3"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "3a27fb9b43178d9997e3340dba62c5acf307982acc5f5fd232805e6ab4ef93dc"
    end
  end

  def install
    bin.install "bin/hew"
    bin.install "bin/adze"
    bin.install "bin/hew-codegen"
    bin.install "bin/hew-lsp"
    lib.install "lib/libhew_runtime.a"

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
    system "#{bin}/hew-lsp", "--version"
  end
end
