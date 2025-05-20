# [Documentation](@id man-documentation)

## Accessing Documentation

ドキュメントはREPLまたは[IJulia](https://github.com/JuliaLang/IJulia.jl)で、`?`の後に関数またはマクロの名前を入力し、`Enter`を押すことでアクセスできます。例えば、

```julia
?cos
?@time
?r""
```

関連する関数、マクロ、または文字列マクロのドキュメントを表示します。ほとんどのJulia環境では、ドキュメントに直接アクセスする方法が提供されています：

  * [VS Code](https://www.julia-vscode.org/) は、関数名にマウスを合わせるとドキュメントを表示します。また、サイドバーのJuliaパネルを使用してドキュメントを検索することもできます。
  * [Pluto](https://github.com/fonsp/Pluto.jl)で、右下の「Live Docs」パネルを開いてください。
  * [Juno](https://junolab.org) で `Ctrl-J, Ctrl-D` を使用すると、カーソルの下にあるオブジェクトのドキュメントが表示されます。

`Docs.hasdoc(module, name)::Bool` は、名前にドキュメント文字列があるかどうかを示します。 `Docs.undocumented_names(module; all)` は、モジュール内の未文書の名前を返します。

## Writing Documentation

Juliaは、パッケージ開発者とユーザーが組み込みのドキュメントシステムを通じて関数、型、およびその他のオブジェクトを簡単に文書化できるようにします。

基本的な構文はシンプルです：オブジェクト（関数、マクロ、型、またはインスタンス）の直前に現れる任意の文字列は、それを文書化するものとして解釈されます（これを*docstrings*と呼びます）。docstringと文書化されたオブジェクトの間に空白行やコメントが入ることはできません。以下は基本的な例です：

```julia
"Tell whether there are too foo items in the array."
foo(xs::Array) = ...
```

ドキュメントは [Markdown](https://en.wikipedia.org/wiki/Markdown) と解釈されるため、インデントやコードフェンスを使用してコード例をテキストから区切ることができます。技術的には、任意のオブジェクトをメタデータとして他の任意のオブジェクトに関連付けることができます。Markdownはデフォルトですが、他の文字列マクロを構築し、それを `@doc` マクロに渡すこともできます。

!!! note
    Markdownサポートは`Markdown`標準ライブラリに実装されており、サポートされている構文の完全なリストは[documentation](@ref markdown_stdlib)を参照してください。


ここに、Markdownを使用したより複雑な例があります：

````julia
"""
    bar(x[, y])

Compute the Bar index between `x` and `y`.

If `y` is unspecified, compute the Bar index between all pairs of columns of `x`.

# Examples
```julia-repl
julia> bar([1, 2], [1, 2])
1
```
"""
function bar(x, y) ...
````

上記の例のように、ドキュメントを書く際にはいくつかの簡単な規則に従うことをお勧めします：

1. 常にドキュメントの最上部に関数のシグネチャを表示し、4つのスペースでインデントして、Juliaコードとして印刷されるようにします。

    これは、Juliaコードに存在する署名（例えば `mean(x::AbstractArray)`）と同一であるか、または簡略化された形式である可能性があります。オプション引数は、可能な限りデフォルト値（すなわち `f(x, y=1)`）で表現され、実際のJulia構文に従います。デフォルト値を持たないオプション引数は、括弧内に配置されるべきです（すなわち `f(x[, y])` および `f(x[, y[, z]])`）。別の解決策は、オプション引数のない行と、オプション引数を持つ行を1つずつ使用することです。この解決策は、特定の関数の関連する複数のメソッドを文書化するためにも使用できます。関数が多くのキーワード引数を受け入れる場合、署名には `<keyword arguments>` プレースホルダーのみを含め（すなわち `f(x; <keyword arguments>)`）、`# Arguments` セクションの下に完全なリストを示します（以下のポイント4を参照）。
2. 関数が何をするか、またはオブジェクトが何を表すかを説明する一文を簡略化されたシグネチャブロックの後に含めてください。必要に応じて、空白の段落の後に詳細を提供してください。

    1行の文は、関数を文書化する際に三人称ではなく命令形（「これを実行する」、「それを返す」）を使用する必要があります。文の最後にはピリオドを付けてください。関数の意味を簡単に要約できない場合は、別々の構成可能な部分に分割することが有益です（ただし、これはすべてのケースに対する絶対的な要件とは見なさないでください）。
3. 自分自身を繰り返さないでください。

    関数名はシグネチャによって与えられるため、「関数 `bar`...」で文書を始める必要はありません。要点に直接入ってください。同様に、シグネチャが引数の型を指定している場合、説明でそれらを言及するのは冗長です。
4. 本当に必要な場合にのみ引数リストを提供してください。

    単純な関数の場合、引数の役割を関数の目的の説明に直接記載する方が明確なことが多いです。引数リストは、すでに他の場所で提供されている情報を繰り返すだけです。しかし、引数が多い複雑な関数（特にキーワード引数）に対しては、引数リストを提供することが良いアイデアです。その場合、関数の一般的な説明の後に、`# Arguments` ヘッダーの下に挿入し、各引数に対して `-` バレットを1つ使用します。リストには、引数の型とデフォルト値（ある場合）を記載する必要があります。

    ```julia
    """
    ...
    # Arguments
    - `n::Integer`: the number of elements to compute.
    - `dim::Integer=1`: the dimensions along which to perform the computation.
    ...
    """
    ```
5. 関連する関数へのヒントを提供します。

    関連機能の関数がある場合があります。発見性を高めるために、これらの短いリストを `See also` 段落に提供してください。

    ```
    See also [`bar!`](@ref), [`baz`](@ref), [`baaz`](@ref).
    ```
6. Include any code examples in an `# Examples` section.

    Examples should, whenever possible, be written as *doctests*. A *doctest* is a fenced code block (see [Code blocks](@ref)) starting with ````` ```jldoctest````` and contains any number of `julia>` prompts together with inputs and expected outputs that mimic the Julia REPL.

    !!! note
        Doctestsは[`Documenter.jl`](https://github.com/JuliaDocs/Documenter.jl)によって有効になっています。詳細なドキュメントについては、Documenter's [manual](https://juliadocs.github.io/Documenter.jl/)を参照してください。


    例えば、以下のドキュメンテーション文字列では、変数 `a` が定義され、その後にJulia REPLで表示される期待される結果が示されています。

    ````julia
    """
    Some nice documentation here.

    # Examples
    ```jldoctest
    julia> a = [1 2; 3 4]
    2×2 Array{Int64,2}:
     1  2
     3  4
    ```
    """
    ````

    !!! warning
        `rand` やその他の RNG 関連の関数を doctests で使用することは避けるべきです。なぜなら、異なる Julia セッションで一貫した出力を生成しないからです。ランダムな数生成に関連する機能を示したい場合は、自分の RNG オブジェクトを明示的に構築し、シードを設定することが一つの選択肢です（[`Random`](@ref Random-Numbers) を参照）そして、それをテストしている関数に渡します。

        オペレーティングシステムのワードサイズ（[`Int32`](@ref) または [`Int64`](@ref)）やパスセパレーターの違い（`/` または `\`）も、いくつかのドクトテストの再現性に影響を与えるでしょう。

        注意してください。あなたのドクトテストでは空白が重要です！配列の整形出力の位置がずれると、ドクトテストは失敗します。


    `make -C doc doctest=true` を実行すると、Julia マニュアルと API ドキュメント内のすべてのドクトストを実行でき、あなたの例が正しく動作することを確認できます。

    出力結果が切り捨てられていることを示すために、チェックを停止すべき行に `[...]` と書くことができます。これは、例外がスローされることを示すドクトテストの際に、ジュリアコードの行への一時的な参照を含むスタックトレースを隠すのに便利です。

    ````julia
    ```jldoctest
    julia> div(1, 0)
    ERROR: DivideError: integer division error
    [...]
    ```
    ````

    例外的にテストできないものは、生成されたドキュメントで正しくハイライトされるように、````` ```julia````` で始まるフェンシングコードブロック内に記述する必要があります。

    !!! tip
        可能な限り、例は**自己完結型**で**実行可能**であるべきです。これにより、読者は依存関係を含めることなく、試すことができるようになります。
7. バックティックを使用してコードや数式を識別します。

    Juliaの識別子とコードの抜粋は、ハイライトを有効にするために常にバックティック ``` ` ``` の間に表示されるべきです。LaTeX構文の方程式は、ダブルバックティック ``` `` ``` の間に挿入できます。LaTeXのエスケープシーケンスではなく、Unicode文字を使用してください。つまり、``` ``α = 1`` ``` のように、``` ``\\alpha = 1`` ``` ではなく。
8. Place the starting and ending `"""` characters on lines by themselves.

    それは、書いてください：

    ```julia
    """
    ...

    ...
    """
    f(x, y) = ...
    ```

    むしろ:

    ```julia
    """...

    ..."""
    f(x, y) = ...
    ```

    これにより、ドックストリングの開始と終了がより明確になります。
9. 行の長さ制限を尊重してください。

    ドックストリングはコードと同じツールを使って編集されます。したがって、同じ規則が適用されるべきです。行の幅は最大92文字にすることを推奨します。
10. Provide information allowing custom types to implement the function in an `# Implementation` section. These implementation details are intended for developers rather than users, explaining e.g. which functions should be overridden and which functions automatically use appropriate fallbacks. Such details are best kept separate from the main description of the function's behavior.
11. 長いドキュメンテーション文字列の場合は、`# 拡張ヘルプ` ヘッダーでドキュメントを分割することを検討してください。通常のヘルプモードでは、ヘッダーの上にある資料のみが表示されます。式の先頭に '?' を追加することで、完全なヘルプにアクセスできます（つまり、"?foo" ではなく "??foo" を使用します）。

## Functions & Methods

Juliaの関数は、メソッドとして知られる複数の実装を持つことができます。汎用関数は単一の目的を持つことが良い慣習ですが、必要に応じてメソッドを個別に文書化することがJuliaでは許可されています。一般的に、最も汎用的なメソッドのみを文書化するべきであり、場合によっては関数自体（すなわち、`function bar end`によってメソッドなしで作成されたオブジェクト）を文書化することもあります。特定のメソッドは、より汎用的なものと挙動が異なる場合にのみ文書化されるべきです。いずれにせよ、他の場所で提供されている情報を繰り返すべきではありません。例えば：

```julia
"""
    *(x, y, z...)

Multiplication operator. `x * y * z *...` calls this function with multiple
arguments, i.e. `*(x, y, z...)`.
"""
function *(x, y, z...)
    # ... [implementation sold separately] ...
end

"""
    *(x::AbstractString, y::AbstractString, z::AbstractString...)

When applied to strings, concatenates them.
"""
function *(x::AbstractString, y::AbstractString, z::AbstractString...)
    # ... [insert secret sauce here] ...
end

help?> *
search: * .*

  *(x, y, z...)

  Multiplication operator. x * y * z *... calls this function with multiple
  arguments, i.e. *(x,y,z...).

  *(x::AbstractString, y::AbstractString, z::AbstractString...)

  When applied to strings, concatenates them.
```

汎用関数のドキュメントを取得する際、各メソッドのメタデータは `catdoc` 関数で連結されます。これはもちろん、カスタムタイプのためにオーバーライドすることができます。

## Advanced Usage

`@doc` マクロは、その最初の引数を、モジュールごとの辞書 `META` の中で二番目の引数に関連付けます。

ドキュメントを書くのを容易にするために、パーサーはマクロ名 `@doc` を特別に扱います。`@doc` への呼び出しが1つの引数を持ち、単一の改行の後に別の式が現れる場合、その追加の式はマクロへの引数として追加されます。したがって、次の構文は `@doc` への2引数の呼び出しとして解析されます：

```julia
@doc raw"""
...
"""
f(x) = x
```

これにより、通常の文字列リテラル（`raw""`文字列マクロなど）以外の式をドキュメント文字列として使用することが可能になります。

ドキュメントを取得するために使用される `@doc` マクロ（または同様に `doc` 関数）は、指定されたオブジェクトに関連するメタデータをすべての `META` 辞書から検索し、それを返します。返されたオブジェクト（例えば、いくつかのMarkdownコンテンツ）は、デフォルトで自動的に賢く表示されます。この設計により、異なるバージョンの関数間でドキュメントを再利用するなど、プログラム的にドキュメントシステムを使用することが容易になります。

```julia
@doc "..." foo!
@doc (@doc foo!) foo
```

または、Juliaのメタプログラミング機能と一緒に使用するために：

```julia
for (f, op) in ((:add, :+), (:subtract, :-), (:multiply, :*), (:divide, :/))
    @eval begin
        $f(a, b) = $op(a, b)
    end
end
@doc "`add(a, b)` adds `a` and `b` together" add
@doc "`subtract(a, b)` subtracts `b` from `a`" subtract
```

非トップレベルブロック、例えば `begin`、`if`、`for`、`let`、および内部コンストラクタにおけるドキュメントは、`@doc` を介してドキュメントシステムに追加する必要があります。例えば：

```julia
if condition()
    @doc "..."
    f(x) = x
end
```

`condition()`が`true`のときに`f(x)`にドキュメントを追加します。`f(x)`がブロックの終わりでスコープ外になっても、そのドキュメントは残ることに注意してください。

メタプログラミングを利用してドキュメントの作成を支援することが可能です。ドックストリング内で文字列補間を使用する場合は、`$($name)`のように追加の`$`を使用する必要があります。

```julia
for func in (:day, :dayofmonth)
    name = string(func)
    @eval begin
        @doc """
            $($name)(dt::TimeType) -> Int64

        The day of month of a `Date` or `DateTime` as an `Int64`.
        """ $func(dt::Dates.TimeType)
    end
end
```

### Dynamic documentation

時には、型のインスタンスに対する適切なドキュメントが、そのインスタンスのフィールド値に依存し、単に型自体に依存しないことがあります。このような場合、カスタム型のために `Docs.getdoc` にメソッドを追加して、インスタンスごとにドキュメントを返すことができます。例えば、

```julia
struct MyType
    value::Int
end

Docs.getdoc(t::MyType) = "Documentation for MyType with value $(t.value)"

x = MyType(1)
y = MyType(2)
```

`?x` は「値 1 の MyType のドキュメント」を表示し、`?y` は「値 2 の MyType のドキュメント」を表示します。

## Syntax Guide

このガイドは、ドキュメントを提供できるすべてのJulia構文にドキュメントを添付する方法の包括的な概要を提供します。

以下の例では、`"..."`は任意のドックストリングを示すために使用されています。

### `$` and `\` characters

`$` と `\` 文字は、ドキュメント文字列でも文字列補間やエスケープシーケンスの開始として解析されます。 `raw""` 文字列マクロと `@doc` マクロを組み合わせることで、これらをエスケープする必要がなくなります。これは、ドキュメント文字列に LaTeX や Julia のソースコード例が含まれている場合に便利です。

````julia
@doc raw"""
```math
\LaTeX
```
"""
function f end
````

### Functions and Methods

```julia
"..."
function f end

"..."
f
```

関数 `f` にドックストリング `"..."` を追加します。最初のバージョンが推奨される構文ですが、どちらも同等です。

```julia
"..."
f(x) = x

"..."
function f(x)
    return x
end

"..."
f(x)
```

`f(::Any)` メソッドにドックストリング `"..."` を追加します。

```julia
"..."
f(x, y = 1) = x + y
```

`f(::Any)` と `f(::Any, ::Any)` の2つの `Method` にドックストリング `"..."` を追加します。

### Macros

```julia
"..."
macro m(x) end
```

`@m(::Any)` マクロ定義にドックストリング `"..."` を追加します。

```julia
"..."
:(@m1)

"..."
macro m2 end
```

`@m1` と `@m2` というマクロにドックストリング `"..."` を追加します。

### Types

```
"..."
abstract type T1 end

"..."
mutable struct T2
    ...
end

"..."
struct T3
    ...
end
```

`T1`、`T2`、および `T3` にドックストリング `"..."` を追加します。

```
"..."
T1

"..."
T2

"..."
T3
```

タイプ `T1`、`T2`、および `T3` にドックストリング `"..."` を追加します。以前のバージョンが推奨される構文ですが、両者は同等です。

```julia
"..."
struct T
    "x"
    x
    "y"
    y

    @doc "Inner constructor"
    function T()
        new(...)
    end
end
```

`T`にドックストリング`"..."`を追加し、フィールド`T.x`に`"x"`を、フィールド`T.y`に`"y"`を、内部コンストラクタ`T()`に`"Inner constructor"`を追加します。`mutable struct`型にも適用可能です。

### Modules

```julia
"..."
module M end

module M

"..."
M

end
```

`Module` `M` にドックストリング `"..."` を追加します。ドックストリングを `Module` の上に追加するのが推奨される構文ですが、どちらも同等です。

```julia
"..."
baremodule M
# ...
end

baremodule M

import Base: @doc

"..."
f(x) = x

end
```

`baremodule`をドキュメント化するために、式の上にドックストリングを置くと、`@doc`が自動的にモジュールにインポートされます。モジュール式がドキュメント化されていない場合、これらのインポートは手動で行う必要があります。

### Global Variables

```julia
"..."
const a = 1

"..."
b = 2

"..."
global c = 3
```

`Binding`の`a`、`b`、および`c`にドックストリング`"..."`を追加します。

`Binding`は、参照される値自体を保存することなく、`Module`内の特定の`Symbol`への参照を保存するために使用されます。

!!! note
    `const` 定義が他の定義のエイリアスを定義するためだけに使用される場合、例えば `Base` における関数 `div` とそのエイリアス `÷` の場合、エイリアスを文書化せず、実際の関数を文書化してください。

    エイリアスが文書化されていて、実際の定義ではない場合、docsystem（`?`モード）は、実際の定義が検索されたときにエイリアスに添付されたドックストリングを返しません。

    例えば、次のように書くべきです。

    ```julia
    "..."
    f(x) = x + 1
    const alias = f
    ```

    むしろ

    ```julia
    f(x) = x + 1
    "..."
    const alias = f
    ```


```julia
"..."
sym
```

`sym`に関連付けられた値にドックストリング`"..."`を追加します。ただし、`sym`は定義されている場所で文書化されることが望ましいです。

### Multiple Objects

```julia
"..."
a, b
```

`a` と `b` にそれぞれドキュメント可能な式である `"..."` というドックストリングを追加します。この構文は次のものと同等です。

```julia
"..."
a

"..."
b
```

この方法で任意の数の式を一緒に文書化することができます。この構文は、非変異バージョンと変異バージョン `f` と `f!` のように、2つの関数が関連している場合に便利です。

### Macro-generated code

```julia
"..."
@m expression
```

`@m`式を展開することによって生成された式にドックストリング`"..."`を追加します。これにより、`@inline`、`@noinline`、`@generated`、またはその他のマクロで装飾された式も、装飾されていない式と同様に文書化できるようになります。

マクロの作者は、単一の式を生成するマクロのみが自動的にドキュメント文字列をサポートすることに注意する必要があります。マクロが複数のサブ式を含むブロックを返す場合、ドキュメント化すべきサブ式は [`@__doc__`](@ref Core.@__doc__) マクロを使用してマークする必要があります。

[`@enum`](@ref) マクロは、`@__doc__` を利用して [`Enum`](@ref) のドキュメントを作成することを可能にします。その定義を調べることで、`@__doc__` を正しく使用する方法の例となるでしょう。

```@docs
Core.@__doc__
```
