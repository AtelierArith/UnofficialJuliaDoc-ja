# [Constructors](@id man-constructors)

コンストラクタ [^1] は新しいオブジェクト、具体的には [Composite Types](@ref) のインスタンスを作成する関数です。Julia では、型オブジェクトもコンストラクタ関数として機能します。これは、引数タプルに対して関数として適用されると、自身の新しいインスタンスを作成します。このことは、合成型が導入されたときに簡単に言及されました。例えば：

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

多くのタイプにおいて、フィールド値を結びつけることで新しいオブジェクトを形成することが、インスタンスを作成するために必要なすべてです。しかし、複合オブジェクトを作成する際には、より多くの機能が必要な場合があります。時には、不変条件を強制する必要があり、引数をチェックしたり、変換したりすることがあります。 [Recursive data structures](https://en.wikipedia.org/wiki/Recursion_%28computer_science%29#Recursive_data_structures_.28structural_recursion.29)、特に自己参照的なものは、最初に不完全な状態で作成され、その後プログラム的に変更されて完全なものにされるという別のステップを経なければ、クリーンに構築することができないことがよくあります。時には、フィールドよりも少ない、または異なるタイプのパラメータでオブジェクトを構築できることが便利です。Juliaのオブジェクト構築システムは、これらすべてのケースに対処しています。

[^1]: Nomenclature: while the term "constructor" generally refers to the entire function which constructs objects of a type, it is common to abuse terminology slightly and refer to specific constructor methods as "constructors". In such situations, it is generally clear from the context that the term is used to mean "constructor method" rather than "constructor function", especially as it is often used in the sense of singling out a particular method of the constructor from all of the others.

## [Outer Constructor Methods](@id man-outer-constructor-methods)

コンストラクタは、Juliaの他の関数と同様に、その全体的な動作はメソッドの組み合わせによって定義されます。したがって、新しいメソッドを定義することで、コンストラクタに機能を追加できます。たとえば、`Foo`オブジェクトのために、1つの引数のみを受け取り、与えられた値を`bar`と`baz`の両方のフィールドに使用するコンストラクタメソッドを追加したいとしましょう。これは簡単です：

```jldoctest footype
julia> Foo(x) = Foo(x,x)
Foo

julia> Foo(1)
Foo(1, 1)
```

`bar` と `baz` フィールドの両方にデフォルト値を供給するゼロ引数の `Foo` コンストラクタメソッドを追加することもできます。

```jldoctest footype
julia> Foo() = Foo(0)
Foo

julia> Foo()
Foo(0, 0)
```

ここでは、ゼロ引数のコンストラクタメソッドが単一引数のコンストラクタメソッドを呼び出し、それが自動的に提供される二引数のコンストラクタメソッドを呼び出します。すぐに明らかになる理由から、このように通常のメソッドとして宣言された追加のコンストラクタメソッドは*外部*コンストラクタメソッドと呼ばれます。外部コンストラクタメソッドは、自動的に提供されるデフォルトのものなど、他のコンストラクタメソッドを呼び出すことによってのみ新しいインスタンスを作成できます。

## [Inner Constructor Methods](@id man-inner-constructor-methods)

外部コンストラクターメソッドは、オブジェクトを構築するための追加の便利なメソッドを提供するという問題に対処するのに成功していますが、この章の導入部で言及された他の2つのユースケース、すなわち不変条件の強制と自己参照オブジェクトの構築を許可することには対処できていません。これらの問題には、*内部*コンストラクターメソッドが必要です。内部コンストラクターメソッドは、外部コンストラクターメソッドに似ていますが、2つの違いがあります：

1. それは通常のメソッドのように外側ではなく、型宣言のブロック内で宣言されます。
2. 特別なローカルに存在する関数 [`new`](@ref) にアクセスでき、ブロックのタイプのオブジェクトを作成します。

例えば、最初の数が2番目の数より大きくないという制約のもとで、実数のペアを保持する型を宣言したいとします。このように宣言することができます：

```jldoctest pairtype
julia> struct OrderedPair
           x::Real
           y::Real
           OrderedPair(x,y) = x > y ? error("out of order") : new(x,y)
       end
```

現在、`OrderedPair`オブジェクトは`x <= y`となるようにのみ構築できます：

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

もし型が`mutable`として宣言されていた場合、フィールドの値を直接変更してこの不変条件を破ることができました。もちろん、オブジェクトの内部に無断で手を加えることは悪い習慣です。あなた（または他の誰か）が後で追加の外部コンストラクタメソッドを提供することもできますが、一度型が宣言されると、追加の内部コンストラクタメソッドを加える方法はありません。外部コンストラクタメソッドは他のコンストラクタメソッドを呼び出すことによってのみオブジェクトを作成できるため、最終的にはオブジェクトを作成するためにいくつかの内部コンストラクタが呼び出されなければなりません。これにより、宣言された型のすべてのオブジェクトは、型に提供された内部コンストラクタメソッドのいずれかへの呼び出しによって存在することが保証され、型の不変条件のある程度の強制が与えられます。

内部コンストラクタメソッドが定義されている場合、デフォルトコンストラクタメソッドは提供されません：これは、必要なすべての内部コンストラクタを自分で用意したと見なされます。デフォルトコンストラクタは、オブジェクトのすべてのフィールドをパラメータとして受け取る独自の内部コンストラクタメソッドを書くことと同等であり（対応するフィールドに型がある場合は、その型に制約されます）、それらを`new`に渡し、結果として得られるオブジェクトを返します：

```jldoctest
julia> struct Foo
           bar
           baz
           Foo(bar,baz) = new(bar,baz)
       end

```

この宣言は、明示的な内部コンストラクタメソッドなしでの `Foo` 型の以前の定義と同じ効果を持ちます。次の2つの型は同等です - 1つはデフォルトコンストラクタを持ち、もう1つは明示的なコンストラクタを持っています：

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

内部コンストラクタメソッドはできるだけ少なく提供することが良いプラクティスです：すべての引数を明示的に受け取り、重要なエラーチェックと変換を強制するものだけです。デフォルト値や補助的な変換を提供する追加の便利なコンストラクタメソッドは、内部コンストラクタを呼び出して重い処理を行う外部コンストラクタとして提供されるべきです。この分離は通常非常に自然です。

## Incomplete Initialization

最終的な問題は、自己参照オブジェクト、あるいはより一般的には再帰的データ構造の構築がまだ対処されていないことです。根本的な難しさはすぐには明らかでないかもしれないので、簡単に説明しましょう。次の再帰的型宣言を考えてみましょう：

```jldoctest selfrefer
julia> mutable struct SelfReferential
           obj::SelfReferential
       end

```

このタイプは無害に見えるかもしれませんが、それをインスタンス化する方法を考えるとそうではありません。もし `a` が `SelfReferential` のインスタンスであれば、次の呼び出しによって2番目のインスタンスを作成できます:

```julia-repl
julia> b = SelfReferential(a)
```

しかし、`obj` フィールドに有効な値を提供するインスタンスが存在しない場合、最初のインスタンスをどのように構築するのでしょうか？唯一の解決策は、`obj` フィールドが未割り当ての不完全に初期化された `SelfReferential` インスタンスを作成し、その不完全なインスタンスを別のインスタンスの `obj` フィールドの有効な値として使用することです。例えば、それ自体などです。

不完全に初期化されたオブジェクトの作成を許可するために、Juliaは[`new`](@ref)関数を、型が持つフィールドの数よりも少ない数で呼び出すことを許可し、指定されていないフィールドが初期化されていないオブジェクトを返します。内部コンストラクタメソッドは、その後、不完全なオブジェクトを使用して初期化を完了し、返すことができます。ここでは、例えば、`SelfReferential`型を定義する別の試みを示します。今回は、引数なしの内部コンストラクタを使用して、`obj`フィールドが自分自身を指すインスタンスを返します。

```jldoctest selfrefer2
julia> mutable struct SelfReferential
           obj::SelfReferential
           SelfReferential() = (x = new(); x.obj = x)
       end

```

このコンストラクタが機能し、実際に自己参照的なオブジェクトを構築することを確認できます：

```jldoctest selfrefer2
julia> x = SelfReferential();

julia> x === x
true

julia> x === x.obj
true

julia> x === x.obj.obj
true
```

一般的には、内部コンストラクタから完全に初期化されたオブジェクトを返すことが良いアイデアですが、不完全に初期化されたオブジェクトを返すことも可能です：

```jldoctest incomplete
julia> mutable struct Incomplete
           data
           Incomplete() = new()
       end

julia> z = Incomplete();
```

未初期化のフィールドを持つオブジェクトを作成することは許可されていますが、未初期化の参照にアクセスすることは即座にエラーになります：

```jldoctest incomplete
julia> z.data
ERROR: UndefRefError: access to undefined reference
```

これにより、`null` 値を継続的にチェックする必要がなくなります。ただし、すべてのオブジェクトフィールドが参照であるわけではありません。Julia は、いくつかの型を「プレーンデータ」と見なしており、これはすべてのデータが自己完結しており、他のオブジェクトを参照しないことを意味します。プレーンデータ型は、原始型（例: `Int`）および他のプレーンデータ型の不変構造体で構成されています（参照: [`isbits`](@ref)、[`isbitstype`](@ref)）。プレーンデータ型の初期内容は未定義です：

```julia-repl
julia> struct HasPlain
           n::Int
           HasPlain() = new()
       end

julia> HasPlain()
HasPlain(438103441441)
```

プレーンデータ型の配列は同じ動作を示します。

不完全なオブジェクトを内部コンストラクタから他の関数に渡して、その完了を委任することができます：

```jldoctest
julia> mutable struct Lazy
           data
           Lazy(v) = complete_me(new(), v)
       end
```

コンストラクタから返された不完全なオブジェクトと同様に、`complete_me` またはその呼び出し元のいずれかが、`Lazy` オブジェクトの `data` フィールドに初期化される前にアクセスしようとすると、エラーが即座にスローされます。

## Parametric Constructors

パラメトリック型は、コンストラクタの話にいくつかの複雑さを加えます。[Parametric Types](@ref) から思い出してください。デフォルトでは、パラメトリック合成型のインスタンスは、明示的に与えられた型パラメータを使用して構築するか、コンストラクタに与えられた引数の型によって暗黙的に型パラメータを決定することができます。以下はいくつかの例です：

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

ご覧のとおり、明示的な型パラメータを持つコンストラクタ呼び出しでは、引数は暗黙のフィールド型に変換されます：`Point{Int64}(1,2)` は動作しますが、`Point{Int64}(1.0,2.5)` は [`InexactError`](@ref) を生成し、`2.5` を [`Int64`](@ref) に変換する際にエラーが発生します。コンストラクタ呼び出しの引数によって型が暗黙的に決定される場合、例えば `Point(1,2)` のように、引数の型は一致しなければなりません – そうでなければ `T` を決定することができません – しかし、型が一致する任意の実数引数のペアは、汎用の `Point` コンストラクタに渡すことができます。

ここで実際に起こっていることは、`Point`、`Point{Float64}`、および `Point{Int64}` がすべて異なるコンストラクタ関数であるということです。実際、`Point{T}` は各タイプ `T` に対して異なるコンストラクタ関数です。明示的に提供された内部コンストラクタがない場合、合成型 `Point{T<:Real}` の宣言は、非パラメトリックなデフォルト内部コンストラクタと同様に動作する、各可能なタイプ `T<:Real` に対して自動的に内部コンストラクタ `Point{T}` を提供します。また、同じタイプの実引数のペアを受け取る単一の一般的な外部 `Point` コンストラクタも提供します。このコンストラクタの自動提供は、次の明示的な宣言に相当します：

```jldoctest parametric2
julia> struct Point{T<:Real}
           x::T
           y::T
           Point{T}(x,y) where {T<:Real} = new(x,y)
       end

julia> Point(x::T, y::T) where {T<:Real} = Point{T}(x,y);
```

各定義が処理するコンストラクタ呼び出しの形式に似ていることに注意してください。呼び出し `Point{Int64}(1,2)` は、`struct` ブロック内の定義 `Point{T}(x,y)` を呼び出します。一方、外部コンストラクタ宣言は、同じ実数型の値のペアにのみ適用される一般的な `Point` コンストラクタのメソッドを定義します。この宣言により、明示的な型パラメータなしでのコンストラクタ呼び出し、例えば `Point(1,2)` や `Point(1.0,2.5)` が機能します。メソッド宣言が引数を同じ型に制限するため、異なる型の引数を持つ呼び出し `Point(1,2.5)` のようなものは、「メソッドなし」エラーを引き起こします。

`Point(1,2.5)`を動作させるために、整数値`1`を浮動小数点値`1.0`に「昇格」させる必要があるとします。これを達成する最も簡単な方法は、次の追加の外部コンストラクタメソッドを定義することです：

```jldoctest parametric2
julia> Point(x::Int64, y::Float64) = Point(convert(Float64,x),y);
```

このメソッドは、[`convert`](@ref) 関数を使用して `x` を明示的に [`Float64`](@ref) に変換し、両方の引数が `4d61726b646f776e2e436f64652822222c2022466c6f617436342229_40726566` である場合の一般的なコンストラクタに構築を委任します。このメソッド定義により、以前は [`MethodError`](@ref) であったものが、今では `Point{Float64}` 型のポイントを正常に作成します：

```jldoctest parametric2
julia> p = Point(1,2.5)
Point{Float64}(1.0, 2.5)

julia> typeof(p)
Point{Float64}
```

しかし、他の同様の呼び出しはまだ機能しません：

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

For a more general way to make all such calls work sensibly, see [Conversion and Promotion](@ref conversion-and-promotion). At the risk of spoiling the suspense, we can reveal here that all it takes is the following outer method definition to make all calls to the general `Point` constructor work as one would expect:

```jldoctest parametric2
julia> Point(x::Real, y::Real) = Point(promote(x,y)...);
```

`promote` 関数は、すべての引数を共通の型に変換します。この場合は [`Float64`](@ref) です。このメソッド定義により、`Point` コンストラクタは、[`+`](@ref) のような数値演算子と同じ方法で引数を昇格させ、すべての種類の実数に対して機能します。

```jldoctest parametric2
julia> Point(1.5,2)
Point{Float64}(1.5, 2.0)

julia> Point(1,1//2)
Point{Rational{Int64}}(1//1, 1//2)

julia> Point(1.0,1//2)
Point{Float64}(1.0, 0.5)
```

したがって、Juliaでデフォルトで提供される暗黙の型パラメータコンストラクタはかなり厳格ですが、より緩やかで理にかなった方法で動作させることは非常に簡単です。さらに、コンストラクタは型システム、メソッド、および多重ディスパッチのすべての力を活用できるため、洗練された動作を定義することは通常非常に簡単です。

## Case Study: Rational

おそらく、これらのすべての要素を結びつける最良の方法は、パラメトリックコンポジット型とそのコンストラクターメソッドの実世界の例を示すことです。そのために、私たち自身の有理数型 `OurRational` を実装します。これは、Juliaの組み込み [`Rational`](@ref) 型に似ています。この型は、[`rational.jl`](https://github.com/JuliaLang/julia/blob/master/base/rational.jl) で定義されています。

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

最初の行 – `struct OurRational{T<:Integer} <: Real` – は、`OurRational` が整数型の型パラメータを1つ取ることを宣言し、かつそれ自体が実数型であることを示しています。フィールド宣言 `num::T` と `den::T` は、`OurRational{T}` オブジェクトが型 `T` の整数のペアを保持していることを示しており、一方は有理数の分子を、もう一方は分母を表しています。

今、物事が面白くなってきました。 `OurRational` には、`num` と `den` が両方ともゼロでないことを確認し、すべての有理数が「最小の形」で非負の分母を持つように構築される単一の内部コンストラクタメソッドがあります。これは、まず分母が負の場合に分子と分母の符号を反転させることで実現されます。その後、両方は最大公約数で割られます（`gcd` は常に引数の符号に関係なく非負の数を返します）。これが `OurRational` の唯一の内部コンストラクタであるため、`OurRational` オブジェクトは常にこの正規化された形で構築されることが確実です。

`OurRational` は、便利さのためにいくつかの外部コンストラクタメソッドも提供しています。最初のものは、分子と分母が同じ型を持つ場合に型パラメータ `T` を推論する「標準的な」一般コンストラクタです。2番目は、与えられた分子と分母の値が異なる型を持つ場合に適用されます：それらを共通の型に昇格させ、その後、型が一致する引数の外部コンストラクタに構築を委任します。3番目の外部コンストラクタは、整数値を有理数に変換するために、分母として `1` の値を供給します。

外部コンストラクタの定義に従って、`⊘` 演算子のためのいくつかのメソッドを定義しました。これは、有理数を書くための構文を提供します（例：`1 ⊘ 2`）。Juliaの `Rational` 型は、この目的のために [`//`](@ref) 演算子を使用します。これらの定義の前では、`⊘` は完全に未定義の演算子で、構文だけがあり意味はありません。その後、[Rational Numbers](@ref) に記載されているように振る舞います – その全ての動作はこれらの数行で定義されています。`⊘` の中置使用が機能するのは、Juliaが中置演算子として認識されるシンボルのセットを持っているからです。最初の基本的な定義は、`a ⊘ b` が `a` と `b` が整数のときに `OurRational` コンストラクタを適用して `OurRational` を構築することを単純に行います。`⊘` のオペランドの一方がすでに有理数である場合、結果の比率のために新しい有理数を少し異なる方法で構築します。この動作は、実際には有理数と整数の除算と同じです。最後に、複素整数値に `⊘` を適用すると、`Complex{<:OurRational}` のインスタンスが作成されます – 実部と虚部が有理数である複素数です。

```jldoctest rational
julia> z = (1 + 2im) ⊘ (1 - 2im);

julia> typeof(z)
Complex{OurRational{Int64}}

julia> typeof(z) <: Complex{<:OurRational}
true
```

したがって、`⊘` 演算子は通常 `OurRational` のインスタンスを返しますが、引数のいずれかが複素整数である場合、代わりに `Complex{<:OurRational}` のインスタンスを返します。興味のある読者は、[`rational.jl`](https://github.com/JuliaLang/julia/blob/master/base/rational.jl) の残りを読むことを検討すべきです：それは短く、自己完結しており、基本的な Julia タイプ全体を実装しています。

## Outer-only constructors

ご覧のように、典型的なパラメトリック型には、型パラメータが知られているときに呼び出される内部コンストラクタがあります。例えば、`Point{Int}`には適用されますが、`Point`には適用されません。オプションとして、型パラメータを自動的に決定する外部コンストラクタを追加することができます。例えば、`Point(1,2)`の呼び出しから`Point{Int}`を構築することができます。外部コンストラクタは、実際にインスタンスを作成するために内部コンストラクタを呼び出します。しかし、特定の型パラメータを手動で要求できないように、内部コンストラクタを提供しない方が良い場合もあります。

例えば、ベクトルとその合計の正確な表現を格納する型を定義するとしましょう：

```jldoctest
julia> struct SummedArray{T<:Number,S<:Number}
           data::Vector{T}
           sum::S
       end

julia> SummedArray(Int32[1; 2; 3], Int32(6))
SummedArray{Int32, Int32}(Int32[1, 2, 3], 6)
```

問題は、`S` を `T` よりも大きな型にしたいということです。そうすることで、情報の損失を少なくして多くの要素を合計することができます。例えば、`T` が [`Int32`](@ref) の場合、`S` は [`Int64`](@ref) であることを望みます。したがって、ユーザーが `SummedArray{Int32,Int32}` 型のインスタンスを構築できるインターフェースを避けたいと考えています。これを実現する一つの方法は、`SummedArray` のためのコンストラクタのみを提供し、`struct` 定義ブロック内でデフォルトコンストラクタの生成を抑制することです。

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

このコンストラクタは、構文 `SummedArray(a)` によって呼び出されます。構文 `new{T,S}` は、構築される型のパラメータを指定することを可能にします。つまり、この呼び出しは `SummedArray{T,S}` を返します。`new{T,S}` は任意のコンストラクタ定義で使用できますが、便利さのために、`new{}` のパラメータは可能な場合に構築される型から自動的に導出されます。

## Constructors are just callable objects

任意のタイプのオブジェクトは、メソッドを定義することによって [made callable](@ref "Function-like objects") になる可能性があります。これにはタイプ、すなわち [`Type`](@ref) タイプのオブジェクトが含まれます。また、コンストラクタは実際には呼び出し可能なタイプオブジェクトとして見ることができます。例えば、`Bool` およびそのさまざまなスーパタイプに対して定義された多くのメソッドがあります：

```julia-repl
julia> methods(Bool)
# 10 methods for type constructor:
  [1] Bool(x::BigFloat)
     @ Base.MPFR mpfr.jl:393
  [2] Bool(x::Float16)
     @ Base float.jl:338
  [3] Bool(x::Rational)
     @ Base rational.jl:138
  [4] Bool(x::Real)
     @ Base float.jl:233
  [5] (dt::Type{<:Integer})(ip::Sockets.IPAddr)
     @ Sockets ~/tmp/jl/jl/julia-nightly-assert/share/julia/stdlib/v1.11/Sockets/src/IPAddr.jl:11
  [6] (::Type{T})(x::Enum{T2}) where {T<:Integer, T2<:Integer}
     @ Base.Enums Enums.jl:19
  [7] (::Type{T})(z::Complex) where T<:Real
     @ Base complex.jl:44
  [8] (::Type{T})(x::Base.TwicePrecision) where T<:Number
     @ Base twiceprecision.jl:265
  [9] (::Type{T})(x::T) where T<:Number
     @ boot.jl:894
 [10] (::Type{T})(x::AbstractChar) where T<:Union{AbstractChar, Number}
     @ char.jl:50
```

通常のコンストラクタ構文は、関数のようなオブジェクト構文と完全に同等であるため、それぞれの構文でメソッドを定義しようとすると、最初のメソッドが次のメソッドによって上書きされます：

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
