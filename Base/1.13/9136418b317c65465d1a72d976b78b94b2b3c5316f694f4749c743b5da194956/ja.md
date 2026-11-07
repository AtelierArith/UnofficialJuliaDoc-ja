```julia
findmin(f, domain) -> (f(x), index)
```

`f` の出力である値と、`f` への入力である `domain` 内の対応する値のインデックスまたはキーを返します。`f(x)` が最小となるものを返し、最小値をとる点が複数ある場合は最初のものを返します。

`domain` は空でない反復可能オブジェクトでなければなりません。

インデックスの型は、[`keys(domain)`](@ref) および [`pairs(domain)`](@ref) が返す型と同じです。

`NaN` は、`missing` を除くすべての値より小さいものとして扱われます。

!!! compat "Julia 1.7"
    このメソッドには Julia 1.7 以降が必要です。


# Examples

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
