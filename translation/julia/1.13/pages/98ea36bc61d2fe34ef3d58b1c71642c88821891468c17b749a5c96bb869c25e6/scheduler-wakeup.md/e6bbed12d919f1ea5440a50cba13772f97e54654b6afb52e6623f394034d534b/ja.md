# Task scheduler wakeups

このページでは、Juliaのタスクスケジューラで使われるスリープ／起床ハンドシェイクについて説明します。特に、なぜ`jl_wakeup_threadpool`が、すべてのスレッドにブロードキャストするのではなく、マルチキューへの挿入ごとに起こすワーカーを*1つだけ*にできるのかを解説します。

## The problem

マルチキューに入る`@spawn`は、以前は毎回`jl_wakeup_thread(-1)`を呼び出していました。この関数は*すべての*スレッドを走査し、スリープ中の各スレッドに`uv_cond_signal`を発行します。そのため、過剰にスレッドを割り当てたマシンでは、spawnが集中すると、挿入のたびに``O(nthreads)``の「起床ストーム」が発生していました（JuliaLang/julia#61820、JuliaLang/julia#50425）。アイドル状態のワーカーがすべて起こされ、1つの新しいタスクを奪い合い、1つを除く全員がすぐに再びスリープします。

`jl_wakeup_threadpool(tpid)`は、このブロードキャストを置き換えます。マルチキューへの挿入で起こすのは、そのタスクのプール内でスリープ中のワーカーのうち最大1つです。``N``の挿入が連続して行われれば、最大``N``個のワーカーが起こされます。ワーカー間で起床を連鎖させることはありません。起こされたワーカーはタスクを取り出して実行するだけです。

## Why waking one worker is enough

