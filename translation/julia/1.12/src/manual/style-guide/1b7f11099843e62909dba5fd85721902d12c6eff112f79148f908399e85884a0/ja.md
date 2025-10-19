# Style Guide

以下のセクションでは、慣用的なJuliaコーディングスタイルのいくつかの側面について説明します。これらのルールは絶対的なものではなく、言語に慣れる手助けや、代替設計の中から選択する際の参考としての提案に過ぎません。

## Indentation

4つのスペースをインデントレベルとして使用します。

## Write functions, not just scripts

問題を解決するために、最初に一連のステップとしてコードを書くことは迅速なスタート方法ですが、できるだけ早くプログラムを関数に分割するように努めるべきです。関数は再利用可能でテスト可能であり、どのステップが実行されているのか、またその入力と出力が何であるかを明確にします。さらに、関数内のコードは、Juliaのコンパイラの動作により、トップレベルのコードよりもはるかに速く実行される傾向があります。

関数は引数を取るべきであり、グローバル変数（[`pi`](@ref)のような定数を除いて）に直接作用すべきではないことも強調する価値があります。

## Avoid writing overly-specific types

コードはできるだけ汎用的であるべきです。次のように書くのではなく:

```julia
Complex{Float64}(x)
```

利用可能な汎用関数を使用する方が良いです:

```julia
complex(float(x))
```

2 番目のバージョンは、常に同じ型ではなく、`x` を適切な型に変換します。

This style point is especially relevant to function arguments. For example, don't declare an argument to be of type `Int` or [`Int32`](@ref) if it really could be any integer, expressed with the abstract type [`Integer`](@ref). In fact, in many cases you can omit the argument type altogether, unless it is needed to disambiguate from other method definitions, since a [`MethodError`](@ref) will be thrown anyway if a type is passed that does not support any of the requisite operations. (This is known as [duck typing](https://en.wikipedia.org/wiki/Duck_typing).)

例えば、引数に1を加えた値を返す関数 `addone` の以下の定義を考えてみましょう：

```julia
addone(x::Int) = x + 1                 # works only for Int
addone(x::Integer) = x + oneunit(x)    # any integer type
addone(x::Number) = x + oneunit(x)     # any numeric type
addone(x) = x + oneunit(x)             # any type supporting + and oneunit
```

`addone`の最後の定義は、[`oneunit`](@ref)をサポートする任意の型を処理します（これは、`x`と同じ型で1を返し、不要な型の昇格を回避します）およびその引数を持つ[`+`](@ref)関数です。重要な点は、*一般的な`addone(x) = x + oneunit(x)`のみを定義することに* *パフォーマンスペナルティはない* ということです。なぜなら、Juliaは必要に応じて自動的に特化したバージョンをコンパイルするからです。たとえば、最初に`addone(12)`を呼び出すと、Juliaは自動的に`x::Int`引数用の特化した`addone`関数をコンパイルし、`oneunit`への呼び出しはそのインライン値`1`に置き換えられます。したがって、上記の`addone`の最初の3つの定義は、4番目の定義と完全に冗長です。

## Handle excess argument diversity in the caller

その代わりに：

```julia
function foo(x, y)
    x = Int(x); y = Int(y)
    ...
end
foo(x, y)
```

使用：

```julia
function foo(x::Int, y::Int)
    ...
end
foo(Int(x), Int(y))
```

これはより良いスタイルです。なぜなら、`foo` はすべてのタイプの数値を受け入れるわけではなく、実際には `Int` が必要だからです。

ここでの一つの問題は、関数が本質的に整数を必要とする場合、呼び出し元に非整数をどのように変換するか（例えば、切り捨てまたは切り上げ）を決定させる方が良いかもしれないということです。もう一つの問題は、より具体的な型を宣言することで、将来のメソッド定義のための「スペース」が増えるということです。

## [Append `!` to names of functions that modify their arguments](@id bang-convention)

その代わりに：

```julia
function double(a::AbstractArray{<:Number})
    for i in eachindex(a)
        a[i] *= 2
    end
    return a
end
```

使用：

```julia
function double!(a::AbstractArray{<:Number})
    for i in eachindex(a)
        a[i] *= 2
    end
    return a
end
```

Julia Baseはこの規則を通じて使用されており、コピー形式と修正形式の両方の関数の例が含まれています（例：[`sort`](@ref)および[`sort!`](@ref)）、および単に修正するもの（例：[`push!`](@ref)、[`pop!`](@ref)、[`splice!`](@ref)）。このような関数は、便利さのために修正された配列を返すことが一般的です。

