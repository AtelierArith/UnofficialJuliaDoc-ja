# Collections and Data Structures

## [Iteration](@id lib-collections-iteration)

逐次反復は、[`iterate`](@ref) 関数によって実装されています。一般的な `for` ループ:

```julia
for i in iter   # or  "for i = iter"
    # body
end
```

は、次のように変換されます。

```julia
next = iterate(iter)
while next !== nothing
    (i, state) = next
    # body
    next = iterate(iter, state)
end
```

`state` オブジェクトには任意のものを指定できます。各反復可能型に適したものを選んでください。カスタム反復可能型の定義について詳しくは、[manual section on the iteration interface](@ref man-interface-iteration) を参照してください。

```@docs
Base.iterate
Base.IteratorSize
Base.IteratorEltype
```

完全に実装されているもの:

  * [`AbstractRange`](@ref)
  * [`UnitRange`](@ref)
  * [`Tuple`](@ref)
  * [`Number`](@ref)
  * [`AbstractArray`](@ref)
  * [`BitSet`](@ref)
  * [`IdDict`](@ref)
  * [`Dict`](@ref)
  * [`WeakKeyDict`](@ref)
  * `EachLine`
  * [`AbstractString`](@ref)
  * [`Set`](@ref)
  * [`Pair`](@ref)
  * [`NamedTuple`](@ref)

## Constructors and Types

```@docs
Base.AbstractRange
Base.OrdinalRange
Base.AbstractUnitRange
Base.StepRange
Base.UnitRange
Base.AbstractOneTo
Base.LinRange
```

## General Collections

```@docs
Base.isempty
Base.isdone
Base.empty!
Base.length
Base.checked_length
```

完全に実装されているもの:

  * [`AbstractRange`](@ref)
  * [`UnitRange`](@ref)
  * [`Tuple`](@ref)
  * [`Number`](@ref)
  * [`AbstractArray`](@ref)
  * [`BitSet`](@ref)
  * [`IdDict`](@ref)
  * [`Dict`](@ref)
  * [`WeakKeyDict`](@ref)
  * [`AbstractString`](@ref)
  * [`Set`](@ref)
  * [`NamedTuple`](@ref)

## Iterable Collections

```@docs
Base.in
Base.:∉
Base.hasfastin
Base.eltype
Base.indexin
Base.unique
Base.unique!
Base.allunique
Base.allequal
Base.reduce(::Any, ::Any)
Base.reduce(::Any, ::AbstractArray)
Base.foldl(::Any, ::Any)
Base.foldr(::Any, ::Any)
Base.maximum
Base.maximum!
Base.minimum
Base.minimum!
Base.extrema
Base.extrema!
Base.argmax
Base.argmin
Base.findmax
Base.findmin
Base.findmax!
Base.findmin!
Base.sum
Base.sum!
Base.prod
Base.prod!
Base.any(::Any)
Base.any(::AbstractArray, ::Any)
Base.any!
Base.all(::Any)
Base.all(::AbstractArray, ::Any)
Base.all!
Base.count
Base.foreach
Base.map
Base.map!
Base.mapreduce(::Any, ::Any, ::Any)
Base.mapfoldl(::Any, ::Any, ::Any)
Base.mapfoldr(::Any, ::Any, ::Any)
Base.first
Base.last
Base.front
Base.tail
Base.step
Base.collect(::Any)
Base.collect(::Type, ::Any)
Base.filter
Base.filter!
Base.replace(::Any, ::Pair...)
Base.replace(::Base.Callable, ::Any)
Base.replace!
Base.rest
Base.split_rest
```

## Indexable Collections

```@docs
Base.getindex
Base.setindex!
Base.firstindex
Base.lastindex
```

完全に実装されているもの:

  * [`Array`](@ref)
  * [`BitArray`](@ref)
  * [`AbstractArray`](@ref)
  * `SubArray`

部分的に実装されているもの:

  * [`AbstractRange`](@ref)
  * [`UnitRange`](@ref)
  * [`Tuple`](@ref)
  * [`AbstractString`](@ref)
  * [`Dict`](@ref)
  * [`IdDict`](@ref)
  * [`WeakKeyDict`](@ref)
  * [`NamedTuple`](@ref)

