```julia
show([io::IO = stdout], x)
```

値 `x` のテキスト表現を出力ストリーム `io` に書き込みます。新しい型 `T` では、`show(io::IO, x::T)` をオーバーロードする必要があります。`show` が使用する表現には、通常、Julia 固有の書式や型情報が含まれ、可能な場合は Julia コードとして解析できます。

[`repr`](@ref) は、`show` の出力を文字列として返します。

`T` 型のオブジェクトを、より詳しく人間が読みやすいテキストで出力するには、`show(io::IO, ::MIME"text/plain", ::T)` も定義してください。このようなメソッドでは、`io` の `:compact` [`IOContext`](@ref) キー（多くの場合、`get(io, :compact, false)::Bool` として確認されます）を調べることを推奨します。一部のコンテナは、このメソッドを `:compact => true` で呼び出して要素を表示するためです。

装飾のない表現を書き込む [`print`](@ref) も参照してください。

# Examples

```jldoctest
julia> show("Hello World!")
"Hello World!"
julia> print("Hello World!")
Hello World!
```
