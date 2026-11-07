# Interfaces

Julia の強力さと拡張性の多くは、一連の非公式なインターフェースによって支えられています。いくつかの特定のメソッドを独自の型に対して拡張すると、その型のオブジェクトでそれらの機能が使えるようになるだけでなく、その振る舞いを基に汎用的に実装された他のメソッドでも使えるようになります。

## [Iteration](@id man-interface-iteration)

次の 2 つのメソッドは常に必要です。

| 必須メソッド                  | 概要                                                |
|:----------------------- |:------------------------------------------------- |
| [`iterate(iter)`](@ref) | 最初の要素と初期状態のタプルを返します。空の場合は [`nothing`](@ref) を返します |
| `iterate(iter, state)`  | 次の要素と次の状態のタプルを返します。要素が残っていない場合は `nothing` を返します   |

状況によっては、さらにいくつかのメソッドを定義する必要があります。`Base.IteratorSize(IterType)` のデフォルトの定義は `Base.HasLength()` なので、`Base.IteratorSize(IterType)` と `length(iter)` の少なくとも一方は必ず定義してください。

| メソッド                                    | 定義が必要な場合                                                                  | デフォルトの定義           | 概要                                                                                                                  |
|:--------------------------------------- |:------------------------------------------------------------------------- |:------------------ |:------------------------------------------------------------------------------------------------------------------- |
| [`Base.IteratorSize(IterType)`](@ref)   | デフォルトが適切でない場合                                                             | `Base.HasLength()` | `Base.HasLength()`、`Base.HasShape{N}()`、`Base.IsInfinite()`、`Base.SizeUnknown()` のうち適切なもの                           |
| [`length(iter)`](@ref)                  | `Base.IteratorSize()` が `Base.HasLength()` または `Base.HasShape{N}()` を返す場合 | （*未定義*）            | 要素数（既知の場合）                                                                                                          |
| [`size(iter, [dim])`](@ref)             | `Base.IteratorSize()` が `Base.HasShape{N}()` を返す場合                        | （*未定義*）            | 各次元の要素数（既知の場合）                                                                                                      |
| [`Base.IteratorEltype(IterType)`](@ref) | デフォルトが適切でない場合                                                             | `Base.HasEltype()` | `Base.EltypeUnknown()` または `Base.HasEltype()` のうち適切なもの                                                              |
| [`eltype(IterType)`](@ref)              | デフォルトが適切でない場合                                                             | `Any`              | `iterate()` が返すタプルの最初の要素の型                                                                                          |
| [`Base.isdone(iter, [state])`](@ref)    | イテレータが状態を持つ場合は**必須**                                                      | `missing`          | イテレータの終了を高速に判定するためのヒント。状態を持つイテレータに対して定義されていないと、`isempty()` や `zip()` など、終了したかどうかを調べる関数がイテレータを変更し、不具合を引き起こす可能性があります！ |

逐次反復は [`iterate`](@ref) 関数によって実装されます。Julia のイテレータは、反復の際にオブジェクト自体を変更する代わりに、反復状態をオブジェクトの外部で管理できます。iterate の戻り値は常に、値と状態のタプルか、要素が残っていない場合には `nothing` です。状態オブジェクトは次の反復で iterate 関数に再び渡され、通常は反復可能オブジェクトの内部的な実装詳細と見なされます。

この関数を定義するオブジェクトはすべて反復可能であり、[many functions that rely upon iteration](@ref lib-collections-iteration) で使用できます。また、[`for`](@ref) ループでも直接使用できます。これは、次の構文が

```julia
for item in iter   # or  "for item = iter"
    # body
end
```

次のように変換されるためです。

```julia
next = iterate(iter)
while next !== nothing
    (item, state) = next
    # body
    next = iterate(iter, state)
end
```

簡単な例として、長さが定義された、平方数からなる反復可能な数列を考えます。

```jldoctest squaretype
julia> struct Squares
           count::Int
       end

julia> Base.iterate(S::Squares, state=1) = state > S.count ? nothing : (state*state, state+1)
```

[`iterate`](@ref) を定義するだけで、`Squares` 型ではすでに多くのことができます。すべての要素を反復処理できます。

```jldoctest squaretype
julia> for item in Squares(7)
           println(item)
       end
1
4
9
16
25
36
49
```

[`in`](@ref) や [`sum`](@ref) など、反復可能オブジェクトに対応する組み込みメソッドの多くも使えます。

```jldoctest squaretype
julia> 25 in Squares(10)
true

julia> sum(Squares(100))
338350
```

さらにいくつかのメソッドを拡張すると、この反復可能なコレクションについて、より多くの情報を Julia に伝えられます。`Squares` の数列の要素は常に `Int` であることがわかっています。[`eltype`](@ref) メソッドを拡張してこの情報を Julia に伝えることで、より複雑なメソッドでも、より特化したコードを生成できるようになります。数列の要素数もわかっているので、[`length`](@ref) も拡張できます。

```jldoctest squaretype
julia> Base.eltype(::Type{Squares}) = Int # Note that this is defined for the type

julia> Base.length(S::Squares) = S.count
```

これにより、すべての要素を [`collect`](@ref) で配列に集める際、各要素を単純に [`push!`](@ref) で `Vector{Any}` に追加するのではなく、適切なサイズの `Vector{Int}` をあらかじめ確保できます。

```jldoctest squaretype
julia> collect(Squares(4))
4-element Vector{Int64}:
  1
  4
  9
 16
```

汎用的な実装に任せることもできますが、より単純なアルゴリズムがわかっている場合には、特定のメソッドを拡張することもできます。たとえば、平方和を計算する公式があるので、反復処理による汎用版を、より高性能な実装で上書きできます。

```jldoctest squaretype
julia> Base.sum(S::Squares) = (n = S.count; return n*(n+1)*(2n+1)÷6)

julia> sum(Squares(1803))
1955361914
```

