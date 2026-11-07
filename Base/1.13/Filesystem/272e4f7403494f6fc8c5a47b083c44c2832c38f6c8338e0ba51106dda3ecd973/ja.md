```julia
ispath(path)::Bool
ispath(path_elements...)::Bool
```

`true` を返します。`path` に有効なファイルシステムエンティティが存在する場合はそうし、存在しない場合は `false` を返します。

これは [`isfile`](@ref)、[`isdir`](@ref) などを一般化したものです。
