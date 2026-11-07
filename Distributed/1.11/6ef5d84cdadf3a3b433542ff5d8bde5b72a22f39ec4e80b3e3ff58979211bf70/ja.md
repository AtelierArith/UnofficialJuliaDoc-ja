```julia
RemoteException(captured)
```

リモート計算で発生した例外は捕捉され、ローカルで再スローされます。`RemoteException` は、ワーカーの `pid` と捕捉された例外をラップします。`CapturedException` は、リモート例外と、例外発生時の呼び出しスタックをシリアライズ可能な形式で捕捉します。