これは Julia Base 全体で非常によく使われるパターンです。少数の必須メソッドで非公式なインターフェースを定義することで、多くの高度な振る舞いが利用可能になります。型によっては、その型に固有の条件でより効率的なアルゴリズムが使えるとわかっている場合に、これらの追加の振る舞いも特殊化するとよいでしょう。

[`Iterators.reverse(iterator)`](@ref) を反復することで、コレクションを*逆順*に反復できるようにするのも便利です。ただし、実際に逆順の反復をサポートするには、イテレータ型 `T` に対して、`Iterators.Reverse{T}` 用の `iterate` を実装する必要があります。（`r::Iterators.Reverse{T}` が与えられた場合、型 `T` の元のイテレータは `r.itr` です。）先ほどの `Squares` の例では、`Iterators.Reverse{Squares}` メソッドを実装します。

```jldoctest squaretype
julia> Base.iterate(rS::Iterators.Reverse{Squares}, state=rS.itr.count) = state < 1 ? nothing : (state*state, state-1)

julia> collect(Iterators.reverse(Squares(4)))
4-element Vector{Int64}:
 16
  9
  4
  1
```

## Indexing

| 実装するメソッド             | 概要                                                |
|:-------------------- |:------------------------------------------------- |
| `getindex(X, i)`     | `X[i]`、インデックスによるアクセス。非スカラーの `i` ではコピーを確保する必要があります |
| `setindex!(X, v, i)` | `X[i] = v`、インデックスによる代入                            |
| `firstindex(X)`      | 最初のインデックス。`X[begin]` で使用されます                      |
| `lastindex(X)`       | 最後のインデックス。`X[end]` で使用されます                        |

上の反復可能オブジェクト `Squares` では、`i` 番目の要素は、その番号を二乗するだけで簡単に計算できます。この操作をインデックス式 `S[i]` として利用できるようにしましょう。この振る舞いを有効にするには、`Squares` に対して [`getindex`](@ref) を定義するだけで十分です。

```jldoctest squaretype
julia> function Base.getindex(S::Squares, i::Int)
           1 <= i <= S.count || throw(BoundsError(S, i))
           return i*i
       end

julia> Squares(100)[23]
529
```

さらに、`S[begin]` と `S[end]` の構文をサポートするには、[`firstindex`](@ref) と [`lastindex`](@ref) を定義し、それぞれ最初と最後の有効なインデックスを指定する必要があります。

```jldoctest squaretype
julia> Base.firstindex(S::Squares) = 1

julia> Base.lastindex(S::Squares) = length(S)

julia> Squares(23)[end]
529
```

たとえば `a[3, begin, 7]` のような多次元の `begin`/`end` によるインデックス指定には、`firstindex(a, dim)` と `lastindex(a, dim)` を定義してください（デフォルトでは、それぞれ `axes(a, dim)` に対して `first` と `last` を呼び出します）。

ただし、上の定義は、整数インデックスを 1 つ受け取る [`getindex`](@ref) *のみ*を定義していることに注意してください。`Int` 以外でインデックス指定すると、一致するメソッドがないことを示す [`MethodError`](@ref) がスローされます。範囲や `Int` のベクトルによるインデックス指定をサポートするには、別のメソッドを書く必要があります。

```jldoctest squaretype
julia> Base.getindex(S::Squares, i::Number) = S[convert(Int, i)]

julia> Base.getindex(S::Squares, I) = [S[i] for i in I]

julia> Squares(10)[[3,4.,5]]
3-element Vector{Int64}:
  9
 16
 25
```

これで [indexing operations supported by some of the builtin types](@ref man-array-indexing) のより多くの機能をサポートし始めましたが、まだかなりの振る舞いが欠けています。`Squares` の数列は、振る舞いを追加するにつれて、ますますベクトルに近づいてきました。これらの振る舞いをすべて自分で定義する代わりに、正式に [`AbstractArray`](@ref) のサブタイプとして定義できます。

## [Abstract Arrays](@id man-interface-array)

| 実装するメソッド                                 |                                      | 概要                                                                                                                     |
|:---------------------------------------- |:------------------------------------ |:---------------------------------------------------------------------------------------------------------------------- |
| `size(A)`                                |                                      | `A` の各次元のサイズを含むタプルを返します                                                                                                |
| `getindex(A, i::Int)`                    |                                      | （`IndexLinear` の場合）線形スカラーインデックス指定                                                                                      |
| `getindex(A, I::Vararg{Int, N})`         |                                      | （`IndexCartesian`、かつ `N = ndims(A)` の場合）N 次元スカラーインデックス指定                                                               |
| **オプションのメソッド**                           | **デフォルトの定義**                         | **概要**                                                                                                                 |
| `IndexStyle(::Type)`                     | `IndexCartesian()`                   | `IndexLinear()` または `IndexCartesian()` を返します。以下の説明を参照してください。                                                           |
| `setindex!(A, v, i::Int)`                |                                      | （`IndexLinear` の場合）スカラーインデックスによる代入                                                                                     |
| `setindex!(A, v, I::Vararg{Int, N})`     |                                      | （`IndexCartesian`、かつ `N = ndims(A)` の場合）N 次元スカラーインデックスによる代入                                                            |
| `getindex(A, I...)`                      | スカラーの `getindex` に基づいて定義             | [Multidimensional and nonscalar indexing](@ref man-array-indexing)                                                     |
| `setindex!(A, X, I...)`                  | スカラーの `setindex!` に基づいて定義            | [Multidimensional and nonscalar indexed assignment](@ref man-array-indexing)                                           |
| `iterate`                                | スカラーの `getindex` に基づいて定義             | 反復                                                                                                                     |
| `length(A)`                              | `prod(size(A))`                      | 要素数                                                                                                                    |
| `similar(A)`                             | `similar(A, eltype(A), size(A))`     | 同じ形状と要素型を持つ可変配列を返します                                                                                                   |
| `similar(A, ::Type{S})`                  | `similar(A, S, size(A))`             | 同じ形状で、指定された要素型を持つ可変配列を返します                                                                                             |
| `similar(A, dims::Dims)`                 | `similar(A, eltype(A), dims)`        | 同じ要素型で、サイズが *dims* の可変配列を返します                                                                                          |
| `similar(A, ::Type{S}, dims::Dims)`      | `Array{S}(undef, dims)`              | 指定された要素型とサイズの可変配列を返します                                                                                                 |
| **非標準のインデックス**                           | **デフォルトの定義**                         | **概要**                                                                                                                 |
| `axes(A)`                                | `map(OneTo, size(A))`                | 有効なインデックスの `AbstractUnitRange{<:Integer}` からなるタプルを返します。軸はそれ自身の軸である必要があり、つまり `axes.(axes(A),1) == axes(A)` を満たす必要があります。 |
| `similar(A, ::Type{S}, inds)`            | `similar(A, S, Base.to_shape(inds))` | 指定されたインデックス `inds` を持つ可変配列を返します（下記参照）                                                                                  |
| `similar(T::Union{Type,Function}, inds)` | `T(Base.to_shape(inds))`             | `T` に似た、指定されたインデックス `inds` を持つ配列を返します（下記参照）                                                                            |

