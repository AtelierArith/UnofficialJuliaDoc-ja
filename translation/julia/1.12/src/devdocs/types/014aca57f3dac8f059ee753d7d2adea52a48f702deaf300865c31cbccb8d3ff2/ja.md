# More about types

もしあなたがしばらくの間Juliaを使用しているなら、型が果たす基本的な役割を理解しているでしょう。ここでは、特に [Parametric Types](@ref) に焦点を当てて、内部を掘り下げてみます。

## Types and sets (and `Any` and `Union{}`/`Bottom`)

おそらく、ジュリアの型システムを集合の観点から考えるのが最も簡単です。プログラムは個々の値を操作しますが、型は値の集合を指します。これはコレクションとは異なります。たとえば、[`Set`](@ref) の値は、それ自体が単一の `Set` 値です。むしろ、型は*可能な*値の集合を説明し、どの値を持っているかについての不確実性を表現します。

型 `T` の *具体的* なタイプは、[`typeof`](@ref) 関数によって返される直接タグが `T` である値の集合を記述します。*抽象的* なタイプは、より大きな値の集合を記述します。

[`Any`](@ref) は可能な値の全宇宙を表します。 [`Integer`](@ref) は `Any` のサブセットであり、`Int`、[`Int8`](@ref)、および他の具体的な型を含みます。内部的に、Julia は `Bottom` として知られる別の型を重用しており、これは `Union{}` としても書くことができます。これは空集合に対応します。

Juliaの型は集合論の標準的な操作をサポートしています：`T1`が`T2`の「部分集合」（サブタイプ）であるかどうかを`T1 <: T2`で確認できます。同様に、[`typeintersect`](@ref)を使用して2つの型を交差させ、[`Union`](@ref)を使用してそれらの和を取ります。そして、[`typejoin`](@ref)を使用してそれらの和を含む型を計算します：

```jldoctest
julia> typeintersect(Int, Float64)
Union{}

julia> Union{Int, Float64}
Union{Float64, Int64}

julia> typejoin(Int, Float64)
Real

julia> typeintersect(Signed, Union{UInt8, Int8})
Int8

julia> Union{Signed, Union{UInt8, Int8}}
Union{UInt8, Signed}

julia> typejoin(Signed, Union{UInt8, Int8})
Integer

julia> typeintersect(Tuple{Integer, Float64}, Tuple{Int, Real})
Tuple{Int64, Float64}

julia> Union{Tuple{Integer, Float64}, Tuple{Int, Real}}
Union{Tuple{Int64, Real}, Tuple{Integer, Float64}}

julia> typejoin(Tuple{Integer, Float64}, Tuple{Int, Real})
Tuple{Integer, Real}
```

これらの操作は抽象的に見えるかもしれませんが、Juliaの中心にあります。例えば、メソッドディスパッチは、メソッドリスト内のアイテムを順に確認し、引数タプルの型がメソッドシグネチャのサブタイプであるものに到達することで実装されています。このアルゴリズムが機能するためには、メソッドがその特異性によってソートされていることが重要であり、検索は最も特異的なメソッドから始まります。その結果、Juliaは型に対して部分順序も実装しています。これは`<:`に似た機能によって達成されますが、以下で説明する違いがあります。

## UnionAll types

Juliaの型システムは、型の*反復的な和*を表現することもできます。これは、ある変数のすべての値に対する型の和です。これは、いくつかのパラメータの値が不明な場合のパラメトリック型を説明するために必要です。

例えば、[`Array`](@ref) には `Array{Int,2}` のように2つのパラメータがあります。要素の型がわからない場合、`Array{T,2} where T` と書くことができ、これはすべての値の `T` に対する `Array{T,2}` の和集合です：`Union{Array{Int8,2}, Array{Int16,2}, ...}`。

そのような型は `UnionAll` オブジェクトによって表され、変数（この例では `TypeVar` 型の `T`）とラップされた型（この例では `Array{T,2}`）を含みます。

