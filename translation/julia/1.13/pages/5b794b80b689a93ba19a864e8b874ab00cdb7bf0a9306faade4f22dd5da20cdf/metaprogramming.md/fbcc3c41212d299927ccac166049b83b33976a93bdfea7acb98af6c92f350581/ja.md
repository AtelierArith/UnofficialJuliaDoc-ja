# Metaprogramming

Julia言語におけるLispの最も大きな遺産は、メタプログラミングのサポートです。Lispと同様に、Juliaは自身のコードを言語自体のデータ構造で表現します。コードが言語内で作成・操作できるオブジェクトとして表現されるため、プログラムが自分自身のコードを変換・生成できます。これにより、追加のビルド手順なしに高度なコード生成が可能になり、[abstract syntax trees](https://en.wikipedia.org/wiki/Abstract_syntax_tree)のレベルで動作する本物のLispスタイルのマクロも実現できます。一方、CやC++のプリプロセッサの「マクロ」システムは、実際の構文解析や解釈が行われる前に、テキストの操作と置換を行います。Juliaではすべてのデータ型とコードがJuliaのデータ構造で表現されるため、強力な[reflection](https://en.wikipedia.org/wiki/Reflection_%28computer_programming%29)機能を使って、プログラムの内部やその型を、ほかのデータと同じように調べることができます。

!!! warning
    メタプログラミングは強力なツールですが、複雑さを持ち込み、コードを理解しにくくすることがあります。たとえば、スコープの規則を正しく扱うのは、驚くほど難しい場合があります。通常、メタプログラミングは、[higher order functions](@ref man-anonymous-functions)や[closures](https://en.wikipedia.org/wiki/Closure_(computer_programming))などのほかの手法を適用できない場合にのみ使うべきです。

    `eval`の使用や新しいマクロの定義は、通常、最後の手段とするべきです。`Meta.parse`を使ったり、任意の文字列をJuliaコードに変換したりすることが適切な選択となる場面は、ほとんどありません。Juliaコードを操作するには、`Expr`データ構造を直接使用し、Julia構文の解析に伴う複雑さを避けてください。

    メタプログラミングをうまく活用している例では、多くの場合、機能の大部分を実行時のヘルパー関数に実装し、生成するコードの量を最小限に抑えています。


## Program representation

すべてのJuliaプログラムは、文字列から始まります。

```jldoctest prog
julia> prog = "1 + 1"
"1 + 1"
```

**次に何が起こるのでしょうか？**

次の段階では、各文字列に[parse](https://en.wikipedia.org/wiki/Parsing#Computer_languages)を行い、式と呼ばれるオブジェクトに変換します。式はJuliaの型[`Expr`](@ref)で表現されます。

```jldoctest prog
julia> ex1 = Meta.parse(prog)
:(1 + 1)

julia> typeof(ex1)
Expr
```

`Expr`オブジェクトは、次の2つの部分から構成されます。

  * 式の種類を識別する[`Symbol`](@ref)。シンボルは[interned string](https://en.wikipedia.org/wiki/String_interning)な識別子です（詳しくは後述します）。

```jldoctest prog
julia> ex1.head
:call
```

  * 式の引数。シンボル、ほかの式、またはリテラル値を取ることができます。

```jldoctest prog
julia> ex1.args
3-element Vector{Any}:
  :+
 1
 1
```

式は[prefix notation](https://en.wikipedia.org/wiki/Polish_notation)で直接構築することもできます。

```jldoctest prog
julia> ex2 = Expr(:call, :+, 1, 1)
:(1 + 1)
```

上で構築した2つの式、つまり構文解析によるものと直接構築によるものは等価です。

```jldoctest prog
julia> ex1 == ex2
true
```

**ここで重要なのは、Juliaコードが内部的には言語自体からアクセスできるデータ構造として表現されているという点です。**

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

`Expr`オブジェクトは入れ子にすることもできます。

```jldoctest ex3
julia> ex3 = Meta.parse("(4 + 4) / 2")
:((4 + 4) / 2)
```

式を表示する別の方法として、`Meta.show_sexpr`があります。これは、指定した`Expr`を[S-expression](https://en.wikipedia.org/wiki/S-expression)形式で表示するもので、Lispのユーザーにはとてもなじみ深く見えるかもしれません。入れ子になった`Expr`の表示例を示します。

```jldoctest ex3
julia> Meta.show_sexpr(ex3)
(:call, :/, (:call, :+, 4, 4), 2)
```

### Symbols

Juliaでは、`:`という文字に構文上の用途が2つあります。1つ目の形式は、有効な識別子から[`Symbol`](@ref)を作成します。これは、式を構成する要素の1つとして使われる[interned string](https://en.wikipedia.org/wiki/String_interning)です。

```jldoctest
julia> s = :foo
:foo

julia> typeof(s)
Symbol
```

[`Symbol`](@ref)コンストラクタは任意の個数の引数を受け取り、それぞれの文字列表現を連結して新しいシンボルを作成します。

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

式の中では、シンボルは変数へのアクセスを表すために使われます。式が評価されると、シンボルは適切な[scope](@ref scope-of-variables)でそのシンボルに束縛された値に置き換えられます。

構文解析の曖昧さを避けるため、`:`の引数をさらに括弧で囲む必要がある場合もあります。

```jldoctest
julia> :(:)
:(:)

julia> :(::)
:(::)
```

## Expressions and evaluation

### Quoting

`:`という文字の2つ目の構文上の用途は、[`Expr`](@ref)コンストラクタを明示的に使わずに式オブジェクトを作成することです。これを*クォート*と呼びます。`:`という文字に続けて、Juliaコードの単一の文を括弧で囲んで記述すると、そのコードに基づく`Expr`オブジェクトが生成されます。算術式をクォートする短い形式の例を示します。

```jldoctest
julia> ex = :(a+b*c+1)
:(a + b * c + 1)

julia> typeof(ex)
Expr
```

（この式の構造を確認するには、`ex.head`と`ex.args`を試すか、上記のように[`dump`](@ref)または[`Meta.@dump`](@ref)を使ってください。）

[`Meta.parse`](@ref)や、`Expr`による直接構築でも、等価な式を構築できます。

```jldoctest
julia>      :(a + b*c + 1)       ==
       Meta.parse("a + b*c + 1") ==
       Expr(:call, :+, :a, Expr(:call, :*, :b, :c), 1)
true
```

パーサーが生成する式のargsには、一般にシンボル、ほかの式、リテラル値だけが含まれます。一方、Juliaコードで構築した式では、リテラル形式を持たない任意の実行時の値もargsに含めることができます。この例では、`+`と`a`はシンボル、`*(b,c)`は部分式、`1`は64ビット符号付き整数のリテラルです。

複数の式をクォートするための、もう1つの構文形式もあります。`quote ... end`で囲まれたコードブロックです。

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

値を引数として[`Expr`](@ref)オブジェクトを直接構築する方法は強力ですが、`Expr`コンストラクタの使用は「通常の」Julia構文と比べると煩雑になることがあります。代わりの方法として、Juliaではクォートされた式にリテラルや式を*補間*できます。補間は接頭辞`$`で示します。

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

この例では、タプル`(1,2,3)`が、条件判定に式として補間されます。

```jldoctest interp1
julia> ex = :(a in $:((1,2,3)) )
:(a in (1, 2, 3))
```

式の補間に`$`を使うのは、[string interpolation](@ref string-interpolation)や[command interpolation](@ref command-interpolation)を意図的に連想させるためです。式の補間を使うと、複雑なJuliaの式をプログラムで簡潔かつ読みやすく構築できます。

### Splatting interpolation

`$`による補間構文では、外側の式に挿入できるのは単一の式だけであることに注意してください。式の配列があり、そのすべてを外側の式の引数にしたい場合もあります。これは`$(xs...)`という構文で実現できます。たとえば、次のコードは、引数の個数をプログラムで決定する関数呼び出しを生成します。

```jldoctest interp1
julia> args = [:x, :y, :z];

julia> :(f(1, $(args...)))
:(f(1, x, y, z))
```

### Nested quote

もちろん、クォート式の中に別のクォート式を含めることもできます。この場合の補間の動作を理解するのは、少し難しいかもしれません。次の例を考えてみましょう。

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

結果に`$x`が含まれていることに注目してください。これは、`x`がまだ評価されていないことを意味します。つまり、`$`という式は内側のクォート式に「属している」ため、その引数は内側のクォート式が評価されるときに初めて評価されます。

```jldoctest interp1
julia> eval(e)
quote
    #= none:1 =#
    1 + 2
end
```

ただし、外側の`quote`式から、内側のクォート内にある`$`の内部に値を補間することもできます。そのためには`$`を複数使います。

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

今度は結果に、シンボル`x`ではなく`(1 + 2)`が現れています。この式を評価すると、補間された`3`が得られます。

```jldoctest interp1
julia> eval(e)
quote
    #= none:1 =#
    3
end
```

この動作は、`$`が1つあるごとに`x`が1回評価される、と直感的に捉えられます。`$`が1つなら`eval(:x)`と同じように動作し、`x`の値を返します。一方、`$`が2つなら、`eval(eval(:x))`と同等の処理を行います。

### [QuoteNode](@id man-quote-node)

ASTでは、`quote`形式は通常、headが`:quote`である[`Expr`](@ref)として表現されます。

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

これまで見てきたように、このような式は`$`による補間をサポートします。しかし、状況によっては、補間を*行わずに*コードをクォートする必要があります。この種のクォートにはまだ専用の構文がありませんが、内部的には`QuoteNode`型のオブジェクトとして表現されます。

```jldoctest interp1
julia> eval(Meta.quot(Expr(:$, :(1+2))))
3

julia> eval(QuoteNode(Expr(:$, :(1+2))))
:($(Expr(:$, :(1 + 2))))
```

パーサーは、シンボルなどの単純なクォート対象に対して`QuoteNode`を生成します。

```jldoctest interp1
julia> dump(Meta.parse(":x"))
QuoteNode
  value: Symbol x
```

`QuoteNode`は、一部の高度なメタプログラミング処理にも利用できます。

`$`はサポートされていませんが、禁止もされていないこと、また、包まれたオブジェクトの同一性は保持されないことに注意してください。

```jldoctest
julia> b = 2; eval(Expr(:quote, QuoteNode(Expr(:$, :b))))
:($(QuoteNode(2)))
```

### Evaluating expressions

式オブジェクトが与えられたとき、[`eval`](@ref)を使って、Juliaにグローバルスコープでその式を評価（実行）させることができます。

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

各[module](@ref modules)には独自の[`eval`](@ref)関数があり、そのグローバルスコープで式を評価します。[`eval`](@ref)に渡される式は、値を返すだけとは限りません。そのモジュールの環境の状態を変更する副作用を持つこともできます。

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

ここでは、式オブジェクトの評価によって、グローバル変数`x`に値が代入されます。

式は単なる`Expr`オブジェクトであり、プログラムで構築してから評価できるため、任意のコードを動的に生成し、[`eval`](@ref)を使って実行できます。簡単な例を示します。

```jldoctest
julia> a = 1;

julia> ex = Expr(:call, :+, a, :b)
:(1 + b)

julia> a = 0; b = 2;

julia> eval(ex)
3
```

`a`の値を使って、式`ex`を構築しています。この式は、値1と変数`b`に`+`関数を適用します。`a`と`b`の使われ方には、重要な違いがあります。

  * 式を構築した時点での*変数*`a`の値が、式内の即値として使われます。したがって、式の評価時に`a`がどのような値であるかは、もはや関係ありません。`a`の値が何であっても、式内の値はすでに`1`になっています。
  * 一方、式の構築に使われるのが*シンボル*`:b`である場合、その時点での変数`b`の値は関係ありません。`:b`は単なるシンボルであり、変数`b`は定義されている必要すらありません。ただし、式の評価時には、変数`b`の値を検索することで、シンボル`:b`の値が解決されます。

### Functions on `Expr`essions

前述のとおり、Juliaの非常に便利な機能の1つは、Julia自身の中でJuliaコードを生成・操作できることです。[`Expr`](@ref)オブジェクトを返す関数の例は、すでに見てきました。Juliaコードの文字列を受け取り、対応する`Expr`を返す[`Meta.parse`](@ref)関数です。また、関数は1つ以上の`Expr`オブジェクトを引数として受け取り、別の`Expr`を返すこともできます。考え方をつかむための簡単な例を示します。

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

別の例として、数値の引数は2倍にする一方、式はそのままにする関数を示します。

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

マクロは、生成したコードをプログラムの最終的な本体に組み込む仕組みを提供します。マクロは引数のタプルを受け取り、*式*を返します。返された式は、実行時に[`eval`](@ref)を呼び出すことなく、直接コンパイルされます。マクロの引数には、式、リテラル値、シンボルを含めることができます。

### Basics

非常に単純なマクロを示します。

```jldoctest sayhello
julia> macro sayhello()
           return :( println("Hello, world!") )
       end
@sayhello (macro with 1 method)
```

Juliaの構文では、マクロに専用の文字`@`（アットマーク）を使い、その後に`macro NAME ... end`ブロックで宣言した一意の名前を続けます。この例では、コンパイラはすべての`@sayhello`を次の式に置き換えます。

```julia
:( println("Hello, world!") )
```

REPLで`@sayhello`を入力すると、式はすぐに実行されるため、評価結果だけが表示されます。

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

このマクロは、`name`という引数を1つ受け取ります。`@sayhello`が現れると、クォートされた式が*展開*され、引数の値が最終的な式に補間されます。

```jldoctest sayhello2
julia> @sayhello("human")
Hello, human
```

[`macroexpand`](@ref)関数を使うと、戻り値となるクォートされた式を確認できます（**重要：**これはマクロのデバッグに非常に役立つツールです）。

```julia-repl sayhello2
julia> ex = macroexpand(Main, :(@sayhello("human")) )
:(Main.println("Hello, ", "human"))

julia> typeof(ex)
Expr
```

`"human"`というリテラルが式に補間されていることがわかります。

`macroexpand`関数よりも少し便利に使える、[`@macroexpand`](@ref)というマクロもあります。

```jldoctest sayhello2
julia> @macroexpand @sayhello "human"
:(println("Hello, ", "human"))
```

### Hold up: why macros?

前の節では、すでに`f(::Expr...) -> Expr`という関数を見ました。実際、[`macroexpand`](@ref)もそのような関数です。では、なぜマクロが存在するのでしょうか？

マクロが必要なのは、コードの構文解析時に実行されるからです。そのため、プログラマーはプログラム全体が実行される*前に*、用途に合わせたコード片を生成して組み込むことができます。この違いを示すために、次の例を考えてみましょう。

```julia-repl whymacros
julia> macro twostep(arg)
           println("I execute at parse time. The argument is: ", arg)
           return :(println("I execute at runtime. The argument is: ", $arg))
       end
@twostep (macro with 1 method)

julia> ex = macroexpand(Main, :(@twostep :(1, 2, 3)) );
I execute at parse time. The argument is: :((1, 2, 3))
```

最初の[`println`](@ref)の呼び出しは、[`macroexpand`](@ref)が呼び出されたときに実行されます。その結果得られる式には、2つ目の`println`*だけ*が含まれます。

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

マクロ名の前に識別用の`@`があることに注目してください。また、1つ目の形式では引数の式の間にカンマがなく、2つ目の形式では`@name`の後に空白がありません。この2つの形式を混在させてはいけません。たとえば、次の構文は上の例とは異なり、タプル`(expr1, expr2, ...)`を1つの引数としてマクロに渡します。

```julia
@name (expr1, expr2, ...)
```

配列リテラル（または内包表記）に対してマクロを呼び出す別の方法として、括弧を使わずに両者を隣接させて記述できます。この場合、配列がマクロに渡される唯一の式になります。次の構文は互いに等価です（ただし`@name [a b] * v`とは異なります）。

```julia
@name[a b] * v
@name([a b]) * v
```

マクロは引数を式、リテラル、シンボルとして受け取る、という点は重要です。マクロの引数を調べる方法の1つは、マクロ本体の中で[`show`](@ref)関数を呼び出すことです。

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

すべてのマクロには、指定された引数リストに加えて、`__source__`と`__module__`という追加の引数が渡されます。

引数`__source__`は、マクロ呼び出しの`@`記号がパーサー上のどこにあるかという情報を、`LineNumberNode`オブジェクトの形で提供します。これにより、マクロはより詳しいエラー診断情報を含めることができます。たとえば、ログ出力、文字列解析マクロ、ドキュメントなどでよく使われるほか、[`@__LINE__`](@ref)、[`@__FILE__`](@ref)、[`@__DIR__`](@ref)マクロの実装にも使われます。

位置情報は、`__source__.line`と`__source__.file`を参照して取得できます。

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

引数`__module__`は、マクロ呼び出しの展開コンテキストに関する情報を、`Module`オブジェクトの形で提供します。これにより、マクロは既存の束縛などのコンテキスト情報を検索したり、現在のモジュール内でリフレクションを行う実行時の関数呼び出しに、この値を追加の引数として挿入したりできます。

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

構文解析時に、マクロ呼び出しはその戻り値の結果へと展開され、元の記述と置き換わります。これは次のように書くのと等価です。

```julia
1 == 1.0 ? nothing : throw(AssertionError("1 == 1.0"))
1 == 0 ? nothing : throw(AssertionError("1 == 0"))
```

つまり、最初の呼び出しでは、式`:(1 == 1.0)`が判定条件の位置に挿入され、`string(:(1 == 1.0))`の値がアサーションメッセージの位置に挿入されます。このように構築された式全体が、構文木の中で`@assert`マクロの呼び出しがあった位置に置かれます。そして実行時に、判定式の評価結果がtrueなら[`nothing`](@ref)が返され、falseなら、アサートした式が偽だったことを示すエラーが発生します。これを関数として記述することはできません。関数では条件の*値*しか利用できず、その値を計算した式をエラーメッセージに表示できないためです。

Julia Baseにある`@assert`の実際の定義は、より複雑です。失敗した式を表示するだけでなく、ユーザーが独自のエラーメッセージを任意で指定できるようになっています。可変個の引数を取る関数（[Varargs Functions](@ref)）と同様に、これは最後の引数の後に省略記号を付けて指定します。

```julia-repl assert2
julia> macro assert(ex, msgs...)
           msg_body = isempty(msgs) ? ex : msgs[1]
           msg = string(msg_body)
           return :($ex ? nothing : throw(AssertionError($msg)))
       end
@assert (macro with 1 method)
```

これで`@assert`は、受け取る引数の個数に応じて2通りの動作をするようになりました。引数が1つしかない場合、`msgs`で取り込まれる式のタプルは空になり、先ほどの単純な定義と同じように動作します。一方、ユーザーが2つ目の引数を指定すると、失敗した式の代わりに、その引数がメッセージ本文に表示されます。マクロ展開の結果は、その名のとおりの[`@macroexpand`](@ref)マクロで確認できます。

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

実際の`@assert`マクロは、さらに別のケースにも対応しています。「aはbと等しいはずです」というメッセージに加えて、それぞれの値も表示したい場合はどうでしょうか？ 単純に考えると、独自のメッセージで文字列補間を使い、たとえば`@assert a==b "a ($a) should equal b ($b)!"`のように書きたくなるかもしれません。しかし、上のマクロでは期待どおりには動作しません。なぜかわかりますか？ [string interpolation](@ref string-interpolation)で説明したように、補間を含む文字列は[`string`](@ref)の呼び出しに書き換えられます。比較してみましょう。

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

したがって、マクロは`msg_body`に単なる文字列を受け取るのではなく、期待どおりに表示するために評価が必要な式全体を受け取ります。これは、[`string`](@ref)呼び出しの引数として、返す式に直接挿入できます。完全な実装については[`error.jl`](https://github.com/JuliaLang/julia/blob/master/base/error.jl)を参照してください。

`@assert`マクロは、クォートされた式への挿入をうまく活用することで、マクロ本体内での式の操作を簡単にしています。

### Hygiene

より複雑なマクロで生じる問題の1つが、[hygiene](https://en.wikipedia.org/wiki/Hygienic_macro)です。要するに、マクロは返す式の中に導入した変数が、展開先の周囲のコードにある既存の変数と意図せず衝突しないようにしなければなりません。逆に、マクロに引数として渡された式は、多くの場合、周囲のコードのコンテキストで評価され、既存の変数を参照したり変更したりすることが*期待されます*。また、マクロが定義されたモジュールとは別のモジュールから呼び出される場合もあります。この場合、すべてのグローバル変数が正しいモジュールで解決されるようにする必要があります。Juliaには、返される式だけを考慮すればよいという点で、Cなどのテキストによるマクロ展開を行う言語に対する大きな利点がすでにあります。それ以外の変数（上の`@assert`における`msg`など）はすべて、[normal scoping block behavior](@ref scope-of-variables)に従います。

これらの問題を示すために、`@time`マクロを作ることを考えてみましょう。このマクロは式を引数として受け取り、時刻を記録し、式を評価してから再び時刻を記録し、前後の時刻の差を表示して、最後に式の値を結果とします。マクロは次のようになるでしょう。

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

ここでは、`t0`、`t1`、`val`を内部専用の一時変数にしたいと考えています。また、`time_ns`は、ユーザーが持っているかもしれない`time_ns`という変数ではなく、Julia Baseの[`time_ns`](@ref)関数を参照してほしいところです（`println`についても同様です）。ユーザーの式`ex`にも`t0`という名前の変数への代入が含まれていたり、独自の`time_ns`変数が定義されていたりした場合に、どのような問題が起こるか想像してみてください。エラーが発生したり、原因のわかりにくい誤動作が起きたりするかもしれません。

Juliaのマクロ展開器は、次のようにしてこれらの問題を解決します。まず、マクロの結果に含まれる変数をローカルかグローバルのどちらかに分類します。代入先となる変数（グローバルと宣言されていないもの）、ローカルと宣言された変数、関数の引数名として使われる変数は、ローカルとみなされます。それ以外はグローバルとみなされます。次に、ローカル変数は、新しいシンボルを生成する[`gensym`](@ref)関数を使って、一意の名前に変更されます。一方、グローバル変数はマクロ定義時の環境で解決されます。これによって、先ほどの2つの問題に対処できます。マクロのローカル変数はユーザーの変数と衝突せず、`time_ns`と`println`はJulia Baseの定義を参照します。

しかし、まだ1つ問題が残っています。このマクロを次のように使う場合を考えてみましょう。

```julia
module MyModule
import Base.@time

time_ns() = ... # compute something

@time time_ns()
end
```

ここで、ユーザーの式`ex`は`time_ns`の呼び出しですが、マクロが使っている`time_ns`関数と同じものではありません。これは明らかに`MyModule.time_ns`を参照しています。したがって、`ex`内のコードは、マクロ呼び出し時の環境で解決されるようにする必要があります。そのためには、[`esc`](@ref)を使って式を「エスケープ」します。

```julia
macro time(ex)
    ...
    local val = $(esc(ex))
    ...
end
```

このように包まれた式は、マクロ展開器による処理を受けず、そのまま出力に貼り付けられます。そのため、マクロ呼び出し時の環境で解決されます。

このエスケープ機構を使うと、必要に応じてハイジーンを「破り」、ユーザーの変数を導入したり操作したりできます。たとえば、次のマクロは、呼び出し元の環境で`x`をゼロに設定します。

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

この種の変数操作は慎重に使うべきですが、ときには非常に便利です。

ハイジーンの規則を正しく扱うのは、非常に難しいことがあります。マクロを使う前に、関数のクロージャで十分ではないか検討するとよいでしょう。もう1つの有用な方針は、できるだけ多くの処理を実行時に回すことです。たとえば、多くのマクロは、引数を`QuoteNode`や、それに類する[`Expr`](@ref)で包むだけです。その例として、単に`schedule(Task(() -> $body))`を返す`@task body`や、単に`eval(QuoteNode(expr))`を返す`@eval expr`があります。

例として、先ほどの`@time`を書き換えると、次のようになります。

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

ただし、実際にはこのようにはしません。それには理由があります。`expr`を新しいスコープブロック（無名関数）で包むと、式の意味、つまりその中の変数のスコープもわずかに変わってしまいます。一方、`@time`は、包まれるコードへの影響を最小限に抑えて使えるようにしたいためです。

### Macros and dispatch

マクロはJuliaの関数と同様にジェネリックです。つまり、多重ディスパッチによって、複数のメソッド定義を持つことができます。

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

ただし、マクロのディスパッチは、マクロに渡されるASTの型に基づいて行われるのであって、ASTを実行時に評価して得られる値の型に基づくものではないことに注意してください。

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

反復的な定型コードが大量に必要な場合、冗長さを避けるためにプログラムで生成するのが一般的です。多くの言語では、そのために追加のビルド手順と、反復的なコードを生成する別のプログラムが必要になります。Juliaでは、式の補間と[`eval`](@ref)によって、通常のプログラム実行の流れの中でそのようなコード生成を行えます。たとえば、次の独自の型を考えてみましょう。

```jldoctest mynumber-codegen
struct MyNumber
    x::Float64
end
# output

```

この型に複数のメソッドを追加したいとします。次のループで、プログラムによって追加できます。

```jldoctest mynumber-codegen
for op = (:sin, :cos, :tan, :log, :exp)
    eval(quote
        Base.$op(a::MyNumber) = MyNumber($op(a.x))
    end)
end
# output

```

これで、独自の型に対してそれらの関数を使えるようになりました。

```jldoctest mynumber-codegen
julia> x = MyNumber(π)
MyNumber(3.141592653589793)

julia> sin(x)
MyNumber(1.2246467991473532e-16)

julia> cos(x)
MyNumber(-1.0)
```

このように、Juliaは自身の[preprocessor](https://en.wikipedia.org/wiki/Preprocessor)として機能し、言語の内部からコードを生成できます。上のコードは、`:`を前置するクォート形式を使うと、もう少し簡潔に書けます。

```julia
for op = (:sin, :cos, :tan, :log, :exp)
    eval(:(Base.$op(a::MyNumber) = MyNumber($op(a.x))))
end
```

ただし、`eval(quote(...))`というパターンを使う、この種の言語内でのコード生成は十分によく使われるため、Juliaにはこのパターンを短く書くためのマクロが用意されています。

```julia
for op = (:sin, :cos, :tan, :log, :exp)
    @eval Base.$op(a::MyNumber) = MyNumber($op(a.x))
end
```

[`@eval`](@ref)マクロは、この呼び出しを上の長い形式と完全に等価になるように書き換えます。生成するコードが長い場合は、[`@eval`](@ref)に渡す式の引数をブロックにすることもできます。

```julia
@eval begin
    # multiple lines
end
```

## [Non-Standard String Literals](@id meta-non-standard-string-literals)

[Strings](@ref non-standard-string-literals)で説明したように、識別子が前置された文字列リテラルは非標準文字列リテラルと呼ばれ、接頭辞のない文字列リテラルとは異なる意味を持つことがあります。たとえば、次のようなものです。

  * `r"^\s*(?:#|$)"`は、文字列ではなく[regular expression object](@ref man-regex-literals)を生成します。
  * `b"DATA\xff\u2200"`は、`[68,65,84,65,255,226,136,128]`の[byte array literal](@ref man-byte-array-literals)です。

意外かもしれませんが、これらの動作はJuliaのパーサーやコンパイラに組み込まれたものではありません。誰でも使える汎用的な仕組みによって提供される、独自の動作です。接頭辞付きの文字列リテラルは、特定の命名規則を持つマクロへの呼び出しとして解析されます。たとえば、正規表現マクロは次のようなものにすぎません。

```julia
macro r_str(p)
    Regex(p)
end
```

これだけです。このマクロは、文字列リテラル`r"^\s*(?:#|$)"`の内容をそのまま`@r_str`マクロに渡し、その展開結果を、構文木内で文字列リテラルがあった位置に配置するように指示します。つまり、式`r"^\s*(?:#|$)"`は、次のオブジェクトを構文木に直接配置することと等価です。

```julia
Regex("^\\s*(?:#|\$)")
```

文字列リテラル形式は、短くてはるかに便利なだけでなく、効率も優れています。正規表現のコンパイルと`Regex`オブジェクトの実際の作成は、*コードのコンパイル時に*行われるため、コードを実行するたびではなく、一度だけ行われるからです。正規表現がループ内にある場合を考えてみましょう。

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

正規表現`r"^\s*(?:#|$)"`は、このコードが解析されるときにコンパイルされて構文木に挿入されるため、ループが実行されるたびにではなく、一度だけコンパイルされます。マクロなしで同じことを実現するには、このループを次のように書く必要があります。

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

さらに、コンパイラが正規表現オブジェクトはループの全反復を通じて一定であると判断できなければ、一部の最適化ができなくなり、この形式は、より便利な上のリテラル形式よりも効率が悪くなる可能性があります。もちろん、リテラルを使わない形式のほうが便利な状況もあります。正規表現に変数を補間する必要がある場合は、この冗長な方法を取らなければなりません。また、正規表現のパターン自体が動的で、ループの反復ごとに変わる可能性がある場合は、反復のたびに新しい正規表現オブジェクトを構築する必要があります。しかし、大半の用途では、正規表現を実行時のデータに基づいて構築することはありません。そのような多くの場合、正規表現をコンパイル時の値として記述できることは非常に有用です。

ユーザー定義の文字列リテラルの仕組みは、きわめて強力です。Juliaの非標準リテラルがこの仕組みで実装されているだけでなく、コマンドリテラル構文（``` `echo "Hello, $person"` ```）も、次の一見単純なマクロで実装されています。

```julia
macro cmd(str)
    :(cmd_gen($(shell_parse(str)[1])))
end
```

もちろん、このマクロ定義で使われている関数の中には多くの複雑な処理が隠れています。しかし、それらも完全にJuliaで書かれた普通の関数です。ソースを読めば、何をしているのか正確に確認できます。そして、それらが行っているのは、プログラムの構文木に挿入する式オブジェクトの構築だけです。

文字列リテラルと同様に、コマンドリテラルにも識別子を前置して、非標準コマンドリテラルと呼ばれるものを作れます。これらのコマンドリテラルは、特定の命名規則を持つマクロへの呼び出しとして解析されます。たとえば、構文```custom`literal` ```は、`@custom_cmd "literal"`として解析されます。Julia自体には非標準コマンドリテラルは含まれていませんが、パッケージではこの構文を利用できます。構文が異なることと、接尾辞が`_str`ではなく`_cmd`であることを除けば、非標準コマンドリテラルは非標準文字列リテラルとまったく同じように動作します。

2つのモジュールが同じ名前の非標準文字列リテラルまたは非標準コマンドリテラルを提供している場合は、文字列リテラルやコマンドリテラルをモジュール名で修飾できます。たとえば、`Foo`と`Bar`の両方が非標準文字列リテラル`@x_str`を提供している場合、`Foo.x"literal"`または`Bar.x"literal"`と書けば、両者を区別できます。

マクロを定義する別の方法として、次のような形式もあります。

```julia
macro foo_str(str, flag)
    # do stuff
end
```

このマクロは、次の構文で呼び出せます。

```julia
foo"str"flag
```

上の構文におけるflagの型は`String`で、その内容は文字列リテラルの後ろに続く部分です。

## Generated functions

非常に特殊なマクロとして、[`@generated`](@ref)があります。これは、いわゆる*生成関数*を定義するためのものです。生成関数は、多重ディスパッチだけを使う場合よりも柔軟に、あるいは少ないコードで、引数の型に応じた特殊化コードを生成できます。マクロは構文解析時に式を処理し、入力の型にはアクセスできませんが、生成関数は、引数の型がわかっていて、まだ関数がコンパイルされていない段階で展開されます。

生成関数の宣言は、何らかの計算や処理を実行する代わりに、クォートされた式を返します。この式が、引数の型に対応するメソッドの本体になります。生成関数を呼び出すと、その関数が返す式がコンパイルされ、実行されます。効率を高めるため、通常、その結果はキャッシュされます。また、推論を可能にするため、言語の機能のうち限られた部分だけが使用できます。したがって、生成関数は、使える構文要素に強い制限が課される代わりに、実行時の処理をコンパイル時に移す柔軟な方法を提供します。

生成関数の定義には、通常の関数と比べて主に次の5つの違いがあります。

1. 関数宣言に`@generated`マクロを付けます。これにより、生成関数であることをコンパイラに知らせる情報がASTに追加されます。
2. 生成関数の本体でアクセスできるのは引数の*型*だけであり、値にはアクセスできません。
3. 何かを計算したり処理を実行したりする代わりに、評価されたときに目的の動作を行う*クォートされた式*を返します。
4. 生成関数から呼び出せるのは、その生成関数の定義*より前に*定義された関数だけです。（これに従わないと、将来のworld-ageにある関数を参照する`MethodErrors`が発生することがあります。）
5. 生成関数は、定数ではないグローバル状態を*変更*しても*観測*してもいけません（たとえば、IO、ロック、非ローカルな辞書、[`hasmethod`](@ref)の使用などが含まれます）。つまり、読み取れるのはグローバル定数だけで、副作用を持つことはできません。言い換えれば、完全に純粋でなければなりません。また、実装上の制約により、現時点ではクロージャやジェネレーターを定義することもできません。

例を使うのが最もわかりやすいでしょう。生成関数`foo`を次のように宣言できます。

```jldoctest generated
julia> @generated function foo(x)
           Core.println(x)
           return :(x * x)
       end
foo (generic function with 1 method)
```

本体が返すのは、単なる`x * x`の値ではなく、クォートされた式`:(x * x)`であることに注意してください。

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

生成関数の本体では、`x`は渡された引数の*型*になっています。また、生成関数の呼び出しから返される値は、定義から返したクォートされた式を、今度は`x`の*値*を使って評価した結果です。

すでに使った型で`foo`をもう一度評価すると、どうなるでしょうか？

```jldoctest generated
julia> foo(4)
16
```

[`Int64`](@ref)が表示されていないことに注目してください。この例では、特定の引数の型の組み合わせに対して、生成関数の本体は一度だけ実行され、その結果がキャッシュされたことがわかります。その後は、最初の呼び出し時に生成関数が返した式がメソッド本体として再利用されています。ただし、実際のキャッシュ動作は実装で定められる性能上の最適化なので、この動作に過度に依存してはいけません。

生成関数の生成は、一度だけ行われる*かもしれません*が、それより多く行われる*かもしれません*し、まったく行われないように見えることもあります。そのため、副作用を持つ生成関数は*決して*書かないでください。副作用がいつ、どのくらいの頻度で発生するかは未定義です。（これはマクロでも同じです。また、マクロの場合と同様に、生成関数内で[`eval`](@ref)を使っているなら、方法を誤っている兆候です。）ただし、マクロとは異なり、実行時システムは[`eval`](@ref)の呼び出しを正しく処理できないため、これは禁止されています。

`@generated`関数がメソッドの再定義とどのように関わるかを理解することも重要です。正しい`@generated`関数は、可変な状態を観測せず、グローバル状態を変更してもならないという原則に従うと、次の動作になります。生成関数自身の*定義*より前に定義されていないメソッドは、生成関数から呼び出せ*ない*ことに注目してください。

最初、`f(x)`には定義が1つあります。

```jldoctest redefinition
julia> f(x) = "original definition";
```

`f(x)`を使う、ほかの処理を定義します。

```jldoctest redefinition
julia> g(x) = f(x);

julia> @generated gen1(x) = f(x);

julia> @generated gen2(x) = :(f(x));
```

次に、`f(x)`の新しい定義をいくつか追加します。

```jldoctest redefinition
julia> f(x::Int) = "definition for Int";

julia> f(x::Type{Int}) = "definition for Type{Int}";
```

そして、結果の違いを比較します。

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

生成関数の各メソッドから見える関数の定義は、それぞれ異なります。

```jldoctest redefinition
julia> @generated gen1(x::Real) = f(x);

julia> gen1(1)
"definition for Type{Int}"
```

上の生成関数`foo`の例では、通常の関数`foo(x) = x * x`ではできないことは何もしていませんでした（最初の呼び出し時に型を表示し、より大きなオーバーヘッドがかかることを除きます）。しかし、生成関数の強みは、渡された型に応じて異なるクォート式を計算できることにあります。

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

（もちろん、このような説明用の例は、多重ディスパッチを使うほうが簡単に実装できますが……。）

これを誤用すると、実行時システムを破損させ、未定義動作を引き起こします。

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

生成関数の本体が非決定的であるため、その動作だけでなく、*それ以降のすべてのコードの動作も*未定義になります。

*これらの例をコピーしないでください！*

これらの例は、生成関数が定義側と呼び出し側でどのように動くかを理解する助けになるはずです。しかし、次の理由から、*コピーして使わないでください*。

  * `foo`関数には副作用（`Core.println`の呼び出し）があり、その副作用が具体的にいつ、どのくらいの頻度で、何回発生するかは未定義です。
  * `bar`関数が解決している問題は、多重ディスパッチを使うほうが適切です。`bar(x) = x`と`bar(x::Integer) = x ^ 2`を定義すれば、同じことを、より簡単かつ高速に実現できます。
  * `baz`関数は、問題のある極端な例です。

生成関数内で試みるべきでない操作は、列挙しきれるものではありません。また、現在の実行時システムが検出できる不正な操作は、その一部だけです。警告もなく実行時システムを破損させる操作はほかにも多くあり、通常は、問題のある定義との関連がすぐにはわからない微妙な形で影響が現れます。関数生成器は推論中に実行されるため、推論コードに課されるすべての制約を守る必要があります。

試みるべきでない操作の例を挙げます。

1. ネイティブポインタのキャッシュ。
2. `Core.Compiler`の内容やメソッドに、何らかの形で関わること。
3. 可変な状態の観測。

      * 生成関数に対する推論は、コードがその状態を観測または変更しようとしている最中を含め、*いつでも*実行される可能性があります。
4. ロックの取得。呼び出し先のCコードが内部的にロックを使うことは許されます（たとえば、`malloc`の呼び出しは、多くの実装で内部的にロックが必要でも問題ありません）。ただし、Juliaコードの実行中にロックを保持したり取得したりしようとしてはいけません。
5. 生成関数の本体より後に定義された関数の呼び出し。この条件は、インクリメンタルに読み込まれるプリコンパイル済みモジュールでは緩和され、モジュール内の任意の関数を呼び出せます。

さて、生成関数の動作について理解が深まったところで、これを使って、もう少し高度で、かつ正当な機能を構築してみましょう。

### An advanced example

Juliaの基本ライブラリには、n個の多次元インデックスからn次元配列内の線形インデックスを計算する内部関数`sub2ind`があります。言い換えると、配列`A`の要素に、`A[x,y,z,...]`ではなく`A[i]`でアクセスするためのインデックス`i`を計算する関数です。実装の一例を示します。

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

同じことは再帰でも実現できます。

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

この2つの実装は異なるものですが、本質的には同じことをしています。実行時に配列の各次元をループで処理し、各次元のオフセットを最終的なインデックスに集約しています。

しかし、ループに必要な情報はすべて、引数の型情報に埋め込まれています。そのため、コンパイラは反復処理をコンパイル時に移し、実行時のループを完全に取り除くことができます。生成関数を使っても、同様の効果を実現できます。コンパイラの用語で言えば、生成関数を使って手動でループを展開するわけです。本体はほぼ同じですが、線形インデックスを計算する代わりに、インデックスを計算する*式*を組み立てます。

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

**これはどのようなコードを生成するのでしょうか？**

簡単に確認するには、本体を別の（通常の）関数として切り出します。

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

これで`sub2ind_gen_impl`を実行して、返される式を調べられます。

```jldoctest sub2ind_gen2
julia> sub2ind_gen_impl(Tuple{Int,Int}, Int, Int)
:(((I[1] - 1) + dims[1] * (I[2] - 1)) + 1)
```

ここで使われるメソッド本体にはループがまったく含まれておらず、2つのタプルへのインデックスアクセスと、乗算、加算・減算だけがあります。すべてのループ処理はコンパイル時に行われ、実行時のループは完全になくなります。したがって、ループを実行するのは*型ごとに一度*だけで、この場合は`N`ごとに一度です（関数が複数回生成される特殊な場合を除きます。上記の注意事項を参照してください）。

### Optionally-generated functions

生成関数は実行時に高い効率を実現できますが、コンパイル時にはコストがかかります。具体的な引数の型の組み合わせごとに、新しい関数本体を生成する必要があるためです。通常、Juliaは任意の引数に対して動作する「ジェネリック」な関数をコンパイルできますが、生成関数ではこれができません。そのため、生成関数を多用するプログラムは、静的にコンパイルできない可能性があります。

この問題を解決するために、生成関数の代替実装として、生成を行わない通常の実装を記述する構文が用意されています。上の`sub2ind`の例に適用すると、次のようになります。

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

内部的には、このコードから関数の実装が2つ作られます。`if @generated`の最初のブロックを使う生成版と、`else`ブロックを使う通常版です。`if @generated`ブロックの`then`部分では、コードはほかの生成関数と同じ意味を持ちます。引数名は型を参照し、コードは式を返す必要があります。`if @generated`ブロックを複数記述することもできます。その場合、生成版はすべての`then`ブロックを使い、代替実装はすべての`else`ブロックを使います。

関数の先頭にエラーチェックを追加したことに注目してください。このコードは両方の版に共通で、いずれの版でも実行時のコードになります（生成版では、クォートされて式として返されます）。したがって、ローカル変数の値や型はコード生成時には利用できません。コード生成を行うコードから見えるのは、引数の型だけです。

この形式の定義では、コード生成機能は本質的に任意の最適化です。コンパイラは都合がよければこれを使いますが、そうでなければ通常の実装を使うこともあります。この形式が推奨されるのは、コンパイラがより多くの判断を行い、より多様な方法でプログラムをコンパイルできることに加え、通常のコードのほうがコードを生成するコードよりも読みやすいためです。ただし、どちらの実装が使われるかはコンパイラの実装の詳細に依存するため、2つの実装が同一の動作をすることが不可欠です。
