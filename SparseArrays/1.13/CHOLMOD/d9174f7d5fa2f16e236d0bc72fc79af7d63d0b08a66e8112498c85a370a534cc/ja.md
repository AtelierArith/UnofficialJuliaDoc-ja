```julia
lowrankdowndate(F::CHOLMOD.Factor, C::AbstractArray) -> FF::CHOLMOD.Factor
```

`A + C*C'` の `A` を、`LDLt` または `LLt` の因子分解 `F` から `LDLt` 因子分解として取得します。

返される因子は、常に `LDLt` 因子分解です。

関連項目: [`lowrankdowndate!`](@ref)、[`lowrankupdate`](@ref)、[`lowrankupdate!`](@ref)。