型を `AbstractArray` のサブタイプとして定義すると、単一要素へのアクセスを基に実装された、反復や多次元インデックス指定などの非常に豊富な振る舞いを継承します。その他のサポートされるメソッドについては、[arrays manual page](@ref man-multi-dim-arrays) と [Julia Base section](@ref lib-arrays) を参照してください。

`AbstractArray` のサブタイプを定義する際の重要な要素が [`IndexStyle`](@ref) です。インデックス指定は配列の非常に重要な機能であり、頻繁に実行されるループ内で使われることも多いため、インデックスによるアクセスと代入の両方をできる限り効率的にすることが重要です。配列データ構造は通常、次のどちらかの方式で定義されます。1 つのインデックスだけを使うアクセス（線形インデックス指定）が最も効率的であるか、各次元のインデックスを指定して要素にアクセスするのが本来の方式であるかです。Julia では、この 2 つの方式を `IndexLinear()` と `IndexCartesian()` で識別します。線形インデックスから複数の添字への変換は通常非常に高コストなので、この仕組みにより、トレイトに基づいてすべての配列型で効率的な汎用コードを実現できます。

この区別によって、その型で定義しなければならないスカラーインデックス指定のメソッドが決まります。`IndexLinear()` 配列は単純で、`getindex(A::ArrayType, i::Int)` を定義するだけです。その後、配列が多次元のインデックスでアクセスされると、フォールバックの `getindex(A::AbstractArray, I...)` がそれらを 1 つの線形インデックスに効率的に変換し、上のメソッドを呼び出します。一方、`IndexCartesian()` 配列では、サポートする次元数ごとに、`ndims(A)` 個の `Int` インデックスを受け取るメソッドを定義する必要があります。たとえば、標準ライブラリモジュール `SparseArrays` の [`SparseMatrixCSC`](@ref) は 2 次元のみをサポートするため、`getindex(A::SparseMatrixCSC, i::Int, j::Int)` だけを定義しています。[`setindex!`](@ref) についても同様です。

先ほどの平方数の数列に戻ると、これを `AbstractArray{Int, 1}` のサブタイプとして定義することもできます。

```jldoctest squarevectype
julia> struct SquaresVector <: AbstractArray{Int, 1}
           count::Int
       end

julia> Base.size(S::SquaresVector) = (S.count,)

julia> Base.IndexStyle(::Type{<:SquaresVector}) = IndexLinear()

julia> Base.getindex(S::SquaresVector, i::Int) = i*i
```

`AbstractArray` の 2 つのパラメータを指定することが非常に重要です。最初のパラメータは [`eltype`](@ref) を、2 番目は [`ndims`](@ref) を定義します。このスーパータイプと 3 つのメソッドだけで、`SquaresVector` は反復可能で、インデックスによるアクセスができる、完全に機能する配列になります。

```jldoctest squarevectype
julia> s = SquaresVector(4)
4-element SquaresVector:
  1
  4
  9
 16

julia> s[s .> 8]
2-element Vector{Int64}:
  9
 16

julia> s + s
4-element Vector{Int64}:
  2
  8
 18
 32

julia> sin.(s)
4-element Vector{Float64}:
  0.8414709848078965
 -0.7568024953079282
  0.4121184852417566
 -0.2879033166650653
```

もう少し複雑な例として、[`Dict`](@ref) を基に、疎配列に似た簡易的な N 次元配列型を定義してみましょう。

```jldoctest squarevectype
julia> struct SparseArray{T,N} <: AbstractArray{T,N}
           data::Dict{NTuple{N,Int}, T}
           dims::NTuple{N,Int}
       end

julia> SparseArray(::Type{T}, dims::Int...) where {T} = SparseArray(T, dims);

julia> SparseArray(::Type{T}, dims::NTuple{N,Int}) where {T,N} = SparseArray{T,N}(Dict{NTuple{N,Int}, T}(), dims);

julia> Base.size(A::SparseArray) = A.dims

julia> Base.similar(A::SparseArray, ::Type{T}, dims::Dims) where {T} = SparseArray(T, dims)

julia> Base.getindex(A::SparseArray{T,N}, I::Vararg{Int,N}) where {T,N} = get(A.data, I, zero(T))

julia> Base.setindex!(A::SparseArray{T,N}, v, I::Vararg{Int,N}) where {T,N} = (A.data[I] = v)
```

これは `IndexCartesian` 配列なので、配列の次元数に合わせて [`getindex`](@ref) と [`setindex!`](@ref) を手動で定義する必要があります。`SquaresVector` とは異なり、[`setindex!`](@ref) を定義できるため、配列を変更できます。

