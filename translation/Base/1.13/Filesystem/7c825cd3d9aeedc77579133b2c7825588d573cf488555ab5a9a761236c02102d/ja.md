```julia
DirEntry
```

エントリ名、ディレクトリ、およびエントリの生の型を保持する、ファイルシステムエントリを表す型です。エントリの完全なパスは、`path` フィールドにアクセスすると遅延評価で取得できます。エントリの型は、[`isfile`](@ref)、[`isdir`](@ref)、[`islink`](@ref)、[`isfifo`](@ref)、[`issocket`](@ref)、[`ischardev`](@ref)、および [`isblockdev`](@ref) を呼び出して確認できます。
