```
lu(A::AbstractSparseMatrixCSC; check = true, q = nothing, control = get_umfpack_control()) -> F::UmfpackLU
```

スパース行列 `A` のLU因子分解を計算します。

実数または複素数要素型のスパース `A` の場合、`F` の戻り値の型は `UmfpackLU{Tv, Ti}` であり、`Tv` は [`Float64`](@ref) または `ComplexF64` でそれぞれ、`Ti` は整数型（[`Int32`](@ref) または [`Int64`](@ref)）です。

`check = true` の場合、分解が失敗した場合はエラーがスローされます。`check = false` の場合、分解の有効性を確認する責任（[`issuccess`](@ref) を介して）はユーザーにあります。

置換 `q` は置換ベクトルまたは `nothing` である可能性があります。置換ベクトルが提供されない場合や `q` が `nothing` の場合、UMFPACKのデフォルトが使用されます。置換がゼロベースでない場合、ゼロベースのコピーが作成されます。

`control` ベクトルは、UMFPACKのためのJulia SparseArraysパッケージのデフォルト設定にデフォルトで設定されます（注：これは反復精度を無効にするためにUMFPACKのデフォルトから修正されています）が、`UMFPACK_CONTROL` の長さのベクトルを渡すことで変更できます。可能な設定についてはUMFPACKマニュアルを参照してください。たとえば、反復精度を再有効にするには：

```
umfpack_control = SparseArrays.UMFPACK.get_umfpack_control(Float64, Int64) # Float64スパース行列のためのJuliaデフォルト設定を読み取る
SparseArrays.UMFPACK.show_umf_ctrl(umfpack_control) # オプション - 値を表示
umfpack_control[SparseArrays.UMFPACK.JL_UMFPACK_IRSTEP] = 2.0 # 反復精度を再有効にする（2はUMFPACKのデフォルトの最大反復精度ステップ）

Alu = lu(A; control = umfpack_control)
x = Alu \ b   # Ax = bを解く、UMFPACKの反復精度を含む
```

因子分解 `F` の個々のコンポーネントにはインデックスを使用してアクセスできます：

| コンポーネント | 説明                     |
|:------- |:---------------------- |
| `L`     | `LU` の下三角部分 `L`        |
| `U`     | `LU` の上三角部分 `U`        |
| `p`     | 右置換 `Vector`           |
| `q`     | 左置換 `Vector`           |
| `Rs`    | スケーリングファクターの `Vector`  |
| `:`     | `(L,U,p,q,Rs)` コンポーネント |

`F` と `A` の関係は次の通りです。

`F.L*F.U == (F.Rs .* A)[F.p, F.q]`

`F` はさらに以下の関数をサポートしています：

  * [`\`](@ref)
  * [`det`](@ref)

また [`lu!`](@ref) も参照してください。

!!! note
    `lu(A::AbstractSparseMatrixCSC)` は、[SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse) の一部であるUMFPACK[^ACM832]ライブラリを使用します。このライブラリは、[`Float64`](@ref) または `ComplexF64` 要素を持つスパース行列のみをサポートしているため、`lu` は `A` を `SparseMatrixCSC{Float64}` または `SparseMatrixCSC{ComplexF64}` 型のコピーに変換します。


[^ACM832]: Davis, Timothy A. (2004b). Algorithm 832: UMFPACK V4.3–-an Unsymmetric-Pattern Multifrontal Method. ACM Trans. Math. Softw., 30(2), 196–199. [doi:10.1145/992200.992206](https://doi.org/10.1145/992200.992206)
