# Tracks the newest release, including release candidates.
# Use hew@stable for the newest final release only.
class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.11.0-rc4"
  license any_of: ["MIT", "Apache-2.0"]

  conflicts_with "hew-stable", because: "both install a `hew` binary"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
    sha256 "6b3e770366984b730c54006099069e53296fe8d572d59431f12e21267a50e3db"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "b5a16a26de63f53fb894f61b6591c83e04bbf8e39d3d752adef0fad46863d2cd"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "22e4b5ff447e12228b7e9a4d703ebbad5664e1af7e8c90f46daa6e85077f96c2"
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
          println(math.clamp(10, 0, 5).expect("clamp bounds are valid"));
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
