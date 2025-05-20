```
kron(A, B)
```

2つのベクトル、行列、または数のクロネッカー積を計算します。

実ベクトル `v` と `w` に対して、クロネッカー積は外積に関連しており、`kron(v,w) == vec(w * transpose(v))` または `w * transpose(v) == reshape(kron(v,w), (length(w), length(v)))` となります。これらの式の左側と右側で `v` と `w` の順序が異なることに注意してください（列優先ストレージのため）。複素ベクトルの場合、外積 `w * v'` も `v` の共役によって異なります。

# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> B = [im 1; 1 -im]
2×2 Matrix{Complex{Int64}}:
 0+1im  1+0im
 1+0im  0-1im

julia> kron(A, B)
4×4 Matrix{Complex{Int64}}:
 0+1im  1+0im  0+2im  2+0im
 1+0im  0-1im  2+0im  0-2im
 0+3im  3+0im  0+4im  4+0im
 3+0im  0-3im  4+0im  0-4im

julia> v = [1, 2]; w = [3, 4, 5];

julia> w*transpose(v)
3×2 Matrix{Int64}:
 3   6
 4   8
 5  10

julia> reshape(kron(v,w), (length(w), length(v)))
3×2 Matrix{Int64}:
 3   6
 4   8
 5  10
```
