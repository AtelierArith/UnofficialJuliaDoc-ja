```julia
permutedims(A::AbstractArray, perm)
permutedims(A::AbstractMatrix)
```

配列 `A` の次元（軸）を並べ替えます。`perm` は、並べ替えを指定する `ndims(A)` 整数のタプルまたはベクトルです。

`A` が2次元配列（[`AbstractMatrix`](@ref)）の場合、`perm` の既定値は `(2,1)` で、`A` の2つの軸（行と列）を入れ替えます。この操作は [`transpose`](@ref) と異なり、再帰的ではありません。そのため、数値以外の値を含む配列（再帰的な `transpose` ではエラーになる）や、線形作用素を表さない2次元配列に特に便利です。

1次元配列については、1行の「行列」を返す [`permutedims(v::AbstractVector)`](@ref) を参照してください。

関連項目: [`permutedims!`](@ref)、[`PermutedDimsArray`](@ref)、[`transpose`](@ref)、[`invperm`](@ref)。

# Examples

## 2d arrays:

`transpose` とは異なり、`permutedims` は、文字列など、数値以外の任意の要素を含む2次元配列の行と列を入れ替えるために使用できます。

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

また、要素自体が数値行列である行列では、`permutedims` は `transpose` とは異なる結果を生成します。

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

## Multi-dimensional arrays

```jldoctest
julia> A = reshape(Vector(1:8), (2,2,2))
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  3
 2  4

[:, :, 2] =
 5  7
 6  8

julia> perm = (3, 1, 2); # put the last dimension first

julia> B = permutedims(A, perm)
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  2
 5  6

[:, :, 2] =
 3  4
 7  8

julia> A == permutedims(B, invperm(perm)) # the inverse permutation
true
```

`B = permutedims(A, perm)` の各次元 `i` に対して、`A` の対応する次元は `perm[i]` になります。つまり、等式 `size(B, i) == size(A, perm[i])` が成り立ちます。

```jldoctest
julia> A = randn(5, 7, 11, 13);

julia> perm = [4, 1, 3, 2];

julia> B = permutedims(A, perm);

julia> size(B)
(13, 5, 11, 7)

julia> size(A)[perm] == ans
true
```
