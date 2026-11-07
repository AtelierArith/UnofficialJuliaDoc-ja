```julia
valtype(T::Type{<:AbstractArray})
valtype(A::AbstractArray)
```

配列の値の型を返します。これは[`eltype`](@ref)と同じで、主に辞書インターフェースとの互換性のために用意されています。

# Examples

```jldoctest
julia> valtype(["one", "two", "three"])
String
```

!!! compat "Julia 1.2"
    配列に対してこの関数を使用するには、Julia 1.2以降が必要です。

