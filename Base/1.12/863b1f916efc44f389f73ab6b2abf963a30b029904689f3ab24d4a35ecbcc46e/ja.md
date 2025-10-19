```julia
disable_sigint(f::Function)
```

現在のタスクで関数の実行中にCtrl-Cハンドラを無効にします。これは、割り込みに安全でないJuliaコードを呼び出す可能性のある外部コードを呼び出すために使用されます。次のように`do`ブロック構文を使用して呼び出すことを意図しています：

```julia
disable_sigint() do
    # 割り込みに安全でないコード
    ...
end
```

ワーカースレッド（`Threads.threadid() != 1`）では必要ありません。なぜなら、`InterruptException`はマスタースレッドにのみ送信されるからです。JuliaコードやJuliaランタイムを呼び出さない外部関数は、その実行中に自動的にsigintを無効にします。
