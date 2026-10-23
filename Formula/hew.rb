# Tracks the newest release, including release candidates.
# Use hew@stable for the newest final release only.
class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.8.0"
  license any_of: ["MIT", "Apache-2.0"]

  conflicts_with "hew@stable", because: "both install a `hew` binary"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
    sha256 "caa52d04c2aa7d0afd9db64c6afc85c1180f15dc219d4a3ea23de1c5245291c1"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "feb771a15a2a49871c0b9ea7baeffcbe0b79e4ad4b0284577cbc3bcd148547f1"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "f78e22d025118de5d340717b3946b76ff741bee12577931cc214eb77994cfc25"
    end
  end

  def install
    bin.install "bin/hew"
    lib.install Dir["lib/*"]
    include.install Dir["include/*"] if File.directory?("include")
    (share/"hew").install Dir["share/hew/*"] if File.directory?("share/hew")

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
    system "#{bin}/hew", "lsp", "--version"
    system "#{bin}/hew", "observe", "--version"

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