```jldoctest squarevectype
julia> A = SparseArray(Float64, 3, 3)
3×3 SparseArray{Float64, 2}:
 0.0  0.0  0.0
 0.0  0.0  0.0
 0.0  0.0  0.0

julia> fill!(A, 2)
3×3 SparseArray{Float64, 2}:
 2.0  2.0  2.0
 2.0  2.0  2.0
 2.0  2.0  2.0

julia> A[:] = 1:length(A); A
3×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
 3.0  6.0  9.0
```

`AbstractArray` に対するインデックス指定の結果は、それ自体が配列になることがあります（たとえば、`AbstractRange` でインデックス指定した場合）。`AbstractArray` のフォールバックメソッドは、[`similar`](@ref) を使って適切なサイズと要素型の `Array` を確保し、上で説明した基本的なインデックス指定のメソッドで要素を埋めます。ただし、配列ラッパーを実装する際には、結果もラップされた状態にしたいことがよくあります。

```jldoctest squarevectype
julia> A[1:2,:]
2×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
```

この例では、適切にラップされた配列を作成するよう `Base.similar(A::SparseArray, ::Type{T}, dims::Dims) where T` を定義することで実現しています。（`similar` は引数が 1 個および 2 個の形式もサポートしますが、ほとんどの場合、引数が 3 個の形式だけを特殊化すれば十分です。）これが機能するには、`SparseArray` が可変であること（`setindex!` をサポートすること）が重要です。また、`SparseArray` に対して `similar`、`getindex`、`setindex!` を定義することで、配列に [`copy`](@ref) を適用することも可能になります。

```jldoctest squarevectype
julia> copy(A)
3×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
 3.0  6.0  9.0
```

これらの型は、上で紹介した反復やインデックス指定のメソッドをすべて使えるだけでなく、互いに組み合わせて使うことも、Julia Base で `AbstractArrays` 用に定義されているほとんどのメソッドを使うこともできます。

```jldoctest squarevectype
julia> A[SquaresVector(3)]
3-element SparseArray{Float64, 1}:
 1.0
 4.0
 9.0

julia> sum(A)
45.0
```

非標準のインデックス指定（1 以外から始まるインデックス）を許可する配列型を定義する場合は、[`axes`](@ref) を特殊化してください。また、[`similar`](@ref) も特殊化して、`dims` 引数（通常は `Dims` のサイズタプル）が `AbstractUnitRange` オブジェクトを受け取れるようにしてください。これには、独自に設計した範囲型 `Ind` を使うこともできます。詳しくは [Arrays with custom indices](@ref man-custom-indices) を参照してください。

## [Strided Arrays](@id man-interface-strided-arrays)

| 実装するメソッド                                 |                 | 概要                                                                                   |
|:---------------------------------------- |:--------------- |:------------------------------------------------------------------------------------ |
| `strides(A)`                             |                 | 各次元で隣接する要素間のメモリ上の距離を、要素数単位のタプルで返します。`A` が `AbstractArray{T,0}` の場合は、空のタプルを返す必要があります。 |
| `Base.unsafe_convert(::Type{Ptr{T}}, A)` |                 | 配列のネイティブアドレスを返します。                                                                   |
| `Base.elsize(::Type{<:A})`               |                 | 配列内の連続する要素間のストライドをバイト数単位で返します。                                                       |
| **オプションのメソッド**                           | **デフォルトの定義**    | **概要**                                                                               |
| `stride(A, i::Int)`                      | `strides(A)[i]` | 次元 i で隣接する要素間のメモリ上の距離を要素数単位で返します。                                                    |

ストライド配列とは、要素がメモリ上に一定のストライドで格納されている `AbstractArray` のサブタイプです。配列の要素型が BLAS と互換であれば、ストライド配列は BLAS と LAPACK のルーチンを利用して、より効率的な線形代数処理を実行できます。ユーザー定義のストライド配列の典型例は、標準の `Array` をラップし、構造を追加したものです。

警告：基になるストレージが実際には一定のストライドを持たない場合、これらのメソッドを実装しないでください。誤った結果やセグメンテーションフォールトを引き起こす可能性があります。

次の関数は、ストライド配列 `A` のインデックス `I` にある要素へのアクセス方法を示しています。この関数は、要素型が `isbitstype` であり、インデックスが範囲内にあると仮定しています。

```jldoctest
julia> function unsafe_strided_getindex(A::AbstractArray{T,N}, I::Vararg{Int, N})::T where {T, N}
           A_cconv = Base.cconvert(Ptr{T}, A)
           GC.@preserve A_cconv begin
               A_ptr = Base.unsafe_convert(Ptr{T}, A_cconv)
               for d in 1:N
                   stride_in_bytes = stride(A, d) * Base.elsize(typeof(A))
                   first_idx = first(axes(A, d))
                   A_ptr += (I[d] - first_idx) * stride_in_bytes
               end
               unsafe_load(A_ptr)
           end
       end;

julia> A = [1 5; 2 6; 3 7; 4 8];

julia> unsafe_strided_getindex(A, 3, 2)
7

julia> V = view(A, 1:2:3, 1:2);

julia> unsafe_strided_getindex(V, 2, 2)
7
```

以下の例は、どのような配列がストライド配列であり、どのような配列がそうでないかを示しています。

```julia
1:5   # not strided (there is no storage associated with this array.)
Vector(1:5)  # is strided with strides (1,)
A = [1 5; 2 6; 3 7; 4 8]  # is strided with strides (1,4)
V = view(A, 1:2, :)   # is strided with strides (1,4)
V = view(A, 1:2:3, 1:2)   # is strided with strides (2,4)
V = view(A, [1,2,4], :)   # is not strided, as the spacing between rows is not fixed.
```

## [Customizing broadcasting](@id man-interfaces-broadcasting)

