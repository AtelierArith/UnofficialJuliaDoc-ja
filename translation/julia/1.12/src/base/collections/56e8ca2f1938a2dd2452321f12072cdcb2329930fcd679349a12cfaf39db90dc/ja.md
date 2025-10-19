# Collections and Data Structures

## [Iteration](@id lib-collections-iteration)

逐次反復は [`iterate`](@ref) 関数によって実装されています。一般的な `for` ループ：

```julia
for i in iter   # or  "for i = iter"
    # body
end
```

翻訳されます:

```julia
next = iterate(iter)
while next !== nothing
    (i, state) = next
    # body
    next = iterate(iter, state)
end
```

`state`オブジェクトは何でもよく、各イテラブルタイプに適切に選択する必要があります。カスタムイテラブルタイプを定義する詳細については、[manual section on the iteration interface](@ref man-interface-iteration)を参照してください。

```@docs
Base.iterate
Base.IteratorSize
Base.IteratorEltype
```

完全に実装されたのは：

  * [`AbstractRange`](@ref)
  * [`UnitRange`](@ref)
  * [`Tuple`](@ref)
  * [`Number`](@ref)
  * [`AbstractArray`](@ref)
  * [`BitSet`](@ref)
  * [`IdDict`](@ref)
  * [`Dict`](@ref)
  * [`WeakKeyDict`](@ref)
  * `各行`
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

完全に実装されたのは：

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

完全に実装されたのは：

  * [`Array`](@ref)
  * [`BitArray`](@ref)
  * [`AbstractArray`](@ref)
  * `サブ配列`

部分的に実装されたのは：

  * [`AbstractRange`](@ref)
  * [`UnitRange`](@ref)
  * [`Tuple`](@ref)
  * [`AbstractString`](@ref)
  * [`Dict`](@ref)
  * [`IdDict`](@ref)
  * [`WeakKeyDict`](@ref)
  * [`NamedTuple`](@ref)

## Dictionaries

[`Dict`](@ref)は標準辞書です。その実装では、[`hash`](@ref)をキーのハッシュ関数として使用し、[`isequal`](@ref)を等価性を決定するために使用します。カスタムタイプのためにこれらの2つの関数を定義して、ハッシュテーブルにどのように格納されるかをオーバーライドします。

[`IdDict`](@ref) は、キーが常にオブジェクトのアイデンティティである特別なハッシュテーブルです。

[`WeakKeyDict`](@ref) は、キーがオブジェクトへの弱い参照であるハッシュテーブルの実装であり、ハッシュテーブル内で参照されていてもガーベジコレクションされる可能性があります。`Dict` と同様に、ハッシュ化には `hash` を使用し、等価性には `isequal` を使用しますが、`Dict` とは異なり、挿入時にキーを変換しません。

[`Dict`](@ref) は、`=>` で構築されたペアオブジェクトを `4d61726b646f776e2e436f64652822222c2022446963742229_40726566` コンストラクタに渡すことで作成できます: `Dict("A"=>1, "B"=>2)`。この呼び出しは、キーと値から型情報を推測しようとします（つまり、この例では `Dict{String, Int64}` が作成されます）。型を明示的に指定するには、構文 `Dict{KeyType,ValueType}(...)` を使用します。例えば、`Dict{String,Int32}("A"=>1, "B"=>2)` のようになります。

辞書はジェネレーターを使って作成することもできます。例えば、`Dict(i => f(i) for i = 1:10)`。

辞書 `D` がある場合、構文 `D[x]` はキー `x` の値を返します（存在する場合）またはエラーをスローします。また、`D[x] = y` はキー-値ペア `x => y` を `D` に格納します（キー `x` の既存の値を置き換えます）。`D[...]` に対する複数の引数はタプルに変換されます。たとえば、構文 `D[x,y]` は `D[(x,y)]` と同等であり、タプル `(x,y)` によってキー付けされた値を参照します。

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

完全に実装されたのは：

  * [`Dict`](@ref)
  * [`IdDict`](@ref)
  * [`WeakKeyDict`](@ref)

部分的に実装されたのは：

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

完全に実装されたのは：

  * [`Set`](@ref)
  * [`BitSet`](@ref)
  * [`IdSet`](@ref)

部分的に実装されたのは：

  * [`Array`](@ref)

## Dequeues

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

完全に実装されたのは：

  * `Vector`（別名 1次元 [`Array`](@ref)）
  * `BitVector`（別名 1次元 [`BitArray`](@ref)）

## Utility Collections

```@docs
Base.Pair
Iterators.Pairs
```
