# More about types

Juliaをしばらく使っていれば、型が果たす基本的な役割は理解しているでしょう。ここでは、特に[Parametric Types](@ref)に焦点を当てて、その内部の仕組みを見ていきます。

## Types and sets (and `Any` and `Union{}`/`Bottom`)

Juliaの型システムは、集合として捉えると最も理解しやすいかもしれません。プログラムが個々の値を操作するのに対し、型は値の集合を指します。ただし、これはコレクションとは異なります。たとえば、値の[`Set`](@ref)自体は、単一の`Set`値です。型が表すのは、取り得る値の集合であり、手元の値がそのうちのどれなのか確定していないことを表現します。

*具象型*`T`は、[`typeof`](@ref)関数が返す直接のタグが`T`である値の集合を表します。*抽象型*は、それより大きい可能性のある値の集合を表します。

[`Any`](@ref)は、取り得るすべての値からなる全体集合を表します。[`Integer`](@ref)は`Any`の部分集合であり、`Int`、[`Int8`](@ref)、その他の具象型を含みます。Juliaの内部では、`Bottom`という別の型も多用されます。これは`Union{}`とも表記でき、空集合に対応します。

Juliaの型は、集合論の標準的な演算をサポートしています。`T1`が`T2`の「部分集合」（部分型）かどうかは、`T1 <: T2`で調べられます。同様に、[`typeintersect`](@ref)で2つの型の共通部分を、[`Union`](@ref)で和集合を求められます。また、[`typejoin`](@ref)で、それらの和集合を含む型を計算できます。

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

これらの演算は抽象的に見えるかもしれませんが、Juliaの中核を成しています。たとえば、メソッドディスパッチは、メソッドリストの要素を順に調べ、引数タプルの型がメソッドシグネチャの部分型となるメソッドに到達することで実装されています。このアルゴリズムが機能するには、メソッドが特異性の順に並んでいて、最も特異性の高いメソッドから探索を始めることが重要です。そのため、Juliaは型の半順序も実装しています。これは`<:`に似た機能で実現されていますが、後述する違いがあります。

## UnionAll types

Juliaの型システムでは、型の*反復和集合*、つまりある変数が取り得るすべての値にわたる型の和集合も表現できます。これは、一部のパラメータの値が不明なパラメトリック型を記述するために必要です。

たとえば、[`Array`](@ref)には、`Array{Int,2}`のように2つのパラメータがあります。要素型が不明な場合は、`Array{T,2} where T`と書けます。これは`T`のすべての値にわたる`Array{T,2}`の和集合、すなわち`Union{Array{Int8,2}, Array{Int16,2}, ...}`です。

このような型は、`UnionAll`オブジェクトで表されます。このオブジェクトは、変数（この例では`T`で、型は`TypeVar`）と、ラップされた型（この例では`Array{T,2}`）を保持します。

次のメソッドを考えてみましょう。

```julia
f1(A::Array) = 1
f2(A::Array{Int}) = 2
f3(A::Array{T}) where {T<:Any} = 3
f4(A::Array{Any}) = 4
```

[Function calls](@ref Function-calls)で説明されているとおり、`f3`のシグネチャは、タプル型をラップした`UnionAll`型、すなわち`Tuple{typeof(f3), Array{T}} where T`です。`f4`以外はすべて`a = [1,2]`で呼び出せます。また、`f2`以外はすべて`b = Any[1,2]`で呼び出せます。

これらの型をもう少し詳しく見てみましょう。

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

ここから、`Array`は実際には`UnionAll`型の名前であることがわかります。パラメータごとに1つの`UnionAll`型があり、それらが入れ子になっています。`Array{Int,2}`という構文は`Array{Int}{2}`と等価です。内部では、各`UnionAll`が、最も外側から順に1つずつ、特定の変数値でインスタンス化されます。これにより、末尾の型パラメータの省略に自然な意味が与えられます。`Array{Int}`は、`Array{Int,N} where N`と等価な型になります。

