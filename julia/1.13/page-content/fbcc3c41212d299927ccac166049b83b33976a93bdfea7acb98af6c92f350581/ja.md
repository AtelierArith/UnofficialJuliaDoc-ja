# Metaprogramming

JuliaがLispから受け継いだ最も大きな特徴は、メタプログラミングのサポートです。Lispと同様に、Juliaは自身のコードを言語自体のデータ構造として表現します。コードは言語内で作成・操作できるオブジェクトとして表現されるため、プログラムが自身のコードを変換したり生成したりできます。これにより、追加のビルド手順なしで高度なコード生成が可能になるとともに、[abstract syntax trees](https://en.wikipedia.org/wiki/Abstract_syntax_tree)のレベルで動作する、本来のLispスタイルのマクロも実現できます。対照的に、CやC++のようなプリプロセッサの「マクロ」システムは、実際の構文解析や解釈が行われる前に、テキストの操作と置換を行います。Juliaではすべてのデータ型とコードがJuliaのデータ構造で表現されるため、強力な[reflection](https://en.wikipedia.org/wiki/Reflection_%28computer_programming%29)機能を使い、プログラムの内部やその型を、ほかのデータと同じように調べることができます。

!!! warning
    メタプログラミングは強力なツールですが、複雑さを持ち込み、コードを理解しにくくすることがあります。たとえば、スコープの規則を正しく扱うのは、驚くほど難しい場合があります。通常、メタプログラミングは、[higher order functions](@ref man-anonymous-functions)や[closures](https://en.wikipedia.org/wiki/Closure_(computer_programming))などのほかの手法を適用できない場合にのみ使うべきです。

    `eval`の使用や新しいマクロの定義は、通常、最後の手段とすべきです。`Meta.parse`を使ったり、任意の文字列をJuliaコードに変換したりするのが適切なことは、ほとんどありません。Juliaコードを操作する場合は、Juliaの構文解析に伴う複雑さを避けるため、`Expr`データ構造を直接使ってください。

    メタプログラミングをうまく活用する実装では、機能の大部分を実行時のヘルパー関数で実現し、生成するコードの量を最小限に抑えることがよくあります。


## Program representation

すべてのJuliaプログラムは、文字列として始まります。

```jldoctest prog
julia> prog = "1 + 1"
"1 + 1"
```

**その次に何が起こるのでしょうか？**

次の段階では、それぞれの文字列に[parse](https://en.wikipedia.org/wiki/Parsing#Computer_languages)を行い、式と呼ばれるオブジェクトに変換します。式はJuliaの型[`Expr`](@ref)で表されます。

```jldoctest prog
julia> ex1 = Meta.parse(prog)
:(1 + 1)

julia> typeof(ex1)
Expr
```

`Expr`オブジェクトは、次の2つの部分で構成されます。

  * 式の種類を識別する[`Symbol`](@ref)。シンボルは[interned string](https://en.wikipedia.org/wiki/String_interning)な識別子です（詳しくは後述します）。

```jldoctest prog
julia> ex1.head
:call
```

  * 式の引数。シンボル、ほかの式、またはリテラル値を指定できます。

```jldoctest prog
julia> ex1.args
3-element Vector{Any}:
  :+
 1
 1
```

式は、[prefix notation](https://en.wikipedia.org/wiki/Polish_notation)で直接構築することもできます。

```jldoctest prog
julia> ex2 = Expr(:call, :+, 1, 1)
:(1 + 1)
```

上で構築した2つの式、つまり構文解析による式と直接構築した式は、同等です。

```jldoctest prog
julia> ex1 == ex2
true
```

**ここで重要なのは、Juliaコードが、言語自体からアクセスできるデータ構造として内部的に表現されているという点です。**

[`dump`](@ref)関数は、`Expr`オブジェクトをインデントと注釈付きで表示します。

```jldoctest prog
julia> dump(ex2)
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Int64 1
    3: Int64 1
```

`Expr`オブジェクトは、入れ子にすることもできます。

```jldoctest ex3
julia> ex3 = Meta.parse("(4 + 4) / 2")
:((4 + 4) / 2)
```

式を表示する別の方法として、`Meta.show_sexpr`があります。これは、指定した`Expr`を[S-expression](https://en.wikipedia.org/wiki/S-expression)形式で表示します。この形式は、Lispユーザーにはとてもなじみ深いものかもしれません。入れ子になった`Expr`を表示する例を示します。

```jldoctest ex3
julia> Meta.show_sexpr(ex3)
(:call, :/, (:call, :+, 4, 4), 2)
```

### Symbols

Juliaでは、`:`という文字に、構文上2つの用途があります。1つ目の形式は、有効な識別子から[`Symbol`](@ref)を作成します。これは[interned string](https://en.wikipedia.org/wiki/String_interning)であり、式の構成要素の1つとして使われます。

```jldoctest
julia> s = :foo
:foo

julia> typeof(s)
Symbol
```

[`Symbol`](@ref)コンストラクターは任意の個数の引数を受け取り、それらの文字列表現を連結して新しいシンボルを作成します。

```jldoctest
julia> :foo === Symbol("foo")
true

julia> Symbol("1foo") # `:1foo` would not work, as `1foo` is not a valid identifier
Symbol("1foo")

julia> Symbol("func",10)
:func10

julia> Symbol(:var,'_',"sym")
:var_sym
```

式の中では、シンボルは変数へのアクセスを示すために使われます。式を評価すると、シンボルは、適切な[scope](@ref scope-of-variables)でそのシンボルに束縛された値に置き換えられます。

構文解析の曖昧さを避けるため、`:`の引数を追加の括弧で囲む必要がある場合もあります。

```jldoctest
julia> :(:)
:(:)

julia> :(::)
:(::)
```

## Expressions and evaluation

### Quoting

`:`という文字の2つ目の構文上の用途は、[`Expr`](@ref)コンストラクターを明示的に使わずに式オブジェクトを作成することです。これを*クォート*と呼びます。`:`という文字に続けて、Juliaコードの単一の文を丸括弧で囲むと、そのコードに基づく`Expr`オブジェクトが生成されます。算術式をクォートする短い形式の例を示します。

```jldoctest
julia> ex = :(a+b*c+1)
:(a + b * c + 1)

julia> typeof(ex)
Expr
```

（この式の構造を見るには、`ex.head`と`ex.args`を試すか、上記のように[`dump`](@ref)、または[`Meta.@dump`](@ref)を使ってください。）

[`Meta.parse`](@ref)、または直接`Expr`形式を使って、同等の式を構築できることに注意してください。

```jldoctest
julia>      :(a + b*c + 1)       ==
       Meta.parse("a + b*c + 1") ==
       Expr(:call, :+, :a, Expr(:call, :*, :b, :c), 1)
true
```

パーサーが生成する式のargsは、通常、シンボル、ほかの式、およびリテラル値のみで構成されます。一方、Juliaコードで構築した式では、リテラル形式を持たない任意の実行時の値もargsに指定できます。この例では、`+`と`a`はシンボル、`*(b,c)`は部分式、`1`は64ビット符号付き整数のリテラルです。

複数の式をクォートするための2つ目の構文形式もあります。`quote ... end`で囲んだコードブロックです。

```jldoctest
julia> ex = quote
           x = 1
           y = 2
           x + y
       end
quote
    #= none:2 =#
    x = 1
    #= none:3 =#
    y = 2
    #= none:4 =#
    x + y
end

julia> typeof(ex)
Expr
```

### [Interpolation](@id man-expression-interpolation)

値を引数として[`Expr`](@ref)オブジェクトを直接構築する方法は強力ですが、`Expr`コンストラクターは「通常の」Julia構文と比べると煩雑になる場合があります。別の方法として、Juliaでは、クォートされた式にリテラルや式を*補間*できます。補間は、接頭辞`$`で示します。

この例では、変数`a`の値が補間されます。

```jldoctest interp1
julia> a = 1;

julia> ex = :($a + b)
:(1 + b)
```

クォートされていない式への補間はサポートされておらず、コンパイル時エラーになります。

```jldoctest interp1
julia> $a + b
ERROR: syntax: "$" expression outside quote
```

この例では、タプル`(1,2,3)`が式として条件判定に補間されます。

```jldoctest interp1
julia> ex = :(a in $:((1,2,3)) )
:(a in (1, 2, 3))
```

式の補間に`$`を使うのは、意図的に[string interpolation](@ref string-interpolation)や[command interpolation](@ref command-interpolation)を連想させるようにしたものです。式の補間を使うと、複雑なJuliaの式を、簡便で読みやすい形でプログラムから構築できます。

### Splatting interpolation

`$`という補間構文では、それを囲む式に単一の式しか挿入できないことに注意してください。式の配列があり、そのすべてを外側の式の引数にしたい場合もあります。これには、`$(xs...)`という構文を使えます。たとえば、次のコードは、引数の個数をプログラムで決定する関数呼び出しを生成します。

```jldoctest interp1
julia> args = [:x, :y, :z];

julia> :(f(1, $(args...)))
:(f(1, x, y, z))
```

### Nested quote

当然ながら、クォート式の中に別のクォート式を含めることもできます。この場合の補間の動作を理解するのは、少し難しいかもしれません。次の例を考えてみましょう。

```jldoctest interp1
julia> x = :(1 + 2);

julia> e = quote quote $x end end
quote
    #= none:1 =#
    $(Expr(:quote, quote
    #= none:1 =#
    $(Expr(:$, :x))
end))
end
```

結果に`$x`が含まれていることに注目してください。これは、`x`がまだ評価されていないことを意味します。つまり、`$`という式は内側のクォート式に「属して」おり、その引数は、内側のクォート式が評価されるときに初めて評価されます。

```jldoctest interp1
julia> eval(e)
quote
    #= none:1 =#
    1 + 2
end
```

ただし、外側の`quote`式から、内側のクォートにある`$`の内部に値を補間することもできます。これには、複数の`$`を使います。

```jldoctest interp1
julia> e = quote quote $$x end end
quote
    #= none:1 =#
    $(Expr(:quote, quote
    #= none:1 =#
    $(Expr(:$, :(1 + 2)))
end))
end
```

今度は、結果にシンボル`x`ではなく、`(1 + 2)`が現れることに注目してください。この式を評価すると、補間された`3`が得られます。

```jldoctest interp1
julia> eval(e)
quote
    #= none:1 =#
    3
end
```

この動作は、`$`が1つあるごとに、`x`が1回評価されると考えると理解しやすくなります。`$`が1つなら、`eval(:x)`と同様に動作し、`x`の値を返します。一方、`$`が2つなら、`eval(eval(:x))`に相当する処理を行います。

### [QuoteNode](@id man-quote-node)

ASTでは、`quote`形式は通常、headが`:quote`の[`Expr`](@ref)として表現されます。

```jldoctest interp1
julia> dump(Meta.parse(":(1+2)"))
Expr
  head: Symbol quote
  args: Array{Any}((1,))
    1: Expr
      head: Symbol call
      args: Array{Any}((3,))
        1: Symbol +
        2: Int64 1
        3: Int64 2
```

すでに見たように、このような式は`$`による補間をサポートします。しかし、状況によっては、補間を*行わずに*コードをクォートする必要があります。この種のクォートには、まだ専用の構文はありませんが、内部的には`QuoteNode`型のオブジェクトとして表現されます。

```jldoctest interp1
julia> eval(Meta.quot(Expr(:$, :(1+2))))
3

julia> eval(QuoteNode(Expr(:$, :(1+2))))
:($(Expr(:$, :(1 + 2))))
```

シンボルのような単純な要素をクォートした場合、パーサーは`QuoteNode`を生成します。

```jldoctest interp1
julia> dump(Meta.parse(":x"))
QuoteNode
  value: Symbol x
```

`QuoteNode`は、一部の高度なメタプログラミングにも使えます。

`$`をサポートしない一方で、それを防ぐわけでもなく、包み込んだオブジェクトの同一性を保持するわけでもない点に注意してください。

```jldoctest
julia> b = 2; eval(Expr(:quote, QuoteNode(Expr(:$, :b))))
:($(QuoteNode(2)))
```

### Evaluating expressions

式オブジェクトがあれば、[`eval`](@ref)を使って、Juliaにグローバルスコープで評価（実行）させることができます。

```jldoctest interp1
julia> ex1 = :(1 + 2)
:(1 + 2)

julia> eval(ex1)
3

julia> ex = :(a + b)
:(a + b)

julia> eval(ex)
ERROR: UndefVarError: `b` not defined in `Main`
[...]

julia> a = 1; b = 2;

julia> eval(ex)
3
```

各[module](@ref modules)は、そのグローバルスコープで式を評価する独自の[`eval`](@ref)関数を持ちます。[`eval`](@ref)に渡す式は、値を返すものに限りません。そのモジュールの環境の状態を変更する副作用を持つこともできます。

```jldoctest
julia> ex = :(x = 1)
:(x = 1)

julia> x
ERROR: UndefVarError: `x` not defined in `Main`

julia> eval(ex)
1

julia> x
1
```

ここでは、式オブジェクトを評価することで、グローバル変数`x`に値が代入されます。

式は、プログラムで構築して評価できる単なる`Expr`オブジェクトなので、任意のコードを動的に生成し、[`eval`](@ref)を使って実行できます。簡単な例を示します。

```jldoctest
julia> a = 1;

julia> ex = Expr(:call, :+, a, :b)
:(1 + b)

julia> a = 0; b = 2;

julia> eval(ex)
3
```

`a`の値を使って、式`ex`を構築しています。この式は、値1と変数`b`に`+`関数を適用します。`a`と`b`の使い方には、次の重要な違いがあります。

  * 式の構築時点での*変数*`a`の値が、式の中で即値として使われます。そのため、式の評価時に`a`がどのような値かは、もはや関係ありません。式の中の値はすでに`1`であり、`a`の値には左右されません。
  * 一方、式の構築には*シンボル*`:b`を使っているため、その時点での変数`b`の値は関係ありません。`:b`は単なるシンボルであり、変数`b`は定義されている必要さえありません。ただし、式の評価時には、変数`b`の値を検索することで、シンボル`:b`の値が解決されます。

### Functions on `Expr`essions

前述したように、Juliaの非常に便利な機能の1つは、Julia自体の中でJuliaコードを生成・操作できることです。[`Expr`](@ref)オブジェクトを返す関数の例は、すでに見てきました。Juliaコードの文字列を受け取り、対応する`Expr`を返す[`Meta.parse`](@ref)関数です。関数は、1つ以上の`Expr`オブジェクトを引数として受け取り、別の`Expr`を返すこともできます。用途を示す簡単な例を見てみましょう。

```jldoctest
julia> function math_expr(op, op1, op2)
           expr = Expr(:call, op, op1, op2)
           return expr
       end
math_expr (generic function with 1 method)

julia>  ex = math_expr(:+, 1, Expr(:call, :*, 4, 5))
:(1 + 4 * 5)

julia> eval(ex)
21
```

別の例として、数値の引数は2倍にし、式はそのままにする関数を示します。

```jldoctest
julia> function make_expr2(op, opr1, opr2)
           opr1f, opr2f = map(x -> isa(x, Number) ? 2*x : x, (opr1, opr2))
           retexpr = Expr(:call, op, opr1f, opr2f)
           return retexpr
       end
make_expr2 (generic function with 1 method)

julia> make_expr2(:+, 1, 2)
:(2 + 4)

julia> ex = make_expr2(:+, 1, Expr(:call, :*, 5, 8))
:(2 + 5 * 8)

julia> eval(ex)
42
```

## [Macros](@id man-macros)

マクロは、生成したコードをプログラムの最終的な本体に組み込む仕組みを提供します。マクロは引数のタプルを受け取り、*式*を返します。その式は直接コンパイルされるため、実行時に[`eval`](@ref)を呼び出す必要はありません。マクロの引数には、式、リテラル値、シンボルを含めることができます。

### Basics

非常に単純なマクロを示します。

```jldoctest sayhello
julia> macro sayhello()
           return :( println("Hello, world!") )
       end
@sayhello (macro with 1 method)
```

Juliaの構文には、マクロ専用の文字`@`（アットマーク）があります。その後ろに、`macro NAME ... end`ブロックで宣言した固有の名前を続けます。この例では、コンパイラーは`@sayhello`が現れるすべての箇所を、次のコードに置き換えます。

```julia
:( println("Hello, world!") )
```

REPLに`@sayhello`を入力すると、式は直ちに実行されるため、評価結果だけが表示されます。

```jldoctest sayhello
julia> @sayhello()
Hello, world!
```

次に、もう少し複雑なマクロを考えてみましょう。

```jldoctest sayhello2
julia> macro sayhello(name)
           return :( println("Hello, ", $name) )
       end
@sayhello (macro with 1 method)
```

このマクロは、`name`という1つの引数を受け取ります。`@sayhello`が現れると、クォートされた式が*展開*され、引数の値が最終的な式に補間されます。

```jldoctest sayhello2
julia> @sayhello("human")
Hello, human
```

[`macroexpand`](@ref)関数を使うと、返されるクォート式を見ることができます（**重要：**これは、マクロのデバッグに非常に便利なツールです）。

```julia-repl sayhello2
julia> ex = macroexpand(Main, :(@sayhello("human")) )
:(Main.println("Hello, ", "human"))

julia> typeof(ex)
Expr
```

`"human"`というリテラルが式に補間されていることがわかります。

`macroexpand`関数よりも多少便利な、[`@macroexpand`](@ref)というマクロもあります。

```jldoctest sayhello2
julia> @macroexpand @sayhello "human"
:(println("Hello, ", "human"))
```

### Hold up: why macros?

前の節では、すでに`f(::Expr...) -> Expr`という関数を見ました。実際、[`macroexpand`](@ref)もそのような関数です。それでは、なぜマクロが必要なのでしょうか？

マクロが必要なのは、コードの構文解析時に実行されるからです。これにより、プログラマーは、プログラム全体が実行される*前に*、用途に合わせたコード片を生成して組み込めます。この違いを示すため、次の例を考えてみましょう。

```julia-repl whymacros
julia> macro twostep(arg)
           println("I execute at parse time. The argument is: ", arg)
           return :(println("I execute at runtime. The argument is: ", $arg))
       end
@twostep (macro with 1 method)

julia> ex = macroexpand(Main, :(@twostep :(1, 2, 3)) );
I execute at parse time. The argument is: :((1, 2, 3))
```

最初の[`println`](@ref)の呼び出しは、[`macroexpand`](@ref)が呼び出されるときに実行されます。結果の式には、2つ目の`println`*だけ*が含まれます。

```julia-repl whymacros
julia> typeof(ex)
Expr

julia> ex
:(println("I execute at runtime. The argument is: ", $(Expr(:copyast, :($(QuoteNode(:((1, 2, 3)))))))))

julia> eval(ex)
I execute at runtime. The argument is: (1, 2, 3)
```

### Macro invocation

マクロは、一般に次の構文で呼び出します。

```julia
@name expr1 expr2 ...
@name(expr1, expr2, ...)
```

1つ目の形式では、マクロ名の前に識別用の`@`があり、引数の式の間にカンマがないことに注意してください。また、2つ目の形式では、`@name`の後に空白を入れません。この2つの書き方を混在させてはいけません。たとえば、次の構文は上の例とは異なり、タプル`(expr1, expr2, ...)`を1つの引数としてマクロに渡します。

```julia
@name (expr1, expr2, ...)
```

配列リテラル（または内包表記）に対してマクロを呼び出す別の方法は、括弧を使わずに両者を隣接させることです。この場合、配列だけが式としてマクロに渡されます。次の構文は互いに同等です（ただし、`@name [a b] * v`とは異なります）。

```julia
@name[a b] * v
@name([a b]) * v
```

マクロが引数を式、リテラル、またはシンボルとして受け取ることは、強調しておくべき重要な点です。マクロの引数を調べる方法の1つは、マクロ本体の中で[`show`](@ref)関数を呼び出すことです。

```jldoctest
julia> macro showarg(x)
           show(x)
           # ... remainder of macro, returning an expression
       end
@showarg (macro with 1 method)

julia> @showarg(a)
:a

julia> @showarg(1+1)
:(1 + 1)

julia> @showarg(println("Yo!"))
:(println("Yo!"))

julia> @showarg(1)        # Numeric literal
1

julia> @showarg("Yo!")    # String literal
"Yo!"

julia> @showarg("Yo! $("hello")")    # String with interpolation is an Expr rather than a String
:("Yo! $("hello")")
```

指定された引数リストに加えて、すべてのマクロには`__source__`と`__module__`という名前の追加の引数が渡されます。

引数`__source__`は、マクロ呼び出しの`@`記号の、パーサー上の位置情報を`LineNumberNode`オブジェクトとして提供します。これにより、マクロはより詳しいエラー診断情報を含めることができます。この機能は、たとえばログ、文字列解析マクロ、ドキュメントでよく使われるほか、[`@__LINE__`](@ref)、[`@__FILE__`](@ref)、[`@__DIR__`](@ref)マクロの実装にも使われています。

位置情報には、`__source__.line`と`__source__.file`を参照することでアクセスできます。

```jldoctest
julia> macro __LOCATION__(); return QuoteNode(__source__); end
@__LOCATION__ (macro with 1 method)

julia> dump(
            @__LOCATION__(
       ))
LineNumberNode
  line: Int64 2
  file: Symbol none
```

引数`__module__`は、マクロ呼び出しの展開コンテキストに関する情報を、`Module`オブジェクトとして提供します。これにより、マクロは既存の束縛などのコンテキスト情報を検索したり、現在のモジュールをリフレクションする実行時の関数呼び出しに、その値を追加の引数として挿入したりできます。

### Building an advanced macro

Juliaの[`@assert`](@ref)マクロを簡略化した定義を示します。

```jldoctest building
julia> macro assert(ex)
           return :( $ex ? nothing : throw(AssertionError($(string(ex)))) )
       end
@assert (macro with 1 method)
```

このマクロは、次のように使えます。

```jldoctest building
julia> @assert 1 == 1.0

julia> @assert 1 == 0
ERROR: AssertionError: 1 == 0
```

記述されたマクロ呼び出しの構文は、構文解析時に、マクロが返した結果へと展開されます。これは、次のように書くのと同等です。

```julia
1 == 1.0 ? nothing : throw(AssertionError("1 == 1.0"))
1 == 0 ? nothing : throw(AssertionError("1 == 0"))
```

つまり、最初の呼び出しでは、式`:(1 == 1.0)`がテスト条件の位置に挿入され、`string(:(1 == 1.0))`の値がアサーションメッセージの位置に挿入されます。このように構築された式全体が、`@assert`マクロ呼び出しのある構文木の位置に配置されます。そして実行時には、テスト式の評価結果が真なら[`nothing`](@ref)が返され、偽なら、偽となったアサーションの式を示すエラーが発生します。これを関数として書くことはできない点に注目してください。関数では条件の*値*しか得られないため、エラーメッセージに、その値を計算した式を表示することはできません。

Julia Baseにおける`@assert`の実際の定義は、もっと複雑です。失敗した式を表示するだけでなく、ユーザーが独自のエラーメッセージを任意に指定できるようになっています。引数の個数が可変の関数（[Varargs Functions](@ref)）と同じように、最後の引数の後ろに省略記号を付けて指定します。

```julia-repl assert2
julia> macro assert(ex, msgs...)
           msg_body = isempty(msgs) ? ex : msgs[1]
           msg = string(msg_body)
           return :($ex ? nothing : throw(AssertionError($msg)))
       end
@assert (macro with 1 method)
```

これで`@assert`は、受け取る引数の個数に応じて2通りの動作をするようになりました。引数が1つだけなら、`msgs`が取り込む式のタプルは空になり、上の単純な定義と同じように動作します。一方、ユーザーが2つ目の引数を指定すると、失敗した式の代わりに、その引数がメッセージ本文に表示されます。マクロ展開の結果は、その名のとおりの[`@macroexpand`](@ref)マクロで確認できます。

```julia-repl assert2
julia> @macroexpand @assert a == b
:(if Main.a == Main.b
        Main.nothing
    else
        Main.throw(Main.AssertionError("a == b"))
    end)

julia> @macroexpand @assert a==b "a should equal b!"
:(if Main.a == Main.b
        Main.nothing
    else
        Main.throw(Main.AssertionError("a should equal b!"))
    end)
```

実際の`@assert`マクロは、さらに別の場合も扱います。「aとbは等しくなければならない」と表示するだけでなく、それらの値も表示したい場合はどうでしょうか？ 単純に考えると、独自のメッセージ内で、たとえば`@assert a==b "a ($a) should equal b ($b)!"`のように文字列補間を使いたくなるかもしれません。しかし、上のマクロでは期待どおりに動作しません。なぜかわかるでしょうか？ [string interpolation](@ref string-interpolation)で説明したように、補間を含む文字列は[`string`](@ref)の呼び出しに書き換えられます。次を比較してください。

```jldoctest
julia> typeof(:("a should equal b"))
String

julia> typeof(:("a ($a) should equal b ($b)!"))
Expr

julia> dump(:("a ($a) should equal b ($b)!"))
Expr
  head: Symbol string
  args: Array{Any}((5,))
    1: String "a ("
    2: Symbol a
    3: String ") should equal b ("
    4: Symbol b
    5: String ")!"
```

したがって、マクロは`msg_body`として単なる文字列を受け取るのではなく、期待どおりに表示するために評価が必要な式全体を受け取ります。この式は、返す式の中に[`string`](@ref)呼び出しの引数として直接挿入できます。完全な実装については、[`error.jl`](https://github.com/JuliaLang/julia/blob/master/base/error.jl)を参照してください。

`@assert`マクロは、クォートされた式への挿入を巧みに活用して、マクロ本体での式の操作を簡単にしています。

### Hygiene

より複雑なマクロで生じる問題の1つが、[hygiene](https://en.wikipedia.org/wiki/Hygienic_macro)です。簡単に言えば、マクロは、返す式に導入した変数が、展開先の周囲のコードにある既存の変数と誤って衝突しないようにする必要があります。逆に、引数としてマクロに渡される式は、周囲のコードのコンテキストで評価され、既存の変数を参照・変更することが*期待される*場合がよくあります。また、マクロが定義されたモジュールとは異なるモジュールから呼び出される可能性も問題になります。この場合、すべてのグローバル変数が正しいモジュールで解決されるようにする必要があります。Juliaは、返される式だけを考慮すればよいという点で、Cのようなテキストベースのマクロ展開を行う言語に対し、すでに大きな利点を持っています。それ以外の変数（上の`@assert`における`msg`など）は、[normal scoping block behavior](@ref scope-of-variables)に従います。

これらの問題を示すために、`@time`マクロを書くことを考えてみましょう。このマクロは、式を引数として受け取り、時刻を記録し、式を評価し、再び時刻を記録して、前後の時刻の差を表示し、最後に式の値を自身の値とします。次のようなマクロになるでしょう。

```julia
macro time(ex)
    return quote
        local t0 = time_ns()
        local val = $ex
        local t1 = time_ns()
        println("elapsed time: ", (t1-t0)/1e9, " seconds")
        val
    end
end
```

ここでは、`t0`、`t1`、`val`を非公開の一時変数にしたいと考えています。また、`time_ns`には、ユーザーが持っているかもしれない`time_ns`という変数ではなく、Julia Baseの[`time_ns`](@ref)関数を参照させたいと考えています（`println`も同様です）。ユーザーの式`ex`にも、`t0`という変数への代入が含まれていたり、独自の`time_ns`という変数が定義されていたりしたら、どのような問題が起こるか想像してください。エラーが発生したり、不可解な誤動作が生じたりするかもしれません。

Juliaのマクロ展開器は、次の方法でこれらの問題を解決します。まず、マクロの結果に含まれる変数を、ローカルまたはグローバルに分類します。代入先になっていて（かつglobalと宣言されていない）変数、localと宣言された変数、または関数の引数名として使われる変数は、ローカルと見なされます。それ以外はグローバルと見なされます。その後、ローカル変数は、新しいシンボルを生成する[`gensym`](@ref)関数を使って一意な名前に変更され、グローバル変数はマクロの定義環境で解決されます。これによって、上の2つの懸念はどちらも解消されます。マクロのローカル変数はユーザーの変数と衝突せず、`time_ns`と`println`はJulia Baseの定義を参照します。

しかし、まだ1つ問題が残っています。このマクロを次のように使う場合を考えてみましょう。

```julia
module MyModule
import Base.@time

time_ns() = ... # compute something

@time time_ns()
end
```

ここでは、ユーザーの式`ex`は`time_ns`の呼び出しですが、マクロが使う`time_ns`関数とは別物です。これは明らかに`MyModule.time_ns`を参照しています。そのため、`ex`内のコードが、マクロの呼び出し環境で解決されるようにする必要があります。これには、[`esc`](@ref)で式を「エスケープ」します。

```julia
macro time(ex)
    ...
    local val = $(esc(ex))
    ...
end
```

このように包まれた式は、マクロ展開器によって変更されず、そのまま出力に貼り付けられます。そのため、マクロの呼び出し環境で解決されます。

このエスケープの仕組みは、必要に応じてハイジーンを「破り」、ユーザーの変数を導入・操作するためにも使えます。たとえば、次のマクロは、呼び出し環境で`x`をゼロに設定します。

```jldoctest
julia> macro zerox()
           return esc(:(x = 0))
       end
@zerox (macro with 1 method)

julia> function foo()
           x = 1
           @zerox
           return x # is zero
       end
foo (generic function with 1 method)

julia> foo()
0
```

この種の変数操作は慎重に使うべきですが、場合によっては非常に便利です。

ハイジーンの規則を正しく扱うのは、かなり難しい場合があります。マクロを使う前に、関数クロージャーで十分ではないか検討するとよいでしょう。また、できるだけ多くの処理を実行時に回すのも、有効な方策です。たとえば、多くのマクロは、単に引数を`QuoteNode`や、それに類する[`Expr`](@ref)で包むだけです。その例として、単に`schedule(Task(() -> $body))`を返す`@task body`や、単に`eval(QuoteNode(expr))`を返す`@eval expr`があります。

例として、上の`@time`の例は、次のように書き換えることもできます。

```julia
macro time(expr)
    return :(timeit(() -> $(esc(expr))))
end
function timeit(f)
    t0 = time_ns()
    val = f()
    t1 = time_ns()
    println("elapsed time: ", (t1-t0)/1e9, " seconds")
    return val
end
```

ただし、実際にこうしないのには理由があります。`expr`を新しいスコープブロック（無名関数）で包むと、式の意味（その中の変数のスコープ）もわずかに変わってしまいます。一方、`@time`は、包まれるコードへの影響を最小限にして使えるようにしたいのです。

### Macros and dispatch

マクロもJuliaの関数と同じく、ジェネリックです。つまり、多重ディスパッチによって、複数のメソッド定義を持つこともできます。

```jldoctest macromethods
julia> macro m end
@m (macro with 0 methods)

julia> macro m(args...)
           println("$(length(args)) arguments")
       end
@m (macro with 1 method)

julia> macro m(x,y)
           println("Two arguments")
       end
@m (macro with 2 methods)

julia> @m "asd"
1 arguments

julia> @m 1 2
Two arguments
```

ただし、マクロのディスパッチは、マクロに渡されたASTの型に基づくのであって、ASTを実行時に評価して得られる値の型に基づくのではないことに注意してください。

```jldoctest macromethods
julia> macro m(::Int)
           println("An Integer")
       end
@m (macro with 3 methods)

julia> @m 2
An Integer

julia> x = 2
2

julia> @m x
1 arguments
```

## Code Generation

繰り返しの多い定型コードが大量に必要な場合、冗長さを避けるために、プログラムでコードを生成するのが一般的です。ほとんどの言語では、そのために追加のビルド手順と、反復的なコードを生成するための別のプログラムが必要になります。Juliaでは、式の補間と[`eval`](@ref)によって、通常のプログラム実行の中で、そのようなコード生成を行えます。たとえば、次の独自の型を考えてみましょう。

```jldoctest mynumber-codegen
struct MyNumber
    x::Float64
end
# output

```

この型に、いくつかのメソッドを追加したいとします。次のループで、プログラムから追加できます。

```jldoctest mynumber-codegen
for op = (:sin, :cos, :tan, :log, :exp)
    eval(quote
        Base.$op(a::MyNumber) = MyNumber($op(a.x))
    end)
end
# output

```

これで、独自の型に対して、それらの関数を使えるようになりました。

```jldoctest mynumber-codegen
julia> x = MyNumber(π)
MyNumber(3.141592653589793)

julia> sin(x)
MyNumber(1.2246467991473532e-16)

julia> cos(x)
MyNumber(-1.0)
```

このように、Juliaは自身の[preprocessor](https://en.wikipedia.org/wiki/Preprocessor)として動作し、言語内からのコード生成を可能にします。上のコードは、`:`を前置するクォート形式を使って、もう少し簡潔に書けます。

```julia
for op = (:sin, :cos, :tan, :log, :exp)
    eval(:(Base.$op(a::MyNumber) = MyNumber($op(a.x))))
end
```

ただし、`eval(quote(...))`というパターンを使った、この種の言語内コード生成は十分に一般的なので、Juliaには、このパターンを短く書くためのマクロが用意されています。

```julia
for op = (:sin, :cos, :tan, :log, :exp)
    @eval Base.$op(a::MyNumber) = MyNumber($op(a.x))
end
```

[`@eval`](@ref)マクロは、この呼び出しを、上の長い形式とまったく同等になるように書き換えます。生成するコードが長いブロックになる場合は、[`@eval`](@ref)に渡す式の引数をブロックにできます。

```julia
@eval begin
    # multiple lines
end
```

## [Non-Standard String Literals](@id meta-non-standard-string-literals)

[Strings](@ref non-standard-string-literals)で説明したように、識別子を前置した文字列リテラルは非標準文字列リテラルと呼ばれ、接頭辞のない文字列リテラルとは異なる意味を持つことがあります。たとえば、次のようなものです。

  * `r"^\s*(?:#|$)"`は、文字列ではなく[regular expression object](@ref man-regex-literals)を生成します。
  * `b"DATA\xff\u2200"`は、`[68,65,84,65,255,226,136,128]`用の[byte array literal](@ref man-byte-array-literals)です。

意外かもしれませんが、これらの動作は、Juliaのパーサーやコンパイラーにハードコードされているわけではありません。代わりに、誰でも使える汎用の仕組みによって提供される独自の動作です。接頭辞付きの文字列リテラルは、特別な名前を持つマクロへの呼び出しとして構文解析されます。たとえば、正規表現のマクロは、次のものにすぎません。

```julia
macro r_str(p)
    Regex(p)
end
```

これだけです。このマクロは、文字列リテラル`r"^\s*(?:#|$)"`のリテラルとしての内容を`@r_str`マクロに渡し、その展開結果を、文字列リテラルが現れる構文木の位置に置くよう指定しています。つまり、式`r"^\s*(?:#|$)"`は、次のオブジェクトを構文木に直接配置するのと同等です。

```julia
Regex("^\\s*(?:#|\$)")
```

文字列リテラル形式は、短くてはるかに便利なだけでなく、効率もよくなります。正規表現のコンパイルと`Regex`オブジェクトの実際の作成が、*コードのコンパイル時*に行われるため、コードの実行ごとではなく、一度だけコンパイルされるからです。正規表現がループ内にある場合を考えてみましょう。

```julia
for line = lines
    m = match(r"^\s*(?:#|$)", line)
    if m === nothing
        # non-comment
    else
        # comment
    end
end
```

このコードの構文解析時に、正規表現`r"^\s*(?:#|$)"`がコンパイルされて構文木に挿入されるため、ループの実行ごとではなく、一度だけコンパイルされます。マクロを使わずにこれを実現するには、ループを次のように書く必要があります。

```julia
re = Regex("^\\s*(?:#|\$)")
for line = lines
    m = match(re, line)
    if m === nothing
        # non-comment
    else
        # comment
    end
end
```

さらに、正規表現オブジェクトがすべての反復を通じて一定であるとコンパイラーが判断できなければ、一部の最適化ができず、この形式は、上の便利なリテラル形式よりも効率が悪くなる可能性があります。もちろん、非リテラル形式のほうが便利な状況もあります。正規表現に変数を補間する必要がある場合は、この長い書き方を使わなければなりません。また、正規表現のパターン自体が動的で、ループの反復ごとに変わり得る場合は、反復ごとに新しい正規表現オブジェクトを構築する必要があります。ただし、圧倒的多数の用途では、正規表現は実行時のデータに基づいて構築されるものではありません。そのような大多数の場合に、正規表現をコンパイル時の値として記述できることは、非常に有用です。

ユーザー定義の文字列リテラルの仕組みは、きわめて強力です。Juliaの非標準リテラルだけでなく、コマンドリテラル構文（``` `echo "Hello, $person"` ```）も、次の一見何気ないマクロを使って実装されています。

```julia
macro cmd(str)
    :(cmd_gen($(shell_parse(str)[1])))
end
```

もちろん、このマクロ定義で使われる関数の内部には、多くの複雑な処理が隠されています。しかし、それらも、すべてJuliaで書かれた単なる関数です。ソースを読めば、何をしているのかを正確に確認できます。そして、その処理はすべて、プログラムの構文木に挿入する式オブジェクトを構築するものです。

文字列リテラルと同じように、コマンドリテラルにも識別子を前置して、非標準コマンドリテラルと呼ばれるものを作れます。これらのコマンドリテラルは、特別な名前を持つマクロへの呼び出しとして構文解析されます。たとえば、```custom`literal` ```という構文は、`@custom_cmd "literal"`として解析されます。Julia自体には非標準コマンドリテラルは含まれていませんが、パッケージでこの構文を利用できます。構文が異なることと、接尾辞が`_str`ではなく`_cmd`になることを除けば、非標準コマンドリテラルは非標準文字列リテラルとまったく同じように動作します。

2つのモジュールが同じ名前の非標準文字列リテラルまたは非標準コマンドリテラルを提供する場合、文字列リテラルやコマンドリテラルをモジュール名で修飾できます。たとえば、`Foo`と`Bar`の両方が非標準文字列リテラル`@x_str`を提供しているなら、`Foo.x"literal"`または`Bar.x"literal"`と書くことで、両者を区別できます。

マクロを定義する別の方法として、次のようなものもあります。

```julia
macro foo_str(str, flag)
    # do stuff
end
```

このマクロは、次の構文で呼び出せます。

```julia
foo"str"flag
```

上の構文でのflagの型は`String`となり、その内容は、文字列リテラルの後ろに続く部分です。

## Generated functions

[`@generated`](@ref)は、いわゆる*生成関数*を定義できる、非常に特殊なマクロです。生成関数は、引数の型に応じて特化したコードを生成できます。これにより、多重ディスパッチだけで実現する場合よりも柔軟に、あるいは少ないコードで処理を記述できます。マクロは構文解析時に式を扱い、入力の型にはアクセスできません。一方、生成関数は、引数の型が判明していて、かつ関数がまだコンパイルされていない段階で展開されます。

生成関数の宣言では、何らかの計算や動作を行う代わりに、クォートされた式を返します。その式が、引数の型に対応するメソッドの本体になります。生成関数が呼び出されると、返された式がコンパイルされ、その後に実行されます。効率を上げるため、通常、その結果はキャッシュされます。また、型推論を可能にするため、言語機能の限られた一部しか使えません。このように生成関数は、使用可能な構文への制約が増える代わりに、処理を実行時からコンパイル時へ移す柔軟な手段を提供します。

生成関数の定義には、通常の関数との間に、主に次の5つの違いがあります。

1. 関数宣言に`@generated`マクロで注釈を付けます。これにより、生成関数であることをコンパイラーに知らせる情報がASTに追加されます。
2. 生成関数の本体では、引数の*型*にしかアクセスできず、値にはアクセスできません。
3. 何かを計算したり動作を実行したりする代わりに、評価したときに目的の処理を行う*クォートされた式*を返します。
4. 生成関数から呼び出せるのは、その生成関数の定義*より前に*定義された関数だけです。（これを守らないと、未来のworld-ageの関数を参照したことによる`MethodErrors`が発生する場合があります。）
5. 生成関数は、定数でないグローバル状態を*変更*したり*観測*したりしてはいけません（たとえば、IO、ロック、非ローカルな辞書、[`hasmethod`](@ref)の使用などが含まれます）。つまり、読み取れるのはグローバル定数だけであり、副作用を持つことはできません。言い換えると、完全に純粋でなければなりません。実装上の制限により、現時点ではクロージャーやジェネレーターも定義できません。

例で示すのが最もわかりやすいでしょう。生成関数`foo`を、次のように宣言できます。

```jldoctest generated
julia> @generated function foo(x)
           Core.println(x)
           return :(x * x)
       end
foo (generic function with 1 method)
```

本体が、`x * x`の値そのものではなく、クォートされた式、すなわち`:(x * x)`を返していることに注意してください。

呼び出し側から見ると、これは通常の関数と同じです。実際、呼び出しているのが通常の関数なのか生成関数なのかを知る必要はありません。`foo`の動作を見てみましょう。

```jldoctest generated
julia> x = foo(2); # note: output is from println() statement in the body
Int64

julia> x           # now we print x
4

julia> y = foo("bar");
String

julia> y
"barbar"
```

生成関数の本体では、`x`が渡された引数の*型*であることがわかります。また、生成関数の呼び出しが返す値は、定義から返したクォート式を、今度は`x`の*値*を使って評価した結果です。

すでに使った型でもう一度`foo`を評価すると、どうなるでしょうか？

```jldoctest generated
julia> foo(4)
16
```

[`Int64`](@ref)が表示されないことに注目してください。ここでは、特定の引数の型の組み合わせに対して、生成関数の本体が一度だけ実行され、結果がキャッシュされたことがわかります。その後、この例では、最初の呼び出しで生成関数が返した式が、メソッド本体として再利用されました。ただし、実際のキャッシュ動作は実装依存の性能最適化なので、この動作に強く依存するのは不適切です。

生成関数のコードが生成される回数は、一度だけ*かもしれません*が、もっと多い*かもしれません*し、一度も生成されていないように見える場合もあります。したがって、副作用を持つ生成関数は*決して*書いてはいけません。副作用がいつ、どのくらいの頻度で発生するかは未定義です。（これはマクロにも当てはまります。また、マクロと同様に、生成関数で[`eval`](@ref)を使っているなら、やり方が適切でない兆候です。）ただし、マクロとは異なり、ランタイムシステムは[`eval`](@ref)への呼び出しを正しく処理できないため、その呼び出しは禁止されています。

`@generated`関数とメソッドの再定義との関係も、理解しておくことが重要です。正しい`@generated`関数は、変更可能な状態を観測したり、グローバル状態を変更したりしてはいけないという原則から、次の動作になります。生成関数は、その生成関数自体の*定義*より前に定義されていないメソッドを呼び出すことが*できない*点に注目してください。

最初、`f(x)`には1つの定義があります。

```jldoctest redefinition
julia> f(x) = "original definition";
```

`f(x)`を使う、ほかの処理を定義します。

```jldoctest redefinition
julia> g(x) = f(x);

julia> @generated gen1(x) = f(x);

julia> @generated gen2(x) = :(f(x));
```

次に、`f(x)`に新しい定義をいくつか追加します。

```jldoctest redefinition
julia> f(x::Int) = "definition for Int";

julia> f(x::Type{Int}) = "definition for Type{Int}";
```

そして、結果がどう異なるかを比較します。

```jldoctest redefinition
julia> f(1)
"definition for Int"

julia> g(1)
"definition for Int"

julia> gen1(1)
"original definition"

julia> gen2(1)
"definition for Int"
```

生成関数の各メソッドから見える関数定義は、それぞれ異なります。

```jldoctest redefinition
julia> @generated gen1(x::Real) = f(x);

julia> gen1(1)
"definition for Type{Int}"
```

上の生成関数の例`foo`は、通常の関数`foo(x) = x * x`ではできないことを何もしていませんでした（最初の呼び出しで型を表示することと、より大きなオーバーヘッドが生じることを除きます）。しかし、生成関数の強みは、渡された型に応じて異なるクォート式を計算できる点にあります。

```jldoctest
julia> @generated function bar(x)
           if x <: Integer
               return :(x ^ 2)
           else
               return :(x)
           end
       end
bar (generic function with 1 method)

julia> bar(4)
16

julia> bar("baz")
"baz"
```

（もちろん、この作為的な例は、多重ディスパッチを使うほうが簡単に実装できますが……。）

この仕組みを誤用すると、ランタイムシステムを破損させ、未定義の動作を引き起こします。

```jldoctest
julia> @generated function baz(x)
           if rand() < .9
               return :(x^2)
           else
               return :("boo!")
           end
       end
baz (generic function with 1 method)
```

生成関数の本体が非決定的なので、その動作も、*それ以降のすべてのコードの動作も*未定義です。

*これらの例をコピーしないでください！*

これらの例は、定義側と呼び出し側の両方で生成関数がどう動作するかを理解する助けになるはずです。ただし、次の理由から、*コピーしないでください*。

  * `foo`関数には副作用（`Core.println`への呼び出し）があり、その副作用が正確にいつ、どのくらいの頻度で、何回発生するかは未定義です。
  * `bar`関数が解決している問題は、多重ディスパッチを使うほうが適切です。`bar(x) = x`と`bar(x::Integer) = x ^ 2`を定義すれば、同じことを、より簡単かつ高速に実現できます。
  * `baz`関数は、問題を引き起こす極端な例です。

生成関数内で試みるべきでない操作は際限なくあり、現在のランタイムシステムが検出できるのは、不正な操作の一部だけであることに注意してください。それ以外にも、何の通知もなくランタイムシステムを破損させる操作が多数あります。しかも、通常は、不適切な定義との関係がすぐにはわからない微妙な形で問題が現れます。関数ジェネレーターは型推論中に実行されるため、そのコードに課されるすべての制約を守らなければなりません。

試みるべきでない操作には、次のようなものがあります。

1. ネイティブポインターのキャッシュ。
2. `Core.Compiler`の内容やメソッドへの、あらゆる形での関与。
3. 変更可能な状態の観測。

      * 生成関数の型推論は、コードがその状態を観測・変更しようとしている最中も含め、*いつでも*実行される可能性があります。
4. ロックの取得。呼び出し先のCコードが内部でロックを使うことはあります（たとえば、`malloc`は、ほとんどの実装で内部的にロックを必要としますが、呼び出しても問題ありません）。ただし、Juliaコードの実行中にロックを保持したり取得したりしようとしてはいけません。
5. 生成関数の本体より後に定義された関数の呼び出し。この条件は、逐次読み込まれるプリコンパイル済みモジュールでは緩和され、モジュール内の任意の関数を呼び出せます。

さて、生成関数の仕組みへの理解が深まったところで、もっと高度な（そして正当な）機能を作ってみましょう。

### An advanced example

Juliaの標準ライブラリには、n個の多次元添字から、n次元配列の線形インデックスを計算する内部関数`sub2ind`があります。言い換えると、配列`A`に対し、`A[x,y,z,...]`の代わりに`A[i]`を使ってアクセスするためのインデックス`i`を計算します。実装の一例は次のとおりです。

```jldoctest sub2ind
julia> function sub2ind_loop(dims::NTuple{N}, I::Integer...) where N
           ind = I[N] - 1
           for i = N-1:-1:1
               ind = I[i]-1 + dims[i]*ind
           end
           return ind + 1
       end;

julia> sub2ind_loop((3, 5), 1, 2)
4
```

同じことは、再帰を使っても実現できます。

```jldoctest
julia> sub2ind_rec(dims::Tuple{}) = 1;

julia> sub2ind_rec(dims::Tuple{}, i1::Integer, I::Integer...) =
           i1 == 1 ? sub2ind_rec(dims, I...) : throw(BoundsError());

julia> sub2ind_rec(dims::Tuple{Integer, Vararg{Integer}}, i1::Integer) = i1;

julia> sub2ind_rec(dims::Tuple{Integer, Vararg{Integer}}, i1::Integer, I::Integer...) =
           i1 + dims[1] * (sub2ind_rec(Base.tail(dims), I...) - 1);

julia> sub2ind_rec((3, 5), 1, 2)
4
```

この2つの実装は、書き方こそ異なりますが、本質的には同じことをしています。実行時に配列の各次元をループし、それぞれの次元のオフセットを最終的なインデックスにまとめています。

しかし、このループに必要な情報はすべて、引数の型情報に埋め込まれています。そのため、コンパイラーは反復処理をコンパイル時に移し、実行時のループを完全に取り除くことができます。生成関数を使って、同様の効果を得ることもできます。コンパイラーの用語で言えば、生成関数を使って手動でループを展開します。本体はほぼ同じですが、線形インデックスを計算する代わりに、そのインデックスを計算する*式*を組み立てます。

```jldoctest sub2ind_gen
julia> @generated function sub2ind_gen(dims::NTuple{N}, I::Integer...) where N
           ex = :(I[$N] - 1)
           for i = (N - 1):-1:1
               ex = :(I[$i] - 1 + dims[$i] * $ex)
           end
           return :($ex + 1)
       end;

julia> sub2ind_gen((3, 5), 1, 2)
4
```

**どのようなコードが生成されるのでしょうか？**

簡単に確認するには、本体を別の（通常の）関数に切り出します。

```jldoctest sub2ind_gen2
julia> function sub2ind_gen_impl(dims::Type{T}, I...) where T <: NTuple{N,Any} where N
           length(I) == N || return :(error("partial indexing is unsupported"))
           ex = :(I[$N] - 1)
           for i = (N - 1):-1:1
               ex = :(I[$i] - 1 + dims[$i] * $ex)
           end
           return :($ex + 1)
       end;

julia> @generated function sub2ind_gen(dims::NTuple{N}, I::Integer...) where N
           return sub2ind_gen_impl(dims, I...)
       end;

julia> sub2ind_gen((3, 5), 1, 2)
4
```

これで、`sub2ind_gen_impl`を実行し、返される式を調べられます。

```jldoctest sub2ind_gen2
julia> sub2ind_gen_impl(Tuple{Int,Int}, Int, Int)
:(((I[1] - 1) + dims[1] * (I[2] - 1)) + 1)
```

ここで使われるメソッド本体には、ループがまったくありません。あるのは、2つのタプルへの添字アクセス、乗算、加算と減算だけです。ループ処理はすべてコンパイル時に行われるため、実行時のループを完全に避けられます。したがって、ループは*型ごとに一度だけ*、この場合は`N`ごとに一度だけ実行されます（関数が複数回生成される例外的な場合を除きます。上の注意事項を参照してください）。

### Optionally-generated functions

生成関数は、実行時に高い効率を実現できますが、コンパイル時のコストが伴います。引数の具体的な型の組み合わせごとに、新しい関数本体を生成しなければなりません。通常、Juliaは任意の引数で動作する「汎用的な」関数をコンパイルできますが、生成関数ではそれができません。つまり、生成関数を多用するプログラムは、静的にコンパイルできない可能性があります。

この問題を解決するため、Juliaには、生成関数の代替として、通常の非生成の実装を記述する構文が用意されています。上の`sub2ind`の例に適用すると、次のようになります。

```jldoctest sub2ind_gen_opt
julia> function sub2ind_gen_impl(dims::Type{T}, I...) where T <: NTuple{N,Any} where N
           ex = :(I[$N] - 1)
           for i = (N - 1):-1:1
               ex = :(I[$i] - 1 + dims[$i] * $ex)
           end
           return :($ex + 1)
       end;

julia> function sub2ind_gen_fallback(dims::NTuple{N}, I) where N
           ind = I[N] - 1
           for i = (N - 1):-1:1
               ind = I[i] - 1 + dims[i]*ind
           end
           return ind + 1
       end;

julia> function sub2ind_gen(dims::NTuple{N}, I::Integer...) where N
           length(I) == N || error("partial indexing is unsupported")
           if @generated
               return sub2ind_gen_impl(dims, I...)
           else
               return sub2ind_gen_fallback(dims, I)
           end
       end;

julia> sub2ind_gen((3, 5), 1, 2)
4
```

内部的には、このコードは2つの関数実装を作成します。1つは`if @generated`の最初のブロックを使う生成版、もう1つは`else`ブロックを使う通常版です。`if @generated`ブロックの`then`側では、コードの意味はほかの生成関数と同じです。引数名は型を参照し、コードは式を返す必要があります。`if @generated`ブロックは複数記述できます。その場合、生成版の実装はすべての`then`ブロックを使い、代替実装はすべての`else`ブロックを使います。

関数の先頭にエラーチェックを追加したことに注目してください。このコードは両方の実装に共通し、どちらでも実行時のコードになります（生成版では、クォートされ、式として返されます）。つまり、コード生成時にはローカル変数の値も型も利用できません。コードを生成する側から見えるのは、引数の型だけです。

この形式の定義では、コード生成機能は本質的に、任意に利用される最適化です。コンパイラーは都合がよければそれを使いますが、そうでなければ通常の実装を選ぶこともあります。この形式が推奨されるのは、コンパイラーにより多くの判断を委ね、より多様な方法でプログラムをコンパイルできるうえ、通常のコードのほうがコード生成用のコードより読みやすいからです。ただし、どちらの実装が使われるかはコンパイラーの実装詳細に依存するため、両方の実装が同じ動作をすることが不可欠です。