| 実装するメソッド                                                   | 概要                                        |
|:---------------------------------------------------------- |:----------------------------------------- |
| `Base.BroadcastStyle(::Type{SrcType}) = SrcStyle()`        | `SrcType` のブロードキャストの振る舞い                  |
| `Base.similar(bc::Broadcasted{DestStyle}, ::Type{ElType})` | 出力コンテナの確保                                 |
| **オプションのメソッド**                                             |                                           |
| `Base.BroadcastStyle(::Style1, ::Style2) = Style12()`      | スタイルを混在させる場合の優先順位規則                       |
| `Base.axes(x)`                                             | [`axes(x)`](@ref) に従った、`x` のインデックスの宣言。    |
| `Base.broadcastable(x)`                                    | `x` を、`axes` を持ち、インデックス指定をサポートするオブジェクトに変換 |
| **デフォルトの仕組みを使わない方法**                                       |                                           |
| `Base.copy(bc::Broadcasted{DestStyle})`                    | `broadcast` の独自実装                         |
| `Base.copyto!(dest, bc::Broadcasted{DestStyle})`           | `DestStyle` に対して特殊化した、`broadcast!` の独自実装  |
| `Base.copyto!(dest::DestType, bc::Broadcasted{Nothing})`   | `DestType` に対して特殊化した、`broadcast!` の独自実装   |
| `Base.Broadcast.broadcasted(f, args...)`                   | 融合された式の内部で、デフォルトの遅延評価の振る舞いを上書き            |
| `Base.Broadcast.instantiate(bc::Broadcasted{DestStyle})`   | 遅延ブロードキャストの軸の計算を上書き                       |

[Broadcasting](@ref) は、`broadcast` または `broadcast!` を明示的に呼び出すか、`A .+ b` や `f.(x, y)` のような「ドット」演算によって暗黙的に実行されます。[`axes`](@ref) を持ち、インデックス指定をサポートするオブジェクトはすべて、ブロードキャストの引数として使用できます。デフォルトでは、結果は `Array` に格納されます。この基本的な枠組みは、主に次の 3 つの方法で拡張できます。

  * すべての引数がブロードキャストをサポートするようにする
  * 与えられた引数の組み合わせに適した出力配列を選択する
  * 与えられた引数の組み合わせに対して効率的な実装を選択する

すべての型が `axes` とインデックス指定をサポートするわけではありませんが、ブロードキャストで使えると便利な型は数多くあります。[`Base.broadcastable`](@ref) 関数はブロードキャストの各引数に対して呼び出され、`axes` とインデックス指定をサポートする別のものを返せるようにします。デフォルトでは、すべての `AbstractArray` と `Number` に対して恒等関数として動作します。これらはすでに `axes` とインデックス指定をサポートしているためです。

ブロードキャストで、ある型をコンテナではなく「0 次元スカラー」（単一のオブジェクト）として扱いたい場合は、次のメソッドを定義してください。

```julia
Base.broadcastable(o::MyType) = Ref(o)
```

このメソッドは、引数を 0 次元の [`Ref`](@ref) コンテナでラップして返します。たとえば、型そのもの、関数、[`missing`](@ref) や [`nothing`](@ref) のような特別なシングルトン、日付に対して、このようなラッパーメソッドが定義されています。

独自の配列に似た型は、`Base.broadcastable` を特殊化して形状を定義できますが、`collect(Base.broadcastable(x)) == collect(x)` という規約に従う必要があります。注目すべき例外は `AbstractString` です。文字列は文字の反復可能なコレクションですが、ブロードキャストではスカラーとして振る舞うよう特別に扱われます（詳しくは [Strings](@ref) を参照してください）。

次の 2 つの段階（出力配列と実装の選択）では、与えられた引数の組み合わせに対して 1 つの答えを決める必要があります。ブロードキャストは、さまざまな型の引数をすべて考慮し、出力配列と実装をそれぞれ 1 つに絞らなければなりません。ブロードキャストでは、この 1 つの答えを「スタイル」と呼びます。ブロードキャスト可能なオブジェクトはそれぞれ自身の優先するスタイルを持ち、型の昇格に似た仕組みによってそれらのスタイルを組み合わせ、「出力先スタイル」という 1 つの答えを導きます。

### Broadcast Styles

`Base.BroadcastStyle` は、すべてのブロードキャストスタイルの基となる抽象型です。関数として使用する場合は、単項（引数 1 個）と二項の 2 つの形式があります。単項の形式は、特定のブロードキャストの振る舞いや出力型を実装し、デフォルトのフォールバック [`Broadcast.DefaultArrayStyle`](@ref) には依存しないことを表します。

これらのデフォルトを上書きするには、オブジェクトに対して独自の `BroadcastStyle` を定義します。

```julia
struct MyStyle <: Broadcast.BroadcastStyle end
Base.BroadcastStyle(::Type{<:MyType}) = MyStyle()
```

場合によっては、`MyStyle` を定義せずに済むほうが便利です。その場合は、汎用のブロードキャストラッパーを利用できます。

  * `Base.BroadcastStyle(::Type{<:MyType}) = Broadcast.Style{MyType}()` は任意の型に使用できます。
  * `MyType` が `AbstractArray` の場合は、`Base.BroadcastStyle(::Type{<:MyType}) = Broadcast.ArrayStyle{MyType}()` が推奨されます。
  * 特定の次元数だけをサポートする `AbstractArrays` には、`Broadcast.AbstractArrayStyle{N}` のサブタイプを作成してください（下記参照）。

ブロードキャスト演算に複数の引数が含まれる場合、各引数のスタイルを組み合わせ、出力コンテナの型を制御する 1 つの `DestStyle` を決定します。詳しくは [below](@ref writing-binary-broadcasting-rules) を参照してください。

### Selecting an appropriate output array

ブロードキャスト演算ごとにブロードキャストスタイルを計算することで、ディスパッチと特殊化を可能にしています。結果配列の実際の確保は、Broadcasted オブジェクトを第 1 引数とする `similar` が担当します。

```julia
Base.similar(bc::Broadcasted{DestStyle}, ::Type{ElType})
```

フォールバックの定義は次のとおりです。

```julia
similar(bc::Broadcasted{DefaultArrayStyle{N}}, ::Type{ElType}) where {N,ElType} =
    similar(Array{ElType}, axes(bc))
```

