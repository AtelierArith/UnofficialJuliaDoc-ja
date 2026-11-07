```julia
CFunction struct
```

最初の引数に「$」の注釈が付いている場合に、`@cfunction`の戻り値を保持するためのガベージコレクション用ハンドルです。他のすべての`cfunction`ハンドルと同様に、`ccall`には`Ptr{Cvoid}`として渡してください。呼び出し箇所で適切な型に自動変換されます。

[`@cfunction`](@ref)を参照してください。