## Dictionaries

[`Dict`](@ref) は標準の辞書です。その実装では、キーのハッシュ関数として [`hash`](@ref) を、等価性の判定に [`isequal`](@ref) を使用します。カスタム型の保存方法をハッシュテーブル内で変更するには、これら2つの関数を定義してください。

[`IdDict`](@ref) は、キーが常にオブジェクトの同一性である特殊なハッシュテーブルです。

[`WeakKeyDict`](@ref) は、キーとしてオブジェクトへの弱参照を使用するハッシュテーブルの実装です。そのため、ハッシュテーブルから参照されていても、キーはガベージコレクションの対象になることがあります。`Dict` と同様に、ハッシュ計算には `hash` を、等価性の判定には `isequal` を使用します。一方、`Dict` とは異なり、挿入時にキーを変換しません。

[`Dict`](@ref) は、`=>` で構築したペアオブジェクトを [`Dict`](@ref) コンストラクターに渡して作成できます: `Dict("A"=>1, "B"=>2)`。この呼び出しでは、キーと値から型情報を推論しようとします（つまり、この例では `Dict{String, Int64}` が作成されます）。型を明示的に指定するには、`Dict{KeyType,ValueType}(...)` の構文を使用します。たとえば、`Dict{String,Int32}("A"=>1, "B"=>2)` のようにします。

辞書はジェネレーターを使って作成することもできます。たとえば、`Dict(i => f(i) for i = 1:10)` のようにします。

辞書 `D` に対して、構文 `D[x]` は、キー `x` の値を返します（キーが存在する場合）。存在しない場合はエラーをスローします。また、`D[x] = y` は、キーと値のペア `x => y` を `D` に格納します（キー `x` に既存の値があれば置き換えます）。`D[...]` に複数の引数を渡すと、それらはタプルに変換されます。たとえば、構文 `D[x,y]` は `D[(x,y)]` と同等であり、タプル `(x,y)` をキーとする値を参照します。

```@docs
Base.AbstractDict
Base.Dict
Base.IdDict
Base.WeakKeyDict
Base.ImmutableDict
Base.PersistentDict
Base.haskey
Base.get
Base.get!
Base.getkey
Base.delete!
Base.pop!(::Any, ::Any, ::Any)
Base.keys
Base.values
Base.pairs
Base.merge
Base.mergewith
Base.merge!
Base.mergewith!
Base.sizehint!
Base.keytype
Base.valtype
```

完全に実装されているもの:

  * [`Dict`](@ref)
  * [`IdDict`](@ref)
  * [`WeakKeyDict`](@ref)

部分的に実装されているもの:

  * [`Set`](@ref)
  * [`BitSet`](@ref)
  * [`IdSet`](@ref)
  * [`EnvDict`](@ref Base.EnvDict)
  * [`Array`](@ref)
  * [`BitArray`](@ref)
  * [`ImmutableDict`](@ref Base.ImmutableDict)
  * [`PersistentDict`](@ref Base.PersistentDict)
  * [`Iterators.Pairs`](@ref)

## Set-Like Collections

```@docs
Base.AbstractSet
Base.Set
Base.BitSet
Base.IdSet
Base.union
Base.union!
Base.intersect
Base.setdiff
Base.setdiff!
Base.symdiff
Base.symdiff!
Base.intersect!
Base.issubset
Base.in!
Base.:⊈
Base.:⊊
Base.issetequal
Base.isdisjoint
```

完全に実装されているもの:

  * [`Set`](@ref)
  * [`BitSet`](@ref)
  * [`IdSet`](@ref)

部分的に実装されているもの:

  * [`Array`](@ref)

## Deques

```@docs
Base.push!
Base.pop!
Base.popat!
Base.pushfirst!
Base.popfirst!
Base.insert!
Base.deleteat!
Base.keepat!
Base.splice!
Base.resize!
Base.append!
Base.prepend!
```

完全に実装されているもの:

  * `Vector`（別名、1次元の [`Array`](@ref)）
  * `BitVector`（別名、1次元の [`BitArray`](@ref)）

## Utility Collections

```@docs
Base.Pair
Iterators.Pairs
```
