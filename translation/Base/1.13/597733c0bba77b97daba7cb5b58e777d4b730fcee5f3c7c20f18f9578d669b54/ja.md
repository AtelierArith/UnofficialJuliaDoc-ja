```julia
findnext(predicate::Function, A, i)
```

`i`以降（そのインデックスを含む）で、`A`の要素に対して`predicate`が`true`を返す最初のインデックスを検索します。見つからない場合は`nothing`を返します。これは、[`getindex`](@ref)、[`keys(A)`](@ref)、[`nextind`](@ref)をサポートする配列、文字列、その他ほとんどのコレクションで使用できます。

インデックスの型は、[`keys(A)`](@ref)および[`pairs(A)`](@ref)が返す型と同じです。

# Examples

```jldoctest
julia> A = [1, 4, 2, 2];

julia> findnext(isodd, A, 1)
1

julia> findnext(isodd, A, 2) # returns nothing, but not printed in the REPL

julia> A = [1 4; 2 2];

julia> findnext(isodd, A, CartesianIndex(1, 1))
CartesianIndex(1, 1)

julia> findnext(isspace, "a b c", 3)
4
```
