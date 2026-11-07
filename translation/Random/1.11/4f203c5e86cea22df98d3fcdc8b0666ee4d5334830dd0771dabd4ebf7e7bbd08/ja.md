```julia
jump_128(rng::Xoshiro, [n::Integer=1])
```

8 バイト（つまり、`UInt64` 全体）を消費する呼び出しを `n * 2^128` 回行ったのと同等に状態を進めた、`rng` のコピーを返します。`n = 0` の場合、返されるコピーの状態は `rng` と同一になります。

これは、並列計算で重複しない `2^128` 個の部分列を生成するために使用できます。

関連項目: [`jump_128!`](@ref)、[`jump_192`](@ref)

# Examples

```julia-repl
julia> x = Xoshiro(1);

julia> jump_128(jump_128(x)) == jump_128(x, 2)
true

julia> jump_128(x, 0) == x
true

julia> jump_128(x, 0) === x
false
```
