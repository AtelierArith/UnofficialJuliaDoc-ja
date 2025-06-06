```
Pkg.instantiate(; verbose = false, io::IO=stderr)
```

アクティブプロジェクトに `Manifest.toml` ファイルが存在する場合、そのマニフェストに宣言されたすべてのパッケージをダウンロードします。そうでない場合は、`Project.toml` ファイルから実行可能なパッケージのセットを解決し、それらをインストールします。`verbose = true` は、ビルド出力を `stdout`/`stderr` に印刷し、`build.log` ファイルにリダイレクトしません。現在のアクティブプロジェクトに `Project.toml` が存在しない場合、マニフェスト内のすべての依存関係を持つ新しいものを作成し、結果として得られたプロジェクトをインスタンス化します。

パッケージがインストールされた後、プロジェクトはプリコンパイルされます。詳細は [Environment Precompilation](@ref) を参照してください。