`TypeVar`自体は型ではなく、`UnionAll`型の構造の一部と考えるべきものです。型変数の値には下限と上限があり、それぞれ`lb`フィールドと`ub`フィールドに格納されています。シンボル`name`は、見た目のためだけのものです。内部では、`TypeVar`同士はアドレスで比較されます。そのため、「異なる」型変数を確実に区別できるように、可変型として定義されています。ただし、慣例として、その内容を変更すべきではありません。

`TypeVar`は手動でも構築できます。

```jldoctest
julia> TypeVar(:V, Signed, Real)
Signed<:V<:Real
```

シンボル`name`以外の引数を省略できる簡便な形式もあります。

`Array{T} where T<:Integer`という構文は、次のように低水準化されます。

```julia
let T = TypeVar(:T,Integer)
    UnionAll(T, Array{T})
end
```

そのため、`TypeVar`を手動で構築する必要はほとんどありません（実際、避けるべきです）。

## Free variables

型システムでは、*自由*型変数という概念が非常に重要です。型`T`において変数`V`が自由であるとは、`T`が、変数`V`を導入する`UnionAll`を含んでいないことをいいます。たとえば、型`Array{Array{V} where V<:Integer}`には自由変数がありませんが、その内部の`Array{V}`の部分には、自由変数`V`があります。

自由変数を含む型は、ある意味では、そもそも本当の型とはいえません。型`Array{Array{T}} where T`を考えてみましょう。これは、配列を要素とする同種配列すべてを指します。内側の型`Array{T}`だけを見ると、あらゆる種類の配列を指しているように見えるかもしれません。しかし、外側の配列の各要素は*同じ*配列型でなければならないため、`Array{T}`は単に任意の配列を指すわけではありません。`Array{T}`は実質的に複数回「出現」しており、その「たびに」`T`は同じ値でなければならない、ともいえます。

このため、C APIの関数`jl_has_free_typevars`は非常に重要です。この関数がtrueを返す型については、部分型判定やその他の型関数から意味のある結果は得られません。

## TypeNames

次の2つの[`Array`](@ref)型は、機能的には等価ですが、表示は異なります。

```jldoctest
julia> TV, NV = TypeVar(:T), TypeVar(:N)
(T, N)

julia> Array
Array

julia> Array{TV, NV}
Array{T, N}
```

これらは、型の`name`フィールドを調べることで区別できます。このフィールドは`TypeName`型のオブジェクトです。

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

ここで関係するのは`wrapper`フィールドです。このフィールドは、新しい`Array`型を作るために使われる最上位の型への参照を保持します。

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

[`Array`](@ref)の`wrapper`フィールドは自分自身を指しますが、`Array{TV,NV}`では型の元の定義を指します。

ほかのフィールドはどうでしょうか。`hash`は、各型に整数を割り当てます。`cache`フィールドを調べるには、Arrayほど頻繁には使われていない型を選ぶと便利です。まず、独自の型を作成しましょう。

```jldoctest
julia> struct MyType{T,N} end

julia> MyType{Int,2}
MyType{Int64, 2}

julia> MyType{Float32, 5}
MyType{Float32, 5}
```

パラメトリック型をインスタンス化すると、各具象型は型キャッシュ（`MyType.body.body.name.cache`）に保存されます。ただし、自由型変数を含むインスタンスはキャッシュされません。

## Tuple types

タプル型は興味深い特殊ケースです。`x::Tuple`のような宣言でディスパッチが機能するには、その型が任意のタプルを受け入れられる必要があります。パラメータを確認してみましょう。

```jldoctest
julia> Tuple
Tuple

julia> Tuple.parameters
svec(Vararg{Any})
```

ほかの型とは異なり、タプル型はパラメータに関して共変です。そのため、この定義により`Tuple`はどのようなタプル型にも一致できます。

