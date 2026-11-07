```julia
sortslices(A; dims, alg::Algorithm=DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Ordering=Forward)
```

配列 `A` のスライスをソートします。必須のキーワード引数 `dims` には、整数または整数のタプルを指定します。これは、スライスをソートする対象の次元を指定します。

たとえば、`A` が行列の場合、`dims=1` は行を、`dims=2` は列をソートします。1 次元スライスに対するデフォルトの比較関数は、辞書順でソートすることに注意してください。

その他のキーワード引数については、[`sort!`](@ref) のドキュメントを参照してください。

# Examples

```jldoctest
julia> sortslices([7 3 5; -1 6 4; 9 -2 8], dims=1) # Sort rows
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

julia> sortslices([7 3 5; 6 -1 -4; 9 -2 8], dims=2) # Sort columns
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

# Higher dimensions

`sortslices` は高次元にも自然に拡張できます。たとえば、`A` が 2x2x2 の配列の場合、`sortslices(A, dims=3)` は第 3 次元に沿ってスライスをソートし、2x2 のスライス `A[:, :, 1]` と `A[:, :, 2]` を比較関数に渡します。高次元スライスにはデフォルトの順序がありませんが、`by` または `lt` キーワード引数を使って順序を指定できます。

`dims` がタプルの場合、`dims` 内の次元の順序が重要であり、スライスの線形順序を指定します。たとえば、`A` が 3 次元で、`dims` が `(1, 2)` の場合、残りの第 3 次元のスライスがソートされるように、最初の 2 次元の順序が並べ替えられます。代わりに `dims` が `(2, 1)` の場合も同じスライスが対象になりますが、結果は行優先の順序になります。

# Higher dimensional examples

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