ただし、必要に応じて、これらの引数のいずれか、またはすべてに対して特殊化できます。最後の引数 `bc` は、（融合されている可能性のある）ブロードキャスト演算の遅延表現であり、`Broadcasted` オブジェクトです。この用途でラッパーの最も重要なフィールドは `f` と `args` で、それぞれ関数と引数リストを表します。引数リストには、入れ子になった別の `Broadcasted` ラッパーが含まれることがあり、実際によく含まれます。

完全な例として、配列と 1 文字を格納する型 `ArrayAndChar` を作成したとします。

```jldoctest ArrayAndChar; output = false
struct ArrayAndChar{T,N} <: AbstractArray{T,N}
    data::Array{T,N}
    char::Char
end
Base.size(A::ArrayAndChar) = size(A.data)
Base.getindex(A::ArrayAndChar{T,N}, inds::Vararg{Int,N}) where {T,N} = A.data[inds...]
Base.setindex!(A::ArrayAndChar{T,N}, val, inds::Vararg{Int,N}) where {T,N} = A.data[inds...] = val
Base.showarg(io::IO, A::ArrayAndChar, toplevel) = print(io, typeof(A), " with char '", A.char, "'")
# output

```

ブロードキャストでも `char` の「メタデータ」を保持したいと考えるかもしれません。まず、次のように定義します。

```jldoctest ArrayAndChar; output = false
Base.BroadcastStyle(::Type{<:ArrayAndChar}) = Broadcast.ArrayStyle{ArrayAndChar}()
# output

```

これにより、対応する `similar` メソッドも定義する必要があります。

```jldoctest ArrayAndChar; output = false
function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{ArrayAndChar}}, ::Type{ElType}) where ElType
    # Scan the inputs for the ArrayAndChar:
    A = find_aac(bc)
    # Use the char field of A to create the output
    ArrayAndChar(similar(Array{ElType}, axes(bc)), A.char)
end

"`A = find_aac(As)` returns the first ArrayAndChar among the arguments."
find_aac(bc::Base.Broadcast.Broadcasted) = find_aac(bc.args)
find_aac(args::Tuple) = find_aac(find_aac(args[1]), Base.tail(args))
find_aac(x) = x
find_aac(::Tuple{}) = nothing
find_aac(a::ArrayAndChar, rest) = a
find_aac(::Any, rest) = find_aac(rest)
# output
find_aac (generic function with 6 methods)
```

これらの定義によって、次の振る舞いが得られます。

```jldoctest ArrayAndChar
julia> a = ArrayAndChar([1 2; 3 4], 'x')
2×2 ArrayAndChar{Int64, 2} with char 'x':
 1  2
 3  4

julia> a .+ 1
2×2 ArrayAndChar{Int64, 2} with char 'x':
 2  3
 4  5

julia> a .+ [5,10]
2×2 ArrayAndChar{Int64, 2} with char 'x':
  6   7
 13  14
```

### [Extending broadcast with custom implementations](@id extending-in-place-broadcast)

一般に、ブロードキャスト演算は、適用する関数とその引数を保持する遅延評価の `Broadcasted` コンテナで表されます。引数自体がさらに入れ子の `Broadcasted` コンテナになっていることもあり、評価対象の大きな式ツリーを形成します。暗黙のドット構文は、`Broadcasted` コンテナの入れ子のツリーを直接構築します。たとえば、`5 .+ 2.*x` は一時的に `Broadcasted(+, 5, Broadcasted(*, 2, x))` として表されます。これは `copy` の呼び出しによってすぐに実体化されるため、ユーザーには見えません。しかし、このコンテナこそが、独自の型の作成者にブロードキャストの拡張性を提供する基盤です。組み込みのブロードキャスト機構は、引数に基づいて結果の型とサイズを決定し、配列を確保した後、最後にデフォルトの `copyto!(::AbstractArray, ::Broadcasted)` メソッドで `Broadcasted` オブジェクトの評価結果をそこへコピーします。組み込みのフォールバックメソッド `broadcast` と `broadcast!` も同様に、演算の一時的な `Broadcasted` 表現を構築することで、同じコードパスをたどります。このため、独自の配列実装では `copyto!` の独自の特殊化を提供し、ブロードキャストをカスタマイズして最適化できます。これも、計算されたブロードキャストスタイルによって決定されます。スタイルはこの処理において非常に重要なので、ディスパッチと特殊化を可能にするため、`Broadcasted` 型の最初の型パラメータとして格納されています。

型によっては、入れ子のブロードキャストの階層をまたいで演算を「融合」する仕組みが利用できない場合や、段階的に処理するほうが効率的な場合があります。そのような場合は、`x .* (x .+ 1)` を `broadcast(*, x, broadcast(+, x, 1))` と書かれたかのように、内側の演算を評価してから外側の演算を処理する必要がある、またはそうしたいことがあります。このような即時評価は、少し間接的な仕組みによって直接サポートされています。Julia は `Broadcasted` オブジェクトを直接構築するのではなく、融合された式 `x .* (x .+ 1)` を `Broadcast.broadcasted(*, x, Broadcast.broadcasted(+, x, 1))` に変換します。デフォルトでは、`broadcasted` は単に `Broadcasted` コンストラクタを呼び出して、融合された式ツリーの遅延表現を作成しますが、特定の関数と引数の組み合わせに対して上書きできます。

たとえば、組み込みの `AbstractRange` オブジェクトはこの仕組みを使い、ブロードキャスト式のうち、開始値、刻み幅、長さ（または終了値）だけで即時評価できる部分を最適化します。個々の要素をすべて計算する必要はありません。他の仕組みと同様に、`broadcasted` も引数を組み合わせたブロードキャストスタイルを計算し、利用可能にします。そのため、`broadcasted(f, args...)` に対して特殊化する代わりに、スタイル、関数、引数の任意の組み合わせに対して `broadcasted(::DestStyle, f, args...)` を特殊化できます。

たとえば、次の定義は範囲の符号反転をサポートします。

