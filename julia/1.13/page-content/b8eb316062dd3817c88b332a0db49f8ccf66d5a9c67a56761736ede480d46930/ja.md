# Frequently Asked Questions

## General

### Is Julia named after someone or something?

いいえ。

### Why don't you compile Matlab/Python/R/… code to Julia?

多くの人がほかの動的言語の構文に慣れており、そうした言語で書かれたコードもすでに大量にあるため、新しい言語を学ばなくてもJuliaの性能上の利点を得られるよう、MatlabやPythonのフロントエンドをJuliaのバックエンドに接続したり、コードをJuliaに「トランスパイル」したりすればよいのではないか、と考えるのは自然なことです。簡単そうですよね？

根本的な問題は、*Juliaのコンパイラに特別な仕掛けがあるわけではない*ということです。私たちが使っているのは一般的なコンパイラ（LLVM）であり、ほかの言語の開発者が知らないような「秘密の技術」はありません。実際、Juliaのコンパイラは多くの点で、ほかの動的言語のコンパイラ（PyPyやLuaJITなど）よりもずっと単純です。Juliaの性能上の優位性は、ほぼ全面的にフロントエンドに由来します。Juliaの言語仕様によって、[well-written Julia program](@ref man-performance-tips)がコンパイラに効率的なコードやメモリレイアウトを生成する機会をより多く与えられるのです。MatlabやPythonのコードをJuliaにコンパイルしようとしても、MatlabやPythonの言語仕様に制約されるため、私たちのコンパイラが生成できるコードは、既存の各言語向けコンパイラと同等か、それより劣るものになるでしょう。言語仕様が重要なのはこのためでもあります。既存のPythonコンパイラ（NumbaやPythranなど）が最適化の対象を言語のごく一部（たとえばNumpyの配列やスカラーに対する演算）に限っているのも、そのためです。そして、その範囲では、同じ言語仕様を前提とする限り、すでに私たちと同等以上の性能を実現しています。これらのプロジェクトに携わる人々は非常に優秀で、素晴らしい成果を上げています。しかし、インタープリターでの実行を前提に設計された言語に、後からコンパイラを組み込むのは非常に難しい問題です。

Juliaの強みは、高い性能が「組み込み」型や演算のごく一部に限られないことです。ユーザーが定義した任意の型に対応しながら、高速かつメモリ効率のよい高水準の型ジェネリックコードを書けます。Pythonのような言語の型は、同様の機能を実現するために必要な情報をコンパイラに十分提供しません。そのため、そうした言語をJuliaのフロントエンドとして使おうとした時点で、行き詰まってしまいます。

同じ理由から、Juliaへの自動変換で生成されるコードは、たいてい読みにくく、遅く、Juliaらしくないものになります。そのため、ほかの言語からJuliaへネイティブに移植する際のよい出発点にはなりません。

