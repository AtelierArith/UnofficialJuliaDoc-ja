# Frequently Asked Questions

## General

### Is Julia named after someone or something?

いいえ。

### Why don't you compile Matlab/Python/R/… code to Julia?

多くの人が他の動的言語の構文に慣れており、すでにそれらの言語で多くのコードが書かれているため、プログラマーに新しい言語を学ばせることなく、Juliaのすべてのパフォーマンスの利点を得るために、MatlabやPythonのフロントエンドをJuliaのバックエンドに接続する（またはコードをJuliaに「トランスパイル」する）ことができなかったのか疑問に思うのは自然です。簡単ですよね？

基本的な問題は、*ジュリアのコンパイラには特別なものが何もない*ということです：私たちは、他の言語開発者が知らない「秘密のソース」なしに、一般的なコンパイラ（LLVM）を使用しています。実際、ジュリアのコンパイラは、他の動的言語（例えば、PyPyやLuaJIT）のものよりも多くの点ではるかにシンプルです。ジュリアのパフォーマンスの利点は、ほぼ完全にそのフロントエンドから生じています：その言語の意味論は、[well-written Julia program](@ref man-performance-tips)が*コンパイラに効率的なコードとメモリレイアウトを生成するためのより多くの機会を与える*ことを可能にします。もしあなたがMatlabやPythonのコードをジュリアにコンパイルしようとした場合、私たちのコンパイラはMatlabやPythonの意味論によって制限され、これらの言語の既存のコンパイラと同じかそれ以下のコードしか生成できません（おそらくそれよりも悪いでしょう）。意味論の重要な役割は、いくつかの既存のPythonコンパイラ（NumbaやPythranなど）が言語の小さなサブセット（例えば、Numpy配列やスカラーに対する操作）を最適化しようとする理由でもあり、このサブセットに関しては、同じ意味論に対して私たちができることと少なくとも同じくらいの成果を上げています。これらのプロジェクトに取り組んでいる人々は非常に賢く、驚くべき成果を上げていますが、解釈されることを前提に設計された言語にコンパイラを適合させることは非常に難しい問題です。

Juliaの利点は、優れたパフォーマンスが「組み込み」型や操作の小さなサブセットに制限されず、任意のユーザー定義型で動作する高レベルの型ジェネリックコードを書くことができるため、迅速かつメモリ効率が良いままであることです。Pythonのような言語では、同様の機能を実現するためにコンパイラに十分な情報を提供しないため、これらの言語をJuliaのフロントエンドとして使用すると、行き詰まってしまいます。

同様の理由から、自動翻訳によるJuliaへの変換も通常は読みにくく、遅く、非慣用的なコードを生成し、他の言語からのネイティブなJuliaポートの良い出発点にはならないでしょう。

