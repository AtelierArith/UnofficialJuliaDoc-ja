```@meta
EditURL = "https://github.com/JuliaSparse/SparseArrays.jl/blob/master/docs/src/index.md"
```

# Sparse Arrays

```@meta
DocTestSetup = :(using SparseArrays, LinearAlgebra)
```

Juliaは、`SparseArrays`標準ライブラリモジュールでスパースベクトルと[sparse matrices](https://en.wikipedia.org/wiki/Sparse_matrix)をサポートしています。スパース配列は、ゼロが十分に含まれている配列であり、特別なデータ構造に格納することで、密な配列と比較して、スペースと実行時間の節約が可能になります。

異なるスパースストレージタイプ、マルチディメンショナルスパース配列などを実装する外部パッケージは、[Noteworthy External Sparse Packages](@ref) で見つけることができます。

## [Compressed Sparse Column (CSC) Sparse Matrix Storage](@id man-csc)

Juliaでは、スパース行列は[Compressed Sparse Column (CSC) format](https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_column_.28CSC_or_CCS.29)に格納されます。Juliaのスパース行列は[`SparseMatrixCSC{Tv,Ti}`](@ref)という型を持ち、ここで`Tv`は格納される値の型、`Ti`は列ポインタと行インデックスを格納するための整数型です。`SparseMatrixCSC`の内部表現は次のようになります：

```julia
struct SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
    m::Int                  # Number of rows
    n::Int                  # Number of columns
    colptr::Vector{Ti}      # Column j is in colptr[j]:(colptr[j+1]-1)
    rowval::Vector{Ti}      # Row indices of stored values
    nzval::Vector{Tv}       # Stored values, typically nonzeros
end
```

圧縮スパース列ストレージは、スパース行列の列内の要素に簡単かつ迅速にアクセスできるようにしますが、行によるスパース行列へのアクセスはかなり遅くなります。CSC構造内で、以前に保存されていなかったエントリを1つずつ挿入するような操作は遅くなる傾向があります。これは、挿入ポイントを超えるスパース行列のすべての要素を1つずつ移動させる必要があるためです。

すべてのスパース行列に関する操作は、パフォーマンスを向上させるためにCSCデータ構造を活用し、高コストの操作を回避するように慎重に実装されています。

CSC形式のデータが他のアプリケーションやライブラリからある場合、Juliaにインポートする際は1ベースのインデックスを使用することを確認してください。各列の行インデックスはソートされている必要があり、そうでない場合、行列は正しく表示されません。`SparseMatrixCSC`オブジェクトにソートされていない行インデックスが含まれている場合、ソートする簡単な方法はダブルトランスポーズを行うことです。トランスポーズ操作は遅延されるため、各トランスポーズを具現化するためにコピーを作成してください。

一部のアプリケーションでは、`SparseMatrixCSC`に明示的なゼロ値を格納することが便利です。これらは`Base`の関数によって受け入れられます（ただし、変更操作で保持される保証はありません）。このように明示的に格納されたゼロは、多くのルーチンによって構造的な非ゼロとして扱われます。[`nnz`](@ref)関数は、構造的でないゼロを含むスパースデータ構造に明示的に格納された要素の数を返します。正確な数の数値非ゼロをカウントするには、[`count(!iszero, x)`](@ref)を使用してください。これはスパース行列のすべての格納された要素を検査します。[`dropzeros`](@ref)およびインプレースの[`dropzeros!`](@ref)は、スパース行列から格納されたゼロを削除するために使用できます。

```jldoctest
julia> A = sparse([1, 1, 2, 3], [1, 3, 2, 3], [0, 1, 2, 0])
3×3 SparseMatrixCSC{Int64, Int64} with 4 stored entries:
 0  ⋅  1
 ⋅  2  ⋅
 ⋅  ⋅  0

julia> dropzeros(A)
3×3 SparseMatrixCSC{Int64, Int64} with 2 stored entries:
 ⋅  ⋅  1
 ⋅  2  ⋅
 ⋅  ⋅  ⋅
```

## Sparse Vector Storage

スパースベクトルは、スパース行列の圧縮スパース列形式に近い形で保存されます。Juliaでは、スパースベクトルは型 [`SparseVector{Tv,Ti}`](@ref) を持ち、ここで `Tv` は保存される値の型、`Ti` はインデックスの整数型です。内部表現は次のようになります：

```julia
struct SparseVector{Tv,Ti<:Integer} <: AbstractSparseVector{Tv,Ti}
    n::Int              # Length of the sparse vector
    nzind::Vector{Ti}   # Indices of stored values
    nzval::Vector{Tv}   # Stored values, typically nonzeros
end
```

[`SparseMatrixCSC`](@ref)について、`SparseVector`型は明示的に保存されたゼロも含むことができます。（参照：[Sparse Matrix Storage](@ref man-csc)。）

## Sparse Vector and Matrix Constructors

スパース配列を作成する最も簡単な方法は、Juliaが密な配列を扱うために提供する[`zeros`](@ref)関数に相当する関数を使用することです。代わりにスパース配列を生成するには、同じ名前に`sp`プレフィックスを付けて使用できます：

```jldoctest
julia> spzeros(3)
3-element SparseVector{Float64, Int64} with 0 stored entries
```

[`sparse`](@ref) 関数は、スパース配列を構築する便利な方法です。たとえば、スパース行列を構築するために、行インデックスのベクトル `I`、列インデックスのベクトル `J`、および保存された値のベクトル `V` を入力できます（これは [COO (coordinate) format](https://en.wikipedia.org/wiki/Sparse_matrix#Coordinate_list_.28COO.29) とも呼ばれます）。`sparse(I,J,V)` は、`S[I[k], J[k]] = V[k]` となるスパース行列を構築します。等価なスパースベクトルコンストラクタは [`sparsevec`](@ref) で、（行）インデックスベクトル `I` と保存された値のベクトル `V` を取り、`R[I[k]] = V[k]` となるスパースベクトル `R` を構築します。

```jldoctest sparse_function
julia> I = [1, 4, 3, 5]; J = [4, 7, 18, 9]; V = [1, 2, -5, 3];

julia> S = sparse(I,J,V)
5×18 SparseMatrixCSC{Int64, Int64} with 4 stored entries:
⎡⠀⠈⠀⠀⠀⠀⠀⠀⢀⎤
⎣⠀⠀⠀⠂⡀⠀⠀⠀⠀⎦

julia> R = sparsevec(I,V)
5-element SparseVector{Int64, Int64} with 4 stored entries:
  [1]  =  1
  [3]  =  -5
  [4]  =  2
  [5]  =  3
```

[`sparse`](@ref) および [`sparsevec`](@ref) 関数の逆は [`findnz`](@ref) であり、これはスパース配列を作成するために使用された入力（ゼロに等しい保存されたエントリを含む）を取得します。 [`findall(!iszero, x)`](@ref) は、`x` の非ゼロエントリのカーテシアンインデックスを返します（ゼロに等しい保存されたエントリは含まれません）。

```jldoctest sparse_function
julia> findnz(S)
([1, 4, 5, 3], [4, 7, 9, 18], [1, 2, 3, -5])

julia> findall(!iszero, S)
4-element Vector{CartesianIndex{2}}:
 CartesianIndex(1, 4)
 CartesianIndex(4, 7)
 CartesianIndex(5, 9)
 CartesianIndex(3, 18)

julia> findnz(R)
([1, 3, 4, 5], [1, -5, 2, 3])

julia> findall(!iszero, R)
4-element Vector{Int64}:
 1
 3
 4
 5
```

別の方法として、[`sparse`](@ref) 関数を使用して、密な配列を疎な配列に変換することができます：

```jldoctest
julia> sparse(Matrix(1.0I, 5, 5))
5×5 SparseMatrixCSC{Float64, Int64} with 5 stored entries:
 1.0   ⋅    ⋅    ⋅    ⋅
  ⋅   1.0   ⋅    ⋅    ⋅
  ⋅    ⋅   1.0   ⋅    ⋅
  ⋅    ⋅    ⋅   1.0   ⋅
  ⋅    ⋅    ⋅    ⋅   1.0

julia> sparse([1.0, 0.0, 1.0])
3-element SparseVector{Float64, Int64} with 2 stored entries:
  [1]  =  1.0
  [3]  =  1.0
```

他の方向に進むには、[`Array`](@ref) コンストラクタを使用できます。[`issparse`](@ref) 関数は、行列がスパースであるかどうかを照会するために使用できます。

```jldoctest
julia> issparse(spzeros(5))
true
```

## Sparse matrix operations

Arithmetic operations on sparse matrices also work as they do on dense matrices. Indexing of, assignment into, and concatenation of sparse matrices work in the same way as dense matrices. Indexing operations, especially assignment, are expensive, when carried out one element at a time. In many cases it may be better to convert the sparse matrix into `(I,J,V)` format using [`findnz`](@ref), manipulate the values or the structure in the dense vectors `(I,J,V)`, and then reconstruct the sparse matrix.

## Correspondence of dense and sparse methods

次の表は、スパース行列の組み込みメソッドと、それに対応する密行列タイプのメソッドとの対応関係を示しています。一般に、スパース行列を生成するメソッドは、密行列の対応するメソッドとは異なり、結果として得られる行列が指定されたスパース行列 `S` と同じスパースパターンに従うか、または結果として得られるスパース行列が密度 `d` を持つこと、すなわち各行列要素が非ゼロである確率が `d` であることを意味します。

詳細は、標準ライブラリリファレンスの [Sparse Vectors and Matrices](@ref stdlib-sparse-arrays) セクションにあります。

| Sparse                       | Dense                    | Description                                                                                                                                          |
|:---------------------------- |:------------------------ |:---------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`spzeros(m,n)`](@ref)       | [`zeros(m,n)`](@ref)     | Creates a *m*-by-*n* matrix of zeros. ([`spzeros(m,n)`](@ref) is empty.)                                                                             |
| [`sparse(I,n,n)`](@ref)      | [`Matrix(I,n,n)`](@ref)  | Creates a *n*-by-*n* identity matrix.                                                                                                                |
| [`sparse(A)`](@ref)          | [`Array(S)`](@ref)       | Interconverts between dense and sparse formats.                                                                                                      |
| [`sprand(m,n,d)`](@ref)      | [`rand(m,n)`](@ref)      | Creates a *m*-by-*n* random matrix (of density *d*) with iid non-zero elements distributed uniformly on the half-open interval $[0, 1)$.             |
| [`sprandn(m,n,d)`](@ref)     | [`randn(m,n)`](@ref)     | Creates a *m*-by-*n* random matrix (of density *d*) with iid non-zero elements distributed according to the standard normal (Gaussian) distribution. |
| [`sprandn(rng,m,n,d)`](@ref) | [`randn(rng,m,n)`](@ref) | Creates a *m*-by-*n* random matrix (of density *d*) with iid non-zero elements generated with the `rng` random number generator                      |

## [Sparse Linear Algebra](@id stdlib-sparse-linalg)

スパース行列ソルバーは、[SuiteSparse](http://suitesparse.com) から関数を呼び出します。以下の因子分解が利用可能です：

| Type                | Description                      |
|:------------------- |:-------------------------------- |
| `CHOLMOD.Factor`    | Cholesky and LDLt factorizations |
| `UMFPACK.UmfpackLU` | LU factorization                 |
| `SPQR.QRSparse`     | QR factorization                 |

これらの因数分解は、[Sparse Linear Algebra API section](@ref stdlib-sparse-linalg-api)でより詳細に説明されています。

1. [`cholesky`](@ref SparseArrays.CHOLMOD.cholesky)
2. [`ldlt`](@ref SparseArrays.CHOLMOD.ldlt)
3. [`lu`](@ref SparseArrays.UMFPACK.lu)
4. [`qr`](@ref SparseArrays.SPQR.qr)

```@meta
DocTestSetup = nothing
```

# [SparseArrays API](@id stdlib-sparse-arrays)

```@docs
SparseArrays.AbstractSparseArray
SparseArrays.AbstractSparseVector
SparseArrays.AbstractSparseMatrix
SparseArrays.SparseVector
SparseArrays.SparseMatrixCSC
SparseArrays.sparse
SparseArrays.sparse!
SparseArrays.sparsevec
Base.similar(::SparseArrays.AbstractSparseMatrixCSC, ::Type)
SparseArrays.issparse
SparseArrays.nnz
SparseArrays.findnz
SparseArrays.spzeros
SparseArrays.spzeros!
SparseArrays.spdiagm
SparseArrays.sparse_hcat
SparseArrays.sparse_vcat
SparseArrays.sparse_hvcat
SparseArrays.blockdiag
SparseArrays.sprand
SparseArrays.sprandn
SparseArrays.nonzeros
SparseArrays.rowvals
SparseArrays.nzrange
SparseArrays.droptol!
SparseArrays.dropzeros!
SparseArrays.dropzeros
SparseArrays.permute
permute!{Tv, Ti, Tp <: Integer, Tq <: Integer}(::SparseMatrixCSC{Tv,Ti}, ::SparseMatrixCSC{Tv,Ti}, ::AbstractArray{Tp,1}, ::AbstractArray{Tq,1})
SparseArrays.halfperm!
SparseArrays.ftranspose!
```

```@meta
DocTestSetup = nothing
```

# [Sparse Linear Algebra API](@id stdlib-sparse-linalg-api)

```@docs; canonical=false
SparseArrays.CHOLMOD.cholesky
SparseArrays.CHOLMOD.cholesky!
SparseArrays.CHOLMOD.lowrankupdate
SparseArrays.CHOLMOD.lowrankupdate!
SparseArrays.CHOLMOD.lowrankdowndate
SparseArrays.CHOLMOD.lowrankdowndate!
SparseArrays.CHOLMOD.lowrankupdowndate!
SparseArrays.CHOLMOD.ldlt
SparseArrays.UMFPACK.lu
SparseArrays.SPQR.qr
```

```@meta
DocTestSetup = nothing
```

# Noteworthy External Sparse Packages

いくつかの他のJuliaパッケージは、言及すべきスパース行列の実装を提供しています：

1. [SuiteSparseGraphBLAS.jl](https://github.com/JuliaSparse/SuiteSparseGraphBLAS.jl) は、高速でマルチスレッド対応の SuiteSparse:GraphBLAS C ライブラリのラッパーです。CPU上では、通常これが最も高速なオプションであり、しばしば MKLSparse を大幅に上回ります。
2. [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) は、GPU スパース行列操作のための [CUSPARSE](https://docs.nvidia.com/cuda/cusparse/index.html) ライブラリを公開しています。
3. [SparseMatricesCSR.jl](https://github.com/gridap/SparseMatricesCSR.jl) は、圧縮スパース行（CSR）フォーマットのJuliaネイティブ実装を提供します。
4. [MKLSparse.jl](https://github.com/JuliaSparse/MKLSparse.jl) は、IntelのMKLライブラリを使用してスパースアレイのスパース-密行列演算を加速します。
5. [SparseArrayKit.jl](https://github.com/Jutho/SparseArrayKit.jl) は多次元スパース配列に利用可能です。
6. [LuxurySparse.jl](https://github.com/QuantumBFS/LuxurySparse.jl) は、静的スパース配列フォーマットと座標フォーマットを提供します。
7. [ExtendableSparse.jl](https://github.com/j-fu/ExtendableSparse.jl) は、新しい保存されたインデックスへの遅延アプローチを使用して、スパース行列への高速挿入を可能にします。
8. [Finch.jl](https://github.com/willow-ahrens/Finch.jl) は、ネイティブのJuliaを使用して、ミニテンソル言語とコンパイラを通じて、広範な多次元スパース配列フォーマットと操作をサポートします。COO、CSF、CSR、CSCなどのサポートに加え、ブロードキャスト、リデュースなどの操作やカスタム操作も可能です。

外部パッケージによるスパース直接ソルバー：

1. [KLU.jl](https://github.com/JuliaSparse/KLU.jl)
2. [Pardiso.jl](https://github.com/JuliaSparse/Pardiso.jl/)

外部パッケージは、固有システムおよび特異値分解の反復解法のためのソルバーを提供しています：

1. [ArnoldiMethods.jl](https://github.com/JuliaLinearAlgebra/ArnoldiMethod.jl)
2. [KrylovKit](https://github.com/Jutho/KrylovKit.jl)
3. [Arpack.jl](https://github.com/JuliaLinearAlgebra/Arpack.jl)

グラフを扱うための外部パッケージ:

1. [Graphs.jl](https://github.com/JuliaGraphs/Graphs.jl)