次のメソッドを考慮してください：

```julia
f1(A::Array) = 1
f2(A::Array{Int}) = 2
f3(A::Array{T}) where {T<:Any} = 3
f4(A::Array{Any}) = 4
```

署名 - [Function calls](@ref Function-calls) に記載されているように - `f3` の型は、タプル型をラップした `UnionAll` 型です: `Tuple{typeof(f3), Array{T}} where T`。`f4` を除くすべては `a = [1,2]` で呼び出すことができ、`f2` を除くすべては `b = Any[1,2]` で呼び出すことができます。

これらのタイプをもう少し詳しく見てみましょう：

```jldoctest
julia> dump(Array)
UnionAll
  var: TypeVar
    name: Symbol T
    lb: Union{}
    ub: abstract type Any
  body: UnionAll
    var: TypeVar
      name: Symbol N
      lb: Union{}
      ub: abstract type Any
    body: mutable struct Array{T, N} <: DenseArray{T, N}
      ref::MemoryRef{T}
      size::NTuple{N, Int64}
```

これは、`Array`が実際には`UnionAll`型の名前であることを示しています。各パラメータに対して1つの`UnionAll`型があり、ネストされています。構文`Array{Int,2}`は`Array{Int}{2}`と同等です。内部的には、各`UnionAll`は特定の変数値で一度に1つずつ、外側から内側へとインスタンス化されます。これにより、末尾の型パラメータを省略することに自然な意味が与えられます。`Array{Int}`は、`Array{Int,N} where N`と同等の型を提供します。

`TypeVar`はそれ自体が型ではなく、むしろ`UnionAll`型の構造の一部と見なされるべきです。型変数には、その値に対する下限（`lb`）と上限（`ub`）があります。シンボル`name`は純粋に装飾的なものです。内部的には、`TypeVar`はアドレスによって比較されるため、異なる型変数を区別できるように可変型として定義されています。しかし、慣習としてそれらは変更されるべきではありません。

`TypeVar`を手動で構築することができます：

```jldoctest
julia> TypeVar(:V, Signed, Real)
Signed<:V<:Real
```

`name` シンボルを除くこれらの引数のいずれかを省略できる便利なバージョンがあります。

構文 `Array{T} where T<:Integer` は次のように低下されます。

```julia
let T = TypeVar(:T,Integer)
    UnionAll(T, Array{T})
end
```

そのため、`TypeVar`を手動で構築する必要はめったにありません（実際、これは避けるべきです）。

## Free variables

*自由* 型変数の概念は、型システムにおいて非常に重要です。変数 `V` が型 `T` の中で自由であるとは、`T` が変数 `V` を導入する `UnionAll` を含まない場合を指します。例えば、型 `Array{Array{V} where V<:Integer}` には自由変数がありませんが、その中の `Array{V}` 部分には自由変数 `V` があります。

自由変数を持つ型は、ある意味では本当に型ではありません。型 `Array{Array{T}} where T` を考えてみましょう。これはすべての同種の配列の配列を指します。内側の型 `Array{T}` は、単独で見ると、あらゆる種類の配列を指しているように見えるかもしれません。しかし、外側の配列のすべての要素は*同じ*配列型を持たなければならないため、`Array{T}` は単なる古い配列を指すことはできません。言い換えれば、`Array{T}` は実質的に複数回「出現」し、`T` は各「回」で同じ値を持たなければならないと言えるでしょう。

この理由から、C API の `jl_has_free_typevars` 関数は非常に重要です。これが true を返す型は、サブタイピングやその他の型関数において意味のある回答を提供しません。

## TypeNames

次の2つの [`Array`](@ref) タイプは機能的に同等ですが、出力が異なります：

```jldoctest
julia> TV, NV = TypeVar(:T), TypeVar(:N)
(T, N)

julia> Array
Array

julia> Array{TV, NV}
Array{T, N}
```

