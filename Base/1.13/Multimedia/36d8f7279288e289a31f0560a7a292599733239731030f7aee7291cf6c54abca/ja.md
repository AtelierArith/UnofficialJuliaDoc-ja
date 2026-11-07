```julia
repr(mime, x; context=nothing)
```

`AbstractString` または `Vector{UInt8}` を返します。これは、`x` を要求された `mime` 型の表現として、[`show(io, mime, x)`](@ref) が書き出したものです（適切な `show` が利用できない場合は [`MethodError`](@ref) をスローします）。テキスト表現を持つ MIME 型（`"text/html"` や `"application/postscript"` など）では `AbstractString` が返され、バイナリデータの場合は `Vector{UInt8}` が返されます。（`istextmime(mime)` 関数は、指定された `mime` 型を Julia がテキストとして扱うかどうかを返します。）

省略可能なキーワード引数 `context` には、`:key=>value` ペア、または `IO` や [`IOContext`](@ref) オブジェクトを指定できます。これらの属性は、`show` に渡される I/O ストリームに使用されます。

特例として、`x` が（テキスト MIME 型の場合）`AbstractString`、または（バイナリ MIME 型の場合）`Vector{UInt8}` であれば、`repr` 関数は `x` が要求された `mime` 形式で既に表現されているとみなし、そのまま `x` を返します。この特例は `"text/plain"` MIME 型には適用されません。これは、生データを `display(m::MIME, x)` に渡す場合に便利です。

特に、`repr("text/plain", x)` は通常、人が読みやすいように整形された `x` です。Julia で `x` の値を入力する際の表記により近い文字列を返すには、[`repr(x)`](@ref) も参照してください。これは、[`show(x)`](@ref) に対応する文字列を返します。

# Examples

```jldoctest
julia> A = [1 2; 3 4];

julia> repr("text/plain", A)
"2×2 Matrix{Int64}:\n 1  2\n 3  4"
```
