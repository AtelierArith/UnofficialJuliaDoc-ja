```julia
repr(mime, x; context=nothing)
```

指定された `mime` タイプでの `x` の表現を含む `AbstractString` または `Vector{UInt8}` を返します。これは [`show(io, mime, x)`](@ref) によって書かれたものであり、適切な `show` が利用できない場合は [`MethodError`](@ref) をスローします。テキスト表現を持つ MIME タイプ（例えば `"text/html"` や `"application/postscript"`）の場合は `AbstractString` が返され、バイナリデータの場合は `Vector{UInt8}` として返されます。（関数 `istextmime(mime)` は、Julia が特定の `mime` タイプをテキストとして扱うかどうかを返します。）

オプションのキーワード引数 `context` は、`key=>value` ペアまたは `IO` または [`IOContext`](@ref) オブジェクトに設定でき、その属性は `show` に渡される I/O ストリームに使用されます。

特別なケースとして、`x` が `AbstractString`（テキスト MIME タイプの場合）または `Vector{UInt8}`（バイナリ MIME タイプの場合）の場合、`repr` 関数は `x` がすでに要求された `mime` 形式であると仮定し、単に `x` を返します。この特別なケースは `"text/plain"` MIME タイプには適用されません。これは、生データを `display(m::MIME, x)` に渡すために便利です。

特に、`repr("text/plain", x)` は通常、人間が消費するために設計された `x` の「整形された」バージョンです。代わりに [`show(x)`](@ref) に対応する文字列を返す [`repr(x)`](@ref) も参照してください。これは `x` の値が Julia に入力される方法により近いかもしれません。

# 例

```jldoctest
julia> A = [1 2; 3 4];

julia> repr("text/plain", A)
"2×2 Matrix{Int64}:\n 1  2\n 3  4"
```
