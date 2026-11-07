```julia
disable_sigint(f::Function)
```

現在のタスクで関数を実行している間、Ctrl-C ハンドラーを無効にします。これは、割り込み安全でない Julia コードを呼び出す可能性のある外部コードを呼び出す場合に使用します。次のように `do` ブロック構文で呼び出すことを想定しています。

```julia
disable_sigint() do
    # interrupt-unsafe code
    ...
end
```

ワーカースレッド（`Threads.threadid() != 1`）では、`InterruptException` はマスタースレッドにのみ送信されるため、これは必要ありません。Julia コードや Julia ランタイムを呼び出さない外部関数は、実行中に sigint を自動的に無効にします。
