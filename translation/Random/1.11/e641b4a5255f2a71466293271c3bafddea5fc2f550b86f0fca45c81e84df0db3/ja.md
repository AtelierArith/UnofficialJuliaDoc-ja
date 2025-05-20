```
randsubseq([rng=default_rng(),] A, p) -> Vector
```

与えられた配列 `A` のランダム部分列からなるベクターを返します。`A` の各要素は、独立した確率 `p` で（順序を保ったまま）含まれます。（複雑さは `p*length(A)` に対して線形であるため、この関数は `p` が小さく `A` が大きい場合でも効率的です。）技術的には、このプロセスは `A` の「ベルヌーイサンプリング」として知られています。

# 例

```jldoctest
julia> randsubseq(Xoshiro(123), 1:8, 0.3)
2-element Vector{Int64}:
 4
 7
```
