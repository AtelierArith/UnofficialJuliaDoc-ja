```
UpperHessenberg(A::AbstractMatrix)
```

行列 `A` の `UpperHessenberg` ビューを構築します。最初の副対角線の下にある `A` のエントリは無視されます。

!!! compat "Julia 1.3"
    この型は Julia 1.3 で追加されました。


`H \ b`、`det(H)`、および類似の効率的なアルゴリズムが実装されています。

任意の行列を類似の上部ヘッセンベルク行列に因数分解する [`hessenberg`](@ref) 関数も参照してください。

`F::Hessenberg` が因数分解オブジェクトである場合、ユニタリ行列は `F.Q` でアクセスでき、ヘッセンベルク行列は `F.H` でアクセスできます。`Q` が抽出されると、結果の型は `HessenbergQ` オブジェクトになり、[`convert(Array, _)`](@ref)（または短縮形の `Array(_)`）を使って通常の行列に変換できます。

分解を反復すると、因子 `F.Q` と `F.H` が得られます。

# 例

```jldoctest
julia> A = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16]
4×4 Matrix{Int64}:
  1   2   3   4
  5   6   7   8
  9  10  11  12
 13  14  15  16

julia> UpperHessenberg(A)
4×4 UpperHessenberg{Int64, Matrix{Int64}}:
 1   2   3   4
 5   6   7   8
 ⋅  10  11  12
 ⋅   ⋅  15  16
```
