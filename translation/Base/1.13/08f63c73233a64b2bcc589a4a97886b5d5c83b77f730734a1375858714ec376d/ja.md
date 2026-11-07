```julia
argmin(f, domain)
```

`x` を返します。これは `domain` の中から `f(x)` が最小となる値です。`f(x)` が最小となる値が複数ある場合は、最初の値が返されます。

`domain` は空でない反復可能オブジェクトでなければなりません。

`NaN` は、`missing` を除くすべての値より小さいものとして扱われます。

!!! compat "Julia 1.7"
    このメソッドを使用するには、Julia 1.7 以降が必要です。


関連項目: [`argmax`](@ref)、[`findmin`](@ref)。

# Examples

```jldoctest
julia> argmin(sign, -10:5)
-10

julia> argmin(x -> -x^3 + x^2 - 10, -5:5)
5

julia> argmin(acos, 0:0.1:1)
1.0
```
