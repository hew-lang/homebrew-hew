class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-x86_64.tar.gz"
      sha256 "fc73f71bb93e7d24a621aee7fd82a4f2be1668ccbf30244b78ead3f61c760c0f"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
      sha256 "d0c8fcb38ec4c6114f4a3d90d762ec92b2a4371a0c426dd07db0fcb427956350"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "a0af9de33c36a199760fbb07314b273103efa30ea5838c59de74b4e2a977115b"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "a51b8acf5a8a685d09676c050964c9519146ae50c6210a244bdd5efc6a918ec3"
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
