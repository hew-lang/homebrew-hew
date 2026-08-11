class Hew < Formula
  desc "Statically-typed, actor-oriented programming language"
  homepage "https://hew.sh"
  version "0.5.6"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-x86_64.tar.gz"
      sha256 "48d1c3b30a9b18fab5e66cebd752fd4aa72efef00ee00ef0088d41e1d8f83095"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-darwin-aarch64.tar.gz"
      sha256 "e9bad3641097ca744d44cee09a11ca5cd2b7fca4550d4335ef1559d02d64ba62"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-x86_64.tar.gz"
      sha256 "05d5e5c52083d7c35f829213204ccc5037591808d91753a9d623e8380addc17c"
    else
      url "https://github.com/hew-lang/hew/releases/download/v#{version}/hew-v#{version}-linux-aarch64.tar.gz"
      sha256 "79d359f4b64d22e134fbc62eb87251b32d49f11696c4870638e34681cb7f1e08"
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
      import std::math;

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
