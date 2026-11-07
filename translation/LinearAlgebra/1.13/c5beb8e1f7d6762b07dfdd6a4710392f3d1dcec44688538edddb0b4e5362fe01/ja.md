```julia
inplace_adj_or_trans(::AbstractArray) -> adjoint!|transpose!|copyto!
inplace_adj_or_trans(::Type{<:AbstractArray}) -> adjoint!|transpose!|copyto!
```

`Adjoint`型またはオブジェクトからは[`adjoint!`](@ref)を、`Transpose`型またはオブジェクトからは[`transpose!`](@ref)を返します。それ以外の場合は[`copyto!`](@ref)を返します。`Adjoint`と`Transpose`は、非`identity`関数を返すための最外層のラッパーオブジェクトである必要がある点に注意してください。
