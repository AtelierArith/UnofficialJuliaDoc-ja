```julia
DirEntry
```

ファイルシステムのエントリを表す型です。エントリ名、ディレクトリ、およびエントリの生の型を保持します。エントリの完全なパスは、`path`フィールドにアクセスすると遅延評価で取得できます。エントリの型は、[`isfile`](@ref)、[`isdir`](@ref)、[`islink`](@ref)、[`isfifo`](@ref)、[`issocket`](@ref)、[`ischardev`](@ref)、および[`isblockdev`](@ref)を呼び出して確認できます。
