```
jump_128(rng::Xoshiro, [n::Integer=1])
```

`rng`の状態を`n * 2^128`回の呼び出しに相当するように進めたコピーを返します。各呼び出しは8バイト（すなわちフルの`UInt64`）を消費します。`n = 0`の場合、返されるコピーの状態は`rng`と同一になります。

これは、並列計算のために`2^128`の非重複部分列を生成するために使用できます。

参照: [`jump_128!`](@ref), [`jump_192`](@ref)

# 例

```julia-repl
julia> x = Xoshiro(1);

julia> jump_128(jump_128(x)) == jump_128(x, 2)
true

julia> jump_128(x, 0) == x
true

julia> jump_128(x, 0) === x
false
```
