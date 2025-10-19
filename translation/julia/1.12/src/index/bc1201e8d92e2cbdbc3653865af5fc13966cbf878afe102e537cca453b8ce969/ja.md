```@eval
io = IOBuffer()
release = isempty(VERSION.prerelease)
v = "$(VERSION.major).$(VERSION.minor)"
!release && (v = v*"-$(first(VERSION.prerelease))")
print(io, """
    # Julia $(v) Documentation

    Welcome to the documentation for Julia $(v).

    """)
if !release
    print(io,"""
        !!! warning "Work in progress!"
            This documentation is for an unreleased, in-development, version of Julia.
        """)
end
import Markdown
Markdown.parse(String(take!(io)))
```

[release notes](NEWS.md)を読んで、前回のリリース以降に何が変更されたかを確認してください。

```@eval
release = isempty(VERSION.prerelease)
file = release ? "julia-$(VERSION).pdf" :
       "julia-$(VERSION.major).$(VERSION.minor).$(VERSION.patch)-$(first(VERSION.prerelease)).pdf"
url = "https://raw.githubusercontent.com/JuliaLang/docs.julialang.org/assets/$(file)"
import Markdown
Markdown.parse("""
!!! note
    The documentation is also available in PDF format: [$file]($url).
""")
```

## [Important Links](@id man-important-links)

