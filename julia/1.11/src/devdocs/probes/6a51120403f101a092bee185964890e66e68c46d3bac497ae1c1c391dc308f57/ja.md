# Instrumenting Julia with DTrace, and bpftrace

DTrace と bpftrace は、プロセスの軽量な計測を可能にするツールです。プロセスが実行中の間に計測をオンとオフに切り替えることができ、計測がオフの状態ではオーバーヘッドは最小限です。

!!! compat "Julia 1.8"
    プローブのサポートはJulia 1.8で追加されました。


!!! note
    このドキュメントはLinuxの視点から書かれており、ほとんどの内容はMac OS/DarwinおよびFreeBSDでも適用されるはずです。


## Enabling support

Linuxに`dtrace`のバージョンを含む`systemtap`パッケージをインストールし、`Make.user`ファイルを作成します。

```
WITH_DTRACE=1
```

USDTプローブを有効にする。

### Verifying

```
> readelf -n usr/lib/libjulia-internal.so.1

Displaying notes found in: .note.gnu.build-id
  Owner                Data size  Description
  GNU                  0x00000014 NT_GNU_BUILD_ID (unique build ID bitstring)
    Build ID: 57161002f35548772a87418d2385c284ceb3ead8

Displaying notes found in: .note.stapsdt
  Owner                Data size  Description
  stapsdt              0x00000029 NT_STAPSDT (SystemTap probe descriptors)
    Provider: julia
    Name: gc__begin
    Location: 0x000000000013213e, Base: 0x00000000002bb4da, Semaphore: 0x0000000000346cac
    Arguments:
  stapsdt              0x00000032 NT_STAPSDT (SystemTap probe descriptors)
    Provider: julia
    Name: gc__stop_the_world
    Location: 0x0000000000132144, Base: 0x00000000002bb4da, Semaphore: 0x0000000000346cae
    Arguments:
  stapsdt              0x00000027 NT_STAPSDT (SystemTap probe descriptors)
    Provider: julia
    Name: gc__end
    Location: 0x000000000013214a, Base: 0x00000000002bb4da, Semaphore: 0x0000000000346cb0
    Arguments:
  stapsdt              0x0000002d NT_STAPSDT (SystemTap probe descriptors)
    Provider: julia
    Name: gc__finalizer
    Location: 0x0000000000132150, Base: 0x00000000002bb4da, Semaphore: 0x0000000000346cb2
    Arguments:
```

## Adding probes in libjulia

プローブは、ファイル `src/uprobes.d` で dtraces 形式で宣言されています。生成されたヘッダーファイルは `src/julia_internal.h` に含まれており、プローブを追加する場合は、そこで noop 実装を提供する必要があります。

ヘッダーにはセマフォ `*_ENABLED` が含まれ、実際のプローブへの呼び出しが行われます。プローブの引数を計算するのが高コストである場合、まずプローブが有効かどうかを確認し、その後引数を計算してプローブを呼び出すべきです。

```c
  if (JL_PROBE_{PROBE}_ENABLED())
    auto expensive_arg = ...;
    JL_PROBE_{PROBE}(expensive_arg);
```

引数がない場合、セマフォチェックを含めないことが推奨されます。USDTプローブが有効な場合、セマフォのコストはメモリロードであり、プローブが有効かどうかに関係なく発生します。

```c
#define JL_PROBE_GC_BEGIN_ENABLED() __builtin_expect (julia_gc__begin_semaphore, 0)
__extension__ extern unsigned short julia_gc__begin_semaphore __attribute__ ((unused)) __attribute__ ((section (".probes")));
```

プローブ自体は、プローブハンドラーにパッチされるトランポリンに接続されたノーオプススレッドです。

## Available probes

### GC probes

1. `julia:gc__begin`: GCが1つのスレッドで実行を開始し、ストップ・ザ・ワールドをトリガーします。
2. `julia:gc__stop_the_world`: すべてのスレッドがセーフポイントに到達し、GCが実行されます。
3. `julia:gc__mark__begin`: マークフェーズの開始
4. `julia:gc__mark_end(scanned_bytes, perm_scanned)`: マークフェーズが終了しました
5. `julia:gc__sweep_begin(full)`: スイープを開始しています
6. `julia:gc__sweep_end`: スイープフェーズが終了しました
7. `julia:gc__end`: GCが終了しました。他のスレッドは作業を続けます。
8. `julia:gc__finalizer`: 初期GCスレッドがファイナライザの実行を完了しました