```jldoctest
julia> typeintersect(Tuple, Tuple{Int,Float64})
Tuple{Int64, Float64}

julia> typeintersect(Tuple{Vararg{Any}}, Tuple{Int,Float64})
Tuple{Int64, Float64}
```

ただし、可変長（`Vararg`）タプル型に自由変数がある場合、異なる種類のタプルを表すことがあります。

```jldoctest
julia> typeintersect(Tuple{Vararg{T} where T}, Tuple{Int,Float64})
Tuple{Int64, Float64}

julia> typeintersect(Tuple{Vararg{T}} where T, Tuple{Int,Float64})
Union{}
```

`T`が`Tuple`型に対して自由である場合（つまり、それを束縛する`UnionAll`型が`Tuple`型の外側にある場合）、単一の`T`の値が型全体にわたって適合しなければならないことに注意してください。したがって、異種タプルは一致しません。

最後に、`Tuple{}`はこれとは別物であることも押さえておきましょう。

```jldoctest
julia> Tuple{}
Tuple{}

julia> Tuple{}.parameters
svec()

julia> typeintersect(Tuple{}, Tuple{Int})
Union{}
```

「主」となるタプル型は何でしょうか。

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

したがって、`Tuple == Tuple{Vararg{Any}}`が確かに主となる型です。

## Diagonal types

型`Tuple{T,T} where T`を考えてみましょう。このシグネチャを持つメソッドは、次のようになります。

```julia
f(x::T, y::T) where {T} = ...
```

`UnionAll`型の通常の解釈では、この`T`は`Any`を含むすべての型を取り得るため、この型は`Tuple{Any,Any}`と等価なはずです。しかし、この解釈には実用上いくつか問題があります。

まず、メソッド定義の内部では、`T`の値を利用できる必要があります。`f(1, 1.0)`のような呼び出しでは、`T`が何であるべきかは明らかではありません。`Union{Int,Float64}`かもしれませんし、[`Real`](@ref)かもしれません。直感的には、宣言`x::T`は`T === typeof(x)`を意味すると期待します。この不変条件を確実に保つには、このメソッドで`typeof(x) === typeof(y) === T`が必要です。つまり、このメソッドは、まったく同じ型の引数に対してのみ呼び出されるべきだということです。

2つの値が同じ型かどうかでディスパッチできることは、非常に便利です（たとえば、昇格システムで利用されています）。したがって、`Tuple{T,T} where T`に別の解釈を求める理由は複数あります。これを実現するため、部分型判定に次の規則を加えます。変数が共変位置に複数回出現する場合、その変数が取り得る値は具象型のみに制限されます。（「共変位置」とは、変数の出現箇所と、その変数を導入する`UnionAll`型の間に、`Tuple`型と`Union`型しか現れないことを意味します。）このような変数は「対角変数」または「具象変数」と呼ばれます。

したがって、たとえば`Tuple{T,T} where T`は、`T`がすべての具象型を取り得る`Union{Tuple{Int8,Int8}, Tuple{Int16,Int16}, ...}`と見なせます。これにより、部分型判定には興味深い結果が生じます。たとえば、`Tuple{Real,Real}`は`Tuple{T,T} where T`の部分型ではありません。2つの要素の型が異なる`Tuple{Int8,Int16}`のような型を含むためです。`Tuple{Real,Real}`と`Tuple{T,T} where T`には、非自明な共通部分`Tuple{T,T} where T<:Real`があります。一方、`Tuple{Real}`は`Tuple{T} where T`の部分型*です*。この場合、`T`は1回しか出現せず、対角変数ではないためです。

次に、以下のようなシグネチャを考えてみましょう。

```julia
f(a::Array{T}, x::T, y::T) where {T} = ...
```

