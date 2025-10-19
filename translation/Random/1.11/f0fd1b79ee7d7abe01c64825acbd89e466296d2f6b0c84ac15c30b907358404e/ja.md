```julia
MersenneTwister(seed)
MersenneTwister()
```

`MersenneTwister` RNGオブジェクトを作成します。異なるRNGオブジェクトはそれぞれ独自のシードを持つことができ、異なるランダム数のストリームを生成するのに役立ちます。`seed`は整数、文字列、または`UInt32`整数のベクターである場合があります。シードが提供されない場合は、ランダムに生成されたものが作成されます（システムからのエントロピーを使用）。既存の`MersenneTwister`オブジェクトの再シードについては、[`seed!`](@ref)関数を参照してください。

!!! compat "Julia 1.11"
    負の整数シードを渡すには、少なくともJulia 1.11が必要です。


# 例

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
