```julia
findmax(f, domain) -> (f(x), index)
```

`f` の出力である値と、`f` への入力である `domain` 内の対応する値のインデックスまたはキーのペアを返します。このペアは、`f(x)` が最大となるものです。最大値をとる点が複数ある場合は、最初のものを返します。

`domain` は、空でなく、[`keys`](@ref) をサポートする反復可能オブジェクトでなければなりません。インデックスの型は、[`keys(domain)`](@ref) が返すものと同じです。

値は `isless` で比較されます。

!!! compat "Julia 1.7"
    このメソッドを使用するには、Julia 1.7 以降が必要です。


# Examples

```jldoctest
julia> findmax(identity, 5:9)
(9, 5)

julia> findmax(-, 1:10)
(-1, 1)

julia> findmax(first, [(1, :a), (3, :b), (3, :c)])
(3, 2)

julia> findmax(cos, 0:π/2:2π)
(1.0, 1)
```
