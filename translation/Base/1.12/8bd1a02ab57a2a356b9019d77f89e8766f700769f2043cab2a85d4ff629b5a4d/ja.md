```julia
sortslices(A; dims, alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)
```

配列 `A` のスライスをソートします。必須のキーワード引数 `dims` は整数または整数のタプルでなければなりません。これは、スライスがソートされる次元を指定します。

例えば、`A` が行列の場合、`dims=1` は行をソートし、`dims=2` は列をソートします。1次元スライスに対するデフォルトの比較関数は、辞書式にソートされることに注意してください。

残りのキーワード引数については、[`sort!`](@ref) のドキュメントを参照してください。

# 例

```jldoctest
julia> sortslices([7 3 5; -1 6 4; 9 -2 8], dims=1) # 行をソート
3×3 Matrix{Int64}:
 -1   6  4
  7   3  5
  9  -2  8

julia> sortslices([7 3 5; -1 6 4; 9 -2 8], dims=1, lt=(x,y)->isless(x[2],y[2]))
3×3 Matrix{Int64}:
  9  -2  8
  7   3  5
 -1   6  4

julia> sortslices([7 3 5; -1 6 4; 9 -2 8], dims=1, rev=true)
3×3 Matrix{Int64}:
  9  -2  8
  7   3  5
 -1   6  4

julia> sortslices([7 3 5; 6 -1 -4; 9 -2 8], dims=2) # 列をソート
3×3 Matrix{Int64}:
  3   5  7
 -1  -4  6
 -2   8  9

julia> sortslices([7 3 5; 6 -1 -4; 9 -2 8], dims=2, alg=InsertionSort, lt=(x,y)->isless(x[2],y[2]))
3×3 Matrix{Int64}:
  5   3  7
 -4  -1  6
  8  -2  9

julia> sortslices([7 3 5; 6 -1 -4; 9 -2 8], dims=2, rev=true)
3×3 Matrix{Int64}:
 7   5   3
 6  -4  -1
 9   8  -2
```

# 高次元

`sortslices` は高次元にも自然に拡張されます。例えば、`A` が 2x2x2 の配列である場合、`sortslices(A, dims=3)` は3次元内のスライスをソートし、2x2 のスライス `A[:, :, 1]` と `A[:, :, 2]` を比較関数に渡します。高次元スライスにはデフォルトの順序はありませんが、`by` または `lt` のキーワード引数を使用してそのような順序を指定できます。

`dims` がタプルの場合、`dims` 内の次元の順序は重要であり、スライスの線形順序を指定します。例えば、`A` が三次元で `dims` が `(1, 2)` の場合、最初の2つの次元の順序が再配置され、残りの3次元のスライスがソートされます。代わりに `dims` が `(2, 1)` の場合、同じスライスが取られますが、結果の順序は行優先になります。

# 高次元の例

```julia
julia> A = [4 3; 2 1 ;;; 'A' 'B'; 'C' 'D']
2×2×2 Array{Any, 3}:
[:, :, 1] =
 4  3
 2  1

[:, :, 2] =
 'A'  'B'
 'C'  'D'

julia> sortslices(A, dims=(1,2))
2×2×2 Array{Any, 3}:
[:, :, 1] =
 1  3
 2  4

[:, :, 2] =
 'D'  'B'
 'C'  'A'

julia> sortslices(A, dims=(2,1))
2×2×2 Array{Any, 3}:
[:, :, 1] =
 1  2
 3  4

[:, :, 2] =
 'D'  'C'
 'B'  'A'

julia> sortslices(reshape([5; 4; 3; 2; 1], (1,1,5)), dims=3, by=x->x[1,1])
1×1×5 Array{Int64, 3}:
[:, :, 1] =
 1

[:, :, 2] =
 2

[:, :, 3] =
 3

[:, :, 4] =
 4

[:, :, 5] =
 5
```
