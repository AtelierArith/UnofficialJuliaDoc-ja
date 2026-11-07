# GC Debug Build Tools

Juliaのガベージコレクターには、`WITH_GC_DEBUG_ENV=1`を指定してJuliaをビルドすると有効になる、一連のデバッグツールが含まれています。これらのツールを使うと、書き込みバリアの欠落、解放後使用エラー、GCルートの誤りなど、メモリ安全性に関するバグを診断できます。

## Building with GC Debug Support

Juliaをビルドする前に、`Make.user`ファイルに次の行を追加してください。

```make
WITH_GC_DEBUG_ENV=1
```

これにより、Cプリプロセッサの定義`GC_DEBUG_ENV`が設定され、以下で説明する複数のデバッグ機能が有効になります。また、`GC_VERIFY`も自動的に有効になります（[GC Verification](@ref GC_VERIFY)を参照）。

`Make.user`を変更した後にJuliaを再ビルドするには、次のようにします。

```sh
make -j
```

!!! note
    AddressSanitizerのビルド設定（`contrib/asan/Make.user.asan`）では、`WITH_GC_DEBUG_ENV=1`がデフォルトで有効になります。ASANはプール割り当てを`malloc`/`free`に置き換えるため、GCデバッグ用の環境変数もこのモデルに合わせて設定されます。


## Environment Variables

`WITH_GC_DEBUG_ENV=1`を指定してJuliaをビルドすると、起動時に次の環境変数が認識されます。

### `JULIA_GC_WAIT_FOR_DEBUGGER`

`0`以外の値に設定すると、書き込みバリア違反が`GC_VERIFY`によって検出された場合など、重大なGCエラーが検出されたときに、GCは直ちに異常終了する代わりに一時停止し、デバッガーの接続を待ちます。

```sh
JULIA_GC_WAIT_FOR_DEBUGGER=1 ./julia myscript.jl
```

プロセスが停止したら、次のコマンドでデバッガーを接続します。

```sh
gdb -p <PID>
```

### `JULIA_GC_ALLOC_POOL`, `JULIA_GC_ALLOC_OTHER`, `JULIA_GC_ALLOC_PRINT`

次の3つの変数は、割り当て回数に基づいてGCを実行するタイミングや統計情報を出力するタイミングを制御します。いずれも共通の形式を使います。

```
[r]<min>:<interv>:<max>
```

|      フィールド |                          意味 |
| ----------:| ---------------------------:|
|      `min` |            最初のトリガーまでの割り当て回数 |
|   `interv` |                 以降のトリガー間の間隔 |
|      `max` | トリガーする割り当て回数の上限（デフォルト：上限なし） |
| `r` prefix | 平均頻度を保ちながら、トリガーのタイミングをランダム化 |

3つのフィールドはいずれも省略できます。例：

|           設定 |                               効果 |
| ------------:| --------------------------------:|
|          `1` |                     割り当てのたびにトリガー |
|     `100:10` | 割り当て100回目に初回トリガーし、その後は10回ごとにトリガー |
|   `50:1:200` |         割り当て50回目から200回目まで、毎回トリガー |
| `r1000:1000` |   割り当て約1000回ごとに、ランダムな揺らぎを伴ってトリガー |

**`JULIA_GC_ALLOC_POOL`** — 小さなオブジェクト（プール割り当て）の割り当てを契機とするGCを制御します。プール割り当てのたびにカウンターが増加します。

**`JULIA_GC_ALLOC_OTHER`** — 大きなオブジェクト（プール外で`malloc`を使って割り当てられるオブジェクト）の割り当てを契機とするGCを制御します。大きなオブジェクトを割り当てるたびにカウンターが増加します。

**`JULIA_GC_ALLOC_PRINT`** — 割り当て統計を`stderr`に出力するタイミングを制御します。トリガーされるたびに、次のような行が出力されます。

```
Allocations: 12345 (Pool: 10000; Other: 2345); GC: 7
```

#### Example: trigger GC on every allocation

これは最も負荷の高いストレステストモードです。割り当てのたびに完全なGCサイクルを実行するため、バグがはるかに見つかりやすくなります。

