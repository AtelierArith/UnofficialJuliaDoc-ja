```
findmax(f, domain) -> (f(x), index)
```

`f`の出力値（コドメイン内の値）と、`domain`内の対応する値のインデックスまたはキー（`f`への入力）をペアで返します。`f(x)`が最大化されるようにします。最大点が複数ある場合は、最初のものが返されます。

`domain`は、[`keys`](@ref)をサポートする空でないイテラブルでなければなりません。インデックスは[`keys(domain)`](@ref)によって返されるものと同じ型です。

値は`isless`で比較されます。

!!! compat "Julia 1.7"
    このメソッドはJulia 1.7以降が必要です。


# 例

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
