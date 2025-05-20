# Metaprogramming

Lispの最も強力な遺産は、Julia言語におけるメタプログラミングのサポートです。Lispと同様に、Juliaは自分自身のコードを言語自体のデータ構造として表現します。コードは言語内から作成および操作できるオブジェクトによって表現されるため、プログラムが自分自身のコードを変換および生成することが可能です。これにより、追加のビルドステップなしで高度なコード生成が可能になり、また、[abstract syntax trees](https://en.wikipedia.org/wiki/Abstract_syntax_tree)のレベルで動作する真のLispスタイルのマクロも可能になります。対照的に、CやC++のようなプリプロセッサの「マクロ」システムは、実際の解析や解釈が行われる前にテキストの操作や置換を行います。Juliaでは、すべてのデータ型とコードがJuliaのデータ構造によって表現されるため、プログラムとその型の内部を探るための強力な[reflection](https://en.wikipedia.org/wiki/Reflection_%28computer_programming%29)機能が利用可能です。

!!! warning
    メタプログラミングは強力なツールですが、コードを理解しにくくする複雑さを導入します。たとえば、スコープルールを正しく取得するのは驚くほど難しい場合があります。メタプログラミングは、通常、[higher order functions](@ref man-anonymous-functions)や[closures](https://en.wikipedia.org/wiki/Closure_(computer_programming))のような他のアプローチが適用できない場合にのみ使用されるべきです。

    `eval` と新しいマクロの定義は、通常、最後の手段として使用すべきです。`Meta.parse` を使用したり、任意の文字列を Julia コードに変換するのは、ほとんど良いアイデアではありません。Julia コードを操作するには、Julia の構文がどのように解析されるかの複雑さを避けるために、`Expr` データ構造を直接使用してください。

    メタプログラミングの最良の使用法は、しばしばランタイムヘルパー関数にほとんどの機能を実装し、生成するコードの量を最小限に抑えることを目指します。


## Program representation

すべてのJuliaプログラムは文字列として始まります：

```jldoctest prog
julia> prog = "1 + 1"
"1 + 1"
```

**次に何が起こるのか？**

次のステップは、[parse](https://en.wikipedia.org/wiki/Parsing#Computer_languages) 各文字列を、Julia型 [`Expr`](@ref) で表されるオブジェクト「expression」として表現することです。

```jldoctest prog
julia> ex1 = Meta.parse(prog)
:(1 + 1)

julia> typeof(ex1)
Expr
```

`Expr` オブジェクトは二つの部分を含みます：

  * a [`Symbol`](@ref) は、表現の種類を特定します。シンボルは [interned string](https://en.wikipedia.org/wiki/String_interning) 識別子です（以下でさらに議論します）。

```jldoctest prog
julia> ex1.head
:call
```

  * 式の引数は、シンボル、他の式、またはリテラル値である可能性があります：

```jldoctest prog
julia> ex1.args
3-element Vector{Any}:
  :+
 1
 1
```

式は [prefix notation](https://en.wikipedia.org/wiki/Polish_notation) で直接構築することもできます:

```jldoctest prog
julia> ex2 = Expr(:call, :+, 1, 1)
:(1 + 1)
```

上記で構築された2つの表現 – パースによるものと直接構築によるもの – は同等です：

```jldoctest prog
julia> ex1 == ex2
true
```

**ここでの重要な点は、Juliaコードが内部的にデータ構造として表現されており、そのデータ構造に言語自体からアクセスできるということです。**

[`dump`](@ref) 関数は、`Expr` オブジェクトのインデントされた注釈付き表示を提供します：

```jldoctest prog
julia> dump(ex2)
Expr
  head: Symbol call
  args: Array{Any}((3,))
    1: Symbol +
    2: Int64 1
    3: Int64 1
```

`Expr` オブジェクトはネストすることもできます:

```jldoctest ex3
julia> ex3 = Meta.parse("(4 + 4) / 2")
:((4 + 4) / 2)
```

別の方法として、`Meta.show_sexpr`を使用して式を表示することができます。これは、与えられた`Expr`の[S-expression](https://en.wikipedia.org/wiki/S-expression)形式を表示します。この形式はLispのユーザーには非常に馴染みがあるかもしれません。以下は、ネストされた`Expr`の表示を示す例です：

```jldoctest ex3
julia> Meta.show_sexpr(ex3)
(:call, :/, (:call, :+, 4, 4), 2)
```

### Symbols

`:` 文字は、Julia において二つの構文的目的を持っています。最初の形式は、[`Symbol`](@ref) を作成します。これは、式の構成要素の一つとして使用される [interned string](https://en.wikipedia.org/wiki/String_interning) です。

```jldoctest
julia> s = :foo
:foo

julia> typeof(s)
Symbol
```

[`Symbol`](@ref) コンストラクタは、任意の数の引数を受け取り、それらの文字列表現を連結することによって新しいシンボルを作成します：

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

式の文脈において、シンボルは変数へのアクセスを示すために使用されます。式が評価されると、シンボルは適切な [scope](@ref scope-of-variables) においてそのシンボルに束縛された値に置き換えられます。

時々、解析の曖昧さを避けるために、`:` への引数の周りに余分な括弧が必要です:

```jldoctest
julia> :(:)
:(:)

julia> :(::)
:(::)
```

## Expressions and evaluation

### Quoting

`:` 文字の第二の構文的目的は、明示的な [`Expr`](@ref) コンストラクタを使用せずに式オブジェクトを作成することです。これは *引用* と呼ばれます。 `:` 文字の後に、単一の Julia コードのステートメントを囲むペアの括弧を続けることで、囲まれたコードに基づいた `Expr` オブジェクトが生成されます。以下は、算術式を引用するために使用される短い形式の例です：

```jldoctest
julia> ex = :(a+b*c+1)
:(a + b * c + 1)

julia> typeof(ex)
Expr
```

（この式の構造を表示するには、`ex.head` と `ex.args` を試すか、上記のように [`dump`](@ref) または [`Meta.@dump`](@ref) を使用してください）

同等の式は、[`Meta.parse`](@ref)を使用するか、直接の`Expr`形式を使用して構築できます:

```jldoctest
julia>      :(a + b*c + 1)       ==
       Meta.parse("a + b*c + 1") ==
       Expr(:call, :+, :a, Expr(:call, :*, :b, :c), 1)
true
```

パーサーによって提供される式は、一般的にシンボル、他の式、およびリテラル値のみを引数として持ちますが、Juliaコードによって構築された式は、リテラル形式なしで任意の実行時値を引数として持つことができます。この特定の例では、`+`と`a`はシンボルであり、`*(b,c)`はサブ式であり、`1`はリテラルの64ビット符号付き整数です。

複数の式を引用するための第二の構文形式があります：`quote ... end` で囲まれたコードのブロック。

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

[`Expr`](@ref) オブジェクトを値引数で直接構築することは強力ですが、`Expr` コンストラクタは「通常の」Julia構文と比べて面倒な場合があります。代わりに、Juliaはリテラルや式を引用された式に*補間*することを許可しています。補間はプレフィックス `$` で示されます。

この例では、変数 `a` の値が補間されています：

```jldoctest interp1
julia> a = 1;

julia> ex = :($a + b)
:(1 + b)
```

未引用の式への補間はサポートされておらず、コンパイル時エラーを引き起こします:

```jldoctest interp1
julia> $a + b
ERROR: syntax: "$" expression outside quote
```

この例では、タプル `(1,2,3)` が条件テストの式として補間されています：

```jldoctest interp1
julia> ex = :(a in $:((1,2,3)) )
:(a in (1, 2, 3))
```

`$`を用いた式の補間は、意図的に[string interpolation](@ref string-interpolation)および[command interpolation](@ref command-interpolation)を思い起こさせるものです。式の補間は、複雑なJulia式をプログラム的に便利かつ読みやすく構築することを可能にします。

### Splatting interpolation

`$` 補間構文は、囲まれた式に単一の式のみを挿入することを許可することに注意してください。時には、式の配列があり、それらすべてを周囲の式の引数にする必要があります。これは `$(xs...)` 構文を使用することで実現できます。たとえば、次のコードは、引数の数がプログラム的に決定される関数呼び出しを生成します：

```jldoctest interp1
julia> args = [:x, :y, :z];

julia> :(f(1, $(args...)))
:(f(1, x, y, z))
```

### Nested quote

当然、引用式が他の引用式を含むことは可能です。これらのケースでの補間の仕組みを理解するのは少し難しいかもしれません。この例を考えてみてください：

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

結果に `$x` が含まれていることに注意してください。これは、`x` がまだ評価されていないことを意味します。言い換えれば、`$` の式は内側の引用式に「属して」おり、その引数は内側の引用式が評価されるときにのみ評価されます。

```jldoctest interp1
julia> eval(e)
quote
    #= none:1 =#
    1 + 2
end
```

しかし、外側の `quote` 式は、内側の引用の `$` 内に値を補間することができます。これは複数の `$` を使って行われます：

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

`(1 + 2)`が結果に表示され、シンボル`x`の代わりになっていることに注意してください。この式を評価すると、補間された`3`が得られます：

```jldoctest interp1
julia> eval(e)
quote
    #= none:1 =#
    3
end
```

この動作の背後にある直感は、`x`が各`$`ごとに一度評価されるということです：1つの`$`は`eval(:x)`と同様に機能し、`x`の値を返しますが、2つの`$`は`eval(eval(:x))`と同等の動作をします。

### [QuoteNode](@id man-quote-node)

ASTにおける`quote`形式の通常の表現は、[`Expr`](@ref)で、ヘッドは`:quote`です。

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

私たちが見たように、そのような表現は `$` を使った補間をサポートしています。しかし、いくつかの状況では、補間を行わずにコードを引用する必要があります。この種の引用にはまだ構文がありませんが、内部的には `QuoteNode` 型のオブジェクトとして表現されています。

```jldoctest interp1
julia> eval(Meta.quot(Expr(:$, :(1+2))))
3

julia> eval(QuoteNode(Expr(:$, :(1+2))))
:($(Expr(:$, :(1 + 2))))
```

パーサーは、シンボルのような単純な引用アイテムに対して `QuoteNode` を生成します:

```jldoctest interp1
julia> dump(Meta.parse(":x"))
QuoteNode
  value: Symbol x
```

`QuoteNode` は、特定の高度なメタプログラミングタスクにも使用できます。

### Evaluating expressions

与えられた式オブジェクトを使用すると、Juliaはグローバルスコープでそれを評価（実行）することができます [`eval`](@ref)：

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

すべての [module](@ref modules) は、それぞれ独自の [`eval`](@ref) 関数を持ち、グローバルスコープ内で式を評価します。 `4d61726b646f776e2e436f64652822222c20226576616c2229_40726566` に渡される式は、値を返すことに限定されず、囲んでいるモジュールの環境の状態を変更する副作用を持つこともあります。

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

ここでは、式オブジェクトの評価がグローバル変数 `x` に値を割り当てる原因となります。

式は単に `Expr` オブジェクトであり、プログラム的に構築して評価することができるため、任意のコードを動的に生成し、[`eval`](@ref) を使用して実行することが可能です。以下は簡単な例です：

```julia-repl
julia> a = 1;

julia> ex = Expr(:call, :+, a, :b)
:(1 + b)

julia> a = 0; b = 2;

julia> eval(ex)
3
```

`a`の値は、値1と変数`b`に`+`関数を適用する式`ex`を構築するために使用されます。`a`と`b`の使われ方の重要な違いに注意してください：

  * 式の構築時における*変数* `a` の値は、式内の即時値として使用されます。したがって、式が評価されるときの `a` の値はもはや重要ではありません：式内の値はすでに `1` であり、`a` の値が何であれ独立しています。
  * 一方で、*シンボル* `:b` は式の構築に使用されるため、その時点での変数 `b` の値は無関係です – `:b` は単なるシンボルであり、変数 `b` が定義されている必要すらありません。しかし、式の評価時には、シンボル `:b` の値は変数 `b` の値を調べることによって解決されます。

### Functions on `Expr`essions

As hinted above, one extremely useful feature of Julia is the capability to generate and manipulate Julia code within Julia itself. We have already seen one example of a function returning [`Expr`](@ref) objects: the [`Meta.parse`](@ref) function, which takes a string of Julia code and returns the corresponding `Expr`. A function can also take one or more `Expr` objects as arguments, and return another `Expr`. Here is a simple, motivating example:

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

別の例として、数値の引数を2倍にする関数を示しますが、式はそのままにします：

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

マクロは、生成されたコードをプログラムの最終的な本体に含めるためのメカニズムを提供します。マクロは、引数のタプルを返される*式*にマッピングし、結果の式はコンパイル時に直接コンパイルされ、ランタイムの [`eval`](@ref) 呼び出しを必要としません。マクロの引数には、式、リテラル値、およびシンボルが含まれる場合があります。

### Basics

ここに非常にシンプルなマクロがあります：

```jldoctest sayhello
julia> macro sayhello()
           return :( println("Hello, world!") )
       end
@sayhello (macro with 1 method)
```

マクロは、Juliaの構文で専用の文字を持っています：`@`（アットサイン）の後に、`macro NAME ... end`ブロックで宣言されたユニークな名前が続きます。この例では、コンパイラはすべての`@sayhello`のインスタンスを次のように置き換えます：

```julia
:( println("Hello, world!") )
```

`@sayhello`がREPLに入力されると、式は即座に実行されるため、評価結果のみが表示されます:

```jldoctest sayhello
julia> @sayhello()
Hello, world!
```

少し複雑なマクロを考えてみましょう：

```jldoctest sayhello2
julia> macro sayhello(name)
           return :( println("Hello, ", $name) )
       end
@sayhello (macro with 1 method)
```

このマクロは1つの引数を取ります: `name`。`@sayhello` が出現すると、引用された式は引数の値を最終的な式に補間するために *展開* されます:

```jldoctest sayhello2
julia> @sayhello("human")
Hello, human
```

引用された戻り値の式は、関数 [`macroexpand`](@ref) を使用して表示できます（**重要な注意:** これはマクロのデバッグに非常に便利なツールです）：

```julia-repl sayhello2
julia> ex = macroexpand(Main, :(@sayhello("human")) )
:(Main.println("Hello, ", "human"))

julia> typeof(ex)
Expr
```

`"human"`リテラルが式に補間されていることがわかります。

[`@macroexpand`](@ref)というマクロも存在し、`macroexpand`関数よりも少し便利かもしれません。

```jldoctest sayhello2
julia> @macroexpand @sayhello "human"
:(println("Hello, ", "human"))
```

### Hold up: why macros?

私たちはすでに前のセクションで `f(::Expr...) -> Expr` という関数を見ました。実際、 [`macroexpand`](@ref) もそのような関数です。では、なぜマクロが存在するのでしょうか？

マクロは、コードが解析されるときに実行されるため、プログラマーがプログラム全体が実行される前にカスタマイズされたコードの断片を生成して含めることを可能にします。この違いを示すために、次の例を考えてみましょう：

```julia-repl whymacros
julia> macro twostep(arg)
           println("I execute at parse time. The argument is: ", arg)
           return :(println("I execute at runtime. The argument is: ", $arg))
       end
@twostep (macro with 1 method)

julia> ex = macroexpand(Main, :(@twostep :(1, 2, 3)) );
I execute at parse time. The argument is: :((1, 2, 3))
```

最初の呼び出し [`println`](@ref) は、[`macroexpand`](@ref) が呼び出されたときに実行されます。結果の式には*のみ*第二の `println` が含まれています:

```julia-repl whymacros
julia> typeof(ex)
Expr

julia> ex
:(println("I execute at runtime. The argument is: ", $(Expr(:copyast, :($(QuoteNode(:((1, 2, 3)))))))))

julia> eval(ex)
I execute at runtime. The argument is: (1, 2, 3)
```

### Macro invocation

マクロは以下の一般的な構文で呼び出されます：

```julia
@name expr1 expr2 ...
@name(expr1, expr2, ...)
```

マクロ名の前にある区別するための `@` と、最初の形式での引数式の間にカンマがないこと、そして2番目の形式での `@name` の後に空白がないことに注意してください。これらの2つのスタイルは混合してはいけません。例えば、以下の構文は上記の例とは異なります。これは、タプル `(expr1, expr2, ...)` をマクロへの1つの引数として渡します：

```julia
@name (expr1, expr2, ...)
```

マクロを配列リテラル（または内包表記）に適用する別の方法は、括弧を使用せずに両者を並べることです。この場合、配列はマクロに供給される唯一の式になります。以下の構文は等価であり（`@name [a b] * v` とは異なります）：

```julia
@name[a b] * v
@name([a b]) * v
```

マクロは引数を式、リテラル、またはシンボルとして受け取ることを強調することが重要です。マクロ引数を探る一つの方法は、マクロ本体内で [`show`](@ref) 関数を呼び出すことです：

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

与えられた引数リストに加えて、すべてのマクロには `__source__` と `__module__` という名前の追加引数が渡されます。

引数 `__source__` は、マクロ呼び出しからの `@` 記号のパーサー位置に関する情報（`LineNumberNode` オブジェクトの形式で）を提供します。これにより、マクロはより良いエラー診断情報を含めることができ、ログ記録、文字列パーサーマクロ、ドキュメントなどで一般的に使用されます。また、[`@__LINE__`](@ref)、[`@__FILE__`](@ref)、および [`@__DIR__`](@ref) マクロを実装するためにも使用されます。

位置情報は `__source__.line` と `__source__.file` を参照することでアクセスできます:

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

引数 `__module__` は、マクロ呼び出しの展開コンテキストに関する情報（`Module` オブジェクトの形式で）を提供します。これにより、マクロは既存のバインディングなどのコンテキスト情報を調べたり、現在のモジュール内で自己反射を行うランタイム関数呼び出しに値を追加の引数として挿入したりすることができます。

### Building an advanced macro

ここに、Juliaの[`@assert`](@ref)マクロの簡略化された定義があります：

```jldoctest building
julia> macro assert(ex)
           return :( $ex ? nothing : throw(AssertionError($(string(ex)))) )
       end
@assert (macro with 1 method)
```

このマクロは次のように使用できます：

```jldoctest building
julia> @assert 1 == 1.0

julia> @assert 1 == 0
ERROR: AssertionError: 1 == 0
```

マクロ呼び出しは、解析時にその返された結果に展開されます。これは、次のように書くことと同等です：

```julia
1 == 1.0 ? nothing : throw(AssertionError("1 == 1.0"))
1 == 0 ? nothing : throw(AssertionError("1 == 0"))
```

つまり、最初の呼び出しでは、式 `:(1 == 1.0)` がテスト条件スロットに挿入され、`string(:(1 == 1.0))` の値がアサーションメッセージスロットに挿入されます。このように構築された全体の式は、`@assert` マクロ呼び出しが行われる構文木に配置されます。実行時に、テスト式が真に評価されると、[`nothing`](@ref) が返されますが、テストが偽の場合は、偽であったアサートされた式を示すエラーが発生します。このように、条件の*値*のみが利用可能であり、それを計算した式をエラーメッセージに表示することは不可能であるため、これを関数として書くことはできないことに注意してください。

`@assert`の実際の定義はJulia Baseではより複雑です。ユーザーは失敗した式を単に印刷するのではなく、オプションで独自のエラーメッセージを指定することができます。可変数の引数を持つ関数と同様に（[Varargs Functions](@ref)）、これは最後の引数の後にエリプシスを指定することで示されます：

```jldoctest assert2
julia> macro assert(ex, msgs...)
           msg_body = isempty(msgs) ? ex : msgs[1]
           msg = string(msg_body)
           return :($ex ? nothing : throw(AssertionError($msg)))
       end
@assert (macro with 1 method)
```

現在、`@assert` は受け取る引数の数に応じて2つの動作モードを持っています！ 引数が1つだけの場合、`msgs` にキャプチャされた式のタプルは空になり、上記の簡単な定義と同じように動作します。しかし、ユーザーが2番目の引数を指定すると、それは失敗した式の代わりにメッセージ本文に印刷されます。マクロ展開の結果を調べるには、適切に名付けられた [`@macroexpand`](@ref) マクロを使用できます：

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

別のケースがあります。実際の `@assert` マクロが処理するのは、"a should equal b" を印刷するだけでなく、それらの値も印刷したい場合です。例えば、カスタムメッセージで文字列補間を使おうとするかもしれませんが、`@assert a==b "a ($a) should equal b ($b)!"` のように書くと、上記のマクロでは期待通りに動作しません。なぜか分かりますか？ [string interpolation](@ref string-interpolation) から思い出してください。補間された文字列は、[`string`](@ref) への呼び出しに書き換えられます。比較してみてください：

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

今や `msg_body` にプレーンな文字列を取得する代わりに、マクロは期待通りに表示するために評価する必要がある完全な式を受け取っています。これは、[`string`](@ref) コールへの引数として返される式に直接スプライスできます。完全な実装については、[`error.jl`](https://github.com/JuliaLang/julia/blob/master/base/error.jl) を参照してください。

`@assert`マクロは、マクロ本体内の式の操作を簡素化するために、引用された式へのスプライシングを大いに活用しています。

### Hygiene

より複雑なマクロで発生する問題の一つは、[hygiene](https://en.wikipedia.org/wiki/Hygienic_macro)です。要するに、マクロは、返される式に導入する変数が、展開される周囲のコードに既存の変数と偶然に衝突しないようにする必要があります。逆に、マクロに引数として渡される式は、周囲のコードの文脈で評価されることが*期待される*ことが多く、既存の変数と相互作用し、変更を加えます。別の懸念は、マクロが定義された場所とは異なるモジュールで呼び出される可能性があるという事実から生じます。この場合、すべてのグローバル変数が正しいモジュールに解決されることを確認する必要があります。Juliaは、テキストマクロ展開（Cのような）を持つ言語に対して大きな利点を持っており、返される式だけを考慮すればよいのです。他のすべての変数（上記の`@assert`の`msg`など）は、[normal scoping block behavior](@ref scope-of-variables)に従います。

これらの問題を示すために、式を引数として受け取り、時間を記録し、式を評価し、再度時間を記録し、前後の時間の差を出力し、最後に式の値を最終値として持つ`@time`マクロを書くことを考えてみましょう。このマクロは次のようになります：

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

ここでは、`t0`、`t1`、および `val` をプライベートな一時変数にし、`time_ns` がユーザーが持っているかもしれない `time_ns` 変数ではなく、Julia Base の [`time_ns`](@ref) 関数を参照するようにしたいと思います（`println` も同様です）。ユーザーの式 `ex` に `t0` という変数への代入が含まれていたり、独自の `time_ns` 変数が定義されていた場合に発生する可能性のある問題を想像してみてください。エラーが発生したり、神秘的に不正確な動作が起こるかもしれません。

Juliaのマクロエクスパンダーは、これらの問題を次のように解決します。まず、マクロの結果内の変数は、ローカルまたはグローバルのいずれかに分類されます。変数は、代入されていて（グローバルとして宣言されていない）、ローカルとして宣言されているか、関数の引数名として使用されている場合、ローカルと見なされます。それ以外の場合は、グローバルと見なされます。ローカル変数は、ユニークになるように名前が変更され（新しいシンボルを生成する[`gensym`](@ref)関数を使用）、グローバル変数はマクロ定義環境内で解決されます。したがって、上記の2つの懸念はどちらも対処されます。マクロのローカルはユーザー変数と衝突せず、`time_ns`と`println`はJulia Baseの定義を参照します。

ただし、1つの問題が残っています。このマクロの次の使用を考えてみてください：

```julia
module MyModule
import Base.@time

time_ns() = ... # compute something

@time time_ns()
end
```

ここでユーザーの式 `ex` は `time_ns` への呼び出しですが、マクロが使用する同じ `time_ns` 関数ではありません。これは明らかに `MyModule.time_ns` を指しています。したがって、`ex` のコードがマクロ呼び出し環境で解決されるように手配する必要があります。これは、式を [`esc`](@ref) で「エスケープ」することによって行われます。

```julia
macro time(ex)
    ...
    local val = $(esc(ex))
    ...
end
```

このようにラップされた式は、マクロ展開器によってそのまま放置され、出力にそのまま貼り付けられます。したがって、マクロ呼び出し環境で解決されます。

このエスケープ機構は、必要に応じて「ハイジーンを侵害」するために使用でき、ユーザー変数を導入または操作することができます。たとえば、次のマクロは呼び出し環境で `x` をゼロに設定します：

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

この種の変数の操作は慎重に使用すべきですが、時には非常に便利です。

ハイジーンルールを正しく理解することは、非常に困難な課題です。マクロを使用する前に、関数クロージャで十分かどうかを考慮することをお勧めします。もう一つの有用な戦略は、可能な限り多くの作業をランタイムに遅延させることです。例えば、多くのマクロは単にその引数を `QuoteNode` やその他の類似の [`Expr`](@ref) にラップします。これには、単に `schedule(Task(() -> $body))` を返す `@task body` や、単に `eval(QuoteNode(expr))` を返す `@eval expr` などの例があります。

上記の `@time` の例を次のように書き換えることができます:

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

しかし、私たちは良い理由があってこれを行いません。`expr`を新しいスコープブロック（無名関数）でラップすることは、式の意味（その中の変数のスコープ）をわずかに変更しますが、私たちは`@time`がラップされたコードに最小限の影響で使用できるようにしたいのです。

### Macros and dispatch

マクロは、ジュリアの関数と同様に、ジェネリックです。これは、複数のメソッド定義を持つことができることを意味し、これは多重ディスパッチのおかげです：

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

ただし、マクロディスパッチは、マクロに渡されるASTの型に基づいていることを念頭に置くべきです。実行時にASTが評価される型ではありません。

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

大量の繰り返しのボイラープレートコードが必要な場合、冗長性を避けるためにプログラム的に生成することが一般的です。ほとんどの言語では、これには追加のビルドステップと、繰り返しのコードを生成するための別のプログラムが必要です。Juliaでは、式の補間と [`eval`](@ref) により、そのようなコード生成がプログラムの実行の通常の過程で行われることができます。たとえば、次のカスタムタイプを考えてみましょう。

```jldoctest mynumber-codegen
struct MyNumber
    x::Float64
end
# output

```

追加したいメソッドの数に対して、以下のループでプログラム的に行うことができます：

```jldoctest mynumber-codegen
for op = (:sin, :cos, :tan, :log, :exp)
    eval(quote
        Base.$op(a::MyNumber) = MyNumber($op(a.x))
    end)
end
# output

```

そして、私たちは今、カスタムタイプでそれらの関数を使用できます：

```jldoctest mynumber-codegen
julia> x = MyNumber(π)
MyNumber(3.141592653589793)

julia> sin(x)
MyNumber(1.2246467991473532e-16)

julia> cos(x)
MyNumber(-1.0)
```

このように、Juliaは独自の [preprocessor](https://en.wikipedia.org/wiki/Preprocessor) として機能し、言語内からのコード生成を可能にします。上記のコードは、`:` プレフィックスの引用形式を使用して、もう少し簡潔に書くことができます。

```julia
for op = (:sin, :cos, :tan, :log, :exp)
    eval(:(Base.$op(a::MyNumber) = MyNumber($op(a.x))))
end
```

この種の言語内コード生成は、`eval(quote(...))`パターンを使用することで一般的であり、Juliaにはこのパターンを短縮するためのマクロが付属しています。

```julia
for op = (:sin, :cos, :tan, :log, :exp)
    @eval Base.$op(a::MyNumber) = MyNumber($op(a.x))
end
```

[`@eval`](@ref) マクロは、この呼び出しを上記の長いバージョンと正確に同等になるように書き換えます。生成されたコードの長いブロックの場合、`4d61726b646f776e2e436f64652822222c2022406576616c2229_40726566` に与えられる式引数はブロックであることができます：

```julia
@eval begin
    # multiple lines
end
```

## [Non-Standard String Literals](@id meta-non-standard-string-literals)

[Strings](@ref non-standard-string-literals)から思い出してください。識別子で接頭辞が付けられた文字列リテラルは非標準文字列リテラルと呼ばれ、接頭辞のない文字列リテラルとは異なる意味を持つことがあります。例えば：

  * `r"^\s*(?:#|$)"` は文字列ではなく、[regular expression object](@ref man-regex-literals) を生成します。
  * `b"DATA\xff\u2200"` は `[68,65,84,65,255,226,136,128]` の [byte array literal](@ref man-byte-array-literals) です。

おそらく驚くべきことに、これらの動作はJuliaのパーサーやコンパイラーにハードコーディングされているわけではありません。代わりに、誰でも使用できる一般的なメカニズムによって提供されるカスタム動作です：接頭辞付き文字列リテラルは、特別に名前付けされたマクロへの呼び出しとして解析されます。たとえば、正規表現マクロは次のようになります：

```julia
macro r_str(p)
    Regex(p)
end
```

それだけです。このマクロは、文字列リテラル `r"^\s*(?:#|$)"` のリテラル内容が `@r_str` マクロに渡され、その展開結果が文字列リテラルが発生する構文木に配置されるべきであることを示しています。言い換えれば、式 `r"^\s*(?:#|$)"` は、次のオブジェクトを構文木に直接配置することと同等です：

```julia
Regex("^\\s*(?:#|\$)")
```

文字列リテラル形式は短く、はるかに便利であるだけでなく、効率も良いです。正規表現はコンパイルされ、`Regex`オブジェクトは実際に*コードがコンパイルされるとき*に作成されるため、コンパイルはコードが実行されるたびに行われるのではなく、一度だけ行われます。正規表現がループ内で発生する場合を考えてみてください：

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

正規表現 `r"^\s*(?:#|$)"` はコンパイルされ、コードが解析されるときに構文木に挿入されるため、この式はループが実行されるたびにコンパイルされるのではなく、一度だけコンパイルされます。これをマクロなしで実現するためには、このループを次のように書く必要があります：

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

さらに、コンパイラが正規表現オブジェクトがすべてのループで定数であることを判断できない場合、特定の最適化が不可能になる可能性があり、このバージョンは上記のより便利なリテラル形式よりも依然として効率が悪くなるかもしれません。もちろん、非リテラル形式がより便利な状況もあります。変数を正規表現に埋め込む必要がある場合、このより冗長なアプローチを取らなければなりません。また、正規表現パターン自体が動的で、各ループの反復ごとに変更される可能性がある場合、各反復で新しい正規表現オブジェクトを構築する必要があります。しかし、ほとんどの使用ケースでは、正規表現は実行時データに基づいて構築されることはありません。この大多数のケースでは、正規表現をコンパイル時の値として記述する能力は非常に貴重です。

ユーザー定義の文字列リテラルのメカニズムは、非常に強力です。ジュリアの非標準リテラルはこれを使用して実装されているだけでなく、コマンドリテラル構文（``` `echo "Hello, $person"` ```）も次の無害に見えるマクロを使用して実装されています：

```julia
macro cmd(str)
    :(cmd_gen($(shell_parse(str)[1])))
end
```

もちろん、このマクロ定義で使用される関数には多くの複雑さが隠れていますが、それらは単なる関数であり、完全にJuliaで書かれています。ソースを読むことができ、彼らが正確に何をしているのかを見ることができます。そして、彼らが行うことはすべて、プログラムの構文木に挿入される式オブジェクトを構築することだけです。

文字列リテラルと同様に、コマンドリテラルも識別子でプレフィックスを付けて、非標準コマンドリテラルと呼ばれるものを形成することができます。これらのコマンドリテラルは、特別に名前付けされたマクロへの呼び出しとして解析されます。例えば、構文 ```custom`literal` ``` は `@custom_cmd "literal"` として解析されます。Julia自体には非標準コマンドリテラルは含まれていませんが、パッケージはこの構文を利用することができます。異なる構文と `_str` サフィックスの代わりに `_cmd` サフィックスがあることを除いて、非標準コマンドリテラルは非標準文字列リテラルとまったく同じように動作します。

モジュールが同じ名前の非標準文字列またはコマンドリテラルを提供する場合、文字列またはコマンドリテラルをモジュール名で修飾することが可能です。たとえば、`Foo` と `Bar` の両方が非標準文字列リテラル `@x_str` を提供している場合、`Foo.x"literal"` または `Bar.x"literal"` と書くことで、両者を区別することができます。

マクロを定義する別の方法は次のようになります：

```julia
macro foo_str(str, flag)
    # do stuff
end
```

このマクロは次の構文で呼び出すことができます：

```julia
foo"str"flag
```

上記の構文でのフラグのタイプは、文字列リテラルの後に続く内容を持つ `String` になります。

## Generated functions

非常に特別なマクロは [`@generated`](@ref) であり、いわゆる *生成関数* を定義することを可能にします。これらは、引数の型に応じて特化したコードを生成する能力を持ち、複数のディスパッチで達成できるよりも柔軟性があり、または少ないコードで実現できます。マクロはパース時に式で動作し、入力の型にアクセスできませんが、生成関数は引数の型が知られている時点で展開されますが、関数はまだコンパイルされていません。

生成された関数宣言は、計算やアクションを実行する代わりに、引用された式を返し、その式が引数の型に対応するメソッドの本体を形成します。生成された関数が呼び出されると、返された式がコンパイルされて実行されます。これを効率的にするために、結果は通常キャッシュされます。また、これを推論可能にするために、使用できる言語のサブセットは限られています。したがって、生成された関数は、許可される構造に対する制限が大きくなる代わりに、実行時からコンパイル時に作業を移動する柔軟な方法を提供します。

生成関数を定義する際には、通常の関数との主な違いが5つあります：

1. 関数宣言に`@generated`マクロを注釈します。これにより、コンパイラがこの関数が生成されたものであることを知るための情報がASTに追加されます。
2. 生成された関数の本体では、引数の*型*にのみアクセスでき、値にはアクセスできません。
3. 何かを計算したり、アクションを実行する代わりに、あなたが望むことを行う*引用された式*を返します。
4. 生成された関数は、生成された関数の定義の*前*に定義された関数のみを呼び出すことが許可されています。（これに従わないと、将来のワールドエイジの関数を参照する`MethodErrors`が発生する可能性があります。）
5. 生成された関数は、非定数のグローバル状態（例えば、IO、ロック、非ローカル辞書、または [`hasmethod`](@ref) を使用することを含む）を*変更*したり*観察*したりしてはいけません。これは、グローバル定数を読み取ることしかできず、副作用を持つことができないことを意味します。言い換えれば、完全に純粋でなければなりません。実装の制限により、現在はクロージャやジェネレーターを定義することもできません。

これは例を使って説明するのが最も簡単です。生成された関数 `foo` を次のように宣言できます。

```jldoctest generated
julia> @generated function foo(x)
           Core.println(x)
           return :(x * x)
       end
foo (generic function with 1 method)
```

注意すべきは、本文が単に `x * x` の値ではなく、引用された式 `:(x * x)` を返すということです。

呼び出し元の視点から見ると、これは通常の関数と同じです。実際、通常の関数を呼び出しているのか生成された関数を呼び出しているのかを知る必要はありません。`foo` がどのように動作するか見てみましょう：

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

生成された関数の本体では、`x`は渡された引数の*型*であり、生成された関数が返す値は、定義から返された引用された式を、今度は`x`の*値*で評価した結果です。

`foo`をすでに使用した型で再評価するとどうなりますか？

```jldoctest generated
julia> foo(4)
16
```

[`Int64`](@ref) の印刷は行われないことに注意してください。生成された関数の本体は、特定の引数の型のセットに対してここで一度だけ実行されたことがわかります。そして、その結果はキャッシュされました。その後、この例では、最初の呼び出しで生成された関数から返された式がメソッド本体として再利用されました。ただし、実際のキャッシュ動作は実装依存のパフォーマンス最適化であるため、この動作に過度に依存することは無効です。

生成された関数が生成される回数は*1回だけ*である可能性もありますが、*それ以上*の回数である可能性や、まったく発生しないように見える可能性もあります。その結果、*副作用*のある生成された関数を書くことは*決して*避けるべきです - 副作用が発生するタイミングや頻度は未定義です。（これはマクロにも当てはまります - そしてマクロと同様に、生成された関数内での [`eval`](@ref) の使用は、あなたが間違った方法で何かをしているサインです。）しかし、マクロとは異なり、ランタイムシステムは `4d61726b646f776e2e436f64652822222c20226576616c2229_40726566` への呼び出しを正しく処理できないため、それは許可されていません。

`@generated` 関数がメソッドの再定義とどのように相互作用するかを見ることも重要です。正しい `@generated` 関数は、可変状態を観察したり、グローバル状態を変更したりしてはならないという原則に従うと、次のような動作が見られます。生成された関数は、生成された関数自体の *定義* の前に定義されていないメソッドを *呼び出すことができない* ことに注意してください。

最初に `f(x)` は一つの定義を持っています。

```jldoctest redefinition
julia> f(x) = "original definition";
```

他の操作を定義する `f(x)`：

```jldoctest redefinition
julia> g(x) = f(x);

julia> @generated gen1(x) = f(x);

julia> @generated gen2(x) = :(f(x));
```

`f(x)`の新しい定義をいくつか追加します:

```jldoctest redefinition
julia> f(x::Int) = "definition for Int";

julia> f(x::Type{Int}) = "definition for Type{Int}";
```

そして、これらの結果がどのように異なるかを比較します：

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

生成された関数の各メソッドは、定義された関数の独自の見方を持っています：

```jldoctest redefinition
julia> @generated gen1(x::Real) = f(x);

julia> gen1(1)
"definition for Type{Int}"
```

生成された関数 `foo` の例は、通常の関数 `foo(x) = x * x` ができること（最初の呼び出し時に型を印刷し、より高いオーバーヘッドがかかることを除いて）を何も行いませんでした。しかし、生成された関数の力は、渡された型に応じて異なる引用された式を計算できる能力にあります。

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

（もちろん、この作り話の例は、複数のディスパッチを使用することでより簡単に実装できますが…）

この使用法はランタイムシステムを破損させ、未定義の動作を引き起こします:

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

生成された関数の本体は非決定的であるため、その動作、*およびその後のすべてのコードの動作*は未定義です。

*これらの例をコピーしないでください！*

これらの例は、生成された関数がどのように機能するかを、定義の側と呼び出しの側の両方で示すのに役立つことを願っています。ただし、*これらをコピーしないでください*。理由は以下の通りです：

  * `foo` 関数は副作用を持っています（`Core.println` の呼び出し）、これらの副作用がいつ、どのくらいの頻度で、または何回発生するかは未定義です。
  * `bar` 関数は、複数のディスパッチで解決した方が良い問題を解決します - `bar(x) = x` と `bar(x::Integer) = x ^ 2` を定義することで同じことができますが、これはよりシンプルで速いです。
  * `baz` 関数は病的です

生成された関数で試みるべきでない操作のセットは無限であり、ランタイムシステムは現在、無効な操作のサブセットのみを検出できます。他にも、通知なしにランタイムシステムを単に破損させる操作が多数存在し、通常は悪い定義に明らかに関連していない微妙な方法で発生します。関数ジェネレーターは推論中に実行されるため、そのコードのすべての制限を尊重しなければなりません。

試みるべきではない操作には、以下が含まれます：

1. ネイティブポインタのキャッシング。
2. `Core.Compiler`の内容やメソッドにいかなる形でも関与すること。
3. 可変状態を観察する。

      * 生成された関数に対する推論は、*任意の*タイミングで実行できます。これには、コードがこの状態を観察または変更しようとしている間も含まれます。
4. ロックを取得すること: 呼び出すCコードは内部でロックを使用する場合があります（例えば、ほとんどの実装が内部でロックを必要とするため、`malloc`を呼び出すことは問題ありません）が、Juliaコードを実行中にロックを保持したり取得したりしないでください。
5. 生成された関数の本体の後に定義された関数を呼び出すこと。これは、モジュール内の任意の関数を呼び出すことを許可するために、インクリメンタルにロードされたプリコンパイル済みモジュールに対して緩和されます。

さて、生成関数の仕組みをよりよく理解したので、これを使ってもう少し高度な（かつ有効な）機能を構築してみましょう...

### An advanced example

Juliaの基本ライブラリには、n次元配列への線形インデックスを計算するための内部`sub2ind`関数があります。これは、n個の多次元インデックスのセットに基づいて、配列`A`に`A[i]`を使用してインデックスを付けるために使用できるインデックス`i`を計算するということです。1つの可能な実装は以下の通りです：

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

再帰を使用して同じことができます：

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

これらの実装は異なりますが、本質的には同じことを行っています。配列の次元に対するランタイムループを実行し、各次元のオフセットを最終インデックスに集めます。

しかし、ループに必要なすべての情報は引数の型情報に埋め込まれています。これにより、コンパイラは反復処理をコンパイル時に移動させ、ランタイムループを完全に排除することができます。生成された関数を利用して同様の効果を達成することができます。コンパイラの用語では、生成された関数を使用して手動でループを展開します。本文はほぼ同じになりますが、線形インデックスを計算する代わりに、インデックスを計算する*式*を構築します：

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

**このコードは何を生成しますか？**

簡単な方法は、本文を別の（通常の）関数に抽出することです：

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

`sub2ind_gen_impl`を実行し、それが返す式を調べることができます:

```jldoctest sub2ind_gen2
julia> sub2ind_gen_impl(Tuple{Int,Int}, Int, Int)
:(((I[1] - 1) + dims[1] * (I[2] - 1)) + 1)
```

ここで使用されるメソッド本体にはループは含まれておらず、2つのタプルへのインデックス付け、乗算、加算/減算のみが行われます。すべてのループ処理はコンパイル時に行われ、実行時にはループを回避します。したがって、ここでは*タイプごとに1回*、この場合は`N`ごとに1回ループします（関数が複数回生成されるエッジケースを除く - 上記の免責事項を参照）。

### Optionally-generated functions

生成された関数は実行時に高い効率を達成できますが、コンパイル時のコストが伴います：具体的な引数の型の組み合わせごとに新しい関数本体を生成する必要があります。通常、Juliaは任意の引数に対して機能する「汎用」バージョンの関数をコンパイルできますが、生成された関数ではこれは不可能です。これは、生成された関数を多用するプログラムが静的にコンパイルできない可能性があることを意味します。

この問題を解決するために、言語は生成された関数の通常の非生成代替実装を書くための構文を提供します。上記の `sub2ind` の例に適用すると、次のようになります：

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

内部的に、このコードは関数の2つの実装を作成します。1つは、`if @generated`の最初のブロックが使用される生成されたもので、もう1つは`else`ブロックが使用される通常のものです。`if @generated`ブロックの`then`部分の中では、コードは他の生成された関数と同じ意味を持ちます：引数名は型を参照し、コードは式を返す必要があります。複数の`if @generated`ブロックが存在する場合、生成された実装はすべての`then`ブロックを使用し、代替実装はすべての`else`ブロックを使用します。

関数の先頭にエラーチェックを追加したことに注意してください。このコードは両方のバージョンで共通であり、両方のバージョンで実行時コードです（生成されたバージョンから式として引用され、返されます）。つまり、ローカル変数の値と型はコード生成時には利用できません。コード生成コードは引数の型のみを見ることができます。

この定義スタイルでは、コード生成機能は本質的にオプションの最適化です。コンパイラは便利な場合にそれを使用しますが、そうでない場合は通常の実装を選択することがあります。このスタイルは好まれます。なぜなら、コンパイラがより多くの決定を下し、プログラムをより多くの方法でコンパイルできるからです。また、通常のコードはコード生成コードよりも読みやすいためです。しかし、どの実装が使用されるかはコンパイラの実装の詳細に依存するため、2つの実装が同一に動作することが不可欠です。
