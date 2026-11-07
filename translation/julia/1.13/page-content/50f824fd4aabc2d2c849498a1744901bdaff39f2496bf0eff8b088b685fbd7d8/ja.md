# [Modules](@id modules)

Juliaでは、モジュールを使ってコードをまとまりのある単位に整理できます。モジュールは構文上、`module NameOfModule ... end`の中に定義され、次のような特徴があります。

1. モジュールはそれぞれ独立した名前空間であり、新しいグローバルスコープを導入します。そのため、別々のモジュールにあれば、同じ名前を異なる関数やグローバル変数に使っても衝突しません。
2. モジュールには、名前空間を細かく管理する機能があります。それぞれが`export`する名前の集合を定義し、それらを`public`として指定できます。また、`using`や`import`を使って、ほかのモジュールから名前をインポートできます（詳しくは後述します）。
3. モジュールは読み込みを高速化するために事前コンパイルでき、実行時の初期化コードを含めることもできます。

一般に、大規模なJuliaパッケージでは、モジュールのコードは複数のファイルに分けて整理されています。たとえば、次のようになります。

```julia
module SomeModule

# export, public, using, import statements are usually here; we discuss these below

include("file1.jl")
include("file2.jl")

end
```

ファイルやファイル名とモジュールとの関係は、ほとんどありません。モジュールはモジュール式によってのみ定義されます。1つのモジュールを複数のファイルに分けることも、1つのファイルに複数のモジュールを定義することもできます。`include`は、ソースファイルの内容が、読み込み先モジュールのグローバルスコープで評価されたかのように動作します。この章では短く簡略化した例を使うため、`include`は使いません。

モジュール本体はインデントしないのが推奨されるスタイルです。インデントすると、通常はファイル全体をインデントすることになるためです。また、モジュール名には（型名と同様に）`UpperCamelCase`を使うのが一般的です。該当する場合、特にモジュール内に似た名前の識別子がある場合は、名前の衝突を避けるため複数形を使います。たとえば、次のようになります。

```julia
module FastThings

struct FastThing
    ...
end

end
```

## [Namespace management](@id namespace-management)

名前空間管理とは、あるモジュール内の名前をほかのモジュールから利用できるようにするための言語機能を指します。関連する概念と機能について、以下で詳しく説明します。

### Qualified names

`sin`、`ARGS`、`UnitRange`のように、グローバルスコープにある関数、変数、型の名前は、必ずいずれかのモジュールに属します。このモジュールを*親モジュール*と呼びます。たとえば、対話的に[`parentmodule`](@ref)を使うと、親モジュールを確認できます。

```jldoctest
julia> parentmodule(UnitRange)
Base
```

親モジュールの外から名前を参照するには、モジュール名を前に付けます。たとえば、`Base.UnitRange`のようにします。これを*修飾名*と呼びます。親モジュールには、`Base.Math.sin`のようにサブモジュールをたどってアクセスできる場合があります。このとき、`Base.Math`を*モジュールパス*と呼びます。構文上の曖昧さがあるため、演算子など、記号だけで構成される名前を修飾するには、コロンを挿入する必要があります。たとえば、`Base.:+`のようにします。また、一部の演算子では括弧も必要です。たとえば、`Base.:(==)`のようにします。

名前を修飾すれば、常にその名前を利用できます。また、関数の場合は、修飾名を関数名として使ってメソッドを追加することもできます。

モジュール内では、変数名を`global x`として宣言することで、値を代入せずに「予約」できます。これにより、読み込み後に初期化されるグローバル変数との名前の衝突を防げます。`M.x = y`という構文を使って、別のモジュールにあるグローバル変数に代入することはできません。グローバル変数への代入は、常にモジュール内で行われます。

### Export lists

関数、型、グローバル変数、定数などの名前は、`export`を使ってモジュールの*エクスポートリスト*に追加できます。これらは、モジュールを`using`したときにインポートされる名前です。通常、ソースコードを読む人が見つけやすいよう、モジュール定義の先頭付近に記述します。たとえば、次のようになります。

```jldoctest module_manual
julia> module NiceStuff
       export nice, DOG
       struct Dog end      # singleton type, not exported
       const DOG = Dog()   # named instance, exported
       nice(x) = "nice $x" # function, exported
       end;

```

