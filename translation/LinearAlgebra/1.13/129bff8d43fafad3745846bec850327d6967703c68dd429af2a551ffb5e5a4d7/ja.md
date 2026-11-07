```julia
kron(A, B)
```

2つのベクトル、行列、または数値のクロネッカー積を計算します。

実ベクトル `v` と `w` について、クロネッカー積は外積と `kron(v,w) == vec(w * transpose(v))` または `w * transpose(v) == reshape(kron(v,w), (length(w), length(v)))` の関係にあります。これらの式では、`v` と `w` の順序が左辺と右辺で異なることに注意してください（列優先の格納方式によるものです）。複素ベクトルの場合、外積 `w * v'` では、さらに `v` が複素共役になります。

# Examples

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
