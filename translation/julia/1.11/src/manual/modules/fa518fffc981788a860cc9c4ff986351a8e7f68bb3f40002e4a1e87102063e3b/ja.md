# [Modules](@id modules)

Juliaのモジュールは、コードを一貫した単位に整理するのに役立ちます。モジュールは`module NameOfModule ... end`の中で構文的に区切られ、以下の特徴を持っています：

1. モジュールは別々の名前空間であり、それぞれが新しいグローバルスコープを導入します。これは便利であり、異なる関数やグローバル変数に同じ名前を使用しても衝突がないため、別々のモジュールにある限り問題ありません。
2. モジュールは詳細な名前空間管理のための機能を持っています：各モジュールは、`export`して`public`としてマークされた名前のセットを定義し、`using`や`import`を使って他のモジュールから名前をインポートすることができます（これについては以下で説明します）。
3. モジュールは、より高速な読み込みのために事前コンパイルされることがあり、ランタイム初期化のためのコードを含む場合があります。

通常、大きなJuliaパッケージでは、モジュールコードがファイルに整理されているのを見かけます。例えば、

```julia
module SomeModule

# export, public, using, import statements are usually here; we discuss these below

include("file1.jl")
include("file2.jl")

end
```

ファイルとファイル名はモジュールとはほとんど無関係であり、モジュールはモジュール式にのみ関連しています。モジュールごとに複数のファイルを持つことができ、ファイルごとに複数のモジュールを持つことができます。`include`は、ソースファイルの内容が含まれているモジュールのグローバルスコープで評価されたかのように振る舞います。この章では、短く簡略化された例を使用するため、`include`は使用しません。

モジュールの本体をインデントしないことが推奨されており、これは通常、ファイル全体がインデントされることにつながります。また、モジュール名には（型と同様に）`UpperCamelCase`を使用することが一般的であり、特にモジュールに同様の名前の識別子が含まれている場合は、名前の衝突を避けるために複数形を使用することが推奨されます。例えば、

```julia
module FastThings

struct FastThing
    ...
end

end
```

## [Namespace management](@id namespace-management)

名前空間管理とは、モジュール内の名前を他のモジュールで利用できるようにするために言語が提供する機能を指します。関連する概念と機能について、以下で詳細に説明します。

### Qualified names

グローバルスコープ内の関数、変数、型の名前は、常に*親モジュール*に属します。この親モジュールは、例えば [`parentmodule`](@ref) を使ってインタラクティブに見つけることができます。

```jldoctest
julia> parentmodule(UnitRange)
Base
```

これらの名前は、親モジュールの名前をプレフィックスとして付けることで、親モジュールの外部でも参照できます。例えば、`Base.UnitRange`のようにです。これは*修飾名*と呼ばれます。親モジュールは、`Base.Math.sin`のようにサブモジュールのチェーンを使用してアクセスでき、`Base.Math`は*モジュールパス*と呼ばれます。構文の曖昧さのために、演算子のような記号のみを含む名前を修飾するにはコロンを挿入する必要があります。例えば、`Base.:+`のようにです。少数の演算子は、さらに括弧を必要とします。例えば、`Base.:(==)`のようにです。

名前が修飾されている場合、それは常に *アクセス可能* であり、関数の場合は、修飾名を関数名として使用することでメソッドを追加することもできます。

モジュール内では、変数名を `global x` と宣言することで、値を割り当てることなく「予約」することができます。これにより、ロード時以降に初期化されたグローバル変数との名前の衝突を防ぎます。構文 `M.x = y` は、別のモジュールでグローバル変数に割り当てるためには機能しません。グローバル変数の割り当ては常にモジュールローカルです。

### Export lists

名前（関数、型、グローバル変数、および定数を指す）は、`export`を使用してモジュールの*エクスポートリスト*に追加できます：これらは、モジュールを`using`したときにインポートされるシンボルです。通常、ソースコードの読者が簡単に見つけられるように、モジュール定義の最上部またはその近くに配置されます。

```jldoctest module_manual
julia> module NiceStuff
       export nice, DOG
       struct Dog end      # singleton type, not exported
       const DOG = Dog()   # named instance, exported
       nice(x) = "nice $x" # function, exported
       end;

```

しかし、これは単なるスタイルの提案です — モジュールには任意の場所に複数の `export` ステートメントを持つことができます。

