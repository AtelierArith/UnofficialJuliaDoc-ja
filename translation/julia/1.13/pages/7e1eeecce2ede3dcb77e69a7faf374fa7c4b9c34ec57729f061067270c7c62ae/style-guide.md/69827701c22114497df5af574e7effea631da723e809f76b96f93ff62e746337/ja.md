# Style Guide

以下のセクションでは、Juliaらしいコーディングスタイルのいくつかの側面を説明します。これらのルールは絶対的なものではなく、Juliaに慣れ、複数の設計案から選ぶ際の参考となる提案です。

## Indentation

インデントの各レベルには、スペースを4つ使います。

## Write functions, not just scripts

トップレベルに処理を順番に書いていくのは、問題解決に取りかかる手っ取り早い方法です。しかし、できるだけ早い段階でプログラムを関数に分割するようにしましょう。関数を使うと再利用やテストがしやすくなり、どのような処理を行うのか、またその入力と出力が何なのかも明確になります。さらに、Juliaのコンパイラの仕組みにより、関数内のコードはトップレベルのコードよりもはるかに高速に実行される傾向があります。

また、関数はグローバル変数を直接操作するのではなく、引数を受け取るようにするのが望ましい点も強調しておきます（[`pi`](@ref)のような定数は除きます）。

## Write docstrings

オブジェクトの説明コメントは、エディターやREPLから参照できるよう、通常は[docstrings](@ref man-writing-documentation)として記述します。インラインコメント（`# comment`）や複数行コメント（`#= comment =#`）は、ユーザーではなくコードを読む人だけに伝える情報を書く場合に適しています。

## Avoid writing overly-specific types

コードはできるだけ汎用的に書きましょう。次のように書くよりも、

```julia
Complex{Float64}(x)
```

利用可能な汎用関数を使うほうが適切です。

```julia
complex(float(x))
```

後者では、`x`が常に同じ型になるのではなく、適切な型に変換されます。

