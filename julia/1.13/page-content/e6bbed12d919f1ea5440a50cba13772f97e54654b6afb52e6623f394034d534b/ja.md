# Task scheduler wakeups

このページでは、Juliaのタスクスケジューラで使われるスリープ／起床ハンドシェイクについて説明します。特に、なぜ`jl_wakeup_threadpool`が、すべてのスレッドにブロードキャストするのではなく、マルチキューへの挿入1回につき1つのワーカーだけを起こす場合があるのかを解説します。

## The problem

マルチキューに入るすべての`@spawn`は、以前は`jl_wakeup_thread(-1)`を呼び出していました。この関数はすべてのスレッドを走査し、スリープ中の各スレッドに`uv_cond_signal`を発行します。そのため、過剰にスレッドを割り当てたマシンでは、spawnが集中すると、挿入のたびに``O(nthreads)``「起床ストーム」が発生します（JuliaLang/julia#61820、JuliaLang/julia#50425）。アイドル状態のワーカーがすべて起こされ、1つの新しいタスクを奪い合い、1つを除く全員がすぐに再びスリープします。

`jl_wakeup_threadpool(tpid)`は、このブロードキャストを置き換えます。マルチキューへの挿入で起こすのは、そのタスクのプール内でスリープ中のワーカー最大1つです。``N``の挿入が連続すれば、最大``N``個のワーカーが起こされます。ワーカー間で起床が連鎖することはありません。起こされたワーカーはタスクを取り出して実行するだけです。

## Why waking one worker is enough

