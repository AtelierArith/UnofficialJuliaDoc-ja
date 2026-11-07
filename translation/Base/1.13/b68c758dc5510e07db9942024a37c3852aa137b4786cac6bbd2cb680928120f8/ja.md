```julia
foreach(f, c...) -> nothing
```

反復可能オブジェクト`c`の各要素に対して、関数`f`を呼び出します。複数の反復可能引数を指定した場合は、`f`が要素ごとに呼び出され、いずれかのイテレーターが終了した時点で反復も終了します。

`f`の結果が不要な場合は、[`map`](@ref)の代わりに`foreach`を使用してください。たとえば、`foreach(println, array)`の場合です。

# Examples

```jldoctest
julia> tri = 1:3:7; res = Int[];

julia> foreach(x -> push!(res, x^2), tri)

julia> res
3-element Vector{Int64}:
  1
 16
 49

julia> foreach((x, y) -> println(x, " with ", y), tri, 'a':'z')
1 with a
4 with b
7 with c
```