このスタイル上の注意点は、特に関数の引数に当てはまります。たとえば、実際には任意の整数を受け取れるのであれば、引数を`Int`や[`Int32`](@ref)型として宣言せず、抽象型の[`Integer`](@ref)で表しましょう。実際、多くの場合、他のメソッド定義との曖昧さを解消する必要がなければ、引数の型を省略できます。必要な操作をサポートしない型が渡された場合は、いずれにせよ[`MethodError`](@ref)がスローされるからです（これは[duck typing](https://en.wikipedia.org/wiki/Duck_typing)と呼ばれます）。

たとえば、引数に1を加えた値を返す関数`addone`について、次の定義を考えてみましょう。

```julia
addone(x::Int) = x + 1                 # works only for Int
addone(x::Integer) = x + oneunit(x)    # any integer type
addone(x::Number) = x + oneunit(x)     # any numeric type
addone(x) = x + oneunit(x)             # any type supporting + and oneunit
```

最後の`addone`の定義は、[`oneunit`](@ref)（`x`と同じ型で1を返し、不要な型昇格を避けます）と、これらの引数を受け取る[`+`](@ref)関数をサポートする、あらゆる型を扱います。重要なのは、汎用的な`addone(x) = x + oneunit(x)`だけを定義しても、*性能上の不利益はない*ということです。Juliaは必要に応じて、特殊化したバージョンを自動的にコンパイルします。たとえば、`addone(12)`を初めて呼び出すと、Juliaは`x::Int`型の引数に特化した`addone`関数を自動的にコンパイルし、その中では`oneunit`の呼び出しがインライン化された値`1`に置き換えられます。したがって、上記の最初の3つの`addone`の定義は、4つ目の定義と完全に重複しています。

## Handle excess argument diversity in the caller

次のように書くよりも、

```julia
function foo(x, y)
    x = Int(x); y = Int(y)
    ...
end
foo(x, y)
```

次のように書きましょう。

```julia
function foo(x::Int, y::Int)
    ...
end
foo(Int(x), Int(y))
```

`foo`があらゆる型の数値を受け取れるわけではなく、実際には`Int`を必要とするため、こちらのほうが適切なスタイルです。

関数が本質的に整数を必要とする場合、整数以外の値をどう変換するか（たとえば、切り捨てるか切り上げるか）は呼び出し側に決めてもらうほうがよいことがあります。また、より具体的な型を宣言しておけば、将来メソッドを追加するための「余地」を広く残せます。

## [Append `!` to names of functions that modify their arguments](@id bang-convention)

次のように書くよりも、

```julia
function double(a::AbstractArray{<:Number})
    for i in eachindex(a)
        a[i] *= 2
    end
    return a
end
```

次のように書きましょう。

```julia
function double!(a::AbstractArray{<:Number})
    for i in eachindex(a)
        a[i] *= 2
    end
    return a
end
```

Julia Baseではこの規約が一貫して使われており、コピーする形式と変更する形式の両方を持つ関数（たとえば、[`sort`](@ref)と[`sort!`](@ref)）や、変更する形式だけを持つ関数（たとえば、[`push!`](@ref)、[`pop!`](@ref)、[`splice!`](@ref)）の例があります。このような関数は、利便性のため、変更後の配列も返すのが一般的です。

IOや乱数生成器（RNG）を扱う関数は、注目すべき例外です。これらの関数はほぼ必ずIOやRNGを変更するため、名前の末尾に`!`が付く関数は、IOの変更やRNG状態の進行とは*別の*変更を表します。たとえば、`rand(x)`はRNGを変更しますが、`rand!(x)`はRNGと`x`の両方を変更します。同様に、`read(io)`は`io`を変更しますが、`read!(io, x)`は両方の引数を変更します。

## Avoid strange type `Union`s

`Union{Function,AbstractString}`のような型は、設計をもっとすっきりさせられる可能性を示していることがよくあります。

## Avoid elaborate container types

次のような配列を作っても、たいていはあまり役に立ちません。

```julia
a = Vector{Union{Int,AbstractString,Tuple,Array}}(undef, n)
```

この場合は`Vector{Any}(undef, n)`のほうが適切です。また、1つの型に多くの選択肢を詰め込もうとするより、用途を絞って注釈を付ける（たとえば`a[i]::Int`）ほうが、コンパイラにとっても有益です。

## Prefer exported methods over direct field access

Juliaらしいコードでは、通常、モジュールがエクスポートするメソッドを、その型のインターフェースとして扱います。オブジェクトのフィールドは一般に実装の詳細とみなされるため、APIであると明示されていない限り、ユーザーコードから直接アクセスすべきではありません。これには次のような利点があります。

  * パッケージ開発者は、ユーザーコードを壊さずに実装を変更しやすくなります。
  * メソッドは、[`map`](@ref)のような高階の構文に渡せます（たとえば`map(imag, zs)`）。`[z.im for z in zs]`を使う必要はありません。
  * 抽象型に対してメソッドを定義できます。
  * メソッドを使って、異なる型に共通する概念的な操作を表せます（たとえば`real(z)`は、複素数にも四元数にも使えます）。

Juliaのディスパッチシステムは、このスタイルを後押しします。`play(x::MyType)`は、その特定の型に対する`play`メソッドだけを定義し、他の型にはそれぞれ独自の実装を任せるからです。

同様に、エクスポートされていない関数は、ドキュメントに別段の記載がない限り、通常は内部用であり、変更される可能性があります。関数名の先頭（または末尾）に`_`を付けて、「内部用」または実装の詳細であることを示す場合もありますが、これは規則ではありません。

この規則に当てはまらない例として、[`NamedTuple`](@ref)、[`RegexMatch`](@ref match)、[`StatStruct`](@ref stat)があります。

## Use naming conventions consistent with Julia `base/`

  * モジュール名と型名には、大文字とキャメルケースを使います。例：`module SparseArrays`、`struct UnitRange`。
  * 定数名はすべて大文字にし、単語の区切りにはアンダースコアを使います（[`LOAD_PATH`](@ref)、[`VERSION`](@ref)）。
  * `public`または`export`が付いていないものは内部用とみなされますが、先頭に`_`を付けると、公開用ではないことをさらに示せます。
  * 1つ以上の引数を変更する関数名の末尾には、`!`を付けます。
  * 簡潔さは重視されますが、略語は避けましょう（`indxin`ではなく[`indexin`](@ref)）。略語を使うと、特定の単語が略されているか、またどのように略されているかを覚えるのが難しくなります。

関数名に複数の単語が必要な場合は、複数の概念を表しているため、名前を分割したほうがよいのではないか検討しましょう。

関数名にはスネークケースを使います（[`minimum`](@ref)、[`count_zeros`](@ref)、[`escape_string`](@ref)）。Baseでは単語をつなげて1語にすることで、この規約から外れることがよくあります（[`splitpath`](@ref)、[`readeach`](@ref)）が、パッケージではこのスタイルは推奨されません。

## Write functions with argument ordering similar to Julia Base

一般に、Baseライブラリでは、該当する場合、関数の引数を次の順序で並べます。

1. **関数引数**。関数引数を先頭に置くと、複数行の無名関数を渡す際に[`do`](@ref)ブロックを使えます。
2. **I/Oストリーム**。`IO`オブジェクトを先頭に置くと、たとえば`sprint(show, x)`のように、関数を[`sprint`](@ref)などの関数に渡せます。
3. **変更対象の入力**。たとえば[`fill!(x, v)`](@ref fill!)では、変更対象のオブジェクトである`x`を、`x`に挿入する値より前に置きます。
4. **型**。型を渡す場合、通常は出力がその型になります。[`parse(Int, "1")`](@ref parse)では、型を解析対象の文字列より前に置きます。型を先頭に置く例は多数ありますが、[`read(io, String)`](@ref read)では`IO`引数が型より前に置かれます。これは、ここで示す順序に沿ったものです。
5. **変更対象ではない入力**。`fill!(x, v)`では、`v`は*変更されず*、`x`の後に置かれます。
6. **キー**。連想コレクションでは、キーと値のペアのキーを指します。それ以外のインデックス付きコレクションでは、インデックスを指します。
7. **値**。連想コレクションでは、キーと値のペアの値を指します。[`fill!(x, v)`](@ref fill!)のような場合は、`v`がこれに当たります。
8. **その他すべて**。上記以外の引数です。
9. **可変長引数**。関数呼び出しの末尾にいくつでも並べられる引数を指します。たとえば`Matrix{T}(undef, dims)`では、次元を[`Tuple`](@ref)（例：`Matrix{T}(undef, (1,2))`）として指定することも、複数の[`Vararg`](@ref)（例：`Matrix{T}(undef, 1, 2)`）として指定することもできます。
10. **キーワード引数**。Juliaでは関数定義のキーワード引数は必ず最後に置く必要があります。ここでは網羅性のために挙げています。

ほとんどの関数は、上記のすべての種類の引数を受け取るわけではありません。番号は、該当する引数がある場合にどの順序を優先するかを示しています。

もちろん、いくつか例外もあります。たとえば[`convert`](@ref)では、型を必ず先頭に置きます。[`setindex!`](@ref)では、インデックスを可変長引数として指定できるよう、値をインデックスより前に置きます。

APIを設計する際は、できる限りこの一般的な順序に従うと、ユーザーにとって一貫性のある使い心地になります。

## Don't overuse try-catch

エラーを捕捉することに頼るより、エラーを未然に防ぐほうが望ましいです。

## Don't parenthesize conditions

Juliaでは、`if`や`while`の条件式を括弧で囲む必要はありません。次のように書きましょう。

```julia
if a == b
```

次のように書くのではなく、

```julia
if (a == b)
```

## Don't overuse `...`

関数引数のスプライスは、つい多用しがちです。`[a..., b...]`の代わりに、配列をすでに連結できる`[a; b]`をそのまま使いましょう。`[a...]`より[`collect(a)`](@ref)のほうが適切ですが、`a`はすでに反復可能なので、配列に変換せずそのまま使うほうがよい場合もよくあります。

## Ensure constructors return an instance of their own type

型`T`に対してメソッド`T(x)`を呼び出した場合、通常は型Tの値が返ることが期待されます。予期しない型を返す[constructor](@ref man-constructors)を定義すると、挙動が分かりにくく、予測しにくくなることがあります。

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

コードの明瞭さを保ち、型の一貫性を確保するため、コンストラクターは、構築対象の型のインスタンスを返すように設計してください。

## Don't use unnecessary static parameters

次の関数シグネチャは、

```julia
foo(x::T) where {T<:Real} = ...
```

次のように書くべきです。

```julia
foo(x::Real) = ...
```

特に、関数本体で`T`を使わない場合はそうしてください。`T`を使う場合でも、都合がよければ[`typeof(x)`](@ref)に置き換えられます。性能差はありません。これは静的パラメーター全般を避けるべきだという注意ではなく、不要な場面で使うことを避けるべきだという注意です。

また、特にコンテナー型では、関数呼び出しで型パラメーターが必要になる場合があります。詳しくはFAQの[Avoid fields with abstract containers](@ref)を参照してください。

## Avoid confusion about whether something is an instance or a type

次のような定義の組み合わせは分かりにくくなります。

```julia
foo(::Type{MyType}) = ...
foo(::MyType) = foo(MyType)
```

対象の概念を`MyType`として表すのか、`MyType()`として表すのかを決め、一貫させましょう。

推奨されるスタイルは、まずインスタンスを使い、問題の解決に必要になった場合に限って、後から`Type{MyType}`を使うメソッドを追加することです。

型が実質的に列挙型である場合は、単一の型（できれば不変の構造体またはプリミティブ型）として定義し、列挙値はそのインスタンスとして表すべきです。コンストラクターや変換処理で、値が有効かどうかを検証できます。この設計は、列挙型を抽象型として定義し、そのサブタイプを「値」とする方法よりも望ましいものです。

## Don't overuse macros

マクロではなく関数で実現できないか、よく検討しましょう。

マクロ内で[`eval`](@ref)を呼び出している場合は、特に注意が必要です。これは、そのマクロがトップレベルで呼び出された場合にしか動作しないことを意味します。そのようなマクロを関数として書けば、必要な実行時の値を自然に利用できます。

## Don't expose unsafe operations at the interface level

ネイティブポインターを使う型がある場合、

```julia
mutable struct NativeType
    p::Ptr{UInt8}
    ...
end
```

次のような定義は書かないでください。

```julia
getindex(x::NativeType, i) = unsafe_load(x.p, i)
```

この型のユーザーが、操作の危険性に気づかずに`x[i]`と書き、メモリ関連のバグに遭遇するおそれがあるためです。

このような関数では、操作が安全であることを確認するか、呼び出し側に注意を促すため、名前のどこかに`unsafe`を含めるべきです。

## Don't overload methods of base container types

次のような定義を書くこともできます。

```julia
show(io::IO, v::Vector{MyType}) = ...
```

これにより、特定の新しい要素型を持つベクトルの表示をカスタマイズできます。魅力的に思えるかもしれませんが、避けるべきです。`Vector()`のようなよく知られた型には、ユーザーが一定の挙動を期待します。その挙動を過度にカスタマイズすると、扱いにくくなることがあります。

## [Avoid type piracy](@id avoid-type-piracy)

「型の海賊行為（type piracy）」とは、自分が定義していない型に対して、Baseや他のパッケージのメソッドを拡張または再定義することです。極端な場合には、Juliaをクラッシュさせることもあります（たとえば、メソッドの拡張や再定義によって、無効な入力が`ccall`に渡される場合）。型の海賊行為はコードの推論を難しくし、予測や診断が困難な非互換性を引き起こす可能性があります。

例として、あるモジュールでシンボルに対する乗算を定義したいとします。

```julia
module A
import Base.*
*(x::Symbol, y::Symbol) = Symbol(x,y)
end
```

問題は、`Base.*`を使う他のモジュールからも、この定義が見えるようになることです。`Symbol`はBaseで定義され、他のモジュールでも使われているため、無関係なコードの挙動が予期せず変わる可能性があります。別の関数名を使う、あるいは`Symbol`を自分で定義した別の型でラップするなど、いくつかの代替策があります。

機能と定義を分離するため、連携するパッケージ同士が型の海賊行為を行うこともあります。特に、共同で開発されたパッケージで、定義を再利用できる場合に見られます。たとえば、あるパッケージが色を扱うための型を提供し、別のパッケージが色空間間の変換を可能にするメソッドをその型に定義する場合があります。また、Cコードを薄くラップするパッケージの型を、別のパッケージが拡張して、より高水準でJuliaらしいAPIを実装する場合もあります。

## Be careful with type equality

型の判定には、通常`==`ではなく、[`isa`](@ref)や[`<:`](@ref)を使います。型の完全一致を調べるのが適切なのは、既知の具象型（たとえば`T == Float64`）と比較する場合か、何をしているかを*本当に、本当に*理解している場合に限られます。

## Don't write a trivial anonymous function `x->f(x)` for a named function `f`

高階関数は無名関数とともに呼び出されることが多いため、無名関数を使うのが望ましい、あるいは必須だと思いがちです。しかし、どの関数も無名関数で「ラップ」せずに、そのまま渡せます。`map(x->f(x), a)`と書く代わりに、[`map(f, a)`](@ref)と書きましょう。

## Avoid using floats for numeric literals in generic code when possible

数値を扱い、多様な数値型の引数で実行されることが想定される汎用コードを書く場合は、型昇格による引数への影響ができるだけ小さい数値型のリテラルを使いましょう。

たとえば、

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

一方、

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

このように、`Int`リテラルを使った2つ目の例では、入力引数の型が保たれていますが、1つ目では保たれていません。これは、たとえば`promote_type(Int, Float64) == Float64`のような型があり、乗算時に型昇格が起こるためです。同様に、[`Rational`](@ref)リテラルは[`Float64`](@ref)リテラルより型への影響が小さいものの、`Int`よりは影響が大きくなります。

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

したがって、コードを使いやすくするため、可能な場合は`Int`リテラルを使い、整数以外の数値リテラルには`Rational{Int}`を使いましょう。
