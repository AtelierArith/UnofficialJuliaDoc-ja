# Multi-processing and Distributed Computing

分散メモリ並列計算の実装は、Juliaに同梱される標準ライブラリのモジュール[`Distributed`](@ref man-distributed)によって提供されます。

現代のコンピューターの多くは複数のCPUを備えており、複数のコンピューターを組み合わせてクラスターを構成することもできます。これら複数のCPUの能力を活用すれば、多くの計算をより短時間で完了できます。性能に影響する主な要因は、CPU自体の速度と、CPUがメモリにアクセスする速度の2つです。クラスターでは、あるCPUが最も高速にアクセスできるのは、同じコンピューター（ノード）内のRAMであることは明らかでしょう。意外かもしれませんが、一般的なマルチコアのノートPCでも、主記憶と[cache](https://www.akkadia.org/drepper/cpumemory.pdf)の速度の違いにより、同様の問題が生じます。したがって、優れたマルチプロセッシング環境では、特定のCPUによるメモリ領域の「所有」を制御できる必要があります。Juliaはメッセージパッシングに基づくマルチプロセッシング環境を提供しており、別々のメモリ領域を持つ複数のプロセス上でプログラムを同時に実行できます。

Juliaのメッセージパッシングの実装は、MPI[^1]などの他の環境とは異なります。Juliaの通信は一般に「片側通信」です。つまり、2つのプロセスが関わる操作でも、プログラマーが明示的に管理する必要があるのは一方のプロセスだけです。さらに、これらの操作は通常、「メッセージ送信」や「メッセージ受信」という形ではなく、ユーザー関数の呼び出しのような、より高水準の操作に近い形を取ります。

Juliaの分散プログラミングは、*リモート参照*と*リモート呼び出し*という2つの基本要素に基づいています。リモート参照は、特定のプロセスに格納されたオブジェクトを、どのプロセスからでも参照できるオブジェクトです。リモート呼び出しは、あるプロセスが別のプロセス（同じプロセスの場合もあります）に対し、指定した引数で特定の関数を呼び出すよう要求するものです。

リモート参照には、[`Future`](@ref Distributed.Future)と[`RemoteChannel`](@ref)の2種類があります。

リモート呼び出しは、結果に対する[`Future`](@ref Distributed.Future)を返します。リモート呼び出しは直ちに戻り、呼び出し元のプロセスは次の操作に進みます。その間、リモート呼び出しは別の場所で実行されます。返された[`Future`](@ref Distributed.Future)に対して[`wait`](@ref)を呼び出すと、リモート呼び出しの完了を待つことができ、[`fetch`](@ref)を使うと結果の値全体を取得できます。

一方、[`RemoteChannel`](@ref)は書き換え可能です。たとえば、複数のプロセスが同じリモートの`Channel`を参照することで、処理を協調させることができます。

各プロセスには識別子が割り当てられています。対話型のJuliaプロンプトを提供するプロセスの`id`は、常に1です。並列処理にデフォルトで使用されるプロセスを「ワーカー」と呼びます。プロセスが1つだけの場合、プロセス1がワーカーとみなされます。それ以外の場合は、プロセス1以外のすべてのプロセスがワーカーとみなされます。そのため、[`pmap`](@ref)のような並列処理手法の恩恵を得るには、2つ以上のプロセスを追加する必要があります。ワーカーで長時間の計算を実行している間にメインプロセスで別の作業を行いたいだけなら、プロセスを1つ追加するだけでも有用です。

実際に試してみましょう。`julia -p n`で起動すると、ローカルマシン上に`n`個のワーカープロセスが作成されます。一般に、`n`はマシンのCPUスレッド数（論理コア数）と同じにするのが適切です。なお、`-p`引数を指定すると、モジュール[`Distributed`](@ref man-distributed)が暗黙的に読み込まれます。

```julia-repl
$ julia -p 2

julia> r = remotecall(rand, 2, 2, 2)
Future(2, 1, 4, nothing)

julia> s = @spawnat 2 1 .+ fetch(r)
Future(2, 1, 5, nothing)

julia> fetch(s)
2×2 Matrix{Float64}:
 1.18526  1.50912
 1.16296  1.60607
```

[`remotecall`](@ref)の第1引数は、呼び出す関数です。Juliaの並列プログラミングの大部分では、特定のプロセスや使用可能なプロセス数を意識する必要はありませんが、[`remotecall`](@ref)は、より細かな制御を提供する低水準インターフェースです。[`remotecall`](@ref)の第2引数は、処理を行うプロセスの`id`で、それ以降の引数は呼び出す関数に渡されます。

この例では、1行目でプロセス2に2行2列の乱数行列の作成を依頼し、2行目でその行列に1を加えるよう依頼しています。2つの計算の結果は、それぞれFutureである`r`と`s`から取得できます。[`@spawnat`](@ref)マクロは、第1引数で指定されたプロセス上で第2引数の式を評価します。

リモートで計算した値をすぐに必要とする場合もあります。典型的には、次のローカル操作に必要なデータを得るために、リモートオブジェクトから読み出す場合です。このために用意されているのが関数[`remotecall_fetch`](@ref)です。これは`fetch(remotecall(...))`と同等ですが、より効率的です。

```julia-repl
julia> remotecall_fetch(r-> fetch(r)[1, 1], 2, r)
0.18526337335308085
```

これはワーカー2上で配列を取得し、その最初の値を返します。この場合、`fetch`は配列を所有するワーカー上で実行されるため、データを移動しないことに注意してください。次のようにも書けます。

```julia-repl
julia> remotecall_fetch(getindex, 2, r, 1, 1)
0.10824216411304866
```

[`getindex(r,1,1)`](@ref)は`r[1,1]`に[equivalent](@ref man-array-indexing)されることを思い出してください。そのため、この呼び出しはFutureである`r`の最初の要素を取得します。

より簡単にするには、[`@spawnat`](@ref)にシンボル`:any`を渡すことができます。これにより、操作を実行する場所が自動的に選ばれます。

```julia-repl
julia> r = @spawnat :any rand(2,2)
Future(2, 1, 4, nothing)

julia> s = @spawnat :any 1 .+ fetch(r)
Future(3, 1, 5, nothing)

julia> fetch(s)
2×2 Matrix{Float64}:
 1.38854  1.9098
 1.20939  1.57158
```

ここでは`1 .+ r`ではなく`1 .+ fetch(r)`を使っている点に注意してください。コードがどこで実行されるか分からないため、一般には加算を実行するプロセスへ`r`を移動するために、[`fetch`](@ref)が必要になる可能性があります。ただし、この例では[`@spawnat`](@ref)が`r`を所有するプロセス上で計算を実行するよう適切に判断するため、[`fetch`](@ref)は何もしません（処理は行われません）。

（[`@spawnat`](@ref)は組み込み機能ではなく、Juliaで[macro](@ref man-macros)として定義されていることも覚えておくとよいでしょう。同様の構文を独自に定義することもできます。）

重要なのは、[`Future`](@ref Distributed.Future)は一度値を取得すると、その値をローカルにキャッシュするという点です。その後の[`fetch`](@ref)呼び出しでは、ネットワーク通信は発生しません。参照しているすべての[`Future`](@ref Distributed.Future)が値を取得すると、リモートに格納されていた値は削除されます。

[`Threads.@spawn`](@ref)は[`@spawnat`](@ref)に似ていますが、タスクを実行するのはローカルプロセス上だけです。ここではこれを使って、各プロセスに仕事を供給する「フィーダー」タスクを作成します。各タスクは、次に計算すべきインデックスを選び、担当プロセスの処理が終わるのを待ってから、インデックスがなくなるまでこれを繰り返します。フィーダータスクの実行が始まるのは、メインタスクが[`@sync`](@ref)ブロックの末尾に到達してからであることに注意してください。この時点でメインタスクは制御を譲り、ローカルのすべてのタスクが完了するのを待ってから関数を戻ります。v0.7以降では、フィーダータスクはすべて同じプロセスで動作するため、`nextidx`を介して状態を共有できます。`Tasks`が協調的にスケジュールされる場合でも、[asynchronous I/O](@ref faq-async-io)のように、状況によってはロックが必要です。協調的なスケジューリングでは、コンテキスト切り替えは明確に定められた時点でのみ発生します。この例では、[`remotecall_fetch`](@ref)の呼び出し時です。これは現在の実装であり、将来のJuliaでは変更される可能性があります。最大N個の`Tasks`をM個の`Process`上で実行する、いわゆる[M:N Threading](https://en.wikipedia.org/wiki/Thread_(computing)#Models)を可能にすることが目指されているためです。その場合、複数のプロセスが同じリソースを同時に読み書きするのは安全ではないため、`nextidx`にはロックの取得・解放モデルが必要になります。

## [Code Availability and Loading Packages](@id code-availability)

コードは、それを実行するすべてのプロセスで利用可能になっていなければなりません。たとえば、Juliaプロンプトに次を入力してみてください。

```julia-repl
julia> function rand2(dims...)
           return 2*rand(dims...)
       end

julia> rand2(2,2)
2×2 Matrix{Float64}:
 0.153756  0.368514
 1.15119   0.918912

julia> fetch(@spawnat :any rand2(2,2))
ERROR: RemoteException(2, CapturedException(UndefVarError(Symbol("#rand2"))))
Stacktrace:
[...]
```

プロセス1は関数`rand2`を認識していましたが、プロセス2は認識していませんでした。

通常、コードはファイルやパッケージから読み込みます。どのプロセスにコードを読み込ませるかは、かなり柔軟に制御できます。次のコードを含むファイル`DummyModule.jl`を考えてみましょう。

```julia
module DummyModule

export MyType, f

mutable struct MyType
    a::Int
end

f(x) = x^2+1

println("loaded")

end
```

すべてのプロセスで`MyType`を参照するには、各プロセスに`DummyModule.jl`を読み込む必要があります。`include("DummyModule.jl")`を呼び出すだけでは、1つのプロセスにしか読み込まれません。すべてのプロセスに読み込むには、[`@everywhere`](@ref)マクロを使います（Juliaは`julia -p 2`で起動します）。

```julia-repl
julia> @everywhere include("DummyModule.jl")
loaded
      From worker 3:    loaded
      From worker 2:    loaded
```

通常と同様、これだけでは、どのプロセスでも`DummyModule`がスコープ内に導入されることはありません。そのためには[`using`](@ref)または[`import`](@ref)が必要です。また、あるプロセスで`DummyModule`をスコープ内に導入しても、他のプロセスでは導入されません。

```julia-repl
julia> using .DummyModule

julia> MyType(7)
MyType(7)

julia> fetch(@spawnat 2 MyType(7))
ERROR: On worker 2:
UndefVarError: `MyType` not defined in `Main`
⋮

julia> fetch(@spawnat 2 DummyModule.MyType(7))
MyType(7)
```

ただし、たとえば`DummyModule`を読み込み済みのプロセスには、それがスコープ内になくても、`MyType`を送ることができます。

```julia-repl
julia> put!(RemoteChannel(2), MyType(7))
RemoteChannel{Channel{Any}}(2, 1, 13)
```

`-L`フラグを使えば、起動時に複数のプロセスへファイルを事前に読み込むこともできます。また、ドライバースクリプトを使って計算を進めることもできます。

```
julia -p <n> -L file1.jl -L file2.jl driver.jl
```

上の例でドライバースクリプトを実行しているJuliaプロセスの`id`は、対話型プロンプトを提供するプロセスと同じく1です。

最後に、`DummyModule.jl`が単独のファイルではなくパッケージである場合、`using DummyModule`はすべてのプロセスに`DummyModule.jl`を*読み込みます*が、スコープ内に導入するのは[`using`](@ref)を呼び出したプロセスだけです。

## Starting and managing worker processes

Juliaの基本インストールには、次の2種類のクラスターのサポートが組み込まれています。

  * 上で示したように、`-p`オプションで指定するローカルクラスター。
  * `--machine-file`オプションを使う、複数のマシンにまたがるクラスター。パスワードなしの`ssh`ログインを使い、指定したマシン上でJuliaワーカープロセスを起動します（現在のホストと同じパスを使用します）。各マシンの定義は`[count*][user@]host[:port] [bind_addr[:port]]`という形式です。`user`のデフォルトは現在のユーザー、`port`のデフォルトは標準のsshポートです。`count`は、そのノードで起動するワーカー数で、デフォルトは1です。省略可能な`bind-to bind_addr[:port]`は、他のワーカーがこのワーカーに接続する際に使うIPアドレスとポートを指定します。

!!! note
    Juliaは一般に後方互換性の維持に努めていますが、ワーカープロセスへのコードの配布には[`Serialization.serialize`](@ref)を使用します。対応するドキュメントで説明されているとおり、Juliaのバージョンが異なる場合の動作は保証できません。そのため、すべてのマシンのすべてのワーカーで同じバージョンを使用することをお勧めします。


クラスター内のプロセスをプログラムから追加、削除、照会するために、[`addprocs`](@ref)、[`rmprocs`](@ref)、[`workers`](@ref)などの関数が用意されています。

```julia-repl
julia> using Distributed

julia> addprocs(2)
2-element Vector{Int64}:
 2
 3
```

[`addprocs`](@ref)を呼び出す前に、マスタープロセスでモジュール[`Distributed`](@ref man-distributed)を明示的に読み込む必要があります。ワーカープロセスでは自動的に利用可能になります。

!!! note
    ワーカーは`~/.julia/config/startup.jl`起動スクリプトを実行しません。また、コマンドラインオプション、グローバル変数、新しいメソッド定義、読み込み済みモジュールなどのグローバルな状態を、他の実行中のプロセスと同期することもありません。`addprocs(exeflags="--project")`を使って特定の環境でワーカーを初期化し、その後`@everywhere using <modulename>`または`@everywhere include("file.jl")`を使用できます。


他の種類のクラスターにも、独自の`ClusterManager`を実装することで対応できます。詳細は後述の[ClusterManagers](@ref)の節を参照してください。

## Data Movement

分散プログラムのオーバーヘッドの大部分は、メッセージの送信とデータの移動によって生じます。性能とスケーラビリティを確保するには、メッセージ数と送信するデータ量を減らすことが極めて重要です。そのためには、Juliaのさまざまな分散プログラミング構文がどのようにデータを移動するかを理解する必要があります。

[`fetch`](@ref)は、オブジェクトをローカルマシンに移動するよう直接要求するため、明示的なデータ移動操作とみなせます。[`@spawnat`](@ref)（およびいくつかの関連構文）もデータを移動しますが、それほど明白ではないため、暗黙的なデータ移動操作と呼べます。乱数行列を作成し、その2乗を計算する次の2つの方法を考えてみましょう。

方法1：

```julia-repl
julia> A = rand(1000,1000);

julia> Bref = @spawnat :any A^2;

[...]

julia> fetch(Bref);
```

方法2：

```julia-repl
julia> Bref = @spawnat :any rand(1000,1000)^2;

[...]

julia> fetch(Bref);
```

違いはわずかに見えますが、[`@spawnat`](@ref)の動作により、実際には大きな差があります。最初の方法では、ローカルで乱数行列を作成し、それを別のプロセスへ送って2乗を計算します。2番目の方法では、乱数行列の作成も2乗の計算も別のプロセス上で行います。したがって、2番目の方法で送信されるデータ量は、最初の方法よりはるかに少なくなります。

この単純な例では、2つの方法の違いを見分けて選択するのは簡単です。しかし実際のプログラムでは、データ移動の設計にもっと検討が必要で、測定も必要になるでしょう。たとえば、最初のプロセスでも行列`A`が必要なら、最初の方法が適しているかもしれません。あるいは、`A`の計算コストが高く、現在のプロセスしかそれを持っていないなら、別のプロセスへの移動は避けられないかもしれません。また、現在のプロセスが[`@spawnat`](@ref)から`fetch(Bref)`までの間にほとんど何も行わないなら、並列化そのものをやめた方がよい可能性もあります。`rand(1000,1000)`を、よりコストの高い操作に置き換える場合も考えてみてください。その場合は、この処理だけのために[`@spawnat`](@ref)文をもう1つ追加するのが適切かもしれません。

## Global variables

[`@spawnat`](@ref)を介してリモート実行される式や、[`remotecall`](@ref)でリモート実行を指定したクロージャは、グローバル変数を参照できます。モジュール`Main`内のグローバル束縛は、他のモジュール内のグローバル束縛とは少し異なる扱いを受けます。次のコードを考えてみましょう。

```julia-repl
A = rand(10,10)
remotecall_fetch(()->sum(A), 2)
```

この場合、[`sum`](@ref)はリモートプロセスで**必ず定義されていなければなりません**。`A`はローカルのワークスペースで定義されたグローバル変数です。ワーカー2の`Main`には、`A`という変数はありません。クロージャ`()->sum(A)`をワーカー2へ送信すると、ワーカー2に`Main.A`が定義されます。`Main.A`は、[`remotecall_fetch`](@ref)の呼び出しが戻った後もワーカー2に存在し続けます。グローバル参照を含むリモート呼び出しでは、グローバルを次のように管理します（`Main`モジュール内のものに限ります）。

  * リモート呼び出しの一部として参照されると、送信先のワーカーに新しいグローバル束縛が作成されます。
  * グローバル定数は、リモートノードでも定数として宣言されます。
  * グローバルが送信先のワーカーに再送されるのは、リモート呼び出しの際だけであり、かつ値が変更された場合だけです。また、クラスターはノード間でグローバル束縛を同期しません。たとえば、次のようになります。

    ```julia
    A = rand(10,10)
    remotecall_fetch(()->sum(A), 2) # worker 2
    A = rand(10,10)
    remotecall_fetch(()->sum(A), 3) # worker 3
    A = nothing
    ```

    上のコードを実行すると、ワーカー2の`Main.A`とワーカー3の`Main.A`は異なる値になり、ノード1の`Main.A`の値は`nothing`に設定されます。

お気づきかもしれませんが、マスターでグローバルに再代入すると、それに関連するメモリは回収される可能性がある一方、ワーカーでは束縛が有効なままなので、そのような処理は行われません。リモートノード上の特定のグローバルが不要になったら、[`clear!`](@ref)を使って手動で`nothing`を再代入できます。これにより、通常のガベージコレクションのサイクルで、関連するメモリが解放されます。

したがって、リモート呼び出しでグローバルを参照する際は注意が必要です。実際には、可能ならグローバルの参照自体を避ける方が望ましいでしょう。どうしても参照する必要がある場合は、`let`ブロックでグローバル変数をローカル化することを検討してください。

たとえば、次のようにします。

```julia-repl
julia> A = rand(10,10);

julia> remotecall_fetch(()->A, 2);

julia> B = rand(10,10);

julia> let B = B
           remotecall_fetch(()->B, 2)
       end;

julia> @fetchfrom 2 InteractiveUtils.varinfo()
name           size summary
––––––––– ––––––––– ––––––––––––––––––––––
A         800 bytes 10×10 Array{Float64,2}
Base                Module
Core                Module
Main                Module
```

この例では、グローバル変数`A`はワーカー2に定義されますが、`B`はローカル変数としてキャプチャされるため、ワーカー2に`B`の束縛は存在しません。

## Parallel Map and Loops

幸い、有用な並列計算の多くはデータ移動を必要としません。よくある例はモンテカルロシミュレーションで、複数のプロセスが独立した試行を同時に処理できます。[`@spawnat`](@ref)を使って、2つのプロセスでコイン投げを行ってみましょう。まず、`count_heads.jl`に次の関数を書きます。

```julia
function count_heads(n)
    c::Int = 0
    for i = 1:n
        c += rand(Bool)
    end
    c
end
```

関数`count_heads`は、単に`n`個のランダムなビットを足し合わせます。2台のマシンで試行を行い、結果を足し合わせるには次のようにします。

```julia-repl
julia> @everywhere include_string(Main, $(read("count_heads.jl", String)), "count_heads.jl")

julia> a = @spawnat :any count_heads(100000000)
Future(2, 1, 6, nothing)

julia> b = @spawnat :any count_heads(100000000)
Future(3, 1, 7, nothing)

julia> fetch(a)+fetch(b)
100001564
```

この例は、強力でよく使われる並列プログラミングのパターンを示しています。多数の反復を複数のプロセス上で独立に実行し、その結果を何らかの関数で結合するというものです。この結合処理は、一般にテンソルの階数を減らすため、*リダクション*と呼ばれます。たとえば、数値のベクトルを1つの数値にまとめたり、行列を1つの行や列にまとめたりします。コードでは通常、`x = f(x,v[i])`という形になります。ここで、`x`は累積変数、`f`はリダクション関数、`v[i]`はリダクションの対象となる要素です。操作の実行順序が結果に影響しないように、`f`は結合法則を満たすことが望まれます。

`count_heads`にこのパターンを適用した方法は、一般化できます。この例では[`@spawnat`](@ref)文を明示的に2つ使ったため、並列処理は2つのプロセスに限られています。任意の数のプロセスで実行するには、分散メモリ上で動作する*並列forループ*を使用できます。Juliaでは、[`@distributed`](@ref)を使って次のように書けます。

```julia
nheads = @distributed (+) for i = 1:200000000
    Int(rand(Bool))
end
```

この構文は、反復を複数のプロセスに割り当て、指定したリダクション（この例では`(+)`）で結合するパターンを実装しています。各反復の結果には、ループ内の最後の式の値が使われます。並列ループ式全体の評価結果が、最終的な答えになります。

並列forループは逐次forループに似た見た目ですが、動作は大きく異なることに注意してください。特に、反復の実行順序は定まっていません。また、反復は異なるプロセス上で実行されるため、変数や配列への書き込みは全体から見えるわけではありません。並列ループ内で使われる変数は、各プロセスへコピーされ、配布されます。

たとえば、次のコードは意図どおりには動作しません。

```julia
a = zeros(100000)
@distributed for i = 1:100000
    a[i] = i
end
```

各プロセスが`a`の別々のコピーを持つため、このコードではその全体を初期化できません。このような並列forループは避けなければなりません。幸い、[Shared Arrays](@ref man-shared-arrays)を使えば、この制限を回避できます。

```julia
using SharedArrays

a = SharedArray{Float64}(10)
@distributed for i = 1:10
    a[i] = i
end
```

変数が読み取り専用であれば、並列ループ内で「外側」の変数を使うことに問題はありません。

```julia
a = randn(1000)
@distributed (+) for i = 1:100000
    f(a[rand(1:end)])
end
```

ここでは各反復で、すべてのプロセスが共有するベクトル`a`からランダムに選んだサンプルに、`f`を適用しています。

これまでの例にあるように、リダクション演算子は不要なら省略できます。その場合、ループは非同期に実行されます。つまり、利用可能なすべてのワーカーで独立したタスクを起動し、完了を待たずに[`Future`](@ref Distributed.Future)の配列を直ちに返します。呼び出し元は、後でそれらに[`fetch`](@ref)を呼び出して[`Future`](@ref Distributed.Future)の完了を待つことができます。また、`@sync @distributed for`のようにループの前に[`@sync`](@ref)を付けて、ループの末尾で完了を待つこともできます。

リダクション演算子は不要で、ある範囲内のすべての整数（より一般には、あるコレクション内のすべての要素）に関数を適用したいだけの場合もあります。これも*並列map*と呼ばれる有用な操作で、Juliaでは[`pmap`](@ref)関数として実装されています。たとえば、複数の大きな乱数行列の特異値を、次のように並列に計算できます。

```julia-repl
julia> M = Matrix{Float64}[rand(1000,1000) for i = 1:10];

julia> pmap(svdvals, M);
```

Juliaの[`pmap`](@ref)は、各関数呼び出しが大量の処理を行う場合を想定して設計されています。一方、`@distributed for`は、各反復が2つの数値を足すだけといった、ごく小さな処理である場合にも対応できます。[`pmap`](@ref)と`@distributed for`は、どちらも並列計算にはワーカープロセスだけを使用します。`@distributed for`の場合、最後のリダクションは呼び出し元のプロセスで行われます。

## Remote References and AbstractChannels

リモート参照は、常に`AbstractChannel`の実装を参照します。

`AbstractChannel`の具象実装（`Channel`など）には、[`put!`](@ref)、[`take!`](@ref)、[`fetch`](@ref)、[`isready`](@ref)、[`wait`](@ref)を実装する必要があります。[`Future`](@ref Distributed.Future)が参照するリモートオブジェクトは、`Channel{Any}(1)`に格納されます。これは、`Any`型のオブジェクトを保持できる、サイズ1の`Channel`です。

書き換え可能な[`RemoteChannel`](@ref)は、任意の型とサイズのチャネルや、`AbstractChannel`のその他の実装を参照できます。

コンストラクター`RemoteChannel(f::Function, pid)()`を使うと、特定の型の値を複数保持するチャネルへの参照を作成できます。`f`は`pid`上で実行される関数で、`AbstractChannel`を返す必要があります。

たとえば、`RemoteChannel(()->Channel{Int}(10), pid)`は、型が`Int`でサイズが10のチャネルへの参照を返します。このチャネルはワーカー`pid`上に存在します。

[`RemoteChannel`](@ref)に対するメソッド[`put!`](@ref)、[`take!`](@ref)、[`fetch`](@ref)、[`isready`](@ref)、[`wait`](@ref)は、リモートプロセス上の実体となる格納先に転送されます。

したがって、[`RemoteChannel`](@ref)を使って、ユーザーが実装した`AbstractChannel`オブジェクトを参照できます。その簡単な例が、辞書をリモートの格納先として使う次の`DictChannel`です。

```jldoctest
julia> struct DictChannel{T} <: AbstractChannel{T}
           d::Dict
           cond_take::Threads.Condition    # waiting for data to become available
           DictChannel{T}() where {T} = new(Dict(), Threads.Condition())
           DictChannel() = DictChannel{Any}()
       end

julia> begin
       function Base.put!(D::DictChannel, k, v)
           @lock D.cond_take begin
               D.d[k] = v
               notify(D.cond_take)
           end
           return D
       end
       function Base.take!(D::DictChannel, k)
           @lock D.cond_take begin
               v = fetch(D, k)
               delete!(D.d, k)
               return v
           end
       end
       Base.isready(D::DictChannel) = @lock D.cond_take !isempty(D.d)
       Base.isready(D::DictChannel, k) = @lock D.cond_take haskey(D.d, k)
       function Base.fetch(D::DictChannel, k)
           @lock D.cond_take begin
               wait(D, k)
               return D.d[k]
           end
       end
       function Base.wait(D::DictChannel, k)
           @lock D.cond_take begin
               while !isready(D, k)
                   wait(D.cond_take)
               end
           end
       end
       end;

julia> d = DictChannel();

julia> isready(d)
false

julia> put!(d, :k, :v);

julia> isready(d, :k)
true

julia> fetch(d, :k)
:v

julia> wait(d, :k)

julia> take!(d, :k)
:v

julia> isready(d, :k)
false
```

## Channels and RemoteChannels

  * [`Channel`](@ref)はプロセス内でローカルなものです。ワーカー2からワーカー3の[`Channel`](@ref)を直接参照することはできず、逆も同様です。一方、[`RemoteChannel`](@ref)では、ワーカーをまたいで値を格納したり取り出したりできます。
  * [`RemoteChannel`](@ref)は、[`Channel`](@ref)への*ハンドル*と考えることができます。
  * [`RemoteChannel`](@ref)に対応するプロセスID、`pid`は、実体となる格納先、つまり背後にある[`Channel`](@ref)が存在するプロセスを識別します。
  * [`RemoteChannel`](@ref)への参照を持つプロセスは、どれでもそのチャネルに要素を格納したり取り出したりできます。データは、[`RemoteChannel`](@ref)に対応するプロセスへ自動的に送信されます（または、そのプロセスから取得されます）。
  * [`Channel`](@ref)をシリアライズすると、チャネル内のデータもシリアライズされます。そのため、デシリアライズすると、実質的に元のオブジェクトのコピーが作成されます。
  * 一方、[`RemoteChannel`](@ref)のシリアライズでは、ハンドルが参照する[`Channel`](@ref)の場所とインスタンスを特定する識別子だけがシリアライズされます。したがって、デシリアライズされた[`RemoteChannel`](@ref)オブジェクトも、どのワーカー上にあっても、元のものと同じ格納先を参照します。

先ほどのチャネルの例は、次のように変更すればプロセス間通信に使えます。

1つのリモートチャネル`jobs`を処理するために、4つのワーカーを起動します。ID（`job_id`）で識別されるジョブをチャネルに書き込みます。このシミュレーションでリモート実行される各タスクは、`job_id`を読み取り、ランダムな時間だけ待ってから、`job_id`、所要時間、自身の`pid`をまとめたタプルを結果チャネルへ書き戻します。最後に、マスタープロセスですべての`results`を出力します。

```julia-repl
julia> addprocs(4); # add worker processes

julia> const jobs = RemoteChannel(()->Channel{Int}(32));

julia> const results = RemoteChannel(()->Channel{Tuple}(32));

julia> @everywhere function do_work(jobs, results) # define work function everywhere
           while true
               job_id = take!(jobs)
               exec_time = rand()
               sleep(exec_time) # simulates elapsed time doing actual work
               put!(results, (job_id, exec_time, myid()))
           end
       end

julia> function make_jobs(n)
           for i in 1:n
               put!(jobs, i)
           end
       end;

julia> n = 12;

julia> errormonitor(Threads.@spawn make_jobs(n)); # feed the jobs channel with "n" jobs

julia> for p in workers() # start tasks on the workers to process requests in parallel
           remote_do(do_work, p, jobs, results)
       end

julia> @elapsed while n > 0 # print out results
           job_id, exec_time, worker_id = take!(results)
           println("$job_id finished in $(round(exec_time; digits=2)) seconds on worker $worker_id")
           global n = n - 1
       end
1 finished in 0.18 seconds on worker 4
2 finished in 0.26 seconds on worker 5
6 finished in 0.12 seconds on worker 4
7 finished in 0.18 seconds on worker 4
5 finished in 0.35 seconds on worker 5
4 finished in 0.68 seconds on worker 2
3 finished in 0.73 seconds on worker 3
11 finished in 0.01 seconds on worker 3
12 finished in 0.02 seconds on worker 3
9 finished in 0.26 seconds on worker 5
8 finished in 0.57 seconds on worker 4
10 finished in 0.58 seconds on worker 2
0.055971741
```

### Remote References and Distributed Garbage Collection

リモート参照が指すオブジェクトを解放できるのは、クラスター内で保持されている参照が*すべて*削除されたときだけです。

値を格納するノードは、どのワーカーがその値への参照を持っているかを追跡します。[`RemoteChannel`](@ref)や、まだ値を取得していない[`Future`](@ref Distributed.Future)がワーカーへシリアライズされるたびに、参照先のノードへ通知されます。また、[`RemoteChannel`](@ref)や、まだ値を取得していない[`Future`](@ref Distributed.Future)がローカルでガベージコレクションされるたびに、値を所有するノードへ通知されます。これは、クラスターを認識する内部シリアライザーによって実装されています。リモート参照は、実行中のクラスター内でのみ有効です。通常の`IO`オブジェクトに対して参照をシリアライズしたり、そこからデシリアライズしたりすることはサポートされていません。

通知は「追跡」メッセージを送信することで行われます。参照が別のプロセスへシリアライズされると「参照追加」メッセージが送られ、参照がローカルでガベージコレクションされると「参照削除」メッセージが送られます。

[`Future`](@ref Distributed.Future)は一度だけ書き込み可能で、ローカルにキャッシュされるため、[`Future`](@ref Distributed.Future)に対して[`fetch`](@ref)を実行すると、値を所有するノードの参照追跡情報も更新されます。

値を所有するノードは、その値への参照がすべてなくなった時点で値を解放します。

[`Future`](@ref Distributed.Future)では、すでに値を取得済みの[`Future`](@ref Distributed.Future)を別のノードへシリアライズすると、値も一緒に送信されます。この時点では、元のリモート格納先の値がすでに回収されている可能性があるためです。

オブジェクトがローカルでガベージコレクションされる*タイミング*は、オブジェクトのサイズと、システムの現在のメモリ逼迫状況によって決まることに注意してください。

リモート参照では、ローカルの参照オブジェクトは非常に小さい一方で、リモートノードに格納された値は非常に大きいことがあります。ローカルオブジェクトはすぐに回収されるとは限らないため、[`RemoteChannel`](@ref)のローカルインスタンスや、まだ値を取得していない[`Future`](@ref Distributed.Future)に対しては、[`finalize`](@ref)を明示的に呼び出すことをお勧めします。[`Future`](@ref Distributed.Future)に[`fetch`](@ref)を呼び出すと、リモート格納先からその参照も削除されるため、値を取得済みの[`Future`](@ref Distributed.Future)ではこれは不要です。[`finalize`](@ref)を明示的に呼び出すと、その値への参照を削除するよう、リモートノードへ直ちにメッセージが送信されます。

ファイナライズされた参照は無効になり、それ以降の呼び出しでは使用できません。

## Local invocations

リモートノードで実行する際には、必ずデータがそのノードへコピーされます。これは、リモート呼び出しの場合も、別のノード上の[`RemoteChannel`](@ref) / [`Future`](@ref Distributed.Future)にデータを格納する場合も同様です。予想どおり、リモートノード上にはシリアライズされたオブジェクトのコピーが作成されます。ただし、宛先ノードがローカルノードである場合、つまり呼び出し元のプロセスIDとリモートノードのIDが同じ場合は、ローカル呼び出しとして実行されます。通常は別のタスクで実行されますが、常にそうとは限りません。また、データのシリアライズやデシリアライズは行われません。そのため、呼び出しは渡されたものと同じオブジェクトインスタンスを参照し、コピーは作成されません。この動作を次の例で示します。

```julia-repl
julia> using Distributed

julia> rc = RemoteChannel(()->Channel(3));   # RemoteChannel created on local node

julia> v = [0];

julia> for i in 1:3
           v[1] = i                          # Reusing `v`
           put!(rc, v)
       end;

julia> result = [take!(rc) for _ in 1:3];

julia> println(result);
[[3], [3], [3]]

julia> println("Num Unique objects : ", length(unique(map(objectid, result))));
Num Unique objects : 1

julia> addprocs(1);

julia> rc = RemoteChannel(()->Channel(3), workers()[1]);   # RemoteChannel created on remote node

julia> v = [0];

julia> for i in 1:3
           v[1] = i
           put!(rc, v)
       end;

julia> result = [take!(rc) for _ in 1:3];

julia> println(result);
[[1], [2], [3]]

julia> println("Num Unique objects : ", length(unique(map(objectid, result))));
Num Unique objects : 3
```

このように、ローカルで所有する[`RemoteChannel`](@ref)に対して、同じオブジェクト`v`を呼び出し間で変更しながら[`put!`](@ref)を行うと、格納されるのは同じ1つのオブジェクトインスタンスです。これに対し、`rc`を所有するノードが別のノードであれば、`v`のコピーが作成されます。

通常、これは問題にはなりません。考慮が必要なのは、オブジェクトをローカルに格納し、かつ呼び出し後にそのオブジェクトを変更する場合だけです。そのような場合は、オブジェクトの`deepcopy`を格納するのが適切なことがあります。

これは、次の例に示すように、ローカルノードへのリモート呼び出しでも同じです。

```julia-repl
julia> using Distributed; addprocs(1);

julia> v = [0];

julia> v2 = remotecall_fetch(x->(x[1] = 1; x), myid(), v);     # Executed on local node

julia> println("v=$v, v2=$v2, ", v === v2);
v=[1], v2=[1], true

julia> v = [0];

julia> v2 = remotecall_fetch(x->(x[1] = 1; x), workers()[1], v); # Executed on remote node

julia> println("v=$v, v2=$v2, ", v === v2);
v=[0], v2=[1], false
```

この例でも、ローカルノードへのリモート呼び出しは、直接呼び出した場合と同じように動作します。引数として渡されたローカルオブジェクトが変更されます。一方、リモートでの実行では、引数のコピーに対して操作が行われます。

繰り返しになりますが、通常、これは問題にはなりません。ローカルノードを計算ノードとしても使用し、呼び出し後に引数を使用する場合は、この動作を考慮する必要があります。必要に応じて、ローカルノードへの呼び出しには引数のディープコピーを渡さなければなりません。リモートノードへの呼び出しは、常に引数のコピーを操作します。

## [Shared Arrays](@id man-shared-arrays)

共有配列は、システムの共有メモリを使って、同じ配列を複数のプロセスにマッピングします。同じマシン上の2つ以上のプロセスから大量のデータに共同でアクセスしたい場合には、[`SharedArray`](@ref)が適しています。共有配列のサポートはモジュール`SharedArrays`で提供されており、参加するすべてのワーカーで明示的に読み込む必要があります。

これを補完するデータ構造として、外部パッケージ[`DistributedArrays.jl`](https://github.com/JuliaParallel/DistributedArrays.jl)が`DArray`を提供しています。[`SharedArray`](@ref)と似た点もありますが、[`DArray`](https://github.com/JuliaParallel/DistributedArrays.jl)の動作は大きく異なります。[`SharedArray`](@ref)では、「参加する」各プロセスが配列全体にアクセスできます。一方、[`DArray`](https://github.com/JuliaParallel/DistributedArrays.jl)では、各プロセスがローカルにアクセスできるのはデータの一部分だけであり、同じ部分を複数のプロセスで共有することはありません。

[`SharedArray`](@ref)のインデックス操作（代入と値へのアクセス）は通常の配列と同じように動作し、基礎となるメモリをローカルプロセスから利用できるため効率的です。そのため、ほとんどのアルゴリズムは、単一プロセスでの実行にはなるものの、[`SharedArray`](@ref)に対してそのまま動作します。アルゴリズムが入力として[`Array`](@ref)を要求する場合は、[`sdata`](@ref)を呼び出すことで、[`SharedArray`](@ref)から基礎となる配列を取得できます。他の`AbstractArray`型では、[`sdata`](@ref)はオブジェクト自体をそのまま返すため、任意の`Array`型のオブジェクトに対して[`sdata`](@ref)を安全に使用できます。

共有配列のコンストラクターは、次の形式です。

```julia
SharedArray{T,N}(dims::NTuple; init=false, pids=Int[])
```

これは、`pids`で指定したプロセス間で共有する、要素のbits型が`T`、サイズが`dims`の`N`次元共有配列を作成します。分散配列とは異なり、共有配列にアクセスできるのは、名前付き引数`pids`で指定した参加ワーカーだけです（作成元のプロセスが同じホスト上にある場合は、そのプロセスからもアクセスできます）。SharedArrayでサポートされるのは、[`isbits`](@ref)である要素だけであることに注意してください。

シグネチャが`initfn(S::SharedArray)`の`init`関数を指定すると、参加するすべてのワーカー上で呼び出されます。各ワーカーが配列の異なる部分に対して`init`関数を実行するように指定すれば、初期化を並列化できます。

簡単な例を示します。

```julia-repl
julia> using Distributed

julia> addprocs(3)
3-element Vector{Int64}:
 2
 3
 4

julia> @everywhere using SharedArrays

julia> S = SharedArray{Int,2}((3,4), init = S -> S[localindices(S)] = repeat([myid()], length(localindices(S))))
3×4 SharedMatrix{Int64}:
 2  2  3  4
 2  3  3  4
 2  3  4  4

julia> S[3,2] = 7
7

julia> S
3×4 SharedMatrix{Int64}:
 2  2  3  4
 2  3  3  4
 2  7  4  4
```

[`SharedArrays.localindices`](@ref)は、互いに重ならない1次元のインデックス範囲を提供するため、プロセス間でタスクを分担する際に便利なことがあります。もちろん、処理は任意の方法で分割できます。

```julia-repl
julia> S = SharedArray{Int,2}((3,4), init = S -> S[indexpids(S):length(procs(S)):length(S)] = repeat([myid()], length( indexpids(S):length(procs(S)):length(S))))
3×4 SharedMatrix{Int64}:
 2  2  2  2
 3  3  3  3
 4  4  4  4
```

すべてのプロセスが基礎となるデータにアクセスできるため、競合が生じないよう注意する必要があります。たとえば、次のコードを考えてみましょう。

```julia
@sync begin
    for p in procs(S)
        Threads.@spawn begin
            remotecall_wait(fill!, p, S, p)
        end
    end
end
```

これは未定義の動作を引き起こします。各プロセスが配列*全体*を自身の`pid`で埋めるため、`S`の各要素には、最後に書き込んだプロセスの`pid`が残ります。

より大きく複雑な例として、次の「カーネル」を並列に実行することを考えてみましょう。

```julia
q[i,j,t+1] = q[i,j,t] + u[i,j,t]
```

この場合、1次元のインデックスを使って処理を分割しようとすると、問題が生じる可能性が高くなります。`q[i,j,t]`があるワーカーに割り当てられた領域の末尾付近にあり、`q[i,j,t+1]`が別のワーカーに割り当てられた領域の先頭付近にあると、`q[i,j,t+1]`の計算に必要な時点で、`q[i,j,t]`がまだ準備できていない可能性が高いからです。このような場合は、配列を手動で分割した方がよいでしょう。ここでは第2次元に沿って分割します。まず、このワーカーに割り当てられた`(irange, jrange)`のインデックスを返す関数を定義します。

```julia-repl
julia> @everywhere function myrange(q::SharedArray)
           idx = indexpids(q)
           if idx == 0 # This worker is not assigned a piece
               return 1:0, 1:0
           end
           nchunks = length(procs(q))
           splits = [round(Int, s) for s in range(0, stop=size(q,2), length=nchunks+1)]
           1:size(q,1), splits[idx]+1:splits[idx+1]
       end
```

次に、カーネルを定義します。

```julia-repl
julia> @everywhere function advection_chunk!(q, u, irange, jrange, trange)
           @show (irange, jrange, trange)  # display so we can see what's happening
           for t in trange, j in jrange, i in irange
               q[i,j,t+1] = q[i,j,t] + u[i,j,t]
           end
           q
       end
```

`SharedArray`による実装のために、使いやすくするラッパーも定義します。

```julia-repl
julia> @everywhere advection_shared_chunk!(q, u) =
           advection_chunk!(q, u, myrange(q)..., 1:size(q,3)-1)
```

では、3つの異なるバージョンを比較してみましょう。まず、単一プロセスで実行するものです。

```julia-repl
julia> advection_serial!(q, u) = advection_chunk!(q, u, 1:size(q,1), 1:size(q,2), 1:size(q,3)-1);
```

次に、[`@distributed`](@ref)を使うものです。

```julia-repl
julia> function advection_parallel!(q, u)
           for t = 1:size(q,3)-1
               @sync @distributed for j = 1:size(q,2)
                   for i = 1:size(q,1)
                       q[i,j,t+1]= q[i,j,t] + u[i,j,t]
                   end
               end
           end
           q
       end;
```

最後に、分割した領域ごとに処理を委譲するものです。

```julia-repl
julia> function advection_shared!(q, u)
           @sync begin
               for p in procs(q)
                   Threads.@spawn remotecall_wait(advection_shared_chunk!, p, q, u)
               end
           end
           q
       end;
```

`SharedArray`を作成してこれらの関数の実行時間を測定すると、次の結果が得られます（`julia -p 4`を使用）。

```julia-repl
julia> q = SharedArray{Float64,3}((500,500,500));

julia> u = SharedArray{Float64,3}((500,500,500));
```

関数を一度実行してJITコンパイルを済ませ、2回目の実行で[`@time`](@ref)を使って測定します。

```julia-repl
julia> @time advection_serial!(q, u);
(irange,jrange,trange) = (1:500,1:500,1:499)
 830.220 milliseconds (216 allocations: 13820 bytes)

julia> @time advection_parallel!(q, u);
   2.495 seconds      (3999 k allocations: 289 MB, 2.09% gc time)

julia> @time advection_shared!(q,u);
        From worker 2:       (irange,jrange,trange) = (1:500,1:125,1:499)
        From worker 4:       (irange,jrange,trange) = (1:500,251:375,1:499)
        From worker 3:       (irange,jrange,trange) = (1:500,126:250,1:499)
        From worker 5:       (irange,jrange,trange) = (1:500,376:500,1:499)
 238.119 milliseconds (2264 allocations: 169 KB)
```

`advection_shared!`の最大の利点は、ワーカー間の通信を最小限に抑え、それぞれが割り当てられた領域で長時間計算を続けられることです。

### Shared Arrays and Distributed Garbage Collection

リモート参照と同様に、共有配列も、参加するすべてのワーカーからの参照を解放するために、作成元ノードのガベージコレクションに依存します。寿命の短い共有配列オブジェクトを多数作成するコードでは、できるだけ早くそれらを明示的にファイナライズすると有効です。これにより、メモリと、共有領域をマッピングするファイルハンドルの両方が、より早く解放されます。

## ClusterManagers

Juliaプロセスを起動・管理し、論理的なクラスターとしてネットワーク接続する処理は、クラスターマネージャーを介して行われます。`ClusterManager`は、次の役割を担います。

  * クラスター環境でワーカープロセスを起動する
  * 各ワーカーの存続期間中に発生するイベントを管理する
  * 必要に応じて、データ転送機能を提供する

Juliaのクラスターには、次の特徴があります。

  * 最初のJuliaプロセスは`master`とも呼ばれる特別なプロセスで、その`id`は1です。
  * ワーカープロセスを追加・削除できるのは、`master`プロセスだけです。
  * すべてのプロセスが互いに直接通信できます。

ワーカー間の接続（組み込みのTCP/IPトランスポートを使用）は、次の手順で確立されます。

  * マスタープロセスで、`ClusterManager`オブジェクトを指定して[`addprocs`](@ref)を呼び出します。
  * [`addprocs`](@ref)は適切な[`launch`](@ref)メソッドを呼び出し、適切なマシン上に必要な数のワーカープロセスを起動します。
  * 各ワーカーは空きポートで待ち受けを開始し、ホストとポートの情報を[`stdout`](@ref)へ出力します。
  * クラスターマネージャーは各ワーカーの[`stdout`](@ref)を取得し、マスタープロセスから利用できるようにします。
  * マスタープロセスはこの情報を解析し、各ワーカーへのTCP/IP接続を確立します。
  * 各ワーカーには、クラスター内の他のワーカーの情報も通知されます。
  * 各ワーカーは、自身の`id`よりも`id`が小さいすべてのワーカーに接続します。
  * こうして、すべてのワーカーが他のすべてのワーカーと直接接続されたメッシュネットワークが確立されます。

デフォルトのトランスポート層では通常の[`TCPSocket`](@ref)を使いますが、Juliaクラスターで独自のトランスポートを提供することもできます。

Juliaには、次の2つのクラスターマネージャーが組み込まれています。

  * `LocalManager`：[`addprocs()`](@ref)または[`addprocs(np::Integer)`](@ref)を呼び出した場合に使用されます
  * `SSHManager`：ホスト名のリストを指定して[`addprocs(hostnames::Array)`](@ref)を呼び出した場合に使用されます

`LocalManager`は、同じホスト上に追加のワーカーを起動するために使われます。これにより、マルチコアやマルチプロセッサーのハードウェアを活用できます。

したがって、最低限のクラスターマネージャーには次が必要です。

  * 抽象型`ClusterManager`のサブタイプであること
  * 新しいワーカーの起動を担うメソッド[`launch`](@ref)を実装すること
  * ワーカーの存続期間中のさまざまなイベント（割り込みシグナルの送信など）で呼び出される[`manage`](@ref)を実装すること

[`addprocs(manager::FooManager)`](@ref addprocs)を利用するには、`FooManager`に次を実装する必要があります。

```julia
function launch(manager::FooManager, params::Dict, launched::Array, c::Condition)
    [...]
end

function manage(manager::FooManager, id::Integer, config::WorkerConfig, op::Symbol)
    [...]
end
```

例として、同じホスト上でワーカーを起動するマネージャーである`LocalManager`の実装を見てみましょう。

```julia
struct LocalManager <: ClusterManager
    np::Integer
end

function launch(manager::LocalManager, params::Dict, launched::Array, c::Condition)
    [...]
end

function manage(manager::LocalManager, id::Integer, config::WorkerConfig, op::Symbol)
    [...]
end
```

[`launch`](@ref)メソッドは、次の引数を受け取ります。

  * `manager::ClusterManager`：[`addprocs`](@ref)の呼び出しに指定されたクラスターマネージャー
  * `params::Dict`：[`addprocs`](@ref)に渡されたすべてのキーワード引数
  * `launched::Array`：1つ以上の`WorkerConfig`オブジェクトを追加する配列
  * `c::Condition`：ワーカーが起動されるたびに通知する条件変数

[`launch`](@ref)メソッドは、別のタスクで非同期に呼び出されます。このタスクの終了は、要求されたすべてのワーカーの起動が完了したことを示します。したがって、[`launch`](@ref)関数は、要求されたすべてのワーカーを起動したら、**直ちに終了しなければなりません**。

新しく起動したワーカーは、他のワーカーおよびマスタープロセスと全対全で接続されます。コマンドライン引数`--worker[=<cookie>]`を指定すると、起動したプロセスは自身をワーカーとして初期化し、TCP/IPソケットを介して接続を確立します。

クラスター内のすべてのワーカーは、マスターと同じ[cookie](@ref man-cluster-cookie)を共有します。Cookieが指定されていない場合、つまり`--worker`オプションを使用した場合、ワーカーは標準入力からCookieを読み取ろうとします。`LocalManager`と`SSHManager`は、どちらも新しく起動したワーカーの標準入力を介してCookieを渡します。

デフォルトでは、ワーカーは[`getipaddr()`](@ref)の呼び出しで返されるアドレスの空きポートで待ち受けます。省略可能な引数`--bind-to bind_addr[:port]`で、待ち受けるアドレスを明示的に指定できます。これは、複数のネットワークインターフェースを持つホストで有用です。

TCP/IP以外のトランスポートの例として、MPIを使用する実装も考えられます。その場合、`--worker`を**指定してはいけません**。代わりに、新しく起動したワーカーは、並列処理の構文を使う前に`init_worker(cookie)`を呼び出す必要があります。

[`launch`](@ref)メソッドは、起動したワーカーごとに、適切なフィールドを初期化した`WorkerConfig`オブジェクトを`launched`へ追加しなければなりません。

```julia
mutable struct WorkerConfig
    # Common fields relevant to all cluster managers
    io::Union{IO, Nothing}
    host::Union{AbstractString, Nothing}
    port::Union{Integer, Nothing}

    # Used when launching additional workers at a host
    count::Union{Int, Symbol, Nothing}
    exename::Union{AbstractString, Cmd, Nothing}
    exeflags::Union{Cmd, Nothing}

    # External cluster managers can use this to store information at a per-worker level
    # Can be a dict if multiple fields need to be stored.
    userdata::Any

    # SSHManager / SSH tunnel connections to workers
    tunnel::Union{Bool, Nothing}
    bind_addr::Union{AbstractString, Nothing}
    sshflags::Union{Cmd, Nothing}
    max_parallel::Union{Integer, Nothing}

    # Used by Local/SSH managers
    connect_at::Any

    [...]
end
```

`WorkerConfig`のフィールドの多くは、組み込みのマネージャーが使用します。独自のクラスターマネージャーでは、通常、`io`、または`host` / `port`だけを指定します。

  * `io`を指定すると、ホストとポートの情報を読み取るために使われます。Juliaワーカーは起動時にバインド先アドレスとポートを出力します。そのため、ワーカーのポートを手動で設定せずに、利用可能な任意の空きポートで待ち受けることができます。
  * `io`を指定しない場合、接続には`host`と`port`が使われます。
  * `count`、`exename`、`exeflags`は、ワーカーから追加のワーカーを起動する際に使用します。たとえば、クラスターマネージャーが各ノードにワーカーを1つずつ起動し、それを使って追加のワーカーを起動することができます。

      * `count`に整数値`n`を指定すると、合計`n`個のワーカーが起動します。
      * `count`に`:auto`を指定すると、そのマシンのCPUスレッド数（論理コア数）と同じ数のワーカーが起動します。
      * `exename`は、フルパスを含む`julia`実行ファイルの名前です。
      * `exeflags`には、新しいワーカーに必要なコマンドライン引数を設定します。
  * `tunnel`、`bind_addr`、`sshflags`、`max_parallel`は、マスタープロセスからワーカーへ接続するためにsshトンネルが必要な場合に使われます。
  * `userdata`は、独自のクラスターマネージャーがワーカー固有の情報を格納するために用意されています。

`manage(manager::FooManager, id::Integer, config::WorkerConfig, op::Symbol)`は、ワーカーの存続期間中のさまざまなタイミングで、適切な`op`値を指定して呼び出されます。

  * ワーカーがJuliaのワーカープールに追加・削除されると、それぞれ`:register` / `:deregister`で呼び出されます。
  * `interrupt(workers)`が呼び出されると、`:interrupt`で呼び出されます。`ClusterManager`は、該当するワーカーに割り込みシグナルを送る必要があります。
  * 後処理のために、`:finalize`で呼び出されます。

### Cluster Managers with Custom Transports

デフォルトのTCP/IPによる全対全のソケット接続を独自のトランスポート層に置き換えるには、もう少し複雑な実装が必要です。各Juliaプロセスは、接続先のワーカー数と同じ数の通信タスクを持ちます。たとえば、32プロセスからなる全対全メッシュネットワークのJuliaクラスターを考えてみましょう。

  * 各Juliaプロセスには、31個の通信タスクがあります。
  * 各タスクはメッセージ処理ループを実行し、1つのリモートワーカーから受信するすべてのメッセージを処理します。
  * メッセージ処理ループは、`IO`オブジェクト（デフォルト実装では[`TCPSocket`](@ref)など）で待機し、メッセージを1つ丸ごと読み取り、処理してから、次のメッセージを待ちます。
  * プロセスへのメッセージ送信は、通信タスクに限らず、任意のJuliaタスクから直接行われます。この場合も、適切な`IO`オブジェクトを介して送信します。

デフォルトのトランスポートを置き換えるには、新しい実装でリモートワーカーへの接続を確立し、メッセージ処理ループが待機できる適切な`IO`オブジェクトを提供する必要があります。実装すべきマネージャー固有のコールバックは、次のとおりです。

```julia
connect(manager::FooManager, pid::Integer, config::WorkerConfig)
kill(manager::FooManager, pid::Int, config::WorkerConfig)
```

TCP/IPソケットを使うデフォルトの実装は、`connect(manager::ClusterManager, pid::Integer, config::WorkerConfig)`として実装されています。

`connect`は、`IO`オブジェクトのペアを返す必要があります。一方はワーカー`pid`から送られたデータを読み取るためのもの、もう一方はワーカー`pid`へ送るデータを書き込むためのものです。独自のクラスターマネージャーでは、メモリ内の`BufferStream`を橋渡しとして使い、`IO`に基づかない可能性もある独自のトランスポートと、Juliaに組み込まれた並列処理基盤との間でデータを中継できます。

`BufferStream`は、`IO`のように動作するメモリ内の[`IOBuffer`](@ref)です。つまり、非同期に扱えるストリームです。

[Examples repository](https://github.com/JuliaAttic/Examples)の`clustermanager/0mq`フォルダーには、ZeroMQを使い、中央に0MQブローカーを配置したスタートポロジーでJuliaワーカーを接続する例があります。なお、Juliaプロセスは*論理的には*引き続きすべて相互に接続されています。どのワーカーも、トランスポート層で0MQが使われていることを意識せずに、他の任意のワーカーへ直接メッセージを送信できます。

独自のトランスポートを使う場合は、次の点に注意してください。

  * Juliaワーカーを`--worker`で起動してはいけません。`--worker`で起動すると、新しく起動したワーカーはデフォルトのTCP/IPソケットトランスポート実装を使用します。
  * ワーカーからの論理接続を受け入れるたびに、`Base.process_messages(rd::IO, wr::IO)()`を呼び出す必要があります。これにより、`IO`オブジェクトが表すワーカーとのメッセージの読み書きを処理する、新しいタスクが起動します。
  * ワーカープロセスの初期化の一環として、`init_worker(cookie, manager::FooManager)`を*必ず*呼び出さなければなりません。
  * [`launch`](@ref)の呼び出し時に、クラスターマネージャーは`WorkerConfig`のフィールド`connect_at::Any`を設定できます。このフィールドの値は、すべての[`connect`](@ref)コールバックに渡されます。通常、このフィールドにはワーカーへの*接続方法*に関する情報を格納します。たとえば、TCP/IPソケットトランスポートでは、このフィールドでワーカーへの接続先を表す`(host, port)`タプルを指定します。

`kill(manager, pid, config)`は、クラスターからワーカーを削除するために呼び出されます。適切に後処理を行うため、実装側でマスタープロセス上の対応する`IO`オブジェクトを閉じる必要があります。デフォルト実装は、指定したリモートワーカー上で`exit()`呼び出しを実行するだけです。

Examplesフォルダーの`clustermanager/simple`は、UNIXドメインソケットを使ってクラスターを構成する簡単な実装例です。

### Network Requirements for LocalManager and SSHManager

Juliaクラスターは、ローカルのノートPC、部門内のクラスター、クラウドなど、すでに安全が確保された環境のインフラストラクチャ上で実行することを想定して設計されています。この節では、組み込みの`LocalManager`と`SSHManager`に関するネットワークセキュリティ要件を説明します。

  * マスタープロセスは、どのポートでも待ち受けを行いません。ワーカーへの発信接続だけを行います。
  * 各ワーカーは、ローカルインターフェースのうち1つだけにバインドし、OSが割り当てたエフェメラルポート番号で待ち受けます。
  * `addprocs(N)`が使う`LocalManager`は、デフォルトではループバックインターフェースにのみバインドします。つまり、後からリモートホスト上で起動したワーカーや、悪意のある第三者が起動したワーカーは、クラスターに接続できません。`addprocs(4)`に続けて`addprocs(["remote_host"])`を実行すると失敗します。ローカルシステムといくつかのリモートシステムからなるクラスターを作成したい場合は、キーワード引数`restrict`を使い、`LocalManager`に外部ネットワークインターフェースへバインドするよう明示的に指定できます：`addprocs(4; restrict=false)`。
  * `addprocs(list_of_remote_hosts)`が使う`SSHManager`は、SSHを介してリモートホスト上にワーカーを起動します。デフォルトでは、SSHはJuliaワーカーの起動にのみ使われます。その後のマスター・ワーカー間およびワーカー間の接続には、暗号化されていない通常のTCP/IPソケットが使われます。リモートホストでは、パスワードなしのログインを有効にしておく必要があります。追加のSSHフラグや認証情報は、キーワード引数`sshflags`で指定できます。
  * マスター・ワーカー間にもSSH接続を使いたい場合は、`addprocs(list_of_remote_hosts; tunnel=true, sshflags=<ssh keys and other flags>)`が有用です。典型的な例は、ローカルのノートPCでJulia REPL（つまりマスター）を実行し、クラスターの残りをAmazon EC2などのクラウド上に配置する場合です。この場合、公開鍵基盤（PKI）による認証を行うSSHクライアントを使えば、リモートクラスターではポート22だけを開けば済みます。認証情報は`sshflags`で指定でき、たとえば```sshflags=`-i <keyfile>` ```とします。

    デフォルトの全対全トポロジーでは、すべてのワーカーが通常のTCPソケットで相互接続します。そのため、クラスターノードのセキュリティポリシーでは、エフェメラルポートの範囲（OSによって異なります）でワーカー間の通信を自由に行えるようにする必要があります。

    SSHによってワーカー間のすべての通信を保護・暗号化したり、個々のメッセージを暗号化したりするには、独自の`ClusterManager`を使用できます。
  * [`addprocs`](@ref)のオプションとして`multiplex=true`を指定すると、SSH多重化を使ってマスターとワーカーの間にトンネルを作成します。SSH多重化を自分で設定しており、すでに接続が確立されている場合は、`multiplex`オプションにかかわらずSSH多重化が使われます。多重化が有効な場合、既存の接続を使って転送を設定します（sshの`-O forward`オプション）。これは、サーバーがパスワード認証を要求する場合に便利です。[`addprocs`](@ref)の前にサーバーへログインしておけば、Julia内での認証を省略できます。既存の多重化接続を使用しない限り、セッション中の制御ソケットは`~/.ssh/julia-%r@%h:%p`に配置されます。なお、1つのノードに複数のプロセスを作成して多重化を有効にすると、各プロセスが1つの多重化TCP接続を共有するため、帯域幅が制限される可能性があります。

### [Cluster Cookie](@id man-cluster-cookie)

クラスター内のすべてのプロセスは同じCookieを共有します。デフォルトでは、マスタープロセスでランダムに生成された文字列が使われます。

  * [`cluster_cookie()`](@ref)はCookieを返します。一方、`cluster_cookie(cookie)()`はCookieを設定し、新しいCookieを返します。
  * すべての接続で双方向に認証を行い、マスターが起動したワーカーだけが相互に接続できるようにします。
  * Cookieは、起動時に引数`--worker=<cookie>`でワーカーに渡せます。Cookieを付けずに引数`--worker`を指定すると、ワーカーは標準入力（[`stdin`](@ref)）からCookieを読み取ろうとします。Cookieを取得すると、`stdin`は直ちに閉じられます。
  * `ClusterManager`は、マスター上で[`cluster_cookie()`](@ref)を呼び出すことでCookieを取得できます。デフォルトのTCP/IPトランスポートを使用しないクラスターマネージャー（したがって`--worker`を指定しないもの）は、マスターと同じCookieで`init_worker(cookie, manager)`を呼び出さなければなりません。

より高いセキュリティが必要な環境では、独自の`ClusterManager`で対応できます。たとえば、Cookieを事前共有しておけば、起動引数で指定する必要はありません。

## Specifying Network Topology (Experimental)

[`addprocs`](@ref)に渡すキーワード引数`topology`は、ワーカー同士をどのように接続するかを指定します。

  * `:all_to_all`（デフォルト）：すべてのワーカーを相互に接続します。
  * `:master_worker`：ドライバープロセス、つまり`pid`が1のプロセスだけがワーカーに接続します。
  * `:custom`：クラスターマネージャーの`launch`メソッドが、`WorkerConfig`のフィールド`ident`と`connect_idents`を介して接続トポロジーを指定します。クラスターマネージャーから識別子`ident`を与えられたワーカーは、`connect_idents`に指定されたすべてのワーカーに接続します。

キーワード引数`lazy=true|false`は、`topology`オプションが`:all_to_all`の場合にのみ影響します。`true`の場合、クラスターはマスターがすべてのワーカーに接続した状態で開始します。個々のワーカー間の接続は、その2つのワーカー間で最初にリモート呼び出しを行った時点で確立されます。これにより、クラスター内通信のために初期段階で割り当てるリソースを減らせます。接続は、並列プログラムの実行時の必要に応じて確立されます。`lazy`のデフォルト値は`true`です。

現時点では、接続されていないワーカー間でメッセージを送信するとエラーになります。この動作は、機能やインターフェースと同様に実験的なものと考えてください。将来のリリースで変更される可能性があります。

## Noteworthy external packages

Julia自体の並列処理機能以外にも、紹介すべき外部パッケージは数多くあります。たとえば、[`MPI.jl`](https://github.com/JuliaParallel/MPI.jl)は`MPI`プロトコルのJuliaラッパーであり、[`Dagger.jl`](https://github.com/JuliaParallel/Dagger.jl)はPythonの[Dask](https://dask.org/)と同様の機能を提供します。また、[`DistributedArrays.jl`](https://github.com/JuliaParallel/Distributedarrays.jl)は、[outlined above](@ref man-shared-arrays)としてワーカー間に分散した配列操作を提供します。

JuliaのGPUプログラミングのエコシステムにも触れておきましょう。次のようなものが含まれます。

1. [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl)は、各種CUDAライブラリをラップし、Nvidia GPU向けのJuliaカーネルのコンパイルをサポートします。
2. [oneAPI.jl](https://github.com/JuliaGPU/oneAPI.jl)は、oneAPIの統合プログラミングモデルをラップし、対応するアクセラレーター上でのJuliaカーネルの実行をサポートします。現在サポートされているのはLinuxのみです。
3. [AMDGPU.jl](https://github.com/JuliaGPU/AMDGPU.jl)は、AMD ROCmライブラリをラップし、AMD GPU向けのJuliaカーネルのコンパイルをサポートします。現在サポートされているのはLinuxのみです。
4. [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl)、[Tullio.jl](https://github.com/mcabbott/Tullio.jl)、[ArrayFire.jl](https://github.com/JuliaComputing/ArrayFire.jl)などの高水準ライブラリ。

次の例では、`DistributedArrays.jl`と`CUDA.jl`の両方を使い、まず`distribute()`と`CuArray()`を介してキャストすることで、配列を複数のプロセスに分散させます。

`DistributedArrays.jl`をインポートする際は、[`@everywhere`](@ref)を使ってすべてのプロセスでインポートすることを忘れないでください。

```julia-repl
$ ./julia -p 4

julia> addprocs()

julia> @everywhere using DistributedArrays

julia> using CUDA

julia> B = ones(10_000) ./ 2;

julia> A = ones(10_000) .* π;

julia> C = 2 .* A ./ B;

julia> all(C .≈ 4*π)
true

julia> typeof(C)
Vector{Float64} (alias for Array{Float64, 1})

julia> dB = distribute(B);

julia> dA = distribute(A);

julia> dC = 2 .* dA ./ dB;

julia> all(dC .≈ 4*π)
true

julia> typeof(dC)
DistributedArrays.DArray{Float64,1,Vector{Float64}}

julia> cuB = CuArray(B);

julia> cuA = CuArray(A);

julia> cuC = 2 .* cuA ./ cuB;

julia> all(cuC .≈ 4*π);
true

julia> typeof(cuC)
CuArray{Float64,1}
```

次の例では、`DistributedArrays.jl`と`CUDA.jl`の両方を使って配列を複数のプロセスに分散させ、その配列に対して汎用関数を呼び出します。

```julia
function power_method(M, v)
    for i in 1:100
        v = M*v
        v /= norm(v)
    end

    return v, norm(M*v) / norm(v)  # or  (M*v) ./ v
end
```

`power_method`は、新しいベクトルを作成して正規化する処理を繰り返します。関数の宣言では型シグネチャを一切指定していません。先ほどのデータ型で動作するか見てみましょう。

```julia-repl
julia> M = [2. 1; 1 1];

julia> v = rand(2)
2-element Vector{Float64}:
0.40395
0.445877

julia> power_method(M,v)
([0.850651, 0.525731], 2.618033988749895)

julia> cuM = CuArray(M);

julia> cuv = CuArray(v);

julia> curesult = power_method(cuM, cuv);

julia> typeof(curesult)
CuArray{Float64,1}

julia> dM = distribute(M);

julia> dv = distribute(v);

julia> dC = power_method(dM, dv);

julia> typeof(dC)
Tuple{DistributedArrays.DArray{Float64,1,Vector{Float64}},Float64}
```

外部パッケージの簡単な紹介の締めくくりとして、MPIプロトコルのJuliaラッパーである`MPI.jl`を見てみましょう。内部の関数をすべて取り上げると長くなりすぎるため、ここではプロトコルの実装に使われているアプローチを理解するにとどめます。

次の簡単なスクリプトを考えてみてください。各サブプロセスを呼び出してそのランクを初期化し、マスタープロセスに到達したところでランクの総和を計算します。

```julia
import MPI

MPI.Init()

comm = MPI.COMM_WORLD
MPI.Barrier(comm)

root = 0
r = MPI.Comm_rank(comm)

sr = MPI.Reduce(r, MPI.SUM, root, comm)

if(MPI.Comm_rank(comm) == root)
   @printf("sum of ranks: %s\n", sr)
end

MPI.Finalize()
```

```
mpirun -np 4 ./julia example.jl
```

[^1]: ここでのMPIはMPI-1標準を指します。MPI-2以降、MPI標準化委員会は、Remote Memory Access（RMA）と総称される新しい通信機構を導入しました。MPI標準にRMAを追加した目的は、片側通信のパターンを容易に扱えるようにすることでした。最新のMPI標準の詳細については、['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'-': ASCII/Unicode U+002D (category Pd: Punctuation, dash)'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)](https://mpi-forum.org/docs)を参照してください。
