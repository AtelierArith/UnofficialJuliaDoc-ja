```julia
Random.SeedHasher(seed=nothing)
```

暗号学的ハッシュ関数（SHA2）を利用し、[`Random.hash_seed`](@ref) の呼び出しを通じてランダムなバイト列を生成する `Random.SeedHasher` RNG オブジェクトを作成します。

2 つのシード `s1` と `s2` が与えられたとき、`SeedHasher(s1)` と `SeedHasher(s2)` が生成する乱数ストリームは、`s1` と `s2` が異なる場合に限り、互いに異なるものとなります。

この RNG は `Random.seed!(::AbstractRNG, seed::Any)` でデフォルトで使用されるため、通常、RNG が実装する必要があるのは `seed!(rng, ::AbstractRNG)` だけです。

これは内部型であり、変更される可能性があります。
