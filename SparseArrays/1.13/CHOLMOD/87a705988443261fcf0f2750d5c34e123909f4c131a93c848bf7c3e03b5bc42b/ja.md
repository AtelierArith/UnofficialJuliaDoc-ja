```julia
lowrankupdate(F::CHOLMOD.Factor, C::AbstractArray) -> FF::CHOLMOD.Factor
```

`LDLt` または `LLt` の `A` の因数分解 `F` が与えられたとき、`A + C*C'` の `LDLt` 因数分解を取得します。

返される因数は、常に `LDLt` 因数分解です。

関連項目: [`lowrankupdate!`](@ref)、[`lowrankdowndate`](@ref)、[`lowrankdowndate!`](@ref)。
