```
inplace_adj_or_trans(::AbstractArray) -> adjoint!|transpose!|copyto!
inplace_adj_or_trans(::Type{<:AbstractArray}) -> adjoint!|transpose!|copyto!
```

`Adjoint`型またはオブジェクトから[`adjoint!`](@ref)を返し、`Transpose`型またはオブジェクトから[`transpose!`](@ref)を返します。それ以外の場合は[`copyto!`](@ref)を返します。`Adjoint`と`Transpose`は、非`identity`関数が返されるための最外層のラッパーオブジェクトである必要があります。