```julia
broadcasted(::DefaultArrayStyle{1}, ::typeof(-), r::OrdinalRange) = range(-first(r), step=-step(r), length=length(r))
```

### [Extending in-place broadcasting](@id extending-in-place-broadcast)

適切な `copyto!(dest, bc::Broadcasted)` メソッドを定義すると、インプレースのブロードキャストをサポートできます。`dest` に対して特殊化したい場合も、`bc` の特定のサブタイプに対して特殊化したい場合もあるため、パッケージ間の曖昧さを避けるには、次の規約を推奨します。

特定のスタイル `DestStyle` に対して特殊化したい場合は、次のメソッドを定義してください。

```julia
copyto!(dest, bc::Broadcasted{DestStyle})
```

この形式では、必要に応じて `dest` の型に対しても特殊化できます。

一方、`DestStyle` に対しては特殊化せず、出力先の型 `DestType` に対して特殊化したい場合は、次のシグネチャを持つメソッドを定義してください。

```julia
copyto!(dest::DestType, bc::Broadcasted{Nothing})
```

これは、ラッパーを `Broadcasted{Nothing}` に変換する `copyto!` のフォールバック実装を利用します。そのため、`DestType` に対する特殊化は、`DestStyle` に対して特殊化したメソッドよりも優先順位が低くなります。

同様に、`copy(::Broadcasted)` メソッドを使って、非インプレースのブロードキャストを完全に上書きできます。

#### Working with `Broadcasted` objects

もちろん、このような `copy` または `copyto!` メソッドを実装するには、`Broadcasted` ラッパーを操作して各要素を計算する必要があります。その方法は主に 2 つあります。

  * `Broadcast.flatten` は、入れ子になっている可能性のある演算を、1 つの関数と平坦な引数リストに組み直します。ブロードキャストの形状規則は自分で実装する必要がありますが、限られた状況では役立つことがあります。
  * `axes(::Broadcasted)` の `CartesianIndices` を反復し、得られた `CartesianIndex` オブジェクトを使ってインデックス指定することで結果を計算します。

### [Writing binary broadcasting rules](@id writing-binary-broadcasting-rules)

優先順位規則は、二項の `BroadcastStyle` 呼び出しによって定義されます。

```julia
Base.BroadcastStyle(::Style1, ::Style2) = Style12()
```

ここで `Style12` は、`Style1` と `Style2` の引数を含む演算の出力に対して選択したい `BroadcastStyle` です。たとえば、

```julia
Base.BroadcastStyle(::Broadcast.Style{Tuple}, ::Broadcast.AbstractArrayStyle{0}) = Broadcast.Style{Tuple}()
```

は、`Tuple` が 0 次元配列に「勝つ」ことを示します（出力コンテナはタプルになります）。この呼び出しについて、引数の両方の順序を定義する必要はありません（定義すべきでもありません）。ユーザーが引数をどの順序で渡しても、一方を定義するだけで十分です。

`AbstractArray` 型では、`BroadcastStyle` を定義すると、フォールバックの選択肢である [`Broadcast.DefaultArrayStyle`](@ref) に優先します。`DefaultArrayStyle` とその抽象スーパータイプ `AbstractArrayStyle` は、次元数が固定される特殊な配列型をサポートするために、次元数を型パラメータとして格納します。

`DefaultArrayStyle` は、次のメソッドによって、定義済みの他のどの `AbstractArrayStyle` に対しても「負ける」ようになっています。

```julia
BroadcastStyle(a::AbstractArrayStyle{Any}, ::DefaultArrayStyle) = a
BroadcastStyle(a::AbstractArrayStyle{N}, ::DefaultArrayStyle{N}) where N = a
BroadcastStyle(a::AbstractArrayStyle{M}, ::DefaultArrayStyle{N}) where {M,N} =
    typeof(a)(Val(max(M, N)))
```

`DefaultArrayStyle` 以外の型を 2 つ以上使う場合の優先順位を設定したいのでなければ、二項の `BroadcastStyle` 規則を書く必要はありません。

配列型の次元数に固定の制約がある場合は、`AbstractArrayStyle` のサブタイプにしてください。たとえば、疎配列のコードには次の定義があります。

```julia
struct SparseVecStyle <: Broadcast.AbstractArrayStyle{1} end
struct SparseMatStyle <: Broadcast.AbstractArrayStyle{2} end
Base.BroadcastStyle(::Type{<:SparseVector}) = SparseVecStyle()
Base.BroadcastStyle(::Type{<:SparseMatrixCSC}) = SparseMatStyle()
```

`AbstractArrayStyle` のサブタイプを作成する場合は必ず、`Val(N)` 引数を受け取るスタイルのコンストラクタを作成し、次元数を組み合わせるための規則も定義する必要があります。たとえば、次のようにします。

```julia
SparseVecStyle(::Val{0}) = SparseVecStyle()
SparseVecStyle(::Val{1}) = SparseVecStyle()
SparseVecStyle(::Val{2}) = SparseMatStyle()
SparseVecStyle(::Val{N}) where N = Broadcast.DefaultArrayStyle{N}()
```

これらの規則は、`SparseVecStyle` と 0 次元または 1 次元の配列を組み合わせると別の `SparseVecStyle` になり、2 次元配列と組み合わせると `SparseMatStyle` になり、それより高い次元では任意次元の密配列の枠組みにフォールバックすることを示します。この規則によって、ブロードキャストは出力が 1 次元または 2 次元となる演算では疎表現を保持し、それ以外の次元数では `Array` を生成できます。

## [Instance Properties](@id man-instance-properties)

