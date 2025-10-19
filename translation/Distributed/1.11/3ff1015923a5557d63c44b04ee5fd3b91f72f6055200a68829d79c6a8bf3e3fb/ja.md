```julia
RemoteException(captured)
```

リモート計算での例外はキャプチャされ、ローカルで再スローされます。`RemoteException`は、ワーカーの`pid`とキャプチャされた例外をラップします。`CapturedException`は、リモート例外と例外が発生したときのコールスタックのシリアライズ可能な形式をキャプチャします。
