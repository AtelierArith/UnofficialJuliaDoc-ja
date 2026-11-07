# [Constructors](@id man-constructors)

コンストラクター[^1]とは、新しいオブジェクト、具体的には[Composite Types](@ref)のインスタンスを作成する関数です。Juliaでは、型オブジェクト自体もコンストラクター関数として機能します。型オブジェクトを関数として引数のタプルに適用すると、その型の新しいインスタンスが作成されます。この点については、複合型を導入した際にすでに簡単に触れました。たとえば、次のようになります。

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

多くの型では、フィールド値をまとめて新しいオブジェクトを作るだけで、インスタンスの作成に必要なことはすべて満たされます。しかし、複合オブジェクトの作成時に、さらに機能が必要となる場合もあります。引数を検査したり変換したりして、不変条件を保証しなければならないことがあります。特に自己参照する可能性のある[Recursive data structures](https://en.wikipedia.org/wiki/Recursion_%28computer_science%29#Recursive_data_structures_.28structural_recursion.29)は、不完全な状態でいったん作成し、その後、オブジェクトの作成とは別の手順でプログラムから変更して完成させなければ、適切に構築できないことがよくあります。また、フィールドの数より少ない引数や、フィールドとは異なる型の引数でオブジェクトを構築できると便利な場合もあります。Juliaのオブジェクト構築システムは、こうしたケースをはじめ、さまざまな状況に対応します。

[^1]: 用語について：「コンストラクター」は一般に、ある型のオブジェクトを構築する関数全体を指しますが、特定のコンストラクターメソッドを「コンストラクター」と呼ぶこともよくあります。このような場合、特にコンストラクターの他のメソッドと区別して特定のメソッドを指すときには、文脈から「コンストラクター関数」ではなく「コンストラクターメソッド」を意味していることが通常明らかです。

## [Outer Constructor Methods](@id man-outer-constructor-methods)

コンストラクターは、全体としての振る舞いが各メソッドの振る舞いを組み合わせて定義されるという点で、Juliaの他の関数と同じです。したがって、新しいメソッドを定義するだけで、コンストラクターに機能を追加できます。たとえば、`Foo`オブジェクトに対して、引数を1つだけ受け取り、その値を`bar`フィールドと`baz`フィールドの両方に使うコンストラクターメソッドを追加したいとします。これは簡単です。

```jldoctest footype
julia> Foo(x) = Foo(x,x)
Foo

julia> Foo(1)
Foo(1, 1)
```

また、引数を取らず、`bar`フィールドと`baz`フィールドの両方に既定値を設定する`Foo`コンストラクターメソッドを追加することもできます。

```jldoctest footype
julia> Foo() = Foo(0)
Foo

julia> Foo()
Foo(0, 0)
```

ここでは、引数なしのコンストラクターメソッドが引数1つのコンストラクターメソッドを呼び出し、さらに後者が自動的に提供される引数2つのコンストラクターメソッドを呼び出しています。まもなく明らかになる理由から、このように通常のメソッドとして宣言する追加のコンストラクターメソッドを、*外部*コンストラクターメソッドと呼びます。外部コンストラクターメソッドは、自動的に提供される既定のものなど、別のコンストラクターメソッドを呼び出すことでしか、新しいインスタンスを作成できません。

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

内部コンストラクターメソッドを1つでも定義すると、既定のコンストラクターメソッドは提供されません。必要な内部コンストラクターはすべて自分で用意したものと見なされるためです。既定のコンストラクターは、オブジェクトのすべてのフィールドを引数として受け取り（対応するフィールドに型が指定されている場合は、その型に制約されます）、それらを`new`に渡して、返されたオブジェクトを返す内部コンストラクターメソッドを自分で記述するのと同じです。

```jldoctest
julia> struct Foo
           bar
           baz
           Foo(bar,baz) = new(bar,baz)
       end

```

この宣言は、内部コンストラクターメソッドを明示せずに`Foo`型を定義した先ほどの例と同じ効果を持ちます。次の2つの型は同等です。一方は既定のコンストラクターを使い、もう一方は明示的なコンストラクターを使っています。

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

内部コンストラクターメソッドは、必要最小限の数だけ用意するのがよい習慣です。つまり、すべての引数を明示的に受け取り、必須のエラーチェックや変換を行うものだけを定義します。既定値の設定や補助的な変換を行う追加の便利なコンストラクターメソッドは、内部コンストラクターに主要な処理を委ねる外部コンストラクターとして定義します。このように役割を分けるのは、たいてい自然なことです。

## Incomplete Initialization

まだ解決していない最後の問題は、自己参照オブジェクト、あるいはより一般的には再帰的なデータ構造の構築です。根本的な難しさはすぐには明らかでないかもしれないので、簡単に説明しましょう。次の再帰型宣言を考えてください。

```jldoctest selfrefer
julia> mutable struct SelfReferential
           obj::SelfReferential
       end

```

この型は一見問題なさそうですが、インスタンスの構築方法を考えると問題が生じます。`a`が`SelfReferential`のインスタンスなら、次の呼び出しで2つ目のインスタンスを作成できます。

```julia-repl
julia> b = SelfReferential(a)
```

しかし、`obj`フィールドに有効な値として渡せるインスタンスがまだ存在しないとき、最初のインスタンスはどう作ればよいのでしょうか。唯一の解決策は、`SelfReferential`の不完全に初期化されたインスタンスを作成できるようにし、`obj`フィールドを未割り当てのままにしておくことです。そして、その不完全なインスタンスを、別のインスタンスの`obj`フィールドに有効な値として渡します。たとえば、そのインスタンス自身を渡すこともできます。

不完全に初期化されたオブジェクトを作成できるようにするため、Juliaでは[`new`](@ref)関数を、型のフィールド数より少ない引数で呼び出せます。この場合、指定されなかったフィールドが未初期化のオブジェクトが返されます。その後、内部コンストラクターメソッドでこの不完全なオブジェクトを使い、返す前に初期化を完了できます。たとえば、`SelfReferential`型を定義する別の方法として、引数なしの内部コンストラクターを使い、`obj`フィールドが自身を指すインスタンスを返す方法があります。

```jldoctest selfrefer2
julia> mutable struct SelfReferential
           obj::SelfReferential
           SelfReferential() = (x = new(); x.obj = x)
       end

```

このコンストラクターが実際に自己参照オブジェクトを構築することを確認できます。

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

これにより、`null`の値を常に確認する必要がなくなります。ただし、オブジェクトのフィールドがすべて参照とは限りません。Juliaでは、一部の型を「プレーンデータ」と見なします。これは、そのデータがすべて自己完結しており、他のオブジェクトを参照しないことを意味します。プレーンデータ型には、プリミティブ型（例：`Int`）と、他のプレーンデータ型からなる不変構造体が含まれます（[`isbits`](@ref)、[`isbitstype`](@ref)も参照）。プレーンデータ型の初期内容は未定義です。

```julia-repl
julia> struct HasPlain
           n::Int
           HasPlain() = new()
       end

julia> HasPlain()
HasPlain(438103441441)
```

プレーンデータ型の配列も同じ振る舞いをします。

内部コンストラクターから不完全なオブジェクトを他の関数に渡し、初期化の完了を委ねることもできます。

```jldoctest
julia> mutable struct Lazy
           data
           Lazy(v) = complete_me(new(), v)
       end
```

コンストラクターから返された不完全なオブジェクトの場合と同様に、`complete_me`またはその呼び出し先が、初期化前に`Lazy`オブジェクトの`data`フィールドにアクセスしようとすると、ただちにエラーが発生します。

## Parametric Constructors

パラメトリック型では、コンストラクターに関していくつか注意点があります。[Parametric Types](@ref)で説明したように、既定では、パラメトリック複合型のインスタンスは、型パラメーターを明示して構築することも、コンストラクターに渡した引数の型から型パラメーターを推論して構築することもできます。例をいくつか示します。

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

ご覧のとおり、型パラメーターを明示したコンストラクター呼び出しでは、引数が推論されたフィールド型に変換されます。`Point{Int64}(1,2)`は成功しますが、`Point{Int64}(1.0,2.5)`は`2.5`を[`Int64`](@ref)に変換する際に[`InexactError`](@ref)を発生させます。一方、`Point(1,2)`のように、コンストラクター呼び出しの引数から型を推論する場合、引数の型は一致していなければなりません。そうでないと`T`を決定できないためです。ただし、型が一致する実数の引数であれば、汎用の`Point`コンストラクターに渡せます。

実際には、`Point`、`Point{Float64}`、`Point{Int64}`は、それぞれ異なるコンストラクター関数です。実際、`Point{T}`は、型`T`ごとに別個のコンストラクター関数です。内部コンストラクターを明示的に定義しない場合、複合型`Point{T<:Real}`の宣言によって、可能な型`T<:Real`ごとに内部コンストラクター`Point{T}`が自動的に提供されます。その振る舞いは、非パラメトリック型の既定の内部コンストラクターと同じです。また、同じ型の実数の引数を2つ受け取る、汎用の外部コンストラクター`Point`も1つ提供されます。これらのコンストラクターが自動的に提供されることは、次の宣言を明示的に記述するのと同じです。

```jldoctest parametric2
julia> struct Point{T<:Real}
           x::T
           y::T
           Point{T}(x,y) where {T<:Real} = new(x,y)
       end

julia> Point(x::T, y::T) where {T<:Real} = Point{T}(x,y);
```

各定義の形が、それぞれ対応するコンストラクター呼び出しの形になっていることに注目してください。`Point{Int64}(1,2)`という呼び出しは、`struct`ブロック内の定義`Point{T}(x,y)`を呼び出します。一方、外部コンストラクターの宣言は、同じ実数型の値のペアにのみ適用される、汎用の`Point`コンストラクターのメソッドを定義します。この宣言により、`Point(1,2)`や`Point(1.0,2.5)`のように、型パラメーターを明示しないコンストラクター呼び出しが機能します。このメソッド宣言では引数の型が同じであることを要求するため、型の異なる引数を渡す`Point(1,2.5)`のような呼び出しは、「メソッドがない」というエラーになります。

整数値`1`を浮動小数点値`1.0`に「昇格」させて、`Point(1,2.5)`というコンストラクター呼び出しを機能させたいとします。これを実現する最も簡単な方法は、次の外部コンストラクターメソッドを追加することです。

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

しかし、同様の呼び出しでも、まだ機能しないものがあります。

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

このような呼び出しをすべて適切に機能させる、より汎用的な方法については、[Conversion and Promotion](@ref conversion-and-promotion)を参照してください。先の展開を明かしてしまうと、汎用の`Point`コンストラクターへのすべての呼び出しを期待どおりに機能させるには、次の外部メソッド定義だけで十分です。

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

このように、Juliaで既定で提供される暗黙的な型パラメーター付きコンストラクターはかなり厳密ですが、より柔軟で適切な振る舞いにするのは簡単です。さらに、コンストラクターでは型システム、メソッド、多重ディスパッチの機能をすべて活用できるため、高度な振る舞いを定義するのもたいてい簡単です。

## Case Study: Rational

これまでの内容をまとめるには、パラメトリック複合型とそのコンストラクターメソッドの実例を示すのが最適でしょう。そこで、Julia組み込みの[`Rational`](@ref)型に似た、有理数型`OurRational`を独自に実装します。この型は[`rational.jl`](https://github.com/JuliaLang/julia/blob/master/base/rational.jl)で定義されています。

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

最初の行、`struct OurRational{T<:Integer} <: Real`は、`OurRational`が整数型の型パラメーターを1つ取り、それ自体が実数型であることを宣言しています。フィールド宣言`num::T`と`den::T`は、`OurRational{T}`オブジェクトが型`T`の整数を2つ保持することを示しています。一方は有理数の分子、もう一方は分母です。

ここからが興味深いところです。`OurRational`には内部コンストラクターメソッドが1つだけあり、`num`と`den`が同時にゼロになることを禁止し、すべての有理数が分母を非負とする「既約分数」の形で構築されるようにします。まず、分母が負の場合は分子と分母の符号を反転します。次に、両方を最大公約数で割ります（`gcd`は、引数の符号にかかわらず常に非負の数を返します）。`OurRational`の内部コンストラクターはこれだけなので、`OurRational`オブジェクトはすべて、この正規化された形で構築されると保証できます。

`OurRational`には、利便性のための外部コンストラクターメソッドもいくつかあります。1つ目は「標準的な」汎用コンストラクターで、分子と分母の型が同じ場合、その型から型パラメーター`T`を推論します。2つ目は、分子と分母の値の型が異なる場合に適用されます。両者を共通の型に昇格させた後、引数の型が一致する外部コンストラクターに構築を委ねます。3つ目の外部コンストラクターは、分母に`1`の値を指定して、整数値を有理数に変換します。

外部コンストラクターの定義に続いて、有理数を記述する構文（例：`1 ⊘ 2`）を提供する演算子`⊘`のメソッドをいくつか定義しています。Juliaの`Rational`型では、この目的に[`//`](@ref)演算子を使います。これらの定義を行う前の`⊘`は、構文だけがあり意味を持たない、完全に未定義の演算子です。定義後は[Rational Numbers](@ref)で説明したとおりに振る舞い、その振る舞いはこの数行で完全に定義されます。`⊘`を中置演算子として使えるのは、Juliaが中置演算子として認識する記号の集合を持っているためです。最初の最も基本的な定義では、オペランドが整数の場合に、`a ⊘ b`が`a`と`b`を`OurRational`コンストラクターに渡して、`OurRational`を構築します。`⊘`のオペランドの一方がすでに有理数の場合は、結果の比を表す新しい有理数を少し異なる方法で構築します。この振る舞いは、実際には有理数と整数の除算と同じです。最後に、`⊘`を複素整数値に適用すると、`Complex{<:OurRational}`のインスタンスが作成されます。これは、実部と虚部が有理数である複素数です。

```jldoctest rational
julia> z = (1 + 2im) ⊘ (1 - 2im);

julia> typeof(z)
Complex{OurRational{Int64}}

julia> typeof(z) <: Complex{<:OurRational}
true
```

したがって、`⊘`演算子は通常、`OurRational`のインスタンスを返しますが、引数のいずれかが複素整数の場合は、代わりに`Complex{<:OurRational}`のインスタンスを返します。興味のある方は、[`rational.jl`](https://github.com/JuliaLang/julia/blob/master/base/rational.jl)の残りの部分もご覧ください。短く自己完結しており、Juliaの基本的な型を丸ごと実装しています。

## Outer-only constructors

これまで見てきたように、一般的なパラメトリック型には、型パラメーターが既知の場合に呼び出される内部コンストラクターがあります。たとえば、`Point{Int}`には適用されますが、`Point`には適用されません。必要に応じて、型パラメーターを自動的に決定する外部コンストラクターを追加できます。たとえば、`Point(1,2)`という呼び出しから`Point{Int}`を構築できます。外部コンストラクターは、実際のインスタンス作成を内部コンストラクターに委ねます。しかし、場合によっては、内部コンストラクターを用意せず、特定の型パラメーターを手動で指定できないようにしたいこともあります。

たとえば、ベクトルと、その合計を正確に表す値を一緒に格納する型を定義するとします。

```jldoctest
julia> struct SummedArray{T<:Number,S<:Number}
           data::Vector{T}
           sum::S
       end

julia> SummedArray(Int32[1; 2; 3], Int32(6))
SummedArray{Int32, Int32}(Int32[1, 2, 3], 6)
```

問題は、情報の損失を抑えて多数の要素を合計できるように、`S`を`T`より大きな型にしたいことです。たとえば、`T`が[`Int32`](@ref)の場合、`S`は[`Int64`](@ref)にしたいと考えています。そのため、ユーザーが型`SummedArray{Int32,Int32}`のインスタンスを構築できるインターフェースは避けたいところです。1つの方法は、`SummedArray`に対するコンストラクターだけを用意し、`struct`の定義ブロック内で既定のコンストラクターの生成を抑制することです。

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

このコンストラクターは、`SummedArray(a)`という構文で呼び出されます。`new{T,S}`という構文では、構築する型のパラメーターを指定できます。つまり、この呼び出しは`SummedArray{T,S}`を返します。`new{T,S}`はどのコンストラクター定義でも使えますが、利便性のため、可能な場合は`new{}`のパラメーターが構築対象の型から自動的に導出されます。

## Constructors are just callable objects

メソッドを定義すれば、どの型のオブジェクトも[made callable](@ref "Function-like objects")にできます。これには型、つまり[`Type`](@ref)型のオブジェクトも含まれます。実際、コンストラクターは呼び出し可能な型オブジェクトと見なすことができます。たとえば、`Bool`とそのさまざまな上位型には、多数のメソッドが定義されています。

```@repl
methods(Bool)
```

通常のコンストラクター構文は、関数のようなオブジェクトを使う構文とまったく同じです。そのため、どちらの構文でもメソッドを定義しようとすると、最初のメソッドは次のメソッドによって上書きされます。

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