| 実装するメソッド                                         | デフォルトの定義                | 概要                                                                                       |
|:------------------------------------------------ |:----------------------- |:---------------------------------------------------------------------------------------- |
| `propertynames(x::ObjType, private::Bool=false)` | `fieldnames(typeof(x))` | オブジェクト `x` のプロパティ（`x.property`）のタプルを返します。`private=true` の場合は、非公開として扱うことを意図したプロパティ名も返します  |
| `getproperty(x::ObjType, s::Symbol)`             | `getfield(x, s)`        | `x` のプロパティ `s` を返します。`x.s` は `getproperty(x, :s)` を呼び出します。                               |
| `setproperty!(x::ObjType, s::Symbol, v)`         | `setfield!(x, s, v)`    | `x` のプロパティ `s` を `v` に設定します。`x.s = v` は `setproperty!(x, :s, v)` を呼び出します。`v` を返す必要があります。 |

エンドユーザーがオブジェクトのフィールドを操作する方法を変えたい場合があります。型のフィールドへの直接アクセスを提供する代わりに、`object.field` をオーバーロードすることで、ユーザーとコードの間に抽象化の層を追加できます。プロパティはユーザーから*見えるオブジェクトの姿*であり、フィールドはオブジェクトの*実際の構成*です。

デフォルトでは、プロパティとフィールドは同じです。ただし、この振る舞いは変更できます。たとえば、平面上の点を [polar coordinates](https://en.wikipedia.org/wiki/Polar_coordinate_system) で表した次の例を考えます。

```jldoctest polartype
julia> mutable struct Point
           r::Float64
           ϕ::Float64
       end

julia> p = Point(7.0, pi/4)
Point(7.0, 0.7853981633974483)
```

上の表で説明したように、ドットによるアクセス `p.r` は `getproperty(p, :r)` と同じであり、これはデフォルトでは `getfield(p, :r)` と同じです。

```jldoctest polartype
julia> propertynames(p)
(:r, :ϕ)

julia> getproperty(p, :r), getproperty(p, :ϕ)
(7.0, 0.7853981633974483)

julia> p.r, p.ϕ
(7.0, 0.7853981633974483)

julia> getfield(p, :r), getproperty(p, :ϕ)
(7.0, 0.7853981633974483)
```

しかし、`Point` が座標を `r` と `ϕ`（フィールド）として格納していることをユーザーに意識させず、代わりに `x` と `y`（プロパティ）を操作してもらいたい場合があります。表の最初の列にあるメソッドを定義することで、新しい機能を追加できます。

```jldoctest polartype
julia> Base.propertynames(::Point, private::Bool=false) = private ? (:x, :y, :r, :ϕ) : (:x, :y)

julia> function Base.getproperty(p::Point, s::Symbol)
           if s === :x
               return getfield(p, :r) * cos(getfield(p, :ϕ))
           elseif s === :y
               return getfield(p, :r) * sin(getfield(p, :ϕ))
           else
               # This allows accessing fields with p.r and p.ϕ
               return getfield(p, s)
           end
       end

julia> function Base.setproperty!(p::Point, s::Symbol, f)
           if s === :x
               y = p.y
               setfield!(p, :r, sqrt(f^2 + y^2))
               setfield!(p, :ϕ, atan(y, f))
               return f
           elseif s === :y
               x = p.x
               setfield!(p, :r, sqrt(x^2 + f^2))
               setfield!(p, :ϕ, atan(f, x))
               return f
           else
               # This allow modifying fields with p.r and p.ϕ
               return setfield!(p, s, f)
           end
       end
```

`getproperty` と `setproperty!` の内部では、ドット構文ではなく `getfield` と `setfield` を使うことが重要です。ドット構文を使うと関数が再帰的になり、型推論の問題につながる可能性があるためです。これで、新しい機能を試せます。

```jldoctest polartype
julia> propertynames(p)
(:x, :y)

julia> p.x
4.949747468305833

julia> p.y = 4.0
4.0

julia> p.r
6.363961030678928
```

最後に、このようにインスタンスのプロパティを追加することは Julia ではごくまれであり、一般には十分な理由がある場合に限って行うべきだという点に注意してください。

## [Rounding](@id man-rounding-interface)

| 実装するメソッド                                      | デフォルトの定義                  | 概要                                                       |
|:--------------------------------------------- |:------------------------- |:-------------------------------------------------------- |
| `round(x::ObjType, r::RoundingMode)`          | なし                        | `x` を丸めて結果を返します。可能であれば、round は `x` と同じ型のオブジェクトを返す必要があります |
| `round(T::Type, x::ObjType, r::RoundingMode)` | `convert(T, round(x, r))` | `x` を丸め、結果を `T` として返します                                  |

新しい型で丸めをサポートするには、通常は `round(x::ObjType, r::RoundingMode)` という 1 つのメソッドを定義すれば十分です。渡された丸めモードによって、値をどの方向に丸めるかが決まります。最もよく使われる丸めモードは `RoundNearest`、`RoundToZero`、`RoundDown`、`RoundUp` です。これらはそれぞれ、引数が 1 個の `round` メソッド、および `trunc`、`floor`、`ceil` の定義で使用されるためです。

場合によっては、引数が 2 個のメソッドを呼び出してから変換するよりも、精度や性能に優れた、引数が 3 個の `round` メソッドを定義できます。この場合は、引数が 2 個のメソッドに加えて、引数が 3 個のメソッドを定義してもかまいません。丸めた結果を型 `T` のオブジェクトとして表現できない場合、引数が 3 個のメソッドは `InexactError` をスローする必要があります。

たとえば、https://github.com/JuliaPhysics/Measurements.jl, と同様に、取りうる値の範囲を表す `Interval` 型がある場合、次のようにその型の丸めを定義できます。

```jldoctest
julia> struct Interval{T}
           min::T
           max::T
       end

julia> Base.round(x::Interval, r::RoundingMode) = Interval(round(x.min, r), round(x.max, r))

julia> x = Interval(1.7, 2.2)
Interval{Float64}(1.7, 2.2)

julia> round(x)
Interval{Float64}(2.0, 2.0)

julia> floor(x)
Interval{Float64}(1.0, 2.0)

julia> ceil(x)
Interval{Float64}(2.0, 3.0)

julia> trunc(x)
Interval{Float64}(1.0, 2.0)
```
