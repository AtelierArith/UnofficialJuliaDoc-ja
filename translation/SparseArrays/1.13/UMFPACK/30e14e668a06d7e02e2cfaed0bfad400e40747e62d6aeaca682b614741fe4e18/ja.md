```julia
lu(A::AbstractSparseMatrixCSC; check = true, q = nothing, control = get_umfpack_control()) -> F::UmfpackLU
```

疎行列 `A` の LU 分解を計算します。

実数または複素数の要素型を持つ疎行列 `A` に対して、`F` の戻り値の型は `UmfpackLU{Tv, Ti}` です。ここで、`Tv` はそれぞれ [`Float64`](@ref) または `ComplexF64` であり、`Ti` は整数型（[`Int32`](@ref) または [`Int64`](@ref)）です。

`check = true` の場合、分解に失敗するとエラーがスローされます。`check = false` の場合、分解が有効かどうか（[`issuccess`](@ref) を使って）確認する責任はユーザーにあります。

置換 `q` には、置換ベクトルまたは `nothing` を指定できます。置換ベクトルが指定されていない場合、または `q` が `nothing` の場合は、UMFPACK のデフォルトが使われます。置換が 0 始まりでない場合は、0 始まりのコピーが作成されます。

`control` ベクトルのデフォルト値は、Julia の SparseArrays パッケージにおける UMFPACK のデフォルト設定です（注：反復改良を無効にするため、UMFPACK のデフォルトから変更されています）。長さ `UMFPACK_CONTROL` のベクトルを渡すことで変更できます。設定可能な値については UMFPACK のマニュアルを参照してください。たとえば、反復改良を再び有効にするには、次のようにします。

```julia
umfpack_control = SparseArrays.UMFPACK.get_umfpack_control(Float64, Int64) # read Julia default configuration for a Float64 sparse matrix
SparseArrays.UMFPACK.show_umf_ctrl(umfpack_control) # optional - display values
umfpack_control[SparseArrays.UMFPACK.JL_UMFPACK_IRSTEP] = 2.0 # reenable iterative refinement (2 is UMFPACK default max iterative refinement steps)

Alu = lu(A; control = umfpack_control)
x = Alu \ b   # solve Ax = b, including UMFPACK iterative refinement
```

分解 `F` の各成分には、インデックス指定でアクセスできます。

| 成分   | 説明                 |
|:---- |:------------------ |
| `L`  | `LU` の `L`（三角行列）部分 |
| `U`  | `LU` の `U`（三角行列）部分 |
| `p`  | 右側の置換 `Vector`     |
| `q`  | 左側の置換 `Vector`     |
| `Rs` | スケーリング係数の `Vector` |
| `:`  | 成分の `(L,U,p,q,Rs)` |

`F` と `A` の関係は次のとおりです。

`F.L*F.U == (F.Rs .* A)[F.p, F.q]`

`F` は、さらに次の関数をサポートします。

  * [`\`](@ref)
  * [`det`](@ref)

[`lu!`](@ref) も参照してください。

!!! note
    `lu(A::AbstractSparseMatrixCSC)` は、[SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse) の一部である UMFPACK[^ACM832] ライブラリを使用します。このライブラリがサポートする疎行列の要素型は [`Float64`](@ref) または `ComplexF64` のみです。そのため、`lu` は `A` を、適切な型である `SparseMatrixCSC{Float64}` または `SparseMatrixCSC{ComplexF64}` のコピーに変換します。


[^ACM832]: Davis, Timothy A. (2004b). Algorithm 832: UMFPACK V4.3—an Unsymmetric-Pattern Multifrontal Method. ACM Trans. Math. Softw., 30(2), 196–199. [doi:10.1145/992200.992206](https://doi.org/10.1145/992200.992206)
