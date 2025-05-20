```
isbanded(A::AbstractMatrix, kl::Integer, ku::Integer) -> Bool
```

`A`が`kl`番目の上対角線から始まる下バンド幅と`ku`番目の上対角線を通る上バンド幅を持つかどうかをテストします。

# 例

```jldoctest
julia> a = [1 2; 2 -1]
2×2 Matrix{Int64}:
 1   2
 2  -1

julia> LinearAlgebra.isbanded(a, 0, 0)
false

julia> LinearAlgebra.isbanded(a, -1, 1)
true

julia> b = [1 0; -im -1] # 下バイジアゴナル
2×2 Matrix{Complex{Int64}}:
 1+0im   0+0im
 0-1im  -1+0im

julia> LinearAlgebra.isbanded(b, 0, 0)
false

julia> LinearAlgebra.isbanded(b, -1, 0)
true
```
