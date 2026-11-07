```@meta
EditURL = "https://github.com/JuliaSparse/SparseArrays.jl/blob/master/docs/src/index.md"
```

# Sparse Arrays

```@meta
DocTestSetup = :(using SparseArrays, LinearAlgebra)
```

Julia は、`SparseArrays` 標準ライブラリモジュールで、疎ベクトルと [sparse matrices](https://en.wikipedia.org/wiki/Sparse_matrix) をサポートしています。疎配列とは、十分な数のゼロを含む配列です。密配列と比べて、専用のデータ構造に格納することで、メモリ使用量と実行時間を削減できます。

異なる疎データの格納形式や多次元疎配列などを実装する外部パッケージは、[Noteworthy External Sparse Packages](@ref) で確認できます。

## [Compressed Sparse Column (CSC) Sparse Matrix Storage](@id man-csc)

Julia では、疎行列は [Compressed Sparse Column (CSC) format](https://en.wikipedia.org/wiki/Sparse_matrix#Compressed_sparse_column_.28CSC_or_CCS.29) 形式で格納されます。Julia の疎行列の型は [`SparseMatrixCSC{Tv,Ti}`](@ref) で、`Tv` は格納する値の型、`Ti` は列ポインターと行インデックスの格納に使う整数型です。`SparseMatrixCSC` の内部表現は次のとおりです。

```julia
struct SparseMatrixCSC{Tv,Ti<:Integer} <: AbstractSparseMatrixCSC{Tv,Ti}
    m::Int                  # Number of rows
    n::Int                  # Number of columns
    colptr::Vector{Ti}      # Column j is in colptr[j]:(colptr[j+1]-1)
    rowval::Vector{Ti}      # Row indices of stored values
    nzval::Vector{Tv}       # Stored values, typically nonzeros
end
```

圧縮疎列（CSC）形式では、疎行列の列内の要素に簡単かつ高速にアクセスできます。一方、行を使ったアクセスはかなり遅くなります。CSC 構造に未格納の要素を一つずつ挿入するような操作は、一般に低速です。挿入位置より後ろにある疎行列の要素をすべて一つずつ移動する必要があるためです。

疎行列に対するすべての操作は、CSC データ構造を活用して性能を高め、高コストな処理を避けるよう、慎重に実装されています。

別のアプリケーションやライブラリから CSC 形式のデータを取り込みたい場合は、1 始まりのインデックスを使っていることを確認してください。各列の行インデックスはソートされている必要があります。ソートされていない場合、行列は正しく表示されません。`SparseMatrixCSC` オブジェクトの行インデックスがソートされていない場合、手早くソートする方法の一つは、転置を二度行うことです。転置操作は遅延評価されるため、それぞれの転置を実体化するにはコピーを作成してください。

用途によっては、`SparseMatrixCSC` に明示的なゼロ値を格納すると便利です。こうした値は `Base` の関数で受け付けられます（ただし、変更を伴う操作で保持される保証はありません）。明示的に格納されたゼロは、多くのルーチンで構造上の非ゼロ要素として扱われます。[`nnz`](@ref) 関数は、構造上のゼロも含め、疎データ構造に明示的に格納されている要素数を返します。数値としての非ゼロ要素数を正確に数えるには、疎行列に格納されたすべての要素を調べる [`count(!iszero, x)`](@ref) を使います。[`dropzeros`](@ref) と、そのインプレース版である [`dropzeros!`](@ref) を使うと、疎行列から格納済みのゼロを削除できます。

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

疎ベクトルは、疎行列の圧縮疎列形式に近い形式で格納されます。Julia の疎ベクトルの型は [`SparseVector{Tv,Ti}`](@ref) で、`Tv` は格納する値の型、`Ti` はインデックスに使う整数型です。内部表現は次のとおりです。

```julia
struct SparseVector{Tv,Ti<:Integer} <: AbstractSparseVector{Tv,Ti}
    n::Int              # Length of the sparse vector
    nzind::Vector{Ti}   # Indices of stored values
    nzval::Vector{Tv}   # Stored values, typically nonzeros
end
```

[`SparseMatrixCSC`](@ref) と同様に、`SparseVector` 型にも明示的に格納されたゼロを含めることができます（[Sparse Matrix Storage](@ref man-csc) を参照）。

## Sparse Vector and Matrix Constructors

疎配列を作成する最も簡単な方法は、Julia が密配列の操作用に提供する [`zeros`](@ref) 関数と同等の関数を使うことです。疎配列を作成するには、同じ名前の関数に `sp` 接頭辞を付けて使います。

```jldoctest
julia> spzeros(3)
3-element SparseVector{Float64, Int64} with 0 stored entries
```

[`sparse`](@ref) 関数は、疎配列の構築に便利です。たとえば、疎行列を作るには、行インデックスのベクトル `I`、列インデックスのベクトル `J`、格納する値のベクトル `V` を入力します（これは [COO (coordinate) format](https://en.wikipedia.org/wiki/Sparse_matrix#Coordinate_list_.28COO.29) とも呼ばれます）。`sparse(I,J,V)` は、`S[I[k], J[k]] = V[k]` を満たす疎行列を構築します。疎ベクトルを作る同等のコンストラクターは [`sparsevec`](@ref) です。これは、（行）インデックスのベクトル `I` と、格納する値のベクトル `V` を受け取り、`R[I[k]] = V[k]` を満たす疎ベクトル `R` を構築します。

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

[`sparse`](@ref) 関数と [`sparsevec`](@ref) 関数の逆操作にあたるのが [`findnz`](@ref) です。この関数は、疎配列の作成に使った入力（ゼロに等しい格納済み要素を含む）を取得します。[`findall(!iszero, x)`](@ref) は、`x` 内の非ゼロ要素のデカルトインデックスを返します（ゼロに等しい格納済み要素は含みません）。

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

疎配列を作成するもう一つの方法は、[`sparse`](@ref) 関数を使って密配列を疎配列に変換することです。

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

逆方向の変換には [`Array`](@ref) コンストラクターを使います。行列が疎行列かどうかを調べるには、[`issparse`](@ref) 関数を使います。

```jldoctest
julia> issparse(spzeros(5))
true
```

## Sparse matrix operations

疎行列に対する算術演算は、密行列の場合と同様に行えます。疎行列のインデックス参照、代入、連結も、密行列と同じ方法で行えます。ただし、インデックス操作、特に代入は、要素を一つずつ処理すると高コストになります。多くの場合、[`findnz`](@ref) を使って疎行列を `(I,J,V)` 形式に変換し、密ベクトル `(I,J,V)` 内の値や構造を操作してから、疎行列を再構築するほうが効率的です。

## Correspondence of dense and sparse methods

次の表は、疎行列に対する組み込みメソッドと、密行列型に対する対応メソッドを示しています。一般に、疎行列を生成するメソッドは、密行列用の対応メソッドとは異なり、指定した疎行列 `S` と同じ疎性パターンを持つ行列を生成するか、密度 `d` の疎行列を生成します。後者では、各行列要素が非ゼロである確率は `d` です。

詳細については、標準ライブラリリファレンスの [Sparse Vectors and Matrices](@ref stdlib-sparse-arrays) の節を参照してください。

| 疎行列                          | 密行列                      | 説明                                                                         |
|:---------------------------- |:------------------------ |:-------------------------------------------------------------------------- |
| [`spzeros(m,n)`](@ref)       | [`zeros(m,n)`](@ref)     | *m* 行 *n* 列のゼロ行列を作成します（[`spzeros(m,n)`](@ref) は空です）。                       |
| [`sparse(I,n,n)`](@ref)      | [`Matrix(I,n,n)`](@ref)  | *n* 行 *n* 列の単位行列を作成します。                                                    |
| [`sparse(A)`](@ref)          | [`Array(S)`](@ref)       | 密形式と疎形式の間で相互変換します。                                                         |
| [`sprand(m,n,d)`](@ref)      | [`rand(m,n)`](@ref)      | *m* 行 *n* 列のランダム行列を作成します（密度 *d*）。非ゼロ要素は独立同分布で、半開区間 ``[0, 1)`` 上の一様分布に従います。 |
| [`sprandn(m,n,d)`](@ref)     | [`randn(m,n)`](@ref)     | *m* 行 *n* 列のランダム行列を作成します（密度 *d*）。非ゼロ要素は独立同分布で、標準正規（ガウス）分布に従います。            |
| [`sprandn(rng,m,n,d)`](@ref) | [`randn(rng,m,n)`](@ref) | `rng` 乱数生成器で生成した独立同分布の非ゼロ要素を持つ、*m* 行 *n* 列のランダム行列を作成します（密度 *d*）。           |

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

# Noteworthy External Sparse Packages

疎行列を実装する Julia パッケージとして、ほかにも次のものがあります。

1. [SuiteSparseGraphBLAS.jl](https://github.com/JuliaSparse/SuiteSparseGraphBLAS.jl) は、高速なマルチスレッド対応 SuiteSparse:GraphBLAS C ライブラリのラッパーです。CPU では通常、最速の選択肢であり、MKLSparse を大幅に上回ることもよくあります。
2. [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) は、GPU 上の疎行列演算用ライブラリ [CUSPARSE](https://docs.nvidia.com/cuda/cusparse/index.html) を公開します。
3. [SparseMatricesCSR.jl](https://github.com/gridap/SparseMatricesCSR.jl) は、Compressed Sparse Rows（CSR）形式を Julia でネイティブに実装しています。
4. [MKLSparse.jl](https://github.com/JuliaSparse/MKLSparse.jl) は、Intel の MKL ライブラリを使って SparseArrays の疎行列と密行列の演算を高速化します。
5. [SparseArrayKit.jl](https://github.com/Jutho/SparseArrayKit.jl) は、多次元疎配列向けに利用できます。
6. [LuxurySparse.jl](https://github.com/QuantumBFS/LuxurySparse.jl) は、静的疎配列形式に加えて、座標形式も提供します。
7. [ExtendableSparse.jl](https://github.com/j-fu/ExtendableSparse.jl) は、新たに格納するインデックスを遅延方式で扱うことで、疎行列への高速な挿入を可能にします。
8. [Finch.jl](https://github.com/willow-ahrens/Finch.jl) は、ミニテンソル言語とコンパイラーを通じて、幅広い多次元疎配列形式と演算をすべて Julia ネイティブでサポートします。COO、CSF、CSR、CSC などの形式に加え、ブロードキャストやリダクションなどの演算、カスタム演算にも対応しています。

疎行列の直接法ソルバーを提供する外部パッケージ：

1. [KLU.jl](https://github.com/JuliaSparse/KLU.jl)
2. [Pardiso.jl](https://github.com/JuliaSparse/Pardiso.jl/)

固有系や特異値分解を反復法で解くソルバーを提供する外部パッケージ：

1. [ArnoldiMethods.jl](https://github.com/JuliaLinearAlgebra/ArnoldiMethod.jl)
2. [KrylovKit](https://github.com/Jutho/KrylovKit.jl)
3. [Arpack.jl](https://github.com/JuliaLinearAlgebra/Arpack.jl)

グラフを扱うための外部パッケージ：

1. [Graphs.jl](https://github.com/JuliaGraphs/Graphs.jl)
