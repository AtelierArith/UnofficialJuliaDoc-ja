```julia
Pkg.instantiate(; verbose = false, workspace=false, io::IO=stderr, julia_version_strict=false)
```

アクティブプロジェクトに `Manifest.toml` ファイルが存在する場合、そのマニフェストに宣言されたすべてのパッケージをダウンロードします。そうでない場合は、`Project.toml` ファイルから実行可能なパッケージのセットを解決し、それらをインストールします。`verbose = true` はビルド出力を `stdout`/`stderr` に印刷し、`build.log` ファイルにリダイレクトしません。`workspace=true` はワークスペース内のすべてのプロジェクトもインスタンス化します。現在のアクティブプロジェクトに `Project.toml` が存在しない場合、マニフェスト内のすべての依存関係を持つ新しいものを作成し、その結果得られたプロジェクトをインスタンス化します。`julia_version_strict=true` はマニフェストのバージョンチェックの失敗を警告としてログするのではなく、エラーに変えます。

パッケージがインストールされた後、プロジェクトはプリコンパイルされます。詳細は [Environment Precompilation](@ref) を参照してください。

!!! compat "Julia 1.12"
    `julia_version_strict` キーワード引数は少なくとも Julia 1.12 が必要です。

