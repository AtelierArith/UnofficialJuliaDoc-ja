```julia
hvncat(dim::Int, row_first, values...)
hvncat(dims::Tuple{Vararg{Int}}, row_first, values...)
hvncat(shape::Tuple{Vararg{Tuple}}, row_first, values...)
```

複数の `values` を、1 回の呼び出しで水平方向、垂直方向、および n 次元に連結します。

この関数は、ブロック行列構文で呼び出されます。第 1 引数には、タプルのタプルとして連結の形状を指定する方法（`hvcat` と同様）と、各軸に沿った要素数を指定する次元を渡す方法があります。いずれの場合も、出力の次元を決定するために使われます。`dims` 形式はより高性能で、連結操作において各軸に沿った要素数が等しい場合（例: [a b; c d;;; e f ; g h]）にデフォルトで使われます。各軸に沿った要素数が不均衡な場合（例: [a b ; c]）は、`shape` 形式が使われます。不均衡な構文では、追加の検証処理が必要です。`dim` 形式は、1 つの次元に沿った連結に特化した最適化です。`row_first` は、`values` の順序を指定します。`shape` の第 1 要素と第 2 要素の意味も、`row_first` に応じて入れ替わります。

# Examples

```jldoctest
julia> a, b, c, d, e, f = 1, 2, 3, 4, 5, 6
(1, 2, 3, 4, 5, 6)

julia> [a b c;;; d e f]
1×3×2 Array{Int64, 3}:
[:, :, 1] =
 1  2  3

[:, :, 2] =
 4  5  6

julia> hvncat((2,1,3), false, a,b,c,d,e,f)
2×1×3 Array{Int64, 3}:
[:, :, 1] =
 1
 2

[:, :, 2] =
 3
 4

[:, :, 3] =
 5
 6

julia> [a b;;; c d;;; e f]
1×2×3 Array{Int64, 3}:
[:, :, 1] =
 1  2

[:, :, 2] =
 3  4

[:, :, 3] =
 5  6

julia> hvncat(((3, 3), (3, 3), (6,)), true, a, b, c, d, e, f)
1×3×2 Array{Int64, 3}:
[:, :, 1] =
 1  2  3

[:, :, 2] =
 4  5  6
```

# Examples for construction of the arguments

```julia
[a b c ; d e f ;;;
 g h i ; j k l ;;;
 m n o ; p q r ;;;
 s t u ; v w x]
⇒ dims = (2, 3, 4)

[a b ; c ;;; d ;;;;]
 ___   _     _
 2     1     1 = elements in each row (2, 1, 1)
 _______     _
 3           1 = elements in each column (3, 1)
 _____________
 4             = elements in each 3d slice (4,)
 _____________
 4             = elements in each 4d slice (4,)
⇒ shape = ((2, 1, 1), (3, 1), (4,), (4,)) with `row_first` = true
```
