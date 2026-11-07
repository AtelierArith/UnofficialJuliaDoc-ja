```julia
lowrankupdate!(F::CHOLMOD.Factor, C::AbstractArray)
```

`A` の `LDLt` または `LLt` 分解 `F` を、`A + C*C'` の分解に更新します。

`LLt` 分解は `LDLt` に変換されます。

関連項目: [`lowrankupdate`](@ref)、[`lowrankdowndate`](@ref)、[`lowrankdowndate!`](@ref)。
