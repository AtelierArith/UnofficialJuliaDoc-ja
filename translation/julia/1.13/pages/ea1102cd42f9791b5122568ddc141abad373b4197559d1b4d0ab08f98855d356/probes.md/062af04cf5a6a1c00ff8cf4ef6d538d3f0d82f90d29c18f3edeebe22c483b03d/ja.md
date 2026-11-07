# Instrumenting Julia with DTrace, and bpftrace

DTrace と bpftrace は、プロセスに軽量な計測機能を追加するためのツールです。プロセスの実行中に計測の有効・無効を切り替えられ、無効時のオーバーヘッドは最小限です。

!!! compat "Julia 1.8"
    プローブのサポートは Julia 1.8 で追加されました。


!!! note
    このドキュメントは Linux を前提に書かれていますが、内容の大部分は Mac OS/Darwin と FreeBSD にも当てはまります。


## Enabling support

Linux では、`systemtap` パッケージをインストールします。このパッケージには `dtrace` のバージョンが含まれています。次に、`Make.user` ファイルを作成し、以下を記述します。

```
WITH_DTRACE=1
```

これにより、USDT プローブが有効になります。

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

プローブは、`src/uprobes.d` ファイル内で DTrace 形式で宣言します。生成されたヘッダーファイルは `src/julia_internal.h` にインクルードされます。プローブを追加する場合は、そこで noop 実装も用意してください。

ヘッダーにはセマフォ `*_ENABLED` と、プローブを実際に呼び出すコードが含まれます。プローブの引数を計算するコストが高い場合は、まずプローブが有効かどうかを確認してから、引数を計算してプローブを呼び出してください。

```c
  if (JL_PROBE_{PROBE}_ENABLED())
    auto expensive_arg = ...;
    JL_PROBE_{PROBE}(expensive_arg);
```

プローブに引数がない場合は、セマフォのチェックを含めないことを推奨します。USDT プローブが有効な場合、セマフォのコストはメモリの読み込みです。プローブが有効かどうかには関係ありません。

```c
#define JL_PROBE_GC_BEGIN_ENABLED() __builtin_expect (julia_gc__begin_semaphore, 0)
__extension__ extern unsigned short julia_gc__begin_semaphore __attribute__ ((unused)) __attribute__ ((section (".probes")));
```

一方、プローブ自体は noop のスレッドであり、プローブハンドラーへのトランポリンにパッチされます。

## Available probes

### GC probes

1. `julia:gc__begin`: GC があるスレッドで開始され、stop-the-world を引き起こす。
2. `julia:gc__stop_the_world`: すべてのスレッドがセーフポイントに到達し、GC が実行される。
3. `julia:gc__mark__begin`: マークフェーズの開始
4. `julia:gc__mark_end(scanned_bytes, perm_scanned)`: マークフェーズの終了
5. `julia:gc__sweep_begin(full)`: スイープの開始
6. `julia:gc__sweep_end`: スイープフェーズの終了
7. `julia:gc__end`: GC が終了し、他のスレッドが処理を再開する
8. `julia:gc__finalizer`: 最初に GC を実行したスレッドがファイナライザーの実行を終える

### Task runtime probes

1. `julia:rt__run__task(task)`: 現在のスレッドでタスク `task` に切り替える。
2. `julia:rt__pause__task(task)`: 現在のスレッドでタスク `task` から切り替える。
3. `julia:rt__new__task(parent, child)`: 現在のスレッドでタスク `parent` がタスク `child` を作成した。
4. `julia:rt__start__task(task)`: タスク `task` が新しいスタックで初めて実行を開始した。
5. `julia:rt__finish__task(task)`: タスク `task` が終了し、以後実行されなくなる。
6. `julia:rt__start__process__events(task)`: タスク `task` が libuv イベントの処理を開始した。
7. `julia:rt__finish__process__events(task)`: タスク `task` が libuv イベントの処理を終えた。

### Task queue probes

1. `julia:rt__taskq__insert(ptls, task)`: スレッド `ptls` が PARTR multiq への `task` の挿入を試みた。
2. `julia:rt__taskq__get(ptls, task)`: スレッド `ptls` が PARTR multiq から `task` を取り出した。

### Thread sleep/wake probes

1. `julia:rt__sleep__check__wake(ptls, old_state)`: スレッド (PTLS `ptls`) が起床中。直前の状態は `old_state`。
2. `julia:rt__sleep__check__wakeup(ptls)`: スレッド (PTLS `ptls`) が自ら起床した。
3. `julia:rt__sleep__check__sleep(ptls)`: スレッド (PTLS `ptls`) がスリープしようとしている。
4. `julia:rt__sleep__check__taskq__wake(ptls)`: PARTR multiq にタスクがあるため、スレッド (PTLS `ptls`) はスリープできなかった。
5. `julia:rt__sleep__check__task__wake(ptls)`: Base workqueue にタスクがあるため、スレッド (PTLS `ptls`) はスリープできなかった。
6. `julia:rt__sleep__check__uv__wake(ptls)`: libuv の起床通知があったため、スレッド (PTLS `ptls`) はスリープできなかった。

## Probe usage examples

### GC stop-the-world latency