以下は、Juliaプログラミング言語を学び、使用する際に役立つリンクの非網羅的なリストです。

  * [Julia Homepage](https://julialang.org)
  * [Install Julia](https://julialang.org/install/)
  * [Discussion forum](https://discourse.julialang.org)
  * [Julia YouTube](https://www.youtube.com/user/JuliaLanguage)
  * [Find Julia Packages](https://julialang.org/packages/)
  * [Learning Resources](https://julialang.org/learning/)
  * [Read and write blogs on Julia](https://forem.julialang.org)

## [Introduction](@id man-introduction)

科学計算は伝統的に最高のパフォーマンスを要求してきましたが、ドメインの専門家は日常の作業のために主に遅い動的言語に移行しています。私たちは、これらのアプリケーションに動的言語を好む多くの良い理由があると考えており、その使用が減少することはないと予想しています。幸いなことに、現代の言語設計とコンパイラ技術により、パフォーマンスのトレードオフをほぼ排除し、プロトタイピングに十分生産的で、パフォーマンス集約型アプリケーションの展開に十分効率的な単一の環境を提供することが可能になりました。Juliaプログラミング言語はこの役割を果たします：それは科学計算および数値計算に適した柔軟な動的言語であり、従来の静的型付け言語と同等のパフォーマンスを持っています。

JuliaのコンパイラはPythonやRのような言語で使用されるインタプリタとは異なるため、最初はJuliaのパフォーマンスが直感的でないと感じるかもしれません。何かが遅いと感じた場合は、他のことを試す前に[Performance Tips](@ref man-performance-tips)セクションを読むことを強くお勧めします。Juliaの動作を理解すれば、Cとほぼ同じくらい速いコードを書くのは簡単です。

## [Julia Compared to Other Languages](@id man-julia-compared-other-languages)

Julia features optional typing, multiple dispatch, and good performance, achieved using type inference and [just-in-time (JIT) compilation](https://en.wikipedia.org/wiki/Just-in-time_compilation) (and [optional ahead-of-time compilation](https://github.com/JuliaLang/PackageCompiler.jl)), implemented using [LLVM](https://en.wikipedia.org/wiki/Low_Level_Virtual_Machine). It is multi-paradigm, combining features of imperative, functional, and object-oriented programming. Julia provides ease and expressiveness for high-level numerical computing, in the same way as languages such as R, MATLAB, and Python, but also supports general programming. To achieve this, Julia builds upon the lineage of mathematical programming languages, but also borrows much from popular dynamic languages, including [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)), [Perl](https://en.wikipedia.org/wiki/Perl_(programming_language)), [Python](https://en.wikipedia.org/wiki/Python_(programming_language)), [Lua](https://en.wikipedia.org/wiki/Lua_(programming_language)), and [Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language)).

Juliaの典型的な動的言語からの最も重要な逸脱は次のとおりです：

  * コア言語は非常に少ない制約を課します； [Julia Base and the standard library](@ref man-core-base-and-stdlib) は、整数演算のような基本的な操作を含む、Julia自体で書かれています。
  * オブジェクトを構築および記述するための豊富な型の言語であり、型宣言を行うためにオプションで使用することもできます。
  * 関数の動作を多くの引数タイプの組み合わせにわたって定義する能力 [multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch)
  * 異なる引数タイプに対する効率的で専門的なコードの自動生成
  * 良好なパフォーマンスで、Cのような静的コンパイル言語に近づいています。

動的言語を「型なし」と呼ぶこともありますが、実際にはそうではありません。すべてのオブジェクトは、プリミティブであれユーザー定義であれ、型を持っています。しかし、ほとんどの動的言語では型宣言がないため、コンパイラに値の型について指示することができず、しばしば型について明示的に話すこともできません。一方、静的言語では、コンパイラのために型を注釈することができ（通常はしなければなりません）、型はコンパイル時にのみ存在し、実行時に操作したり表現したりすることはできません。Juliaでは、型自体が実行時オブジェクトであり、コンパイラに情報を伝えるためにも使用できます。

### [What Makes Julia, Julia?](@id man-what-makes-julia)

カジュアルなプログラマーは明示的に型や多重ディスパッチを使用する必要はありませんが、これらはJuliaの中心的な統一機能です：関数は異なる引数の型の組み合わせに基づいて定義され、最も特定の一致する定義にディスパッチすることによって適用されます。このモデルは数学的プログラミングに適しており、従来のオブジェクト指向ディスパッチのように最初の引数が操作を「所有」するのは不自然です。演算子は特別な表記を持つ関数に過ぎません – 新しいユーザー定義データ型に加算を拡張するには、`+`関数の新しいメソッドを定義します。既存のコードは、新しいデータ型にシームレスに適用されます。

部分的には、実行時型推論（オプションの型注釈によって強化される）と、プロジェクトの開始時からのパフォーマンスへの強い焦点によって、Juliaの計算効率は他の動的言語を超え、静的コンパイル言語に匹敵します。大規模な数値問題において、速度は常に重要であり続け、今後もそうであり続けるでしょう：処理されるデータの量は、過去数十年にわたりムーアの法則に容易に追いついてきました。

### [Advantages of Julia](@id man-advantages-of-julia)

Juliaは、使いやすさ、パワー、効率の前例のない組み合わせを単一の言語で作成することを目指しています。上記に加えて、比較可能なシステムに対するJuliaのいくつかの利点には以下が含まれます：

  * フリーでオープンソース ([MIT licensed](https://github.com/JuliaLang/julia/blob/master/LICENSE.md))
  * ユーザー定義型は組み込み型と同じくらい速く、コンパクトです。
  * コードのパフォーマンスのためにベクトル化する必要はありません; デベクトル化されたコードは速いです
  * 並列処理と分散計算のために設計されています
  * 軽量の「グリーン」スレッド ([coroutines](https://en.wikipedia.org/wiki/Coroutine))
  * 目立たず強力な型システム
  * 数値およびその他の型に対するエレガントで拡張可能な変換と昇格
  * 効率的なサポート [Unicode](https://en.wikipedia.org/wiki/Unicode)、ただし [UTF-8](https://en.wikipedia.org/wiki/UTF-8) に限定されません。
  * C関数を直接呼び出す（ラッパーや特別なAPIは不要）
  * 他のプロセスを管理するための強力なシェルのような機能
  * Lispのようなマクロとその他のメタプログラミング機能

## [Julia Standard Modules and the Standard Library](@id man-standard-modules-stdlib)

Juliaランタイムには、[standard modules](@ref standard-modules)が含まれており、これは通常自動的にロードされる重要な名前空間です。

```@docs; canonical=false
Core
Base
```

ジュリアの `Base` モジュールには、さまざまな [useful submodules](@ref base-submodules) が含まれています。

### [The Standard Library](@id man-stdlib)

Juliaの標準ライブラリには、デフォルトでJuliaランタイムと一緒にインストールされる追加の一般的に使用されるパッケージが含まれています。標準ライブラリパッケージを使用するには、まず[`using`](@ref)または[`import`](@ref)ステートメントでパッケージをロードする必要があります。利用可能な標準ライブラリパッケージへのリンクは以下に提供されており、ウェブサイトのサイドバーにも見つけることができます。ソースコードは、Juliaインストールの`Sys.STDLIB`ディレクトリにあります。

```@eval
import Markdown
list = sort(filter(x -> match(r"_jll$", x) === nothing, readdir(Sys.STDLIB)))
Markdown.parse(join("- [`" .* list .* "`](stdlib/" .* list .* ".html)", "\n"))
```

Juliaは、他の言語で書かれた確立されたソフトウェアのさまざまな標準の事前ビルドバイナリライブラリも提供しています。慣例として、これらのパッケージは名前が`_jll`で終わります。[`using`](@ref)ステートメントは、これらのバイナリライブラリからシンボル名をロードできます：

```@eval
import Markdown
list = sort(filter(x -> match(r"_jll$", x) !== nothing, readdir(Sys.STDLIB)))
Markdown.parse(join("- [`" .* list .* "`](stdlib/" .* list .* ".html)", "\n"))
```