ただし、これはあくまでスタイル上の提案です。モジュール内の任意の場所に、複数の`export`文を記述できます。

API（アプリケーションプログラミングインターフェース）の一部となる名前をエクスポートするのが一般的です。上のコードでは、利用者が`nice`と`DOG`を使うことを、エクスポートリストで示しています。ただし、修飾名を使えば常に識別子を利用できるため、これはAPIを整理するための選択肢にすぎません。ほかの言語とは異なり、Juliaにはモジュール内部を完全に隠す機能はありません。

また、名前をまったくエクスポートしないモジュールもあります。これは通常、APIで`derivative`のような一般的な単語を使っていて、ほかのモジュールのエクスポートリストと衝突しやすい場合に行われます。名前の衝突を管理する方法については、後述します。

`using NiceStuff`を呼び出す側の名前空間にエクスポートせずに、名前を公開名として示すには、`export`の代わりに`public`を使います。これにより、その公開名が公開APIの一部であることを示せますが、名前空間には影響しません。`public`キーワードが使えるのはJulia 1.11以降です。Julia 1.10以前との互換性を保つには、[Compat](https://github.com/JuliaLang/Compat.jl)パッケージの`@compat`マクロを使うか、バージョンに応じて次のように記述します。

```julia
VERSION >= v"1.11.0-DEV.469" && eval(Meta.parse("public a, b, c"))
```

`export`は、どこに書かれていてもキーワードとして扱われます。一方、`public`キーワードを使えるのは、現在のところファイルまたはモジュール内の構文上のトップレベルに限られます。この制限は互換性のために設けられています。`public`はJulia 1.11で新しいキーワードとして導入されましたが、`export`はJulia 1.0から存在しているためです。ただし、今後のリリースで`public`に対するこの制限が解除される可能性があるため、`public`を識別子として使わないでください。

### Standalone `using` and `import`

対話的にモジュールを読み込む最も一般的な方法は、`using ModuleName`です。この[loads](@ref code-loading)は、`ModuleName`に関連付けられたコードを読み込み、次のものを周囲のグローバル名前空間に取り込みます。

1. モジュール名
2. エクスポートリストに含まれる名前

厳密には、`using ModuleName`文は、`ModuleName`というモジュールを、必要に応じて名前解決に利用できるようにするという意味です。現在のモジュールに定義のないグローバル変数が見つかると、システムは`ModuleName`がエクスポートした変数の中からその名前を探し、見つかればそれを使います。つまり、現在のモジュール内でそのグローバル変数を使うと、すべて`ModuleName`にある変数の定義を参照します。

パッケージからモジュールを読み込むには、`using ModuleName`文を使います。ローカルに定義されたモジュールから読み込む場合は、`using .ModuleName`のように、モジュール名の前にドットを付けます。

先ほどの例を続けると、

```jldoctest module_manual
julia> using .NiceStuff
```

これにより上記のコードが読み込まれ、`NiceStuff`（モジュール名）、`DOG`、`nice`が利用可能になります。`Dog`はエクスポートリストに含まれていませんが、モジュールパス（この例ではモジュール名のみ）を付けて`NiceStuff.Dog`とすればアクセスできます。

重要なのは、**エクスポートリストが関係するのは`using ModuleName`という形式だけ**だということです。

一方、

```jldoctest module_manual
julia> import .NiceStuff
```

では、モジュール名だけがスコープに入ります。モジュール内の名前にアクセスするには、`NiceStuff.DOG`、`NiceStuff.Dog`、`NiceStuff.nice`のように記述する必要があります。次の節で説明するように、`import .NiceStuff`は`using .NiceStuff: NiceStuff`と同じです。通常、名前空間をすっきり保ちたい場合は、`import ModuleName`または`using ModuleName: ModuleName`を使います。

同じ種類の`using`文や`import`文は、カンマ区切りの式にまとめられます。たとえば、次のようになります。

```jldoctest module_manual
julia> using LinearAlgebra, Random
```

### `using` and `import` with specific identifiers, and adding methods

`using ModuleName:`または`import ModuleName:`の後に名前をカンマ区切りで並べると、モジュールは読み込まれますが、その文によって名前空間に取り込まれるのは、指定した名前だけです。たとえば、

```jldoctest module_manual
julia> using .NiceStuff: nice, DOG
```

この場合、`nice`と`DOG`がインポートされます。

重要なのは、モジュール名`NiceStuff`は名前空間に入りません。利用可能にするには、次のように明示的に列挙する必要があります。

```jldoctest module_manual
julia> using .NiceStuff: nice, DOG, NiceStuff
```

2つ以上のパッケージまたはモジュールが同じ名前をエクスポートしていて、その名前が各パッケージで同じものを指していない場合、名前を明示せずに`using`で読み込むと、その名前を修飾せずに参照したときにエラーになります。そのため、リリース済みパッケージのコードなど、依存パッケージやJuliaの将来のバージョンとの互換性を保つ必要があるコードでは、読み込んだ各パッケージから使う名前を列挙することを推奨します。たとえば、`using Foo`ではなく`using Foo: Foo, f`を使います。

Juliaに一見同じことをする形式が2つあるのは、`import ModuleName: f`だけが、モジュールパスを付けずに`f`へメソッドを追加できるためです。つまり、次の例はエラーになります。

```jldoctest module_manual
julia> using .NiceStuff: nice

julia> struct Cat end

julia> nice(::Cat) = "nice 😸"
ERROR: invalid method definition in Main: function NiceStuff.nice must be explicitly imported to be extended
Stacktrace:
 [1] top-level scope
   @ none:1
```

このエラーにより、使うつもりだっただけの別モジュールの関数に、誤ってメソッドを追加することを防げます。

この問題には2つの対処法があります。関数名に常にモジュールパスを付ける方法です。

```jldoctest module_manual
julia> using .NiceStuff

julia> struct Cat end

julia> NiceStuff.nice(::Cat) = "nice 😸"
```

もう1つは、対象の関数名を`import`する方法です。

```jldoctest module_manual
julia> import .NiceStuff: nice

julia> struct Mouse end

julia> nice(::Mouse) = "nice 🐭"
nice (generic function with 3 methods)
```

どちらを選ぶかはスタイルの問題です。前者は、別モジュールの関数にメソッドを追加していることが明確になります（インポートとメソッド定義が別々のファイルにある場合もあることを思い出してください）。後者は記述が短く、特に複数のメソッドを定義する場合に便利です。

`using`または`import`によって変数が見えるようになると、そのモジュール内で同じ名前の変数を新たに作ることはできません。インポートした変数は読み取り専用です。グローバル変数への代入は、常に現在のモジュールが所有する変数に対して行われ、それ以外の場合はエラーになります。

### Renaming with `as`

`import`または`using`によってスコープに入った識別子は、`as`キーワードを使って別名にできます。これは名前の衝突を避けたり、名前を短くしたりするのに便利です。たとえば、`Base`は関数名`read`をエクスポートしていますが、CSV.jlパッケージにも`CSV.read`があります。CSVの読み込みを何度も呼び出す場合、`CSV.`という修飾子を省略できると便利です。しかし、そうすると`Base.read`と`CSV.read`のどちらを指しているのか曖昧になります。

```julia-repl
julia> read;

julia> import CSV: read
WARNING: ignoring conflicting import of CSV.read into Main
```

別名を付ければ解決できます。

```julia-repl
julia> import CSV: read as rd
```

インポートしたパッケージ自体にも別名を付けられます。

```julia
import BenchmarkTools as BT
```

`as`が`using`と組み合わせて使えるのは、単一の識別子をスコープに取り込む場合だけです。たとえば、`using CSV: read as rd`は使えますが、`using CSV as C`は使えません。後者は`CSV`がエクスポートするすべての名前に作用するためです。

### Mixing multiple `using` and `import` statements

上記の形式の`using`文または`import`文を複数使うと、その効果は記述された順に組み合わされます。たとえば、

```jldoctest module_manual
julia> using .NiceStuff         # exported names and the module name

julia> import .NiceStuff: nice  # allows adding methods to unqualified functions

```

この場合、`NiceStuff`がエクスポートするすべての名前とモジュール名自体がスコープに入り、さらに、モジュール名を前に付けずに`nice`へメソッドを追加できるようになります。

### Handling name conflicts

次のように、2つ以上のパッケージが同じ名前をエクスポートしている場合を考えてみましょう。

```jldoctest module_manual
julia> module A
       export f
       f() = 1
       end
A
julia> module B
       export f
       f() = 2
       end
B
```

`using .A, .B`文は問題なく実行できますが、`f`を呼び出そうとすると、次のヒントを含むエラーが発生します。

```jldoctest module_manual
julia> using .A, .B

julia> f
ERROR: UndefVarError: `f` not defined in `Main`
Hint: It looks like two or more modules export different bindings with this name, resulting in ambiguity. Try explicitly importing it from a particular module, or qualifying the name with the module it should come from.
```

この場合、Juliaはどの`f`を指しているのか判断できないため、どちらを使うか選ぶ必要があります。一般的な解決方法は次のとおりです。

1. `A.f`や`B.f`のように、修飾名を使います。これにより、コードを読む人に文脈が明確に伝わります。特に、`f`がたまたま同じ名前でも、パッケージごとに意味が異なる場合に有効です。たとえば、`degree`は数学、自然科学、日常生活でさまざまな意味を持つため、それぞれを区別する必要があります。
2. 前述の`as`キーワードを使って、一方または両方の識別子に別名を付けます。たとえば、

   ```jldoctest module_manual
   julia> using .A: f as f

   julia> using .B: f as g

   ```

   これにより、`B.f`を`g`として使えるようになります。ここでは、`using A`をまだ使っておらず、それによって`f`が名前空間に入っていないものとします。
3. 対象の名前が*同じ意味を持つ*場合は、一方のモジュールがもう一方からその名前をインポートするのが一般的です。または、インターフェースを定義することだけを目的とした軽量な「ベース」パッケージを用意し、ほかのパッケージから利用する方法もあります。このようなパッケージ名は、`...Base`で終わるのが慣例です（Juliaの`Base`モジュールとは関係ありません）。

### Precedence order of definitions

バインディング定義は、一般に次の4種類に分けられます。

1. `using M`による暗黙のインポート
2. 明示的なインポート（例：`using M: x`、`import M: x`）
3. 型指定のない`global x`による、暗黙のグローバル宣言
4. 定義構文による明示的な宣言（`const`、`global x::T`、`struct`など）

構文上は、これらを優先順位の低いものから高いものへ、次の3段階に分けます。

1. 暗黙のインポート
2. 暗黙の宣言
3. 明示的な宣言とインポート

一般に、優先順位の低いバインディングは、より高いものに置き換えられます。

```julia-repl
julia> module M1; const x = 1; export x; end
Main.M1

julia> using .M1

julia> x # Implicit import from M1
1

julia> begin; f() = (global x; x = 1) end

julia> x # Implicit declaration
ERROR: UndefVarError: `x` not defined in `Main`
Suggestion: add an appropriate import or assignment. This global was declared but not assigned.

julia> const x = 2 # Explicit declaration
2
```

ただし、明示的な優先順位の範囲内では、置き換えは構文上禁止されているか、

```julia-repl
julia> module M1; const x = 1; export x; end
Main.M1

julia> import .M1: x

julia> const x = 2
ERROR: cannot declare Main.x constant; it was already declared as an import
Stacktrace:
 [1] top-level scope
   @ REPL[3]:1
```

無視されます。

```julia-repl
julia> const y = 2
2

julia> import .M1: x as y
WARNING: import of M1.x into Main conflicts with an existing identifier; ignored.
```

暗黙のバインディングの解決は、現在のワールドエイジで参照可能な、`using`されたすべてのモジュールの集合に依存します。詳しくは[the manual chapter on world age](@ref man-world-age)を参照してください。

### Default top-level definitions and bare modules

モジュールには、`using Core`、`using Base`、および[`eval`](@ref)関数と[`include`](@ref)関数の定義が自動的に含まれます。これらの関数は、そのモジュールのグローバルスコープで式やファイルを評価します。

これらのデフォルト定義が不要な場合は、代わりに[`baremodule`](@ref)キーワードを使ってモジュールを定義できます（ただし、`Core`は引き続きインポートされます）。`baremodule`を使って表すと、標準的な`module`は次のようになります。

```
baremodule Mod

using Base

eval(x) = Core.eval(Mod, x)
include(p) = Base.include(Mod, p)

...

end
```

`Core`も不要な場合は、何もインポートせず、名前も定義しないモジュールを`Module(:YourNameHere, false, false)`で定義できます。そのモジュールにコードを評価するには、[`@eval`](@ref)または[`Core.eval`](@ref)を使います。

```jldoctest
julia> arithmetic = Module(:arithmetic, false, false)
Main.arithmetic

julia> @eval arithmetic add(x, y) = $(+)(x, y)
add (generic function with 1 method)

julia> arithmetic.add(12, 13)
25
```

### Standard modules

重要な標準モジュールは3つあります。

  * [`Core`](@ref)には、言語に「組み込まれた」すべての機能が含まれています。
  * [`Base`](@ref)には、ほとんどの場合に役立つ基本機能が含まれています。
  * [`Main`](@ref)はトップレベルのモジュールであり、Juliaの起動時に現在のモジュールとなります。

!!! note "標準ライブラリのモジュール"
    Juliaには、標準ライブラリのモジュールがいくつか標準で付属しています。これらは通常のJuliaパッケージと同様に動作しますが、明示的にインストールする必要はありません。たとえば、単体テストを行う場合は、次のように`Test`標準ライブラリを読み込めます。

    ```julia
    using Test
    ```


## Submodules and relative paths

モジュールには*サブモジュール*を含めることができ、同じ`module ... end`構文を入れ子にして使います。サブモジュールは独立した名前空間を導入するために使え、複雑なコードベースの整理に役立ちます。ただし、各`module`は独自の[scope](@ref scope-of-variables)を導入するため、サブモジュールが親モジュールの名前を自動的に「継承」することはありません。

サブモジュールから、親モジュール（親モジュール自身を含む）内のほかのモジュールを参照する場合は、`using`文や`import`文で*相対モジュール修飾子*を使うことが推奨されます。相対モジュール修飾子はドット（`.`）で始まり、これは現在のモジュールを表します。続けて`.`を1つ書くごとに、現在のモジュールの親へ移動します。必要に応じてモジュール名を続け、最後にアクセスする名前を指定します。各要素は`.`で区切ります。ただし、モジュールのルートを参照する場合は、特別に`.`を付けずに記述できます。これにより、目的のモジュールまでの深さを数える必要がありません。

次の例では、サブモジュール`SubA`で定義した関数を、「兄弟」モジュールで拡張しています。

```jldoctest module_manual
julia> module ParentModule
       module SubA
       export add_D  # exported interface
       const D = 3
       add_D(x) = x + D
       end
       using .SubA  # brings `add_D` into the namespace
       export add_D # export it from ParentModule too
       module SubB
       import ..SubA: add_D # relative path for a “sibling” module
       # import ParentModule.SubA: add_D # when in a package, such as when this is loaded by using or import, this would be equivalent to the previous import, but not at the REPL
       struct Infinity end
       add_D(x::Infinity) = x
       end
       end;

```

同様の状況で、パッケージ内に`.`を付けずにimportを使うコードが見つかることがあります。

```jldoctest
julia> import ParentModule.SubA: add_D
ERROR: ArgumentError: Package ParentModule not found in current path.
```

ただし、これは[code loading](@ref code-loading)を介して動作するため、`ParentModule`がファイル内のパッケージに含まれている場合にしか使えません。`ParentModule`をREPLで定義した場合は、相対パスを使う必要があります。

```jldoctest module_manual
julia> import .ParentModule.SubA: add_D

```

値を評価する場合は、定義の順序も重要です。次の例を考えてみましょう。

```julia
module TestPackage

export x, y

x = 0

module Sub
using ..TestPackage
z = y # ERROR: UndefVarError: `y` not defined in `Main`
end

y = 1

end
```

ここでは、`Sub`が、定義される前の`TestPackage.y`を使おうとしているため、値を持ちません。

同様の理由から、循環する順序で定義することもできません。

```julia
module A

module B
using ..C # ERROR: UndefVarError: `C` not defined in `Main.A`
end

module C
using ..B
end

end
```

## Module initialization and precompilation

大規模なモジュールでは、モジュール内のすべての文を実行する際に大量のコードをコンパイルすることが多いため、読み込みに数秒かかる場合があります。Juliaはこの時間を短縮するため、モジュールの事前コンパイル済みキャッシュを作成します。

事前コンパイル済みモジュールファイル（「キャッシュファイル」と呼ばれることもあります）は、`import`または`using`でモジュールを読み込むと、自動的に作成・使用されます。キャッシュファイルがまだ存在しない場合、モジュールはコンパイルされ、次回以降に再利用できるよう保存されます。モジュールを読み込まずにキャッシュファイルを作成するには、[`Base.compilecache(Base.identify_package("modulename"))`](@ref)を手動で呼び出すこともできます。作成されたキャッシュファイルは、`DEPOT_PATH[1]`の`compiled`サブフォルダーに保存されます。システムに変更がなければ、`import`または`using`でモジュールを読み込む際に、これらのキャッシュファイルが使われます。

事前コンパイルのキャッシュファイルには、モジュール、型、メソッド、定数の定義が保存されます。メソッドの特殊化や、それらに対して生成されたコードも保存される場合がありますが、通常は開発者が明示的な[`precompile`](@ref)ディレクティブを追加するか、パッケージのビルド中にコンパイルを促す処理を実行する必要があります。

ただし、モジュールの依存関係を更新したり、ソースコードを変更したりすると、次に`using`または`import`を実行したときに、モジュールは自動的に再コンパイルされます。依存関係には、インポートするモジュール、Juliaのビルド、インクルードするファイル、およびモジュールファイル内の[`include_dependency(path)`](@ref)で明示的に宣言された依存関係が含まれます。

`include`で読み込まれるファイル依存関係については、ファイルサイズ（`fsize`）または内容（ハッシュ値に要約されます）が変わっていないかを調べて、変更の有無を判定します。`include_dependency`で読み込まれるファイル依存関係については、更新時刻（`mtime`）が変わっていないか、または秒単位に切り捨てた更新時刻と一致するかを調べます（サブ秒精度でmtimeをコピーできないシステムに対応するためです）。また、`require`の検索ロジックで選ばれたファイルのパスが、事前コンパイルファイルの作成時に使われたパスと一致するかどうかも確認します。さらに、現在のプロセスですでに読み込まれている依存関係の集合も考慮します。実行中のシステムと事前コンパイル済みキャッシュとの不整合を避けるため、ファイルが変更または削除されていても、これらのモジュールは再コンパイルしません。最後に、[compile-time preferences](@ref preferences)の変更も考慮します。

たとえば、以下で説明する理由などにより、モジュールが事前コンパイルに適さないと分かっている場合は、モジュールファイル（通常は先頭）に`__precompile__(false)`を記述してください。これにより、`Base.compilecache`はエラーをスローし、`using` / `import`は事前コンパイルとキャッシュを行わず、モジュールを現在のプロセスに直接読み込みます。また、ほかの事前コンパイル済みモジュールからそのモジュールをインポートできなくなります。

インクリメンタル共有ライブラリの作成に伴う動作の中には、モジュールを書く際に注意が必要なものがあります。たとえば、外部状態は保持されません。このため、*実行時*に行う必要がある初期化処理と、*コンパイル時*に行える処理を明確に分けてください。そのためにJuliaでは、実行時に必要な初期化処理を行う`__init__()`関数をモジュール内に定義できます。この関数はコンパイル中には呼び出されません（`--output-*`）。実質的には、コードの存続期間中に一度だけ実行されると考えてかまいません。必要なら手動で呼び出すこともできますが、通常はローカルマシン用の状態を計算する関数として扱います。その状態はコンパイル済みイメージに保存する必要がない、あるいは保存すべきではないものです。この関数は、モジュールがプロセスに読み込まれた後に呼び出されます。インクリメンタルコンパイル（`--output-incremental=yes`）に読み込まれる場合も同様ですが、フルコンパイルのプロセスに読み込まれる場合は呼び出されません。

特に、モジュール内に`function __init__()`を定義すると、Juliaは実行時にモジュールが初めて読み込まれた直後（たとえば、`import`、`using`、`require`による読み込み後）に`__init__()`を呼び出します。つまり、`__init__`は一度だけ呼び出され、モジュール内のすべての文が実行された後にのみ呼び出されます。モジュールのインポートが完了してから呼び出されるため、サブモジュールやほかのインポート済みモジュールの`__init__`関数は、外側のモジュールの`__init__`より先に呼び出されます。この順序はスレッド間でも同期されるため、依存関係の順序に従ってすべての`__init__`が実行されてから、`using`の結果が完了することを安全に前提とできます。ただし、依存関係にないほかの`__init__`メソッドとは並行して実行される場合があるため、現在のモジュールの外にある共有状態にアクセスするときは、必要に応じてロックを使ってください。

`__init__`の典型的な用途は、外部Cライブラリの実行時初期化関数を呼び出すことと、外部ライブラリから返されるポインターを使ってグローバル定数を初期化することです。たとえば、実行時に`foo_init()`初期化関数を呼び出す必要があるCライブラリ`libfoo`を使うとします。また、`libfoo`が定義する`void *foo_data()`関数の戻り値を保持するグローバル定数`foo_data_ptr`も定義したいとします。実行ごとにポインターアドレスが変わるため、この定数はコンパイル時ではなく実行時に初期化する必要があります。モジュール内に次の`__init__`関数を定義すれば実現できます。

```julia
const foo_data_ptr = Ref{Ptr{Cvoid}}(0)
function __init__()
    ccall((:foo_init, :libfoo), Cvoid, ())
    foo_data_ptr[] = ccall((:foo_data, :libfoo), Ptr{Cvoid}, ())
    nothing
end
```

`__init__`のような関数内でグローバル変数を定義することは、まったく問題ありません。これは動的言語を使う利点の1つです。ただし、グローバルスコープで定数にすれば、コンパイラーが型を把握でき、より最適化されたコードを生成できます。もちろん、`foo_data_ptr`に依存するモジュール内のほかのグローバル変数も、`__init__`で初期化する必要があります。

[`ccall`](@ref)によって生成されない、ほとんどのJuliaオブジェクトを含む定数は、`__init__`に置く必要はありません。定義を事前コンパイルし、キャッシュされたモジュールイメージから読み込めます。配列のような、ヒープ上に確保される複雑なオブジェクトも含まれます。ただし、生のポインター値を返すルーチンは、事前コンパイルを正しく行うために実行時に呼び出す必要があります（[`Ptr`](@ref)オブジェクトは、[`isbits`](@ref)オブジェクトの中に隠されていない限り、ヌルポインターになります）。これには、Julia関数[`@cfunction`](@ref)と[`pointer`](@ref)の戻り値も含まれます。

事前コンパイルを使う場合は、コンパイル段階と実行段階の違いを明確に意識することが重要です。このモードでは、Juliaが単にコンパイル済みコードを生成するインタープリターではなく、任意のJuliaコードを実行できるコンパイラーであることが、よりはっきり分かることがよくあります。

ほかに、次のような既知の失敗要因があります。

1. グローバルカウンター（たとえば、オブジェクトを一意に識別するためのもの）。次のコードを考えてみましょう。

   ```julia
   mutable struct UniquedById
       myid::Int
       let counter = 0
           UniquedById() = new(counter += 1)
       end
   end
   ```

   このコードは各インスタンスに一意のIDを割り当てることを意図していますが、カウンターの値はコンパイル終了時の値として記録されます。そのため、このモジュールをインクリメンタルコンパイルした後に使うと、毎回同じカウンター値から始まります。

   `objectid`（メモリーポインターをハッシュすることで動作します）にも同様の問題があります（後述の`Dict`の使用に関する注意を参照してください）。

   代替策として、マクロを使って[`@__MODULE__`](@ref)を取得し、現在の`counter`の値とともに保存する方法があります。ただし、このようなグローバル状態に依存しないよう、コードを設計し直すほうがよい場合もあります。
2. `Dict`や`Set`などの連想コレクションは、`__init__`で再ハッシュする必要があります（将来的には、初期化関数を登録する仕組みが提供される可能性があります）。
3. コンパイル時の副作用が読み込み時にも残ることへの依存。たとえば、ほかのJuliaモジュールにある配列や変数を変更すること、開いたファイルやデバイスへのハンドルを保持すること、メモリーを含むほかのシステムリソースへのポインターを保存することなどです。
4. 別のモジュールのグローバル状態を、検索パスを介さず直接参照することで、意図せず「コピー」を作ってしまうこと。たとえば、グローバルスコープで次のようにします。

   ```julia
   #mystdout = Base.stdout #= will not work correctly, since this will copy Base.stdout into this module =#
   # instead use accessor functions:
   getstdout() = Base.stdout #= best option =#
   # or move the assignment into the runtime:
   __init__() = global mystdout = Base.stdout #= also works =#
   ```

事前コンパイル中に実行できる操作には、ほかの誤動作を避けるため、いくつか追加の制限があります。

1. [`eval`](@ref)を呼び出して、別のモジュールに副作用を起こすこと。インクリメンタル事前コンパイルのフラグが設定されている場合は、警告も出力されます。
2. `__init__()`の開始後に、ローカルスコープから`global const`文を実行すること（この件については、エラーを追加する計画がissue #12010にあります）。
3. インクリメンタル事前コンパイル中にモジュールを置き換えること。これは実行時エラーになります。

ほかにも、次の点に注意してください。

1. ソースファイル自体を変更しても（`Pkg.update`による変更を含む）、コードの再読み込みやキャッシュの無効化は行われません。また、`Pkg.rm`の後にクリーンアップも行われません。
2. reshapeされた配列のメモリー共有動作は、事前コンパイルでは無視されます（各ビューはそれぞれ独自のコピーを持ちます）。
3. コンパイル時と実行時でファイルシステムが変わらないことを前提にすること。たとえば、実行時にリソースを見つけるために[`@__FILE__`](@ref)/`source_path()`を使う場合や、BinDepsの`@checked_lib`マクロを使う場合です。これが避けられないこともありますが、可能であれば、実行時に探す必要がないよう、コンパイル時にリソースをモジュール内へコピーするのがよいでしょう。
4. `WeakRef`オブジェクトとファイナライザーは、現在シリアライザーで正しく処理されません（今後のリリースで修正される予定です）。
5. `Method`、`MethodInstance`、`MethodTable`、`TypeMapLevel`、`TypeMapEntry`などの内部メタデータオブジェクトのインスタンスや、そのフィールドへの参照を保持するのは、通常避けるのが最善です。シリアライザーが混乱し、意図した結果にならない可能性があります。必ずしもエラーになるわけではありませんが、システムが一部をコピーし、別の一部については一意のインスタンスを作成しようとすることを想定しておく必要があります。

モジュールの開発中に、インクリメンタル事前コンパイルを無効にすると便利な場合があります。コマンドラインフラグ`--compiled-modules={yes|no|existing}`を使うと、モジュールの事前コンパイルを有効または無効にできます。`--compiled-modules=no`を指定してJuliaを起動すると、モジュールやその依存関係を読み込む際に、コンパイルキャッシュ内のシリアライズ済みモジュールは無視されます。既存の事前コンパイル済みモジュールは読み込みつつ、新しいモジュールは作成しないようにしたい場合は、`--compiled-modules=existing`を指定してJuliaを起動します。より細かな制御には`--pkgimages={yes|no|existing}`を使えます。これは事前コンパイル中のネイティブコードの保存だけに影響します。`Base.compilecache`は引き続き手動で呼び出せます。このコマンドラインフラグの状態は`Pkg.build`に渡され、パッケージのインストール、更新、明示的なビルド時に自動で事前コンパイルが開始されないようにします。

環境変数を使って、事前コンパイルの失敗をデバッグすることもできます。`JULIA_VERBOSE_LINKING=true`を設定すると、コンパイル済みネイティブコードの共有ライブラリのリンクに関する失敗を解決できる場合があります。詳しくはJuliaマニュアルの**開発者向けドキュメント**を参照してください。「Package Images」の節に、Juliaの内部実装に関する詳細があります。