IOや乱数生成器（RNG）を利用する関数は特筆すべき例外です。これらの関数はほぼ必ずIOやRNGを変更しなければならないため、`!`で終わる関数はIOを変更したりRNGの状態を進めたりする以外の変更を示すために使用されます。例えば、`rand(x)`はRNGを変更しますが、`rand!(x)`はRNGと`x`の両方を変更します。同様に、`read(io)`は`io`を変更しますが、`read!(io, x)`は両方の引数を変更します。

## Avoid strange type `Union`s

`Union{Function,AbstractString}`のような型は、しばしば設計がよりクリーンであるべきであることを示しています。

## Avoid elaborate container types

通常、以下のような配列を構築することはあまり役に立ちません:

```julia
a = Vector{Union{Int,AbstractString,Tuple,Array}}(undef, n)
```

この場合、`Vector{Any}(undef, n)` の方が良いです。また、特定の使用法を注釈すること（例えば、`a[i]::Int`）は、1つの型に多くの代替案を詰め込もうとするよりも、コンパイラにとってもより役立ちます。

## Prefer exported methods over direct field access

イディオマティックなJuliaコードは、一般的にモジュールのエクスポートされたメソッドをその型へのインターフェースとして扱うべきです。オブジェクトのフィールドは一般的に実装の詳細と見なされ、ユーザーコードはこれがAPIであると明記されている場合にのみ直接アクセスすべきです。これにはいくつかの利点があります：

  * パッケージ開発者は、ユーザーコードを壊すことなく実装を変更する自由があります。
  * メソッドは、[`map`](@ref)のような高階構造に渡すことができます（例えば、`map(imag, zs)`）が、`[z.im for z in zs]`の代わりに使用されます）。
  * メソッドは抽象型に定義することができます。
  * メソッドは、異なるタイプ間で共有できる概念的な操作を説明できます（例：`real(z)`は複素数や四元数で機能します）。

Juliaのディスパッチシステムはこのスタイルを奨励します。なぜなら、`play(x::MyType)`はその特定の型に対してのみ`play`メソッドを定義し、他の型はそれぞれ独自の実装を持つことができるからです。

同様に、非エクスポート関数は通常内部的なものであり、文書に別段の記載がない限り変更される可能性があります。名前には、何かが「内部的」または実装の詳細であることをさらに示唆するために、`_` プレフィックス（またはサフィックス）が付けられることがありますが、これはルールではありません。

反例としては、[`NamedTuple`](@ref)、[`RegexMatch`](@ref match)、[`StatStruct`](@ref stat)が含まれます。

## Use naming conventions consistent with Julia `base/`

  * モジュールと型名は大文字とキャメルケースを使用します: `module SparseArrays`、`struct UnitRange`。
  * 関数は小文字です（[`maximum`](@ref)、[`convert`](@ref)）および、可読性がある場合は複数の単語が一緒に圧縮されています（[`isequal`](@ref)、[`haskey`](@ref)）。必要に応じて、単語の区切りとしてアンダースコアを使用します。アンダースコアは、概念の組み合わせを示すためにも使用されます（[`remotecall_fetch`](@ref) は `fetch(remotecall(...))` のより効率的な実装として）または修飾子としても使用されます。
  * 引数の少なくとも1つを変更する関数は `!` で終わります。
  * 簡潔さは重要ですが、略語を避けてください（[`indexin`](@ref) のように、`indxin` の代わりに）。特定の単語がどのように略されているかを覚えるのが難しくなります。

関数名が複数の単語を必要とする場合、それが複数の概念を表している可能性があるかどうかを考慮し、分割する方が良いかもしれません。

## Write functions with argument ordering similar to Julia Base

一般的なルールとして、Baseライブラリは関数に対する引数の次の順序を使用します。

1. **関数引数**。関数引数を最初に置くことで、[`do`](@ref) ブロックを使用して、複数行の匿名関数を渡すことができます。
2. **I/Oストリーム**。`IO`オブジェクトを最初に指定することで、[`sprint`](@ref)のような関数に関数を渡すことができます。例えば、`sprint(show, x)`。
3. **入力が変異しています**。例えば、[`fill!(x, v)`](@ref fill!)の中で、`x`は変異されるオブジェクトであり、`x`に挿入される値の前に現れます。
4. **タイプ**。タイプを渡すということは、出力が指定されたタイプを持つことを意味します。[`parse(Int, "1")`](@ref parse)では、タイプは解析する文字列の前にあります。このようにタイプが最初に現れる例は多くありますが、[`read(io, String)`](@ref read)では、`IO`引数がタイプの前に現れています。これは、ここで示された順序に従っています。
5. **入力が変更されていない**。`fill!(x, v)`では、`v`は*変更されておらず*、`x`の後に来ます。
6. **キー**。連想コレクションの場合、これはキーと値のペアのキーです。他のインデックス付きコレクションの場合、これはインデックスです。
7. **値**。連想コレクションの場合、これはキーと値のペアの値です。[`fill!(x, v)`](@ref fill!)のような場合、これは`v`です。
8. **その他すべて**。他のすべての引数。
9. **Varargs**。これは、関数呼び出しの最後に無限にリストできる引数を指します。例えば、`Matrix{T}(undef, dims)`では、次元を[`Tuple`](@ref)のように指定することができます。例えば、`Matrix{T}(undef, (1,2))`や、[`Vararg`](@ref)のように、`Matrix{T}(undef, 1, 2)`として指定することもできます。
10. **キーワード引数**。Juliaでは、キーワード引数は関数定義の最後に来る必要があります。ここでは、完全性のためにそれらをリストしています。

