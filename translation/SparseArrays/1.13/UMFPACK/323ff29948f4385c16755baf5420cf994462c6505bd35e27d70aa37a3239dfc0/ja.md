```julia
lu!(F::UmfpackLU, A::AbstractSparseMatrixCSC; check=true, reuse_symbolic=true, q=nothing) -> F::UmfpackLU
```

疎行列 `A` の LU 分解を計算します。このとき、既存の LU 分解 `F` のシンボリック分解を再利用します。`reuse_symbolic` が false に設定されていない限り、疎行列 `A` は、LU 分解 `F` の作成に使われた行列と同じ非ゼロパターンを持つ必要があります。そうでない場合はエラーが発生します。`A` と `F` のサイズが異なる場合、すべてのベクトルはそれに応じてサイズ変更されます。

`check = true` の場合、分解に失敗するとエラーが発生します。`check = false` の場合、分解が有効かどうかの確認（[`issuccess`](@ref) による）はユーザーの責任です。

置換 `q` には、置換ベクトルまたは `nothing` を指定できます。置換ベクトルが指定されていない場合、または `q` が `nothing` の場合は、UMFPACK のデフォルトが使われます。置換が 0 始まりでない場合は、0 始まりのコピーが作成されます。

関連項目: [`lu`](@ref)

!!! note
    `lu!(F::UmfpackLU, A::AbstractSparseMatrixCSC)` は、SuiteSparse に含まれる UMFPACK ライブラリを使用します。このライブラリがサポートする疎行列の要素型は [`Float64`](@ref) または `ComplexF64` のみです。そのため、`lu!` は、LU 分解または `SparseMatrixCSC{ComplexF64}` で設定された型に応じて、自動的に型を変換します。


!!! compat "Julia 1.5"
    `UmfpackLU` に対する `lu!` には、Julia 1.5 以降が必要です。


# Examples

```jldoctest
julia> A = sparse(Float64[1.0 2.0; 0.0 3.0]);

julia> F = lu(A);

julia> B = sparse(Float64[1.0 1.0; 0.0 1.0]);

julia> lu!(F, B);

julia> F \ ones(2)
2-element Vector{Float64}:
 0.0
 1.0
```
