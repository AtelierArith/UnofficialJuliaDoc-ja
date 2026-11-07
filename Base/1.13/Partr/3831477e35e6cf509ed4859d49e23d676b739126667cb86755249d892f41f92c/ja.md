```julia
rand_ptls(max::UInt32)
```

スレッドローカルの RNG 状態を使って、`0:max-1` の範囲内のランダムな UInt32 を返します。Max は 0 より大きくなければなりません。
