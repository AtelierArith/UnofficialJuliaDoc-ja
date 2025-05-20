```
lu!(F::UmfpackLU, A::AbstractSparseMatrixCSC; check=true, reuse_symbolic=true, q=nothing) -> F::UmfpackLU
```

スパース行列 `A` のLU因子分解を計算し、既存のLU因子分解 `F` に保存されている符号的因子分解を再利用します。`reuse_symbolic` が false に設定されていない限り、スパース行列 `A` はLU因子分解 `F` を作成するために使用された行列と同一の非ゼロパターンを持っている必要があり、そうでない場合はエラーがスローされます。`A` と `F` のサイズが異なる場合、すべてのベクトルはそれに応じてサイズ変更されます。

`check = true` の場合、分解が失敗した場合にエラーがスローされます。`check = false` の場合、分解の有効性を確認する責任はユーザーにあります（[`issuccess`](@ref) を介して）。

置換 `q` は置換ベクトルまたは `nothing` である可能性があります。置換ベクトルが提供されない場合や `q` が `nothing` の場合、UMFPACK のデフォルトが使用されます。置換がゼロベースでない場合、ゼロベースのコピーが作成されます。

他にも [`lu`](@ref) を参照してください。

!!! note
    `lu!(F::UmfpackLU, A::AbstractSparseMatrixCSC)` は SuiteSparse の一部である UMFPACK ライブラリを使用します。このライブラリは [`Float64`](@ref) または `ComplexF64` 要素を持つスパース行列のみをサポートしているため、`lu!` は自動的にLU因子分解によって設定された型または適切な `SparseMatrixCSC{ComplexF64}` に型を変換します。


!!! compat "Julia 1.5"
    `UmfpackLU` の `lu!` は少なくとも Julia 1.5 を必要とします。


# 例

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