これらは、`TypeName`型のオブジェクトであるタイプの`name`フィールドを調べることで区別できます：

```julia-repl
julia> dump(Array{Int,1}.name)
TypeName
  name: Symbol Array
  module: Module Core
  singletonname: Symbol Array
  names: SimpleVector
    1: Symbol ref
    2: Symbol size
  atomicfields: Ptr{Nothing}(0x0000000000000000)
  constfields: Ptr{Nothing}(0x0000000000000000)
  wrapper: UnionAll
    var: TypeVar
      name: Symbol T
      lb: Union{}
      ub: abstract type Any
    body: UnionAll
      var: TypeVar
        name: Symbol N
        lb: Union{}
        ub: abstract type Any
      body: mutable struct Array{T, N} <: DenseArray{T, N}
  Typeofwrapper: abstract type Type{Array} <: Any
  cache: SimpleVector
    ...
  linearcache: SimpleVector
    ...
  hash: Int64 2594190783455944385
  backedges: #undef
  partial: #undef
  max_args: Int32 0
  n_uninitialized: Int32 0
  flags: UInt8 0x02
  cache_entry_count: UInt8 0x00
  max_methods: UInt8 0x00
  constprop_heuristic: UInt8 0x00
```

この場合、関連するフィールドは `wrapper` であり、新しい `Array` タイプを作成するために使用されるトップレベルのタイプへの参照を保持しています。

```julia-repl
julia> pointer_from_objref(Array)
Ptr{Cvoid} @0x00007fcc7de64850

julia> pointer_from_objref(Array.body.body.name.wrapper)
Ptr{Cvoid} @0x00007fcc7de64850

julia> pointer_from_objref(Array{TV,NV})
Ptr{Cvoid} @0x00007fcc80c4d930

julia> pointer_from_objref(Array{TV,NV}.name.wrapper)
Ptr{Cvoid} @0x00007fcc7de64850
```

[`Array`](@ref)の`wrapper`フィールドは自分自身を指しますが、`Array{TV,NV}`の場合は型の元の定義に戻ります。

他のフィールドはどうでしょうか？ `hash` は各タイプに整数を割り当てます。 `cache` フィールドを調べるには、Array よりもあまり使用されていないタイプを選ぶと便利です。まずは自分のタイプを作成しましょう：

```jldoctest
julia> struct MyType{T,N} end

julia> MyType{Int,2}
MyType{Int64, 2}

julia> MyType{Float32, 5}
MyType{Float32, 5}
```

パラメトリック型をインスタンス化すると、各具体的な型が型キャッシュ（`MyType.body.body.name.cache`）に保存されます。ただし、自由型変数を含むインスタンスはキャッシュされません。

## Tuple types

タプル型は興味深い特別なケースを構成します。`x::Tuple`のような宣言でディスパッチが機能するためには、その型が任意のタプルを受け入れることができなければなりません。パラメータを確認してみましょう：

```jldoctest
julia> Tuple
Tuple

julia> Tuple.parameters
svec(Vararg{Any})
```

他のタイプとは異なり、タプルタイプはそのパラメータにおいて共変であるため、この定義により `Tuple` は任意のタイプのタプルと一致することができます：

```jldoctest
julia> typeintersect(Tuple, Tuple{Int,Float64})
Tuple{Int64, Float64}

julia> typeintersect(Tuple{Vararg{Any}}, Tuple{Int,Float64})
Tuple{Int64, Float64}
```

しかし、可変引数（`Vararg`）のタプル型に自由変数がある場合、異なる種類のタプルを記述することができます：

```jldoctest
julia> typeintersect(Tuple{Vararg{T} where T}, Tuple{Int,Float64})
Tuple{Int64, Float64}

julia> typeintersect(Tuple{Vararg{T}} where T, Tuple{Int,Float64})
Union{}
```

