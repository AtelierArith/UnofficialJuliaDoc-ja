# Multi-processing and Distributed Computing

分散メモリ並列計算の実装は、Julia に標準ライブラリの一部として同梱されているモジュール [`Distributed`](@ref man-distributed) によって提供されています。

現代のコンピューターの多くは複数の CPU を搭載しており、複数のコンピューターを組み合わせてクラスターを構成することもできます。こうした複数の CPU の能力を活用すれば、多くの計算をより短時間で完了できます。性能に影響する主な要因は 2 つあります。CPU 自体の速度と、メモリーへのアクセス速度です。クラスターでは、ある CPU が同じコンピューター（ノード）内の RAM に最も速くアクセスできることは、比較的明らかです。意外に思われるかもしれませんが、一般的なマルチコアのノートパソコンでも、メインメモリーと [cache](https://www.akkadia.org/drepper/cpumemory.pdf) の速度差により、同様の問題が生じます。そのため、優れたマルチプロセス環境では、メモリー領域の所有権を特定の CPU に割り当てられる必要があります。Julia はメッセージパッシングに基づくマルチプロセス環境を提供しており、プログラムを別々のメモリー領域を持つ複数のプロセス上で同時に実行できます。

Julia のメッセージパッシングの実装は、MPI[^1] などの他の環境とは異なります。Julia の通信は一般に「片方向」です。つまり、2 つのプロセス間の操作では、プログラマーが明示的に管理する必要があるのは一方のプロセスだけです。また、こうした操作は通常、「メッセージの送信」や「メッセージの受信」のようには見えず、ユーザー関数の呼び出しのような、より高水準の操作に似ています。

Julia の分散プログラミングは、*リモート参照* と *リモート呼び出し* という 2 つの基本要素で構成されています。リモート参照は、特定のプロセスに保存されたオブジェクトを、どのプロセスからでも参照するために使えるオブジェクトです。リモート呼び出しは、あるプロセスが別のプロセス（同じプロセスの場合もあります）上で、指定した引数を使って特定の関数を呼び出すよう要求するものです。

リモート参照には、[`Future`](@ref Distributed.Future) と [`RemoteChannel`](@ref) の 2 種類があります。

リモート呼び出しは、結果を表す [`Future`](@ref Distributed.Future) を返します。リモート呼び出しはすぐに戻り、呼び出し元のプロセスは、別の場所でリモート呼び出しが実行されている間に次の操作へ進みます。返された [`Future`](@ref Distributed.Future) に対して [`wait`](@ref) を呼び出すと、リモート呼び出しの完了を待てます。また、[`fetch`](@ref) を使うと、結果の値全体を取得できます。

一方、[`RemoteChannel`](@ref) は書き換え可能です。たとえば、複数のプロセスが同じリモート `Channel` を参照することで、処理を連携できます。

各プロセスには、それぞれ識別子が割り当てられています。対話型の Julia プロンプトを提供するプロセスの `id` は常に 1 です。並列処理でデフォルトで使われるプロセスは「ワーカー」と呼ばれます。プロセスが 1 つしかない場合は、プロセス 1 がワーカーと見なされます。それ以外の場合、ワーカーはプロセス 1 以外のすべてのプロセスです。そのため、[`pmap`](@ref) のような並列処理手法の利点を得るには、プロセスを 2 つ以上追加する必要があります。長時間の計算をワーカーで実行している間にメインプロセスで別の作業をしたいだけなら、プロセスを 1 つ追加するだけでも有効です。

実際に試してみましょう。`julia -p n` から起動すると、ローカルマシン上に `n` 個のワーカープロセスが作成されます。一般に、`n` はマシン上の CPU スレッド数（論理コア数）と同じにするのが適切です。`-p` 引数を指定すると、モジュール [`Distributed`](@ref man-distributed) も暗黙的に読み込まれることに注意してください。

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

[`remotecall`](@ref) の第 1 引数は、呼び出す関数です。Julia の並列プログラミングの大半では、特定のプロセスや利用可能なプロセス数を指定しませんが、[`remotecall`](@ref) は、より細かく制御できる低水準インターフェースと見なされています。[`remotecall`](@ref) の第 2 引数は、処理を実行するプロセスの `id` です。残りの引数は、呼び出す関数に渡されます。

ご覧のとおり、1 行目ではプロセス 2 に 2×2 の乱数行列を作成するよう依頼し、2 行目ではその行列に 1 を加えるよう依頼しています。どちらの計算結果も、`r` と `s` という 2 つの future から取得できます。[`@spawnat`](@ref) マクロは、第 1 引数で指定したプロセス上で第 2 引数の式を評価します。

リモートで計算した値をすぐに必要とする場合もあります。これは通常、次のローカル操作に必要なデータをリモートオブジェクトから読み取るときに起こります。そのための関数が [`remotecall_fetch`](@ref) です。これは `fetch(remotecall(...))` と同等ですが、より効率的です。

```julia-repl
julia> remotecall_fetch(r-> fetch(r)[1, 1], 2, r)
0.18526337335308085
```

このコードはワーカー 2 上の配列を取得し、その最初の値を返します。この場合、`fetch` は配列を所有するワーカー上で実行されるため、データは移動しないことに注意してください。次のようにも書けます。

```julia-repl
julia> remotecall_fetch(getindex, 2, r, 1, 1)
0.10824216411304866
```

[`getindex(r,1,1)`](@ref) は [equivalent](@ref man-array-indexing) から `r[1,1]` への参照なので、この呼び出しは future `r` の最初の要素を取得します。

より簡単にするため、シンボル `:any` を [`@spawnat`](@ref) に渡せます。これにより、処理を実行する場所が自動的に選ばれます。

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

`1 .+ r` ではなく `1 .+ fetch(r)` を使っていることに注意してください。コードがどこで実行されるか分からないため、一般には加算を行うプロセスへ `r` を移動するための [`fetch`](@ref) が必要になる場合があります。この例では、[`@spawnat`](@ref) が `r` を所有するプロセス上で計算を実行するため、[`fetch`](@ref) は何もしません（処理は行われません）。

（[`@spawnat`](@ref) は組み込み機能ではなく、Julia で [macro](@ref man-macros) として定義されている点に注意してください。このような構文を独自に定義することもできます。）

重要なのは、取得後の [`Future`](@ref Distributed.Future) は値をローカルにキャッシュするという点です。その後の [`fetch`](@ref) 呼び出しでは、ネットワークを介した通信は発生しません。参照しているすべての [`Future`](@ref Distributed.Future) が値を取得すると、リモートに保存された値は削除されます。

[`Threads.@spawn`](@ref) は [`@spawnat`](@ref) に似ていますが、ローカルプロセス上でのみタスクを実行します。これを使って、各プロセスに「フィーダー」タスクを作成します。各タスクは、次に計算するインデックスを選び、そのプロセスの処理が終わるのを待ってから、インデックスがなくなるまで同じことを繰り返します。フィーダータスクは、メインタスクが [`@sync`](@ref) ブロックの末尾に到達するまで実行を開始しません。末尾に到達すると、メインタスクは制御を譲り、すべてのローカルタスクが完了するまで待ってから関数を返します。v0.7 以降では、フィーダータスクはすべて同じプロセス上で実行されるため、`nextidx` を介して状態を共有できます。`Tasks` が協調的にスケジュールされる場合でも、[asynchronous I/O](@ref faq-async-io) のように、状況によってはロックが必要です。つまり、コンテキスト切り替えは明確に定められた地点でのみ発生します。この例では [`remotecall_fetch`](@ref) が呼び出されたときです。これは現在の実装状況であり、今後の Julia バージョンで変更される可能性があります。将来的には、M 個の `Process` 上で最大 N 個の `Tasks` を実行できるようにすることを目指しているためです。これは [M:N Threading](https://en.wikipedia.org/wiki/Thread_(computing)#Models) とも呼ばれます。その場合、複数のプロセスが同じリソースを同時に読み書きするのは安全ではないため、`nextidx` にはロックの取得と解放を行うモデルが必要になります。

## [Code Availability and Loading Packages](@id code-availability)

コードは、そのコードを実行するすべてのプロセスで利用可能でなければなりません。たとえば、Julia のプロンプトで次のように入力します。

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

プロセス 1 は関数 `rand2` を認識していましたが、プロセス 2 は認識していませんでした。

通常はファイルやパッケージからコードを読み込みます。その際、どのプロセスにコードを読み込むかは柔軟に制御できます。次のコードを含むファイル `DummyModule.jl` を考えてみましょう。

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

すべてのプロセスから `MyType` を参照するには、各プロセスで `DummyModule.jl` を読み込む必要があります。`include("DummyModule.jl")` を呼び出すと、1 つのプロセスにだけ読み込まれます。すべてのプロセスに読み込むには、[`@everywhere`](@ref) マクロを使います（Julia を `julia -p 2` で起動します）。

```julia-repl
julia> @everywhere include("DummyModule.jl")
loaded
      From worker 3:    loaded
      From worker 2:    loaded
```

通常どおり、これだけではどのプロセスでも `DummyModule` はスコープに入りません。スコープに入れるには [`using`](@ref) または [`import`](@ref) が必要です。また、あるプロセスで `DummyModule` をスコープに入れても、他のプロセスではスコープに入りません。

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

ただし、たとえば `DummyModule` を読み込んでいるプロセスに `MyType` を送ることは、スコープに入っていなくても可能です。

```julia-repl
julia> put!(RemoteChannel(2), MyType(7))
RemoteChannel{Channel{Any}}(2, 1, 13)
```

起動時に `-L` フラグを使って、複数のプロセスにファイルを事前に読み込ませることもできます。また、ドライバースクリプトを使って計算を実行できます。

```
julia -p <n> -L file1.jl -L file2.jl driver.jl
```

上の例でドライバースクリプトを実行する Julia プロセスの `id` は 1 です。対話型プロンプトを提供するプロセスと同じです。

最後に、`DummyModule.jl` が単独のファイルではなくパッケージの場合、`using DummyModule` はすべてのプロセスで `DummyModule.jl` を *読み込み* ますが、スコープに入れるのは [`using`](@ref) が呼び出されたプロセスだけです。

## Starting and managing worker processes

Julia の基本インストールには、次の 2 種類のクラスターが組み込みでサポートされています。

  * 上記のように `-p` オプションで指定するローカルクラスター。
  * `--machine-file` オプションを使って複数のマシンにまたがるクラスター。この方式では、パスワードなしの `ssh` ログインを使い、指定したマシン上で（現在のホストと同じパスから）Julia ワーカープロセスを起動します。各マシンの指定は `[count*][user@]host[:port] [bind_addr[:port]]` の形式です。`user` のデフォルトは現在のユーザー、`port` のデフォルトは標準の SSH ポートです。`count` はそのノードで起動するワーカー数で、デフォルトは 1 です。省略可能な `bind-to bind_addr[:port]` では、他のワーカーがこのワーカーへの接続に使う IP アドレスとポートを指定します。

!!! note
    Julia は一般に後方互換性の維持に努めていますが、ワーカープロセスへのコード配布は [`Serialization.serialize`](@ref) に依存します。対応するドキュメントに記載されているとおり、異なる Julia バージョン間での動作は保証されません。そのため、すべてのマシン上のすべてのワーカーで同じバージョンを使うことを推奨します。


[`addprocs`](@ref)、[`rmprocs`](@ref)、[`workers`](@ref) などの関数を使うと、クラスター内のプロセスをプログラムから追加、削除、照会できます。

```julia-repl
julia> using Distributed

julia> addprocs(2)
2-element Vector{Int64}:
 2
 3
```

[`addprocs`](@ref) を呼び出す前に、マスタープロセスでモジュール [`Distributed`](@ref man-distributed) を明示的に読み込む必要があります。このモジュールはワーカープロセスでは自動的に利用可能になります。

!!! note
    ワーカーは `~/.julia/config/startup.jl` 起動スクリプトを実行せず、コマンドラインスイッチ、グローバル変数、新しいメソッド定義、読み込み済みモジュールなどのグローバル状態も、他の実行中プロセスと同期しないことに注意してください。特定の環境でワーカーを初期化するには `addprocs(exeflags="--project")` を使い、その後 `@everywhere using <modulename>` または `@everywhere include("file.jl")` を使えます。


以下の [ClusterManagers](@ref) セクションで説明するように、独自の `ClusterManager` を作成すれば、他の種類のクラスターもサポートできます。

## Data Movement

分散プログラムでは、メッセージの送信とデータの移動がオーバーヘッドの大部分を占めます。性能とスケーラビリティを高めるには、メッセージ数と送信データ量を減らすことが重要です。そのため、Julia のさまざまな分散プログラミング構文がどのようにデータを移動するかを理解しておく必要があります。

[`fetch`](@ref) は、オブジェクトをローカルマシンへ移動するよう直接要求するため、明示的なデータ移動操作と見なせます。[`@spawnat`](@ref)（および関連するいくつかの構文）もデータを移動しますが、その動作は分かりにくいため、暗黙的なデータ移動操作と呼べます。乱数行列を作成して二乗する方法を 2 つ考えてみましょう。

方法 1:

```julia-repl
julia> A = rand(1000,1000);

julia> Bref = @spawnat :any A^2;

[...]

julia> fetch(Bref);
```

方法 2:

```julia-repl
julia> Bref = @spawnat :any rand(1000,1000)^2;

[...]

julia> fetch(Bref);
```

違いは些細に見えますが、[`@spawnat`](@ref) の動作を考えると、実際には大きな違いがあります。方法 1 では、ローカルで乱数行列を作成してから、別のプロセスに送って二乗します。方法 2 では、別のプロセス上で乱数行列の作成と二乗の両方を行います。そのため、方法 2 のほうが送信するデータ量は大幅に少なくなります。

この簡単な例では、2 つの方法の違いは明確で、どちらを選ぶべきかも簡単に判断できます。しかし実際のプログラムでは、データ移動の設計により深い検討が必要で、測定も必要になるでしょう。たとえば、最初のプロセスで行列 `A` が必要なら、方法 1 のほうが適切かもしれません。あるいは、`A` の計算コストが高く、現在のプロセスだけがその値を持っているなら、別のプロセスへの移動は避けられないかもしれません。また、現在のプロセスが [`@spawnat`](@ref) と `fetch(Bref)` の間にほとんど何もしないのであれば、並列化自体をやめたほうがよいかもしれません。さらに、`rand(1000,1000)` がより計算コストの高い操作に置き換わる場合を考えてみましょう。その処理だけのために、[`@spawnat`](@ref) 文を追加するのが適切かもしれません。

## Global variables

[`@spawnat`](@ref) を介してリモート実行される式や、[`remotecall`](@ref) を使ってリモート実行用に指定されたクロージャは、グローバル変数を参照することがあります。モジュール `Main` のグローバル束縛は、他のモジュールのグローバル束縛とは少し異なる扱いを受けます。次のコードを見てみましょう。

```julia-repl
A = rand(10,10)
remotecall_fetch(()->sum(A), 2)
```

この場合、リモートプロセス上で [`sum`](@ref) が定義されている必要があります。`A` はローカルワークスペースで定義されたグローバル変数です。ワーカー 2 の `Main` には、`A` という変数はありません。クロージャ `()->sum(A)` をワーカー 2 に送ると、`Main.A` がプロセス 2 上で定義されます。リモート呼び出し [`remotecall_fetch`](@ref) が戻った後も、`Main.A` はワーカー 2 上に残ります。グローバル参照を含むリモート呼び出し（モジュール `Main` 内に限る）では、グローバル変数は次のように扱われます。

  * リモート呼び出しの一部として参照された新しいグローバル束縛は、呼び出し先のワーカー上に作成されます。
  * グローバル定数は、リモートノード上でも定数として宣言されます。
  * グローバル変数が呼び出し先のワーカーに再送されるのは、リモート呼び出しの際に限られ、かつ値が変更されている場合だけです。また、クラスターはノード間でグローバル束縛を同期しません。たとえば、次のようになります。

    ```julia
    A = rand(10,10)
    remotecall_fetch(()->sum(A), 2) # worker 2
    A = rand(10,10)
    remotecall_fetch(()->sum(A), 3) # worker 3
    A = nothing
    ```

    上のコードを実行すると、ワーカー 2 上の `Main.A` とワーカー 3 上の `Main.A` は異なる値になります。一方、ノード 1 上の `Main.A` の値は `nothing` に設定されます。

お気づきかもしれませんが、マスター上でグローバル変数を再代入すると、それに関連付けられたメモリーは回収されることがあります。しかし、ワーカー上では束縛が有効なままなので、そのような処理は行われません。不要になったリモートノード上の特定のグローバル変数を `nothing` に再代入するには、[`clear!`](@ref) を使えます。これにより、通常のガベージコレクションのサイクルで、それらに関連付けられたメモリーが解放されます。

したがって、リモート呼び出しでグローバル変数を参照する場合は注意が必要です。可能であれば、グローバル変数の参照自体を避けるのが望ましいでしょう。どうしても参照する必要がある場合は、`let` ブロックを使ってグローバル変数をローカル化することを検討してください。

たとえば、次のようになります。

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

この例では、グローバル変数 `A` はワーカー 2 上で定義されますが、`B` はローカル変数として捕捉されるため、ワーカー 2 上に `B` の束縛は存在しません。

## Parallel Map and Loops

幸い、多くの有用な並列計算ではデータ移動が不要です。よくある例として、複数のプロセスが独立したシミュレーション試行を同時に処理できるモンテカルロシミュレーションがあります。[`@spawnat`](@ref) を使って、2 つのプロセスでコインを投げてみましょう。まず、次の関数を `count_heads.jl` に記述します。

```julia
function count_heads(n)
    c::Int = 0
    for i = 1:n
        c += rand(Bool)
    end
    c
end
```

関数 `count_heads` は、`n` 個の乱数ビットを単純に合計します。2 台のマシンで試行を実行し、その結果を合計する方法は次のとおりです。

```julia-repl
julia> @everywhere include_string(Main, $(read("count_heads.jl", String)), "count_heads.jl")

julia> a = @spawnat :any count_heads(100000000)
Future(2, 1, 6, nothing)

julia> b = @spawnat :any count_heads(100000000)
Future(3, 1, 7, nothing)

julia> fetch(a)+fetch(b)
100001564
```

この例は、強力でよく使われる並列プログラミングのパターンを示しています。複数のプロセスで多数の反復を独立して実行し、その結果を何らかの関数でまとめます。この集約処理は一般にテンソルのランクを下げるため、*リダクション* と呼ばれます。たとえば、数値のベクトルを 1 つの数値に、行列を 1 行または 1 列に縮約します。コードでは通常、`x = f(x,v[i])` のような形になります。ここで `x` はアキュムレーター、`f` はリダクション関数、`v[i]` はリダクション対象の要素です。演算の順序に左右されないよう、`f` は結合的であることが望まれます。

このパターンを `count_heads` で使う方法は、一般化できることに注目してください。ここでは [`@spawnat`](@ref) を明示的に 2 回呼び出しているため、並列処理は 2 つのプロセスに限られます。任意の数のプロセスで実行するには、分散メモリー上で動作する *並列 for ループ* を使えます。Julia では、次のように [`@distributed`](@ref) を使って記述できます。

```julia
nheads = @distributed (+) for i = 1:200000000
    Int(rand(Bool))
end
```

この構文は、反復を複数のプロセスに割り当て、指定したリダクション（この例では `(+)`）で結果をまとめるパターンを実装します。各反復の結果は、ループ内の最後の式の値になります。並列ループ式全体の評価結果は、最終的な答えです。

並列 for ループは逐次 for ループに似ていますが、動作は大きく異なることに注意してください。特に、反復の実行順序は決まっておらず、反復は異なるプロセス上で実行されるため、変数や配列への書き込みは全体から見える形では共有されません。並列ループ内で使われる変数は、各プロセスにコピーされてブロードキャストされます。

たとえば、次のコードは意図したとおりには動作しません。

```julia
a = zeros(100000)
@distributed for i = 1:100000
    a[i] = i
end
```

各プロセスが `a` の別々のコピーを持つため、このコードではその全要素を初期化できません。このような並列 for ループは避ける必要があります。幸い、この制限は [Shared Arrays](@ref man-shared-arrays) を使って回避できます。

```julia
using SharedArrays

a = SharedArray{Float64}(10)
@distributed for i = 1:10
    a[i] = i
end
```

並列ループ内で「外側」の変数を使うことは、その変数が読み取り専用であれば問題ありません。

```julia
a = randn(1000)
@distributed (+) for i = 1:100000
    f(a[rand(1:end)])
end
```

ここでは、各反復で、すべてのプロセスが共有するベクトル `a` からランダムに選んだサンプルに `f` を適用します。

ご覧のとおり、リダクション演算子が不要なら省略できます。その場合、ループは非同期に実行されます。つまり、利用可能なすべてのワーカー上で独立したタスクを起動し、完了を待たずに [`Future`](@ref Distributed.Future) の配列をすぐに返します。呼び出し元は、後からそれらに対して [`fetch`](@ref) を呼び出して [`Future`](@ref Distributed.Future) の完了を待つことも、`@sync @distributed for` のように [`@sync`](@ref) を先頭に付けて、ループの末尾で完了を待つこともできます。

リダクション演算子は不要で、ある範囲の整数（または、より一般にはコレクション内のすべての要素）に関数を適用するだけでよい場合もあります。これは *並列 map* と呼ばれる便利な操作で、Julia では関数 [`pmap`](@ref) によって実装されています。たとえば、複数の大きな乱数行列の特異値を並列に計算するには、次のようにします。

```julia-repl
julia> M = Matrix{Float64}[rand(1000,1000) for i = 1:10];

julia> pmap(svdvals, M);
```

Julia の [`pmap`](@ref) は、各関数呼び出しで大量の処理を行う場合を想定して設計されています。一方、`@distributed for` は、2 つの数値を足すだけのような、ごく小さな反復にも対応できます。[`pmap`](@ref) と `@distributed for` のどちらも、並列計算にはワーカープロセスだけを使います。`@distributed for` の場合、最終的なリダクションは呼び出し元のプロセスで実行されます。

## Remote References and AbstractChannels

リモート参照は、常に `AbstractChannel` の実装を参照します。

`AbstractChannel` の具体的な実装（`Channel` など）では、[`put!`](@ref)、[`take!`](@ref)、[`fetch`](@ref)、[`isready`](@ref)、[`wait`](@ref) を実装する必要があります。[`Future`](@ref Distributed.Future) が参照するリモートオブジェクトは、`Channel{Any}(1)` に保存されます。これは、`Any` 型のオブジェクトを格納できる、サイズ 1 の `Channel` です。

書き換え可能な [`RemoteChannel`](@ref) は、任意の型とサイズのチャネル、またはその他の `AbstractChannel` の実装を参照できます。

コンストラクター `RemoteChannel(f::Function, pid)()` を使うと、特定の型の値を複数格納するチャネルへの参照を作成できます。`f` は `pid` 上で実行される関数で、`AbstractChannel` を返す必要があります。

たとえば、`RemoteChannel(()->Channel{Int}(10), pid)` は、型 `Int`、サイズ 10 のチャネルへの参照を返します。このチャネルはワーカー `pid` 上に存在します。

[`RemoteChannel`](@ref) に対するメソッド [`put!`](@ref)、[`take!`](@ref)、[`fetch`](@ref)、[`isready`](@ref)、[`wait`](@ref) は、リモートプロセス上のバックストアに転送されます。

したがって、[`RemoteChannel`](@ref) を使うと、ユーザーが実装した `AbstractChannel` オブジェクトを参照できます。簡単な例として、辞書をリモートストアとして使う次の `DictChannel` を示します。

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

  * [`Channel`](@ref) はプロセス内でのみ有効です。ワーカー 2 はワーカー 3 上の [`Channel`](@ref) を直接参照できず、その逆も同様です。ただし、[`RemoteChannel`](@ref) を使えば、ワーカー間で値を送受信できます。
  * [`RemoteChannel`](@ref) は、[`Channel`](@ref) への *ハンドル* と考えることができます。
  * [`RemoteChannel`](@ref) に関連付けられたプロセス ID `pid` は、バックストア、つまり元となる [`Channel`](@ref) が存在するプロセスを示します。
  * [`RemoteChannel`](@ref) を参照できるプロセスは、どれでもチャネルに値を入れたり、値を取り出したりできます。データは、[`RemoteChannel`](@ref) が関連付けられているプロセスへ自動的に送信されるか、そこから取得されます。
  * [`Channel`](@ref) をシリアライズすると、チャネル内にあるデータもシリアライズされます。そのため、デシリアライズすると元のオブジェクトのコピーが実質的に作成されます。
  * 一方、[`RemoteChannel`](@ref) のシリアライズでは、ハンドルが参照する [`Channel`](@ref) の場所とインスタンスを識別する ID だけがシリアライズされます。そのため、デシリアライズされた [`RemoteChannel`](@ref) オブジェクトは、どのワーカー上でも元のオブジェクトと同じバックストアを参照します。

上記のチャネルの例は、次のように変更するとプロセス間通信に使えます。

4 つのワーカーを起動し、単一の `jobs` リモートチャネルを処理させます。ID（`job_id`）で識別されるジョブをチャネルに書き込みます。このシミュレーションでリモート実行される各タスクは、`job_id` を読み取り、ランダムな時間だけ待機してから、`job_id`、所要時間、自身の `pid` を含むタプルを結果チャネルに書き込みます。最後に、すべての `results` をマスタープロセス上で出力します。

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

リモート参照が指すオブジェクトは、クラスター内で保持されている参照が *すべて* 削除されるまで解放されません。

値を保存しているノードは、その値を参照しているワーカーを追跡します。[`RemoteChannel`](@ref) または（未取得の）[`Future`](@ref Distributed.Future) がワーカーにシリアライズされるたびに、参照先のノードに通知されます。また、[`RemoteChannel`](@ref) または（未取得の）[`Future`](@ref Distributed.Future) がローカルでガベージコレクションされるたびに、値を所有するノードにも通知されます。これは、クラスターを認識する内部シリアライザーによって実装されています。リモート参照は、実行中のクラスター内でのみ有効です。通常の `IO` オブジェクトとの間で参照をシリアライズおよびデシリアライズすることはサポートされていません。

通知には「追跡」メッセージが使われます。参照が別のプロセスにシリアライズされると「参照追加」メッセージが送信され、参照がローカルでガベージコレクションされると「参照削除」メッセージが送信されます。

[`Future`](@ref Distributed.Future) は一度だけ書き込め、値をローカルにキャッシュするため、[`Future`](@ref Distributed.Future) に対して [`fetch`](@ref) を実行すると、値を所有するノード上の参照追跡情報も更新されます。

値を所有するノードは、その値への参照がすべてなくなると値を解放します。

[`Future`](@ref Distributed.Future) の場合、取得済みの [`Future`](@ref Distributed.Future) を別のノードにシリアライズすると、値も送信されます。これは、その時点までに元のリモートストアが値を回収している可能性があるためです。

オブジェクトがローカルでガベージコレクションされるタイミングは、オブジェクトのサイズとシステムの現在のメモリー負荷によって異なることに注意してください。

リモート参照の場合、ローカルの参照オブジェクトは非常に小さい一方、リモートノードに保存されている値は非常に大きいことがあります。ローカルオブジェクトがすぐに回収されるとは限らないため、[`RemoteChannel`](@ref) のローカルインスタンスや、未取得の [`Future`](@ref Distributed.Future) に対して、明示的に [`finalize`](@ref) を呼び出すのが望ましい方法です。[`Future`](@ref Distributed.Future) に対して [`fetch`](@ref) を呼び出すと、リモートストアからも参照が削除されるため、取得済みの [`Future`](@ref Distributed.Future) に対しては必要ありません。[`finalize`](@ref) を明示的に呼び出すと、値への参照を削除するようリモートノードに即座にメッセージが送信されます。

ファイナライズされた参照は無効になり、それ以降の呼び出しには使えません。

## Local invocations

リモートノードで実行するには、データを必ずそのノードにコピーする必要があります。これはリモート呼び出しの場合も、別のノード上の [`RemoteChannel`](@ref) / [`Future`](@ref Distributed.Future) にデータを保存する場合も同じです。その結果、シリアライズされたオブジェクトのコピーがリモートノード上に作成されます。ただし、宛先ノードがローカルノード、つまり呼び出し元のプロセス ID とリモートノード ID が同じ場合は、ローカル呼び出しとして実行されます。通常は（常にではありませんが）別のタスクで実行されますが、データのシリアライズやデシリアライズは行われません。そのため、呼び出しは渡されたものと同じオブジェクトインスタンスを参照し、コピーは作成されません。この動作を次に示します。

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

ご覧のとおり、ローカルで所有されている [`RemoteChannel`](@ref) に対して、呼び出しの間に同じオブジェクト `v` を変更しながら [`put!`](@ref) を実行すると、保存されるのは同じ 1 つのオブジェクトインスタンスです。これに対し、`rc` を所有するノードが別のノードの場合は、`v` のコピーが作成されます。

一般には問題になりません。オブジェクトをローカルに保存し、呼び出し後に変更する場合にだけ考慮すればよい点です。そのような場合は、オブジェクトの `deepcopy` を保存するのが適切かもしれません。

次の例のように、ローカルノードへのリモート呼び出しでも同じことが当てはまります。

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

ここでも、ローカルノードへのリモート呼び出しは直接呼び出しと同じように動作します。呼び出しによって、渡されたローカルオブジェクトが変更されます。リモート呼び出しでは、引数のコピーに対して処理が行われます。

繰り返しになりますが、一般には問題になりません。ローカルノードを計算ノードとしても使い、呼び出し後に引数を使用する場合は、この動作を考慮する必要があります。必要に応じて、ローカルノード上で呼び出す関数には引数のディープコピーを渡してください。リモートノードへの呼び出しでは、常に引数のコピーが使われます。

## [Shared Arrays](@id man-shared-arrays)

Shared Array はシステムの共有メモリーを使い、同じ配列を複数のプロセスにマッピングします。同じマシン上の 2 つ以上のプロセスから大量のデータに共同でアクセスしたい場合は、[`SharedArray`](@ref) が適しています。Shared Array はモジュール `SharedArrays` を介してサポートされており、参加するすべてのワーカーで明示的に読み込む必要があります。

これを補完するデータ構造として、外部パッケージ [`DistributedArrays.jl`](https://github.com/JuliaParallel/DistributedArrays.jl) は `DArray` を提供します。[`SharedArray`](@ref) と似た点もありますが、[`DArray`](https://github.com/JuliaParallel/DistributedArrays.jl) の動作は大きく異なります。[`SharedArray`](@ref) では、参加する各プロセスが配列全体にアクセスできます。一方、[`DArray`](https://github.com/JuliaParallel/DistributedArrays.jl) では、各プロセスがローカルにアクセスできるのはデータの一部だけであり、同じ部分を共有するプロセスはありません。

[`SharedArray`](@ref) のインデックス指定（値の代入とアクセス）は通常の配列と同じように機能します。基盤となるメモリーをローカルプロセスから利用できるため、効率的です。そのため、ほとんどのアルゴリズムは [`SharedArray`](@ref) 上で自然に動作しますが、実行は単一プロセスモードになります。アルゴリズムが [`Array`](@ref) 型の入力を要求する場合は、[`SharedArray`](@ref) に対して [`sdata`](@ref) を呼び出すと、基盤となる配列を取得できます。他の `AbstractArray` 型では、[`sdata`](@ref) はオブジェクト自体を返すため、`Array` 型のオブジェクトならどれに対しても安全に [`sdata`](@ref) を使えます。

共有配列のコンストラクターは次の形式です。

```julia
SharedArray{T,N}(dims::NTuple; init=false, pids=Int[])
```

これは、`pids` で指定したプロセス間に、ビット型 `T`、サイズ `dims` の `N` 次元共有配列を作成します。分散配列とは異なり、共有配列にアクセスできるのは、名前付き引数 `pids` で指定した参加ワーカーだけです（作成プロセスが同じホスト上にある場合は、そのプロセスもアクセスできます）。SharedArray でサポートされるのは、[`isbits`](@ref) である要素だけです。

シグネチャが `initfn(S::SharedArray)` の初期化関数 `init` を指定すると、参加するすべてのワーカー上でその関数が呼び出されます。各ワーカーが配列の異なる部分に対して `init` 関数を実行するよう指定すれば、初期化を並列化できます。

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

[`SharedArrays.localindices`](@ref) は、重複しない 1 次元のインデックス範囲を提供するため、プロセス間でタスクを分割する際に便利なことがあります。もちろん、作業は任意の方法で分割できます。

```julia-repl
julia> S = SharedArray{Int,2}((3,4), init = S -> S[indexpids(S):length(procs(S)):length(S)] = repeat([myid()], length( indexpids(S):length(procs(S)):length(S))))
3×4 SharedMatrix{Int64}:
 2  2  2  2
 3  3  3  3
 4  4  4  4
```

すべてのプロセスが基盤となるデータにアクセスできるため、競合が起きないよう注意する必要があります。たとえば、次のコードは、

```julia
@sync begin
    for p in procs(S)
        Threads.@spawn begin
            remotecall_wait(fill!, p, S, p)
        end
    end
end
```

未定義の動作を引き起こします。各プロセスが配列 *全体* をそれぞれの `pid` で埋めるため、特定の `S` 要素について、最後に実行されたプロセスの `pid` が残ります。

より長く複雑な例として、次の「カーネル」を並列実行することを考えてみましょう。

```julia
q[i,j,t+1] = q[i,j,t] + u[i,j,t]
```

この場合、1 次元のインデックスを使って作業を分割すると、問題が起きる可能性が高くなります。`q[i,j,t]` があるワーカーに割り当てられたブロックの末尾近くにあり、`q[i,j,t+1]` が別のワーカーに割り当てられたブロックの先頭近くにあると、`q[i,j,t+1]` の計算に必要な時点で `q[i,j,t]` の準備ができていない可能性が高いためです。このような場合は、配列を手動で分割するほうが適切です。ここでは第 2 次元に沿って分割します。このワーカーに割り当てられた `(irange, jrange)` インデックスを返す関数を定義します。

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

さらに、`SharedArray` 実装用の便利なラッパーを定義します。

```julia-repl
julia> @everywhere advection_shared_chunk!(q, u) =
           advection_chunk!(q, u, myrange(q)..., 1:size(q,3)-1)
```

それでは、3 つのバージョンを比較しましょう。まず、単一プロセスで実行するものです。

```julia-repl
julia> advection_serial!(q, u) = advection_chunk!(q, u, 1:size(q,1), 1:size(q,2), 1:size(q,3)-1);
```

次に、[`@distributed`](@ref) を使うものです。

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

最後に、チャンク単位で処理を委譲するものです。

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

`SharedArray` を作成してこれらの関数の実行時間を測定すると、次の結果が得られます（`julia -p 4` を使用）。

```julia-repl
julia> q = SharedArray{Float64,3}((500,500,500));

julia> u = SharedArray{Float64,3}((500,500,500));
```

関数を一度実行して JIT コンパイルし、2 回目の実行で [`@time`](@ref) します。

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

`advection_shared!` の最大の利点は、ワーカー間の通信量を最小限に抑え、各ワーカーが割り当てられた部分を長時間にわたって計算できることです。

### Shared Arrays and Distributed Garbage Collection

リモート参照と同様に、共有配列も、参加するすべてのワーカーからの参照を解放するために、作成ノードでのガベージコレクションに依存します。短命な共有配列オブジェクトを多数作成するコードでは、できるだけ早く明示的にファイナライズするとよいでしょう。これにより、共有セグメントをマッピングするメモリーとファイルハンドルの両方を、より早く解放できます。

## ClusterManagers

Julia プロセスを論理クラスターとして起動、管理し、ネットワーク接続する処理は、クラスター管理機構が担います。`ClusterManager` は次の役割を担います。

  * クラスター環境でワーカープロセスを起動する
  * 各ワーカーの稼働中に発生するイベントを管理する
  * 必要に応じてデータ転送を提供する

Julia クラスターには、次の特徴があります。

  * 初期の Julia プロセスは `master` とも呼ばれ、特別なプロセスであり、`id` は 1 です。
  * ワーカープロセスを追加または削除できるのは `master` プロセスだけです。
  * すべてのプロセスは互いに直接通信できます。

組み込みの TCP/IP 転送を使ったワーカー間の接続は、次のように確立されます。

  * マスタープロセス上で、`ClusterManager` オブジェクトを指定して [`addprocs`](@ref) を呼び出します。
  * [`addprocs`](@ref) は適切な [`launch`](@ref) メソッドを呼び出し、必要な数のワーカープロセスを適切なマシン上で起動します。
  * 各ワーカーは空いているポートで待ち受けを開始し、ホストとポートの情報を [`stdout`](@ref) に書き込みます。
  * クラスター管理機構は各ワーカーの [`stdout`](@ref) を取得し、マスタープロセスから利用できるようにします。
  * マスタープロセスはこの情報を解析し、各ワーカーへの TCP/IP 接続を確立します。
  * 各ワーカーにも、クラスター内の他のワーカーが通知されます。
  * 各ワーカーは、自身の `id` より `id` が小さいすべてのワーカーに接続します。
  * このようにしてメッシュネットワークが確立され、すべてのワーカーが他のすべてのワーカーと直接接続されます。

デフォルトの転送層では通常の [`TCPSocket`](@ref) を使いますが、Julia クラスター独自の転送方式を提供することもできます。

Julia には、次の 2 つのクラスター管理機構が組み込まれています。

  * `LocalManager`。[`addprocs()`](@ref) または [`addprocs(np::Integer)`](@ref) の呼び出し時に使われます。
  * `SSHManager`。ホスト名のリストを指定して [`addprocs(hostnames::Array)`](@ref) を呼び出すときに使われます。

`LocalManager` は、同じホスト上で追加のワーカーを起動し、マルチコアおよびマルチプロセッサのハードウェアを活用するために使われます。

したがって、最小限のクラスター管理機構には、次の要件があります。

  * 抽象型 `ClusterManager` のサブタイプであること
  * 新しいワーカーの起動を担うメソッド [`launch`](@ref) を実装すること
  * ワーカーの稼働中にさまざまなイベント（割り込みシグナルの送信など）で呼び出される [`manage`](@ref) を実装すること

[`addprocs(manager::FooManager)`](@ref addprocs) では、`FooManager` に次の実装が必要です。

```julia
function launch(manager::FooManager, params::Dict, launched::Array, c::Condition)
    [...]
end

function manage(manager::FooManager, id::Integer, config::WorkerConfig, op::Symbol)
    [...]
end
```

例として、同じホスト上でワーカーを起動する管理機構 `LocalManager` の実装を見てみましょう。

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

メソッド [`launch`](@ref) は、次の引数を取ります。

  * `manager::ClusterManager`: [`addprocs`](@ref) の呼び出し時に渡されたクラスター管理機構
  * `params::Dict`: [`addprocs`](@ref) に渡されたすべてのキーワード引数
  * `launched::Array`: 1 つ以上の `WorkerConfig` オブジェクトを追加する配列
  * `c::Condition`: ワーカーの起動時に通知する条件変数

メソッド [`launch`](@ref) は、別タスクで非同期に呼び出されます。このタスクが終了すると、要求されたすべてのワーカーの起動が完了したことを示します。そのため、[`launch`](@ref) 関数は、要求されたすべてのワーカーを起動したらすぐに終了しなければなりません。

新しく起動したワーカーは、互いに、またマスタープロセスとも全対全方式で接続されます。コマンドライン引数 `--worker[=<cookie>]` を指定すると、起動したプロセスはワーカーとして初期化され、TCP/IP ソケットを介して接続が確立されます。

クラスター内のすべてのワーカーは、マスターと同じ [cookie](@ref man-cluster-cookie) を共有します。クッキーを指定しない場合、つまり `--worker` オプションを使う場合、ワーカーは標準入力からクッキーを読み取ろうとします。`LocalManager` と `SSHManager` は、どちらも標準入力を介して新しく起動したワーカーにクッキーを渡します。

デフォルトでは、ワーカーは [`getipaddr()`](@ref) の呼び出しで返されるアドレス上の空いているポートで待ち受けます。省略可能な引数 `--bind-to bind_addr[:port]` を使うと、待ち受けるアドレスを指定できます。これは複数のネットワークインターフェースを持つホストで便利です。

TCP/IP 以外の転送方式の例として、MPI を使う実装が考えられます。その場合、`--worker` を指定してはなりません。代わりに、新しく起動したワーカーは並列処理の構文を使う前に `init_worker(cookie)` を呼び出す必要があります。

起動した各ワーカーについて、メソッド [`launch`](@ref) は、適切なフィールドを初期化した `WorkerConfig` オブジェクトを `launched` に追加する必要があります。

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

`WorkerConfig` のフィールドの大半は、組み込みの管理機構で使われます。独自のクラスター管理機構では通常、`io`、または `host` / `port` だけを指定します。

  * `io` を指定すると、ホストとポートの情報の読み取りに使われます。Julia ワーカーは起動時にバインドアドレスとポートを出力します。これにより、ワーカーポートを手動で設定しなくても、利用可能な空きポートで待ち受けられます。
  * `io` を指定しない場合は、接続に `host` と `port` が使われます。
  * `count`、`exename`、`exeflags` は、ワーカーから追加のワーカーを起動する場合に関係します。たとえば、クラスター管理機構が各ノードでワーカーを 1 つだけ起動し、そのワーカーから追加のワーカーを起動することがあります。

      * 整数値 `n` を持つ `count` は、合計 `n` 個のワーカーを起動します。
      * 値が `:auto` の `count` は、そのマシンの CPU スレッド数（論理コア数）と同じ数のワーカーを起動します。
      * `exename` は、フルパスを含む `julia` 実行ファイルの名前です。
      * `exeflags` には、新しいワーカーに必要なコマンドライン引数を設定します。
  * `tunnel`、`bind_addr`、`sshflags`、`max_parallel` は、マスタープロセスからワーカーへの接続に SSH トンネルが必要な場合に使われます。
  * `userdata` は、独自のクラスター管理機構がワーカー固有の情報を保存するために用意されています。

`manage(manager::FooManager, id::Integer, config::WorkerConfig, op::Symbol)` は、ワーカーの稼働中に適切な `op` 値を指定して、さまざまなタイミングで呼び出されます。

  * ワーカーが Julia のワーカープールに追加または削除されるときは、`:register` / `:deregister` が渡されます。
  * `interrupt(workers)` が呼び出されるときは、`:interrupt` が渡されます。`ClusterManager` は、適切なワーカーに割り込みシグナルを送る必要があります。
  * クリーンアップ時には `:finalize` が渡されます。

### Cluster Managers with Custom Transports

デフォルトの TCP/IP 全対全ソケット接続を独自の転送層に置き換えるには、もう少し複雑な作業が必要です。各 Julia プロセスには、接続先のワーカー数と同じ数の通信タスクがあります。たとえば、全対全メッシュネットワークを構成する 32 プロセスの Julia クラスターを考えてみましょう。

  * 各 Julia プロセスには 31 個の通信タスクがあります。
  * 各タスクは、単一のリモートワーカーからのすべての受信メッセージを、メッセージ処理ループで処理します。
  * メッセージ処理ループは `IO` オブジェクト（デフォルト実装では [`TCPSocket`](@ref) など）を待ち、メッセージ全体を読み取り、処理してから、次のメッセージを待ちます。
  * プロセスへのメッセージ送信は、通信タスクに限らず、任意の Julia タスクから適切な `IO` オブジェクトを介して直接行われます。

デフォルトの転送方式を置き換えるには、新しい実装でリモートワーカーへの接続を確立し、メッセージ処理ループが待機できる適切な `IO` オブジェクトを提供する必要があります。実装が必要な管理機構固有のコールバックは次のとおりです。

```julia
connect(manager::FooManager, pid::Integer, config::WorkerConfig)
kill(manager::FooManager, pid::Int, config::WorkerConfig)
```

TCP/IP ソケットを使うデフォルト実装は、`connect(manager::ClusterManager, pid::Integer, config::WorkerConfig)` として実装されています。

`connect` は、`IO` オブジェクトのペアを返す必要があります。一方はワーカー `pid` から送信されたデータの読み取り用、もう一方はワーカー `pid` に送信するデータの書き込み用です。独自のクラスター管理機構では、インメモリーの `BufferStream` を配管として使い、独自の（`IO` とは限らない）転送方式と Julia の組み込み並列処理基盤との間でデータを中継できます。

`BufferStream` はインメモリーの [`IOBuffer`](@ref) で、`IO` のように動作します。つまり、非同期に処理できるストリームです。

[Examples repository](https://github.com/JuliaAttic/Examples) 内のフォルダー `clustermanager/0mq` には、ZeroMQ を使って、中央の 0MQ ブローカーを介したスター型トポロジーで Julia ワーカーを接続する例があります。注: Julia プロセスは引き続き *論理的には* すべて相互接続されています。転送層に 0MQ が使われていることを意識せずに、どのワーカーからでも他のワーカーへ直接メッセージを送れます。

独自の転送方式を使う場合は、次の点に注意してください。

  * Julia ワーカーを `--worker` で起動してはなりません。`--worker` で起動すると、新しく起動したワーカーはデフォルトの TCP/IP ソケット転送実装を使います。
  * ワーカーとの論理接続を受け入れるたびに、`Base.process_messages(rd::IO, wr::IO)()` を呼び出す必要があります。これにより、`IO` オブジェクトで表されるワーカーとの間でメッセージを読み書きする新しいタスクが起動します。
  * ワーカープロセスの初期化時に `init_worker(cookie, manager::FooManager)` を必ず呼び出す必要があります。
  * `WorkerConfig` のフィールド `connect_at::Any` は、[`launch`](@ref) の呼び出し時にクラスター管理機構が設定できます。このフィールドの値は、すべての [`connect`](@ref) コールバックに渡されます。通常、このフィールドにはワーカーへの接続方法に関する情報を格納します。たとえば、TCP/IP ソケット転送では、ワーカーへの接続先となる `(host, port)` タプルを指定します。

`kill(manager, pid, config)` は、ワーカーをクラスターから削除するために呼び出されます。マスタープロセス上では、適切にクリーンアップするため、実装側で対応する `IO` オブジェクトを閉じる必要があります。デフォルト実装では、指定したリモートワーカー上で `exit()` 呼び出しを実行するだけです。

Examples フォルダー `clustermanager/simple` には、UNIX ドメインソケットを使ってクラスターを構成する簡単な実装例があります。

### Network Requirements for LocalManager and SSHManager

Julia クラスターは、ローカルのノートパソコン、部門内のクラスター、クラウドなど、すでにセキュリティが確保された環境で実行することを想定して設計されています。このセクションでは、組み込みの `LocalManager` と `SSHManager` に関するネットワークセキュリティ要件を説明します。

  * マスタープロセスはどのポートでも待ち受けません。ワーカーへの外向き接続だけを行います。
  * 各ワーカーはローカルインターフェースの 1 つだけにバインドし、OS が割り当てた一時ポート番号で待ち受けます。
  * `LocalManager` は `addprocs(N)` が使うもので、デフォルトではループバックインターフェースだけにバインドします。そのため、後からリモートホスト上で起動したワーカーや、悪意のあるユーザーがクラスターに接続することはできません。`addprocs(4)` の後に `addprocs(["remote_host"])` を実行すると失敗します。ローカルシステムといくつかのリモートシステムでクラスターを構成したい場合は、キーワード引数 `restrict` を使って、`LocalManager` が外部ネットワークインターフェースにバインドするよう明示的に指定できます。指定例は `addprocs(4; restrict=false)` です。
  * `SSHManager` は `addprocs(list_of_remote_hosts)` が使うもので、SSH を介してリモートホスト上にワーカーを起動します。デフォルトでは、SSH は Julia ワーカーの起動にだけ使われます。その後のマスターとワーカー間、およびワーカー間の接続には、暗号化されていない通常の TCP/IP ソケットが使われます。リモートホストではパスワードなしのログインを有効にする必要があります。追加の SSH フラグや認証情報は、キーワード引数 `sshflags` で指定できます。
  * マスターとワーカーの接続にも SSH を使いたい場合は、`addprocs(list_of_remote_hosts; tunnel=true, sshflags=<ssh keys and other flags>)` が便利です。典型的な例は、Julia REPL（つまりマスター）を実行するローカルのノートパソコンと、Amazon EC2 などのクラウド上にある残りのクラスターで構成する場合です。この場合、リモートクラスターで開放する必要があるのはポート 22 だけで、公開鍵基盤（PKI）による認証を使う SSH クライアントを利用できます。認証情報は `sshflags` で指定できます。たとえば ```sshflags=`-i <keyfile>` ``` のように指定します。

    デフォルトの全対全トポロジーでは、すべてのワーカーが通常の TCP ソケットを介して互いに接続します。そのため、クラスター内のノードでは、一時ポートの範囲（OS によって異なります）について、ワーカー間の通信を許可する必要があります。

    すべてのワーカー間通信を SSH で保護・暗号化したり、個々のメッセージを暗号化したりするには、独自の `ClusterManager` を実装します。
  * [`addprocs`](@ref) のオプションとして `multiplex=true` を指定すると、SSH 多重化を使ってマスターとワーカーの間にトンネルを作成します。SSH 多重化を独自に設定済みで、接続がすでに確立されている場合は、`multiplex` オプションの有無にかかわらず SSH 多重化が使われます。多重化が有効な場合、既存の接続を使って転送が設定されます（ssh の `-O forward` オプション）。サーバーでパスワード認証が必要な場合に便利です。[`addprocs`](@ref) の前にサーバーへログインしておけば、Julia での認証を省略できます。既存の多重化接続を使わない場合、セッション中の制御ソケットは `~/.ssh/julia-%r@%h:%p` に配置されます。ノード上で複数のプロセスを作成して多重化を有効にすると、プロセス間で 1 つの多重化 TCP 接続を共有するため、帯域幅が制限される場合があることに注意してください。

### [Cluster Cookie](@id man-cluster-cookie)

クラスター内のすべてのプロセスは、デフォルトではマスタープロセスでランダムに生成される同じクッキーを共有します。

  * [`cluster_cookie()`](@ref) はクッキーを返し、`cluster_cookie(cookie)()` はクッキーを設定して新しいクッキーを返します。
  * マスターが起動したワーカーだけが互いに接続できるよう、すべての接続で双方の認証が行われます。
  * 起動時に引数 `--worker=<cookie>` を使って、ワーカーにクッキーを渡せます。クッキーを指定せずに引数 `--worker` を指定した場合、ワーカーは標準入力（[`stdin`](@ref)）からクッキーを読み取ろうとします。クッキーを取得すると、`stdin` はすぐに閉じられます。
  * `ClusterManager` は、マスター上で [`cluster_cookie()`](@ref) を呼び出してクッキーを取得できます。デフォルトの TCP/IP 転送を使わないクラスター管理機構（したがって `--worker` を指定しないもの）は、マスターと同じクッキーを指定して `init_worker(cookie, manager)` を呼び出す必要があります。

より高いセキュリティが必要な環境では、独自の `ClusterManager` を実装して対応できます。たとえば、クッキーを事前に共有し、起動引数として指定しない方法があります。

## Specifying Network Topology (Experimental)

[`addprocs`](@ref) に渡すキーワード引数 `topology` は、ワーカー間の接続方法を指定します。

  * `:all_to_all`（デフォルト）: すべてのワーカーを互いに接続します。
  * `:master_worker`: ドライバープロセス、つまり `pid` 1 だけがワーカーに接続します。
  * `:custom`: クラスター管理機構の `launch` メソッドが、`WorkerConfig` のフィールド `ident` と `connect_idents` を使って接続トポロジーを指定します。クラスター管理機構が割り当てた ID `ident` を持つワーカーは、`connect_idents` で指定されたすべてのワーカーに接続します。

キーワード引数 `lazy=true|false` が影響するのは、`:all_to_all` オプションの `topology` だけです。`true` の場合、クラスターはマスターがすべてのワーカーに接続された状態で起動します。特定のワーカー間の接続は、2 つのワーカー間で最初のリモート呼び出しが行われたときに確立されます。これにより、クラスター内通信に必要な初期リソースを削減できます。接続は並列プログラムの実行時の要件に応じて確立されます。`lazy` のデフォルト値は `true` です。

現在、接続されていないワーカー間でメッセージを送信するとエラーになります。この動作は、機能やインターフェースと同様に実験的なものと見なすべきであり、今後のリリースで変更される可能性があります。

## Noteworthy external packages

Julia の並列処理以外にも、言及すべき外部パッケージが数多くあります。たとえば、[`MPI.jl`](https://github.com/JuliaParallel/MPI.jl) は `MPI` プロトコルの Julia ラッパー、[`Dagger.jl`](https://github.com/JuliaParallel/Dagger.jl) は Python の [Dask](https://dask.org/) に似た機能を提供し、[`DistributedArrays.jl`](https://github.com/JuliaParallel/Distributedarrays.jl) は [outlined above](@ref man-shared-arrays) のように、ワーカー間に分散した配列操作を提供します。

Julia の GPU プログラミングエコシステムにも触れておきましょう。次のものが含まれます。

1. [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) は各種 CUDA ライブラリをラップし、Nvidia GPU 向けの Julia カーネルのコンパイルをサポートします。
2. [oneAPI.jl](https://github.com/JuliaGPU/oneAPI.jl) は oneAPI 統合プログラミングモデルをラップし、対応するアクセラレーター上で Julia カーネルを実行できます。現在は Linux のみをサポートしています。
3. [AMDGPU.jl](https://github.com/JuliaGPU/AMDGPU.jl) は AMD ROCm ライブラリをラップし、AMD GPU 向けの Julia カーネルのコンパイルをサポートします。現在は Linux のみをサポートしています。
4. [KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl)、[Tullio.jl](https://github.com/mcabbott/Tullio.jl)、[ArrayFire.jl](https://github.com/JuliaComputing/ArrayFire.jl) などの高水準ライブラリ。

次の例では、`DistributedArrays.jl` と `CUDA.jl` の両方を使い、まず `distribute()` と `CuArray()` を介して配列を変換してから、複数のプロセスに分散します。

`DistributedArrays.jl` をインポートするときは、[`@everywhere`](@ref) を使ってすべてのプロセスにインポートすることを忘れないでください。

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

次の例では、`DistributedArrays.jl` と `CUDA.jl` の両方を使って配列を複数のプロセスに分散し、その配列に汎用関数を呼び出します。

```julia
function power_method(M, v)
    for i in 1:100
        v = M*v
        v /= norm(v)
    end

    return v, norm(M*v) / norm(v)  # or  (M*v) ./ v
end
```

`power_method` は新しいベクトルを繰り返し作成し、正規化します。関数宣言では型シグネチャを指定していません。先ほどのデータ型でも動作するか試してみましょう。

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

外部パッケージの紹介を締めくくるにあたり、MPI プロトコルの Julia ラッパーである `MPI.jl` を取り上げます。内部関数をすべて説明するには時間がかかりすぎるため、プロトコルの実装方法に注目するのがよいでしょう。

各サブプロセスを呼び出してランクを設定し、マスタープロセスに到達したらランクの合計を計算するだけの、簡単なスクリプトを考えてみましょう。

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

[^1]: ここでいう MPI は MPI-1 標準を指します。MPI-2 以降、MPI 標準化委員会は、総称してリモートメモリーアクセス（RMA）と呼ばれる新しい通信機構を導入しました。MPI 標準に RMA が追加されたのは、片方向通信パターンを実現しやすくするためです。最新の MPI 標準については、['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'-': ASCII/Unicode U+002D (category Pd: Punctuation, dash)'f': ASCII/Unicode U+0066 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'d': ASCII/Unicode U+0064 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)](https://mpi-forum.org/docs) を参照してください。
