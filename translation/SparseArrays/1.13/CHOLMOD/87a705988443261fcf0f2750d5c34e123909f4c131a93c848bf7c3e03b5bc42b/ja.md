```julia
lowrankupdate(F::CHOLMOD.Factor, C::AbstractArray) -> FF::CHOLMOD.Factor
```

`A` の `LDLt` 分解または `LLt` 分解 `F` を与えて、`A + C*C'` の `LDLt` 分解を取得します。

返される分解は常に `LDLt` 分解です。

[`lowrankupdate!`](@ref)、[`lowrankdowndate`](@ref)、[`lowrankdowndate!`](@ref) も参照してください。