`T`が`Tuple`型に対して自由である場合（つまり、そのバインディング`UnionAll`型が`Tuple`型の外にある場合）、全体の型に対して1つの`T`値のみが機能しなければなりません。したがって、異種タプルは一致しません。

最後に、`Tuple{}`は異なることに注意する価値があります：

```jldoctest
julia> Tuple{}
Tuple{}

julia> Tuple{}.parameters
svec()

julia> typeintersect(Tuple{}, Tuple{Int})
Union{}
```

「プライマリ」タプル型とは何ですか？

```julia-repl
julia> pointer_from_objref(Tuple)
Ptr{Cvoid} @0x00007f5998a04370

julia> pointer_from_objref(Tuple{})
Ptr{Cvoid} @0x00007f5998a570d0

julia> pointer_from_objref(Tuple.name.wrapper)
Ptr{Cvoid} @0x00007f5998a04370

julia> pointer_from_objref(Tuple{}.name.wrapper)
Ptr{Cvoid} @0x00007f5998a04370
```

したがって、`Tuple == Tuple{Vararg{Any}}` は確かに主要な型です。

## Diagonal types

`Tuple{T,T} where T`の型を考えてみてください。このシグネチャを持つメソッドは次のようになります:

```julia
f(x::T, y::T) where {T} = ...
```

通常の`UnionAll`型の解釈によれば、この`T`はすべての型、つまり`Any`を含むすべての型にわたるため、この型は`Tuple{Any,Any}`と同等であるべきです。しかし、この解釈は実際的な問題を引き起こします。

まず、`T` の値がメソッド定義内で利用可能である必要があります。`f(1, 1.0)` のような呼び出しでは、`T` が何であるべきかは明確ではありません。`Union{Int,Float64}` である可能性もありますし、あるいは [`Real`](@ref) かもしれません。直感的には、宣言 `x::T` は `T === typeof(x)` を意味することを期待します。この不変性を確保するためには、このメソッド内で `typeof(x) === typeof(y) === T` である必要があります。つまり、このメソッドは正確に同じ型の引数に対してのみ呼び出されるべきです。

2つの値が同じ型であるかどうかに基づいてディスパッチできることは非常に便利であることがわかりました（これはプロモーションシステムによって使用されます）。したがって、`Tuple{T,T} where T`の異なる解釈を望む理由がいくつかあります。これを機能させるために、サブタイピングに次のルールを追加します：変数が共変位置に複数回出現する場合、それは具体的な型の範囲に制限されます。（「共変位置」とは、変数の出現とそれを導入する`UnionAll`型の間に`Tuple`および`Union`型のみが出現することを意味します。）このような変数は「対角変数」または「具体的変数」と呼ばれます。

例えば、`Tuple{T,T} where T` は `Union{Tuple{Int8,Int8}, Tuple{Int16,Int16}, ...}` と見なすことができ、ここで `T` はすべての具体的な型を範囲とします。これにより、いくつかの興味深いサブタイピングの結果が生じます。例えば、`Tuple{Real,Real}` は `Tuple{T,T} where T` のサブタイプではありません。なぜなら、`Tuple{Int8,Int16}` のように、2つの要素が異なる型を持つ型を含むからです。`Tuple{Real,Real}` と `Tuple{T,T} where T` は、非自明な交差点 `Tuple{T,T} where T<:Real` を持っています。しかし、`Tuple{Real}` は `Tuple{T} where T` のサブタイプです。なぜなら、その場合 `T` は一度だけ出現し、したがって対角的ではないからです。

次に、以下のような署名を考えてみてください：

```julia
f(a::Array{T}, x::T, y::T) where {T} = ...
```

この場合、`T`は`Array{T}`の不変位置に出現します。つまり、どのタイプの配列が渡されても、`T`の値が明確に決まります – 我々は`T`に*等式制約*があると言います。したがって、この場合、対角ルールは本当に必要ではありません。配列が`T`を決定し、その後`x`と`y`が`T`の任意のサブタイプであることを許可できます。したがって、不変位置に出現する変数は決して対角とは見なされません。この動作の選択はやや物議を醸しています – 一部の人々はこの定義を次のように書くべきだと感じています。

