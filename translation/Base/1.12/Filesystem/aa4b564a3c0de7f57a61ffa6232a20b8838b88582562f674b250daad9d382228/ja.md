```julia
ispath(path) -> Bool
ispath(path_elements...) -> Bool
```

`path`に有効なファイルシステムエンティティが存在する場合は`true`を返し、そうでない場合は`false`を返します。

これは[`isfile`](@ref)、[`isdir`](@ref)などの一般化です。