`bpftrace` のスクリプト例は `contrib/gc_stop_the_world_latency.bt` にあります。このスクリプトは、すべてのスレッドがセーフポイントに到達するまでの遅延をヒストグラムにします。

次の `julia -t 2` を指定して Julia コードを実行し、

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

別のターミナルで次を実行すると、

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

実行中の Julia プロセスにおける stop-the-world フェーズの遅延分布を確認できます。

### Task spawn monitor

タスクがほかのタスクを生成するタイミングを知りたい場合があります。`rt__new__task` を使えば簡単に確認できます。プローブの最初の引数 `parent` は、新しいタスクを作成する既存のタスクです。つまり、監視したいタスクのアドレスが分かれば、そのタスクが生成したタスクだけを簡単に確認できます。実際に試してみましょう。まず Julia セッションを起動し、PID と REPL のタスクアドレスを取得します。

```
> julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.6.2 (2021-07-14)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org release
|__/                   |

1> getpid()
997825

2> current_task()
Task (runnable) @0x00007f524d088010
```

次に `bpftrace` を起動し、親がこのタスクである場合に限って `rt__new__task` を監視します。

`sudo bpftrace -p 997825 -e 'usdt:usr/lib/libjulia-internal.so:julia:rt__new__task /arg0==0x00007f524d088010/{ printf("Task: %x\n", arg0); }'`

（上の例では、`arg0` が最初の引数で、`parent` です。）

タスクを1つ生成すると、

`Threads.@spawn 1+1`

そのタスクが作成されたことを確認できます。

`Task: 4d088010`

しかし、新しく生成したタスクから複数のタスクを生成しても、

```julia
Threads.@spawn for i in 1:10
   Threads.@spawn 1+1
end
```

`bpftrace` からはタスクが1つだけ表示されます。

`Task: 4d088010`

しかも、表示されるのは引き続き監視対象のタスクです。もちろん、このフィルターを外せば、新しく作成されたタスクをすべて簡単に確認できます。

`sudo bpftrace -p 997825 -e 'usdt:usr/lib/libjulia-internal.so:julia:rt__new__task { printf("Task: %x\n", arg0); }'`

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

ルートタスクと、新たに生成されたタスクが、さらに新しく生成された10個のタスクの親になっていることが分かります。

### Thundering herd detection

タスクランタイムでは、「サンダリングハード」問題が発生することがあります。アイドル状態のタスクランタイムに処理が追加されると、各スレッドが処理できるだけの仕事がない場合でも、すべてのスレッドがスリープ状態から起こされることがあります。その結果、すべてのスレッドが起床し、実行する仕事が見つからず同時に再びスリープするまでの間、余分な遅延や CPU サイクルが発生します。

`bpftrace` を使うと、この問題を簡単に確認できます。まず、1つ目のターミナルで複数スレッド（この例では6スレッド）を使って Julia を起動し、そのプロセスの PID を取得します。

```
> julia -t 6
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.6.2 (2021-07-14)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org release
|__/                   |

1> getpid()
997825
```

別のターミナルでは、`bpftrace` を起動してプロセスを監視します。ここでは特に `rt__sleep__check__wake` フックをプローブします。

`sudo bpftrace -p 997825 -e 'usdt:usr/lib/libjulia-internal.so:julia:rt__sleep__check__wake { printf("Thread wake up! %x\n", arg0); }'`

次に、Julia でタスクを1つだけ作成して実行します。

`Threads.@spawn 1+1`

すると、`bpftrace` に次のような出力が表示されます。

```
Thread wake up! 3f926100
Thread wake up! 3ebd5140
Thread wake up! 3f876130
Thread wake up! 3e2711a0
Thread wake up! 3e312190
```

生成したタスクは1つだけで、一度に処理できるスレッドも1つだけなのに、ほかのスレッドもすべて起床しました。将来、より賢いタスクランタイムが実装されれば、起床するスレッドを1つだけにする（あるいは、生成したスレッド自身がタスクを実行できるなら、どのスレッドも起こさない）ようになり、この現象は解消されるはずです。

### Task Monitor with BPFnative.jl

BPFnative.jl は `bpftrace` と同様に、USDT プローブポイントにアタッチできます。タスクランタイム、GC、スレッドのスリープ／起床の遷移を監視するデモは [here](https://github.com/jpsamaroo/BPFnative.jl/blob/master/examples/task-runtime.jl) で利用できます。

## Notes on using `bpftrace`

bpftrace 形式のプローブの例を示します。

```
usdt:usr/lib/libjulia-internal.so:julia:gc__begin
{
  @start[pid] = nsecs;
}
```

プローブ宣言では、まず種類 `usdt` を指定し、続けてライブラリのパスまたは PID、プロバイダー名 `julia`、プローブ名 `gc__begin` を指定します。ここでは `libjulia-internal.so` への相対パスを使っていますが、本番環境では絶対パスが必要になる場合があります。

## Useful references:

  * [Julia Evans blog on Linux tracing systems](https://jvns.ca/blog/2017/07/05/linux-tracing-systems)
  * [LWN article on USDT and BPF](https://lwn.net/Articles/753601/)
  * [GDB support for probes](https://sourceware.org/gdb/onlinedocs/gdb/Static-Probe-Points.html)
  * [Brendan Gregg – Linux Performance](https://www.brendangregg.com/linuxperf.html)
