# Tracks the newest final (non-rc) release. Until v0.6.0 ships as a final
# release, plain `hew` tracks the newest release candidate instead — see
# Formula/hew.rb. Once v0.6.0 ships as a final release the two formulae
# point at the same version again, until the next pre-release window.
class HewATStable < Formula
  desc "Statically-typed, actor-oriented programming language (stable channel)"
  homepage "https://hew.sh"
  version "0.6.1"
  license any_of: ["MIT", "Apache-2.0"]

  conflicts_with "hew", because: "both install a `hew` binary"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
    sha256 "09a3b8e4e65e0efe89ebacce4842d25b08469d564c10deefb3c790a6f52857aa"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "ac63bc97e92ebbea59f316021b726157e65a6d9d3417b514ed2b6d185c70900b"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "7170af3c9ff51ff8578d4a76d4e0cf4b42c072d2f482d5d1a1c4538c07ac9834"
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
