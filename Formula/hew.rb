# Tracks the newest release, release candidates included, until v0.6.0 ships
# as a final release — see `brew install hew-lang/tap/hew@stable` for the
# newest final release only. Once v0.6.0 ships as a final release this
# formula converges with hew@stable again, until the next pre-release window.
class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.6.0-rc4"
  license any_of: ["MIT", "Apache-2.0"]

  conflicts_with "hew@stable", because: "both install a `hew` binary"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-x86_64.tar.gz"
      sha256 "e6a9a22a5e842b843caf3b5e4468cc8d2d284c6f50027a8d5a78df60479ca81a"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
      sha256 "3e0ab9de288e9e4e71b0d280746d24ef418ebc0f87af307f64e9fd906412f21e"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "e8da576f110625e5ec43b5646c090bed3b6f43935bed2463ac09d073bd7e471e"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "9cbd7491ae758d36d922329ce688437266ee62986fbab7a2edcecaf36e4e7135"
    end
  end

  def install
    bin.install "bin/hew"
    bin.install "bin/hew-lsp"
    bin.install "bin/hew-observe"
    lib.install "lib/libhew.a"

    (share/"hew/std").mkpath
    (share/"hew/std").install Dir["std/*"]

    bash_completion.install "completions/hew.bash" => "hew"
    zsh_completion.install "completions/hew.zsh" => "_hew"
    fish_completion.install "completions/hew.fish"
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
    system "#{bin}/hew-lsp", "--version"
    system "#{bin}/hew-observe", "--version"

    (testpath/"hello.hew").write <<~HEW
      import std.math;

      fn main() {
          println("hello from homebrew");
          println(math.clamp(10, 0, 5));
      }
    HEW
    ENV["HEW_STD"] = (share/"hew/std").to_s
    output = shell_output("#{bin}/hew run #{testpath}/hello.hew")
    assert_match "hello from homebrew",
      output
    assert_match "5",
      output
  end
end