```julia
f(a::Array{T}, x::S, y::S) where {T, S<:T} = ...
```

`x` と `y` が同じ型である必要があるかどうかを明確にするために。このバージョンのシグネチャでは、同じ型である必要がありますが、`x` と `y` が異なる型を持つことができる場合は、`y` の型のために第三の変数を導入することができます。

次の複雑さは、ユニオンと対角変数の相互作用です。例えば、

```julia
f(x::Union{Nothing,T}, y::T) where {T} = ...
```

この宣言が何を意味するか考えてみてください。`y`は型`T`を持っています。したがって、`x`は同じ型`T`を持つか、または型[`Nothing`](@ref)である可能性があります。したがって、以下のすべての呼び出しは一致する必要があります：

```julia
f(1, 1)
f("", "")
f(2.0, 2.0)
f(nothing, 1)
f(nothing, "")
f(nothing, 2.0)
```

これらの例は私たちに何かを伝えています：`x` が `nothing::Nothing` のとき、`y` に対する追加の制約はありません。まるでメソッドシグネチャに `y::Any` があるかのようです。実際、次の型の同値性があります：

```julia
(Tuple{Union{Nothing,T},T} where T) == Union{Tuple{Nothing,Any}, Tuple{T,T} where T}
```

一般的なルールは、共変位置にある具体的な変数は、サブタイピングアルゴリズムがそれを一度だけ*使用*する場合、具体的でないかのように振る舞うということです。`x`が型`Nothing`を持つとき、`Union{Nothing,T}`の中で`T`を使用する必要はありません; 私たちはそれを2番目のスロットでのみ使用します。これは、`Tuple{T} where T`において、`T`を具体的な型に制限しても違いがないという観察から自然に生じます; 型はどちらの場合も`Tuple{Any}`に等しいです。

しかし、*不変*な位置に現れることは、変数が具体的であることを無効にします。その変数の出現が使用されるかどうかにかかわらずです。そうでなければ、型は比較される他の型によって異なる動作をする可能性があり、サブタイプ関係が推移的でなくなります。例えば、次のように考えてみてください。

```julia
Tuple{Int,Int8,Vector{Integer}} <: Tuple{T,T,Vector{Union{Integer,T}}} where T
```

`Union`の中の`T`が無視されると、`T`は具体的であり、答えは「false」になります。なぜなら最初の2つの型は同じではないからです。しかし、代わりに考えてみてください。

```julia
Tuple{Int,Int8,Vector{Any}} <: Tuple{T,T,Vector{Union{Integer,T}}} where T
```

今、私たちは `Union` の中の `T` を無視することはできません（`T == Any` でなければなりません）、したがって `T` は具体的ではなく、答えは「真」です。これにより、`T` の具体性は他の型に依存することになり、型は自分自身で明確な意味を持たなければならないため、受け入れられません。したがって、`Vector` 内の `T` の出現は両方のケースで考慮されます。

## Subtyping diagonal variables

対角変数のサブタイピングアルゴリズムには2つの要素があります：(1) 変数の出現を特定すること、(2) 対角変数が具体的な型のみに範囲を持つことを保証することです。

最初のタスクは、環境内の各変数に対して `occurs_inv` と `occurs_cov`（`src/subtype.c`内）というカウンタを保持することで達成され、各変数の不変および共変の出現回数を追跡します。変数は、`occurs_inv == 0 && occurs_cov > 1` のときに対角的です。

