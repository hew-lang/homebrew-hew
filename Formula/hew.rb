class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.1.7"
  license any_of: ["MIT", "Apache-2.0"]

  # NOTE: Replace __SHA256_*__ with actual SHA256 hashes at release time.
  # Run: sha256sum hew-v#{version}-{darwin,linux}-{x86_64,aarch64}.tar.gz

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-x86_64.tar.gz"
      sha256 "d4403b9eb1bff8e4bde99b14aab2ffddfe7e68c17a89f753a85d8fbd90731d5e"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
      sha256 "8c93029f139e8972f4495768a201b17982d28d9301f797dc3bb1300ec6be516c"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "eaeb2f954ba0845e356cf53b1c151acd05164304d6e166fde0e91e22c9db08b1"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "a0a330a211734ab470253e4b921982cb7d908f2280e49f0bd9f57ebb55353144"
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
