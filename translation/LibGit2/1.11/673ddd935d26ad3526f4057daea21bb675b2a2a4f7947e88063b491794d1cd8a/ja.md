```julia
LibGit2.CredentialPayload
```

同じ URL に対する認証情報コールバックが複数回呼び出される間、状態を保持します。異なる URL で使用する場合は、`CredentialPayload` のインスタンスが `reset!` であることが想定されています。
