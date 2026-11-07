```julia
Compiler.reset_timings()
```

以前に記録された型推論の計測時間（`Compiler._timings`）を消去し、ROOT() タイマーを再び開始します。`ROOT()` は、型推論の*外部*で費やされたすべての時間を計測します。
