```julia
LibGit2.CredentialPayload
```

同じURLに対する資格情報コールバックへの複数回の呼び出しの間に状態を保持します。異なるURLで使用される場合は、`CredentialPayload`インスタンスは`reset!`されることが期待されます。