### Task runtime probes

1. `julia:rt__run__task(task)`: 現在のスレッドでタスク `task` に切り替えています。
2. `julia:rt__pause__task(task)`: 現在のスレッドでタスク `task` から切り替えています。
3. `julia:rt__new__task(parent, child)`: タスク `parent` が現在のスレッドでタスク `child` を作成しました。
4. `julia:rt__start__task(task)`: タスク `task` が新しいスタックで初めて開始されました。
5. `julia:rt__finish__task(task)`: タスク `task` が完了し、もはや実行されません。
6. `julia:rt__start__process__events(task)`: タスク `task` が libuv イベントの処理を開始しました。
7. `julia:rt__finish__process__events(task)`: タスク `task` が libuv イベントの処理を終了しました。

### Task queue probes

1. `julia:rt__taskq__insert(ptls, task)`: スレッド `ptls` が `task` を PARTR マルチキューに挿入しようとしました。
2. `julia:rt__taskq__get(ptls, task)`: スレッド `ptls` が PARTR マルチキューから `task` をポップしました。

### Thread sleep/wake probes

1. `julia:rt__sleep__check__wake(ptls, old_state)`: スレッド (PTLS `ptls`) が目覚めました。以前の状態は `old_state` です。
2. `julia:rt__sleep__check__wakeup(ptls)`: スレッド (PTLS `ptls`) が自ら目を覚ましました。
3. `julia:rt__sleep__check__sleep(ptls)`: スレッド (PTLS `ptls`) がスリープしようとしています。
4. `julia:rt__sleep__check__taskq__wake(ptls)`: スレッド (PTLS `ptls`) は、PARTR マルチキュー内のタスクのためにスリープできません。
5. `julia:rt__sleep__check__task__wake(ptls)`: スレッド (PTLS `ptls`) は、Base のワークキュー内のタスクのためにスリープできません。
6. `julia:rt__sleep__check__uv__wake(ptls)`: スレッド (PTLS `ptls`) が libuv のウェイクアップによりスリープに失敗しました。

## Probe usage examples

### GC stop-the-world latency

例として、`contrib/gc_stop_the_world_latency.bt` に `bpftrace` スクリプトが示されており、すべてのスレッドがセーフポイントに到達するまでのレイテンシのヒストグラムを作成します。

`julia -t 2` でこのJuliaコードを実行する

```
using Base.Threads

fib(x) = x <= 1 ? 1 : fib(x-1) + fib(x-2)

beaver = @spawn begin
    while true
        fib(30)
        # A manual safepoint is necessary since otherwise this loop
        # may never yield to GC.
        GC.safepoint()
    end
end

allocator = @spawn begin
    while true
        zeros(1024)
    end
end

wait(allocator)
```

および別のターミナルで

```
> sudo contrib/bpftrace/gc_stop_the_world_latency.bt
Attaching 4 probes...
Tracing Julia GC Stop-The-World Latency... Hit Ctrl-C to end.
^C


@usecs[1743412]:
[4, 8)               971 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[8, 16)              837 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        |
[16, 32)             129 |@@@@@@                                              |
[32, 64)              10 |                                                    |
[64, 128)              1 |                                                    |
```

実行されたJuliaプロセスにおけるストップ・ザ・ワールドフェーズのレイテンシ分布を見ることができます。

### Task spawn monitor

タスクが他のタスクを生成しているときにそれを知ることは、時には便利です。これは `rt__new__task` を使うと非常に簡単に見ることができます。プローブの最初の引数 `parent` は、新しいタスクを作成している既存のタスクです。つまり、監視したいタスクのアドレスがわかれば、その特定のタスクが生成したタスクを簡単に見ることができます。これをどうやって行うか見てみましょう。まず、Juliaセッションを開始し、PIDとREPLのタスクアドレスを取得しましょう。

```
> julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.6.2 (2021-07-14)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

1> getpid()
997825

2> current_task()
Task (runnable) @0x00007f524d088010
```

今、`bpftrace`を起動し、この親に対してのみ`rt__new__task`を監視することができます:

`sudo bpftrace -p 997825 -e 'usdt:usr/lib/libjulia-internal.so:julia:rt__new__task /arg0==0x00007f524d088010/{ printf("タスク: %x\n", arg0); }'`

