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

前回のリリースからの変更点については、[release notes](NEWS.md)をご覧ください。

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

## [Introduction](@id man-introduction)

科学技術計算では従来、最高水準の性能が求められてきました。しかし、日常的な作業では、分野の専門家の多くが、より低速な動的言語へと移行しています。こうした用途で動的言語を選ぶことには多くの正当な理由があり、今後その利用が減るとは考えていません。幸い、現代の言語設計とコンパイラ技術により、性能とのトレードオフをほぼ解消し、プロトタイピングに十分な生産性と、性能が重視されるアプリケーションのデプロイに十分な効率性を兼ね備えた単一の環境を実現できます。Juliaプログラミング言語は、まさにこの役割を担います。柔軟な動的言語であり、科学技術計算や数値計算に適しているうえ、従来の静的型付け言語に匹敵する性能を備えています。

Juliaのコンパイラは、PythonやRなどの言語で使われるインタープリタとは異なるため、最初はJuliaの性能が直感に反するように感じられるかもしれません。何かが遅いと感じたら、ほかのことを試す前に、[Performance Tips](@ref man-performance-tips)のセクションを読むことを強くおすすめします。Juliaの仕組みを理解すれば、Cにほぼ匹敵する速度のコードを書くのは簡単です。

## [Julia Compared to Other Languages](@id man-julia-compared-other-languages)

Juliaは、型推論と[just-in-time (JIT) compilation](https://en.wikipedia.org/wiki/Just-in-time_compilation)（および[optional ahead-of-time compilation](https://github.com/JuliaLang/PackageCompiler.jl)）を活用し、[LLVM](https://en.wikipedia.org/wiki/Low_Level_Virtual_Machine)を用いて実装することで、オプションの型付け、多重ディスパッチ、高い性能を実現しています。命令型、関数型、オブジェクト指向の各プログラミングの特徴を組み合わせたマルチパラダイム言語です。R、MATLAB、Pythonなどの言語と同様に、高水準の数値計算を容易かつ表現力豊かに行える一方、汎用プログラミングにも対応しています。そのために、Juliaは数理プログラミング言語の系譜を受け継ぎながら、[Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language))、[Perl](https://en.wikipedia.org/wiki/Perl_(programming_language))、[Python](https://en.wikipedia.org/wiki/Python_(programming_language))、[Lua](https://en.wikipedia.org/wiki/Lua_(programming_language))、[Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language))など、広く使われている動的言語からも多くの要素を取り入れています。

Juliaが一般的な動的言語と大きく異なる点は、次のとおりです。

  * 中核となる言語機能はごくわずかに抑えられており、整数演算などの基本的な操作を含め、[Julia Base and the standard library](@ref standard-modules)はJulia自体で記述されています。
  * オブジェクトの構築や記述に使える豊富な型の言語を備えており、型宣言にも任意で利用できます。
  * [multiple dispatch](https://en.wikipedia.org/wiki/Multiple_dispatch)を使って、さまざまな引数型の組み合わせに対する関数の動作を定義できます。
  * 引数型ごとに効率的な特化コードを自動生成します。
  * Cなどの静的コンパイル言語に迫る高い性能を備えています。

動的言語は「型なし」と言われることがありますが、実際には型がないわけではありません。プリミティブなオブジェクトもユーザー定義のオブジェクトも、すべて型を持っています。しかし、ほとんどの動的言語では型宣言がないため、値の型をコンパイラに伝えられず、型について明示的に扱うこともできない場合がよくあります。一方、静的言語では、コンパイラのために型を注釈でき、通常はその必要もありますが、型はコンパイル時にしか存在せず、実行時に操作したり表現したりすることはできません。Juliaでは型そのものが実行時オブジェクトであり、コンパイラに情報を伝えるためにも利用できます。

### [What Makes Julia, Julia?](@id man-what-makes-julia)

気軽にプログラミングを行う人が型や多重ディスパッチを明示的に使う必要はありませんが、これらはJuliaを統一する中核的な機能です。関数は引数型のさまざまな組み合わせに対して定義され、最も具体的に一致する定義へディスパッチすることで呼び出されます。このモデルは数理プログラミングに適しています。従来のオブジェクト指向ディスパッチのように、最初の引数が操作を「所有する」と考えるのは、数理プログラミングでは不自然だからです。演算子は特別な表記を持つ関数にすぎません。ユーザー定義の新しいデータ型に加算を拡張するには、`+`関数に新しいメソッドを定義します。既存のコードは、その新しいデータ型にもそのまま適用できます。

実行時の型推論（オプションの型注釈で補強されます）に加え、プロジェクトの開始当初から性能を重視してきたこともあり、Juliaの計算効率はほかの動的言語を上回り、静的コンパイル言語にも匹敵します。大規模な数値問題では、速度は常に重要であり、今後も重要であり続け、おそらくこれからも変わりません。過去数十年にわたり、処理対象となるデータ量はムーアの法則に容易に追いついてきたからです。

### [Advantages of Julia](@id man-advantages-of-julia)

Juliaは、使いやすさ、強力さ、効率性を単一の言語でかつてない形で両立することを目指しています。上記に加え、同種のシステムと比べたJuliaの利点には、次のようなものがあります。

  * 無料かつオープンソース（[MIT licensed](https://github.com/JuliaLang/julia/blob/master/LICENSE.md)）
  * ユーザー定義型も、組み込み型と同じ速度とコンパクトさを実現
  * 性能のためにコードをベクトル化する必要がなく、ベクトル化していないコードも高速
  * 並列処理と分散計算を前提に設計
  * 軽量な「グリーン」スレッド（[coroutines](https://en.wikipedia.org/wiki/Coroutine)）
  * 控えめでありながら強力な型システム
  * 数値型などの型に対する、洗練され拡張性の高い変換と昇格
  * [Unicode](https://en.wikipedia.org/wiki/Unicode)を効率的にサポート。[UTF-8](https://en.wikipedia.org/wiki/UTF-8)などに対応
  * C関数を直接呼び出し可能（ラッパーや専用APIは不要）
  * ほかのプロセスを管理するための、シェルのように強力な機能
  * Lisp風のマクロをはじめとするメタプログラミング機能

## [Important Links](@id man-important-links)

Juliaプログラミング言語を学び、使う際に役立つリンクを、網羅的ではありませんが以下に挙げます。

  * [Julia Homepage](https://julialang.org)
  * [Install Julia](https://julialang.org/install/)
  * [Discussion forum](https://discourse.julialang.org)
  * [Julia YouTube](https://www.youtube.com/user/JuliaLanguage)
  * [Find Julia Packages](https://julialang.org/packages/)
  * [Learning Resources](https://julialang.org/learning/)
