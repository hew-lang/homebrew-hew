# Tracks the newest release, release candidates included, until v0.6.0 ships
# as a final release — see `brew install hew-lang/tap/hew@stable` for the
# newest final release only. Once v0.6.0 ships as a final release this
# formula converges with hew@stable again, until the next pre-release window.
class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.6.0-rc3"
  license any_of: ["MIT", "Apache-2.0"]

  conflicts_with "hew@stable", because: "both install a `hew` binary"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-x86_64.tar.gz"
      sha256 "acdf420415f3a066bbb6638f98be1d4890349df5d747141f904767d17476671d"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
      sha256 "5d17eacb6763cb287257986d36bc42019804e99e2eaa5da82eb01b4419efd7e1"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "576cef451d5cd0cc98a811e0ae006039c6d4f924d5eb1fc0cb5554e077df1278"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "105502a1d533e199e4515e1f02a29f7aea17cd2fe08024590f7ebfd15c06eaa3"
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
