```julia
unique!(f, A::AbstractVector)
```

`f`を`A`の各要素に適用して得られる一意な値ごとに、`A`から1つの値を選択し、変更後のAを返します。

!!! compat "Julia 1.1"
    このメソッドはJulia 1.1以降で利用できます。


# Examples

```jldoctest
julia> unique!(x -> x^2, [1, -1, 3, -3, 4])
3-element Vector{Int64}:
 1
 3
 4

julia> unique!(n -> n%3, [5, 1, 8, 9, 3, 4, 10, 7, 2, 6])
3-element Vector{Int64}:
 5
 1
 9

julia> unique!(iseven, [2, 3, 5, 7, 9])
2-element Vector{Int64}:
 2
 3
```