正しさは、ブロードキャスト方式でも使われていた同じストアバッファリング用フェンス（`[^store_buffering_1]`、[`src/scheduler.c`](https://github.com/JuliaLang/julia/blob/master/src/scheduler.c)）に依存します。スレッドごとに成り立つ不変条件は次のとおりです。

> ワーカーは起床側から`sleeping`として観測されるか、まだスリープへの移行を確定していません。その場合はキューを再確認し、新たに挿入されたタスクを見つけることが保証されています。


`jl_task_get_next`におけるコンシューマーのスリープ移行は、次の順序で行われます。

1. `sleep_check_state = sleeping`を公開する。
2. `jl_fence()`。
3. キューを再確認する（`check_empty`）。作業が現れていたらスリープを中止する。
4. `n_threads_running`をデクリメントする。
5. `may_sleep`が成立している間、条件変数で待機する。

エンキュー側は挿入後にフェンスを実行し、候補となる各ワーカーの`sleep_check_state`を調べます。コンシューマーはステップ1で`sleeping`を公開し、ステップ3でキューを再確認するより前にそれを行います。そのため、エンキュー側が`sleeping`を確認してワーカーを起こすか、ワーカー自身がステップ3で新しいタスクを見つけます。どちらの場合も、タスクは処理されます。

## Why the wake must *not* be skipped using `n_threads_running`

`n_threads_running >= jl_n_threads`（「すべて実行中で、待機中のスレッドはいない」）の場合に走査を完全に省略するのは、一見すると有効な最適化に思えます。しかし、これは**正しくありません**。理由は独立に2つあります。

1. **カウントはスレッドごとの状態より遅れて更新される。** `n_threads_running`は、コンシューマーがステップ3でキューを再確認した*後の*ステップ4でデクリメントされます。ステップ1から4までの間、ワーカーは`sleeping`を公開し、キューが空だとすでに確認している可能性がありますが、カウント上はまだ実行中です。そのため、カウントを参照するエンキュー側は「全員実行中」という古い情報を読み取り、実際には必要な起床を省いてしまいます。
2. **カウントはグローバルですが、起床はプール内に限られる。** あるプールのビジー状態のワーカーによって`n_threads_running`が高いままでも、別のプールでは全ワーカーが待機中ということがあります。このとき、プールをまたぐ挿入（たとえば、`:default`ワーカーから`:interactive`タスクをspawnする場合）が無視され、タスクがいつまでも処理されないおそれがあります。

`sleep_check_state`を走査すれば、どちらの問題も回避できます。このフラグはステップ1で、キューの再確認より*前に*設定されるため、危険な時間帯にいるワーカーを走査で見落とすことはありません。また、プールごとに調べられます。

## TLA+ model

[`scheduler-wakeup/`](https://github.com/JuliaLang/julia/tree/master/doc/src/devdocs/scheduler-wakeup)ディレクトリには、このハンドシェイクをモデル化した小さなTLA+モデルがあり、上記の議論を機械的に検証できます。

  * [`SchedulerWake.tla`](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/scheduler-wakeup/SchedulerWake.tla)では、スリープ移行を上記と同じ離散ステップとしてモデル化しています。そのため、モデルチェッカーは、エンキュー側が`sleep_check_state`を走査してワーカーを1つ起こす場合について、この時間帯に起こりうるすべてのインターリーブを調べます。
  * `MCFixed`は、具体的な構成（1つのプールを共有する2つのワーカーと、別プールのプロデューサー）です。TLCは状態空間全体を探索し、デッドロックも`NoLostWakeup`違反も見つけません。

再現するには、[`tla2tools.jar`](https://github.com/tlaplus/tlaplus/releases)を使って次のようにします。

```sh
cd doc/src/devdocs/scheduler-wakeup
java -cp tla2tools.jar tlc2.TLC -config MCFixed.cfg MCFixed.tla
```

モデルを、正しくない`n_threads_running`の短絡処理に戻し（`nrun >= N`の場合に`Wakeup`が早期にreturnするようにすると）、TLCは`NoLostWakeup`違反を報告します。これにより、前述の危険な時間帯が実際に存在することを確認できます。

## The event loop thread

スレッド化された領域の外では、1つのスレッド（`io_loop_tid`。通常はスレッド0）だけがlibuvイベントループを実行します。ほかにすることがなくなると、そのスレッドは`sleeping`を公開し、iolock（`jl_uv_mutex`）を保持したまま`uv_run(loop, UV_RUN_ONCE)`を実行します。その後もループがアイドル状態（`uv_run`が0を返す）で、その間に誰も起こしていなければ、条件変数で待機します。

ほかのスレッドはiolockを保持してlibuvハンドル（`uv_poll_start`、`uv_timer_start`など）を登録しますが、それらのハンドルを処理させるためにループを実行することはありません。代わりに、スリープに入るスレッドはiolockを確認します。ロックが空いていれば`io_loop_tid`を起こし、自分が登録したハンドルが監視されるようにします。ロックが保持されていれば、ロックの保持者に任せます。通常は、どの保持者も必要な処理を行います。別のスレッドが自分自身のスリープ時に同じ確認を行うか、イベントループのスレッドがまさに`uv_run`を実行しようとしている（その場合はハンドルが認識される）か、すでに実行中だからです。

例外は、`uv_run`の後のイベントループスレッドです。`JL_UV_UNLOCK`は保留中のファイナライザを実行し、libuvを利用するオブジェクト（`uvfinalize`）のファイナライザはiolockを取得します。ロックが解放された後、別のスレッドがハンドルを登録することがあります。そのスレッドがロックの所有者を確認する前にファイナライザが再びiolockを取得すると、スレッドは起床を省略します。その後、イベントループのスレッドは先ほどのアイドル判定に基づいて待機に入り、ループを再実行するスレッドがいなくなります。

ロックの解放によってアイドル判定が無効になる可能性があるため、`jl_task_get_next`は、待機に入る前にループがまだアイドル状態かどうかを再確認します。trylockでiolockを取得し、ファイナライザを実行せずにロックを解放します。iolockが使用中なら、待機せずに再試行します。

[`IoLoopWake.tla`](https://github.com/JuliaLang/julia/blob/master/doc/src/devdocs/scheduler-wakeup/IoLoopWake.tla)は、スレッド化された領域の外でのこの引き継ぎをモデル化しています。iolockの競合と、ループの実行前およびロック解放後にiolockを取得するファイナライザも含まれます。一方、`uv_run`内でのブロッキングとシャットダウンは抽象化しており、グローバルに取り残された登録済みハンドルがないことを検証します。別のスレッドが実行を続けている間に、最終的にIOが処理されることまでは検証しません。`IoLoopWake.cfg`を使うと、指定した境界内ではTLCは`NoLostWakeup`違反を見つけません。`IoLoopWakeUnfixed.cfg`ではこのチェックを省略するため、反例が生成されます。

```sh
cd doc/src/devdocs/scheduler-wakeup
java -cp tla2tools.jar tlc2.TLC -config IoLoopWake.cfg IoLoopWake.tla
java -cp tla2tools.jar tlc2.TLC -config IoLoopWakeUnfixed.cfg IoLoopWake.tla
```
