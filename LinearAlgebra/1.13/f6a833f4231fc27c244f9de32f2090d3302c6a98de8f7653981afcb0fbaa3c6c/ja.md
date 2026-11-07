```julia
Symmetric(A::AbstractMatrix, uplo::Symbol=:U)
```

行列 `A` の上三角部分（`uplo = :U` の場合）または下三角部分（`uplo = :L` の場合）のビュー `Symmetric` を構築します。

`Symmetric` ビューは、主に実対称行列で役立ちます。実対称行列では、`Symmetric` 型に対して、固有値問題などの専用アルゴリズムが利用できます。より一般には、エルミート行列 `A == A'` については [`Hermitian(A)`](@ref) も参照してください。これは実行列では `Symmetric` と実質的に同等ですが、複素行列にも有用です。（一方、複素 `Symmetric` 行列もサポートされていますが、専用アルゴリズムはほとんど、あるいはまったくありません。）

実行列の対称部分、またはより一般に実行列・複素行列 `A` のエルミート部分 `(A + A') / 2` を計算するには、[`hermitianpart`](@ref) を使用します。

対称ビューと共有される `A` の三角部分に対応する `uplo` シンボルは、関数 [`LinearAlgebra.uplo`](@ref) を使って取得できます。対称ビューから元の行列 `A` を取得するには、`parent` を使用します。

# Examples

```jldoctest
julia> A = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> Supper = Symmetric(A)
3×3 Symmetric{Int64, Matrix{Int64}}:
 1  2  3
 2  5  6
 3  6  9

julia> Slower = Symmetric(A, :L)
3×3 Symmetric{Int64, Matrix{Int64}}:
 1  4  7
 4  5  8
 7  8  9

julia> hermitianpart(A)
3×3 Hermitian{Float64, Matrix{Float64}}:
 1.0  3.0  5.0
 3.0  5.0  7.0
 5.0  7.0  9.0
```

`Supper` は、`A` 自体が対称でない限り（たとえば `A == transpose(A)` の場合）、`Slower` と等しくならないことに注意してください。
