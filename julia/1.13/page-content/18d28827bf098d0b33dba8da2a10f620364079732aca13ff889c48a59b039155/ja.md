# [Documentation](@id man-documentation)

## Accessing Documentation

REPL または [IJulia](https://github.com/JuliaLang/IJulia.jl) では、`?` に続けて関数名またはマクロ名を入力し、`Enter` を押すと、ドキュメントを参照できます。たとえば、

```julia
?cos
?@time
?r""
```

と入力すると、それぞれ該当する関数、マクロ、文字列マクロのドキュメントが表示されます。ほとんどの Julia 環境では、ドキュメントを直接参照する方法が用意されています。

  * [VS Code](https://www.julia-vscode.org/) では、関数名にカーソルを合わせるとドキュメントが表示されます。サイドバーの Julia パネルからドキュメントを検索することもできます。
  * [Pluto](https://github.com/fonsp/Pluto.jl) では、右下にある「Live Docs」パネルを開きます。
  * [Juno](https://junolab.org) では、`Ctrl-J, Ctrl-D` を使うと、カーソル位置にあるオブジェクトのドキュメントが表示されます。

`Docs.hasdoc(module, name)::Bool` は、名前に docstring があるかどうかを調べます。`Docs.undocumented_names(module; all)` は、モジュール内でドキュメント化されていない名前を返します。

## [Writing Documentation](@id man-writing-documentation)

Julia には組み込みのドキュメントシステムがあり、パッケージの開発者やユーザーは、関数、型、その他のオブジェクトを簡単にドキュメント化できます。

基本的な構文はシンプルです。オブジェクト（関数、マクロ、型、インスタンス）の直前にある文字列は、そのオブジェクトのドキュメントとして解釈されます（このような文字列を *docstring* と呼びます）。docstring とドキュメント対象のオブジェクトの間に空行やコメントを挟むことはできません。基本的な例を示します。

```julia
"Tell whether there are too many foo items in the array."
foo(xs::Array) = ...
```

!!! note "注意"
    docstring とドキュメント対象のオブジェクトの間に空行があると、両者の関連付けが解除され、docstring は機能しなくなります。


ドキュメントは [Markdown](https://en.wikipedia.org/wiki/Markdown) として解釈されるため、インデントやコードフェンスを使って、コード例とテキストを区切ることができます。技術的には、任意のオブジェクトをメタデータとして別のオブジェクトに関連付けられます。Markdown がデフォルトですが、別の文字列マクロを作成し、同様に `@doc` マクロに渡すこともできます。

!!! note
    Markdown のサポートは標準ライブラリ `Markdown` で実装されています。サポートされている構文の一覧は、[documentation](@ref markdown_stdlib) を参照してください。


以下に、Markdown を使った、より複雑な例を示します。

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

上の例と同様に、ドキュメントを書く際は、次の簡単な慣例に従うことをお勧めします。

1. ドキュメントの先頭には、関数のシグネチャを必ず記載します。Julia コードとして表示されるよう、4 つのスペースでインデントしてください。

   Julia コードに記載されているシグネチャ（たとえば `mean(x::AbstractArray)`）と同じものでも、簡略化した形式でもかまいません。可能であれば、オプション引数は実際の Julia 構文に従い、デフォルト値（たとえば `f(x, y=1)`）を示してください。デフォルト値のないオプション引数は、角括弧で囲みます（たとえば `f(x[, y])` や `f(x[, y[, z]])`）。別の方法として、オプション引数なしの行と、オプション引数ありの行を複数記載することもできます。この方法は、ある関数の関連する複数のメソッドをドキュメント化する場合にも使えます。キーワード引数を多数受け取る関数では、シグネチャには `<keyword arguments>` のプレースホルダーだけを記載し（たとえば `f(x; <keyword arguments>)`）、引数の完全な一覧は `# Arguments` セクションに記載してください（下記の項目 4 を参照）。

   戻り値の型を記載する場合や、戻り値に名前を付ける場合は、次の形式を使います。

   ```julia
   # Naming the return value or its type is not necessary (this is the most common case)
   """
      sum(itr; [init])

   ...
   """

   # The return type is easily documented and critical to the semantics of this function
   """
      vec(x::AbstractArray)::AbstractVector

   ...
   """

   # Naming and/or destructuring the return value clarifies the semantics of this function
   """
      splitdir(path::AbstractString) -> (dir::AbstractString, file::AbstractString)
   ...
   """
   ```

   戻り値の型を記載する場合は、シグネチャの後に `::` を置いて区切ります。戻り値に名前を付ける場合は、両側にスペースを入れて `->` で区切ります。可能であれば、戻り値の型と戻り値は有効な Julia 式にしてください。戻り値の型や戻り値を注釈するマクロの docstring シグネチャでは、マクロ引数の終わりと戻り値の型または戻り値の始まりを明確にするため、括弧を使ってください。
2. 簡略化したシグネチャブロックの後に、関数の動作またはオブジェクトが表すものを説明する一文を記載します。必要であれば、空行を挟んで2つ目の段落に詳細を記載してください。

   関数をドキュメント化する場合、この一文では三人称ではなく命令形（「これを実行する」「それを返す」など）を使います（「長さを返す」のような書き方は避けてください）。文末にはピリオドを付けます。関数の意味を簡潔にまとめるのが難しい場合は、組み合わせ可能な複数の部分に分割するとよいでしょう（ただし、すべての場合に必須というわけではありません）。
3. 同じ内容を繰り返さないでください。

   関数名はシグネチャに記載されているため、ドキュメントを「関数 `bar` は……」で始める必要はありません。要点から書き始めてください。同様に、シグネチャで引数の型が指定されている場合、説明でその型に言及するのは冗長です。
4. 本当に必要な場合に限り、引数の一覧を記載してください。

   単純な関数では、引数の役割を関数の目的の説明に直接含めるほうが明確なことがよくあります。引数の一覧を追加しても、すでに記載した情報を繰り返すだけです。一方、引数が多い複雑な関数（特にキーワード引数を多く持つ関数）では、引数の一覧が役立つことがあります。その場合は、関数の概要説明の後に `# Arguments` 見出しを置き、引数ごとに `-` の箇条書きを1つ記載します。各項目には、引数の型とデフォルト値（ある場合）を記載してください。

   ```julia
   """
   ...
   # Arguments
   - `n::Integer`: the number of elements to compute.
   - `dim::Integer=1`: the dimensions along which to perform the computation.
   ...
   """
   ```
5. 関連する関数への手がかりを示してください。

   関連する機能を持つ関数がある場合があります。見つけやすくするため、`See also` 段落に、それらの関数を簡潔に列挙してください。

   ```
   See also [`bar!`](@ref), [`baz`](@ref), [`baaz`](@ref).
   ```
6. コード例は `# Examples` セクションに記載してください。

   可能な場合は、例を *doctest* として記述してください。*doctest* とは、[Code blocks](@ref) を参照するフェンス付きコードブロックで、先頭に ````` ```jldoctest````` を記載し、Julia REPL を模した入力と期待される出力を含む `julia>` プロンプトを任意の数だけ記述したものです。

   !!! note
       doctest は [`Documenter.jl`](https://github.com/JuliaDocs/Documenter.jl) によって有効になります。詳しくは、Documenter の [manual](https://juliadocs.github.io/Documenter.jl/) を参照してください。

   たとえば、次の docstring では変数 `a` を定義し、その後に Julia REPL で表示される期待される結果を示しています。

   ````julia
   """
   Some nice documentation here.

   # Examples
   ```jldoctest
   julia> a = [1 2; 3 4]
   2×2 Matrix{Int64}:
    1  2
    3  4
   ```
   """
   ````

   !!! warning
       `rand` やその他の RNG 関連関数は、異なる Julia セッション間で出力が一定にならないため、doctest では呼び出さないでください。乱数生成に関する機能を示したい場合は、独自の RNG オブジェクトを明示的に作成してシードを設定し（[`Random`](@ref Random-Numbers) を参照）、doctest の対象となる関数に渡す方法があります。

       OS のワードサイズ（[`Int32`](@ref) または [`Int64`](@ref)）やパス区切り文字の違い（`/` または `\`）も、一部の doctest の再現性に影響します。

       doctest では空白文字も重要です。たとえば、配列の整形出力の位置がずれていると、doctest は失敗します。

   Julia のマニュアルと API ドキュメントにあるすべての doctest を実行するには、`make -C doc doctest=true` を実行します。これにより、例が正しく動作することを確認できます。

   出力結果が途中で切り詰められていることを示すには、確認を終了する行に `[...]` を記載します。たとえば、例外が発生することを示す doctest で、スタックトレース（Julia コードの行番号など、固定されない参照を含む）を隠す場合に便利です。

   ````julia
   ```jldoctest
   julia> div(1, 0)
   ERROR: DivideError: integer division error
   [...]
   ```
   ````

   テストできない例は、生成されたドキュメントで正しくハイライトされるよう、````` ```julia````` で始まるフェンス付きコードブロックに記載してください。

   !!! tip
       可能な限り、例は**自己完結型**で、**実行可能**なものにしてください。そうすれば、読者は依存関係を追加せずに試すことができます。
7. コードや数式を示すにはバッククォートを使ってください。

   Julia の識別子やコードの抜粋は、ハイライトできるよう、必ずバッククォート ``` ` ``` で囲んでください。LaTeX 構文の数式は、二重バッククォート ``` `` ``` で囲みます。LaTeX のエスケープシーケンスではなく Unicode 文字を使ってください。たとえば、``` ``\\alpha = 1`` ``` ではなく ``` ``α = 1`` ``` を使います。
8. 開始と終了を示す `"""` 文字は、それぞれ単独の行に置いてください。

   つまり、次のように記述します。

   ```julia
   """
   ...

   ...
   """
   f(x, y) = ...
   ```

   次のようには記述しません。

   ```julia
   """...

   ..."""
   f(x, y) = ...
   ```

   こうすると、docstring の開始位置と終了位置が明確になります。
9. 周囲のコードで使われている行の長さ制限を守ってください。

   docstring もコードと同じツールで編集します。そのため、同じ慣例を適用してください。1行は最大92文字にすることを推奨します。
10. カスタム型が関数を実装するために必要な情報を、`# Implementation` セクションに記載してください。こうした実装の詳細はユーザーではなく開発者を対象とし、たとえば、どの関数をオーバーライドすべきか、どの関数が適切なフォールバックを自動的に使うかを説明します。これらの詳細は、関数の動作に関する主な説明とは分けて記載するのが最適です。
11. 長い docstring は、`# Extended help` 見出しを使って分割することを検討してください。通常のヘルプモードでは見出しより上の内容だけが表示されます。式の先頭に「?」を追加すると、ヘルプ全体を参照できます（たとえば「?foo」ではなく「??foo」と入力します）。

## Functions & Methods

Julia の関数には、メソッドと呼ばれる複数の実装が存在する場合があります。ジェネリック関数は単一の目的を持つのが望ましいものの、必要に応じて各メソッドを個別にドキュメント化できます。一般には、最も汎用的なメソッドだけをドキュメント化するか、関数自体（つまり、`function bar end` によってメソッドなしで作成されたオブジェクト）をドキュメント化してください。特定のメソッドを個別にドキュメント化するのは、より汎用的なメソッドと動作が異なる場合に限ります。いずれの場合も、ほかの場所ですでに説明されている情報を繰り返さないでください。たとえば、次のようになります。

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

ジェネリック関数のドキュメントを取得すると、各メソッドのメタデータは `catdoc` 関数によって連結されます。この関数は、もちろんカスタム型向けにオーバーライドできます。

## Advanced Usage

`@doc` マクロは、第1引数を第2引数に関連付け、モジュールごとの辞書 `META` に格納します。

ドキュメントを書きやすくするため、パーサーはマクロ名 `@doc` を特別に扱います。`@doc` の呼び出しに引数が1つあり、その後に1つの改行を挟んで別の式が続く場合、その式はマクロの引数として追加されます。そのため、次の構文は `@doc` を2引数で呼び出すものとして解析されます。

```julia
@doc raw"""
...
"""
f(x) = x
```

これにより、通常の文字列リテラル以外の式（たとえば `raw""` 文字列マクロ）も docstring として使えます。

ドキュメントを取得する際、`@doc` マクロ（または同等の `doc` 関数）は、すべての `META` 辞書を検索し、指定されたオブジェクトに関連するメタデータを返します。返されたオブジェクト（たとえば Markdown コンテンツ）は、デフォルトで適切な形式に表示されます。この設計により、ドキュメントシステムをプログラムから簡単に利用できます。たとえば、関数の異なるバージョン間でドキュメントを再利用できます。

```julia
@doc "..." foo!
@doc (@doc foo!) foo
```

!!! compat "Julia 1.11"
    Julia 1.11 以降では、`@doc` マクロを使ってドキュメントを取得するには、`REPL` 標準ライブラリを読み込む必要があります。


また、Julia のメタプログラミング機能と組み合わせて使うこともできます。

```julia
for (f, op) in ((:add, :+), (:subtract, :-), (:multiply, :*), (:divide, :/))
    @eval begin
        $f(a, b) = $op(a, b)
    end
end
@doc "`add(a, b)` adds `a` and `b` together" add
@doc "`subtract(a, b)` subtracts `b` from `a`" subtract
```

`begin`、`if`、`for`、`let`、内部コンストラクターなど、トップレベル以外のブロックにあるドキュメントも、`@doc` を使ってドキュメントシステムに追加する必要があります。たとえば、次のようにします。

```julia
if condition()
    @doc "..."
    f(x) = x
end
```

これにより、`condition()` が `true` の場合に、`f(x)` にドキュメントが追加されます。ブロックの終わりで `f(x)` がスコープ外になっても、そのドキュメントは残ります。

メタプログラミングを利用して、ドキュメントの作成を補助することもできます。docstring 内で文字列補間を使う場合は、`$($name)` の例に示すように、`$` をもう1つ追加する必要があります。

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

型のインスタンスに適切なドキュメントを付ける際、型そのものだけでなく、そのインスタンスのフィールド値に応じて内容を変える必要がある場合があります。その場合は、カスタム型に対して `Docs.getdoc` のメソッドを追加し、インスタンスごとにドキュメントを返すことができます。たとえば、

```julia
struct MyType
    value::Int
end

Docs.getdoc(t::MyType) = "Documentation for MyType with value $(t.value)"

x = MyType(1)
y = MyType(2)
```

`?x` は「Documentation for MyType with value 1」を表示し、`?y` は「Documentation for MyType with value 2」を表示します。

## Syntax Guide

このガイドでは、ドキュメントを付けられるすべての Julia 構文要素にドキュメントを関連付ける方法を、包括的に説明します。

以下の例では、任意の docstring を表すために `"..."` を使います。

### `$` and `\` characters

`$` 文字と `\` 文字は、docstring 内でも文字列補間またはエスケープシーケンスの開始として解析されます。これらをエスケープせずに使うには、`raw""` 文字列マクロと `@doc` マクロを組み合わせて使えます。docstring に LaTeX や、補間を含む Julia ソースコードの例を記載する場合に便利です。

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

関数 `f` に docstring `"..."` を追加します。最初の形式が推奨されますが、どちらも同等です。

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

メソッド `f(::Any)` に docstring `"..."` を追加します。

```julia
"..."
f(x, y = 1) = x + y
```

2つの `Method`、すなわち `f(::Any)` と `f(::Any, ::Any)` に docstring `"..."` を追加します。

### Macros

```julia
"..."
macro m(x) end
```

マクロ定義 `@m(::Any)` に docstring `"..."` を追加します。

```julia
"..."
:(@m1)

"..."
macro m2 end
```

`@m1` と `@m2` という名前のマクロに、docstring `"..."` を追加します。

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

型 `T1`、`T2`、`T3` に docstring `"..."` を追加します。

```
"..."
T1

"..."
T2

"..."
T3
```

型 `T1`、`T2`、`T3` に docstring `"..."` を追加します。前の形式が推奨されますが、どちらも同等です。

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

型 `T` に docstring `"..."` を、フィールド `T.x` に `"x"` を、フィールド `T.y` に `"y"` を、内部コンストラクター `T()` に `"Inner constructor"` を追加します。`mutable struct` 型にも適用できます。

### Modules

```julia
"..."
module M end

module M

"..."
M

end
```

`M` `Module` に docstring `"..."` を追加します。`Module` の上に docstring を置く形式が推奨されますが、どちらも同等です。

モジュールの docstring はモジュールのスコープ*内*で評価されるため、そのモジュールで定義またはインポートされたすべてのシンボルを利用できます。

```julia
"The magic number is $(MAGIC)."
module DocStringEval
const MAGIC = 42
end
```

式の上に docstring を置いて `baremodule` をドキュメント化すると、`@doc` が自動的にモジュールにインポートされます。モジュール式をドキュメント化しない場合は、これらのインポートを手動で行う必要があります。

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

### Global Variables

```julia
"..."
const a = 1

"..."
b = 2

"..."
global c = 3
```

`a`、`b`、`c` の各 `Binding` に docstring `"..."` を追加します。

`Binding` は、参照先の値そのものを格納せずに、`Module` 内の特定の `Symbol` への参照を保持するために使われます。

!!! note
    `const` の定義が、別の定義のエイリアスを作るためだけに使われている場合（たとえば、`Base` にある関数 `div` とそのエイリアス `÷` のような場合）、エイリアスではなく実際の関数をドキュメント化してください。

    エイリアスをドキュメント化し、実際の定義をドキュメント化しないと、実際の定義を検索したときに、docsystem（`?` モード）はエイリアスに付けられた docstring を返しません。

    たとえば、次のように記述します。

    ```julia
    "..."
    f(x) = x + 1
    const alias = f
    ```

    次のようには記述しません。

    ```julia
    f(x) = x + 1
    "..."
    const alias = f
    ```


```julia
"..."
sym
```

`sym` に関連付けられた値に docstring `"..."` を追加します。ただし、`sym` は定義箇所でドキュメント化することを推奨します。

### Multiple Objects

```julia
"..."
a, b
```

それぞれドキュメント化可能な式である `a` と `b` に、docstring `"..."` を追加します。この構文は、次の構文と同等です。

```julia
"..."
a

"..."
b
```

この方法では、任意の数の式をまとめてドキュメント化できます。たとえば、非破壊版と破壊版の `f` と `f!` のように、関連する2つの関数を扱う場合に便利です。

### Macro-generated code

```julia
"..."
@m expression
```

`@m expression` を展開して生成される式に、docstring `"..."` を追加します。これにより、`@inline`、`@noinline`、`@generated`、その他のマクロで修飾された式も、修飾されていない式と同じ方法でドキュメント化できます。

マクロの作成者は、単一の式を生成するマクロだけが docstring を自動的にサポートする点に注意してください。複数の部分式を含むブロックを返すマクロでは、ドキュメント化する部分式を [`@__doc__`](@ref Core.@__doc__) マクロで指定する必要があります。

[`@enum`](@ref) マクロは、`@__doc__` を使って [`Enum`](@ref) のドキュメント化を可能にしています。その定義を調べると、`@__doc__` の正しい使い方を理解する参考になります。

```@docs
Core.@__doc__
```
