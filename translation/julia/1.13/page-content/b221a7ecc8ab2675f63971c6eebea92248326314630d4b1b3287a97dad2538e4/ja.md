# [Constructors](@id man-constructors)

コンストラクター[^1]とは、新しいオブジェクト、具体的には[Composite Types](@ref)のインスタンスを作成する関数です。Juliaでは、型オブジェクトもコンストラクター関数として機能します。型オブジェクトを関数として引数のタプルに適用すると、その型自身の新しいインスタンスが作成されます。この点については、複合型を導入した際にすでに簡単に触れました。たとえば、次のようになります。

```jldoctest footype
julia> struct Foo
           bar
           baz
       end

julia> foo = Foo(1, 2)
Foo(1, 2)

julia> foo.bar
1

julia> foo.baz
2
```

多くの型では、フィールド値をまとめて新しいオブジェクトを作るだけで、インスタンスの作成に必要なことはすべて満たされます。しかし、複合オブジェクトの作成時に、より多くの機能が必要となる場合もあります。引数を検査したり変換したりして、不変条件を保証しなければならないことがあります。[Recursive data structures](https://en.wikipedia.org/wiki/Recursion_%28computer_science%29#Recursive_data_structures_.28structural_recursion.29)は、特に自己参照する可能性があるものの場合、まず不完全な状態で作成し、その後、オブジェクトの作成とは別の手順としてプログラムから変更し、完成させなければ、適切に構築できないことがよくあります。また、フィールドの数や型とは異なる、より少ない数または別の型の引数でオブジェクトを構築できると便利な場合もあります。Juliaのオブジェクト構築システムは、こうしたケースをはじめ、さまざまなケースに対応します。

[^1]: 用語について：一般に「コンストラクター」は、ある型のオブジェクトを構築する関数全体を指しますが、特定のコンストラクターメソッドを「コンストラクター」と呼ぶ、やや厳密さを欠く用法もよく見られます。このような場合、特に複数あるコンストラクターのうち特定のメソッドを取り上げる文脈では、「コンストラクター関数」ではなく「コンストラクターメソッド」を意味していることが、通常は文脈から明らかです。

## [Outer Constructor Methods](@id man-outer-constructor-methods)

コンストラクターは、全体としての振る舞いが各メソッドの振る舞いを組み合わせて定義されるという点で、Juliaのほかの関数と変わりません。したがって、新しいメソッドを定義するだけで、コンストラクターに機能を追加できます。たとえば、`Foo`オブジェクトに対して、引数を1つだけ受け取り、その値を`bar`フィールドと`baz`フィールドの両方に使うコンストラクターメソッドを追加したいとします。これは簡単です。

```jldoctest footype
julia> Foo(x) = Foo(x,x)
Foo

julia> Foo(1)
Foo(1, 1)
```

また、引数を取らず、`bar`フィールドと`baz`フィールドの両方にデフォルト値を与える`Foo`コンストラクターメソッドを追加することもできます。

```jldoctest footype
julia> Foo() = Foo(0)
Foo

julia> Foo()
Foo(0, 0)
```

ここでは、引数なしのコンストラクターメソッドが引数1つのコンストラクターメソッドを呼び出し、さらに後者が自動的に提供される引数2つのコンストラクターメソッドを呼び出しています。まもなく明らかになる理由から、このように通常のメソッドとして宣言する追加のコンストラクターメソッドを、*外部*コンストラクターメソッドと呼びます。外部コンストラクターメソッドは、自動的に提供されるデフォルトのものなど、別のコンストラクターメソッドを呼び出すことでしか、新しいインスタンスを作成できません。

## [Inner Constructor Methods](@id man-inner-constructor-methods)

外部コンストラクターメソッドは、オブジェクト構築のための便利なメソッドを追加するという問題には対応できますが、この章の冒頭で挙げた残り2つの用途、すなわち不変条件の保証と自己参照オブジェクトの構築には対応できません。これらの問題には、*内部*コンストラクターメソッドが必要です。内部コンストラクターメソッドは外部コンストラクターメソッドに似ていますが、次の2点が異なります。

1. 通常のメソッドのように型宣言の外側ではなく、型宣言のブロック内で宣言されます。
2. ブロックの型のオブジェクトを作成する、[`new`](@ref)という特別なローカル関数を利用できます。

たとえば、2つの実数を保持し、1つ目の数が2つ目の数を超えないという制約を持つ型を宣言したいとします。次のように宣言できます。

```jldoctest pairtype
julia> struct OrderedPair
           x::Real
           y::Real
           OrderedPair(x,y) = x > y ? error("out of order") : new(x,y)
       end
```

これで、`OrderedPair`オブジェクトは、`x <= y`となる場合に限って構築できます。

```jldoctest pairtype; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> OrderedPair(1, 2)
OrderedPair(1, 2)

julia> OrderedPair(2,1)
ERROR: out of order
Stacktrace:
 [1] error at ./error.jl:33 [inlined]
 [2] OrderedPair(::Int64, ::Int64) at ./none:4
 [3] top-level scope
```

型を`mutable`として宣言した場合、フィールド値を直接変更して、この不変条件を破ることができてしまいます。もちろん、許可なくオブジェクトの内部をいじるのはよい習慣ではありません。また、後からいつでも外部コンストラクターメソッドを追加できますが、型を宣言した後に内部コンストラクターメソッドを追加する方法はありません。外部コンストラクターメソッドは、別のコンストラクターメソッドを呼び出すことでしかオブジェクトを作成できないため、最終的には内部コンストラクターが呼び出されなければなりません。これにより、宣言された型のすべてのオブジェクトは、その型とともに定義された内部コンストラクターメソッドのいずれかを呼び出して作成されることが保証され、型の不変条件をある程度強制できます。

内部コンストラクターメソッドを1つでも定義すると、デフォルトのコンストラクターメソッドは提供されません。必要な内部コンストラクターはすべて自分で用意したものと見なされるためです。デフォルトコンストラクターは、オブジェクトのすべてのフィールドを引数として受け取り（対応するフィールドに型が指定されている場合は、その型に制約されます）、それらを`new`に渡して、返されたオブジェクトを返す内部コンストラクターメソッドを自分で書くのと同じです。

```jldoctest
julia> struct Foo
           bar
           baz
           Foo(bar,baz) = new(bar,baz)
       end

```

この宣言は、内部コンストラクターメソッドを明示せずに先ほど定義した`Foo`型と同じ効果を持ちます。次の2つの型は同等です。一方はデフォルトコンストラクターを使い、もう一方はコンストラクターを明示的に定義しています。

```jldoctest
julia> struct T1
           x::Int64
       end

julia> struct T2
           x::Int64
           T2(x) = new(x)
       end

julia> T1(1)
T1(1)

julia> T2(1)
T2(1)

julia> T1(1.0)
T1(1)

julia> T2(1.0)
T2(1)
```

内部コンストラクターメソッドは、必要最小限の数だけ用意するのがよい習慣です。つまり、すべての引数を明示的に受け取り、不可欠なエラーチェックや変換を行うものだけを定義します。デフォルト値や補助的な変換を提供する追加の便利なコンストラクターメソッドは、処理の本体を内部コンストラクターに委ねる外部コンストラクターとして定義します。このように役割を分けるのは、通常ごく自然なことです。

## Incomplete Initialization

まだ解決していない最後の問題は、自己参照オブジェクト、あるいはより一般的には再帰的なデータ構造の構築です。根本的な難しさはすぐには明らかでないかもしれないので、簡単に説明しましょう。次の再帰型宣言を考えてください。

```jldoctest selfrefer
julia> mutable struct SelfReferential
           obj::SelfReferential
       end

```

この型は、一見すると特に問題がなさそうですが、インスタンスの構築方法を考えると事情が変わります。`a`が`SelfReferential`のインスタンスなら、次の呼び出しで2つ目のインスタンスを作成できます。

```julia-repl
julia> b = SelfReferential(a)
```

しかし、`obj`フィールドに有効な値として渡せるインスタンスがまだ存在しないとき、最初のインスタンスはどう構築すればよいのでしょうか。唯一の解決策は、`SelfReferential`のインスタンスを不完全な状態で作成できるようにし、`obj`フィールドを未割り当てのままにしておくことです。そして、その不完全なインスタンスを、別のインスタンスの`obj`フィールドに有効な値として渡します。たとえば、そのインスタンス自身を渡すこともできます。

不完全に初期化されたオブジェクトを作成できるようにするため、Juliaでは[`new`](@ref)関数に型のフィールド数より少ない引数を渡せます。この場合、指定されなかったフィールドが未初期化のオブジェクトが返されます。その後、内部コンストラクターメソッドはこの不完全なオブジェクトを使い、返す前に初期化を完了できます。たとえば、`SelfReferential`型を定義する別の方法として、引数なしの内部コンストラクターを使い、`obj`フィールドが自身を指すインスタンスを返す方法があります。

```jldoctest selfrefer2
julia> mutable struct SelfReferential
           obj::SelfReferential
           SelfReferential() = (x = new(); x.obj = x)
       end

```

このコンストラクターが正しく動作し、実際に自己参照するオブジェクトを構築することを確認できます。

```jldoctest selfrefer2
julia> x = SelfReferential();

julia> x === x
true

julia> x === x.obj
true

julia> x === x.obj.obj
true
```

内部コンストラクターから完全に初期化されたオブジェクトを返すのが一般には望ましいものの、不完全に初期化されたオブジェクトを返すこともできます。

```jldoctest incomplete
julia> mutable struct Incomplete
           data
           Incomplete() = new()
       end

julia> z = Incomplete();
```

未初期化のフィールドを持つオブジェクトを作成することはできますが、未初期化の参照にアクセスすると、ただちにエラーになります。

```jldoctest incomplete
julia> z.data
ERROR: UndefRefError: access to undefined reference
```

これにより、`null`値かどうかを常に確認する必要がなくなります。ただし、すべてのオブジェクトフィールドが参照というわけではありません。Juliaでは、一部の型を「プレーンデータ」と見なします。これは、そのデータがすべて自己完結しており、ほかのオブジェクトを参照しないことを意味します。プレーンデータ型には、プリミティブ型（例：`Int`）と、ほかのプレーンデータ型からなる不変構造体（関連項目：[`isbits`](@ref)、[`isbitstype`](@ref)）が含まれます。プレーンデータ型の初期内容は未定義です。

```julia-repl
julia> struct HasPlain
           n::Int
           HasPlain() = new()
       end

julia> HasPlain()
HasPlain(438103441441)
```

プレーンデータ型の配列も同じ振る舞いをします。

内部コンストラクターから不完全なオブジェクトをほかの関数に渡し、初期化の完了を委ねることもできます。

```jldoctest
julia> mutable struct Lazy
           data
           Lazy(v) = complete_me(new(), v)
       end
```

コンストラクターから返される不完全なオブジェクトの場合と同様に、`complete_me`またはその呼び出し先が、初期化前に`Lazy`オブジェクトの`data`フィールドにアクセスしようとすると、ただちにエラーが発生します。

## Parametric Constructors

パラメトリック型では、コンストラクターの仕組みにいくつか注意点が加わります。[Parametric Types](@ref)で説明したように、デフォルトでは、パラメトリック複合型のインスタンスは、型パラメーターを明示して構築することも、コンストラクターに渡した引数の型から型パラメーターを推論して構築することもできます。例をいくつか示します。

```jldoctest parametric; filter = r"Closest candidates.*\n  .*"
julia> struct Point{T<:Real}
           x::T
           y::T
       end

julia> Point(1,2) ## implicit T ##
Point{Int64}(1, 2)

julia> Point(1.0,2.5) ## implicit T ##
Point{Float64}(1.0, 2.5)

julia> Point(1,2.5) ## implicit T ##
ERROR: MethodError: no method matching Point(::Int64, ::Float64)
The type `Point` exists, but no method is defined for this combination of argument types when trying to construct it.

Closest candidates are:
  Point(::T, ::T) where T<:Real at none:2

julia> Point{Int64}(1, 2) ## explicit T ##
Point{Int64}(1, 2)

julia> Point{Int64}(1.0,2.5) ## explicit T ##
ERROR: InexactError: Int64(2.5)
Stacktrace:
[...]

julia> Point{Float64}(1.0, 2.5) ## explicit T ##
Point{Float64}(1.0, 2.5)

julia> Point{Float64}(1,2) ## explicit T ##
Point{Float64}(1.0, 2.0)
```

ご覧のとおり、型パラメーターを明示したコンストラクター呼び出しでは、引数は推論されたフィールド型に変換されます。`Point{Int64}(1,2)`は動作しますが、`Point{Int64}(1.0,2.5)`は`2.5`を[`Int64`](@ref)に変換する際に[`InexactError`](@ref)を発生させます。`Point(1,2)`のように、コンストラクター呼び出しの引数から型を推論する場合、引数の型は一致していなければなりません。一致しないと`T`を決定できないためです。ただし、型が一致する実数の引数の組であれば、汎用の`Point`コンストラクターに渡せます。

実際には、`Point`、`Point{Float64}`、`Point{Int64}`は、それぞれ異なるコンストラクター関数です。実際、`Point{T}`は、型`T`ごとに異なるコンストラクター関数です。内部コンストラクターを明示的に定義しない場合、複合型`Point{T<:Real}`の宣言によって、可能な各型`T<:Real`に対し、非パラメトリック型のデフォルト内部コンストラクターと同じように動作する内部コンストラクター`Point{T}`が自動的に提供されます。また、同じ型の実数の引数を2つ受け取る、汎用の外部`Point`コンストラクターも1つ提供されます。これらのコンストラクターが自動的に提供される仕組みは、次のように明示的に宣言するのと同じです。

```jldoctest parametric2
julia> struct Point{T<:Real}
           x::T
           y::T
           Point{T}(x,y) where {T<:Real} = new(x,y)
       end

julia> Point(x::T, y::T) where {T<:Real} = Point{T}(x,y);
```

各定義の形が、それぞれが処理するコンストラクター呼び出しの形と一致していることに注目してください。`Point{Int64}(1,2)`という呼び出しは、`struct`ブロック内の`Point{T}(x,y)`定義を呼び出します。一方、外部コンストラクターの宣言は、同じ実数型の値の組にのみ適用される、汎用の`Point`コンストラクターのメソッドを定義します。この宣言により、`Point(1,2)`や`Point(1.0,2.5)`のように、型パラメーターを明示しないコンストラクター呼び出しが動作します。メソッド宣言で引数の型が同じであることを要求しているため、型の異なる引数を渡す`Point(1,2.5)`のような呼び出しでは、「メソッドがない」というエラーになります。

整数値`1`を浮動小数点値`1.0`に「昇格」させて、`Point(1,2.5)`というコンストラクター呼び出しを動作させたいとします。これを実現する最も簡単な方法は、次の外部コンストラクターメソッドを追加することです。

```jldoctest parametric2
julia> Point(x::Int64, y::Float64) = Point(convert(Float64,x),y);
```

このメソッドは[`convert`](@ref)関数を使って`x`を明示的に[`Float64`](@ref)に変換し、両方の引数が[`Float64`](@ref)である場合の汎用コンストラクターに構築を委ねます。このメソッドを定義すると、以前は[`MethodError`](@ref)だった呼び出しが、`Point{Float64}`型の点を正常に作成するようになります。

```jldoctest parametric2
julia> p = Point(1,2.5)
Point{Float64}(1.0, 2.5)

julia> typeof(p)
Point{Float64}
```

しかし、同様のほかの呼び出しは、依然として動作しません。

```jldoctest parametric2
julia> Point(1.5,2)
ERROR: MethodError: no method matching Point(::Float64, ::Int64)
The type `Point` exists, but no method is defined for this combination of argument types when trying to construct it.

Closest candidates are:
  Point(::T, !Matched::T) where T<:Real
   @ Main none:1
  Point(!Matched::Int64, !Matched::Float64)
   @ Main none:1

Stacktrace:
[...]
```

このような呼び出しをすべて適切に動作させる、より一般的な方法については、[Conversion and Promotion](@ref conversion-and-promotion)を参照してください。先の展開を明かすことになりますが、汎用の`Point`コンストラクターへのすべての呼び出しを期待どおりに動作させるには、次の外部メソッド定義だけで十分です。

```jldoctest parametric2
julia> Point(x::Real, y::Real) = Point(promote(x,y)...);
```

`promote`関数は、すべての引数を共通の型（この場合は[`Float64`](@ref)）に変換します。このメソッド定義により、`Point`コンストラクターは、[`+`](@ref)のような数値演算子と同じ方法で引数を昇格させ、あらゆる種類の実数に対応します。

```jldoctest parametric2
julia> Point(1.5,2)
Point{Float64}(1.5, 2.0)

julia> Point(1,1//2)
Point{Rational{Int64}}(1//1, 1//2)

julia> Point(1.0,1//2)
Point{Float64}(1.0, 0.5)
```

このように、Juliaでデフォルト提供される暗黙的な型パラメーター付きコンストラクターはかなり厳密ですが、比較的柔軟で適切な振る舞いをするよう、簡単に変更できます。さらに、コンストラクターでは型システム、メソッド、多重ディスパッチの機能をすべて活用できるため、高度な振る舞いも通常は簡単に定義できます。

## Case Study: Rational

これまでの内容をまとめるには、パラメトリック複合型とそのコンストラクターメソッドの実例を示すのが最適でしょう。そこで、Julia組み込みの[`Rational`](@ref)型に似た、有理数型`OurRational`を独自に実装します。これは[`rational.jl`](https://github.com/JuliaLang/julia/blob/master/base/rational.jl)で定義されています。

```jldoctest rational
julia> struct OurRational{T<:Integer} <: Real
           num::T
           den::T
           function OurRational{T}(num::T, den::T) where T<:Integer
               if num == 0 && den == 0
                    error("invalid rational: 0//0")
               end
               num = flipsign(num, den)
               den = flipsign(den, den)
               g = gcd(num, den)
               num = div(num, g)
               den = div(den, g)
               new(num, den)
           end
       end

julia> OurRational(n::T, d::T) where {T<:Integer} = OurRational{T}(n,d)
OurRational

julia> OurRational(n::Integer, d::Integer) = OurRational(promote(n,d)...)
OurRational

julia> OurRational(n::Integer) = OurRational(n,one(n))
OurRational

julia> ⊘(n::Integer, d::Integer) = OurRational(n,d)
⊘ (generic function with 1 method)

julia> ⊘(x::OurRational, y::Integer) = x.num ⊘ (x.den*y)
⊘ (generic function with 2 methods)

julia> ⊘(x::Integer, y::OurRational) = (x*y.den) ⊘ y.num
⊘ (generic function with 3 methods)

julia> ⊘(x::Complex, y::Real) = complex(real(x) ⊘ y, imag(x) ⊘ y)
⊘ (generic function with 4 methods)

julia> ⊘(x::Real, y::Complex) = (x*y') ⊘ real(y*y')
⊘ (generic function with 5 methods)

julia> function ⊘(x::Complex, y::Complex)
           xy = x*y'
           yy = real(y*y')
           complex(real(xy) ⊘ yy, imag(xy) ⊘ yy)
       end
⊘ (generic function with 6 methods)
```

最初の行、`struct OurRational{T<:Integer} <: Real`は、`OurRational`が整数型の型パラメーターを1つ取り、それ自体が実数型であることを宣言しています。フィールド宣言`num::T`と`den::T`は、`OurRational{T}`オブジェクトが型`T`の整数を2つ保持することを示しています。一方は有理数の分子、もう一方は分母を表します。

ここからが興味深いところです。`OurRational`には内部コンストラクターメソッドが1つだけあり、`num`と`den`が同時にゼロにならないことを検査するとともに、すべての有理数が分母を非負とする「既約分数」の形で構築されるようにします。まず、分母が負なら分子と分母の符号を反転します。次に、両方を最大公約数で割ります（`gcd`は、引数の符号にかかわらず常に非負の数を返します）。`OurRational`の内部コンストラクターはこれだけなので、`OurRational`オブジェクトは常にこの正規化された形で構築されると保証できます。

`OurRational`には、利便性のための外部コンストラクターメソッドもいくつか用意されています。1つ目は「標準的な」汎用コンストラクターで、分子と分母の型が同じ場合、その型から型パラメーター`T`を推論します。2つ目は、分子と分母の値の型が異なる場合に適用されます。両者を共通の型に昇格させた後、引数の型が一致する外部コンストラクターに構築を委ねます。3つ目の外部コンストラクターは、分母に`1`の値を与えて、整数値を有理数に変換します。

外部コンストラクターの定義に続いて、有理数を記述する構文（例：`1 ⊘ 2`）を提供する`⊘`演算子のメソッドをいくつか定義しています。Juliaの`Rational`型では、この目的に[`//`](@ref)演算子を使います。これらの定義より前の`⊘`は、構文だけがあり意味を持たない、完全に未定義の演算子です。定義後は、[Rational Numbers](@ref)で説明したとおりに動作します。その振る舞いのすべてが、これら数行で定義されています。`⊘`を中置演算子として使えるのは、Juliaが中置演算子として認識する記号の集合を持っているためです。最初の最も基本的な定義では、整数である`a`と`b`に対して、`a ⊘ b`が`OurRational`コンストラクターを適用し、`OurRational`を構築するようにします。`⊘`のオペランドの一方がすでに有理数の場合、結果の比を表す新しい有理数は少し異なる方法で構築します。この振る舞いは、実際には有理数を整数で割る場合と同じです。最後に、`⊘`を複素整数値に適用すると、`Complex{<:OurRational}`のインスタンス、つまり実部と虚部が有理数である複素数が作成されます。

```jldoctest rational
julia> z = (1 + 2im) ⊘ (1 - 2im);

julia> typeof(z)
Complex{OurRational{Int64}}

julia> typeof(z) <: Complex{<:OurRational}
true
```

したがって、`⊘`演算子は通常`OurRational`のインスタンスを返しますが、引数のいずれかが複素整数なら、代わりに`Complex{<:OurRational}`のインスタンスを返します。興味のある読者は、[`rational.jl`](https://github.com/JuliaLang/julia/blob/master/base/rational.jl)の残りの部分もぜひご覧ください。短く自己完結しており、Juliaの基本的な型を丸ごと実装しています。

## Outer-only constructors

これまで見てきたように、典型的なパラメトリック型には、型パラメーターが既知の場合に呼び出される内部コンストラクターがあります。たとえば、`Point{Int}`には適用されますが、`Point`には適用されません。必要に応じて、型パラメーターを自動的に決定する外部コンストラクターを追加できます。たとえば、`Point(1,2)`という呼び出しから`Point{Int}`を構築できます。外部コンストラクターは、実際のインスタンス作成を内部コンストラクターに委ねます。しかし、型パラメーターを手動で指定できないようにするため、内部コンストラクターを用意したくない場合もあります。

たとえば、ベクトルと、その合計を正確に表す値を一緒に格納する型を定義するとします。

```jldoctest
julia> struct SummedArray{T<:Number,S<:Number}
           data::Vector{T}
           sum::S
       end

julia> SummedArray(Int32[1; 2; 3], Int32(6))
SummedArray{Int32, Int32}(Int32[1, 2, 3], 6)
```

問題は、情報の損失を抑えて多数の要素を合計できるように、`S`を`T`より大きな型にしたいことです。たとえば、`T`が[`Int32`](@ref)なら、`S`は[`Int64`](@ref)にしたいと考えています。そのため、ユーザーが型`SummedArray{Int32,Int32}`のインスタンスを構築できるインターフェースは避けたいところです。これを実現する方法の1つは、`SummedArray`に対するコンストラクターだけを用意し、`struct`の定義ブロック内でデフォルトコンストラクターの生成を抑制することです。

```jldoctest
julia> struct SummedArray{T<:Number,S<:Number}
           data::Vector{T}
           sum::S
           function SummedArray(a::Vector{T}) where T
               S = widen(T)
               new{T,S}(a, sum(S, a))
           end
       end

julia> SummedArray(Int32[1; 2; 3], Int32(6))
ERROR: MethodError: no method matching SummedArray(::Vector{Int32}, ::Int32)
The type `SummedArray` exists, but no method is defined for this combination of argument types when trying to construct it.

Closest candidates are:
  SummedArray(::Vector{T}) where T
   @ Main none:4

Stacktrace:
[...]
```

このコンストラクターは、`SummedArray(a)`という構文で呼び出されます。`new{T,S}`という構文では、構築する型のパラメーターを指定できます。つまり、この呼び出しは`SummedArray{T,S}`を返します。`new{T,S}`は任意のコンストラクター定義で使用できますが、利便性のため、可能な場合は構築対象の型から`new{}`のパラメーターが自動的に導出されます。

## Constructors are just callable objects

メソッドを定義すれば、どの型のオブジェクトも[made callable](@ref "Function-like objects")にできます。これには型、つまり[`Type`](@ref)型のオブジェクトも含まれます。実際、コンストラクターは呼び出し可能な型オブジェクトと見なすことができます。たとえば、`Bool`とそのさまざまな上位型には、多数のメソッドが定義されています。

```@repl
methods(Bool)
```

通常のコンストラクター構文は、関数のように呼び出し可能なオブジェクトを使う構文とまったく同じです。そのため、どちらの構文でもメソッドを定義しようとすると、最初のメソッドは次のメソッドによって上書きされます。

```jldoctest
julia> struct S
           f::Int
       end

julia> S() = S(7)
S

julia> (::Type{S})() = S(8)  # overwrites the previous constructor method

julia> S()
S(8)
```
