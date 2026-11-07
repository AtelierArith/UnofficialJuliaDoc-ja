```julia
inplace_adj_or_trans(::AbstractArray) -> adjoint!|transpose!|copyto!
inplace_adj_or_trans(::Type{<:AbstractArray}) -> adjoint!|transpose!|copyto!
```

`Adjoint` 型またはオブジェクトからは [`adjoint!`](@ref) を、`Transpose` 型またはオブジェクトからは [`transpose!`](@ref) を返します。それ以外の場合は [`copyto!`](@ref) を返します。`identity` 以外の関数を返すには、`Adjoint` と `Transpose` が最外側のラッパーオブジェクトである必要があります。
