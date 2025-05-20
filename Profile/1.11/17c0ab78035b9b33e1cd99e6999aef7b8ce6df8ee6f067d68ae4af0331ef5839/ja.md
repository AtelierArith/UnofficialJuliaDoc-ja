```
プロファイル
```

プロファイリングサポート。

## CPUプロファイリング

  * `@profile foo()` で特定の呼び出しをプロファイルします。
  * `Profile.print()` でレポートを印刷します。
  * `Profile.clear()` でバッファをクリアします。
  * プロセスにSIGUSR1（Linuxの場合）またはSIGINFO（macOS/BSDの場合）信号を送信して、自動的にプロファイルをトリガーし、印刷します。つまり、`kill -s SIGUSR1/SIGINFO 1234`、ここで1234はjuliaプロセスのpidです。macOSおよびBSDプラットフォームでは、`ctrl-t`を直接使用できます。

## メモリプロファイリング

  * `Profile.Allocs.@profile [sample_rate=0.1] foo()` で特定の呼び出し内の割り当てをサンプリングします。サンプルレートが1.0の場合はすべてを記録し、0.0の場合は何も記録しません。
  * `Profile.Allocs.print()` でレポートを印刷します。
  * `Profile.Allocs.clear()` でバッファをクリアします。

## ヒーププロファイリング

  * `Profile.take_heap_snapshot()` でヒープの`.heapsnapshot`レコードを記録します。
  * `JULIA_PROFILE_PEEK_HEAP_SNAPSHOT=true`を設定して、SIGUSR1信号が送信されたときにヒープスナップショットをキャプチャします。
