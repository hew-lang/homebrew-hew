# Tracks the newest release, release candidates included, until v0.6.0 ships
# as a final release — see `brew install hew-lang/tap/hew@stable` for the
# newest final release only. Once v0.6.0 ships as a final release this
# formula converges with hew@stable again, until the next pre-release window.
class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.6.0"
  license any_of: ["MIT", "Apache-2.0"]

  conflicts_with "hew@stable", because: "both install a `hew` binary"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-x86_64.tar.gz"
      sha256 "257c8fc3c9781018f1faf4f93d0dc554a7e64f4b2fdaf3066c152bd46a688db5"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
      sha256 "9453ce4cae11c205a4f6420ebd39cc5815b6a4a2e2c74fd92893f4b76ae221af"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "5419b390899a8d85c6351c9e135eaa94eb9d63445857ac99427b2bad944c4aca"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "8259c011b2d844be836ebbf8ac94d75dec94e8bb5259ff487e1f7240348a7f64"
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