ほとんどの関数は、上記に示されたすべての種類の引数を受け取るわけではありません。数字は、関数に適用可能な引数に対して使用すべき優先順位を示すだけです。

もちろん、いくつかの例外があります。例えば、[`convert`](@ref)では、タイプは常に最初に来るべきです。[`setindex!`](@ref)では、値がインデックスの前に来るため、インデックスをvarargsとして提供できます。

APIを設計する際には、この一般的な順序にできるだけ従うことで、関数のユーザーにより一貫した体験を提供できる可能性が高くなります。

## Don't overuse try-catch

エラーを捕まえることに頼るよりも、エラーを避ける方が良い。

## Don't parenthesize conditions

Juliaは`if`や`while`の条件の周りに括弧を必要としません。書いてください:

```julia
if a == b
```

その代わりに：

```julia
if (a == b)
```

## Don't overuse `...`

関数引数のスプライシングは中毒性があります。`[a..., b...]`の代わりに、単に`[a; b]`を使用してください。これはすでに配列を連結します。[`collect(a)`](@ref)は`[a...]`よりも優れていますが、`a`はすでに反復可能であるため、しばしばそのままにしておく方がさらに良いです。配列に変換しないでください。

## Ensure constructors return an instance of their own type

`T(x)`というメソッドが型`T`で呼び出されるとき、一般的には型Tの値を返すことが期待されます。予期しない型を返す[constructor](@ref man-constructors)を定義すると、混乱を招き、予測不可能な動作を引き起こす可能性があります。

```jldoctest
julia> struct Foo{T}
           x::T
       end

julia> Base.Float64(foo::Foo) = Foo(Float64(foo.x))  # Do not define methods like this

julia> Float64(Foo(3))  # Should return `Float64`
Foo{Float64}(3.0)

julia> Foo{Int}(x) = Foo{Float64}(x)  # Do not define methods like this

julia> Foo{Int}(3)  # Should return `Foo{Int}`
Foo{Float64}(3.0)
```

コードの明瞭さを維持し、型の一貫性を確保するために、常にコンストラクタを設計して、構築すべき型のインスタンスを返すようにしてください。

## Don't use unnecessary static parameters

関数シグネチャ:

```julia
foo(x::T) where {T<:Real} = ...
```

書かれるべきは：

```julia
foo(x::Real) = ...
```

その代わりに、特に `T` が関数本体で使用されていない場合。たとえ `T` が使用されていても、便利であれば [`typeof(x)`](@ref) に置き換えることができます。パフォーマンスの違いはありません。これは静的パラメータに対する一般的な注意喚起ではなく、必要ない場合の使用に対するものです。

コンテナ型は、特に関数呼び出しで型パラメータが必要な場合があることにも注意してください。詳細については、FAQ [Avoid fields with abstract containers](@ref) を参照してください。

## Avoid confusion about whether something is an instance or a type

以下のような定義のセットは混乱を招きます：

```julia
foo(::Type{MyType}) = ...
foo(::MyType) = foo(MyType)
```

この質問の概念が `MyType` として書かれるのか、`MyType()` として書かれるのかを決定し、それに従ってください。

デフォルトではインスタンスを使用するのが好ましいスタイルであり、問題を解決するために必要になった場合にのみ `Type{MyType}` に関するメソッドを追加します。

もし型が実質的に列挙型であるなら、それは単一の（理想的には不変の構造体または原始型の）型として定義されるべきであり、列挙値はそのインスタンスであるべきです。コンストラクタや変換は、値が有効かどうかをチェックできます。この設計は、列挙型を抽象型として定義し、「値」をサブタイプとするよりも好まれます。

## Don't overuse macros

マクロが実際には関数であるべき時に注意してください。

[`eval`](@ref)をマクロ内で呼び出すことは、特に危険な警告サインです。これは、そのマクロがトップレベルで呼び出されたときにのみ機能することを意味します。このようなマクロが代わりに関数として書かれた場合、必要なランタイム値に自然にアクセスできるようになります。

## Don't expose unsafe operations at the interface level