（上記の内容では、`arg0`は最初の引数であり、`parent`です）。

そして、単一のタスクを生成した場合：

`@async 1+1`

このタスクが作成されるのを見ています：

`タスク: 4d088010`

しかし、新しく生成されたタスクからたくさんのタスクを生成した場合：

```julia
@async for i in 1:10
   @async 1+1
end
```

まだ `bpftrace` からのタスクは1つしか見えません:

`タスク: 4d088010`

そして、それは私たちが監視していた同じタスクです！もちろん、このフィルターを削除すれば、*すべての*新しく作成されたタスクを見ることができます。

`sudo bpftrace -p 997825 -e 'usdt:usr/lib/libjulia-internal.so:julia:rt__new__task { printf("タスク: %x\n", arg0); }'`

```
Task: 4d088010
Task: 4dc4e290
Task: 4dc4e290
Task: 4dc4e290
Task: 4dc4e290
Task: 4dc4e290
Task: 4dc4e290
Task: 4dc4e290
Task: 4dc4e290
Task: 4dc4e290
Task: 4dc4e290
```

ルートタスクと、新たに生成されたタスクが10のさらに新しいタスクの親であることがわかります。

### Thundering herd detection

タスクの実行時間はしばしば「雷鳴の群れ」問題に悩まされることがあります。静かなタスク実行環境に作業が追加されると、すべてのスレッドが眠りから覚まされる可能性がありますが、各スレッドが処理するのに十分な作業がない場合もあります。これにより、すべてのスレッドが目覚める間に余分なレイテンシとCPUサイクルが発生し（同時に作業が見つからず再び眠りに戻る）、問題が生じることがあります。

この問題は `bpftrace` を使って簡単に示すことができます。まず、1つのターミナルで複数のスレッド（この例では6）を持つJuliaを起動し、そのプロセスのPIDを取得します：

```
> julia -t 6
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.6.2 (2021-07-14)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

1> getpid()
997825
```

別のターミナルで、`bpftrace`を起動して、特に`rt__sleep__check__wake`フックをプローブしてプロセスを監視します：

`sudo bpftrace -p 997825 -e 'usdt:usr/lib/libjulia-internal.so:julia:rt__sleep__check__wake { printf("スレッドが起きました！ %x\n", arg0); }'`

今、私たちはJuliaで単一のタスクを作成し、実行します：

`Threads.@spawn 1+1`

そして `bpftrace` では、次のような出力が表示されます:

```
Thread wake up! 3f926100
Thread wake up! 3ebd5140
Thread wake up! 3f876130
Thread wake up! 3e2711a0
Thread wake up! 3e312190
```

たとえ私たちが単一のタスクを生成しただけで（それは一度に一つのスレッドしか処理できませんでした）、私たちは他のすべてのスレッドを起こしました！将来的には、より賢いタスクランタイムが単一のスレッド（または全く起こさない）だけを起こすかもしれません（生成したスレッドがこのタスクを実行することもできます！）、そしてこの動作はなくなるはずです。

### Task Monitor with BPFnative.jl

BPFnative.jlは、`bpftrace`と同様にUSDTプローブポイントにアタッチすることができます。タスクの実行時間、GC、スレッドのスリープ/ウェイク遷移を監視するためのデモが利用可能です。 [here](https://github.com/jpsamaroo/BPFnative.jl/blob/master/examples/task-runtime.jl)

## Notes on using `bpftrace`

bpftraceフォーマットの例となるプローブは次のようになります：

```
usdt:usr/lib/libjulia-internal.so:julia:gc__begin
{
  @start[pid] = nsecs;
}
```

プローブ宣言は `usdt` の種類を取り、次にライブラリへのパスまたはPID、プロバイダー名 `julia` とプローブ名 `gc__begin` を指定します。私は `libjulia-internal.so` への相対パスを使用していますが、これは本番システムでは絶対パスである必要があるかもしれません。

## Useful references:

  * [Julia Evans blog on Linux tracing systems](https://jvns.ca/blog/2017/07/05/linux-tracing-systems)
  * [LWN article on USDT and BPF](https://lwn.net/Articles/753601/)
  * [GDB support for probes](https://sourceware.org/gdb/onlinedocs/gdb/Static-Probe-Points.html)
  * [Brendan Gregg – Linux Performance](https://www.brendangregg.com/linuxperf.html)
