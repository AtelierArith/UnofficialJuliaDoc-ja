```
show([io::IO = stdout], x)
```

値 `x` のテキスト表現を出力ストリーム `io` に書き込みます。新しい型 `T` は `show(io::IO, x::T)` をオーバーロードする必要があります。`show` によって使用される表現は一般的にJulia特有のフォーマットと型情報を含み、可能な限り解析可能なJuliaコードであるべきです。

[`repr`](@ref) は `show` の出力を文字列として返します。

型 `T` のオブジェクトに対してより詳細な人間可読のテキスト出力を提供するには、`show(io::IO, ::MIME"text/plain", ::T)` を追加で定義します。このようなメソッドでは、`io` の `:compact` [`IOContext`](@ref) キー（通常は `get(io, :compact, false)::Bool` としてチェックされる）を確認することが推奨されます。なぜなら、一部のコンテナはこのメソッドを `:compact => true` で呼び出すことで要素を表示するからです。

また、装飾のない表現を書き込む [`print`](@ref) も参照してください。

# 例

```jldoctest
julia> show("Hello World!")
"Hello World!"
julia> print("Hello World!")
Hello World!
```