ネイティブポインタを使用する型がある場合：

```julia
mutable struct NativeType
    p::Ptr{UInt8}
    ...
end
```

定義のようなものは書かないでください:

```julia
getindex(x::NativeType, i) = unsafe_load(x.p, i)
```

このタイプのユーザーは、操作が安全でないことに気づかずに `x[i]` と書くことができ、その結果、メモリバグに対して脆弱になる可能性があります。

そのような関数は、操作が安全であることを確認するか、呼び出し元に警告するために名前のどこかに `unsafe` を含めるべきです。

## Don't overload methods of base container types

次のような定義を書くことが可能です：

```julia
show(io::IO, v::Vector{MyType}) = ...
```

これは特定の新しい要素タイプを持つベクトルのカスタム表示を提供します。魅力的ではありますが、これは避けるべきです。問題は、ユーザーが `Vector()` のようなよく知られたタイプが特定の方法で動作することを期待するため、その動作を過度にカスタマイズすると、作業が難しくなる可能性があることです。

## [Avoid type piracy](@id avoid-type-piracy)

「型の海賊行為」とは、あなたが定義していない型に対して、Baseや他のパッケージのメソッドを拡張または再定義する行為を指します。極端な場合、あなたのメソッドの拡張や再定義が無効な入力を`ccall`に渡す原因となると、Juliaをクラッシュさせることがあります。型の海賊行為はコードの推論を複雑にし、予測や診断が難しい互換性の問題を引き起こす可能性があります。

モジュール内のシンボルに対して乗算を定義したいと仮定します:

```julia
module A
import Base.*
*(x::Symbol, y::Symbol) = Symbol(x,y)
end
```

問題は、現在 `Base.*` を使用する他のモジュールもこの定義を見ることになることです。`Symbol` は Base で定義されており、他のモジュールでも使用されているため、無関係なコードの動作が予期せず変更される可能性があります。ここには、異なる関数名を使用することや、定義した別の型で `Symbol` をラップすることなど、いくつかの代替案があります。

時には、結合されたパッケージが型の海賊行為に関与し、機能を定義から分離することがあります。特に、パッケージが共同著者によって設計され、定義が再利用可能な場合です。例えば、あるパッケージは色を扱うために便利な型を提供するかもしれません。別のパッケージは、その型に対して色空間間の変換を可能にするメソッドを定義することができます。別の例としては、あるパッケージがいくつかのCコードの薄いラッパーとして機能し、別のパッケージがそれを海賊行為して高レベルのJuliaフレンドリーなAPIを実装することが考えられます。

## Be careful with type equality

一般的に、型をテストするためには [`isa`](@ref) と [`<:`](@ref) を使用したいものであり、`==` は使用しません。型の厳密な等価性をチェックすることは、既知の具体的な型（例：`T == Float64`）と比較する場合や、*本当に、本当に* 自分が何をしているのかを理解している場合にのみ意味があります。

## Don't write a trivial anonymous function `x->f(x)` for a named function `f`

高階関数はしばしば匿名関数と共に呼び出されるため、これが望ましい、あるいは必要であると結論づけるのは簡単です。しかし、任意の関数は匿名関数に「ラップ」されることなく直接渡すことができます。`map(x->f(x), a)`と書く代わりに、[`map(f, a)`](@ref)と書いてください。

## Avoid using floats for numeric literals in generic code when possible

数値を扱う汎用コードを書く場合、さまざまな数値型の引数で実行されることが期待される場合は、引数に対する昇格の影響をできるだけ少なくする数値型のリテラルを使用することを検討してください。

例えば、

```jldoctest
julia> f(x) = 2.0 * x
f (generic function with 1 method)

julia> f(1//2)
1.0

julia> f(1/2)
1.0

julia> f(1)
2.0
```

while

```jldoctest
julia> g(x) = 2 * x
g (generic function with 1 method)

julia> g(1//2)
1//1

julia> g(1/2)
1.0

julia> g(1)
2
```

ご覧のとおり、`Int` リテラルを使用した第二のバージョンでは、入力引数の型が保持されましたが、最初のバージョンではそうではありませんでした。これは、例えば `promote_type(Int, Float64) == Float64` であり、乗算によって昇格が発生するためです。同様に、[`Rational`](@ref) リテラルは [`Float64`](@ref) リテラルよりも型の破壊が少なく、しかし `Int` よりは破壊的です。

```jldoctest
julia> h(x) = 2//1 * x
h (generic function with 1 method)

julia> h(1//2)
1//1

julia> h(1/2)
1.0

julia> h(1)
2//1
```

したがって、可能な場合は `Int` リテラルを使用し、リテラルの非整数値には `Rational{Int}` を使用して、コードの使用を容易にしてください。
