```julia
Pkg.instantiate(; verbose = false, workspace=false, io::IO=stderr, julia_version_strict=false)
```

アクティブなプロジェクトに`Manifest.toml`ファイルがある場合は、そのマニフェストに宣言されているすべてのパッケージをダウンロードします。ない場合は、`Project.toml`ファイルから実行可能なパッケージの組み合わせを解決し、インストールします。`verbose = true`は、ビルド出力を`stdout`/`stderr`に出力し、`build.log`ファイルへのリダイレクトは行いません。また、`workspace=true`はワークスペース内のすべてのプロジェクトをインスタンス化します。現在のアクティブなプロジェクトに`Project.toml`が存在しない場合は、マニフェスト内のすべての依存関係を含むものを作成し、生成されたプロジェクトをインスタンス化します。`julia_version_strict=true`を指定すると、マニフェストのバージョンチェックの失敗が警告として記録されるのではなく、エラーになります。

パッケージのインストール後、プロジェクトはプリコンパイルされます。詳細と自動プリコンパイルを無効にする方法については、[Environment Precompilation](@ref)を参照してください。

!!! compat "Julia 1.12"
    `julia_version_strict`キーワード引数を使用するには、Julia 1.12以降が必要です。

