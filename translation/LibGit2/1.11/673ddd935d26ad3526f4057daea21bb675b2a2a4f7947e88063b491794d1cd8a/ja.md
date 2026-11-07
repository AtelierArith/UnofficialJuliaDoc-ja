```julia
LibGit2.CredentialPayload
```

同じ URL に対する認証情報コールバックの複数回の呼び出し間で状態を保持します。異なる URL で使用する場合は、`CredentialPayload` のインスタンスを `reset!` にする必要があります。
