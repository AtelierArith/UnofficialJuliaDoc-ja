```julia
repr(mime, x; context=nothing)
```

`AbstractString` または `Vector{UInt8}` を返します。これは、[`show(io, mime, x)`](@ref) が記述したとおりに、`x` を指定された `mime` 型で表現したものです（適切な `show` がない場合は [`MethodError`](@ref) をスローします）。テキスト表現を持つ MIME タイプ（`"text/html"` や `"application/postscript"` など）では `AbstractString` が返され、バイナリデータは `Vector{UInt8}` として返されます。（`istextmime(mime)` 関数は、指定された `mime` 型を Julia がテキストとして扱うかどうかを返します。）

省略可能なキーワード引数 `context` には、`:key=>value` ペア、または `IO` や [`IOContext`](@ref) オブジェクトを指定できます。これらの属性は、`show` に渡される I/O ストリームに使用されます。

特例として、`x` が（テキスト MIME タイプの場合は）`AbstractString`、または（バイナリ MIME タイプの場合は）`Vector{UInt8}` であれば、`repr` 関数は `x` がすでに要求された `mime` 形式であるとみなし、そのまま `x` を返します。この特例は `"text/plain"` MIME タイプには適用されません。これにより、生データを `display(m::MIME, x)` に渡せます。

特に、`repr("text/plain", x)` は通常、人が読むことを想定した `x` の「整形出力」です。また、[`repr(x)`](@ref) も参照してください。こちらは、[`show(x)`](@ref) に対応する文字列を返します。この文字列は、`x` の値を Julia で入力する際の表記に、より近い場合があります。

# Examples

```jldoctest
julia> A = [1 2; 3 4];

julia> repr("text/plain", A)
"2×2 Matrix{Int64}:\n 1  2\n 3  4"
```
