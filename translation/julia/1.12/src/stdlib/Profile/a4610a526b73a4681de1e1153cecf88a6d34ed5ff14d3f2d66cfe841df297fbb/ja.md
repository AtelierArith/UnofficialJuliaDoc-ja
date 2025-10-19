```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Profile/docs/src/index.md"
```

# [Profiling](@id lib-profiling)

## CPU Profiling

CPUプロファイリングのJuliaコードには主に2つのアプローチがあります：

## Via `@profile`

`@profile` マクロを介して特定の呼び出しに対してプロファイリングが有効になっている場所。

```julia-repl
julia> using Profile

julia> @profile foo()

julia> Profile.print()
Overhead ╎ [+additional indent] Count File:Line; Function
=========================================================
    ╎147  @Base/client.jl:506; _start()
        ╎ 147  @Base/client.jl:318; exec_options(opts::Base.JLOptions)
...
```

## Triggered During Execution

実行中のタスクは、ユーザーがトリガーした任意の時点で、固定の時間期間にわたってプロファイルすることもできます。

プロファイリングをトリガーするには：

  * MacOS & FreeBSD (BSDベースのプラットフォーム): `ctrl-t`を使用するか、`SIGINFO`信号をjuliaプロセスに送信します。つまり、`% kill -INFO $julia_pid`
  * Linux: `julia`プロセスに`SIGUSR1`シグナルを送信します。つまり、`% kill -USR1 $julia_pid`です。
  * Windows: 現在サポートされていません。

最初に、信号が発生した瞬間の単一のスタックトレースが表示され、その後1秒間のプロファイルが収集され、次のイールドポイントでのプロファイルレポートが続きます。これは、イールドポイントのないコード（例えば、タイトなループ）の場合、タスクの完了時に発生する可能性があります。

オプションで環境変数 [`JULIA_PROFILE_PEEK_HEAP_SNAPSHOT`](@ref JULIA_PROFILE_PEEK_HEAP_SNAPSHOT) を `1` に設定すると、[heap snapshot](@ref Heap-Snapshots) も自動的に収集されます。

```julia-repl
julia> foo()
##== the user sends a trigger while foo is running ==##
load: 2.53  cmd: julia 88903 running 6.16u 0.97s

======================================================================================
Information request received. A stacktrace will print followed by a 1.0 second profile
======================================================================================

signal (29): Information request: 29
__psynch_cvwait at /usr/lib/system/libsystem_kernel.dylib (unknown line)
_pthread_cond_wait at /usr/lib/system/libsystem_pthread.dylib (unknown line)
...

======================================================================
Profile collected. A report will print if the Profile module is loaded
======================================================================

Overhead ╎ [+additional indent] Count File:Line; Function
=========================================================
Thread 1 Task 0x000000011687c010 Total snapshots: 572. Utilization: 100%
   ╎147 @Base/client.jl:506; _start()
       ╎ 147 @Base/client.jl:318; exec_options(opts::Base.JLOptions)
...

Thread 2 Task 0x0000000116960010 Total snapshots: 572. Utilization: 0%
   ╎572 @Base/task.jl:587; task_done_hook(t::Task)
      ╎ 572 @Base/task.jl:879; wait()
...
```

### Customization

プロファイリングの期間は、[`Profile.set_peek_duration`](@ref)を介して調整できます。

プロファイルレポートはスレッドとタスクによって分割されています。これを上書きするには、引数なしの関数を`Profile.peek_report[]`に渡します。つまり、`Profile.peek_report[] = () -> Profile.print()`のようにして、グループ化を削除します。これは外部のプロファイルデータ消費者によっても上書きされる可能性があります。

## Reference

```@docs
Profile.@profile
```

`Profile`のメソッドはエクスポートされておらず、例えば`Profile.print()`のように呼び出す必要があります。

```@docs
Profile.clear
Profile.print
Profile.init
Profile.fetch
Profile.retrieve
Profile.callers
Profile.clear_malloc_data
Profile.get_peek_duration
Profile.set_peek_duration
```

## Memory profiling

```@docs
Profile.Allocs.@profile
```

`Profile.Allocs` のメソッドはエクスポートされておらず、例えば `Profile.Allocs.fetch()` のように呼び出す必要があります。

```@docs
Profile.Allocs.clear
Profile.Allocs.print
Profile.Allocs.fetch
Profile.Allocs.start
Profile.Allocs.stop
```

## Heap Snapshots

```@docs
Profile.take_heap_snapshot
```

`Profile`のメソッドはエクスポートされておらず、例えば`Profile.take_heap_snapshot()`のように呼び出す必要があります。

```julia-repl
julia> using Profile

julia> Profile.take_heap_snapshot("snapshot.heapsnapshot")
```

ヒープ上のJuliaオブジェクトをトレースおよび記録します。これは、Juliaガベージコレクタによって知られているオブジェクトのみを記録します。ガベージコレクタによって管理されていない外部ライブラリによって割り当てられたメモリは、スナップショットには表示されません。

スナップショットを記録中にOOMを回避するために、ヒープスナップショットを4つのファイルにストリーミングするオプションを追加しました。

```julia-repl
julia> using Profile

julia> Profile.take_heap_snapshot("snapshot"; streaming=true)
```

「snapshot」は生成されたファイルのプレフィックスとしてのファイルパスです。

スナップショットファイルが生成されると、次のコマンドを使用してオフラインで組み立てることができます：

```julia-repl
julia> using Profile

julia> Profile.HeapSnapshot.assemble_snapshot("snapshot", "snapshot.heapsnapshot")
```

結果として得られたヒープスナップショットファイルは、Chrome DevToolsにアップロードして表示できます。詳細については、[chrome devtools docs](https://developer.chrome.com/docs/devtools/memory-problems/heap-snapshots/#view_snapshots)を参照してください。Chromiumヒープスナップショットを分析するための別の方法は、VS Code拡張機能`ms-vscode.vscode-js-profile-flame`を使用することです。

Firefoxのヒープスナップショットは異なる形式であり、現在FirefoxはJuliaによって生成されたヒープスナップショットの表示には*使用できない*可能性があります。
