```@meta
EditURL = "https://github.com/JuliaLang/julia/blob/master/stdlib/Profile/docs/src/index.md"
```

# [Profiling](@id lib-profiling)

## CPU Profiling

JuliaコードのCPUプロファイリングには、主に2つの方法があります。

## Via `@profile`

特定の呼び出しに対して、`@profile`マクロを使ってプロファイリングを有効にします。

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

すでに実行中のタスクも、ユーザーが任意のタイミングで開始し、一定時間プロファイリングできます。

プロファイリングを開始するには、次の操作を行います。

  * MacOSおよびFreeBSD（BSD系プラットフォーム）: `ctrl-t`を使うか、juliaプロセスに`SIGINFO`シグナルを送ります。例: `% kill -INFO $julia_pid`
  * Linux: juliaプロセスに`SIGUSR1`シグナルを送ります。例: `% kill -USR1 $julia_pid`
  * Windows: 現在はサポートされていません。

まず、シグナルが送信された瞬間のスタックトレースが1つ表示されます。次に1秒間のプロファイルが収集され、次のyieldポイントでプロファイルレポートが出力されます。yieldポイントのないコード（タイトなループなど）では、タスクの完了時に出力される場合があります。

環境変数[`JULIA_PROFILE_PEEK_HEAP_SNAPSHOT`](@ref JULIA_PROFILE_PEEK_HEAP_SNAPSHOT)に`1`を設定すると、[heap snapshot](@ref Heap-Snapshots)も自動的に収集できます。

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

プロファイリングの実行時間は、[`Profile.set_peek_duration`](@ref)で調整できます。

プロファイルレポートはスレッドとタスクごとに分類されます。これを変更するには、引数を取らない関数を`Profile.peek_report[]`に渡します。たとえば、`Profile.peek_report[] = () -> Profile.print()`を指定すると、グループ化をすべて解除できます。外部のプロファイルデータコンシューマーによっても、この設定を変更できます。

## Reference

```@docs
Profile.@profile
```

`Profile`内のメソッドはエクスポートされていないため、たとえば`Profile.print()`のように呼び出す必要があります。

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

`Profile.Allocs`内のメソッドはエクスポートされていないため、たとえば`Profile.Allocs.fetch()`のように呼び出す必要があります。

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

`Profile`内のメソッドはエクスポートされていないため、たとえば`Profile.take_heap_snapshot()`のように呼び出す必要があります。

```julia-repl
julia> using Profile

julia> Profile.take_heap_snapshot("snapshot.heapsnapshot")
```

ヒープ上のJuliaオブジェクトをトレースして記録します。記録されるのは、Juliaのガベージコレクターが認識しているオブジェクトのみです。ガベージコレクターが管理していない外部ライブラリによるメモリ割り当ては、スナップショットには表示されません。

スナップショットの記録中にメモリ不足（OOM）にならないよう、ヒープスナップショットを4つのファイルにストリーミング出力するオプションを追加しました。

```julia-repl
julia> using Profile

julia> Profile.take_heap_snapshot("snapshot"; streaming=true)
```

ここで「snapshot」は、生成されるファイルの接頭辞となるファイルパスです。

スナップショットファイルを生成したら、次のコマンドでオフラインで結合できます。

```julia-repl
julia> using Profile

julia> Profile.HeapSnapshot.assemble_snapshot("snapshot", "snapshot.heapsnapshot")
```

生成されたヒープスナップショットファイルは、Chrome DevToolsにアップロードして表示できます。詳しくは、[chrome devtools docs](https://developer.chrome.com/docs/devtools/memory-problems/heap-snapshots/#view_snapshots)を参照してください。Chromiumのヒープスナップショットを解析する別の方法として、VS Code拡張機能の`ms-vscode.vscode-js-profile-flame`を利用できます。

Firefoxのヒープスナップショットは形式が異なるため、現在、Juliaが生成したヒープスナップショットの表示にはFirefoxを使用できない場合があります。
