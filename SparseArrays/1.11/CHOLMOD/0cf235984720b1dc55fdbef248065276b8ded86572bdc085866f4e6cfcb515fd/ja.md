```
ldlt(A::SparseMatrixCSC; shift = 0.0, check = true, perm=nothing) -> CHOLMOD.Factor
```

スパース行列 `A` の $LDL'$ 分解を計算します。`A` は [`SparseMatrixCSC`](@ref) または `SparseMatrixCSC` の [`Symmetric`](@ref)/[`Hermitian`](@ref) ビューでなければなりません。`A` が型タグを持っていなくても、対称またはエルミートである必要があります。フィル削減置換が使用されます。`F = ldlt(A)` は、方程式系 `A*x = b` を `F\b` で解くために最も頻繁に使用されます。返される分解オブジェクト `F` は、[`diag`](@ref)、[`det`](@ref)、[`logdet`](@ref)、および [`inv`](@ref) メソッドもサポートしています。`F` から個々の因子を `F.L` を使用して抽出できます。ただし、ピボッティングがデフォルトでオンになっているため、分解は内部的に `A == P'*L*D*L'*P` として表現され、置換行列 `P` が含まれます。`P` を考慮せずに単に `L` を使用すると、誤った結果が得られます。置換の影響を含めるためには、通常、`PtL = F.PtL`（`P'*L` の同等物）や `LtP = F.UP`（`L'*P` の同等物）などの「結合」因子を抽出する方が好ましいです。サポートされている因子の完全なリストは `:L, :PtL, :D, :UP, :U, :LD, :DU, :PtLD, :DUP` です。

`check = true` の場合、分解が失敗した場合はエラーがスローされます。`check = false` の場合、分解の有効性を確認する責任（[`issuccess`](@ref) を介して）はユーザーにあります。

オプションの `shift` キーワード引数を設定すると、`A` の代わりに `A+shift*I` の分解が計算されます。`perm` 引数が提供される場合、それは `1:size(A,1)` の置換であり、使用する順序を指定します（CHOLMOD のデフォルトの AMD 順序の代わりに）。

!!! note
    このメソッドは、[SuiteSparse](https://github.com/DrTimothyAldenDavis/SuiteSparse) の CHOLMOD[^ACM887][^DavisHager2009] ライブラリを使用しています。CHOLMOD は、単精度または倍精度の実数または複素数型のみをサポートしています。これらの要素型でない入力行列は、適切にこれらの型に変換されます。

    CHOLMOD の他の多くの関数はラップされていますが、`Base.SparseArrays.CHOLMOD` モジュールからはエクスポートされていません。

