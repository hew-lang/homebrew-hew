# Tracks the newest final release; use hew for release candidates too.
class HewATStable < Formula
  desc "Statically-typed, actor-oriented programming language (stable channel)"
  homepage "https://hew.sh"
  version "0.6.4"
  license any_of: ["MIT", "Apache-2.0"]

  conflicts_with "hew", because: "both install a `hew` binary"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
    sha256 "8067a7b6e0c020896532453b9c5763ff5d78ef1a4079233032b7659cf8ccce71"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "c393d100d83037ce43bcf767c6bab57e5373b02f4069d009cdd6744516a50c78"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "57023428f3c766bd09b90a84f2e54505630ffdef7b7fc98d615aeba154c591b9"
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
