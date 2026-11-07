```julia
Profile
```

プロファイリングのサポート。

## CPU profiling

  * 特定の呼び出しをプロファイルするには、`@profile foo()` を使用します。
  * レポートを出力するには、`Profile.print()` を使用します。対応するターミナルではパスがクリック可能なリンクになり、JULIA_EDITOR などに合わせて調整されます。
  * バッファをクリアするには、`Profile.clear()` を使用します。
  * プロセスに SIGUSR1（Linux）または SIGINFO（macOS/BSD）のシグナルを送信すると、プロファイルが自動的に取得され、出力されます。つまり、`kill -s SIGUSR1/SIGINFO 1234` のようにします。ここで 1234 は Julia プロセスの PID です。macOS および BSD では、`ctrl-t` を直接使用できます。

## Memory profiling

  * 特定の呼び出し内のアロケーションをサンプリングするには、`Profile.Allocs.@profile [sample_rate=0.1] foo()` を使用します。サンプルレートが 1.0 の場合はすべてを記録し、0.0 の場合は何も記録しません。
  * レポートを出力するには、`Profile.Allocs.print()` を使用します。
  * バッファをクリアするには、`Profile.Allocs.clear()` を使用します。

## Heap profiling

  * ヒープの `.heapsnapshot` レコードを記録するには、`Profile.take_heap_snapshot()` を使用します。
  * SIGINFO（ctrl-t）シグナルの送信時にヒープスナップショットを取得するには、`JULIA_PROFILE_PEEK_HEAP_SNAPSHOT=true` を設定します。
