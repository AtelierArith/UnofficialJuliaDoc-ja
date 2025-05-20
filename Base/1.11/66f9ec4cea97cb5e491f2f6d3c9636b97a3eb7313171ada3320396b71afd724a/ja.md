```
valtype(T::Type{<:AbstractArray})
valtype(A::AbstractArray)
```

配列の値の型を返します。これは[`eltype`](@ref)と同じであり、主に辞書インターフェースとの互換性のために提供されています。

# 例

```jldoctest
julia> valtype(["one", "two", "three"])
String
```

!!! compat "Julia 1.2"
    配列の場合、この関数は少なくともJulia 1.2が必要です。

