# Profiling

`Profile`モジュールは、開発者がコードのパフォーマンスを向上させるためのツールを提供します。使用すると、実行中のコードの測定を行い、個々の行にどれだけの時間が費やされているかを理解するのに役立つ出力を生成します。最も一般的な使用法は、最適化のターゲットとして「ボトルネック」を特定することです。

`Profile` は「サンプリング」として知られるものを実装しています。[statistical profiler](https://en.wikipedia.org/wiki/Profiling_(computer_programming))。これは、任意のタスクの実行中に定期的にバックトレースを取得することによって機能します。各バックトレースは、現在実行中の関数と行番号、さらにこの行に至るまでの関数呼び出しの完全なチェーンをキャプチャし、したがって現在の実行状態の「スナップショット」となります。

特定のコード行を実行するのに多くの実行時間が費やされる場合、この行はすべてのバックトレースのセットに頻繁に表示されます。言い換えれば、特定の行の「コスト」—実際には、この行を含む関数呼び出しのシーケンスのコスト—は、すべてのバックトレースのセットにどれだけ頻繁に現れるかに比例します。

サンプリングプロファイラは、完全な行単位のカバレッジを提供しません。なぜなら、バックトレースは間隔で発生するからです（デフォルトでは、Unixシステムでは1ミリ秒、Windowsでは10ミリ秒ですが、実際のスケジューリングはオペレーティングシステムの負荷に依存します）。さらに、以下で詳しく説明するように、サンプルはすべての実行ポイントのスパースなサブセットで収集されるため、サンプリングプロファイラによって収集されたデータは統計的ノイズの影響を受けます。

これらの制限にもかかわらず、サンプリングプロファイラには substantial strengths があります：

  * コードに変更を加える必要はなく、タイミング測定を行うことができます。
  * それはJuliaのコアコードにプロファイルし、さらには（オプションで）CおよびFortranライブラリにプロファイルすることができます。
  * 「まれに」実行することで、パフォーマンスのオーバーヘッドは非常に少なくなります。プロファイリング中は、コードはほぼネイティブスピードで実行されることができます。

これらの理由から、代替手段を検討する前に、組み込みのサンプリングプロファイラを使用してみることをお勧めします。

## Basic usage

シンプルなテストケースで作業しましょう:

```julia-repl
julia> function myfunc()
           A = rand(200, 200, 400)
           maximum(A)
       end
```

コードをプロファイルする予定のものを少なくとも一度は実行するのが良いアイデアです（JuliaのJITコンパイラをプロファイルしたい場合を除いて）：

```julia-repl
julia> myfunc() # run once to force compilation
```

この関数のプロファイルを作成する準備が整いました：

```julia-repl
julia> using Profile

julia> @profile myfunc()
```

プロファイリング結果を見るためには、いくつかのグラフィカルブラウザがあります。「ファミリー」の一つのビジュアライザーは [FlameGraphs.jl](https://github.com/timholy/FlameGraphs.jl) に基づいており、各ファミリーメンバーは異なるユーザーインターフェースを提供しています：

  * [VS Code](https://www.julia-vscode.org/) は、プロファイルの視覚化をサポートするフルIDEです。
  * [ProfileView.jl](https://github.com/timholy/ProfileView.jl) は、GTKに基づいたスタンドアロンのビジュアライザーです。
  * [ProfileVega.jl](https://github.com/davidanthoff/ProfileVega.jl) はVegaLightを使用しており、Jupyterノートブックと良好に統合されています。
  * [StatProfilerHTML.jl](https://github.com/tkluck/StatProfilerHTML.jl) はHTMLを生成し、いくつかの追加の要約を提示し、Jupyterノートブックとの統合も優れています。
  * [ProfileSVG.jl](https://github.com/timholy/ProfileSVG.jl) はSVGをレンダリングします。
  * [PProf.jl](https://github.com/JuliaPerf/PProf.jl) は、グラフ、フレームグラフなどを検査するためのローカルウェブサイトを提供します。
  * [ProfileCanvas.jl](https://github.com/pfitzseb/ProfileCanvas.jl) は、[Julia VS Code extension](https://www.julia-vscode.org/) によって使用されるHTMLキャンバスベースのプロフィールビューアUIであり、インタラクティブなHTMLファイルを生成することもできます。

完全に独立したプロファイル可視化のアプローチは [PProf.jl](https://github.com/vchuravy/PProf.jl) であり、外部の `pprof` ツールを使用します。

ここでは、標準ライブラリに付属するテキストベースの表示を使用します：

```julia-repl
julia> Profile.print()
80 ./event.jl:73; (::Base.REPL.##1#2{Base.REPL.REPLBackend})()
 80 ./REPL.jl:97; macro expansion
  80 ./REPL.jl:66; eval_user_input(::Any, ::Base.REPL.REPLBackend)
   80 ./boot.jl:235; eval(::Module, ::Any)
    80 ./<missing>:?; anonymous
     80 ./profile.jl:23; macro expansion
      52 ./REPL[1]:2; myfunc()
       38 ./random.jl:431; rand!(::MersenneTwister, ::Array{Float64,3}, ::Int64, ::Type{B...
        38 ./dSFMT.jl:84; dsfmt_fill_array_close_open!(::Base.dSFMT.DSFMT_state, ::Ptr{F...
       14 ./random.jl:278; rand
        14 ./random.jl:277; rand
         14 ./random.jl:366; rand
          14 ./random.jl:369; rand
      28 ./REPL[1]:3; myfunc()
       28 ./reduce.jl:270; _mapreduce(::Base.#identity, ::Base.#scalarmax, ::IndexLinear,...
        3  ./reduce.jl:426; mapreduce_impl(::Base.#identity, ::Base.#scalarmax, ::Array{F...
        25 ./reduce.jl:428; mapreduce_impl(::Base.#identity, ::Base.#scalarmax, ::Array{F...
```

この表示の各行は、コード内の特定の位置（行番号）を表しています。インデントは関数呼び出しのネストされた順序を示すために使用されており、よりインデントされた行は呼び出しのシーケンスの深い位置にあります。各行の最初の「フィールド」は、この行またはこの行によって実行された関数で取得されたバックトレース（サンプル）の数です。2番目のフィールドはファイル名と行番号、3番目のフィールドは関数名です。特定の行番号は、Juliaのコードが変更されると変わる可能性があることに注意してください。追跡したい場合は、この例を自分で実行するのが最良です。

この例では、最上位の関数が `event.jl` ファイルにあることがわかります。これは、Juliaを起動したときにREPLを実行する関数です。`REPL.jl` の97行目を調べると、ここで `eval_user_input()` 関数が呼び出されているのがわかります。これは、REPLで入力した内容を評価する関数であり、インタラクティブに作業しているため、`@profile myfunc()` を入力したときにこれらの関数が呼び出されました。次の行は、[`@profile`](@ref) マクロで行われたアクションを反映しています。

最初の行は、`event.jl`の73行目で80のバックトレースが取得されたことを示していますが、この行自体が「高コスト」であったわけではありません。3行目は、これら80のバックトレースが実際には`eval_user_input`への呼び出しの内部でトリガーされたことを明らかにしています。どの操作が実際に時間を要しているのかを見つけるためには、呼び出しチェーンをさらに深く掘り下げる必要があります。

この出力の最初の「重要な」行は次のとおりです：

```
52 ./REPL[1]:2; myfunc()
```

`REPL`は、`myfunc`をファイルに入れるのではなく、REPLで定義したことを指します。ファイルを使用していた場合、ここにはファイル名が表示されていたでしょう。[1]は、関数`myfunc`がこのREPLセッションで最初に評価された式であることを示しています。`myfunc()`の2行目には`rand`への呼び出しが含まれており、この行で52回（80のうち）のバックトレースが発生しました。その下には、`dSFMT.jl`内の`dsfmt_fill_array_close_open!`への呼び出しが見えます。

少し下に行くと、次のように見えます:

```
28 ./REPL[1]:3; myfunc()
```

`myfunc`の3行目には`maximum`への呼び出しが含まれており、ここで28（80のうち）のバックトレースが取得されました。その下には、このタイプの入力データに対する`maximum`関数で時間のかかる操作を実行する`base/reduce.jl`内の特定の場所が表示されています。

全体として、ランダムな数を生成することは、最大要素を見つけることの約2倍のコストがかかると仮定的に結論付けることができます。この結果に対する信頼性を高めるために、より多くのサンプルを収集することができます：

```julia-repl
julia> @profile (for i = 1:100; myfunc(); end)

julia> Profile.print()
[....]
 3821 ./REPL[1]:2; myfunc()
  3511 ./random.jl:431; rand!(::MersenneTwister, ::Array{Float64,3}, ::Int64, ::Type...
   3511 ./dSFMT.jl:84; dsfmt_fill_array_close_open!(::Base.dSFMT.DSFMT_state, ::Ptr...
  310  ./random.jl:278; rand
   [....]
 2893 ./REPL[1]:3; myfunc()
  2893 ./reduce.jl:270; _mapreduce(::Base.#identity, ::Base.#scalarmax, ::IndexLinea...
   [....]
```

一般的に、ラインで収集された `N` サンプルがある場合、他のノイズ源（コンピュータが他のタスクで忙しい場合など）を除けば、`sqrt(N)` のオーダーの不確実性が期待できます。このルールの主な例外はガーベジコレクションで、これは頻繁には実行されませんが、かなりコストがかかる傾向があります。（JuliaのガーベジコレクタはCで書かれているため、以下で説明する `C=true` 出力モードを使用するか、[ProfileView.jl](https://github.com/timholy/ProfileView.jl) を使用することで、そのようなイベントを検出できます。）

これはデフォルトの「ツリー」ダンプを示しています。代替として、ネストに依存しないカウントを蓄積する「フラット」ダンプがあります。

```julia-repl
julia> Profile.print(format=:flat)
 Count File          Line Function
  6714 ./<missing>     -1 anonymous
  6714 ./REPL.jl       66 eval_user_input(::Any, ::Base.REPL.REPLBackend)
  6714 ./REPL.jl       97 macro expansion
  3821 ./REPL[1]        2 myfunc()
  2893 ./REPL[1]        3 myfunc()
  6714 ./REPL[7]        1 macro expansion
  6714 ./boot.jl      235 eval(::Module, ::Any)
  3511 ./dSFMT.jl      84 dsfmt_fill_array_close_open!(::Base.dSFMT.DSFMT_s...
  6714 ./event.jl      73 (::Base.REPL.##1#2{Base.REPL.REPLBackend})()
  6714 ./profile.jl    23 macro expansion
  3511 ./random.jl    431 rand!(::MersenneTwister, ::Array{Float64,3}, ::In...
   310 ./random.jl    277 rand
   310 ./random.jl    278 rand
   310 ./random.jl    366 rand
   310 ./random.jl    369 rand
  2893 ./reduce.jl    270 _mapreduce(::Base.#identity, ::Base.#scalarmax, :...
     5 ./reduce.jl    420 mapreduce_impl(::Base.#identity, ::Base.#scalarma...
   253 ./reduce.jl    426 mapreduce_impl(::Base.#identity, ::Base.#scalarma...
  2592 ./reduce.jl    428 mapreduce_impl(::Base.#identity, ::Base.#scalarma...
    43 ./reduce.jl    429 mapreduce_impl(::Base.#identity, ::Base.#scalarma...
```

もしあなたのコードに再帰が含まれている場合、混乱を招く可能性のある点は、「子」関数内の行が、全体のバックトレースよりも多くのカウントを蓄積することがあるということです。次の関数定義を考えてみてください：

```julia
dumbsum(n::Integer) = n == 1 ? 1 : 1 + dumbsum(n-1)
dumbsum3() = dumbsum(3)
```

`dumbsum3`をプロファイルしているときに、`dumbsum(1)`を実行している間にバックトレースを取得すると、バックトレースは次のようになります：

```julia
dumbsum3
    dumbsum(3)
        dumbsum(2)
            dumbsum(1)
```

その結果、この子関数は3回カウントされますが、親関数は1回しかカウントされません。「ツリー」表現はこれをより明確にし、この理由（他にもいくつかの理由）から、結果を表示する最も便利な方法であると思われます。

## Accumulation and clearing

[`@profile`](@ref) の結果はバッファに蓄積されます。`4d61726b646f776e2e436f64652822222c20224070726f66696c652229_40726566` の下で複数のコードを実行すると、[`Profile.print()`](@ref) で結合された結果が表示されます。これは非常に便利ですが、時には新たに始めたいこともあります。その場合は、[`Profile.clear()`](@ref) を使用することができます。

## Options for controlling the display of profile results

[`Profile.print`](@ref) には、これまで説明した以上のオプションがあります。完全な宣言を見てみましょう：

```julia
function print(io::IO = stdout, data = fetch(); kwargs...)
```

まず、2つの位置引数について話し、その後にキーワード引数について説明します。

  * `io` – 結果をバッファ、例えばファイルに保存することができますが、デフォルトでは `stdout`（コンソール）に出力されます。
  * `data` – 分析したいデータを含みます。デフォルトでは、[`Profile.fetch()`](@ref) から取得され、事前に割り当てられたバッファからバックトレースを引き出します。たとえば、プロファイラをプロファイルしたい場合は、次のように言うことができます：

    ```julia
    data = copy(Profile.fetch())
    Profile.clear()
    @profile Profile.print(stdout, data) # Prints the previous results
    Profile.print()                      # Prints results from Profile.print()
    ```

キーワード引数は、次の任意の組み合わせであることができます：

  * `format` – 上述のように、バックトレースがツリー構造を示すインデント付き（デフォルト、`:tree`）で表示されるか、インデントなし（`:flat`）で表示されるかを決定します。
  * `C` – `true` の場合、C および Fortran コードからのバックトレースが表示されます（通常は除外されます）。`Profile.print(C = true)` を使って導入例を実行してみてください。これは、ボトルネックの原因が Julia コードなのか C コードなのかを判断するのに非常に役立ちます。また、`C = true` に設定すると、プロファイルダンプが長くなる代わりにネストの解釈が改善されます。
  * `combine` – 一部のコード行には複数の操作が含まれています。たとえば、`s += A[i]` には配列参照 (`A[i]`) と加算操作が含まれています。これらは生成された機械コードの異なる行に対応しており、そのためこの行のバックトレース中に2つ以上の異なるアドレスがキャプチャされる可能性があります。`combine = true` はそれらをまとめており、通常はこれが望ましいですが、`combine = false` を使用すると、各ユニークな命令ポインタごとに別々の出力を生成できます。
  * `maxdepth` – `:tree`フォーマットで`maxdepth`より深いフレームを制限します。
  * `sortedby` – `:flat` 形式での順序を制御します。`:filefuncline`（デフォルト）はソース行でソートし、`:count` は収集されたサンプルの数の順にソートします。
  * `noisefloor` – サンプルのヒューリスティックノイズフロアよりも低いフレームを制限します（フォーマット `:tree` のみ適用）。これに試してみることをお勧めする値は 2.0 です（デフォルトは 0 です）。このパラメータは、`n <= noisefloor * √N` の場合にサンプルを隠します。ここで、`n` はこの行のサンプル数、`N` は呼び出し元のサンプル数です。
  * `mincount` – `mincount` 回数未満のフレームを制限します。

ファイル/関数名は時々切り捨てられ（`...`で）、インデントは`+n`で切り捨てられます。ここで`n`は、スペースが挿入されるはずだった追加のスペースの数です。深くネストされたコードの完全なプロファイルを取得したい場合、しばしば良いアイデアは、[`IOContext`](@ref)で広い`displaysize`を使用してファイルに保存することです。

```julia
open("/tmp/prof.txt", "w") do s
    Profile.print(IOContext(s, :displaysize => (24, 500)))
end
```

## Configuration

[`@profile`](@ref) はバックトレースを蓄積するだけで、分析は [`Profile.print()`](@ref) を呼び出したときに行われます。長時間実行される計算の場合、バックトレースを保存するために事前に割り当てられたバッファが満杯になる可能性があります。その場合、バックトレースは停止しますが、計算は続行されます。その結果、重要なプロファイリングデータを見逃す可能性があります（その場合、警告が表示されます）。

関連するパラメータをこの方法で取得して構成できます：

```julia
Profile.init() # returns the current settings
Profile.init(n = 10^7, delay = 0.01)
```

`n` は保存できる命令ポインタの総数で、デフォルト値は `10^6` です。通常のバックトレースが 20 の命令ポインタである場合、50000 のバックトレースを収集でき、これは統計的な不確実性が 1% 未満であることを示唆しています。これはほとんどのアプリケーションにとって十分かもしれません。

その結果、スナップショット間で要求された計算を実行するためにJuliaが得る時間を設定する`delay`（秒単位）を変更する必要がある可能性が高くなります。非常に長時間実行されるジョブは、頻繁なバックトレースを必要としないかもしれません。デフォルト設定は`delay = 0.001`です。もちろん、遅延を減らすことも増やすこともできますが、遅延がバックトレースを取得するのに必要な時間（著者のラップトップでは約30マイクロ秒）に近づくと、プロファイリングのオーバーヘッドが増加します。

## Memory allocation analysis

パフォーマンスを向上させるための最も一般的な手法の一つは、メモリ割り当てを減らすことです。Juliaはこれを測定するためのいくつかのツールを提供しています：

### `@time`

割り当ての総量は、[`@time`](@ref)、[`@allocated`](@ref)、および [`@allocations`](@ref) を使用して測定できます。また、特定の行が割り当てを引き起こすことは、これらの行が引き起こすガーベジコレクションのコストを通じてプロファイリングから推測されることがよくあります。しかし、時には各コード行によって割り当てられるメモリの量を直接測定する方が効率的です。

### GC Logging

[`@time`](@ref) は、式を評価する過程でのメモリ使用量とガベージコレクションに関する高レベルの統計をログに記録しますが、ガベージコレクションイベントを個別にログに記録することも有用です。これにより、ガベージコレクタがどのくらいの頻度で実行されているか、各回の実行時間、そして各回に収集されるゴミの量を直感的に把握できます。これは [`GC.enable_logging(true)`](@ref) を使用することで有効にでき、これによりJuliaはガベージコレクションが発生するたびにstderrにログを記録します。

### [Allocation Profiler](@id allocation-profiler)

!!! compat "Julia 1.8"
    この機能は少なくともJulia 1.8が必要です。


アロケーションプロファイラは、実行中に各アロケーションのスタックトレース、タイプ、およびサイズを記録します。[`Profile.Allocs.@profile`](@ref)で呼び出すことができます。

このアロケーションに関する情報は、`Alloc`オブジェクトの配列として返され、`AllocResults`オブジェクトにラップされています。これらを視覚化する最良の方法は、現在[PProf.jl](https://github.com/JuliaPerf/PProf.jl)および[ProfileCanvas.jl](https://github.com/pfitzseb/ProfileCanvas.jl)パッケージを使用することで、最も多くのアロケーションを行っているコールスタックを視覚化できます。

アロケーションプロファイラにはかなりのオーバーヘッドがあるため、いくつかのアロケーションをスキップすることで速度を上げるために `sample_rate` 引数を渡すことができます。 `sample_rate=1.0` を渡すとすべてを記録します（遅いです）； `sample_rate=0.1` を渡すとアロケーションの10％のみを記録します（速いです）、など。

!!! compat "Julia 1.11"
    古いバージョンのJuliaでは、すべてのケースで型をキャプチャできませんでした。古いバージョンのJuliaでは、`Profile.Allocs.UnknownType`型の割り当てが見られる場合、それはプロファイラがどのタイプのオブジェクトが割り当てられたのかを知らないことを意味します。これは主に、コンパイラによって生成されたコードからの割り当てが行われたときに発生しました。詳細については、[issue #43688](https://github.com/JuliaLang/julia/issues/43688)を参照してください。

    Julia 1.11以降、すべてのアロケーションにはタイプが報告される必要があります。


このツールの使い方の詳細については、以下のJuliaCon 2022のトークをご覧ください: https://www.youtube.com/watch?v=BFvpwC8hEWQ

##### Allocation Profiler Example

この簡単な例では、PProfを使用してアロケーションプロファイルを視覚化します。代わりに別の視覚化ツールを使用することもできます。プロファイルを収集し（サンプルレートを指定）、それを視覚化します。

```julia
using Profile, PProf
Profile.Allocs.clear()
Profile.Allocs.@profile sample_rate=0.0001 my_function()
PProf.Allocs.pprof()
```

ここでは、サンプルレートを調整する方法についてのより詳細な例を示します。目指すべき良いサンプル数は約1,000〜10,000です。サンプルが多すぎると、プロファイルビジュアライザーが圧倒され、プロファイリングが遅くなります。サンプルが少なすぎると、代表的なサンプルが得られません。

```julia-repl
julia> import Profile

julia> @time my_function()  # Estimate allocations from a (second-run) of the function
  0.110018 seconds (1.50 M allocations: 58.725 MiB, 17.17% gc time)
500000

julia> Profile.Allocs.clear()

julia> Profile.Allocs.@profile sample_rate=0.001 begin   # 1.5 M * 0.001 = ~1.5K allocs.
           my_function()
       end
500000

julia> prof = Profile.Allocs.fetch();  # If you want, you can also manually inspect the results.

julia> length(prof.allocs)  # Confirm we have expected number of allocations.
1515

julia> using PProf  # Now, visualize with an external tool, like PProf or ProfileCanvas.

julia> PProf.Allocs.pprof(prof; from_c=false)  # You can optionally pass in a previously fetched profile result.
Analyzing 1515 allocation samples... 100%|████████████████████████████████| Time: 0:00:00
Main binary filename not available.
Serving web UI on http://localhost:62261
"alloc-profile.pb.gz"
```

その後、http://localhost:62261 に移動することでプロファイルを表示でき、プロファイルはディスクに保存されます。詳細なオプションについては PProf パッケージを参照してください。

##### Allocation Profiling Tips

上記の通り、プロフィールには約1,000〜10,000のサンプルを目指してください。

すべての*割り当て*の空間で均等にサンプリングしており、サンプルを割り当てのサイズで重み付けしていないことに注意してください。したがって、特定の割り当てプロファイルは、`sample_rate=1`を設定していない限り、プログラム内でほとんどのバイトがどこに割り当てられているかの代表的なプロファイルを提供しない場合があります。

アロケーションは、ユーザーが直接オブジェクトを構築することから発生することもありますが、ランタイム内部から発生したり、型の不安定性を処理するためにコンパイルされたコードに挿入されることもあります。「ソースコード」ビューを見ることは、それらを特定するのに役立ちます。そして、[`Cthulhu.jl`](https://github.com/JuliaDebug/Cthulhu.jl)のような他の外部ツールも、アロケーションの原因を特定するのに役立ちます。

##### Allocation Profile Visualization Tools

現在、アロケーションプロファイルを表示できるいくつかのプロファイリング可視化ツールがあります。以下は、私たちが知っている主要なツールの小さなリストです：

  * [PProf.jl](https://github.com/JuliaPerf/PProf.jl)
  * [ProfileCanvas.jl](https://github.com/pfitzseb/ProfileCanvas.jl)
  * VSCodeの組み込みプロファイルビジュアライザー（`@profview_allocs`） [ドキュメントが必要]
  * REPLで結果を直接表示する

      * 結果は、[`Profile.Allocs.fetch()`](@ref)を介してREPLで確認できます。これにより、スタックトレースと各アロケーションのタイプを表示できます。

#### Line-by-Line Allocation Tracking

代替的な割り当ての測定方法は、`--track-allocation=<setting>` コマンドラインオプションを使用して Julia を起動することです。このオプションでは、`none`（デフォルト、割り当てを測定しない）、`user`（Julia のコアコードを除くすべての場所でメモリ割り当てを測定）、または `all`（各行の Julia コードでメモリ割り当てを測定）を選択できます。割り当ては、コンパイルされたコードの各行について測定されます。Julia を終了すると、累積結果が `.mem` がファイル名の後に付加されたテキストファイルに書き込まれ、ソースファイルと同じディレクトリに保存されます。各行には、割り当てられたバイト数の合計がリストされます。[`Coverage` package](https://github.com/JuliaCI/Coverage.jl) には、割り当てられたバイト数の順に行をソートするなどの基本的な分析ツールが含まれています。

結果を解釈する際には、いくつかの重要な詳細があります。`user` 設定の下では、REPL から直接呼び出された関数の最初の行は、REPL コード自体で発生するイベントによるアロケーションを示します。さらに重要なことに、JIT コンパイルもアロケーションカウントに寄与します。なぜなら、Julia のコンパイラの多くは Julia で書かれており（コンパイルには通常メモリのアロケーションが必要です）、そのためです。推奨される手順は、分析したいすべてのコマンドを実行してコンパイルを強制し、その後 [`Profile.clear_malloc_data()`](@ref) を呼び出してすべてのアロケーションカウンターをリセットすることです。最後に、目的のコマンドを実行し、Julia を終了して `.mem` ファイルの生成をトリガーします。

!!! note
    `--track-allocation`はコード生成を変更してアロケーションをログに記録します。そのため、オプションなしで発生するアロケーションとは異なる場合があります。代わりに[allocation profiler](@ref allocation-profiler)の使用を推奨します。


## External Profiling

現在、Juliaは外部プロファイリングツールとして`Intel VTune`、`OProfile`、および`perf`をサポートしています。

選択したツールに応じて、`Make.user` で `USE_INTEL_JITEVENTS`、`USE_OPROFILE_JITEVENTS`、および `USE_PERF_JITEVENTS` を 1 に設定してコンパイルします。複数のフラグがサポートされています。

Juliaを実行する前に、環境変数 [`ENABLE_JITPROFILING`](@ref ENABLE_JITPROFILING) を1に設定してください。

今、あなたはそれらのツールを使う多くの方法を持っています！例えば、`OProfile`を使ってシンプルな記録を試すことができます：

```
>ENABLE_JITPROFILING=1 sudo operf -Vdebug ./julia test/fastmath.jl
>opreport -l `which ./julia`
```

または `perf` を使って同様に：

```
$ ENABLE_JITPROFILING=1 perf record -o /tmp/perf.data --call-graph dwarf -k 1 ./julia /test/fastmath.jl
$ perf inject --jit --input /tmp/perf.data --output /tmp/perf-jit.data
$ perf report --call-graph -G -i /tmp/perf-jit.data
```

あなたのプログラムについて測定できる興味深いことはまだまだたくさんあります。包括的なリストについては、[Linux perf examples page](https://www.brendangregg.com/perf.html)をお読みください。

実行ごとに `perf.data` ファイルが保存されることを忘れないでください。これは、小さなプログラムでもかなり大きくなる可能性があります。また、perf LLVM モジュールは一時的にデバッグオブジェクトを `~/.debug/jit` に保存しますので、そのフォルダーを頻繁にクリーンアップすることを忘れないでください。
