# Multi-processing and Distributed Computing

モジュール [`Distributed`](@ref man-distributed) によって、分散メモリ並列計算の実装が提供されており、これはJuliaに付属する標準ライブラリの一部です。

ほとんどの現代のコンピュータは複数のCPUを持っており、いくつかのコンピュータをクラスターとして組み合わせることができます。これらの複数のCPUの力を活用することで、多くの計算をより迅速に完了させることができます。パフォーマンスに影響を与える主な要因は2つあります：CPU自体の速度と、メモリへのアクセス速度です。クラスターでは、特定のCPUが同じコンピュータ（ノード）内のRAMに最も速くアクセスできることは明らかです。おそらく驚くべきことに、一般的なマルチコアのラップトップでも、主メモリの速度と[cache](https://www.akkadia.org/drepper/cpumemory.pdf)の違いにより、同様の問題が関連しています。したがって、良好なマルチプロセッシング環境は、特定のCPUによるメモリのチャンクの「所有権」を制御できる必要があります。Juliaは、メッセージパッシングに基づいたマルチプロセッシング環境を提供し、プログラムが別々のメモリドメインで同時に複数のプロセスで実行できるようにします。

Juliaのメッセージパッシングの実装は、MPI[^1]などの他の環境とは異なります。Juliaにおける通信は一般的に「一方向」であり、つまりプログラマーは2つのプロセスの操作において明示的に管理する必要があるのは1つのプロセスだけです。さらに、これらの操作は通常「メッセージ送信」や「メッセージ受信」のようには見えず、むしろユーザー関数への呼び出しのような高レベルの操作に似ています。

Juliaにおける分散プログラミングは、*リモート参照*と*リモート呼び出し*の2つのプリミティブに基づいています。リモート参照は、特定のプロセスに保存されているオブジェクトを参照するために任意のプロセスから使用できるオブジェクトです。リモート呼び出しは、1つのプロセスが別の（場合によっては同じ）プロセス上の特定の引数で特定の関数を呼び出すように要求することです。

リモートリファレンスには2つの種類があります： [`Future`](@ref Distributed.Future) と [`RemoteChannel`](@ref)。

リモートコールは、[`Future`](@ref Distributed.Future)を結果として返します。リモートコールは即座に返され、コールを行ったプロセスはリモートコールがどこかで行われている間に次の操作に進みます。リモートコールが終了するのを待つには、返された`4d61726b646f776e2e436f64652822222c20224675747572652229_407265662044697374726962757465642e467574757265`に対して[`wait`](@ref)を呼び出すことができ、結果の完全な値を取得するには[`fetch`](@ref)を使用します。

一方で、[`RemoteChannel`](@ref) は書き換え可能です。例えば、複数のプロセスは同じリモート `Channel` を参照することで、その処理を調整することができます。

各プロセスには関連付けられた識別子があります。インタラクティブなJuliaプロンプトを提供するプロセスは常に`id`が1に等しくなります。デフォルトで並列操作に使用されるプロセスは「ワーカー」と呼ばれます。プロセスが1つだけの場合、プロセス1はワーカーと見なされます。それ以外の場合、ワーカーはプロセス1以外のすべてのプロセスと見なされます。その結果、[`pmap`](@ref)のような並列処理メソッドの利点を得るには、2つ以上のプロセスを追加する必要があります。長い計算がワーカーで実行されている間にメインプロセスで他の作業を行いたいだけの場合は、単一のプロセスを追加することが有益です。

`julia -p n` は、ローカルマシン上で `n` のワーカープロセスを提供します。一般的に、`n` はマシン上のCPUスレッド（論理コア）の数と等しくするのが理にかなっています。`-p` 引数は、モジュール [`Distributed`](@ref man-distributed) を暗黙的にロードすることに注意してください。

```julia
$ julia -p 2

julia> r = remotecall(rand, 2, 2, 2)
Future(2, 1, 4, nothing)

julia> s = @spawnat 2 1 .+ fetch(r)
Future(2, 1, 5, nothing)

julia> fetch(s)
2×2 Array{Float64,2}:
 1.18526  1.50912
 1.16296  1.60607
```

[`remotecall`](@ref)への最初の引数は呼び出す関数です。Juliaの並列プログラミングのほとんどは、特定のプロセスや利用可能なプロセスの数を参照しませんが、`4d61726b646f776e2e436f64652822222c202272656d6f746563616c6c2229_40726566`は、より細かい制御を提供する低レベルのインターフェースと見なされています。`4d61726b646f776e2e436f64652822222c202272656d6f746563616c6c2229_40726566`への2番目の引数は、作業を行うプロセスの`id`であり、残りの引数は呼び出される関数に渡されます。

最初の行でプロセス2に2x2のランダム行列を構築するように依頼し、2行目でそれに1を加えるように依頼したことがわかります。両方の計算の結果は、2つの未来、`r`と`s`で利用可能です。[`@spawnat`](@ref)マクロは、最初の引数で指定されたプロセスで2番目の引数の式を評価します。

時折、リモートで計算された値をすぐに取得したい場合があります。これは通常、次のローカル操作に必要なデータを取得するためにリモートオブジェクトから読み取るときに発生します。関数 [`remotecall_fetch`](@ref) はこの目的のために存在します。これは `fetch(remotecall(...))` と同等ですが、より効率的です。

```julia-repl
julia> remotecall_fetch(r-> fetch(r)[1, 1], 2, r)
0.18526337335308085
```

このコードはワーカー2で配列を取得し、最初の値を返します。注意すべきは、`fetch`はこの場合データを移動しないことです。なぜなら、配列を所有しているワーカーで実行されるからです。また、次のように書くこともできます：

```julia-repl
julia> remotecall_fetch(getindex, 2, r, 1, 1)
0.10824216411304866
```

[`getindex(r,1,1)`](@ref)は[equivalent](@ref man-array-indexing)から`r[1,1]`に変換されるので、この呼び出しは将来の`r`の最初の要素を取得します。

物事を簡単にするために、シンボル `:any` を [`@spawnat`](@ref) に渡すことができ、どこで操作を行うかを選択します：

```julia-repl
julia> r = @spawnat :any rand(2,2)
Future(2, 1, 4, nothing)

julia> s = @spawnat :any 1 .+ fetch(r)
Future(3, 1, 5, nothing)

julia> fetch(s)
2×2 Array{Float64,2}:
 1.38854  1.9098
 1.20939  1.57158
```

注意すべきは、`1 .+ fetch(r)`を`1 .+ r`の代わりに使用したことです。これは、コードがどこで実行されるかわからないため、一般的に[`fetch`](@ref)が`r`を加算を行うプロセスに移動させるために必要になる可能性があるからです。この場合、[`@spawnat`](@ref)は`r`を所有するプロセスで計算を実行するのに十分賢いので、`4d61726b646f776e2e436f64652822222c202266657463682229_40726566`はノーオペレーション（何も作業が行われない）になります。

（[`@spawnat`](@ref) は組み込みではなく、Juliaで [macro](@ref man-macros) として定義されています。このような構造を自分で定義することも可能です。）

重要なことは、一度取得されると、[`Future`](@ref Distributed.Future)がローカルにその値をキャッシュするということです。さらに[`fetch`](@ref)の呼び出しはネットワークホップを伴いません。すべての参照している`4d61726b646f776e2e436f64652822222c20224675747572652229_407265662044697374726962757465642e467574757265`が取得されると、リモートに保存された値は削除されます。

[`@async`](@ref) は [`@spawnat`](@ref) に似ていますが、ローカルプロセスでのみタスクを実行します。これを使用して、各プロセスの「フィーダー」タスクを作成します。各タスクは計算が必要な次のインデックスを取得し、そのプロセスが終了するのを待ってから、インデックスがなくなるまで繰り返します。フィーダータスクは、メインタスクが [`@sync`](@ref) ブロックの終わりに達するまで実行を開始しないことに注意してください。この時点で制御を放棄し、すべてのローカルタスクが完了するのを待ってから関数から戻ります。v0.7以降については、フィーダータスクはすべて同じプロセスで実行されるため、`nextidx` を介して状態を共有できます。`Tasks` が協調的にスケジュールされていても、[asynchronous I/O](@ref faq-async-io) のように、いくつかのコンテキストではロックが必要な場合があります。これは、コンテキストスイッチが明確に定義されたポイントでのみ発生することを意味します。この場合、[`remotecall_fetch`](@ref) が呼び出されるときです。これは現在の実装の状態であり、将来のJuliaバージョンで変更される可能性があります。これは、Nの`Tasks`をMの`Process`で実行できるようにすることを目的としています。つまり、[M:N Threading](https://en.wikipedia.org/wiki/Thread_(computing)#Models)。その後、`nextidx`のためのロック取得/解放モデルが必要になります。なぜなら、複数のプロセスが同時にリソースを読み書きすることは安全ではないからです。

## [Code Availability and Loading Packages](@id code-availability)

あなたのコードは、それを実行する任意のプロセスで利用可能でなければなりません。たとえば、次のようにJuliaプロンプトに入力します:

```julia-repl
julia> function rand2(dims...)
           return 2*rand(dims...)
       end

julia> rand2(2,2)
2×2 Array{Float64,2}:
 0.153756  0.368514
 1.15119   0.918912

julia> fetch(@spawnat :any rand2(2,2))
ERROR: RemoteException(2, CapturedException(UndefVarError(Symbol("#rand2"))))
Stacktrace:
[...]
```

プロセス1は関数`rand2`について知っていましたが、プロセス2は知りませんでした。

最も一般的には、ファイルやパッケージからコードを読み込むことになりますが、どのプロセスがコードを読み込むかを制御する際にかなりの柔軟性があります。次のコードを含むファイル `DummyModule.jl` を考えてみましょう：

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

`MyType`をすべてのプロセスで参照するためには、`DummyModule.jl`をすべてのプロセスでロードする必要があります。`include("DummyModule.jl")`を呼び出すと、単一のプロセスでのみロードされます。すべてのプロセスでロードするには、[`@everywhere`](@ref)マクロを使用します（`julia -p 2`でJuliaを起動します）：

```julia-repl
julia> @everywhere include("DummyModule.jl")
loaded
      From worker 3:    loaded
      From worker 2:    loaded
```

通常通り、これにより `DummyModule` はどのプロセスにもスコープに取り込まれません。これは [`using`](@ref) または [`import`](@ref) を必要とします。さらに、`DummyModule` が1つのプロセスでスコープに取り込まれると、他のプロセスではそうではありません：

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

しかし、スコープにない場合でも、`DummyModule`をロードしたプロセスに`MyType`を送信することは依然として可能です。

```julia-repl
julia> put!(RemoteChannel(2), MyType(7))
RemoteChannel{Channel{Any}}(2, 1, 13)
```

ファイルは、`-L` フラグを使用して、起動時に複数のプロセスでプリロードすることもでき、ドライバースクリプトを使用して計算を実行することができます：

```
julia -p <n> -L file1.jl -L file2.jl driver.jl
```

上記の例でドライバースクリプトを実行しているJuliaプロセスの`id`は1であり、インタラクティブプロンプトを提供するプロセスと同じです。

最後に、`DummyModule.jl` がスタンドアロンファイルではなくパッケージである場合、`using DummyModule` はすべてのプロセスで `DummyModule.jl` を*ロード*しますが、[`using`](@ref) が呼び出されたプロセスでのみスコープに持ち込みます。

## Starting and managing worker processes

ベースのJuliaインストールには、2種類のクラスターに対する組み込みサポートがあります：

  * 上記のように `-p` オプションで指定されたローカルクラスター。
  * `--machine-file`オプションを使用して、マシンにまたがるクラスターを構成します。これは、指定されたマシン上でJuliaワーカープロセスを開始するために、パスワードなしの`ssh`ログインを使用します（現在のホストと同じパスから）。各マシンの定義は、`[count*][user@]host[:port] [bind_addr[:port]]`の形式を取ります。`user`は現在のユーザーにデフォルト設定され、`port`は標準のsshポートに設定されます。`count`はノード上で生成するワーカーの数で、デフォルトは1です。オプションの`bind-to bind_addr[:port]`は、他のワーカーがこのワーカーに接続するために使用するIPアドレスとポートを指定します。

!!! note
    Juliaは一般的に後方互換性を重視していますが、ワーカープロセスへのコードの配布は[`Serialization.serialize`](@ref)に依存しています。該当するドキュメントで指摘されているように、これは異なるJuliaバージョン間で動作することが保証されていないため、すべてのマシンのすべてのワーカーが同じバージョンを使用することが推奨されています。


関数 [`addprocs`](@ref)、[`rmprocs`](@ref)、[`workers`](@ref) などは、クラスター内のプロセスを追加、削除、照会するためのプログラム的手段として利用可能です。

```julia-repl
julia> using Distributed

julia> addprocs(2)
2-element Array{Int64,1}:
 2
 3
```

モジュール [`Distributed`](@ref man-distributed) は、[`addprocs`](@ref) を呼び出す前にマスタープロセスで明示的にロードする必要があります。これはワーカープロセスで自動的に利用可能になります。

!!! note
    ワーカーは `~/.julia/config/startup.jl` スタートアップスクリプトを実行せず、他の実行中のプロセスとグローバルステート（コマンドラインスイッチ、グローバル変数、新しいメソッド定義、読み込まれたモジュールなど）を同期しません。特定の環境でワーカーを初期化するには `addprocs(exeflags="--project")` を使用し、その後 `@everywhere using <modulename>` または `@everywhere include("file.jl")` を使用できます。


他のタイプのクラスターは、以下の [ClusterManagers](@ref) セクションで説明されているように、独自のカスタム `ClusterManager` を作成することでサポートできます。

## Data Movement

メッセージの送信とデータの移動は、分散プログラムにおけるオーバーヘッドの大部分を占めます。メッセージの数と送信されるデータの量を減らすことは、パフォーマンスとスケーラビリティを達成するために重要です。この目的のために、Juliaのさまざまな分散プログラミング構造によって行われるデータの移動を理解することが重要です。

[`fetch`](@ref) は、オブジェクトをローカルマシンに移動するよう直接要求しているため、明示的なデータ移動操作と見なすことができます。[`@spawnat`](@ref)（およびいくつかの関連する構造体）もデータを移動しますが、これはそれほど明白ではないため、暗黙的なデータ移動操作と呼ぶことができます。ランダム行列を構築し、二乗するためのこれら2つのアプローチを考えてみましょう：

方法1:

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

違いは些細に見えますが、実際には [`@spawnat`](@ref) の動作により非常に重要です。最初の方法では、ランダム行列がローカルで構築され、その後別のプロセスに送信されて二乗されます。第二の方法では、ランダム行列が別のプロセスで構築され、二乗されます。したがって、第二の方法は最初の方法よりもはるかに少ないデータを送信します。

このおもちゃの例では、2つの方法は簡単に区別でき、選択することができます。しかし、実際のプログラムではデータの移動を設計するには、より多くの考慮が必要であり、測定が必要になることが多いです。たとえば、最初のプロセスが行列 `A` を必要とする場合、最初の方法がより良いかもしれません。また、`A` の計算が高価で、現在のプロセスだけがそれを持っている場合、別のプロセスに移動することは避けられないかもしれません。あるいは、現在のプロセスが [`@spawnat`](@ref) と `fetch(Bref)` の間に非常に少ししか作業がない場合、並列性を完全に排除する方が良いかもしれません。また、`rand(1000,1000)` がより高価な操作に置き換えられたと想像してみてください。この場合、このステップのために別の `4d61726b646f776e2e436f64652822222c202240737061776e61742229_40726566` ステートメントを追加することが理にかなっているかもしれません。

## Global variables

リモートで実行される式は [`@spawnat`](@ref) を介して、またはリモート実行のために指定されたクロージャは [`remotecall`](@ref) を介して、グローバル変数を参照することがあります。モジュール `Main` の下のグローバルバインディングは、他のモジュールのグローバルバインディングとは少し異なる扱いを受けます。次のコードスニペットを考えてみてください：

```julia-repl
A = rand(10,10)
remotecall_fetch(()->sum(A), 2)
```

この場合 [`sum`](@ref) はリモートプロセスで定義されている必要があります。`A` はローカルワークスペースで定義されたグローバル変数であることに注意してください。ワーカー2には `Main` の下に `A` という変数はありません。クロージャ `()->sum(A)` をワーカー2に送信する行為は、`Main.A` が2で定義されることを意味します。`Main.A` は、呼び出し [`remotecall_fetch`](@ref) が返された後もワーカー2に存在し続けます。埋め込まれたグローバル参照を持つリモート呼び出し（`Main` モジュールの下のみ）は、グローバルを次のように管理します：

  * 新しいグローバルバインディングは、リモートコールの一部として参照される場合、宛先ワーカー上に作成されます。
  * グローバル定数は、リモートノードでも定数として宣言されます。
  * グローバルは、リモートコールのコンテキスト内でのみ宛先ワーカーに再送信され、その値が変更された場合にのみ再送信されます。また、クラスターはノード間でグローバルバインディングを同期しません。例えば：

    ```julia
    A = rand(10,10)
    remotecall_fetch(()->sum(A), 2) # worker 2
    A = rand(10,10)
    remotecall_fetch(()->sum(A), 3) # worker 3
    A = nothing
    ```

    上記のスニペットを実行すると、ワーカー2の`Main.A`の値がワーカー3の`Main.A`の値と異なり、ノード1の`Main.A`の値は`nothing`に設定されます。

ご存知のように、グローバルに関連付けられたメモリは、マスターで再割り当てされると収集される場合がありますが、バインディングが有効であり続けるため、ワーカーではそのようなアクションは行われません。[`clear!`](@ref) を使用して、もはや必要ない場合にリモートノード上の特定のグローバルを `nothing` に手動で再割り当てすることができます。これにより、通常のガーベジコレクションサイクルの一部として、それに関連付けられたメモリが解放されます。

そのため、プログラムはリモート呼び出しでグローバル変数を参照する際に注意が必要です。実際、可能であればグローバル変数を完全に避けることが望ましいです。グローバル変数を参照する必要がある場合は、`let` ブロックを使用してグローバル変数をローカライズすることを検討してください。

例えば：

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

ご覧のとおり、グローバル変数 `A` はワーカー2で定義されていますが、`B` はローカル変数としてキャプチャされているため、ワーカー2には `B` のバインディングは存在しません。

## Parallel Map and Loops

幸いなことに、多くの有用な並列計算はデータの移動を必要としません。一般的な例はモンテカルロシミュレーションであり、複数のプロセスが独立したシミュレーショントライアルを同時に処理できます。[`@spawnat`](@ref)を使用して、2つのプロセスでコインを投げることができます。まず、次の関数を`count_heads.jl`に書いてください：

```julia
function count_heads(n)
    c::Int = 0
    for i = 1:n
        c += rand(Bool)
    end
    c
end
```

関数 `count_heads` は単に `n` のランダムビットを合計します。ここでは、2台のマシンでいくつかの試行を行い、結果を合計する方法を示します：

```julia-repl
julia> @everywhere include_string(Main, $(read("count_heads.jl", String)), "count_heads.jl")

julia> a = @spawnat :any count_heads(100000000)
Future(2, 1, 6, nothing)

julia> b = @spawnat :any count_heads(100000000)
Future(3, 1, 7, nothing)

julia> fetch(a)+fetch(b)
100001564
```

この例は、強力でよく使われる並列プログラミングパターンを示しています。多くの反復が複数のプロセスで独立して実行され、その結果がいくつかの関数を使用して結合されます。この結合プロセスは*リダクション*と呼ばれ、一般的にテンソルランクを減少させるためです：数のベクトルが単一の数に減少したり、行列が単一の行または列に減少したりします。コードでは、通常、`x = f(x,v[i])`というパターンのように見えます。ここで、`x`はアキュムレータ、`f`はリダクション関数、`v[i]`は減少される要素です。`f`が結合的であることが望ましいため、操作が実行される順序は重要ではありません。

このパターンを `count_heads` で使用することは一般化できます。私たちは明示的に [`@spawnat`](@ref) ステートメントを2つ使用しましたが、これにより並列性は2つのプロセスに制限されます。任意の数のプロセスで実行するには、分散メモリで実行される *並列 for ループ* を使用することができ、これはJuliaで [`@distributed`](@ref) のように書くことができます。

```julia
nheads = @distributed (+) for i = 1:200000000
    Int(rand(Bool))
end
```

この構造は、複数のプロセスに反復を割り当て、それらを指定された還元（この場合は `(+)`）で結合するパターンを実装しています。各反復の結果は、ループ内の最後の式の値として取られます。全体の並列ループ式自体は、最終的な答えを評価します。

並列forループは直列forループのように見えますが、その動作は大きく異なります。特に、イテレーションは指定された順序で行われず、変数や配列への書き込みは異なるプロセスで実行されるため、グローバルに可視化されません。並列ループ内で使用される変数は、各プロセスにコピーされてブロードキャストされます。

例えば、以下のコードは意図した通りには動作しません：

```julia
a = zeros(100000)
@distributed for i = 1:100000
    a[i] = i
end
```

このコードは `a` のすべてを初期化しません。なぜなら、各プロセスはそれぞれのコピーを持つからです。このような並列forループは避けるべきです。幸いなことに、 [Shared Arrays](@ref man-shared-arrays) を使用することでこの制限を回避できます：

```julia
using SharedArrays

a = SharedArray{Float64}(10)
@distributed for i = 1:10
    a[i] = i
end
```

外部変数を並列ループで使用することは、変数が読み取り専用である場合は完全に合理的です。

```julia
a = randn(1000)
@distributed (+) for i = 1:100000
    f(a[rand(1:end)])
end
```

ここでは、各イテレーションでプロセス全体で共有されるベクトル `a` からランダムに選ばれたサンプルに `f` を適用します。

ご覧のとおり、削減演算子は必要ない場合は省略できます。その場合、ループは非同期に実行され、すなわち、すべての利用可能なワーカーで独立したタスクを生成し、完了を待たずに [`Future`](@ref Distributed.Future) の配列を即座に返します。呼び出し元は、後で `4d61726b646f776e2e436f64652822222c20224675747572652229_407265662044697374726962757465642e467574757265` の完了を待つために [`fetch`](@ref) を呼び出すか、ループの最後で [`@sync`](@ref) で接頭辞を付けて完了を待つことができます。例えば、`@sync @distributed for` のように。

場合によっては、削減演算子は必要なく、単に特定の範囲内のすべての整数（または、より一般的には、コレクション内のすべての要素）に関数を適用したいだけです。これは、*並列マップ*と呼ばれる別の便利な操作で、Juliaでは[`pmap`](@ref)関数として実装されています。たとえば、次のようにして、いくつかの大きなランダム行列の特異値を並列に計算することができます。

```julia-repl
julia> M = Matrix{Float64}[rand(1000,1000) for i = 1:10];

julia> pmap(svdvals, M);
```

Juliaの [`pmap`](@ref) は、各関数呼び出しが大量の作業を行う場合に設計されています。それに対して、`@distributed for` は、各イテレーションが非常に小さい場合、例えば単に2つの数を合計する場合に対応できます。並列計算には、`4d61726b646f776e2e436f64652822222c2022706d61702229_40726566` と `@distributed for` の両方でワーカープロセスのみが使用されます。`@distributed for` の場合、最終的な還元は呼び出しプロセスで行われます。

## Remote References and AbstractChannels

リモート参照は常に `AbstractChannel` の実装を指します。

`AbstractChannel`（例えば`Channel`）の具体的な実装は、[`put!`](@ref)、[`take!`](@ref)、[`fetch`](@ref)、[`isready`](@ref)、および[`wait`](@ref)を実装する必要があります。[`Future`](@ref Distributed.Future)によって参照されるリモートオブジェクトは、`Channel{Any}(1)`、すなわち`Any`型のオブジェクトを保持できるサイズ1の`Channel`に格納されています。

[`RemoteChannel`](@ref)は、書き換え可能で、任意のタイプとサイズのチャネル、または他の`AbstractChannel`の実装を指すことができます。

コンストラクタ `RemoteChannel(f::Function, pid)()` は、特定の型の複数の値を保持するチャネルへの参照を構築することを可能にします。`f` は `pid` 上で実行される関数であり、`AbstractChannel` を返さなければなりません。

例えば、`RemoteChannel(()->Channel{Int}(10), pid)`は、型`Int`でサイズ10のチャネルへの参照を返します。このチャネルはワーカー`pid`に存在します。

メソッド [`put!`](@ref)、[`take!`](@ref)、[`fetch`](@ref)、[`isready`](@ref) および [`wait`](@ref) は、[`RemoteChannel`](@ref) 上で、リモートプロセスのバックストアにプロキシされています。

[`RemoteChannel`](@ref) は、ユーザーが実装した `AbstractChannel` オブジェクトを参照するために使用できます。これの簡単な例が、辞書をリモートストアとして使用する以下の `DictChannel` です：

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

  * [`Channel`](@ref) はプロセスにローカルです。ワーカー2はワーカー3の `4d61726b646f776e2e436f64652822222c20224368616e6e656c2229_40726566` を直接参照することはできず、その逆も同様です。しかし、 [`RemoteChannel`](@ref) は、ワーカー間で値を置いたり取得したりすることができます。
  * [`RemoteChannel`](@ref) は [`Channel`](@ref) への *ハンドル* と考えることができます。
  * The process id, `pid`, associated with a [`RemoteChannel`](@ref) identifies the process where the backing store, i.e., the backing [`Channel`](@ref) exists.
  * [`RemoteChannel`](@ref) に参照されるプロセスは、チャンネルからアイテムを出し入れできます。データは、自動的に `4d61726b646f776e2e436f64652822222c202252656d6f74654368616e6e656c2229_40726566` に関連付けられたプロセスに送信されるか、またはそこから取得されます。
  * [`Channel`](@ref)をシリアライズすると、チャネル内に存在するデータもシリアライズされます。したがって、デシリアライズすることは実質的に元のオブジェクトのコピーを作成することになります。
  * 一方で、[`RemoteChannel`](@ref)をシリアライズすることは、ハンドルによって参照される[`Channel`](@ref)の位置とインスタンスを識別する識別子のシリアライズのみを含みます。したがって、デシリアライズされた`4d61726b646f776e2e436f64652822222c202252656d6f74654368616e6e656c2229_40726566`オブジェクト（任意のワーカー上）は、元のものと同じバックストアを指します。

上記のチャネルの例は、以下のようにプロセス間通信のために修正できます。

私たちは、単一の `jobs` リモートチャネルを処理するために4人のワーカーを起動します。ジョブは、ID（`job_id`）によって識別され、チャネルに書き込まれます。このシミュレーション内の各リモート実行タスクは、`job_id` を読み取り、ランダムな時間待機し、`job_id`、かかった時間、および自分の `pid` のタプルを結果チャネルに書き戻します。最後に、すべての `results` がマスタープロセスで出力されます。

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

julia> errormonitor(@async make_jobs(n)); # feed the jobs channel with "n" jobs

julia> for p in workers() # start tasks on the workers to process requests in parallel
           remote_do(do_work, p, jobs, results)
       end

julia> @elapsed while n > 0 # print out results
           job_id, exec_time, where = take!(results)
           println("$job_id finished in $(round(exec_time; digits=2)) seconds on worker $where")
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

リモート参照によって参照されるオブジェクトは、*すべての* クラスター内の保持されている参照が削除されたときにのみ解放されることができます。

値が保存されているノードは、それに対する参照を持つワーカーを追跡します。[`RemoteChannel`](@ref) または (未取得の) [`Future`](@ref Distributed.Future) がワーカーにシリアライズされるたびに、参照が指すノードが通知されます。また、`4d61726b646f776e2e436f64652822222c202252656d6f74654368616e6e656c2229_40726566` または (未取得の) `4d61726b646f776e2e436f64652822222c20224675747572652229_407265662044697374726962757465642e467574757265` がローカルでガーベジコレクトされるたびに、値を所有するノードが再び通知されます。これは、内部のクラスタ対応シリアライザーで実装されています。リモート参照は、実行中のクラスタのコンテキスト内でのみ有効です。通常の `IO` オブジェクトへの参照のシリアライズおよびデシリアライズはサポートされていません。

通知は「トラッキング」メッセージの送信を通じて行われます。参照が別のプロセスにシリアライズされるときに「参照を追加」メッセージが送信され、参照がローカルでガーベジコレクトされるときに「参照を削除」メッセージが送信されます。

[`Future`](@ref Distributed.Future)は一度書き込み可能でローカルにキャッシュされるため、[`fetch`](@ref)する行為は、値を所有するノードの参照追跡情報も更新します。

その値を所有するノードは、それに対するすべての参照がクリアされると、その値を解放します。

[`Future`](@ref Distributed.Future)を使用して、すでに取得された`4d61726b646f776e2e436f64652822222c20224675747572652229_407265662044697374726962757465642e467574757265`を別のノードにシリアライズすると、元のリモートストアがこの時点で値を収集している可能性があるため、値も送信されます。

オブジェクトがローカルでガーベジコレクトされる*タイミング*は、オブジェクトのサイズとシステムの現在のメモリ圧力に依存することに注意することが重要です。

リモート参照の場合、ローカル参照オブジェクトのサイズは非常に小さいですが、リモートノードに保存されている値は非常に大きい場合があります。ローカルオブジェクトがすぐに収集されない可能性があるため、[`finalize`](@ref)をローカルインスタンスの[`RemoteChannel`](@ref)や、フェッチされていない[`Future`](@ref Distributed.Future)に対して明示的に呼び出すことは良い習慣です。[`fetch`](@ref)を`4d61726b646f776e2e436f64652822222c20224675747572652229_407265662044697374726962757465642e467574757265`に対して呼び出すことは、リモートストアからその参照を削除することにもなるため、フェッチされた`4d61726b646f776e2e436f64652822222c20224675747572652229_407265662044697374726962757465642e467574757265`に対しては必要ありません。`4d61726b646f776e2e436f64652822222c202266696e616c697a652229_40726566`を明示的に呼び出すと、リモートノードに対してその値への参照を削除するように即座にメッセージが送信されます。

一旦確定されると、参照は無効になり、今後の呼び出しで使用することはできません。

## Local invocations

データは実行のためにリモートノードに必ずコピーされます。これは、リモートコールの場合と、データが異なるノードの [`RemoteChannel`](@ref) / [`Future`](@ref Distributed.Future) に保存される場合の両方に当てはまります。予想通り、これによりリモートノード上にシリアライズされたオブジェクトのコピーが生成されます。しかし、宛先ノードがローカルノード、すなわち呼び出しプロセスIDがリモートノードIDと同じである場合、これはローカルコールとして実行されます。通常（常にではありませんが）、異なるタスクで実行されますが、データのシリアライズ/デシリアライズは行われません。その結果、呼び出しは渡された同じオブジェクトインスタンスを参照します - コピーは作成されません。この動作は以下に示されています：

```julia-repl
julia> using Distributed;

julia> rc = RemoteChannel(()->Channel(3));   # RemoteChannel created on local node

julia> v = [0];

julia> for i in 1:3
           v[1] = i                          # Reusing `v`
           put!(rc, v)
       end;

julia> result = [take!(rc) for _ in 1:3];

julia> println(result);
Array{Int64,1}[[3], [3], [3]]

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
Array{Int64,1}[[1], [2], [3]]

julia> println("Num Unique objects : ", length(unique(map(objectid, result))));
Num Unique objects : 3
```

見ての通り、[`put!`](@ref) は、同じオブジェクト `v` が呼び出し間で変更されたローカル所有の [`RemoteChannel`](@ref) で、保存される単一のオブジェクトインスタンスを結果として得ます。これは、`rc` を所有するノードが異なるノードである場合に `v` のコピーが作成されるのとは対照的です。

一般的にこれは問題ではないことに注意する必要があります。これは、オブジェクトがローカルに保存され、呼び出し後に変更される場合にのみ考慮すべきものです。そのような場合には、オブジェクトの`deepcopy`を保存することが適切かもしれません。

これは、次の例に示すように、ローカルノードでのリモートコールにも当てはまります。

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

再び見られるように、ローカルノードへのリモート呼び出しは、直接の呼び出しとまったく同じように動作します。この呼び出しは、引数として渡されたローカルオブジェクトを変更します。リモート呼び出しでは、引数のコピーに対して操作を行います。

一般的に、これは問題ではありません。ローカルノードが計算ノードとしても使用されている場合、呼び出し後に使用される引数を考慮する必要があり、必要に応じて引数のディープコピーをローカルノードで呼び出される関数に渡さなければなりません。リモートノードでの呼び出しは常に引数のコピーで操作されます。

## [Shared Arrays](@id man-shared-arrays)

共有配列は、システムの共有メモリを使用して、複数のプロセス間で同じ配列をマッピングします。[`SharedArray`](@ref) は、同じマシン上で2つ以上のプロセスが共同でアクセスできる大量のデータを持ちたい場合に適した選択肢です。共有配列のサポートは、モジュール `SharedArrays` を介して利用可能であり、すべての参加ワーカーで明示的にロードする必要があります。

補完的なデータ構造は、外部パッケージ [`DistributedArrays.jl`](https://github.com/JuliaParallel/DistributedArrays.jl) によって `DArray` の形で提供されています。 [`SharedArray`](@ref) との類似点はあるものの、 [`DArray`](https://github.com/JuliaParallel/DistributedArrays.jl) の動作はかなり異なります。 `4d61726b646f776e2e436f64652822222c202253686172656441727261792229_40726566` では、各「参加」プロセスが全体の配列にアクセスできますが、対照的に `4d61726b646f776e2e436f64652822222c20224441727261792229_68747470733a2f2f6769746875622e636f6d2f4a756c6961506172616c6c656c2f44697374726962757465644172726179732e6a6c` では、各プロセスがデータの一部にのみローカルアクセスを持ち、2つのプロセスが同じチャンクを共有することはありません。

[`SharedArray`](@ref) のインデクシング（値の割り当てとアクセス）は、通常の配列と同様に機能し、基盤となるメモリがローカルプロセスに利用可能であるため効率的です。したがって、ほとんどのアルゴリズムは `4d61726b646f776e2e436f64652822222c202253686172656441727261792229_40726566` で自然に動作しますが、単一プロセスモードで動作します。アルゴリズムが [`Array`](@ref) 入力を要求する場合、基盤となる配列は `4d61726b646f776e2e436f64652822222c202253686172656441727261792229_40726566` から [`sdata`](@ref) を呼び出すことで取得できます。他の `AbstractArray` タイプの場合、`4d61726b646f776e2e436f64652822222c202273646174612229_40726566` はオブジェクト自体を返すだけなので、任意の `Array` タイプのオブジェクトに対して `4d61726b646f776e2e436f64652822222c202273646174612229_40726566` を使用するのは安全です。

共有配列のコンストラクタは次の形式です：

```julia
SharedArray{T,N}(dims::NTuple; init=false, pids=Int[])
```

`N`次元のビット型 `T` の共有配列を、指定されたプロセス `pids` にわたって作成します。分散配列とは異なり、共有配列は `pids` 引数で指定された参加ワーカーからのみアクセス可能です（作成プロセスも同じホスト上にある場合）。共有配列では、[`isbits`](@ref) の要素のみがサポートされていることに注意してください。

`init`関数が`initfn(S::SharedArray)`というシグネチャで指定されている場合、それはすべての参加ワーカーで呼び出されます。各ワーカーが配列の異なる部分で`init`関数を実行するように指定することで、初期化を並列化することができます。

ここに簡単な例があります：

```julia-repl
julia> using Distributed

julia> addprocs(3)
3-element Array{Int64,1}:
 2
 3
 4

julia> @everywhere using SharedArrays

julia> S = SharedArray{Int,2}((3,4), init = S -> S[localindices(S)] = repeat([myid()], length(localindices(S))))
3×4 SharedArray{Int64,2}:
 2  2  3  4
 2  3  3  4
 2  3  4  4

julia> S[3,2] = 7
7

julia> S
3×4 SharedArray{Int64,2}:
 2  2  3  4
 2  3  3  4
 2  7  4  4
```

[`SharedArrays.localindices`](@ref) は、インデックスの離散的な一次元範囲を提供し、プロセス間でタスクを分割するのに便利なことがあります。もちろん、作業を分割する方法は自由です:

```julia-repl
julia> S = SharedArray{Int,2}((3,4), init = S -> S[indexpids(S):length(procs(S)):length(S)] = repeat([myid()], length( indexpids(S):length(procs(S)):length(S))))
3×4 SharedArray{Int64,2}:
 2  2  2  2
 3  3  3  3
 4  4  4  4
```

すべてのプロセスが基盤となるデータにアクセスできるため、競合が発生しないように注意する必要があります。例えば：

```julia
@sync begin
    for p in procs(S)
        @async begin
            remotecall_wait(fill!, p, S, p)
        end
    end
end
```

未定義の動作が発生します。各プロセスは自分の `pid` で *全体* の配列を埋めるため、`S` の特定の要素に対して最後に実行されるプロセスがその `pid` を保持します。

より長く複雑な例として、次の「カーネル」を並行して実行することを考えてみてください：

```julia
q[i,j,t+1] = q[i,j,t] + u[i,j,t]
```

この場合、1次元インデックスを使用して作業を分割しようとすると、問題が発生する可能性があります。もし `q[i,j,t]` が1人の作業者に割り当てられたブロックの終わり近くにあり、`q[i,j,t+1]` が別の作業者に割り当てられたブロックの始まり近くにある場合、`q[i,j,t]` が `q[i,j,t+1]` の計算に必要な時点で準備が整っていない可能性が非常に高いです。このような場合、配列を手動でチャンク化する方が良いでしょう。2次元目に沿って分割しましょう。この作業者に割り当てられた `(irange, jrange)` インデックスを返す関数を定義します：

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

次に、カーネルを定義します：

```julia-repl
julia> @everywhere function advection_chunk!(q, u, irange, jrange, trange)
           @show (irange, jrange, trange)  # display so we can see what's happening
           for t in trange, j in jrange, i in irange
               q[i,j,t+1] = q[i,j,t] + u[i,j,t]
           end
           q
       end
```

`SharedArray` 実装のための便利なラッパーも定義します。

```julia-repl
julia> @everywhere advection_shared_chunk!(q, u) =
           advection_chunk!(q, u, myrange(q)..., 1:size(q,3)-1)
```

では、単一プロセスで実行される3つの異なるバージョンを比較してみましょう。

```julia-repl
julia> advection_serial!(q, u) = advection_chunk!(q, u, 1:size(q,1), 1:size(q,2), 1:size(q,3)-1);
```

[`@distributed`](@ref)を使用するもの:

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

そして、チャンクで委任するもの：

```julia-repl
julia> function advection_shared!(q, u)
           @sync begin
               for p in procs(q)
                   @async remotecall_wait(advection_shared_chunk!, p, q, u)
               end
           end
           q
       end;
```

`SharedArray`を作成し、これらの関数の時間を計測すると、次の結果が得られます（`julia -p 4`を使用）：

```julia-repl
julia> q = SharedArray{Float64,3}((500,500,500));

julia> u = SharedArray{Float64,3}((500,500,500));
```

関数を一度実行してJITコンパイルし、[`@time`](@ref)を二回目の実行で行います:

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

`advection_shared!` の最大の利点は、ワーカー間のトラフィックを最小限に抑え、各ワーカーが割り当てられた部分で長時間計算を行えるようにすることです。

### Shared Arrays and Distributed Garbage Collection

リモート参照と同様に、共有配列も、すべての参加ワーカーからの参照を解放するために作成ノードのガーベジコレクションに依存しています。多くの短命の共有配列オブジェクトを作成するコードは、これらのオブジェクトをできるだけ早く明示的に最終化することで利益を得るでしょう。これにより、共有セグメントをマッピングするメモリとファイルハンドルが早く解放されます。

## ClusterManagers

Juliaプロセスの起動、管理、およびネットワーキングを論理クラスターに統合するのは、クラスター管理者によって行われます。`ClusterManager`は以下の責任を持っています。

  * クラスタ環境でのワーカープロセスの起動
  * 各ワーカーのライフサイクル中のイベント管理
  * オプションでデータ転送を提供する

ジュリアクラスタには以下の特徴があります：

  * 初期のJuliaプロセスは、`master`とも呼ばれ、特別であり、`id`は1です。
  * `master` プロセスのみがワーカープロセスを追加または削除できます。
  * すべてのプロセスは互いに直接通信できます。

ワーカー間の接続（組み込みのTCP/IPトランスポートを使用）は、以下の方法で確立されます：

  * [`addprocs`](@ref) は、`ClusterManager` オブジェクトを使用してマスタープロセスで呼び出されます。
  * [`addprocs`](@ref) は、適切な [`launch`](@ref) メソッドを呼び出し、適切なマシン上で必要な数のワーカープロセスを生成します。
  * 各ワーカーは空いているポートでリスニングを開始し、そのホストとポート情報を [`stdout`](@ref) に書き出します。
  * クラスター管理者は、各ワーカーの [`stdout`](@ref) をキャプチャし、それをマスタープロセスに利用可能にします。
  * マスタープロセスはこの情報を解析し、各ワーカーへのTCP/IP接続を設定します。
  * すべてのワーカーは、クラスター内の他のワーカーについても通知されます。
  * 各ワーカーは、自分の`id`よりも小さい`id`を持つすべてのワーカーに接続します。
  * このようにしてメッシュネットワークが確立され、すべての作業者が他のすべての作業者と直接接続されます。

デフォルトのトランスポート層はプレーンな [`TCPSocket`](@ref) を使用しますが、Julia クラスターが独自のトランスポートを提供することも可能です。

Juliaは2つの組み込みクラスターマネージャーを提供しています：

  * `LocalManager`は、[`addprocs()`](@ref)または[`addprocs(np::Integer)`](@ref)が呼び出されたときに使用されます。
  * `SSHManager`は、[`addprocs(hostnames::Array)`](@ref)がホスト名のリストで呼び出されたときに使用されます。

`LocalManager`は、同じホスト上で追加のワーカーを起動するために使用され、マルチコアおよびマルチプロセッサハードウェアを活用します。

したがって、最小限のクラスター管理者は次のことが必要です：

  * 抽象 `ClusterManager` のサブタイプである
  * [`launch`](@ref)を実装し、新しいワーカーを起動する責任を持つメソッドを作成します。
  * [`manage`](@ref)を実装します。これは、ワーカーのライフタイム中のさまざまなイベント（例えば、割り込み信号の送信）で呼び出されます。

[`addprocs(manager::FooManager)`](@ref addprocs) は `FooManager` が実装する必要があります:

```julia
function launch(manager::FooManager, params::Dict, launched::Array, c::Condition)
    [...]
end

function manage(manager::FooManager, id::Integer, config::WorkerConfig, op::Symbol)
    [...]
end
```

例として、同じホスト上でワーカーを起動する責任を持つ `LocalManager` がどのように実装されているかを見てみましょう：

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

[`launch`](@ref) メソッドは、以下の引数を取ります：

  * `manager::ClusterManager`: [`addprocs`](@ref) が呼び出されるクラスター マネージャーです。
  * `params::Dict`: [`addprocs`](@ref) に渡されたすべてのキーワード引数
  * `launched::Array`: 1つ以上の `WorkerConfig` オブジェクトを追加する配列
  * `c::Condition`: ワーカーが起動されるときに通知される条件変数

[`launch`](@ref) メソッドは、別のタスクで非同期に呼び出されます。このタスクの終了は、すべての要求されたワーカーが起動されたことを示します。したがって、`4d61726b646f776e2e436f64652822222c20226c61756e63682229_40726566` 関数は、すべての要求されたワーカーが起動されたら、すぐに終了しなければなりません。

新しく起動されたワーカーは、全てのワーカーとマスタープロセスに相互接続されます。コマンドライン引数 `--worker[=<cookie>]` を指定すると、起動されたプロセスはワーカーとして初期化され、TCP/IPソケットを介して接続が設定されます。

クラスター内のすべてのワーカーは、マスターと同じ [cookie](@ref man-cluster-cookie) を共有します。クッキーが指定されていない場合、つまり `--worker` オプションを使用している場合、ワーカーは標準入力からそれを読み取ろうとします。 `LocalManager` と `SSHManager` はどちらも、標準入力を介して新しく起動されたワーカーにクッキーを渡します。

デフォルトでは、ワーカーは [`getipaddr()`](@ref) への呼び出しで返されるアドレスの空いているポートでリッスンします。リッスンする特定のアドレスは、オプション引数 `--bind-to bind_addr[:port]` で指定できます。これはマルチホーミングホストに便利です。

非TCP/IPトランスポートの例として、実装はMPIを使用することを選択する場合があり、その場合は`--worker`を指定してはいけません。代わりに、新しく起動されたワーカーは、並列構造を使用する前に`init_worker(cookie)`を呼び出す必要があります。

すべてのワーカーが起動されるたびに、[`launch`](@ref) メソッドは、`launched` に適切なフィールドが初期化された `WorkerConfig` オブジェクトを追加しなければなりません。

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

`WorkerConfig`のほとんどのフィールドは、組み込みのマネージャーによって使用されます。カスタムクラスター マネージャーは通常、`io`または`host` / `port`のみを指定します:

  * `io`が指定されている場合、ホスト/ポート情報を読み取るために使用されます。Juliaワーカーは、起動時にそのバインドアドレスとポートを出力します。これにより、Juliaワーカーは手動でワーカーポートを設定する必要なく、利用可能な任意の空いているポートでリッスンできるようになります。
  * `io`が指定されていない場合、`host`と`port`が接続に使用されます。
  * `count`、`exename`、および `exeflags` は、ワーカーから追加のワーカーを起動する際に関連します。たとえば、クラスター管理者はノードごとに単一のワーカーを起動し、それを使用して追加のワーカーを起動することがあります。

      * `count` の整数値 `n` は、合計 `n` のワーカーを起動します。
      * `count` の値が `:auto` の場合、そのマシンの CPU スレッド（論理コア）の数と同じだけのワーカーが起動します。
      * `exename` は、フルパスを含む `julia` 実行可能ファイルの名前です。
      * `exeflags` は新しいワーカーのために必要なコマンドライン引数に設定する必要があります。
  * `tunnel`、`bind_addr`、`sshflags` および `max_parallel` は、マスタープロセスからワーカーに接続するために SSH トンネルが必要な場合に使用されます。
  * `userdata` は、カスタムクラスター マネージャーが独自のワーカー固有の情報を保存するために提供されています。

`manage(manager::FooManager, id::Integer, config::WorkerConfig, op::Symbol)` は、ワーカーのライフタイム中に適切な `op` 値で異なるタイミングで呼び出されます：

  * `:register` / `:deregister` を使用して、ワーカーがJuliaワーカープールに追加または削除されるとき。
  * `interrupt(workers)`が呼び出されるときに`:interrupt`を使用します。`ClusterManager`は、適切なワーカーに中断信号を送信する必要があります。
  * `:finalize`をクリーンアップ目的で使用します。

### Cluster Managers with Custom Transports

デフォルトのTCP/IPの全対全ソケット接続をカスタムトランスポート層に置き換えるのは、少し手間がかかります。各Juliaプロセスは、接続されているワーカーの数だけ通信タスクを持っています。たとえば、全対全メッシュネットワークの32プロセスからなるJuliaクラスターを考えてみましょう：

  * 各Juliaプロセスには、したがって31の通信タスクがあります。
  * 各タスクは、メッセージ処理ループ内で単一のリモートワーカーからのすべての受信メッセージを処理します。
  * メッセージ処理ループは、`IO`オブジェクト（例えば、デフォルト実装の[`TCPSocket`](@ref)）で待機し、メッセージ全体を読み取り、それを処理し、次のメッセージを待ちます。
  * プロセスへのメッセージの送信は、適切な `IO` オブジェクトを介して、通信タスクだけでなく、任意のJuliaタスクから直接行われます。

デフォルトのトランスポートを置き換えるには、新しい実装がリモートワーカーへの接続を設定し、メッセージ処理ループが待機できる適切な `IO` オブジェクトを提供する必要があります。実装すべきマネージャー固有のコールバックは次のとおりです：

```julia
connect(manager::FooManager, pid::Integer, config::WorkerConfig)
kill(manager::FooManager, pid::Int, config::WorkerConfig)
```

デフォルトの実装（TCP/IPソケットを使用）は、`connect(manager::ClusterManager, pid::Integer, config::WorkerConfig)`として実装されています。

`connect` は、ワーカー `pid` から送信されたデータを読み取るための `IO` オブジェクトと、ワーカー `pid` に送信する必要があるデータを書き込むための `IO` オブジェクトのペアを返す必要があります。カスタムクラスターマネージャは、カスタムの、場合によっては非 `IO` トランスポートとJuliaの組み込み並列インフラストラクチャの間でデータをプロキシするために、メモリ内の `BufferStream` を使用できます。

`BufferStream`は、メモリ内の[`IOBuffer`](@ref)であり、`IO`のように振る舞います。これは、非同期に処理できるストリームです。

フォルダー `clustermanager/0mq` は、[Examples repository](https://github.com/JuliaAttic/Examples) にあり、ZeroMQを使用してジュリアワーカーを星型トポロジーで接続し、中央に0MQブローカーを配置する例が含まれています。注意: ジュリアプロセスはすべて*論理的に*互いに接続されており、任意のワーカーは他のワーカーに直接メッセージを送信でき、0MQがトランスポート層として使用されていることを意識する必要はありません。

カスタムトランスポートを使用する場合：

  * Julia ワーカーは `--worker` で起動してはいけません。`--worker` で起動すると、新しく起動したワーカーはデフォルトで TCP/IP ソケットトランスポート実装になります。
  * すべてのワーカーとの論理接続が行われるたびに、`Base.process_messages(rd::IO, wr::IO)()`を呼び出さなければなりません。これにより、`IO`オブジェクトで表されるワーカーからのメッセージの読み取りと書き込みを処理する新しいタスクが開始されます。
  * `init_worker(cookie, manager::FooManager)` *は* ワーカープロセスの初期化の一部として呼び出される *必要があります*。
  * フィールド `connect_at::Any` は、`WorkerConfig` 内で、[`launch`](@ref) が呼び出されるときにクラスターマネージャーによって設定されることがあります。このフィールドの値は、すべての [`connect`](@ref) コールバックに渡されます。通常、このフィールドは *ワーカーへの接続方法* に関する情報を持っています。例えば、TCP/IP ソケットトランスポートは、このフィールドを使用してワーカーに接続するための `(host, port)` タプルを指定します。

`kill(manager, pid, config)` は、クラスターからワーカーを削除するために呼び出されます。マスタープロセスでは、適切なクリーンアップを確保するために、対応する `IO` オブジェクトが実装によって閉じられなければなりません。デフォルトの実装は、指定されたリモートワーカーに対して単に `exit()` コールを実行します。

Examplesフォルダの`clustermanager/simple`は、クラスタ設定のためにUNIXドメインソケットを使用したシンプルな実装を示す例です。

### Network Requirements for LocalManager and SSHManager

Juliaクラスタは、ローカルのラップトップ、部門のクラスター、またはクラウドなどの既にセキュリティが確保された環境で実行されるように設計されています。このセクションでは、組み込みの`LocalManager`および`SSHManager`のネットワークセキュリティ要件について説明します。

  * マスタープロセスはポートをリッスンしません。ワーカーに接続するだけです。
  * 各ワーカーはローカルインターフェースの1つにのみバインドし、OSによって割り当てられたエフェメラルポート番号でリッスンします。
  * `LocalManager`は、デフォルトで`addprocs(N)`によってループバックインターフェースにのみバインドされます。これは、後でリモートホスト上で開始されたワーカー（または悪意のある意図を持つ誰か）がクラスターに接続できないことを意味します。`addprocs(4)`の後に`addprocs(["remote_host"])`を実行すると失敗します。一部のユーザーは、ローカルシステムといくつかのリモートシステムからなるクラスターを作成する必要があるかもしれません。これは、`restrict`キーワード引数を介して`LocalManager`に外部ネットワークインターフェースにバインドするよう明示的に要求することで実行できます：`addprocs(4; restrict=false)`。
  * `SSHManager`は、`addprocs(list_of_remote_hosts)`によってリモートホスト上でワーカーをSSH経由で起動します。デフォルトでは、SSHはJuliaワーカーを起動するためにのみ使用されます。その後のマスター-ワーカーおよびワーカー-ワーカーの接続は、平文の暗号化されていないTCP/IPソケットを使用します。リモートホストにはパスワードなしのログインが有効である必要があります。追加のSSHフラグや資格情報は、キーワード引数`sshflags`を介して指定できます。
  * `addprocs(list_of_remote_hosts; tunnel=true, sshflags=<ssh keys and other flags>)` は、マスター-ワーカーのためにSSH接続を使用したい場合に便利です。典型的なシナリオは、ローカルのラップトップでJulia REPL（つまり、マスター）を実行し、クラスタの残りがクラウド上、例えばAmazon EC2にある場合です。この場合、リモートクラスタではポート22のみを開く必要があり、SSHクライアントは公開鍵基盤（PKI）を介して認証されます。認証情報は `sshflags` を介して提供できます。例えば ```sshflags=`-i <keyfile>` ```.

    全対全トポロジー（デフォルト）では、すべてのワーカーがプレーンTCPソケットを介して互いに接続します。したがって、クラスターのノード上のセキュリティポリシーは、一時ポート範囲（OSによって異なる）に対してワーカー間の自由な接続を確保する必要があります。

    すべてのワーカー間のトラフィックを保護し暗号化する（SSHを介して）か、個々のメッセージを暗号化することは、カスタム `ClusterManager` を介して行うことができます。
  * `multiplex=true`をオプションとして指定すると、[`addprocs`](@ref)ではSSHマルチプレクシングが使用され、マスターとワーカー間にトンネルが作成されます。自分でSSHマルチプレクシングを設定しており、接続がすでに確立されている場合は、`multiplex`オプションに関係なくSSHマルチプレクシングが使用されます。マルチプレクシングが有効になっている場合、転送は既存の接続を使用して設定されます（sshの`-O forward`オプション）。これは、サーバーがパスワード認証を必要とする場合に有益です。`4d61726b646f776e2e436f64652822222c202261646470726f63732229_40726566`の前にサーバーにログインすることで、Juliaでの認証を回避できます。制御ソケットは、既存のマルチプレクシング接続が使用されない限り、セッション中に`~/.ssh/julia-%r@%h:%p`に配置されます。ノード上で複数のプロセスを作成し、マルチプレクシングを有効にすると、プロセスが単一のマルチプレクシングTCP接続を共有するため、帯域幅が制限される可能性があることに注意してください。

### [Cluster Cookie](@id man-cluster-cookie)

クラスター内のすべてのプロセスは、同じクッキーを共有します。デフォルトでは、これはマスタープロセスでランダムに生成された文字列です。

  * [`cluster_cookie()`](@ref) はクッキーを返し、`cluster_cookie(cookie)()` はそれを設定し、新しいクッキーを返します。
  * すべての接続は両側で認証されており、マスターによって開始されたワーカーのみが互いに接続できることを保証します。
  * クッキーは、起動時に引数 `--worker=<cookie>` を介してワーカーに渡される場合があります。引数 `--worker` がクッキーなしで指定された場合、ワーカーは標準入力からクッキーを読み取ろうとします ([`stdin`](@ref))。クッキーが取得された後、`stdin` はすぐに閉じられます。
  * `ClusterManager`は、[`cluster_cookie()`](@ref)を呼び出すことでマスター上のクッキーを取得できます。デフォルトのTCP/IPトランスポートを使用していないクラスター マネージャー（したがって`--worker`を指定していない場合）は、マスターと同じクッキーを使用して`init_worker(cookie, manager)`を呼び出す必要があります。

セキュリティの高いレベルを必要とする環境では、カスタム `ClusterManager` を介してこれを実装できます。たとえば、クッキーは事前に共有されるため、スタートアップ引数として指定する必要はありません。

## Specifying Network Topology (Experimental)

キーワード引数 `topology` は [`addprocs`](@ref) に渡され、ワーカー同士がどのように接続されるべきかを指定するために使用されます：

  * `:all_to_all`、デフォルト：すべてのワーカーが互いに接続されています。
  * `:master_worker`: ドライバープロセスのみ、すなわち `pid` 1 がワーカーへの接続を持っています。
  * `:custom`: クラスターマネージャの `launch` メソッドは、`WorkerConfig` の `ident` および `connect_idents` フィールドを介して接続トポロジーを指定します。クラスターマネージャが提供するアイデンティティ `ident` を持つワーカーは、`connect_idents` に指定されたすべてのワーカーに接続します。

キーワード引数 `lazy=true|false` は、`topology` オプション `:all_to_all` にのみ影響します。`true` の場合、クラスターはマスターがすべてのワーカーに接続された状態で開始されます。特定のワーカー間の接続は、2つのワーカー間で最初のリモート呼び出しが行われたときに確立されます。これにより、クラスター内通信のために初期に割り当てられるリソースが削減されます。接続は、並列プログラムの実行時の要件に応じて設定されます。`lazy` のデフォルト値は `true` です。

現在、接続されていないワーカー間でメッセージを送信するとエラーが発生します。この動作は、機能やインターフェースと同様に、実験的な性質と見なされており、将来のリリースで変更される可能性があります。

## Noteworthy external packages

Juliaの並列処理の外には、言及すべき多くの外部パッケージがあります。例えば、[`MPI.jl`](https://github.com/JuliaParallel/MPI.jl)は`MPI`プロトコルのためのJuliaラッパーであり、[`Dagger.jl`](https://github.com/JuliaParallel/Dagger.jl)はPythonの[Dask](https://dask.org/)に似た機能を提供し、[`DistributedArrays.jl`](https://github.com/JuliaParallel/Distributedarrays.jl)は、[outlined above](@ref man-shared-arrays)として、ワーカー間で分散された配列操作を提供します。

ジュリアのGPUプログラミングエコシステムについて言及する必要があります。これには以下が含まれます：

1. [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) は、さまざまなCUDAライブラリをラップし、Nvidia GPU用のJuliaカーネルのコンパイルをサポートします。
2. [oneAPI.jl](https://github.com/JuliaGPU/oneAPI.jl) は oneAPI 統一プログラミングモデルをラップしており、サポートされているアクセラレータ上で Julia カーネルを実行することをサポートしています。現在、サポートされているのは Linux のみです。
3. [AMDGPU.jl](https://github.com/JuliaGPU/AMDGPU.jl) は AMD ROCm ライブラリをラップし、AMD GPU 用の Julia カーネルのコンパイルをサポートします。現在、Linux のみがサポートされています。
4. 高レベルのライブラリは、[KernelAbstractions.jl](https://github.com/JuliaGPU/KernelAbstractions.jl)、[Tullio.jl](https://github.com/mcabbott/Tullio.jl)、および[ArrayFire.jl](https://github.com/JuliaComputing/ArrayFire.jl)です。

次の例では、`DistributedArrays.jl` と `CUDA.jl` の両方を使用して、配列を `distribute()` と `CuArray()` を通じて最初にキャストすることによって、複数のプロセスに分散させます。

`DistributedArrays.jl`をインポートする際は、[`@everywhere`](@ref)を使用してすべてのプロセスでインポートすることを忘れないでください。

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
Array{Float64,1}

julia> dB = distribute(B);

julia> dA = distribute(A);

julia> dC = 2 .* dA ./ dB;

julia> all(dC .≈ 4*π)
true

julia> typeof(dC)
DistributedArrays.DArray{Float64,1,Array{Float64,1}}

julia> cuB = CuArray(B);

julia> cuA = CuArray(A);

julia> cuC = 2 .* cuA ./ cuB;

julia> all(cuC .≈ 4*π);
true

julia> typeof(cuC)
CuArray{Float64,1}
```

次の例では、`DistributedArrays.jl` と `CUDA.jl` の両方を使用して、配列を複数のプロセスに分散させ、その上で汎用関数を呼び出します。

```julia
function power_method(M, v)
    for i in 1:100
        v = M*v
        v /= norm(v)
    end

    return v, norm(M*v) / norm(v)  # or  (M*v) ./ v
end
```

`power_method` は新しいベクトルを繰り返し作成し、正規化します。関数宣言で型シグネチャを指定していませんが、前述のデータ型で動作するか見てみましょう:

```julia-repl
julia> M = [2. 1; 1 1];

julia> v = rand(2)
2-element Array{Float64,1}:
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
Tuple{DistributedArrays.DArray{Float64,1,Array{Float64,1}},Float64}
```

この外部パッケージの短い紹介を終えるために、`MPI.jl`、つまりMPIプロトコルのJuliaラッパーを考えてみましょう。すべての内部関数を考慮するには時間がかかりすぎるため、プロトコルを実装するために使用されるアプローチを単に評価する方が良いでしょう。

このおもちゃのスクリプトは、各サブプロセスを呼び出し、そのランクをインスタンス化し、マスタープロセスに到達したときにランクの合計を計算します。

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

[^1]: In this context, MPI refers to the MPI-1 standard. Beginning with MPI-2, the MPI standards committee introduced a new set of communication mechanisms, collectively referred to as Remote Memory Access (RMA). The motivation for adding rma to the MPI standard was to facilitate one-sided communication patterns. For additional information on the latest MPI standard, see [https://mpi-forum.org/docs](https://mpi-forum.org/docs).
