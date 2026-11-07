```julia
Xoshiro(seed::Union{Integer, AbstractString})
Xoshiro()
```

Xoshiro256++ は、David Blackman と Sebastiano Vigna による論文「Scrambled Linear Pseudorandom Number Generators」（ACM Trans. Math. Softw., 2021）で説明されている高速な擬似乱数生成器です。参照実装は https://prng.di.unimi.it で入手できます。

Xoshiro は高速であるだけでなく、メモリ使用量も少ないため、多数の異なる乱数状態を長時間保持する必要がある用途に適しています。

Julia の Xoshiro 実装には一括生成モードがあります。このモードでは、親の PRNG から新たな仮想 PRNG のシードを生成し、SIMD を使って並列に乱数を生成します（つまり、一括生成される乱数列は、複数の xoshiro インスタンスの出力を交互に組み合わせたものです）。仮想 PRNG は一括生成の要求への処理が完了すると破棄されます（また、この処理ではヒープ割り当ては発生しないはずです）。

シードを指定しない場合は、システムのエントロピーを使ってランダムなシードが生成されます。既存の `Xoshiro` オブジェクトにシードを再設定するには、[`seed!`](@ref) 関数を参照してください。

!!! compat "Julia 1.11"
    負の整数をシードとして渡すには、Julia 1.11 以降が必要です。


# Examples

```jldoctest
julia> using Random

julia> rng = Xoshiro(1234);

julia> x1 = rand(rng, 2)
2-element Vector{Float64}:
 0.32597672886359486
 0.5490511363155669

julia> rng = Xoshiro(1234);

julia> x2 = rand(rng, 2)
2-element Vector{Float64}:
 0.32597672886359486
 0.5490511363155669

julia> x1 == x2
true
```