正しさは、ブロードキャスト方式でも使われていた同じストアバッファリングフェンス（`[^store_buffering_1]`、[`src/scheduler.c`](https://github.com/JuliaLang/julia/blob/master/src/scheduler.c)）に依存します。スレッドごとに成り立つ不変条件は次のとおりです。

> ワーカーは起床側から`sleeping`として観測されるか、まだスリープへの移行を確定していないため、キューを再確認して新たに挿入されたタスクを見つけることが保証されている。


`jl_task_get_next`におけるコンシューマーのスリープ移行は、次の順序で行われます。

1. `sleep_check_state = sleeping`を公開する。
2. `jl_fence()`。
3. キューを再確認する（`check_empty`）。作業が現れていればスリープを中止する。
4. `n_threads_running`を減らす。
5. `may_sleep`が成立している間、条件変数で待機する。

エンキュー側は挿入後にフェンスを実行し、候補となる各ワーカーの`sleep_check_state`を調べます。コンシューマーは手順1で`sleeping`を公開し、手順3でキューを再確認するより前にそれを行うため、エンキュー側は`sleeping`を確認してワーカーを起こすか、ワーカー自身が手順3で新しいタスクを見つけます。どちらの場合も、タスクは処理されます。

## Why the wake must *not* be skipped using `n_threads_running`

`n_threads_running >= jl_n_threads`（「すべて実行中で、待機中のスレッドはいない」）の場合に走査を完全に省略するのは、一見すると有効な最適化に思えます。しかし、これは**正しくありません**。理由は独立に2つあります。

1. **カウントはスレッドごとの状態より遅れて更新される。** `n_threads_running`が減らされるのは手順4であり、コンシューマーが手順3でキューを再確認した後です。手順1から4までの間、ワーカーは`sleeping`を公開し、すでにキューが空だと読み取っている可能性がありますが、カウント上はまだ実行中です。そのため、カウントを参照するエンキュー側は古い「全員実行中」という情報を読み取り、ワーカーが実際には必要としている起床を省略してしまいます。
2. **カウントはグローバルですが、起床対象はプール内に限られる。** あるプールのビジー状態のワーカーによって`n_threads_running`が高いままでも、別のプールでは全ワーカーが待機中ということがあります。このときプールをまたぐ挿入（たとえば、`:default`ワーカーから`:interactive`タスクをspawnする場合）が無視され、タスクが永久に取り残される可能性があります。

`sleep_check_state`を走査すれば、どちらの問題も回避できます。このフラグは手順1で、キューの再確認より前に設定されるため、走査で危険な時間帯にあるワーカーを見落とすことはありません。また、プールごとに調べられます。

## TLA+ model

ディレクトリ[`scheduler-wakeup/`](https://github.com/JuliaLang/julia/tree/master/doc/src/devdocs/scheduler-wakeup)には、このハンドシェイクをモデル化した小さなTLA+モデルがあり、上記の議論を機械的に検証できます。

  * [`SchedulerWake.tla`](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/scheduler-wakeup/SchedulerWake.tla)では、スリープへの移行を上記と同じ離散ステップとしてモデル化しています。そのため、モデルチェッカーは、この時間帯におけるあらゆるインターリーブと、`sleep_check_state`を走査して1つのワーカーを起こすエンキュー側の動作を検証します。
  * `MCFixed` — 具体的な構成例（1つのプールを共有する2つのワーカーと、別プールからのプロデューサー）。TLCは状態空間全体を探索し、デッドロックも`NoLostWakeup`違反も見つけません。

再現するには、[`tla2tools.jar`](https://github.com/tlaplus/tlaplus/releases)を使って次のようにします。

```sh
cd doc/src/devdocs/scheduler-wakeup
java -cp tla2tools.jar tlc2.TLC -config MCFixed.cfg MCFixed.tla
```

モデルを、正しくない`n_threads_running`の短絡処理に戻し（`Wakeup`が`nrun >= N`の場合に早期リターンするようにする）、TLCを実行すると、`NoLostWakeup`違反が報告されます。これにより、前述の危険な時間帯が実際に存在することを確認できます。

## The event loop thread

スレッド化された領域の外では、1つのスレッド（`io_loop_tid`。通常はスレッド0）だけがlibuvイベントループを実行します。ほかにすることがなくなると、そのスレッドは`sleeping`を公開し、iolock（`jl_uv_mutex`）を保持したまま`uv_run(loop, UV_RUN_ONCE)`を実行します。その後もループがアイドル状態（`uv_run`が0を返す）で、その間に起こされていなければ、条件変数で待機します。

ほかのスレッドはiolockを保持してlibuvハンドル（`uv_poll_start`、`uv_timer_start`など）を登録しますが、それらのハンドルを処理するためにイベントループを実行することはありません。代わりに、スリープに入るスレッドはiolockを確認します。ロックが空いていれば`io_loop_tid`を起こし、自分が登録した可能性のあるハンドルが監視されるようにします。ロックが保持されていれば、ロックの保持者に任せます。通常、ロックの保持者は必ず処理します。別のスレッドが自分自身のスリープ時に同じ確認を行うか、イベントループスレッドがまさに`uv_run`を実行しようとしている（その際にハンドルを検出する）か、すでに実行中だからです。

例外は、`uv_run`の後のイベントループスレッドです。`JL_UV_UNLOCK`は保留中のファイナライザを実行し、libuvを利用するオブジェクト（`uvfinalize`）のファイナライザはiolockを取得します。ロック解除によってiolockが解放された後、別のスレッドがハンドルを登録することがあります。そのスレッドがロックの所有者を確認する前にファイナライザがiolockを再取得すると、そのスレッドは起床を省略します。そしてイベントループスレッドは、先ほどのアイドル判定に基づいて待機に入るため、以後ループを実行するスレッドがいなくなります。

ロック解除によってアイドル判定が無効になる可能性があるため、`jl_task_get_next`は待機に入る前に、ループがまだアイドル状態かどうかを再確認します。trylockでiolockを取得し、ファイナライザを実行せずにロックを解放します。iolockがビジーなら、待機せずに再試行します。

[`IoLoopWake.tla`](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/scheduler-wakeup/IoLoopWake.tla)は、スレッド化された領域の外でのこの引き継ぎをモデル化しています。iolockの競合と、ループの実行前およびロック解除後にiolockを取得するファイナライザも含まれます。`uv_run`内でのブロッキングとシャットダウンは抽象化しており、別のスレッドが実行を続けている間にIOが最終的に処理されることではなく、armed状態のハンドルがグローバルに取り残されないことを検証します。`IoLoopWake.cfg`を使うと、指定された境界内ではTLCは`NoLostWakeup`違反を見つけません。一方、`IoLoopWakeUnfixed.cfg`ではそのチェックが省かれ、反例が生成されます。

```sh
cd doc/src/devdocs/scheduler-wakeup
java -cp tla2tools.jar tlc2.TLC -config IoLoopWake.cfg IoLoopWake.tla
java -cp tla2tools.jar tlc2.TLC -config IoLoopWakeUnfixed.cfg IoLoopWake.tla
```
