# Sorting and Related Functions

Juliaは、すでにソートされた値の配列をソートし、対話するための広範で柔軟なAPIを提供しています。デフォルトでは、Juliaは合理的なアルゴリズムを選択し、昇順にソートします：

```jldoctest
julia> sort([2,3,1])
3-element Vector{Int64}:
 1
 2
 3
```

逆順にソートすることもできます:

```jldoctest
julia> sort([2,3,1], rev=true)
3-element Vector{Int64}:
 3
 2
 1
```

`sort` は、入力を変更せずにソートされたコピーを構築します。既存の配列を変更するために、ソート関数の「バン」バージョンを使用します：

```jldoctest
julia> a = [2,3,1];

julia> sort!(a);

julia> a
3-element Vector{Int64}:
 1
 2
 3
```

配列を直接ソートする代わりに、配列をソートされた順序に配置するインデックスの順列を計算することができます：

```julia-repl
julia> v = randn(5)
5-element Array{Float64,1}:
  0.297288
  0.382396
 -0.597634
 -0.0104452
 -0.839027

julia> p = sortperm(v)
5-element Array{Int64,1}:
 5
 3
 4
 1
 2

julia> v[p]
5-element Array{Float64,1}:
 -0.839027
 -0.597634
 -0.0104452
  0.297288
  0.382396
```

配列は、その値の任意の変換に従ってソートすることができます：

```julia-repl
julia> sort(v, by=abs)
5-element Array{Float64,1}:
 -0.0104452
  0.297288
  0.382396
 -0.597634
 -0.839027
```

または変換によって逆の順序で：

```julia-repl
julia> sort(v, by=abs, rev=true)
5-element Array{Float64,1}:
 -0.839027
 -0.597634
  0.382396
  0.297288
 -0.0104452
```

必要に応じて、ソートアルゴリズムを選択できます：

```julia-repl
julia> sort(v, alg=InsertionSort)
5-element Array{Float64,1}:
 -0.839027
 -0.597634
 -0.0104452
  0.297288
  0.382396
```

すべてのソートおよび順序関連の関数は、操作される値に対して「小なり」関係を定義する [strict weak order](https://en.wikipedia.org/wiki/Weak_ordering#Strict_weak_orderings) に依存しています。デフォルトでは `isless` 関数が呼び出されますが、関係は `lt` キーワードを介して指定できます。これは、2つの配列要素を受け取り、最初の引数が2番目の引数よりも「小さい」場合にのみ `true` を返す関数です。詳細については、[`sort!`](@ref) および [Alternate Orderings](@ref) を参照してください。

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

現在、ベースのJuliaには公開されている4つのソートアルゴリズムがあります：

  * [`InsertionSort`](@ref)
  * [`QuickSort`](@ref)
  * [`PartialQuickSort(k)`](@ref)
  * [`MergeSort`](@ref)

デフォルトでは、`sort`ファミリーの関数は、ほとんどの入力に対して高速な安定ソートアルゴリズムを使用します。正確なアルゴリズムの選択は、将来のパフォーマンス向上を可能にするための実装の詳細です。現在、入力の種類、サイズ、および構成に基づいて、`RadixSort`、`ScratchQuickSort`、`InsertionSort`、および`CountingSort`のハイブリッドが使用されています。実装の詳細は変更される可能性がありますが、現在は`??Base.DEFAULT_STABLE`の拡張ヘルプおよびそこにリストされている内部ソートアルゴリズムのドキュメントストリングで利用可能です。

`alg` キーワードを使用して、好みのアルゴリズムを明示的に指定できます（例: `sort!(v, alg=PartialQuickSort(10:20))`）。また、カスタムタイプのデフォルトのソートアルゴリズムを再構成するには、`Base.Sort.defalg` 関数に特化したメソッドを追加します。例えば、[InlineStrings.jl](https://github.com/JuliaStrings/InlineStrings.jl/blob/v1.3.2/src/InlineStrings.jl#L903) は以下のメソッドを定義します:

```julia
Base.Sort.defalg(::AbstractArray{<:Union{SmallInlineStrings, Missing}}) = InlineStringSort
```

!!! compat "Julia 1.9"
    デフォルトのソートアルゴリズム（`Base.Sort.defalg`によって返される）は、Julia 1.9以降、安定であることが保証されています。以前のバージョンでは、数値配列をソートする際に不安定なエッジケースがありました。


## Alternate Orderings

デフォルトでは、`sort`、`searchsorted`、および関連する関数は、どちらの要素が先に来るべきかを判断するために [`isless`](@ref) を使用して比較します。[`Base.Order.Ordering`](@ref) 抽象型は、同じ要素のセットに対して代替の順序を定義するためのメカニズムを提供します。`sort!` のようなソート関数を呼び出す際に、`Ordering` のインスタンスをキーワード引数 `order` とともに提供することができます。

`Ordering`のインスタンスは、[`Base.Order.lt`](@ref)関数を通じて順序を定義します。この関数は、`isless`の一般化として機能します。カスタム`Ordering`に対するこの関数の動作は、[strict weak order](https://en.wikipedia.org/wiki/Weak_ordering#Strict_weak_orderings)のすべての条件を満たさなければなりません。詳細と有効および無効な`lt`関数の例については、[`sort!`](@ref)を参照してください。

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
