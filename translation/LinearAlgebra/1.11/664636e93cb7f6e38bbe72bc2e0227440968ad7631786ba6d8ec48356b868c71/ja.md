```
transpose(A)
```

遅延転置。返されたオブジェクトを変更すると、適切に `A` が変更されます。しばしば、しかし常にではなく、`Transpose(A)` を返します。ここで `Transpose` は遅延転置ラッパーです。この操作は再帰的であることに注意してください。

この操作は線形代数の使用を意図しています - 一般的なデータ操作については [`permutedims`](@ref Base.permutedims) を参照してください。これは再帰的ではありません。

# 例

```jldoctest
julia> A = [3 2; 0 0]
2×2 Matrix{Int64}:
 3  2
 0  0

julia> B = transpose(A)
2×2 transpose(::Matrix{Int64}) with eltype Int64:
 3  0
 2  0

julia> B isa Transpose
true

julia> transpose(B) === A # 転置の転置は親をアンラップします
true

julia> Transpose(B) # ただし、コンストラクタは常にその引数をラップします
2×2 transpose(transpose(::Matrix{Int64})) with eltype Int64:
 3  2
 0  0

julia> B[1,2] = 4; # Bを変更するとAも自動的に変更されます

julia> A
2×2 Matrix{Int64}:
 3  2
 4  0
```

複素行列の場合、`adjoint` 操作は共役転置に相当します。

```jldoctest
julia> A = reshape([Complex(x, x) for x in 1:4], 2, 2)
2×2 Matrix{Complex{Int64}}:
 1+1im  3+3im
 2+2im  4+4im

julia> adjoint(A) == conj(transpose(A))
true
```

`AbstractVector` の `transpose` は行ベクトルです：

```jldoctest
julia> v = [1,2,3]
3-element Vector{Int64}:
 1
 2
 3

julia> transpose(v) # 行ベクトルを返します
1×3 transpose(::Vector{Int64}) with eltype Int64:
 1  2  3

julia> transpose(v) * v # ドット積を計算します
14
```

行列の行列の場合、個々のブロックは再帰的に操作されます：

```jldoctest
julia> C = [1 3; 2 4]
2×2 Matrix{Int64}:
 1  3
 2  4

julia> D = reshape([C, 2C, 3C, 4C], 2, 2) # ブロック行列を構築します
2×2 Matrix{Matrix{Int64}}:
 [1 3; 2 4]  [3 9; 6 12]
 [2 6; 4 8]  [4 12; 8 16]

julia> transpose(D) # ブロックは再帰的に転置されます
2×2 transpose(::Matrix{Matrix{Int64}}) with eltype Transpose{Int64, Matrix{Int64}}:
 [1 2; 3 4]   [2 4; 6 8]
 [3 6; 9 12]  [4 8; 12 16]
```