この場合、`T`は`Array{T}`内の不変位置に出現します。つまり、渡される配列の型によって`T`の値が一意に決まります。これを、`T`には*等値制約*があるといいます。したがって、この場合には対角規則は実際には必要ありません。配列によって`T`が決まり、そのうえで`x`と`y`には、`T`の任意の部分型を許せるからです。このため、不変位置に出現する変数は、対角変数とは見なされません。この動作の選択には多少の議論があり、この定義は次のように書くべきだという意見もあります。

```julia
f(a::Array{T}, x::S, y::S) where {T, S<:T} = ...
```

これは、`x`と`y`が同じ型でなければならないかどうかを明確にするためです。この形式のシグネチャでは同じ型である必要があります。`x`と`y`に異なる型を許すのであれば、`y`の型に対して3つ目の変数を導入できます。

次に複雑になるのは、和集合と対角変数の相互作用です。たとえば、次のような場合です。

```julia
f(x::Union{Nothing,T}, y::T) where {T} = ...
```

この宣言の意味を考えてみましょう。`y`の型は`T`です。そして`x`は、同じ型`T`か、または[`Nothing`](@ref)型を取れます。したがって、次の呼び出しはすべて一致するはずです。

```julia
f(1, 1)
f("", "")
f(2.0, 2.0)
f(nothing, 1)
f(nothing, "")
f(nothing, 2.0)
```

これらの例から、あることがわかります。`x`が`nothing::Nothing`の場合、`y`に追加の制約はありません。メソッドシグネチャが`y::Any`であるかのように振る舞います。実際、次の型の等価関係が成り立ちます。

```julia
(Tuple{Union{Nothing,T},T} where T) == Union{Tuple{Nothing,Any}, Tuple{T,T} where T}
```

一般的な規則は次のとおりです。共変位置にある具象変数は、部分型判定アルゴリズムがそれを1回しか*使用*しない場合、具象変数ではないかのように振る舞います。`x`が`Nothing`型の場合、`Union{Nothing,T}`内の`T`を使う必要はなく、2番目の位置でのみ使用します。これは、`Tuple{T} where T`において、`T`を具象型に制限しても違いがないという事実から自然に導かれます。いずれにしても、その型は`Tuple{Any}`に等しくなります。

ただし、*不変*位置に出現する変数は、その出現が使用されるかどうかにかかわらず、具象変数にはなれません。そうしないと、比較相手の型によって型の振る舞いが変わり、部分型関係の推移性が失われてしまいます。たとえば、次を考えてみましょう。

```julia
Tuple{Int,Int8,Vector{Integer}} <: Tuple{T,T,Vector{Union{Integer,T}}} where T
```

`Union`内の`T`を無視すると、`T`は具象変数となり、最初の2つの型が同じではないため、答えは「false」になります。しかし、代わりに次を考えてみましょう。

```julia
Tuple{Int,Int8,Vector{Any}} <: Tuple{T,T,Vector{Union{Integer,T}}} where T
```

今度は、`Union`内の`T`を無視できません（`T == Any`でなければなりません）。そのため、`T`は具象変数ではなく、答えは「true」になります。これでは、`T`が具象変数かどうかが比較相手の型に依存してしまいます。型はそれ自体で明確な意味を持たなければならないため、これは認められません。したがって、どちらの場合も、`Vector`内での`T`の出現を考慮します。

## Subtyping diagonal variables

対角変数に対する部分型判定アルゴリズムは、(1) 変数の出現を特定することと、(2) 対角変数が具象型のみを取り得るようにすること、という2つの要素から成ります。

最初の処理は、環境内の変数ごとにカウンタ`occurs_inv`と`occurs_cov`を（`src/subtype.c`内に）保持し、それぞれ不変位置と共変位置での出現回数を追跡することで実現します。`occurs_inv == 0 && occurs_cov > 1`のとき、その変数は対角変数です。