一方、言語間の*相互運用性*は非常に有用です。Juliaからほかの言語の高品質な既存コードを活用したいですし、その逆も同様です。これを実現する最善の方法はトランスパイラではなく、言語間の呼び出しを簡単にする仕組みです。私たちはこの点に力を注いできました。CやFortranのライブラリを呼び出す組み込みの`ccall`から、JuliaとPython、Matlab、C++などを接続する[JuliaInterop](https://github.com/JuliaInterop)パッケージまで、さまざまな方法を用意しています。

## [Public API](@id man-api)

### How does Julia define its public API?

Juliaの公開[API](https://en.wikipedia.org/wiki/API)とは、`Base`および標準ライブラリの公開バインディングについて、ドキュメントに記載された動作を指します。公開されていない関数、型、定数は、docstringがあったりドキュメントに記載されていたりしても、公開APIには含まれません。また、公開バインディングであっても、ドキュメントに記載された動作だけが公開APIの一部です。ドキュメントに記載されていない動作は内部仕様です。

公開バインディングとは、`public foo`または`export foo`のいずれかが付いているものです。

つまり、次のようになります。

  * 公開バインディングのうち、ドキュメントに記載された動作は公開APIの一部です。
  * 公開バインディングのうち、ドキュメントに記載されていない動作は公開APIの一部ではありません。
  * 非公開バインディングの動作がドキュメントに記載されていても、公開APIの一部ではありません。
  * 非公開バインディングのうち、ドキュメントに記載されていない動作は公開APIの一部ではありません。

モジュールの公開バインディング一覧は、`names(MyModule)`で取得できます。

パッケージの作者にも、同様に公開APIを定義することを推奨します。

Juliaの公開APIに含まれるものは[SemVer](https://semver.org/)の対象となるため、Julia 2.0より前に削除されたり、互換性を大きく損なう変更が加えられたりすることはありません。

### There is a useful undocumented function/type/constant. Can I use it?

非公開APIを使っている場合、Juliaを更新するとコードが動かなくなることがあります。コードが自己完結しているなら、プロジェクトにコピーしておくのもよいでしょう。複雑な非公開APIに依存したい場合、特に安定版パッケージから利用する場合は、公開API化に向けた議論を始めるために[issue](https://github.com/JuliaLang/julia/issues)または[pull request](https://github.com/JuliaLang/julia/pulls)を作成するとよいでしょう。ただし、Juliaの非公開実装の詳細に依存しつつ、Juliaのバージョン間の違いを吸収して安定した公開インターフェースを提供するパッケージを作ることを、私たちは妨げていません。

### The documentation is not accurate enough. Can I rely on the existing behavior?

既存の動作を公開APIにするための議論を始めるには、[issue](https://github.com/JuliaLang/julia/issues)または[pull request](https://github.com/JuliaLang/julia/pulls)を作成してください。

## Sessions and the REPL

### How do I delete an object in memory?

Juliaには、MATLABの`clear`関数に相当するものはありません。Juliaのセッション（厳密にはモジュール`Main`）で一度名前を定義すると、その名前は常に存在します。

メモリ使用量が気になる場合は、メモリ消費量の少ないオブジェクトに置き換えることができます。たとえば、もう必要のないギガバイトサイズの配列が`A`なら、`A = nothing`でメモリを解放できます。メモリは次にガベージコレクターが実行されたときに解放されます。[`GC.gc()`](@ref Base.GC.gc)を使えば、ガベージコレクターを強制的に実行できます。また、`A`を使おうとすると、エラーになる可能性が高いでしょう。ほとんどのメソッドは型`Nothing`に対して定義されていないためです。

## [Scripting](@id man-scripting)

### How do I check if the current file is being run as the main script?

ファイルを`julia file.jl`でメインスクリプトとして実行する場合、コマンドライン引数の処理などの追加機能を有効にしたいことがあります。ファイルがこの方法で実行されているかどうかは、`abspath(PROGRAM_FILE) == @__FILE__`が`true`かどうかで判定できます。

ただし、スクリプトとインポート可能なライブラリを兼ねるファイルは作らないことを推奨します。ライブラリとスクリプトの両方で同じ機能が必要なら、まずライブラリとして実装し、その機能を別のスクリプトからインポートするのがよいでしょう。

### [How do I catch CTRL-C in a script?](@id catch-ctrl-c)

`julia file.jl`でJuliaスクリプトを実行した場合、CTRL-C（SIGINT）で終了しようとしても[`InterruptException`](@ref)はスローされません。CTRL-Cによる場合も含め、Juliaスクリプトの終了前に特定のコードを実行するには、[`atexit`](@ref)を使います。または、`julia -e 'include(popfirst!(ARGS))' file.jl`でスクリプトを実行すれば、[`try`](@ref)ブロック内で`InterruptException`を捕捉できます。ただし、この方法では[`PROGRAM_FILE`](@ref)は設定されないことに注意してください。

### How do I pass options to `julia` using `#!/usr/bin/env`?

`julia`に渡すオプションを、`#!/usr/bin/env julia --startup-file=no`のようなシバン行に記述しても、多くのプラットフォーム（BSD、macOS、Linux）では動作しません。シェルとは異なり、カーネルは空白文字で引数を分割しないためです。シェルのように、空白を含む単一の引数文字列を複数の引数に分割する`env -S`オプションを使うと、簡単に回避できます。

```julia
#!/usr/bin/env -S julia --color=yes --startup-file=no
@show ARGS  # put any Julia code here
```

!!! note
    `env -S`オプションは、FreeBSD 6.0（2005年）、macOS Sierra（2016年）、GNU/Linux coreutils 8.30（2018年）で導入されました。


### Why doesn't `run` support `*` or pipes for scripting external programs?

Juliaの[`run`](@ref)関数は、外部プログラムを[operating-system shell](https://en.wikipedia.org/wiki/Shell_(computing))を介さずに*直接*起動します（Python、R、Cなどの言語にある`system("...")`関数とは異なります）。そのため、`run`は`*`（["globbing"](https://en.wikipedia.org/wiki/Glob_(programming))）のワイルドカード展開を行わず、[shell pipelines](https://en.wikipedia.org/wiki/Pipeline_(Unix))を`|`や`>`のように解釈することもありません。

ただし、Juliaの機能を使ってグロブやパイプラインを利用することはできます。たとえば、組み込みの[`pipeline`](@ref)関数を使うと、シェルのパイプのように外部プログラムやファイルを連結できます。また、[Glob.jl package](https://github.com/vtjnash/Glob.jl)はPOSIX互換のグロブ処理を実装しています。

もちろん、シェルとコマンド文字列を明示的に`run`に渡せば、シェル経由でプログラムを実行できます。たとえば、Unixの[Bourne shell](https://en.wikipedia.org/wiki/Bourne_shell)を使うには```run(`sh -c "ls > files.txt"`)```とします。ただし、一般には```run(pipeline(`ls`, "files.txt"))```のようなJuliaだけで完結するスクリプトを優先してください。デフォルトでシェルを使わないのは、[shelling out sucks](https://julialang.org/blog/2012/03/shelling-out-sucks/)ためです。シェル経由のプロセス起動は遅く、特殊文字の引用符処理に弱く、エラー処理も不十分で、移植性にも問題があります。（Pythonの開発者も[similar conclusion](https://www.python.org/dev/peps/pep-0324/#motivation)に至りました。）

## Variables and Assignments

### Why am I getting `UndefVarError` from a simple loop?

次のようなコードを書いたとします。

```
x = 0
while x < 10
    x += 1
end
```

Julia REPLのような対話環境では問題なく動くのに、スクリプトやほかのファイルで実行すると```UndefVarError: `x` not defined```が発生することがあります。これは、Juliaではローカルスコープ内でグローバル変数に代入する際、原則として明示的な指定が必要だからです。

ここでは、`x`はグローバル変数で、`while`は[local scope](@ref scope-of-variables)を定義し、`x += 1`はそのローカルスコープ内でグローバル変数に代入しています。

前述のとおり、Julia 1.5以降では、REPL（および多くの対話環境）で実行するコードについては、探索を簡単にするために`global`キーワードを省略できます（たとえば、関数内のコードをコピーして対話的に実行する場合など）。しかし、ファイル内のコードでは、グローバル変数をより慎重に扱う必要があります。選択肢は少なくとも3つあります。

1. コードを関数に入れます（そうすれば、`x`は関数内の*ローカル*変数になります）。一般に、グローバルスクリプトより関数を使うほうが、ソフトウェア工学上望ましい方法です（「why global variables bad」などで検索すると、多くの説明が見つかります）。Juliaでは、グローバル変数は[slow](@ref man-performance-tips)でもあります。
2. コードを[`let`](@ref)ブロックで囲みます。（これにより、`x`は`let ... end`文の中のローカル変数となり、やはり`global`は不要になります。）
3. ローカルスコープ内で代入する前に、`x`を`global`として明示します。たとえば、`global x += 1`と書きます。

詳しくは、マニュアルの[on soft scope](@ref on-soft-scope)を参照してください。

## Functions

### I passed an argument `x` to a function, modified it inside that function, but on the outside, the variable `x` is still unchanged. Why?

次のような関数呼び出しを考えてみましょう。

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

Juliaでは、変数`x`を関数の引数として`x`に渡しても、その変数の束縛は変更されません。上の例で`change_value!(x)`を呼び出すと、新しい変数`y`が作られ、最初は`x`の値、つまり`10`に束縛されます。その後、`y`は定数`17`に再束縛されますが、外側のスコープにある変数`x`はそのままです。

一方、`x`が`Array`型（またはほかの*可変*型）のオブジェクトに束縛されている場合は異なります。関数内から`x`の束縛先をこの配列から「解除」することはできませんが、配列の内容は変更できます。たとえば、次のとおりです。

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

ここでは、渡された配列の最初の要素に`5`を代入する関数`change_array!`を作成しました。呼び出し元では配列は`x`に束縛され、関数内では`A`に束縛されています。関数呼び出し後も`x`は同じ配列に束縛されたままですが、配列の内容は変わっています。変数`A`と`x`は別々の束縛ですが、同じ可変の`Array`オブジェクトを参照していたのです。

### Can I use `using` or `import` inside a function?

いいえ。関数内に`using`文や`import`文を書くことはできません。モジュールをインポートし、その束縛を特定の関数または関数群の中だけで使いたい場合は、次の2つの方法があります。

1. `import`を使います。

   ```julia
   import Foo
   function bar(...)
       # ... refer to Foo bindings via Foo.baz ...
   end
   ```

   これによりモジュール`Foo`が読み込まれ、そのモジュールを参照する変数`Foo`が定義されます。ただし、モジュール内のほかの束縛は現在の名前空間にインポートされません。`Foo`の束縛は、`Foo.bar`などの修飾名で参照します。
2. 関数をモジュールで囲みます。

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

   これにより、`Foo`のすべての束縛がインポートされますが、その範囲はモジュール`Bar`の中だけです。

### What does the `...` operator do?

#### The two uses of the `...` operator: slurping and splatting

Juliaを使い始めたばかりの人は、`...`演算子に戸惑うことがよくあります。`...`演算子が分かりにくい理由の一つは、文脈によって意味が2通りあることです。

#### `...` combines many arguments into one argument in function definitions

関数定義では、`...`演算子を使って、複数の引数を一つの引数にまとめます。`...`を使って複数の引数を一つにまとめるこの用法は、slurpingと呼ばれます。

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

JuliaがASCII文字をもっと自由に使う言語だったなら、slurping演算子は`...`ではなく、`<-...`と書かれていたかもしれません。

#### `...` splits one argument into many different arguments in function calls

関数定義で`...`演算子を使い、複数の引数を一つにまとめるのとは逆に、関数呼び出しでは`...`演算子を使って、一つの関数引数を複数の引数に分解できます。この`...`の用法は、splattingと呼ばれます。

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

JuliaがASCII文字をもっと自由に使う言語だったなら、splatting演算子は`...`ではなく、`...->`と書かれていたかもしれません。

### What is the return value of an assignment?

`=`演算子は常に右辺を返します。したがって、次のようになります。

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

同様に、次のようになります。

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

### Is a function that ends with `!` allowed to allocate?

はい。名前の末尾が`!`の関数は、少なくとも一つの引数（通常は最初の引数）を変更することを示します。ただし、計算を高速化するための作業領域を確保したり、結果を生成したりするために、メモリを割り当てることはあります。

## Types, type declarations, and constructors

### [What does "type-stable" mean?](@id man-type-stability)

出力の型が入力の型から予測できる、という意味です。特に、入力の*値*によって出力の型が変わることはありません。次のコードは型安定ではありません。

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

引数の値に応じて、`Int`または[`Float64`](@ref)を返します。Juliaはコンパイル時にこの関数の戻り値の型を予測できないため、この関数を使う計算では両方の型の値を扱えるようにする必要があり、高速な機械語コードを生成しにくくなります。

### [Why does Julia give a `DomainError` for certain seemingly-sensible operations?](@id faq-domain-errors)

数学的には意味が通るものの、エラーになる演算があります。

```jldoctest
julia> sqrt(-2.0)
ERROR: DomainError with -2.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]
```

これは、型安定性が求められることから生じる不便な結果です。[`sqrt`](@ref)の場合、ほとんどのユーザーは`sqrt(2.0)`が実数を返すことを期待しており、複素数`1.4142135623730951 + 0.0im`が返されると困るでしょう。負の数を渡したときだけ複素数を返すように[`sqrt`](@ref)関数を書くこともできます（ほかの言語では[`sqrt`](@ref)がそのように動作する場合があります）。しかし、その場合は結果が[type-stable](@ref man-type-stability)ではなくなり、[`sqrt`](@ref)関数の性能も低下します。

こうした場合には、結果を表現できる*出力型*を受け入れることを示す*入力型*を選べば、望む結果を得られます。

```jldoctest
julia> sqrt(-2.0+0im)
0.0 + 1.4142135623730951im
```

### How can I constrain or compute type parameters?

[parametric type](@ref Parametric-Types)のパラメーターには、型またはビット値を指定できます。型自体が、それらのパラメーターをどう使うかを決めます。たとえば、`Array{Float64, 2}`は、要素型を表す型`Float64`と、次元数を表す整数値`2`をパラメーターに取ります。独自のパラメトリック型を定義する際は、サブタイプ制約を使って、あるパラメーターが抽象型または前の型パラメーターのサブタイプ（[`<:`](@ref)）であることを宣言できます。しかし、パラメーターが特定の型の*値*でなければならないことを宣言する専用の構文はありません。たとえば、`struct`の定義内で、次元数のようなパラメーター[`isa`](@ref) `Int`を直接宣言することはできません。同様に、型パラメーターに対して、加算や減算のような単純な演算を含む計算を行うこともできません。こうした制約や関係は、型の[constructors](@ref man-constructors)内で計算・検証する追加の型パラメーターを使って表現できます。

例として、次の型を考えてみましょう。

```julia
struct ConstrainedType{T,N,N+1} # NOTE: INVALID SYNTAX
    A::Array{T,N}
    B::Array{T,N+1}
end
```

ここでは、3番目の型パラメーターが常に2番目の型パラメーターに1を足した値になるようにしたいとします。明示的な型パラメーターを追加し、[inner constructor method](@ref man-inner-constructor-methods)で検査すれば実現できます（ほかの検査と組み合わせることもできます）。

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

コンパイラは有効な具象型に対する検査を省略できるため、通常、この検査に*コストはかかりません*。2番目の引数も計算される場合は、その計算を行う[outer constructor method](@ref man-outer-constructor-methods)を用意するとよいでしょう。

```julia
ConstrainedType(A) = ConstrainedType(A, compute_B(A))
```

### [Why does Julia use native machine integer arithmetic?](@id faq-integer-arithmetic)

Juliaでは整数演算に機械語の算術演算を使います。そのため、`Int`の値域には上限と下限があり、端に達すると値が折り返します。整数の加算、減算、乗算ではオーバーフローやアンダーフローが起こり、最初は戸惑うような結果になることがあります。

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

これは明らかに数学上の整数の振る舞いとは異なり、高水準言語がこの性質をユーザーに見せるのは理想的ではないと思うかもしれません。しかし、効率と透明性が重視される数値計算では、ほかの選択肢のほうが問題があります。

考えられる選択肢の一つは、整数演算のたびにオーバーフローを検査し、オーバーフローした場合は[`Int128`](@ref)や[`BigInt`](@ref)のような、より大きな整数型に昇格させることです。しかし、これではすべての整数演算（ループカウンターのインクリメントなど）に大きなオーバーヘッドが生じます。算術命令の後に実行時のオーバーフロー検査を行うコードを生成し、オーバーフローの可能性に対処する分岐も必要になるためです。さらに悪いことに、整数を含むすべての計算が型不安定になります。前述のとおり、効率的なコードを生成するには[type-stability is crucial](@ref man-type-stability)が重要です。整数演算の結果が整数であると保証できなければ、CやFortranのコンパイラのように、高速で単純なコードを生成することはできません。

型不安定性が表面化しないようにする別の方法として、`Int`型と[`BigInt`](@ref)型を一つのハイブリッド整数型に統合し、結果が機械語整数の範囲に収まらなくなったときに内部表現を切り替える方法があります。Juliaコードのレベルでは型不安定性を避けられるように見えますが、実際には同じ問題を、このハイブリッド整数型を実装するCコードに押しつけているだけです。この方法は実用化でき、多くの場合かなり高速にもできますが、いくつか欠点があります。まず、整数や整数配列のメモリ表現が、C、Fortranなど、ネイティブの機械語整数を使う言語の自然な表現と一致しなくなります。そのため、そうした言語と相互運用するには、結局ネイティブ整数型も導入する必要があります。また、ビット数に上限のない整数は固定ビット数では表せないため、固定サイズの領域を持つ配列にインラインで格納できません。大きな整数値は常にヒープ上に別途確保する必要があります。さらに、どれほど巧妙なハイブリッド整数の実装でも、性能が予想外に低下する状況は避けられません。複雑な表現、CやFortranとの相互運用性の欠如、追加のヒープ領域なしでは整数配列を表現できないこと、そして予測しにくい性能特性を考えると、どれほど巧妙な実装であっても、高性能な数値計算には適しません。

ハイブリッド整数やBigIntへの昇格に代わる方法として、飽和整数演算があります。最大の整数値に加算しても値は変わらず、最小の整数値から減算しても値は変わりません。これはMatlab™の動作そのものです。

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

一見すると、これは十分妥当に思えます。9223372036854775807は-9223372036854775808よりも9223372036854775808に近く、整数はCやFortranと互換性のある自然な固定サイズ表現のままだからです。しかし、飽和整数演算には深刻な問題があります。まず、機械語の整数演算はこのようには動作しません。そのため、飽和演算を実装するには、機械語整数演算のたびにアンダーフローやオーバーフローを検査し、必要に応じて結果を[`typemin(Int)`](@ref)または[`typemax(Int)`](@ref)に置き換える命令を追加しなければなりません。つまり、整数演算は高速な単一命令ではなく、複数の命令になります。さらに問題なのは、飽和整数演算には結合則が成り立たないことです。次のMatlabの計算を考えてみましょう。

```
>> n = int64(2)^62
4611686018427387904

>> n + (n - 1)
9223372036854775807

>> (n + n) - 1
9223372036854775806
```

このため、基本的な整数アルゴリズムの多くが書きにくくなります。よく使われる手法の多くは、オーバーフローを伴う機械語の加算に結合則が成り立つことを前提としているからです。Juliaで、整数値`lo`と`hi`の中点を、式`(lo + hi) >>> 1`で求める場合を考えてみましょう。

```jldoctest
julia> n = 2^62
4611686018427387904

julia> (n + 2n) >>> 1
6917529027641081856
```

ご覧のとおり、問題ありません。`n + 2n`が-4611686018427387904であっても、2^62と2^63の正しい中点が得られます。では、Matlabで試してみましょう。

```
>> (n + 2*n)/2

ans =

  4611686018427387904
```

困ったことになります。Matlabに`>>>`演算子を追加しても解決しません。`n`と`2n`を加算した時点で飽和が起き、正しい中点の計算に必要な情報がすでに失われているからです。

結合則が成り立たないと、こうした手法を使えないプログラマーが困るだけではありません。コンパイラが整数演算を最適化する際にも、ほとんど何もできなくなります。たとえば、Juliaの整数は通常の機械語整数演算を使うため、LLVMは`f(k) = 5k-1`のような単純な関数を積極的に最適化できます。この関数の機械語コードは次のとおりです。

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

関数本体は、整数の乗算と加算を一度に行う単一の`leaq`命令です。`f`が別の関数にインライン展開されると、さらに効果があります。

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

`f`の呼び出しがインライン展開されるため、ループ本体は最終的に単一の`leaq`命令になります。次に、ループの反復回数を固定した場合を考えてみましょう。

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

コンパイラは、整数の加算と乗算に結合則が成り立ち、乗算が加算に対して分配されることを知っています。飽和演算ではどちらも成り立ちませんが、通常の整数演算ならループ全体を乗算と加算だけに最適化できます。飽和演算では、各反復で結合則や分配法則が成り立たなくなる可能性があり、どの反復で破綻するかによって結果が変わるため、この種の最適化は完全に妨げられます。コンパイラはループを展開できますが、複数の演算を、より少ない同等の演算に代数的にまとめることはできません。

整数演算の暗黙のオーバーフローに代わる最も妥当な方法は、加算、減算、乗算のオーバーフロー時にエラーを発生させる、常に検査付きの演算を使うことです。これにより、値として正しくない結果が生成されるのを防げます。[blog post](https://danluu.com/integer-overflow/)でDan Luuがこの方法を分析しています。理論上はわずかなコストで済むはずですが、コンパイラ（LLVMやGCC）が追加されたオーバーフロー検査をうまく最適化できず、実際には大きなコストがかかることが分かっています。将来この問題が改善されれば、Juliaで検査付き整数演算をデフォルトにすることを検討できますが、現時点ではオーバーフローの可能性を受け入れる必要があります。

当面は、[SaferIntegers.jl](https://github.com/JeffreySarnoff/SaferIntegers.jl)などの外部ライブラリを使うことで、オーバーフロー安全な整数演算を実現できます。前述のとおり、検査付き整数型を使うコードの実行時間は大幅に増加します。ただし、限定的な用途で使うのであれば、すべての整数演算に適用する場合ほど大きな問題にはなりません。議論の進捗は[here](https://github.com/JuliaLang/julia/issues/855)で確認できます。

### What are the possible causes of an `UndefVarError` during remote execution?

エラーメッセージにあるとおり、リモートノードで`UndefVarError`が発生する直接の原因は、その名前の束縛が存在しないことです。考えられる原因をいくつか見てみましょう。

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

クロージャ`x->x`は`Foo`への参照を保持しています。`Foo`はノード2で利用できないため、`UndefVarError`がスローされます。

`Main`以外のモジュールに属するグローバル変数は、値としてリモートノードにシリアライズされません。送信されるのは参照だけです。グローバル束縛を作成する関数（`Main`内で作成する場合を除く）は、後で`UndefVarError`を発生させることがあります。

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

上の例では、`@everywhere module Foo`がすべてのノードで`Foo`を定義しています。しかし、`Foo.foo()`の呼び出しによってローカルノードに新しいグローバル束縛`gvar`が作られました。この束縛はノード2には存在しないため、`UndefVarError`エラーが発生します。

ただし、これはモジュール`Main`内で作成されたグローバル変数には当てはまりません。モジュール`Main`内のグローバル変数はシリアライズされ、リモートノードの`Main`内に新しい束縛が作られます。

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

これは`function`や`struct`の宣言には当てはまりません。ただし、グローバル変数に束縛された無名関数はシリアライズされます。次の例で確認できます。

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

実際に試すと分かるように、結果は`MethodError`になります。

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

これは、`Vector{Real}`が`Vector{Int}`のスーパータイプではないためです。`foo(bar::Vector{T}) where {T<:Real}`のようにすれば解決できます（関数本体で静的パラメーター`T`を使わない場合は、短縮形の`foo(bar::Vector{<:Real})`も使えます）。`T`はワイルドカードです。まずRealのサブタイプであることを指定し、次に関数がその型の要素を持つVectorを受け取ることを指定します。

同じ問題は`Vector`だけでなく、あらゆる複合型`Comp`に当てはまります。`Comp`のパラメーターが`Y`型として宣言されている場合、パラメーターが`X<:Y`型である別の型`Comp2`は、`Comp`のサブタイプではありません。これは型不変性です（対照的に、Tupleの型パラメーターは共変です）。詳しくは[Parametric Composite Types](@ref man-parametric-composite-types)を参照してください。

### Why does Julia use `*` for string concatenation? Why not `+` or something else?

[main argument](@ref man-concatenation)が`+`に反対する理由は、文字列の連結には交換法則が成り立たない一方、`+`は一般に交換法則が成り立つ演算子として使われるためです。Juliaコミュニティは、ほかの言語では別の演算子が使われていることや、`*`に馴染みのないユーザーがいることを理解していますが、この演算子は特定の代数的性質を伝えています。

文字列（および文字列に変換されるほかの値）の連結には`string(...)`も使えます。同様に、文字列の繰り返しには`^`の代わりに`repeat`を使えます。文字列の構築には[interpolation syntax](@ref string-interpolation)も便利です。

## Packages and Modules

### What is the difference between "using" and "import"?

`using`と`import`にはいくつか違いがあります（[Modules section](https://docs.julialang.org/en/v1/manual/modules/#modules)を参照）。その中には、最初は直感に反するように思え、表面的には（つまり構文上は）ごく小さな違いに見えるものがあります。`using`でモジュールを読み込む場合、モジュール`Foo`の関数`bar`に新しいメソッドを追加するには、`function Foo.bar(...`と書く必要があります。一方、`import Foo.bar`では、`function bar(...`と書くだけで、モジュール`Foo`の関数`bar`が自動的に拡張されます。

これを別の構文にするほど重要なのは、存在を知らなかった関数を誤って拡張しないようにするためです。そうした誤りは、バグにつながりやすいからです。特に、文字列や整数のような一般的な型を受け取るメソッドで起こりやすくなります。自分と別のモジュールが、どちらもそのような一般的な型を処理するメソッドを定義する可能性があるためです。`import`を使うと、別のモジュールが定義した`bar(s::AbstractString)`の実装を自分の実装で置き換えてしまいます。新しい実装がまったく異なる動作をすれば、barの呼び出しに依存するFooモジュール内の関数が、今後すべて、あるいは多くの場面で壊れる可能性があります。

## Nothingness and missing values

### [How does "null", "nothingness" or "missingness" work in Julia?](@id faq-nothing)

CやJavaなど多くの言語とは異なり、Juliaのオブジェクトはデフォルトで「null」にはなりません。参照（変数、オブジェクトのフィールド、配列要素）が初期化されていない場合、それにアクセスすると直ちにエラーが発生します。この状態は[`isdefined`](@ref)関数または[`isassigned`](@ref Base.isassigned)関数で検出できます。

副作用だけを目的として使われ、戻り値を必要としない関数もあります。そのような場合は、値`nothing`を返すのが慣例です。これは型`Nothing`の単一のオブジェクトです。フィールドを持たない通常の型であり、この慣例と、REPLが何も表示しないことを除けば、特別な点はありません。また、ほかの方法では値を持たない言語構文の中にも、`nothing`を返すものがあります。たとえば`if false; end`です。

型`T`の値`x`が存在する場合としない場合があるときは、関数の引数、オブジェクトのフィールド、配列の要素型に`Union{T, Nothing}`型を使えます。これは、ほかの言語における[`Nullable`, `Option` or `Maybe`](https://en.wikipedia.org/wiki/Nullable_type)に相当します。値そのものが`nothing`になり得る場合（特に`T`が`Any`の場合）は、`Union{Some{T}, Nothing}`型のほうが適切です。この場合、`x == nothing`は値が存在しないことを示し、`x == Some(nothing)`は`nothing`と等しい値が存在することを示します。[`something`](@ref)関数を使うと、`Some`オブジェクトをアンラップし、`nothing`の代わりにデフォルト値を使えます。`Union{T, Nothing}`型の引数やフィールドを扱う場合、コンパイラは効率的なコードを生成できます。

統計上の欠損データ（Rの`NA`やSQLの`NULL`）を表すには、[`missing`](@ref)オブジェクトを使います。詳しくは[`Missing Values`](@ref missing)の節を参照してください。

言語によっては、空のタプル（`()`）を「何もない」ことの標準的な表現とみなします。しかしJuliaでは、値を一つも含まないだけの通常のタプルと考えるのが適切です。

空（または「ボトム」）型は`Union{}`（空のユニオン型）と書き、値もサブタイプも持ちません（自身を除く）。通常、この型を使う必要はありません。

## Memory

### Why does `x += y` allocate memory when `x` and `y` are arrays?

Juliaでは、loweringの段階で`x += y`が`x = x + y`に置き換えられます。配列の場合、結果は`x`と同じメモリ位置に格納されず、結果を格納する新しい配列が割り当てられます。`x`を変更したい場合は、`x .+= y`を使って各要素を個別に更新してください。

この動作に驚く人もいるかもしれませんが、意図的な設計です。主な理由は、Juliaには不変オブジェクトがあり、一度作成すると値を変更できないことです。実際、数値も不変オブジェクトです。`x = 5; x += 1`という文は`5`の意味を変えるのではなく、`x`に束縛される値を変更します。不変オブジェクトの値を変える唯一の方法は、再代入することです。

もう少し詳しく説明するために、次の関数を考えてみましょう。

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

`x = 5; y = power_by_squaring(x, 4)`のように呼び出せば、期待どおりの結果`x == 5 && y == 625`が得られます。しかし、行列に対して使ったときに`*=`が左辺を変更するとしたら、2つの問題が生じます。

  * 一般の正方行列では、一時領域なしに`A = A*B`を実装できません。右辺で使い終わる前に、`A[1,1]`が計算され、左辺に格納されてしまうためです。
  * 計算用の一時領域を確保することを許容したとしても（そうすると、`*=`をインプレースで動作させる利点の大半が失われます）、`x`の可変性を利用すると、この関数は可変入力と不変入力で異なる動作をすることになります。特に、不変の`x`では、呼び出し後に一般に`y != x`となりますが、可変の`x`では`y == x`となります。

ブロードキャストや明示的なループなど、別の方法で実現できる性能最適化よりも、ジェネリックプログラミングへの対応を重視しているため、`+=`や`*=`のような演算子は、新しい値への再束縛によって動作します。

## [Asynchronous IO and concurrent synchronous writes](@id faq-async-io)

### Why do concurrent writes to the same stream result in inter-mixed output?

ストリーミングI/O APIは同期的ですが、その基盤となる実装は完全に非同期です。

次のコードの出力を考えてみましょう。

```
julia> @sync for i in 1:3
           Threads.@spawn write(stdout, string(i), " Foo ", " Bar ")
       end
123 Foo  Foo  Foo  Bar  Bar  Bar
```

`write`の呼び出し自体は同期的ですが、各引数を書き込む際に、そのI/Oが完了するのを待つ間、ほかのタスクに実行を譲るため、このようなことが起こります。

`print`と`println`は、呼び出し中にストリームを「ロック」します。そのため、上の例で`write`を`println`に変更すると、次のようになります。

```
julia> @sync for i in 1:3
           Threads.@spawn println(stdout, string(i), " Foo ", " Bar ")
       end
1 Foo  Bar
2 Foo  Bar
3 Foo  Bar
```

次のように`ReentrantLock`を使えば、書き込みをロックできます。

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

0次元配列とは、`Array{T,0}`の形をした配列です。スカラーに似た動作をしますが、重要な違いもあります。配列の一般的な定義から考えると論理的に自然な特殊ケースですが、最初は少し直感に反するかもしれないため、ここで説明します。次の行は0次元配列を定義します。

```
julia> A = zeros()
0-dimensional Array{Float64,0}:
0.0
```

この例では、`A`は要素を一つ含む可変コンテナーです。要素は`A[] = 1.0`で設定し、`A[]`で取得できます。すべての0次元配列は同じサイズ（`size(A) == ()`）と長さ（`length(A) == 1`）を持ちます。つまり、0次元配列は空ではありません。これが直感に反する場合は、Juliaの定義を理解するために次の点を参考にしてください。

  * 0次元配列は、ベクトルに対する「直線」、行列に対する「平面」に相当する「点」です。直線には面積がありませんが（それでも複数のものを表します）、点には長さも次元もありません（それでも一つのものを表します）。
  * `prod(())`を1と定義し、配列の要素数をサイズの積とします。0次元配列のサイズは`()`なので、長さは`1`です。
  * 0次元配列には、インデックスを指定するための次元がありません。単に`A[]`です。ほかの次元数の配列と同じ「末尾の1」の規則を適用できるため、`A[1]`、`A[1,1]`などでインデックスを指定できます。詳しくは[Omitted and extra indices](@ref)を参照してください。

通常のスカラーとの違いも理解しておくことが重要です。スカラーは可変コンテナーではありません（反復可能で、`length`や`getindex`などを定義している場合でも同様です。たとえば`1[] == 1`）。特に、`x = 0.0`がスカラーとして定義されている場合、`x[] = 1.0`で値を変更しようとするとエラーになります。スカラー`x`は`fill(x)`で、それを含む0次元配列に変換できます。逆に、0次元配列`a`は`a[]`で、格納されているスカラーに変換できます。また、スカラーは`2 * rand(2,2)`のような線形代数演算に参加できますが、0次元配列`fill(2) * rand(2,2)`に対する同様の演算はエラーになります。

### Why are my Julia benchmarks for linear algebra operations different from other languages?

次のような線形代数の基本演算を簡単にベンチマークすると、

```julia
using BenchmarkTools
A = randn(1000, 1000)
B = randn(1000, 1000)
@btime $A \ $B
@btime $A * $B
```

MatlabやRなど、ほかの言語と結果が異なることがあります。

このような演算は、対応するBLAS関数を薄くラップしたものにすぎないため、差が生じる原因はおそらく次のいずれかです。

1. 各言語が使用しているBLASライブラリ
2. 同時に実行されるスレッド数

Juliaは独自にビルドしたOpenBLASをコンパイルして使用しており、スレッド数は現在`8`（またはコア数）に制限されています。

OpenBLASの設定を変更したり、別のBLASライブラリ（たとえば[Intel MKL](https://software.intel.com/en-us/mkl)）を使ってJuliaをコンパイルしたりすると、性能が向上する場合があります。[MKL.jl](https://github.com/JuliaComputing/MKL.jl)を使うと、Juliaの線形代数でOpenBLASの代わりにIntel MKL BLASとLAPACKを利用できます。また、手動で設定する方法について、ディスカッションフォーラムで情報を探すこともできます。Intel MKLはオープンソースではないため、Juliaに同梱できないことに注意してください。

## Computing cluster

### How do I manage precompilation caches in distributed file systems?

共有ファイルシステムを使う高性能計算（HPC）環境でJuliaを使う場合は、共有デポ（環境変数[`JULIA_DEPOT_PATH`](@ref JULIA_DEPOT_PATH)を介して指定）を使うことを推奨します。Julia v1.10以降では、機能的に同等なワーカー上で同じデポを使う複数のJuliaプロセスが、pidfileロックを使って連携します。一つのプロセスだけがプリコンパイルを行い、ほかのプロセスは待機するため、重複した作業を避けられます。プリコンパイル中のプロセスや、別のプロセスのプリコンパイルを待っているプロセスは、その状態を表示します。非対話モードでは、メッセージは`@debug`経由で出力されます。

ただし、バイナリコードのキャッシュに関しては、v1.9以降、キャッシュを拒否する条件がより厳しくなっています。そのため、HPC環境全体で利用できる単一のキャッシュを使うには、環境変数[`JULIA_CPU_TARGET`](@ref JULIA_CPU_TARGET)を適切に設定する必要がある場合があります。

## Julia Releases

### Do I want to use the Stable, LTS, or nightly version of Julia?

Juliaの安定版は、リリース済みの最新バージョンです。ほとんどの人にはこのバージョンが適しています。性能向上を含む最新機能を利用できます。安定版のバージョン番号は、[SemVer](https://semver.org/)に従ってv1.x.yの形式で付けられます。新しい安定版に相当するJuliaのマイナーリリースは、数週間のリリース候補版テストを経て、およそ4〜5か月ごとに公開されます。LTS版とは異なり、通常、次の安定版が公開された後に安定版のバグ修正が提供されることはありません。ただし、Julia v1.xの各リリースは以前のバージョン向けに書かれたコードを引き続き実行できるため、次の安定版へはいつでもアップグレードできます。

非常に安定したコードベースを求める場合は、LTS（長期サポート）版が適しているかもしれません。現在のLTS版は、SemVerに従ってv1.6.xと付番されています。このブランチは、新しいLTSブランチが選ばれるまでバグ修正を受け続けます。新しいLTSブランチが選ばれると、v1.6.x系列への定期的なバグ修正は終了し、最も慎重なユーザーを除いて、新しいLTS系列へのアップグレードが推奨されます。パッケージ開発者は、より多くのユーザーがパッケージを使えるよう、LTS版を対象に開発することを選べます。SemVerに従い、v1.0向けに書かれたコードは、今後のすべてのLTS版および安定版で引き続き動作します。一般に、LTS版を対象にする場合でも、性能向上を活用するため、最新の安定版で開発・実行できます。ただし、追加されたライブラリ関数や新しいメソッドなど、新機能の使用は避けてください。

言語の最新の更新を利用したい場合や、今日利用できるバージョンがときどき動かなくても構わない場合は、ナイトリー版が適しています。名前のとおり、ビルド環境の安定性にもよりますが、ナイトリー版はおおむね毎晩リリースされます。一般に、ナイトリー版は比較的安全に使えます。コードが突然使えなくなるわけではありません。ただし、リリース前のより徹底したテストで初めて見つかるような、まれなリグレッションや問題が含まれることがあります。自分の用途に影響するリグレッションをリリース前に検出できるよう、ナイトリー版でテストすることを検討してもよいでしょう。

最後に、自分でソースからJuliaをビルドする方法もあります。この方法は主に、コマンドラインの操作に慣れている人や、学んでみたい人向けです。該当する場合は、[guidelines for contributing](https://github.com/JuliaLang/julia/blob/master/CONTRIBUTING.md)も参考になるでしょう。

[`juliaup` install manager](https://julialang.org/install/)には、最新の安定版リリースと現在のLTSリリースに対応する`release`および`lts`という定義済みのチャンネルがあり、バージョンごとのチャンネルも用意されています。

### How can I transfer the list of installed packages after updating my version of Julia?

Juliaの各マイナーバージョンには、それぞれ既定の[environment](https://docs.julialang.org/en/v1/manual/code-loading/#Environments-1)があります。そのため、新しいマイナーバージョンをインストールすると、以前のマイナーバージョンで追加したパッケージは、既定では利用できません。Juliaの各バージョンの環境は、`.julia/environments/`内のバージョン番号に対応するフォルダーにある`Project.toml`と`Manifest.toml`で定義されます。たとえば、`.julia/environments/v1.3`です。

たとえば`1.4`のような新しいマイナーバージョンのJuliaをインストールし、その既定の環境で以前のバージョン（たとえば`1.3`）と同じパッケージを使いたい場合は、`1.3`フォルダーにある`Project.toml`の内容を`1.4`にコピーします。その後、新しいJuliaバージョンのセッションで`]`キーを押して「パッケージ管理モード」に入り、[`instantiate`](https://julialang.github.io/Pkg.jl/v1/api/#Pkg.instantiate)コマンドを実行します。

この操作では、コピーしたファイルから、対象のJuliaバージョンと互換性のあるパッケージの組み合わせが解決され、適切なパッケージがインストールまたは更新されます。パッケージの集合だけでなく、以前のJuliaバージョンで使っていたバージョンも再現したい場合は、Pkgコマンド`instantiate`を実行する前に、`Manifest.toml`ファイルもコピーしてください。ただし、パッケージが定義する互換性制約はJuliaのバージョン変更の影響を受けることがあります。そのため、`1.3`で使っていたバージョンの組み合わせが、`1.4`で動作するとは限りません。
