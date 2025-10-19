```julia
Sampler(rng, x, repetition = Val(Inf))
```

`rng`から`x`のランダム値を生成するために使用できるサンプラーオブジェクトを返します。

`sp = Sampler(rng, x, repetition)` のとき、`rand(rng, sp)` がランダム値を引き出すために使用され、適切に定義されるべきです。

`repetition` は `Val(1)` または `Val(Inf)` であり、適用可能な場合は前計算の量を決定するための提案として使用されるべきです。

[`Random.SamplerType`](@ref) と [`Random.SamplerTrivial`](@ref) はそれぞれ *型* と *値* のデフォルトフォールバックです。 [`Random.SamplerSimple`](@ref) は、この目的のためだけに追加の型を定義することなく、前計算された値を格納するために使用できます。
