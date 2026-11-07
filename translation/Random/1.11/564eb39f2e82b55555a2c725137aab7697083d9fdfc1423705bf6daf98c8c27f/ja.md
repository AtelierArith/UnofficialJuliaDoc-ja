```julia
MersenneTwister(seed)
MersenneTwister()
```

`MersenneTwister` オブジェクトを作成します。RNG オブジェクトごとに異なるシードを設定できるため、異なる乱数列を生成する場合に便利です。`seed` には、整数、文字列、または `UInt32` 整数のベクトルを指定できます。シードを指定しない場合は、システムのエントロピーを使ってランダムに生成されます。既存の `MersenneTwister` オブジェクトにシードを設定し直す方法については、[`seed!`](@ref) 関数を参照してください。

!!! compat "Julia 1.11"
    負の整数シードを渡すには、Julia 1.11 以降が必要です。


# Examples

```jldoctest
julia> rng = MersenneTwister(123);

julia> x1 = rand(rng, 2)
2-element Vector{Float64}:
 0.37453777969575874
 0.8735343642013971

julia> x2 = rand(MersenneTwister(123), 2)
2-element Vector{Float64}:
 0.37453777969575874
 0.8735343642013971

julia> x1 == x2
true
```
