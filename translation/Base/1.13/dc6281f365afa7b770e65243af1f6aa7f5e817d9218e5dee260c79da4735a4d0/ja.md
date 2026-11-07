```julia
findprev(predicate::Function, A, i)
```

`i`以前またはその位置にある要素のうち、`A`に属し、`predicate`が`true`を返す要素のインデックスを返します。見つからない場合は`nothing`を返します。これは、[`getindex`](@ref)、[`keys(A)`](@ref)、[`nextind`](@ref)をサポートする配列、文字列、その他ほとんどのコレクションで使用できます。

インデックスの型は、[`keys(A)`](@ref)および[`pairs(A)`](@ref)が返す型と同じです。

# Examples

```jldoctest
julia> A = [4, 6, 1, 2]
4-element Vector{Int64}:
 4
 6
 1
 2

julia> findprev(isodd, A, 1) # returns nothing, but not printed in the REPL

julia> findprev(isodd, A, 3)
3

julia> A = [4 6; 1 2]
2×2 Matrix{Int64}:
 4  6
 1  2

julia> findprev(isodd, A, CartesianIndex(1, 2))
CartesianIndex(2, 1)

julia> findprev(isspace, "a b c", 3)
2
```
