```
findmin(f, domain) -> (f(x), index)
```

コドメイン内の値（`f`の出力）と、対応する値のインデックスまたはキー（`f`の入力）からなるペアを返します。ここで、`f(x)`が最小化されます。最小点が複数ある場合は、最初のものが返されます。

`domain`は空でないイテラブルでなければなりません。

インデックスは[`keys(domain)`](@ref)および[`pairs(domain)`](@ref)によって返されるものと同じ型です。

`NaN`は、`missing`を除くすべての値よりも小さいと見なされます。

!!! compat "Julia 1.7"
    このメソッドはJulia 1.7以降が必要です。


# 例

```jldoctest
julia> findmin(identity, 5:9)
(5, 1)

julia> findmin(-, 1:10)
(-10, 10)

julia> findmin(first, [(2, :a), (2, :b), (3, :c)])
(2, 1)

julia> findmin(cos, 0:π/2:2π)
(-1.0, 3)
```
