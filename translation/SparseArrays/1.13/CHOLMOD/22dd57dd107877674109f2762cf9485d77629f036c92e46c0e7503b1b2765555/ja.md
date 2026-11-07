```julia
lowrankdowndate!(F::CHOLMOD.Factor, C::AbstractArray)
```

`LDLt` または `LLt` の因子分解 `F` を、`A` の `A - C*C'` への因子分解に更新します。

`LLt` の因子分解は `LDLt` に変換されます。

関連項目: [`lowrankdowndate`](@ref)、[`lowrankupdate`](@ref)、[`lowrankupdate!`](@ref)。