2番目の処理は、変数の下限に条件を課すことで実現します。部分型判定アルゴリズムは、実行中に各変数の範囲を狭めます（下限を上げ、上限を下げます）。これにより、部分型関係が成り立つ変数値の範囲を追跡します。変数が対角変数である`UnionAll`型の本体を評価し終えたら、上限と下限の最終的な値を調べます。変数は具象型でなければならないため、その下限が具象型の部分型になり得なければ、矛盾が生じます。たとえば、[`AbstractArray`](@ref)のような抽象型は具象型の部分型にはなれませんが、`Int`のような具象型や、空の型`Bottom`はなれます。下限がこの検査を通過しない場合、アルゴリズムは`false`という結果で停止します。

たとえば、`Tuple{Int,String} <: Tuple{T,T} where T`という問題では、`T`が`Union{Int,String}`の上位型であれば、これがtrueになると導かれます。しかし、`Union{Int,String}`は抽象型なので、この関係は成り立ちません。

この具象性の検査は、関数`is_leaf_bound`で行われます。この検査は、`Bottom`に対しても`true`を返すため、`jl_is_leaf_type`とは少し異なることに注意してください。現在、この関数はヒューリスティックに基づいており、取り得るすべての具象型を検出できるわけではありません。難しいのは、下限が具象型かどうかが、ほかの型変数の上限や下限の値に依存する可能性があることです。たとえば、`Vector{T}`が具象型`Vector{Int}`と等価になるのは、`T`の上限と下限がどちらも`Int`に等しい場合に限られます。このための完全なアルゴリズムは、まだ確立できていません。

## Introduction to the internal machinery

型を扱う演算の大部分は、ファイル`jltypes.c`と`subtype.c`にあります。まずは、部分型判定が実際に動作する様子を観察するとよいでしょう。`make debug`でJuliaをビルドし、デバッガ内でJuliaを起動してください。[gdb debugging tips](@ref gdb-debugging-tips)には、役立つヒントがいくつかあります。

部分型判定のコードはREPL自体でも多用されるため、このコードに設定したブレークポイントは頻繁にヒットします。そのため、次の定義を用意すると作業しやすくなります。

```julia-repl
julia> function mysubtype(a,b)
           ccall(:jl_breakpoint, Cvoid, (Any,), nothing)
           a <: b
       end
```

そのうえで、`jl_breakpoint`にブレークポイントを設定します。このブレークポイントにヒットしたら、ほかの関数にもブレークポイントを設定できます。

手始めに、次を試してみましょう。

```julia
mysubtype(Tuple{Int, Float64}, Tuple{Integer, Real})
```

さらに複雑なケースを試すと、より興味深い動作を観察できます。

```julia
mysubtype(Tuple{Array{Int,2}, Int8}, Tuple{Array{T}, T} where T)
```

## Subtyping and method sorting

`type_morespecific`関数群は、メソッドテーブル内の関数に、特異性の高いものから低いものへの半順序を与えるために使われます。特異性の関係は厳密です。`a`が`b`より特異的であれば、`a`は`b`と等しくなく、`b`が`a`より特異的になることもありません。

`a`が`b`の真の部分型であれば、自動的に、より特異的であると見なされます。それに加えて、`type_morespecific`はいくつかの、より形式性の低い規則を使います。たとえば、`subtype`は引数の数を考慮しますが、`type_morespecific`は必ずしもそうではありません。具体的には、`Tuple{Int,AbstractFloat}`は`Tuple{Integer}`の部分型ではないにもかかわらず、それより特異的です。（`Tuple{Int,AbstractFloat}`と`Tuple{Integer,Float64}`では、どちらも他方より特異的ではありません。）同様に、`Tuple{Int,Vararg{Int}}`は`Tuple{Integer}`の部分型ではありませんが、それより特異的と見なされます。ただし、`morespecific`では長さも有利に働きます。具体的には、`Tuple{Int,Int}`は`Tuple{Int,Vararg{Int}}`より特異的です。

また、型の等価性判定において同一となるシグネチャを持つメソッドが2つ定義された場合は、代わりに追加された順序で比較され、後から追加されたメソッドのほうが先に追加されたメソッドより特異的と見なされます。
