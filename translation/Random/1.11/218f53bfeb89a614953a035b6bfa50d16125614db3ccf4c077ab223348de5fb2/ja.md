```julia
seed!([rng=default_rng()], seed) -> rng
seed!([rng=default_rng()]) -> rng
```

乱数生成器を再シードします。`rng`は、`seed`が指定されている場合に限り、再現可能な数列を生成します。`RandomDevice`のように、シードを受け付けないRNGもあります。`seed!`を呼び出した後の`rng`は、同じシードで初期化した新しいオブジェクトと同等です。

受け付けるシードの型は`rng`の型によって異なりますが、一般に整数のシードを使用できます。シードに`nothing`を指定した場合、シードを指定しない場合と同じです。

`rng`を指定しない場合、共有タスクローカルジェネレーターの状態をシードする設定が既定で使用されます。

# Examples

```jldoctest; filter = r"(true|false)"
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

julia> rand(Random.seed!(rng), Bool) # not reproducible
true

julia> rand(Random.seed!(rng), Bool) # not reproducible either
false

julia> rand(Xoshiro(), Bool) # not reproducible either
true
```
