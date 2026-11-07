```julia
lowrankupdate!(F::CHOLMOD.Factor, C::AbstractArray)
```

`A` の `LDLt` または `LLt` 因子分解 `F` を、`A + C*C'` の因子分解に更新します。

`LLt` の因子分解は `LDLt` に変換されます。

関連項目: [`lowrankupdate`](@ref)、[`lowrankdowndate`](@ref)、[`lowrankdowndate!`](@ref)。
