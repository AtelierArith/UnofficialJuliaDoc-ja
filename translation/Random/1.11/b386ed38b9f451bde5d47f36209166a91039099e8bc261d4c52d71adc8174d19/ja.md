```julia
Random.SeedHasher(seed=nothing)
```

暗号学的ハッシュ関数（SHA2）を用いてランダムバイトを生成する `Random.SeedHasher` RNG オブジェクトを作成します。生成には [`Random.hash_seed`](@ref) の呼び出しを使用します。

2 つのシード `s1` と `s2` が与えられたとき、`SeedHasher(s1)` と `SeedHasher(s2)` が生成する乱数ストリームは、`s1` と `s2` が異なる場合に限り、互いに異なります。

この RNG は `Random.seed!(::AbstractRNG, seed::Any)` でデフォルトとして使用されるため、通常、RNG が実装する必要があるのは `seed!(rng, ::AbstractRNG)` だけです。

これは内部型であり、変更される可能性があります。