API（アプリケーションプログラミングインターフェース）の一部を形成する名前をエクスポートすることは一般的です。上記のコードでは、エクスポートリストがユーザーに `nice` と `DOG` を使用することを示唆しています。しかし、修飾名は常に識別子をアクセス可能にするため、これはAPIを整理するためのオプションに過ぎません。他の言語とは異なり、Juliaにはモジュール内部を真に隠すための機能がありません。

また、一部のモジュールは名前をまったくエクスポートしません。これは通常、`derivative`のような一般的な単語をAPIで使用している場合に行われ、他のモジュールのエクスポートリストと簡単に衝突する可能性があります。名前の衝突を管理する方法については、以下で説明します。

名前を公開としてマークするには、`using NiceStuff`を呼び出す人々の名前空間にエクスポートせずに、`export`の代わりに`public`を使用できます。これにより、公開名が公開APIの一部としてマークされますが、名前空間には影響を与えません。`public`キーワードはJulia 1.11以降でのみ利用可能です。Julia 1.10以前との互換性を維持するためには、[Compat](https://github.com/JuliaLang/Compat.jl)パッケージの`@compat`マクロを使用してください。

### Standalone `using` and `import`

インタラクティブな使用のために、モジュールをロードする最も一般的な方法は `using ModuleName` です。この [loads](@ref code-loading) は `ModuleName` に関連付けられたコードであり、持ってきます。

1. モジュール名
2. およびエクスポートリストの要素を周囲のグローバル名前空間に。

技術的には、`using ModuleName`という文は、`ModuleName`というモジュールが必要に応じて名前を解決するために利用可能であることを意味します。現在のモジュールに定義がないグローバル変数が見つかると、システムは`ModuleName`によってエクスポートされた変数の中からそれを検索し、見つかった場合はそれを使用します。これは、現在のモジュール内でそのグローバル変数のすべての使用が`ModuleName`内のその変数の定義に解決されることを意味します。

パッケージからモジュールをロードするには、`using ModuleName`という文を使用できます。ローカルで定義されたモジュールからモジュールをロードするには、モジュール名の前にドットを追加する必要があります。例えば、`using .ModuleName`のようにします。

例を続けるために、

```jldoctest module_manual
julia> using .NiceStuff
```

上記のコードを読み込むと、`NiceStuff`（モジュール名）、`DOG`、および `nice` が利用可能になります。`Dog` はエクスポートリストには含まれていませんが、モジュールパス（ここではモジュール名のみ）で名前を修飾すればアクセスできます。つまり、`NiceStuff.Dog` としてアクセス可能です。

重要なのは、**`using ModuleName` がエクスポートリストが重要となる唯一の形式である**。

対照的に、

```jldoctest module_manual
julia> import .NiceStuff
```

*のみ* モジュール名をスコープに持ち込みます。ユーザーはその内容にアクセスするために `NiceStuff.DOG`、`NiceStuff.Dog`、および `NiceStuff.nice` を使用する必要があります。通常、`import ModuleName` はユーザーが名前空間をクリーンに保ちたい場合に使用されます。次のセクションで見るように、`import .NiceStuff` は `using .NiceStuff: NiceStuff` と同等です。

複数の `using` および `import` ステートメントを同じ種類でカンマ区切りの式に結合できます。例えば、

```jldoctest module_manual
julia> using LinearAlgebra, Random
```

### `using` and `import` with specific identifiers, and adding methods

`using ModuleName:` または `import ModuleName:` の後にカンマ区切りの名前のリストが続く場合、モジュールはロードされますが、*その特定の名前のみがこのステートメントによって名前空間に取り込まれます*。例えば、

```jldoctest module_manual
julia> using .NiceStuff: nice, DOG
```

`nice` と `DOG` の名前をインポートします。

重要なことに、モジュール名 `NiceStuff` は *名前空間* に含まれません。アクセス可能にしたい場合は、明示的にリストする必要があります。

```jldoctest module_manual
julia> using .NiceStuff: nice, DOG, NiceStuff
```

2つ以上のパッケージ/モジュールが名前をエクスポートし、その名前が各パッケージで同じものを指さない場合、明示的な名前のリストなしに`using`を介してパッケージがロードされると、その名前を修飾なしで参照することはエラーになります。したがって、依存関係やJuliaの将来のバージョンとの互換性を考慮したコード、例えばリリースされたパッケージのコードは、各ロードされたパッケージから使用する名前をリストすることが推奨されます。例えば、`using Foo: Foo, f`のようにするべきであり、`using Foo`のようにするべきではありません。

ジュリアには、一見同じことのための2つの形式があります。なぜなら、`import ModuleName: f`のみが、*モジュールパスなしで* `f`にメソッドを追加することを許可するからです。言い換えれば、以下の例はエラーを返します：

```jldoctest module_manual
julia> using .NiceStuff: nice

julia> struct Cat end

julia> nice(::Cat) = "nice 😸"
ERROR: invalid method definition in Main: function NiceStuff.nice must be explicitly imported to be extended
Stacktrace:
 [1] top-level scope
   @ none:0
 [2] top-level scope
   @ none:1

```

このエラーは、他のモジュールの関数に意図せずメソッドを追加するのを防ぎます。

この問題に対処する方法は2つあります。常にモジュールパスで関数名を修飾することができます：

```jldoctest module_manual
julia> using .NiceStuff

julia> struct Cat end

julia> NiceStuff.nice(::Cat) = "nice 😸"

```

代わりに、特定の関数名を `import` することができます：

```jldoctest module_manual
julia> import .NiceStuff: nice

julia> struct Cat end

julia> nice(::Cat) = "nice 😸"
nice (generic function with 2 methods)
```

どちらを選ぶかはスタイルの問題です。最初の形式は、別のモジュールの関数にメソッドを追加していることを明確に示します（インポートとメソッド定義が別のファイルにある可能性があることを忘れないでください）。一方、2番目の形式は短く、特に複数のメソッドを定義する場合に便利です。

一度変数が `using` または `import` を介して可視化されると、モジュールは同じ名前の変数を自分自身で作成することはできません。インポートされた変数は読み取り専用です。グローバル変数に代入すると、常に現在のモジュールが所有する変数に影響を与えるか、エラーが発生します。

### Renaming with `as`

`import` または `using` によってスコープに持ち込まれた識別子は、キーワード `as` を使って名前を変更することができます。これは、名前の衝突を回避するためや、名前を短縮するために便利です。例えば、`Base` は関数名 `read` をエクスポートしますが、CSV.jl パッケージも `CSV.read` を提供しています。CSV 読み込みを何度も呼び出す場合、`CSV.` 修飾子を省略するのが便利です。しかし、その場合、`Base.read` を指しているのか `CSV.read` を指しているのかが曖昧になります。

```julia-repl
julia> read;

julia> import CSV: read
WARNING: ignoring conflicting import of CSV.read into Main
```

名前の変更は解決策を提供します：

```julia-repl
julia> import CSV: read as rd
```

インポートされたパッケージ自体も名前を変更できます：

```julia
import BenchmarkTools as BT
```

`as` は、単一の識別子がスコープに持ち込まれる場合にのみ `using` と一緒に機能します。例えば、`using CSV: read as rd` は機能しますが、`using CSV as C` は機能しません。なぜなら、これは `CSV` 内のすべてのエクスポートされた名前に対して操作するからです。

### Mixing multiple `using` and `import` statements

複数の `using` または `import` ステートメントが上記のいずれかの形式で使用される場合、それらの効果は出現順に結合されます。例えば、

```jldoctest module_manual
julia> using .NiceStuff         # exported names and the module name

julia> import .NiceStuff: nice  # allows adding methods to unqualified functions

```

`NiceStuff`のすべてのエクスポートされた名前とモジュール名自体をスコープに持ち込み、`nice`にモジュール名をプレフィックスなしでメソッドを追加できるようにします。

### Handling name conflicts

同じ名前をエクスポートする2つ（またはそれ以上の）パッケージがある状況を考えてください。

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

ステートメント `using .A, .B` は機能しますが、`f` を呼び出そうとすると、ヒント付きのエラーが発生します。

```jldoctest module_manual
julia> using .A, .B

julia> f
ERROR: UndefVarError: `f` not defined in `Main`
Hint: It looks like two or more modules export different bindings with this name, resulting in ambiguity. Try explicitly importing it from a particular module, or qualifying the name with the module it should come from.
```

ここで、ジュリアはどの `f` を指しているのか決められないので、あなたが選択する必要があります。以下の解決策が一般的に使用されます：

1. 単に `A.f` や `B.f` のような資格付き名を使用してください。これにより、コードの読者にとって文脈が明確になります。特に、`f` がたまたま一致していても、さまざまなパッケージで異なる意味を持つ場合です。たとえば、`degree` は数学、自然科学、日常生活でさまざまな使い方があり、これらの意味は区別されるべきです。
2. `as` キーワードを使用して、1つまたは両方の識別子の名前を変更します。例えば、

    ```jldoctest module_manual
    julia> using .A: f as f

    julia> using .B: f as g

    ```

    `B.f`を`g`として利用できるようにします。ここでは、`using A`を事前に使用していないと仮定しています。そうであれば、`f`は名前空間に取り込まれていたでしょう。
3. 問題の名前が*意味を共有する*場合、1つのモジュールが別のモジュールからそれをインポートするか、他のパッケージで使用できるようにこのようなインターフェースを定義することだけを目的とした軽量の「ベース」パッケージを持つことが一般的です。そのようなパッケージ名は`...Base`で終わるのが慣例です（これはJuliaの`Base`モジュールとは関係ありません）。

### Default top-level definitions and bare modules

モジュールは自動的に `using Core`、`using Base` を含み、[`eval`](@ref) および [`include`](@ref) 関数の定義を持ち、これらはそのモジュールのグローバルスコープ内で式/ファイルを評価します。

これらのデフォルト定義が不要な場合、キーワード [`baremodule`](@ref) を使用してモジュールを定義できます（注：`Core` はまだインポートされています）。`baremodule` の観点から、標準の `module` は次のようになります：

```
baremodule Mod

using Base

eval(x) = Core.eval(Mod, x)
include(p) = Base.include(Mod, p)

...

end
```

もし `Core` さえも望まれない場合、何もインポートせず、名前を全く定義しないモジュールは `Module(:YourNameHere, false, false)` で定義でき、コードは [`@eval`](@ref) または [`Core.eval`](@ref) を使って評価できます。

```jldoctest
julia> arithmetic = Module(:arithmetic, false, false)
Main.arithmetic

julia> @eval arithmetic add(x, y) = $(+)(x, y)
add (generic function with 1 method)

julia> arithmetic.add(12, 13)
25
```

### Standard modules

重要な標準モジュールが3つあります：

  * [`Core`](@ref) は、言語に「組み込まれた」すべての機能を含んでいます。
  * [`Base`](@ref) は、ほとんどすべてのケースで役立つ基本的な機能を含んでいます。
  * [`Main`](@ref) は、Juliaが起動したときのトップレベルモジュールおよび現在のモジュールです。

!!! note "Standard library modules"
    デフォルトでは、Juliaは標準ライブラリモジュールをいくつか同梱しています。これらは通常のJuliaパッケージのように動作しますが、明示的にインストールする必要はありません。たとえば、単体テストを実行したい場合は、次のように`Test`標準ライブラリをロードできます。

    ```julia
    using Test
    ```


## Submodules and relative paths

モジュールは *サブモジュール* を含むことができ、同じ構文 `module ... end` をネストすることができます。これは、複雑なコードベースを整理するのに役立つ別々の名前空間を導入するために使用できます。各 `module` は独自の [scope](@ref scope-of-variables) を導入するため、サブモジュールは親から名前を自動的に「継承」するわけではないことに注意してください。

サブモジュールは、`using`および`import`ステートメント内で、親モジュール（およびそれを含む）内の他のモジュールを*相対モジュール修飾子*を使用して参照することが推奨されます。相対モジュール修飾子は、現在のモジュールに対応するピリオド（`.`）で始まり、各連続する`.`は現在のモジュールの親に向かいます。必要に応じてモジュールが続き、最終的にアクセスする実際の名前が`.`で区切られて続きます。

次の例を考えてみましょう。ここでは、サブモジュール `SubA` が関数を定義し、その後「兄弟」モジュールで拡張されます。

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
       struct Infinity end
       add_D(x::Infinity) = x
       end
       end;

```

パッケージ内でコードを見ることができ、同様の状況で使用されることがあります。

```jldoctest module_manual
julia> import .ParentModule.SubA: add_D

```

しかし、これは [code loading](@ref code-loading) を通じて動作するため、`ParentModule` がパッケージ内にある場合にのみ機能します。相対パスを使用する方が良いです。

定義の順序も、値を評価する際には重要であることに注意してください。考慮してください。

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

`Sub`は`TestPackage.y`を定義される前に使用しようとしているため、値を持っていません。

同様の理由から、循環順序を使用することはできません：

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

大きなモジュールは、モジュール内のすべてのステートメントを実行することが多く、大量のコードをコンパイルする必要があるため、読み込むのに数秒かかることがあります。Juliaは、この時間を短縮するためにモジュールのプリコンパイルキャッシュを作成します。

プリコンパイルされたモジュールファイル（時々「キャッシュファイル」と呼ばれる）は、`import` または `using` がモジュールをロードする際に自動的に作成され、使用されます。キャッシュファイルがまだ存在しない場合、モジュールはコンパイルされ、将来の再利用のために保存されます。また、モジュールをロードせずにこれらのファイルを作成するために、[`Base.compilecache(Base.identify_package("modulename"))`](@ref) を手動で呼び出すこともできます。生成されたキャッシュファイルは、`DEPOT_PATH[1]` の `compiled` サブフォルダーに保存されます。システムに何も変更がない場合、そのようなキャッシュファイルは、`import` または `using` でモジュールをロードする際に使用されます。

プリコンパイルキャッシュファイルは、モジュール、型、メソッド、および定数の定義を保存します。また、メソッドの特化やそれに対して生成されたコードを保存することもありますが、通常は開発者が明示的な [`precompile`](@ref) ディレクティブを追加するか、パッケージビルド中にコンパイルを強制するワークロードを実行する必要があります。

However, if you update the module's dependencies or change its source code, the module is automatically recompiled upon `using` or `import`. Dependencies are modules it imports, the Julia build, files it includes, or explicit dependencies declared by [`include_dependency(path)`](@ref) in the module file(s).

ファイル依存関係が `include` によって読み込まれる場合、変更はファイルサイズ（`fsize`）または内容（ハッシュに凝縮されたもの）が変更されていないかどうかを調べることによって判断されます。`include_dependency` によって読み込まれるファイル依存関係の場合、変更は修正時間（`mtime`）が変更されていないか、または修正時間が最も近い秒に切り捨てられているかどうかを調べることによって判断されます（サブ秒精度で `mtime` をコピーできないシステムに対応するため）。また、`require` の検索ロジックによって選択されたファイルへのパスが、プリコンパイルファイルを作成したパスと一致するかどうかも考慮されます。さらに、現在のプロセスにすでに読み込まれている依存関係のセットも考慮され、ファイルが変更されたり消失したりしても、それらのモジュールは再コンパイルされず、実行中のシステムとプリコンパイルキャッシュとの間に互換性のない状態を作成しないようにします。最後に、任意の [compile-time preferences](@ref preferences) の変更も考慮されます。

モジュールが*事前コンパイル*に安全でないことがわかっている場合（例えば、以下に説明されている理由の1つのため）、モジュールファイルに`__precompile__(false)`を記述する必要があります（通常はファイルの先頭に配置します）。これにより、`Base.compilecache`がエラーをスローし、`using` / `import`がそれを現在のプロセスに直接ロードし、事前コンパイルとキャッシングをスキップします。これにより、モジュールが他の事前コンパイルされたモジュールによってインポートされるのを防ぎます。

特定の動作が増分共有ライブラリの作成に固有であり、モジュールを書く際に注意が必要であることを認識しておく必要があります。たとえば、外部状態は保持されません。これに対応するために、*ランタイム*で発生する必要がある初期化ステップと、*コンパイル時*に発生できるステップを明示的に分けてください。この目的のために、Juliaでは、ランタイムで発生する必要がある初期化ステップを実行する`__init__()`関数をモジュール内に定義することができます。この関数はコンパイル中（`--output-*`）には呼び出されません。実質的に、この関数はコードのライフタイム中に正確に1回実行されると仮定できます。もちろん、必要に応じて手動で呼び出すこともできますが、デフォルトではこの関数はローカルマシンの状態を計算することに関係していると仮定されており、コンパイルされたイメージにキャプチャする必要はありませんし、キャプチャすべきではありません。この関数は、モジュールがプロセスにロードされた後に呼び出されます。増分コンパイル（`--output-incremental=yes`）にロードされる場合も含まれますが、フルコンパイルプロセスにロードされる場合には呼び出されません。

特に、モジュール内に `function __init__()` を定義すると、Julia はモジュールがロードされた直後（例えば、`import`、`using`、または `require` によって）に `__init__()` を実行時に *最初* に呼び出します（つまり、`__init__` は一度だけ呼び出され、モジュール内のすべてのステートメントが実行された後にのみ呼び出されます）。モジュールが完全にインポートされた後に呼び出されるため、サブモジュールや他のインポートされたモジュールの `__init__` 関数は、囲むモジュールの `__init__` の *前* に呼び出されます。

`__init__`の典型的な使用法の2つは、外部Cライブラリのランタイム初期化関数を呼び出すことと、外部ライブラリによって返されるポインタを含むグローバル定数を初期化することです。たとえば、Cライブラリ`libfoo`を呼び出す必要があり、ランタイムで`foo_init()`初期化関数を呼び出す必要があるとします。また、`libfoo`によって定義された`void *foo_data()`関数の戻り値を保持するグローバル定数`foo_data_ptr`を定義したいとします。この定数は、ポインタのアドレスが実行ごとに変わるため、ランタイムで初期化する必要があります。この目的を達成するために、モジュール内に次の`__init__`関数を定義することができます：

```julia
const foo_data_ptr = Ref{Ptr{Cvoid}}(0)
function __init__()
    ccall((:foo_init, :libfoo), Cvoid, ())
    foo_data_ptr[] = ccall((:foo_data, :libfoo), Ptr{Cvoid}, ())
    nothing
end
```

関数 `__init__` 内でグローバルを定義することは完全に可能であり、これは動的言語を使用する利点の一つです。しかし、グローバルスコープで定数にすることで、コンパイラに型が知られ、より最適化されたコードを生成できるようになります。明らかに、`foo_data_ptr` に依存するモジュール内の他のグローバルも `__init__` で初期化する必要があります。

[`ccall`](@ref)によって生成されないほとんどのJuliaオブジェクトに関する定数は、`__init__`に配置する必要はありません：それらの定義は事前コンパイルされ、キャッシュされたモジュールイメージからロードできます。これには、配列のような複雑なヒープ割り当てオブジェクトが含まれます。ただし、生ポインタ値を返すルーチンは、事前コンパイルが機能するためにランタイムで呼び出す必要があります（[`Ptr`](@ref)オブジェクトは、[`isbits`](@ref)オブジェクトの内部に隠されていない限り、ヌルポインタに変わります）。これには、Julia関数[`@cfunction`](@ref)および[`pointer`](@ref)の戻り値が含まれます。

辞書とセットの型、または一般的に `hash(key)` メソッドの出力に依存するものは、より厄介なケースです。キーが数値、文字列、シンボル、範囲、`Expr`、またはこれらの型の組み合わせ（配列、タプル、セット、ペアなどを介して）である一般的なケースでは、事前コンパイルが安全です。しかし、`Function` や `DataType` のような他のいくつかのキー型、または `hash` メソッドを定義していない汎用のユーザー定義型の場合、フォールバックの `hash` メソッドはオブジェクトのメモリアドレス（その `objectid` を介して）に依存し、したがって実行ごとに変わる可能性があります。これらのキー型のいずれかを持っている場合、または確信が持てない場合は、安全のために `__init__` 関数内からこの辞書を初期化することができます。あるいは、コンパイル時に初期化するのが安全になるように特別に処理されている [`IdDict`](@ref) 辞書型を使用することもできます。

プリコンパイルを使用する際は、コンパイルフェーズと実行フェーズの違いを明確に理解することが重要です。このモードでは、Juliaが任意のJuliaコードの実行を可能にするコンパイラであり、コンパイルされたコードも生成するスタンドアロンのインタプリタではないことが、より明確に示されることがよくあります。

他の既知の潜在的な失敗シナリオには次のものが含まれます：

1. グローバルカウンター（例えば、オブジェクトを一意に識別しようとするためのもの）。次のコードスニペットを考えてみてください：

    ```julia
    mutable struct UniquedById
        myid::Int
        let counter = 0
            UniquedById() = new(counter += 1)
        end
    end
    ```

    このコードの意図は、すべてのインスタンスにユニークなIDを与えることでしたが、カウンタの値はコンパイルの最後に記録されます。この増分コンパイルされたモジュールのその後の使用は、同じカウンタ値から始まります。

    `objectid`（メモリポインタをハッシュ化することで機能する）は、以下の`Dict`の使用に関するノートで示されているように、同様の問題があります。

    一つの代替案は、マクロを使用して [`@__MODULE__`](@ref) をキャプチャし、現在の `counter` 値と一緒にそれだけを保存することですが、このグローバルステートに依存しないようにコードを再設計する方が良いかもしれません。
2. 関連コレクション（`Dict`や`Set`など）は、`__init__`で再ハッシュする必要があります。（将来的には、初期化関数を登録するためのメカニズムが提供されるかもしれません。）
3. コンパイル時の副作用がロード時に持続することに依存します。例としては、他のJuliaモジュール内の配列や他の変数を修正すること、オープンファイルやデバイスへのハンドルを維持すること、他のシステムリソース（メモリを含む）へのポインタを保存することが含まれます。
4. グローバルスコープで、別のモジュールから直接参照することによって、グローバルステートの偶発的な「コピー」を作成すること。例えば：

    ```julia
    #mystdout = Base.stdout #= will not work correctly, since this will copy Base.stdout into this module =#
    # instead use accessor functions:
    getstdout() = Base.stdout #= best option =#
    # or move the assignment into the runtime:
    __init__() = global mystdout = Base.stdout #= also works =#
    ```

コードをプリコンパイルする際に、ユーザーが他の誤った動作の状況を避けるために、実行できる操作にいくつかの追加制限が課されています：

1. [`eval`](@ref)を呼び出して、別のモジュールに副作用を引き起こします。これは、インクリメンタルプリコンパイルフラグが設定されているときに警告が発生する原因にもなります。
2. `__init__()` が開始された後のローカルスコープからの `global const` ステートメント (この件に関するエラー追加の計画については、問題 #12010 を参照)
3. モジュールの置き換えは、インクリメンタルプリコンパイル中のランタイムエラーです。

いくつかの注意すべき点:

1. ソースファイル自体に変更が加えられた後（`Pkg.update`によるものを含む）、コードのリロードやキャッシュの無効化は行われず、`Pkg.rm`の後にクリーンアップも行われません。
2. 再形成された配列のメモリ共有の動作は、事前コンパイルによって無視されます（各ビューは独自のコピーを取得します）。
3. ファイルシステムがコンパイル時と実行時の間で変更されないことを期待すること、例えば [`@__FILE__`](@ref) / `source_path()` を使用して実行時にリソースを見つけることや、BinDeps の `@checked_lib` マクロなどです。時にはこれが避けられないこともあります。しかし、可能な場合は、リソースをコンパイル時にモジュールにコピーすることが良いプラクティスとなることがあります。そうすれば、実行時に見つける必要がなくなります。
4. `WeakRef` オブジェクトとファイナライザは、現在シリアライザによって適切に処理されていません（これは今後のリリースで修正される予定です）。
5. 内部メタデータオブジェクトのインスタンス（`Method`、`MethodInstance`、`MethodTable`、`TypeMapLevel`、`TypeMapEntry`など）への参照をキャプチャすることは通常避けるのが最善です。これはシリアライザーを混乱させ、望む結果を得られない可能性があります。これを行うことが必ずしもエラーであるわけではありませんが、システムがこれらの一部をコピーし、他のもののユニークなインスタンスを作成しようとすることに備えておく必要があります。

モジュール開発中にインクリメンタルプリコンパイルをオフにすることが役立つ場合があります。コマンドラインフラグ `--compiled-modules={yes|no|existing}` を使用すると、モジュールのプリコンパイルをオンまたはオフに切り替えることができます。`--compiled-modules=no` でJuliaを起動すると、コンパイルキャッシュ内のシリアライズされたモジュールは、モジュールおよびモジュール依存関係を読み込む際に無視されます。場合によっては、既存のプリコンパイル済みモジュールを読み込みたいが、新しいものを作成したくないことがあります。これは、`--compiled-modules=existing` でJuliaを起動することで実現できます。プリコンパイル中のネイティブコードストレージにのみ影響を与える `--pkgimages={yes|no|existing}` を使用することで、より細かい制御が可能です。`Base.compilecache` は手動で呼び出すこともできます。このコマンドラインフラグの状態は、パッケージのインストール、更新、および明示的なビルド時に自動プリコンパイルトリガーを無効にするために `Pkg.build` に渡されます。

環境変数を使用して、いくつかのプリコンパイルの失敗をデバッグすることもできます。`JULIA_VERBOSE_LINKING=true`を設定すると、コンパイルされたネイティブコードの共有ライブラリのリンクに関する失敗を解決するのに役立つかもしれません。Juliaマニュアルの**開発者ドキュメント**の部分を参照してください。そこでは、「パッケージイメージ」の下にあるJuliaの内部を文書化したセクションでさらに詳細が見つかります。
