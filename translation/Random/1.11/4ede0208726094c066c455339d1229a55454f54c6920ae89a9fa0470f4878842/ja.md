```julia
seed!([rng=default_rng()], seed) -> rng
seed!([rng=default_rng()]) -> rng
```

乱数生成器を再シードします：`rng`は、`seed`が提供される場合に限り、再現可能な数列を生成します。一部のRNGはシードを受け付けません（例：`RandomDevice`）。`seed!`の呼び出し後、`rng`は同じシードで初期化された新しく作成されたオブジェクトと同等になります。受け入れられるシードの型は`rng`の型によって異なりますが、一般的に整数シードは機能するはずです。

`rng`が指定されていない場合、共有タスクローカルジェネレーターの状態をシードすることがデフォルトとなります。

# 例

```julia-repl
julia> Random.seed!(1234);

julia> x1 = rand(2)
2-element Vector{Float64}:
 0.32597672886359486
 0.5490511363155669

julia> Random.seed!(1234);

julia> x2 = rand(2)
2-element Vector{Float64}:
 0.32597672886359486
 0.5490511363155669

julia> x1 == x2
true

julia> rng = Xoshiro(1234); rand(rng, 2) == x1
true

julia> Xoshiro(1) == Random.seed!(rng, 1)
true

julia> rand(Random.seed!(rng), Bool) # 再現性なし
true

julia> rand(Random.seed!(rng), Bool) # 再現性なし
false

julia> rand(Xoshiro(), Bool) # 再現性なし
true
```
