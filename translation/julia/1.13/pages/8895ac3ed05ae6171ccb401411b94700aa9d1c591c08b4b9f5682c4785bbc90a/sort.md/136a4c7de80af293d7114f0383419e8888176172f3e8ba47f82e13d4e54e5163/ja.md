# Sorting and Related Functions

Juliaには、値の配列をソートしたり、すでにソート済みの配列を操作したりするための、豊富で柔軟なAPIが用意されています。デフォルトでは、Juliaは適切なアルゴリズムを選び、昇順にソートします。

```jldoctest
julia> sort([2,3,1])
3-element Vector{Int64}:
 1
 2
 3
```

降順にソートすることもできます。

```jldoctest
julia> sort([2,3,1], rev=true)
3-element Vector{Int64}:
 3
 2
 1
```

`sort`は、入力を変更せずにソート済みのコピーを作成します。既存の配列を変更するには、ソート関数の「bang」版を使います。

```jldoctest
julia> a = [2,3,1];

julia> sort!(a);

julia> a
3-element Vector{Int64}:
 1
 2
 3
```

配列を直接ソートする代わりに、配列がソート済みになるようなインデックスの順列を計算できます。

```jldoctest sort_example
julia> v = [0.297288, 0.382396, -0.597634, -0.0104452, -0.839027]
5-element Vector{Float64}:
  0.297288
  0.382396
 -0.597634
 -0.0104452
 -0.839027

julia> p = sortperm(v)
5-element Vector{Int64}:
 5
 3
 4
 1
 2

julia> v[p]
5-element Vector{Float64}:
 -0.839027
 -0.597634
 -0.0104452
  0.297288
  0.382396
```

値に任意の変換を適用した結果に基づいて、配列をソートすることもできます。

```jldoctest sort_example
julia> sort(v, by=abs)
5-element Vector{Float64}:
 -0.0104452
  0.297288
  0.382396
 -0.597634
 -0.839027
```

変換結果に基づいて降順にソートすることもできます。

```jldoctest sort_example
julia> sort(v, by=abs, rev=true)
5-element Vector{Float64}:
 -0.839027
 -0.597634
  0.382396
  0.297288
 -0.0104452
```

必要に応じて、ソートアルゴリズムを選択できます。

```jldoctest sort_example
julia> sort(v, alg=InsertionSort)
5-element Vector{Float64}:
 -0.839027
 -0.597634
 -0.0104452
  0.297288
  0.382396
```

ソートおよび順序に関する関数はすべて、操作対象の値に対する[strict weak order](https://en.wikipedia.org/wiki/Weak_ordering#Strict_weak_orderings)を定義する「より小さい」関係に依存します。デフォルトでは`isless`関数が呼び出されますが、`lt`キーワードで関係を指定することもできます。この関数は配列の要素を2つ受け取り、第1引数が第2引数より「小さい」場合に限り`true`を返します。詳しくは[`sort!`](@ref)および[Alternate Orderings](@ref)を参照してください。

## Sorting Functions

```@docs
Base.sort!
Base.sort
Base.sortperm
Base.InsertionSort
Base.MergeSort
Base.QuickSort
Base.PartialQuickSort
Base.Sort.sortperm!
Base.Sort.sortslices
```

## Order-Related Functions

```@docs
Base.issorted
Base.Sort.searchsorted
Base.Sort.searchsortedfirst
Base.Sort.searchsortedlast
Base.Sort.insorted
Base.Sort.partialsort!
Base.Sort.partialsort
Base.Sort.partialsortperm
Base.Sort.partialsortperm!
```

## Sorting Algorithms

現在、base Juliaでは次の4つのソートアルゴリズムが公開されています。

  * [`InsertionSort`](@ref)
  * [`QuickSort`](@ref)
  * [`PartialQuickSort(k)`](@ref)
  * [`MergeSort`](@ref)

デフォルトでは、`sort`系の関数は、ほとんどの入力で高速に動作する安定ソートアルゴリズムを使用します。将来の性能向上に備え、具体的なアルゴリズムの選択は実装の詳細として扱われます。現在は、入力の型、サイズ、構成に応じて、`RadixSort`、`ScratchQuickSort`、`InsertionSort`、`CountingSort`を組み合わせて使用しています。実装の詳細は変更される可能性がありますが、現時点では`??Base.DEFAULT_STABLE`の拡張ヘルプと、そこに記載されている内部ソートアルゴリズムのdocstringで確認できます。

`alg`キーワードを使って、希望するアルゴリズムを明示的に指定できます（例：`sort!(v, alg=PartialQuickSort(10:20))`）。また、`Base.Sort.defalg`関数に特化メソッドを追加すれば、カスタム型に対するデフォルトのソートアルゴリズムを再設定できます。たとえば、[InlineStrings.jl](https://github.com/JuliaStrings/InlineStrings.jl/blob/v1.3.2/src/InlineStrings.jl#L903)では、次のメソッドを定義しています。

```julia
Base.Sort.defalg(::AbstractArray{<:Union{SmallInlineStrings, Missing}}) = InlineStringSort
```

!!! compat "Julia 1.9"
    `Base.Sort.defalg`が返すデフォルトのソートアルゴリズムは、Julia 1.9以降、安定であることが保証されています。それ以前のバージョンでは、数値配列のソート時に不安定になるケースがありました。


## Alternate Orderings

デフォルトでは、`sort`、`searchsorted`などの関数は、[`isless`](@ref)を使って2つの要素を比較し、どちらを先に並べるかを決定します。[`Base.Order.Ordering`](@ref)抽象型を使うと、同じ要素集合に対して別の順序を定義できます。`sort!`のようなソート関数を呼び出す際に、キーワード引数`order`で`Ordering`のインスタンスを指定できます。

`Ordering`のインスタンスは、[`Base.Order.lt`](@ref)関数を通じて順序を定義します。この関数は`isless`を一般化したものです。カスタム`Ordering`に対するこの関数の動作は、[strict weak order](https://en.wikipedia.org/wiki/Weak_ordering#Strict_weak_orderings)のすべての条件を満たす必要があります。有効な`lt`関数と無効な関数の詳細や例については、[`sort!`](@ref)を参照してください。

```@docs
Base.Order.Ordering
Base.Order.lt
Base.Order.ord
Base.Order.Forward
Base.Order.ReverseOrdering
Base.Order.Reverse
Base.Order.By
Base.Order.Lt
Base.Order.Perm
```