一方で、言語 *相互運用性* は非常に便利です：私たちは、Juliaから他の言語の既存の高品質なコードを活用したいと考えています（その逆も同様です）！ これを実現する最良の方法はトランスパイラではなく、むしろ簡単な言語間呼び出し機能を通じてです。私たちは、CおよびFortranライブラリを呼び出すための組み込みの `ccall` 内在関数から、JuliaをPython、Matlab、C++などに接続する [JuliaInterop](https://github.com/JuliaInterop) パッケージに至るまで、これに取り組んできました。

## [Public API](@id man-api)

### How does Julia define its public API?

ジュリアの公開 [API](https://en.wikipedia.org/wiki/API) は、`Base` および標準ライブラリの公開バインディングのドキュメントに記載されている動作です。関数、型、および定数は、公開されていない場合、たとえドキュメント文字列があったり、ドキュメントに記載されていても、公開APIの一部ではありません。さらに、公開バインディングのドキュメント化された動作のみが公開APIの一部です。公開バインディングの未文書化の動作は内部的なものです。

パブリックバインディングは、`public foo` または `export foo` でマークされたものです。

言い換えれば：

  * 公開バインディングの文書化された動作は、公開APIの一部です。
  * 公開バインディングの未文書の動作は、公開APIの一部ではありません。
  * プライベートバインディングの文書化された動作は、公開APIの一部ではありません。
  * プライベートバインディングの文書化されていない動作は、公開APIの一部ではありません。

`names(MyModule)`を使うと、モジュールの公開バインディングの完全なリストを取得できます。

パッケージの著者は、同様に自分の公開APIを定義することが推奨されています。

JuliaのパブリックAPIに含まれるすべてのものは[SemVer](https://semver.org/)によってカバーされており、したがって、Julia 2.0以前に削除されたり、意味のある破壊的変更を受けたりすることはありません。

### There is a useful undocumented function/type/constant. Can I use it?

Updating Julia may break your code if you use non-public API. If the code is self-contained, it may be a good idea to copy it into your project. If you want to rely on a complex non-public API, especially when using it from a stable package, it is a good idea to open an [issue](https://github.com/JuliaLang/julia/issues) or [pull request](https://github.com/JuliaLang/julia/pulls) to start a discussion for turning it into a public API. However, we do not discourage the attempt to create packages that expose stable public interfaces while relying on non-public implementation details of Julia and buffering the differences across different Julia versions.

### The documentation is not accurate enough. Can I rely on the existing behavior?

[issue](https://github.com/JuliaLang/julia/issues) または [pull request](https://github.com/JuliaLang/julia/pulls) を開いて、既存の動作を公開APIに変えるための議論を始めてください。

## Sessions and the REPL

### How do I delete an object in memory?

JuliaにはMATLABの`clear`関数のアナログはありません。名前がJuliaセッション（技術的にはモジュール`Main`）で定義されると、それは常に存在します。

メモリ使用量が気になる場合は、常にメモリを消費しないオブジェクトに置き換えることができます。たとえば、`A` がもはや必要ないギガバイトサイズの配列である場合、`A = nothing` を使ってメモリを解放できます。メモリは、次回ガベージコレクタが実行されるときに解放されます。これを強制的に実行するには、[`GC.gc()`](@ref Base.GC.gc) を使用できます。さらに、`A` を使用しようとすると、ほとんどのメソッドが型 `Nothing` に対して定義されていないため、エラーが発生する可能性が高いです。

## [Scripting](@id man-scripting)

### How do I check if the current file is being run as the main script?

ファイルが `julia file.jl` を使用してメインスクリプトとして実行されるとき、コマンドライン引数の処理のような追加機能を有効にしたい場合があります。このようにファイルが実行されているかどうかを判断する方法は、`abspath(PROGRAM_FILE) == @__FILE__` が `true` であるかどうかを確認することです。

ただし、スクリプトとインポート可能なライブラリの両方として機能するファイルを書くことは推奨されません。ライブラリとしてもスクリプトとしても利用可能な機能が必要な場合は、ライブラリとして書き、その後、機能を別のスクリプトにインポートする方が良いです。

### [How do I catch CTRL-C in a script?](@id catch-ctrl-c)

`julia file.jl`を使用してJuliaスクリプトを実行しても、CTRL-C（SIGINT）で終了しようとしたときに[`InterruptException`](@ref)はスローされません。CTRL-Cによって引き起こされるかもしれない、またはそうでないJuliaスクリプトを終了する前に特定のコードを実行するには、[`atexit`](@ref)を使用してください。あるいは、`julia -e 'include(popfirst!(ARGS))' file.jl`を使用して、[`try`](@ref)ブロック内で`InterruptException`をキャッチできるようにスクリプトを実行することもできます。この戦略では、[`PROGRAM_FILE`](@ref)は設定されないことに注意してください。

### How do I pass options to `julia` using `#!/usr/bin/env`?

`julia`にオプションを渡すためのいわゆるシェバン行、例えば`#!/usr/bin/env julia --startup-file=no`のように記述しても、カーネルがシェルとは異なり、空白文字で引数を分割しない多くのプラットフォーム（BSD、macOS、Linux）では機能しません。単一の引数文字列を空白で複数の引数に分割する`env -S`オプションは、シェルに似た簡単な回避策を提供します。

```julia
#!/usr/bin/env -S julia --color=yes --startup-file=no
@show ARGS  # put any Julia code here
```

!!! note
    オプション `env -S` は FreeBSD 6.0 (2005)、macOS Sierra (2016)、および GNU/Linux coreutils 8.30 (2018) に登場しました。


### Why doesn't `run` support `*` or pipes for scripting external programs?

Juliaの [`run`](@ref) 関数は、[operating-system shell](https://en.wikipedia.org/wiki/Shell_(computing)) を呼び出すことなく、外部プログラムを*直接*起動します（Python、R、Cなどの他の言語の `system("...")` 関数とは異なります）。つまり、`run` は `*` のワイルドカード展開を行わず（["globbing"](https://en.wikipedia.org/wiki/Glob_(programming))）、[shell pipelines](https://en.wikipedia.org/wiki/Pipeline_(Unix)) のように `|` や `>` を解釈することもありません。

あなたはまだJuliaの機能を使用してグロビングやパイプラインを行うことができます。たとえば、組み込みの [`pipeline`](@ref) 関数は、シェルパイプに似た外部プログラムやファイルをチェーンすることを可能にし、[Glob.jl package](https://github.com/vtjnash/Glob.jl) はPOSIX互換のグロビングを実装しています。

You can, of course, run programs through the shell by explicitly passing a shell and a command string to `run`, e.g. ```run(`sh -c "ls > files.txt"`)``` to use the Unix [Bourne shell](https://en.wikipedia.org/wiki/Bourne_shell), but you should generally prefer pure-Julia scripting like ```run(pipeline(`ls`, "files.txt"))```. The reason why we avoid the shell by default is that [shelling out sucks](https://julialang.org/blog/2012/03/shelling-out-sucks/): launching processes via the shell is slow, fragile to quoting of special characters,  has poor error handling, and is problematic for portability.  (The Python developers came to a [similar conclusion](https://www.python.org/dev/peps/pep-0324/#motivation).)

## Variables and Assignments

### Why am I getting `UndefVarError` from a simple loop?

あなたは次のようなものを持っているかもしれません:

```
x = 0
while x < 10
    x += 1
end
```

そして、インタラクティブな環境（Julia REPLのような）では正常に動作することに注意してください。しかし、スクリプトや他のファイルで実行しようとすると、```UndefVarError: `x` not defined```というエラーが発生します。これは、Juliaが一般的に**ローカルスコープ内でグローバル変数に明示的に代入することを要求する**ためです。

ここで、`x`はグローバル変数であり、`while`は[local scope](@ref scope-of-variables)を定義します。そして、`x += 1`はそのローカルスコープ内でのグローバル変数への代入です。

上記のように、Julia（バージョン1.5以降）は、REPL（および多くの他のインタラクティブ環境）でのコードに対して`global`キーワードを省略することを許可しており、探索を簡素化します（例：関数からコードをコピーしてインタラクティブに実行する）。しかし、ファイル内のコードに移行すると、Juliaはグローバル変数に対してより規律あるアプローチを要求します。少なくとも3つのオプションがあります：

1. コードを関数に入れてください（`x`が関数内の*ローカル*変数になるように）。一般的に、グローバルスクリプトよりも関数を使用することは良いソフトウェア工学です（「グローバル変数が悪い理由」をオンラインで検索すると、多くの説明が見つかります）。Juliaでは、グローバル変数は[slow](@ref man-performance-tips)でもあります。
2. [`let`](@ref) ブロック内でコードをラップします。  （これにより、`x` は `let ... end` ステートメント内のローカル変数となり、再び `global` の必要がなくなります）。
3. ローカルスコープ内で`x`を`global`として明示的にマークしてから代入します。例えば、`global x += 1`と書きます。

マニュアルのセクション [on soft scope](@ref on-soft-scope) には、さらに詳しい説明が記載されています。

## Functions

### I passed an argument `x` to a function, modified it inside that function, but on the outside, the variable `x` is still unchanged. Why?

関数を次のように呼び出すとします:

```jldoctest
julia> x = 10
10

julia> function change_value!(y)
           y = 17
       end
change_value! (generic function with 1 method)

julia> change_value!(x)
17

julia> x # x is unchanged!
10
```

Juliaでは、変数`x`のバインディングは、`x`を関数の引数として渡すことで変更することはできません。上記の例で`change_value!(x)`を呼び出すと、`y`は最初に`x`の値、すなわち`10`にバインドされた新しく作成された変数です。その後、`y`は定数`17`に再バインドされますが、外側のスコープの変数`x`はそのまま変更されません。

しかし、`x`が`Array`型（または他の*可変*型）のオブジェクトにバインドされている場合、関数内から`x`をこのArrayから「バインド解除」することはできませんが、その内容を*変更*することはできます。例えば：

```jldoctest
julia> x = [1,2,3]
3-element Vector{Int64}:
 1
 2
 3

julia> function change_array!(A)
           A[1] = 5
       end
change_array! (generic function with 1 method)

julia> change_array!(x)
5

julia> x
3-element Vector{Int64}:
 5
 2
 3
```

ここでは、渡された配列の最初の要素に `5` を割り当てる関数 `change_array!` を作成しました（呼び出し元では `x` にバインドされ、関数内では `A` にバインドされています）。関数呼び出しの後、`x` はまだ同じ配列にバインドされていますが、その配列の内容は変更されました：変数 `A` と `x` は同じ可変 `Array` オブジェクトを参照する異なるバインディングでした。

### Can I use `using` or `import` inside a function?

いいえ、関数内に `using` または `import` 文を持つことは許可されていません。モジュールをインポートしたいが、特定の関数または関数のセット内でのみそのバインディングを使用したい場合は、2つのオプションがあります：

1. `import`を使用します:

    ```julia
    import Foo
    function bar(...)
        # ... refer to Foo bindings via Foo.baz ...
    end
    ```

    これにより、モジュール `Foo` がロードされ、モジュールを参照する変数 `Foo` が定義されますが、モジュールから現在の名前空間に他のバインディングはインポートされません。`Foo` のバインディングには、その修飾名 `Foo.bar` などで参照します。
2. 関数をモジュールにラップします:

    ```julia
    module Bar
    export bar
    using Foo
    function bar(...)
        # ... refer to Foo.baz as simply baz ....
    end
    end
    using Bar
    ```

    これは、`Foo`からすべてのバインディングをインポートしますが、モジュール`Bar`内のみです。

### What does the `...` operator do?

#### The two uses of the `...` operator: slurping and splatting

多くのJuliaの新参者は、`...` 演算子の使い方に混乱します。`...` 演算子が混乱を招く理由の一部は、文脈によって2つの異なる意味を持つからです。

#### `...` combines many arguments into one argument in function definitions

関数定義の文脈において、`...` 演算子は多くの異なる引数を単一の引数に結合するために使用されます。このように多くの異なる引数を単一の引数に結合するための `...` の使用は、スラーピングと呼ばれます：

```jldoctest
julia> function printargs(args...)
           println(typeof(args))
           for (i, arg) in enumerate(args)
               println("Arg #$i = $arg")
           end
       end
printargs (generic function with 1 method)

julia> printargs(1, 2, 3)
Tuple{Int64, Int64, Int64}
Arg #1 = 1
Arg #2 = 2
Arg #3 = 3
```

もしジュリアがASCII文字をより自由に使用する言語であったなら、スラーピング演算子は`...`の代わりに`<-...`として書かれていたかもしれません。

#### `...` splits one argument into many different arguments in function calls

関数を定義する際に多くの異なる引数を1つの引数にまとめるために`...`演算子を使用することとは対照的に、`...`演算子は関数呼び出しの文脈で単一の関数引数を多くの異なる引数に分割するためにも使用されます。この`...`の使用はスプラッティングと呼ばれます：

```jldoctest
julia> function threeargs(a, b, c)
           println("a = $a::$(typeof(a))")
           println("b = $b::$(typeof(b))")
           println("c = $c::$(typeof(c))")
       end
threeargs (generic function with 1 method)

julia> x = [1, 2, 3]
3-element Vector{Int64}:
 1
 2
 3

julia> threeargs(x...)
a = 1::Int64
b = 2::Int64
c = 3::Int64
```

もしジュリアがASCII文字をより自由に使用する言語であったなら、スプラッティング演算子は`...->`として書かれていたかもしれません。

### What is the return value of an assignment?

演算子 `=` は常に右辺を返します。したがって：

```jldoctest
julia> function threeint()
           x::Int = 3.0
           x # returns variable x
       end
threeint (generic function with 1 method)

julia> function threefloat()
           x::Int = 3.0 # returns 3.0
       end
threefloat (generic function with 1 method)

julia> threeint()
3

julia> threefloat()
3.0
```

そして同様に：

```jldoctest
julia> function twothreetup()
           x, y = [2, 3] # assigns 2 to x and 3 to y
           x, y # returns a tuple
       end
twothreetup (generic function with 1 method)

julia> function twothreearr()
           x, y = [2, 3] # returns an array
       end
twothreearr (generic function with 1 method)

julia> twothreetup()
(2, 3)

julia> twothreearr()
2-element Vector{Int64}:
 2
 3
```

## Types, type declarations, and constructors

### [What does "type-stable" mean?](@id man-type-stability)

出力の型が入力の型から予測可能であることを意味します。特に、出力の型は入力の*値*に応じて変わることができないことを意味します。以下のコードは*型安定*ではありません：

```jldoctest
julia> function unstable(flag::Bool)
           if flag
               return 1
           else
               return 1.0
           end
       end
unstable (generic function with 1 method)
```

それは引数の値に応じて `Int` または [`Float64`](@ref) のいずれかを返します。Julia はコンパイル時にこの関数の戻り値の型を予測できないため、これを使用する計算は両方の型の値に対応できる必要があり、これが高速な機械コードを生成するのを難しくします。

### [Why does Julia give a `DomainError` for certain seemingly-sensible operations?](@id faq-domain-errors)

特定の操作は数学的に意味がありますが、エラーを引き起こします：

```jldoctest
julia> sqrt(-2.0)
ERROR: DomainError with -2.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```

この動作は、型安定性の要件の不便な結果です。[`sqrt`](@ref) の場合、ほとんどのユーザーは `sqrt(2.0)` が実数を返すことを望んでおり、複素数 `1.4142135623730951 + 0.0im` を返すと不満に思うでしょう。負の数が渡されたときのみ複素数出力に切り替えるように `4d61726b646f776e2e436f64652822222c2022737172742229_40726566` 関数を書くこともできます（これは他の言語での `4d61726b646f776e2e436f64652822222c2022737172742229_40726566` の動作です）が、その場合、結果は [type-stable](@ref man-type-stability) にはならず、`4d61726b646f776e2e436f64652822222c2022737172742229_40726566` 関数のパフォーマンスは悪くなります。

これらおよび他のケースでは、結果を表現できる*出力タイプ*を受け入れる意欲を伝える*入力タイプ*を選択することで、望む結果を得ることができます：

```jldoctest
julia> sqrt(-2.0+0im)
0.0 + 1.4142135623730951im
```

### How can I constrain or compute type parameters?

The parameters of a [parametric type](@ref Parametric-Types) can hold either types or bits values, and the type itself chooses how it makes use of these parameters. For example, `Array{Float64, 2}` is parameterized by the type `Float64` to express its element type and the integer value `2` to express its number of dimensions. When defining your own parametric type, you can use subtype constraints to declare that a certain parameter must be a subtype ([`<:`](@ref)) of some abstract type or a previous type parameter. There is not, however, a dedicated syntax to declare that a parameter must be a *value* of a given type — that is, you cannot directly declare that a dimensionality-like parameter [`isa`](@ref) `Int` within the `struct` definition, for example. Similarly, you cannot do computations (including simple things like addition or subtraction) on type parameters. Instead, these sorts of constraints and relationships may be expressed through additional type parameters that are computed and enforced within the type's [constructors](@ref man-constructors).

例として、次のことを考えてみてください。

```julia
struct ConstrainedType{T,N,N+1} # NOTE: INVALID SYNTAX
    A::Array{T,N}
    B::Array{T,N+1}
end
```

ユーザーが第三の型パラメータが常に第二の型パラメータに1を加えたものであることを強制したい場合、これは明示的な型パラメータを使用して実装でき、[inner constructor method](@ref man-inner-constructor-methods)によってチェックされます（他のチェックと組み合わせることができます）：

```julia
struct ConstrainedType{T,N,M}
    A::Array{T,N}
    B::Array{T,M}
    function ConstrainedType(A::Array{T,N}, B::Array{T,M}) where {T,N,M}
        N + 1 == M || throw(ArgumentError("second argument should have one more axis" ))
        new{T,N,M}(A, B)
    end
end
```

このチェックは通常*コストがかからない*ものであり、コンパイラは有効な具体的な型のチェックを省略できます。もし第二引数も計算される場合、この計算を行う[outer constructor method](@ref man-outer-constructor-methods)を提供することが有利かもしれません。

```julia
ConstrainedType(A) = ConstrainedType(A, compute_B(A))
```

### [Why does Julia use native machine integer arithmetic?](@id faq-integer-arithmetic)

Juliaは整数計算に機械算術を使用します。これは、`Int`値の範囲が制限されており、両端でラップアラウンドすることを意味します。そのため、整数の加算、減算、乗算はオーバーフローまたはアンダーフローする可能性があり、最初は不安を感じる結果をもたらすことがあります。

```jldoctest
julia> x = typemax(Int)
9223372036854775807

julia> y = x+1
-9223372036854775808

julia> z = -y
-9223372036854775808

julia> 2*z
0
```

明らかに、これは数学的整数の振る舞いとは大きく異なり、高水準プログラミング言語がこれをユーザーに公開するのは理想的ではないと思うかもしれません。しかし、効率と透明性が重要な数値作業においては、代替手段はさらに悪化します。

考慮すべき代替案の一つは、各整数演算のオーバーフローをチェックし、オーバーフローが発生した場合に結果を [`Int128`](@ref) や [`BigInt`](@ref) のようなより大きな整数型に昇格させることです。残念ながら、これはすべての整数演算に対して大きなオーバーヘッドをもたらします（ループカウンタのインクリメントを考えてみてください） – 算術命令の後に実行時オーバーフローチェックを行うためのコードを生成し、潜在的なオーバーフローを処理するための分岐が必要になります。さらに悪いことに、これにより整数を含むすべての計算が型不安定になります。前述のように、効率的なコードの生成には [type-stability is crucial](@ref man-type-stability) が必要です。整数演算の結果が整数であることを信頼できない場合、CやFortranコンパイラのように高速でシンプルなコードを生成することは不可能です。

このアプローチの変種は、型の不安定性の外観を避けるために、`Int` と [`BigInt`](@ref) タイプを単一のハイブリッド整数型に統合し、結果がマシン整数のサイズに収まらなくなったときに内部的に表現を変更することです。この方法は、表面的にはJuliaコードのレベルで型の不安定性を回避しますが、実際にはこのハイブリッド整数型を実装するCコードに同じ困難を押し付けることで問題を隠しているだけです。このアプローチは*機能させることができ*、多くの場合かなり高速にすることも可能ですが、いくつかの欠点があります。一つの問題は、整数と整数の配列のメモリ内表現が、C、Fortran、その他のネイティブマシン整数を持つ言語で使用される自然な表現と一致しなくなることです。したがって、これらの言語と相互運用するためには、最終的にはネイティブ整数型を導入する必要があります。無制限の整数表現は固定ビット数を持つことができず、したがって固定サイズのスロットを持つ配列にインラインで格納することはできません – 大きな整数値は常に別のヒープ割り当てストレージを必要とします。そしてもちろん、どんなに巧妙なハイブリッド整数実装を使用しても、常にパフォーマンスの罠があります – パフォーマンスが予期せず低下する状況です。複雑な表現、CおよびFortranとの相互運用性の欠如、追加のヒープストレージなしで整数配列を表現できないこと、予測不可能なパフォーマンス特性は、最も巧妙なハイブリッド整数実装でさえ、高性能数値作業には不適切な選択となります。

ハイブリッド整数を使用するか、BigIntに昇格させる代わりに、飽和整数演算を使用することができます。ここでは、最大の整数値に加算してもその値は変わらず、最小の整数値から減算しても同様です。これはまさにMatlab™が行っていることです：

```
>> int64(9223372036854775807)

ans =

  9223372036854775807

>> int64(9223372036854775807) + 1

ans =

  9223372036854775807

>> int64(-9223372036854775808)

ans =

 -9223372036854775808

>> int64(-9223372036854775808) - 1

ans =

 -9223372036854775808
```

最初の印象では、9223372036854775807は9223372036854775808に非常に近く、-9223372036854775808よりも合理的に思えます。また、整数はCやFortranと互換性のある自然な方法で固定サイズで表現されます。しかし、飽和整数演算は深刻な問題を抱えています。最初の、そして最も明白な問題は、これは機械の整数演算の動作ではないため、飽和演算を実装するには、各機械整数演算の後にアンダーフローやオーバーフローをチェックし、結果を適切に[`typemin(Int)`](@ref)または[`typemax(Int)`](@ref)に置き換えるための命令を発行する必要があります。これだけで、各整数演算は単一の高速命令から半ダースの命令に拡張され、おそらく分岐を含むことになります。痛いですね。しかし、さらに悪化します – 飽和整数演算は結合的ではありません。このMatlabの計算を考えてみてください：

```
>> n = int64(2)^62
4611686018427387904

>> n + (n - 1)
9223372036854775807

>> (n + n) - 1
9223372036854775806
```

これにより、多くの基本的な整数アルゴリズムを書くのが難しくなります。なぜなら、多くの一般的な手法が、オーバーフローを伴う機械の加算が *結合的* であるという事実に依存しているからです。Juliaで整数値 `lo` と `hi` の間の中点を見つけることを考えてみましょう。式は `(lo + hi) >>> 1` です：

```jldoctest
julia> n = 2^62
4611686018427387904

julia> (n + 2n) >>> 1
6917529027641081856
```

見てください。問題ありません。`2^62`と`2^63`の間の正しい中点です。`n + 2n`が-4611686018427387904であるにもかかわらず。では、Matlabで試してみてください：

```
>> (n + 2*n)/2

ans =

  4611686018427387904
```

おっと。Matlabに`>>>`演算子を追加しても役に立ちません。なぜなら、`n`と`2n`を加算する際に発生する飽和が、正しい中点を計算するために必要な情報をすでに破壊してしまっているからです。

結合性の欠如は、このような技術に頼ることができないプログラマーにとって不幸であるだけでなく、コンパイラが整数演算を最適化するために行いたいほとんどすべてのことを妨げます。たとえば、Juliaの整数は通常のマシン整数演算を使用しているため、LLVMは`f(k) = 5k-1`のような単純な小さな関数を積極的に最適化することができます。この関数のマシンコードは次のとおりです：

```julia-repl
julia> code_native(f, Tuple{Int})
  .text
Filename: none
  pushq %rbp
  movq  %rsp, %rbp
Source line: 1
  leaq  -1(%rdi,%rdi,4), %rax
  popq  %rbp
  retq
  nopl  (%rax,%rax)
```

関数の実際の本体は単一の `leaq` 命令であり、整数の乗算と加算を一度に計算します。これは、`f` が別の関数にインライン化されるときにさらに有益です：

```julia-repl
julia> function g(k, n)
           for i = 1:n
               k = f(k)
           end
           return k
       end
g (generic function with 1 methods)

julia> code_native(g, Tuple{Int,Int})
  .text
Filename: none
  pushq %rbp
  movq  %rsp, %rbp
Source line: 2
  testq %rsi, %rsi
  jle L26
  nopl  (%rax)
Source line: 3
L16:
  leaq  -1(%rdi,%rdi,4), %rdi
Source line: 2
  decq  %rsi
  jne L16
Source line: 5
L26:
  movq  %rdi, %rax
  popq  %rbp
  retq
  nop
```

`f`がインライン化されるため、ループ本体は単一の`leaq`命令だけになります。次に、ループの反復回数を固定した場合に何が起こるかを考えてみましょう。

```julia-repl
julia> function g(k)
           for i = 1:10
               k = f(k)
           end
           return k
       end
g (generic function with 2 methods)

julia> code_native(g,(Int,))
  .text
Filename: none
  pushq %rbp
  movq  %rsp, %rbp
Source line: 3
  imulq $9765625, %rdi, %rax    # imm = 0x9502F9
  addq  $-2441406, %rax         # imm = 0xFFDABF42
Source line: 5
  popq  %rbp
  retq
  nopw  %cs:(%rax,%rax)
```

コンパイラは整数の加算と乗算が結合的であり、乗算が加算に対して分配的であることを知っているため（飽和算術ではどちらも成り立たない）、ループ全体を単に乗算と加算に最適化できます。飽和算術はこの種の最適化を完全に無効にします。なぜなら、結合性と分配性は各ループの反復で失敗する可能性があり、失敗が発生する反復によって異なる結果を引き起こすからです。コンパイラはループを展開できますが、複数の操作をより少ない同等の操作に代数的に削減することはできません。

整数演算が静かにオーバーフローするのを避ける最も合理的な代替手段は、すべての場所でチェック付き演算を行い、加算、減算、乗算がオーバーフローしたときにエラーを発生させ、値が正しくない値を生成することです。この [blog post](https://danluu.com/integer-overflow/) で、Dan Luu はこれを分析し、このアプローチが理論的には trivial なコストを持つべきであるにもかかわらず、コンパイラ（LLVM と GCC）が追加されたオーバーフローチェックの周りを優雅に最適化しないために、実際にはかなりのコストがかかることを発見しました。将来的にこれが改善されれば、Julia でチェック付き整数演算をデフォルトにすることを検討できますが、現時点ではオーバーフローの可能性と共に生きていかなければなりません。

その間、オーバーフロー安全な整数操作は、[SaferIntegers.jl](https://github.com/JeffreySarnoff/SaferIntegers.jl)のような外部ライブラリを使用することで実現できます。前述のように、これらのライブラリを使用すると、チェックされた整数型を使用するコードの実行時間が大幅に増加することに注意してください。しかし、限られた使用の場合、これはすべての整数操作に使用される場合よりもはるかに問題ではありません。ディスカッションの状況をフォローすることができます [here](https://github.com/JuliaLang/julia/issues/855)。

### What are the possible causes of an `UndefVarError` during remote execution?

エラーが示すように、リモートノードでの `UndefVarError` の直接的な原因は、その名前によるバインディングが存在しないことです。いくつかの可能性のある原因を探ってみましょう。

```julia-repl
julia> module Foo
           foo() = remotecall_fetch(x->x, 2, "Hello")
       end

julia> Foo.foo()
ERROR: On worker 2:
UndefVarError: `Foo` not defined in `Main`
Stacktrace:
[...]
```

クロージャ `x->x` は `Foo` への参照を持っており、`Foo` がノード 2 で利用できないため、`UndefVarError` がスローされます。

`Main`以外のモジュールのグローバルは、リモートノードに値としてシリアライズされません。参照のみが送信されます。グローバルバインディングを作成する関数（`Main`以外）は、後で`UndefVarError`がスローされる原因となる可能性があります。

```julia-repl
julia> @everywhere module Foo
           function foo()
               global gvar = "Hello"
               remotecall_fetch(()->gvar, 2)
           end
       end

julia> Foo.foo()
ERROR: On worker 2:
UndefVarError: `gvar` not defined in `Main.Foo`
Stacktrace:
[...]
```

上記の例では、`@everywhere module Foo` がすべてのノードで `Foo` を定義しました。しかし、`Foo.foo()` の呼び出しはローカルノードに新しいグローバルバインディング `gvar` を作成しましたが、これはノード2では見つからず、`UndefVarError` エラーが発生しました。

このことは、モジュール `Main` の下で作成されたグローバルには適用されないことに注意してください。モジュール `Main` の下のグローバルはシリアライズされ、リモートノードで `Main` の下に新しいバインディングが作成されます。

```julia-repl
julia> gvar_self = "Node1"
"Node1"

julia> remotecall_fetch(()->gvar_self, 2)
"Node1"

julia> remotecall_fetch(varinfo, 2)
name          size summary
––––––––– –––––––– –––––––
Base               Module
Core               Module
Main               Module
gvar_self 13 bytes String
```

これは `function` または `struct` の宣言には適用されません。ただし、グローバル変数にバインドされた匿名関数は、以下に示すようにシリアライズされます。

```julia-repl
julia> bar() = 1
bar (generic function with 1 method)

julia> remotecall_fetch(bar, 2)
ERROR: On worker 2:
UndefVarError: `#bar` not defined in `Main`
[...]

julia> anon_bar  = ()->1
(::#21) (generic function with 1 method)

julia> remotecall_fetch(anon_bar, 2)
1
```

## Troubleshooting "method not matched": parametric type invariance and `MethodError`s

### Why doesn't it work to declare `foo(bar::Vector{Real}) = 42` and then call `foo([1])`?

試してみるとわかるように、結果は `MethodError` です:

```jldoctest
julia> foo(x::Vector{Real}) = 42
foo (generic function with 1 method)

julia> foo([1])
ERROR: MethodError: no method matching foo(::Vector{Int64})
The function `foo` exists, but no method is defined for this combination of argument types.

Closest candidates are:
  foo(!Matched::Vector{Real})
   @ Main none:1

Stacktrace:
[...]
```

これは `Vector{Real}` が `Vector{Int}` のスーパタイプではないためです！この問題は、`foo(bar::Vector{T}) where {T<:Real}` のようなもので解決できます（または、関数の本体で静的パラメータ `T` が必要ない場合は短縮形 `foo(bar::Vector{<:Real})` を使用できます）。`T` はワイルドカードです：まずそれが Real のサブタイプである必要があることを指定し、その後その型の要素を持つベクターを関数が受け取ることを指定します。

この同じ問題は、`Vector`だけでなく、任意の合成型`Comp`にも当てはまります。`Comp`が型`Y`のパラメータを持つ場合、型`X<:Y`のパラメータを持つ別の型`Comp2`は`Comp`のサブタイプではありません。これは型の不変性です（対照的に、Tupleはそのパラメータにおいて型の共変性を持ちます）。これらの詳細については、[Parametric Composite Types](@ref man-parametric-composite-types)を参照してください。

### Why does Julia use `*` for string concatenation? Why not `+` or something else?

[main argument](@ref man-concatenation) に対する `+` の主な点は、文字列の連結は可換ではないのに対し、`+` は一般的に可換演算子として使用されることです。Juliaコミュニティは、他の言語が異なる演算子を使用していることを認識しており、`*` が一部のユーザーには馴染みがないかもしれませんが、特定の代数的性質を伝えます。

`string(...)`を使用して文字列（および文字列に変換された他の値）を連結することもできることに注意してください。同様に、`repeat`は文字列を繰り返すために`^`の代わりに使用できます。[interpolation syntax](@ref string-interpolation)も文字列を構築するのに便利です。

## Packages and Modules

### What is the difference between "using" and "import"?

`using` と `import` にはいくつかの違いがありますが（詳細は [Modules section](https://docs.julialang.org/en/v1/manual/modules/#modules) を参照）、最初は直感的でないかもしれない重要な違いがあります。そして、表面的には（つまり、構文的には）非常に小さな違いに見えるかもしれません。`using` でモジュールを読み込むときは、`function Foo.bar(...` と言わなければならず、モジュール `Foo` の関数 `bar` を新しいメソッドで拡張しますが、`import Foo.bar` の場合は、`function bar(...` と言うだけで、自動的にモジュール `Foo` の関数 `bar` を拡張します。

このことが別の構文を持つほど重要な理由は、知らない関数を誤って拡張したくないからです。そうすると、バグが発生する可能性が高くなります。これは、文字列や整数のような一般的な型を受け取るメソッドで最も起こりやすいです。なぜなら、あなたと他のモジュールの両方がそのような一般的な型を処理するメソッドを定義する可能性があるからです。`import`を使用すると、他のモジュールの`bar(s::AbstractString)`の実装があなたの新しい実装で置き換えられ、全く異なる動作をする可能性があり（そして、モジュールFoo内の他の関数がbarを呼び出すことに依存している場合、すべて/多くの将来の使用が壊れる可能性があります）。

## Nothingness and missing values

### [How does "null", "nothingness" or "missingness" work in Julia?](@id faq-nothing)

多くの言語（例えば、CやJava）とは異なり、Juliaのオブジェクトはデフォルトで「null」にはなりません。参照（変数、オブジェクトフィールド、または配列要素）が初期化されていない場合、それにアクセスするとすぐにエラーが発生します。この状況は、[`isdefined`](@ref) または [`isassigned`](@ref Base.isassigned) 関数を使用して検出できます。

いくつかの関数は副作用のためだけに使用され、値を返す必要はありません。これらの場合、慣例として値 `nothing` を返すことになっており、これは `Nothing` 型のシングルトンオブジェクトです。これはフィールドを持たない普通の型であり、この慣例と、REPLがそれに対して何も印刷しないことを除いて特別なことはありません。そうでなければ値を持たない言語構造のいくつかも `nothing` を返します。例えば、`if false; end` のようにです。

値 `x` が型 `T` のものである場合、存在するのが時々だけである状況には、関数引数、オブジェクトフィールド、および配列要素型に `Union{T, Nothing}` 型を使用できます。これは他の言語における [`Nullable`, `Option` or `Maybe`](https://en.wikipedia.org/wiki/Nullable_type) の同等物です。値自体が `nothing` である可能性がある場合（特に `T` が `Any` の場合）、`Union{Some{T}, Nothing}` 型の方が適切です。なぜなら、`x == nothing` は値の不在を示し、`x == Some(nothing)` は `nothing` に等しい値の存在を示すからです。[`something`](@ref) 関数は、`Some` オブジェクトをアンラップし、`nothing` 引数の代わりにデフォルト値を使用することを可能にします。コンパイラは、`Union{T, Nothing}` 引数やフィールドで効率的なコードを生成できることに注意してください。

統計的な意味で欠損データを表すには（Rの`NA`やSQLの`NULL`）、[`missing`](@ref)オブジェクトを使用してください。詳細については、[`Missing Values`](@ref missing)セクションを参照してください。

いくつかの言語では、空のタプル（`()`）は無の標準形と見なされます。しかし、Juliaでは、ゼロの値を含む通常のタプルとして考えるのが最適です。

空の（または「ボトム」）型は、`Union{}`（空のユニオン型）として書かれ、値もサブタイプも持たない型です（自分自身を除く）。一般的に、この型を使用する必要はありません。

## Memory

### Why does `x += y` allocate memory when `x` and `y` are arrays?

Juliaでは、`x += y`は低下時に`x = x + y`に置き換えられます。配列の場合、これは結果を`x`と同じメモリ位置に保存するのではなく、新しい配列を割り当てて結果を保存することになります。`x`を変更したい場合は、各要素を個別に更新するために`x .+= y`を使用してください。

この動作は一部の人には驚きかもしれませんが、その選択は意図的です。主な理由は、作成された後に値を変更できない不変オブジェクトがJuliaに存在することです。実際、数値は不変オブジェクトです。`x = 5; x += 1`という文は`5`の意味を変更するのではなく、`x`にバインドされた値を変更します。不変オブジェクトの場合、値を変更する唯一の方法は再割り当てすることです。

さらに詳しく説明するために、次の関数を考えてみましょう：

```julia
function power_by_squaring(x, n::Int)
    ispow2(n) || error("This implementation only works for powers of 2")
    while n >= 2
        x *= x
        n >>= 1
    end
    x
end
```

`x = 5; y = power_by_squaring(x, 4)` のような呼び出しの後、期待される結果は `x == 5 && y == 625` になります。しかし、もし `*=` が行列に使用された場合、左辺を変異させると仮定すると、2つの問題が発生します：

  * 一般的な正方行列に対して、`A = A*B`は一時的なストレージなしには実装できません：`A[1,1]`は左辺に計算されて格納される前に、右辺で使用されるためです。
  * 一時的な計算のためにメモリを割り当てることにした場合（これは `*=` をインプレースで機能させる目的のほとんどを排除します）、`x` の可変性を利用すると、この関数は可変入力と不変入力で異なる動作をします。特に、不変の `x` に対しては、呼び出し後に（一般的に） `y != x` になりますが、可変の `x` に対しては `y == x` になります。

汎用プログラミングをサポートすることが、他の手段（例えば、ブロードキャスティングや明示的なループを使用すること）によって達成できる潜在的なパフォーマンス最適化よりも重要であると見なされているため、`+=` や `*=` のような演算子は新しい値を再バインドすることによって機能します。

## [Asynchronous IO and concurrent synchronous writes](@id faq-async-io)

### Why do concurrent writes to the same stream result in inter-mixed output?

ストリーミングI/O APIは同期的ですが、基盤となる実装は完全に非同期です。

考慮してください。次の出力を印刷した結果:

```
julia> @sync for i in 1:3
           Threads.@spawn write(stdout, string(i), " Foo ", " Bar ")
       end
123 Foo  Foo  Foo  Bar  Bar  Bar
```

これは、`write`呼び出しが同期的である一方で、各引数の書き込みがI/Oのその部分が完了するのを待っている間に他のタスクに譲るために発生しています。

`print` と `println` は呼び出し中にストリームを「ロック」します。したがって、上記の例で `write` を `println` に変更すると、次のようになります:

```
julia> @sync for i in 1:3
           Threads.@spawn println(stdout, string(i), " Foo ", " Bar ")
       end
1 Foo  Bar
2 Foo  Bar
3 Foo  Bar
```

`ReentrantLock`を使って、次のように書き込みをロックできます:

```
julia> l = ReentrantLock();

julia> @sync for i in 1:3
           Threads.@spawn begin
               lock(l)
               try
                   write(stdout, string(i), " Foo ", " Bar ")
               finally
                   unlock(l)
               end
           end
       end
1 Foo  Bar 2 Foo  Bar 3 Foo  Bar
```

## Arrays

### [What are the differences between zero-dimensional arrays and scalars?](@id faq-array-0dim)

ゼロ次元配列は、`Array{T,0}`の形式の配列です。スカラーに似た動作をしますが、重要な違いがあります。配列の一般的な定義を考えると論理的に意味を持つ特別なケースであるため、特別に言及する価値がありますが、最初は少し直感に反するかもしれません。以下の行はゼロ次元配列を定義します：

```
julia> A = zeros()
0-dimensional Array{Float64,0}:
0.0
```

この例では、`A`は1つの要素を含む可変コンテナであり、`A[] = 1.0`で設定でき、`A[]`で取得できます。すべてのゼロ次元配列は同じサイズ（`size(A) == ()`）と長さ（`length(A) == 1`）を持ちます。特に、ゼロ次元配列は空ではありません。これが直感的でないと感じる場合、Juliaの定義を理解するのに役立ついくつかのアイデアを以下に示します。

  * ゼロ次元配列は、ベクトルの「線」や行列の「平面」に対する「点」です。線が面積を持たないのと同様に（しかし、依然として一連のものを表します）、点は長さや次元を持たない（しかし、依然として一つのものを表します）。
  * `prod(())`は1と定義され、配列の要素の総数はサイズの積です。ゼロ次元配列のサイズは`()`であり、したがってその長さは`1`です。
  * ゼロ次元配列は、インデックスを付けるための次元を持っていません – それらは単に `A[]` です。他のすべての配列の次元と同様に、同じ「末尾の1」ルールを適用できるので、実際に `A[1]`、`A[1,1]` などとしてインデックスを付けることができます; [Omitted and extra indices](@ref) を参照してください。

通常のスカラーとの違いを理解することも重要です。スカラーは可変コンテナではありません（イテラブルであり、`length`や`getindex`などのものを定義しますが、*e.g.* `1[] == 1`）。特に、`x = 0.0`がスカラーとして定義されている場合、`x[] = 1.0`を通じてその値を変更しようとすることはエラーです。スカラー`x`は`fill(x)`を介してそれを含むゼロ次元配列に変換でき、逆に、ゼロ次元配列`a`は`a[]`を介して含まれているスカラーに変換できます。もう一つの違いは、スカラーは`2 * rand(2,2)`のような線形代数演算に参加できるのに対し、ゼロ次元配列`fill(2) * rand(2,2)`との類似の演算はエラーになることです。

### Why are my Julia benchmarks for linear algebra operations different from other languages?

単純なベンチマークを見つけることができるかもしれません。線形代数の基本要素のような

```julia
using BenchmarkTools
A = randn(1000, 1000)
B = randn(1000, 1000)
@btime $A \ $B
@btime $A * $B
```

他の言語、例えば Matlab や R と比較すると異なる場合があります。

このような操作は関連するBLAS関数の非常に薄いラッパーであるため、差異の理由は非常に可能性が高いです。

1. 各言語が使用しているBLASライブラリ、
2. 同時スレッドの数。

Juliaは独自のOpenBLASのコピーをコンパイルして使用し、スレッドは現在`8`（またはコアの数）に制限されています。

Modifying OpenBLAS settings or compiling Julia with a different BLAS library, eg [Intel MKL](https://software.intel.com/en-us/mkl), may provide performance improvements. You can use [MKL.jl](https://github.com/JuliaComputing/MKL.jl), a package that makes Julia's linear algebra use Intel MKL BLAS and LAPACK instead of OpenBLAS, or search the discussion forum for suggestions on how to set this up manually. Note that Intel MKL cannot be bundled with Julia, as it is not open source.

## Computing cluster

### How do I manage precompilation caches in distributed file systems?

高性能コンピューティング（HPC）施設で共有ファイルシステムを使用してJuliaを利用する場合、共有デポを使用することが推奨されます（[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH) 環境変数を介して）。Julia v1.10以降、機能的に類似したワーカー上で複数のJuliaプロセスが同じデポを使用する場合、pidfileロックを介して調整され、他のプロセスが待機している間に1つのプロセスでのみ事前コンパイルを行うようにします。事前コンパイルプロセスは、プロセスが事前コンパイル中であるか、他のプロセスを待機しているかを示します。非対話的な場合、メッセージは`@debug`を介して表示されます。

しかし、バイナリコードのキャッシュのため、v1.9以降のキャッシュ拒否はより厳格になっており、ユーザーはHPC環境全体で使用可能な単一のキャッシュを取得するために、[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET) 環境変数を適切に設定する必要があるかもしれません。

## Julia Releases

### Do I want to use the Stable, LTS, or nightly version of Julia?

Juliaの安定版は、最新のリリース版であり、ほとんどの人が実行したいバージョンです。最新の機能が含まれており、パフォーマンスが向上しています。Juliaの安定版は、[SemVer](https://semver.org/)に従ってバージョン管理されており、v1.x.yとして表されます。新しい安定版に対応する新しいマイナーバージョンのJuliaは、リリース候補として数週間のテストの後、約4〜5ヶ月ごとに作成されます。LTSバージョンとは異なり、安定版は別の安定版のJuliaがリリースされた後、通常はバグ修正を受けません。ただし、次の安定版へのアップグレードは常に可能であり、各リリースのJulia v1.xは、以前のバージョン用に書かれたコードを引き続き実行できます。

LTS（長期サポート）バージョンのJuliaは、非常に安定したコードベースを求めている場合に好まれるかもしれません。現在のLTSバージョンのJuliaは、SemVerに従ってv1.6.xとしてバージョン管理されています。このブランチは、新しいLTSブランチが選ばれるまでバグ修正を受け続けます。その時点で、v1.6.xシリーズは定期的なバグ修正を受けなくなり、最も保守的なユーザーを除いてすべてのユーザーに新しいLTSバージョンシリーズへのアップグレードが推奨されます。パッケージ開発者としては、LTSバージョン向けに開発することで、あなたのパッケージを使用できるユーザーの数を最大化することを好むかもしれません。SemVerに従って、v1.0向けに書かれたコードは、すべての将来のLTSおよび安定版で引き続き動作します。一般的に、LTSをターゲットにしていても、最新の安定版でコードを開発および実行することができ、パフォーマンスの向上を活用できます。ただし、新しい機能（追加されたライブラリ関数や新しいメソッドなど）を使用しない限りです。

夜間版のJuliaを利用することを好むかもしれません。最新の言語の更新を活用したい場合、今日利用可能なバージョンが時々実際には動作しないことを気にしないのであればです。名前が示すように、夜間版へのリリースはおおよそ毎晩行われます（ビルドインフラの安定性に依存します）。一般的に、夜間版は比較的安全に使用できます—あなたのコードが燃え上がることはありません。ただし、時折回帰や問題が発生する可能性があり、より徹底したプレリリーステストが行われるまで発見されないことがあります。リリースが行われる前に、あなたのユースケースに影響を与えるような回帰が検出されることを確認するために、夜間版でテストを行うことをお勧めします。

最後に、ソースから自分でJuliaをビルドすることも検討できます。このオプションは、主にコマンドラインに慣れているか、学ぶことに興味がある個人向けです。もしこれがあなたに当てはまるなら、私たちの [guidelines for contributing](https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md) を読むことにも興味があるかもしれません。

[`juliaup` install manager](https://julialang.org/install/) には、最新の安定版リリース用の `release` と現在の LTS リリース用の `lts` という事前定義されたチャネルがあり、バージョン固有のチャネルもあります。

### How can I transfer the list of installed packages after updating my version of Julia?

各マイナーバージョンのJuliaには、それぞれ独自のデフォルト [environment](https://docs.julialang.org/en/v1/manual/code-loading/#Environments-1) があります。そのため、新しいマイナーバージョンのJuliaをインストールすると、前のマイナーバージョンで追加したパッケージはデフォルトでは利用できなくなります。特定のJuliaバージョンの環境は、`.julia/environments/`内のバージョン番号に一致するフォルダーにある`Project.toml`および`Manifest.toml`ファイルによって定義されます。例えば、`.julia/environments/v1.3`のようになります。

新しいマイナーバージョンのJulia（例えば`1.4`）をインストールし、以前のバージョン（例えば`1.3`）と同じパッケージをデフォルト環境で使用したい場合は、`1.3`フォルダーから`Project.toml`ファイルの内容を`1.4`にコピーします。その後、新しいJuliaバージョンのセッションで、キー`]`を押して「パッケージ管理モード」に入り、次のコマンドを実行します：[`instantiate`](https://julialang.github.io/Pkg.jl/v1/api/#Pkg.instantiate)。

この操作は、コピーしたファイルからターゲットのJuliaバージョンと互換性のある一連の実行可能なパッケージを解決し、適切であればそれらをインストールまたは更新します。前のJuliaバージョンで使用していたパッケージのセットだけでなく、バージョンも再現したい場合は、Pkgコマンド`instantiate`を実行する前に`Manifest.toml`ファイルもコピーする必要があります。ただし、パッケージは互換性の制約を定義している場合があり、Juliaのバージョンを変更することで影響を受ける可能性があるため、`1.3`で持っていた正確なバージョンのセットが`1.4`で動作しない場合があります。
