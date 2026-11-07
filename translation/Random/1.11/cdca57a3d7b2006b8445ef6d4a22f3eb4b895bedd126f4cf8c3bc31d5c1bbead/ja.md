```julia
jump_192(rng::Xoshiro, [n::Integer=1])
```

8 バイト（つまり、完全な `UInt64`）を消費する呼び出しを `n * 2^192` 回行った後の状態を持つ、`rng` のコピーを返します。`n = 0` の場合、返されるコピーの状態は `rng` と同一になります。

これは、並列計算で重複しない部分列を `2^64` 個生成するために使用できます。

関連項目: [`jump_192!`](@ref)、[`jump_128`](@ref)

# Examples

```julia-repl
julia> x = Xoshiro(1);

julia> jump_192(jump_192(x)) == jump_192(x, 2)
true

julia> jump_192(x, 0) == x
true

julia> jump_192(x, 0) === x
false
```