```sh
JULIA_GC_ALLOC_POOL=1 JULIA_GC_ALLOC_OTHER=1 ./julia myscript.jl
```

#### Example: randomised stress testing

`r`プレフィックスを使うと、指定した間隔の中でGCのトリガーがランダムに分散されます。固定間隔では特定の割り当て回数でしか発生しないバグも、これによって見つかることがあります。

```sh
JULIA_GC_ALLOC_POOL=r1:1 JULIA_GC_ALLOC_OTHER=r1:1 ./julia myscript.jl
```

## [GC Verification (`GC_VERIFY`)](@id GC_VERIFY)

`WITH_GC_DEBUG_ENV=1`を有効にすると、`GC_VERIFY`も自動的に有効になります。マイナー（高速）GCのたびに、次の処理を行う2回目の完全なGCパスが実行されます。

1. すべてのマークビットをクリアする。
2. すべてのルートから再度マークする。
3. 解放される予定だった各オブジェクトが、新しいマークフェーズでも到達不能であることを確認する。

2回目のパスで生存しているオブジェクトが見つかり、それが1回目のパスで回収対象になっていた場合、書き込みバリアが欠落しています。検証器はその後、オブジェクトグラフをさかのぼって、対応する`jl_gc_wb()`呼び出しなしに書き込まれた親オブジェクトを特定し、次のようなメッセージを出力します。

```
Missing write barrier found !
<parent> was written a reference to <child> that was not recorded
```

診断メッセージの出力後、プロセスは異常終了します（または、`JULIA_GC_WAIT_FOR_DEBUGGER=1`が設定されていればデバッガーを待ちます）。

!!! note
    `GC_VERIFY`は、シングルスレッドGCでのみ使用できます。`julia`をGCスレッド（`--gcthreads`）付きで起動した場合、検証は通知なくスキップされます。


### Tips for debugging write barrier violations

1. **GC_VERIFYを有効にして再現する。** `WITH_GC_DEBUG_ENV=1`を指定してビルドし、問題が発生するワークロードを実行します。検証器が違反を検出し、書き込みバリアなしで書き込まれたオブジェクトとスロットを出力します。
2. **再現可能なアドレスを得るためにASLRを無効にする。** 特定のメモリ位置にハードウェアウォッチポイントを設定する必要がある場合は、次のようにします。

   ```sh
   echo 0 | sudo tee /proc/sys/kernel/randomize_va_space
   ```

   これにより、同じバイナリと環境であれば、実行ごとにアドレスが安定します。
3. **GDBでハードウェアウォッチポイントを使う。** 誤って書き込まれたスロットのアドレスが分かったら、GDBを接続してウォッチポイントを設定します。

   ```
   watch *slot_addr if *slot_addr == expected_val
   ```

   これにより、書き込みが発生した瞬間に実行が停止します。
4. **決定論的なリプレイには`rr`を使う。** [`rr`](https://rr-project.org/)はプロセスの実行を記録し、同じ命令、同じアドレスで完全に再生できるため、GDBでプログラムを逆方向に実行できます。根本原因から離れた場所で障害が表面化するGCバグの調査に特に役立ちます。

   ```sh
   rr record ./julia myscript.jl
   rr replay
   ```

   リプレイセッションでは、`reverse-continue`（`rc`）や`reverse-next`（`rn`）などの逆実行コマンドを使い、クラッシュ地点から問題の書き込みが発生した瞬間までさかのぼれます。`rr`はASLRを無効にし、固定の乱数シードでリプレイするため、記録と再生の間でアドレスが安定します。そのため、ASLRを手動で無効にしなくてもウォッチポイントを確実に利用できます。

## Related Tools

  * [Using Valgrind with Julia](@ref) — `MEMDEBUG`とValgrindの`memcheck`ツールを使って、メモリエラーやメモリリークを検出します。
  * [Sanitizer support](@ref) — AddressSanitizerまたはThreadSanitizerを使ってJuliaをビルドします。ASANの設定では`WITH_GC_DEBUG_ENV=1`が自動的に設定されます。
  * [Static analyzer annotations for GC correctness in C code](@ref) — Cソースファイル内の`JL_GC_PUSH`や書き込みバリアの注釈の欠落を検査する静的解析ツールです。
