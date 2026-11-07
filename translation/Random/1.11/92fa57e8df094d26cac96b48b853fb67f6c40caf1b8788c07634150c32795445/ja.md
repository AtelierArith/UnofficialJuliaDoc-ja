```julia
Sampler(rng, x, repetition = Val(Inf))
```

`rng`から`x`を生成するために使用できるサンプラーオブジェクトを返します。

`sp = Sampler(rng, x, repetition)`の場合、ランダム値の生成には`rand(rng, sp)`が使用されるため、それに応じて定義する必要があります。

`repetition`には`Val(1)`または`Val(Inf)`を指定できます。該当する場合は、事前計算の量を決める際の目安として使用してください。

[`Random.SamplerType`](@ref)と[`Random.SamplerTrivial`](@ref)は、それぞれ*型*と*値*のデフォルトのフォールバックです。[`Random.SamplerSimple`](@ref)を使えば、この目的だけのために追加の型を定義せずに、事前計算した値を格納できます。
