```julia
UpperHessenberg(A::AbstractMatrix)
```

行列 `A` の `UpperHessenberg` ビューを構築します。最初の副対角線より下にある `A` の要素は無視されます。

!!! compat "Julia 1.3"
    この型は Julia 1.3 で追加されました。


`H \ b`、`det(H)` などには、効率的なアルゴリズムが実装されています。

任意の行列を同様の上ヘッセンベルグ行列に分解する関数 [`hessenberg`](@ref) も参照してください。

`F::Hessenberg` が分解オブジェクトの場合、ユニタリ行列は `F.Q` で、ヘッセンベルグ行列は `F.H` で取得できます。`Q` を取り出すと、結果の型は `HessenbergQ` オブジェクトになります。これは [`convert(Array, _)`](@ref)（または簡潔な `Array(_)`）で通常の行列に変換できます。

分解を反復すると、因子 `F.Q` と `F.H` が生成されます。

# Examples

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
