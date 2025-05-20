```
permutedims(A::AbstractArray, perm)
permutedims(A::AbstractMatrix)
```

配列 `A` の次元（軸）を入れ替えます。`perm` は、`ndims(A)` の整数のタプルまたはベクターで、入れ替えの順序を指定します。

`A` が 2 次元配列（[`AbstractMatrix`](@ref)）の場合、`perm` はデフォルトで `(2,1)` となり、`A` の 2 つの軸（行と列）を入れ替えます。これは、操作が再帰的でないため、特に数値以外の値の配列（再帰的な `transpose` はエラーを引き起こす）や線形演算子を表さない 2 次元配列に対して便利です。

1 次元配列については、[`permutedims(v::AbstractVector)`](@ref) を参照してください。これは 1 行の「行列」を返します。

他にも [`permutedims!`](@ref)、[`PermutedDimsArray`](@ref)、[`transpose`](@ref)、[`invperm`](@ref) を参照してください。

# 例

## 2 次元配列:

`transpose` とは異なり、`permutedims` は文字列などの任意の非数値要素の 2 次元配列の行と列を入れ替えるために使用できます。

```jldoctest
julia> A = ["a" "b" "c"
            "d" "e" "f"]
2×3 Matrix{String}:
 "a"  "b"  "c"
 "d"  "e"  "f"

julia> permutedims(A)
3×2 Matrix{String}:
 "a"  "d"
 "b"  "e"
 "c"  "f"
```

また、`permutedims` は、要素が数値行列である行列に対して `transpose` とは異なる結果を生成します。

```jldoctest; setup = :(using LinearAlgebra)
julia> a = [1 2; 3 4];

julia> b = [5 6; 7 8];

julia> c = [9 10; 11 12];

julia> d = [13 14; 15 16];

julia> X = [[a] [b]; [c] [d]]
2×2 Matrix{Matrix{Int64}}:
 [1 2; 3 4]     [5 6; 7 8]
 [9 10; 11 12]  [13 14; 15 16]

julia> permutedims(X)
2×2 Matrix{Matrix{Int64}}:
 [1 2; 3 4]  [9 10; 11 12]
 [5 6; 7 8]  [13 14; 15 16]

julia> transpose(X)
2×2 transpose(::Matrix{Matrix{Int64}}) with eltype Transpose{Int64, Matrix{Int64}}:
 [1 3; 2 4]  [9 11; 10 12]
 [5 7; 6 8]  [13 15; 14 16]
```

## 多次元配列

```jldoctest
julia> A = reshape(Vector(1:8), (2,2,2))
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  3
 2  4

[:, :, 2] =
 5  7
 6  8

julia> perm = (3, 1, 2); # 最後の次元を最初に持ってくる

julia> B = permutedims(A, perm)
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  2
 5  6

[:, :, 2] =
 3  4
 7  8

julia> A == permutedims(B, invperm(perm)) # 逆順序
true
```

`B = permutedims(A, perm)` の各次元 `i` に対して、`A` の対応する次元は `perm[i]` になります。これは、等式 `size(B, i) == size(A, perm[i])` が成り立つことを意味します。

```jldoctest
julia> A = randn(5, 7, 11, 13);

julia> perm = [4, 1, 3, 2];

julia> B = permutedims(A, perm);

julia> size(B)
(13, 5, 11, 7)

julia> size(A)[perm] == ans
true
```
