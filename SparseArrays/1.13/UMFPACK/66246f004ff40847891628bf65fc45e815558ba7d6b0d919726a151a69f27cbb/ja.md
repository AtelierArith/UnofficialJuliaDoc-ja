```julia
copy(F::UmfpackLU, [ws::UmfpackWS])::UmfpackLU
```

マルチスレッドの求解処理で使用する UmfpackLU の浅いコピーです。この関数は、作業領域、制御フィールド、情報フィールド、ロックフィールドを複製します。
