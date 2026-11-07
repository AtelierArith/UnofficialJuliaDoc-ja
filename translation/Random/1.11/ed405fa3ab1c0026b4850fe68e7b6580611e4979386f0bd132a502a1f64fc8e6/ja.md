```julia
randsubseq([rng=default_rng(),] A, p) -> Vector
```

与えられた配列 `A` のランダムな部分列を返します。`A` の各要素は、独立に確率 `p` で（順序を保って）含まれます。（計算量は `p*length(A)` に対して線形なので、`p` が小さく、`A` が大きい場合でも効率的です。）厳密には、この処理は `A` の「ベルヌーイサンプリング」と呼ばれます。

# Examples

```jldoctest
julia> randsubseq(Xoshiro(123), 1:8, 0.3)
2-element Vector{Int64}:
 4
 7
```
