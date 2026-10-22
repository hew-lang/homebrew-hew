# Tracks the newest release, including release candidates.
# Use hew@stable for the newest final release only.
class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.7.0"
  license any_of: ["MIT", "Apache-2.0"]

  conflicts_with "hew@stable", because: "both install a `hew` binary"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
    sha256 "8f1529cef7581f76256b9064e8b1ca9b695fb549a892c5f5e55c8770a7a137f8"
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "d9663f4861e74aea01700b28e7fffb7a0b985b6538fedbf240be9aa5b2808424"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "b07cdb5ac1872bcde0c01b88fe7379c41520c753ac6f7a652322833593befdb6"
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
