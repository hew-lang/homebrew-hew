# homebrew-hew

Homebrew tap for the [Hew](https://hew.sh) programming language.

## Installation

Choose one release channel.

Current releases, including release candidates:

```sh
brew install hew-lang/hew/hew
```

Final releases only:

```sh
brew install hew-lang/hew/hew-stable
```

The former `hew@stable` spelling remains an alias for `hew-stable`.

Supported platforms are Linux x86_64/aarch64 and macOS on Apple silicon.

## What Gets Installed

- `hew` — the compiler, language server (`hew lsp`) and actor observer (`hew observe`)
- `libhew.a` — the Hew runtime and standard library
- `std/` — the Hew standard library sources
- Shell completions (bash, zsh, fish) when available

## License

Apache-2.0