第二のタスクは、変数の下限に条件を課すことによって達成されます。サブタイピングアルゴリズムが実行されると、各変数の範囲を狭め（下限を上げ、上限を下げ）、サブタイプ関係が成り立つ変数値の範囲を追跡します。`UnionAll`型のボディの評価が完了したとき、対角線上の変数の最終的な境界値を確認します。変数は具体的でなければならないため、その下限が具体的な型のサブタイプでない場合、矛盾が発生します。たとえば、[`AbstractArray`](@ref)のような抽象型は具体的な型のサブタイプにはなれませんが、`Int`のような具体的な型はサブタイプになれますし、空の型`Bottom`もそうです。下限がこのテストに失敗した場合、アルゴリズムは`false`という答えで停止します。

例えば、問題 `Tuple{Int,String} <: Tuple{T,T} where T` において、`T` が `Union{Int,String}` の上位型であればこれは真であると導きます。しかし、`Union{Int,String}` は抽象型であるため、この関係は成り立ちません。

この具体性テストは、関数 `is_leaf_bound` によって行われます。このテストは `jl_is_leaf_type` とは少し異なり、`Bottom` に対しても `true` を返します。現在、この関数はヒューリスティックであり、すべての可能な具体的型を捕捉するわけではありません。下限が具体的であるかどうかは、他の型変数の下限の値に依存する可能性があるため、難しさがあります。たとえば、`Vector{T}` は、`T` の上限と下限が両方とも `Int` の場合にのみ、具体的な型 `Vector{Int}` と同等です。私たちはまだこれに対する完全なアルゴリズムを考案していません。

## Introduction to the internal machinery

タイプを扱うためのほとんどの操作は、`jltypes.c` と `subtype.c` のファイルにあります。始める良い方法は、サブタイピングの実行を観察することです。`make debug` で Julia をビルドし、デバッガ内で Julia を起動します。[gdb debugging tips](@ref gdb-debugging-tips) には役立つかもしれないいくつかのヒントがあります。

REPL自体でサブタイピングコードが頻繁に使用されるため、このコードのブレークポイントがしばしばトリガーされます。そのため、次の定義を行うのが最も簡単です：

```julia-repl
julia> function mysubtype(a,b)
           ccall(:jl_breakpoint, Cvoid, (Any,), nothing)
           a <: b
       end
```

そして、`jl_breakpoint`にブレークポイントを設定します。このブレークポイントがトリガーされると、他の関数にブレークポイントを設定できます。

ウォームアップとして、次のことを試してください：

```julia
mysubtype(Tuple{Int, Float64}, Tuple{Integer, Real})
```

より複雑なケースに挑戦することで、もっと面白くすることができます:

```julia
mysubtype(Tuple{Array{Int,2}, Int8}, Tuple{Array{T}, T} where T)
```

## Subtyping and method sorting

`type_morespecific` 関数は、メソッドテーブル内の関数に部分順序を課すために使用されます（最も特異的なものから最も一般的なものへ）。特異性は厳密です。もし `a` が `b` よりも特異的であれば、`a` は `b` と等しくなく、`b` は `a` よりも特異的ではありません。

もし `a` が `b` の厳密なサブタイプであれば、自動的により具体的であると見なされます。そこから、`type_morespecific` はいくつかのあまり形式的でないルールを適用します。例えば、`subtype` は引数の数に敏感ですが、`type_morespecific` はそうではないかもしれません。特に、`Tuple{Int,AbstractFloat}` は `Tuple{Integer}` よりも具体的ですが、サブタイプではありません。 (`Tuple{Int,AbstractFloat}` と `Tuple{Integer,Float64}` のどちらも、他のものより具体的ではありません。) 同様に、`Tuple{Int,Vararg{Int}}` は `Tuple{Integer}` のサブタイプではありませんが、より具体的であると見なされます。しかし、`morespecific` は長さに対してボーナスを得ます：特に、`Tuple{Int,Int}` は `Tuple{Int,Vararg{Int}}` よりも具体的です。

さらに、同一のシグネチャを持つ2つのメソッドが定義されている場合、型が等しい限り、それらは追加の順序によって比較され、後に追加されたメソッドが前のメソッドよりも特異的になります。
