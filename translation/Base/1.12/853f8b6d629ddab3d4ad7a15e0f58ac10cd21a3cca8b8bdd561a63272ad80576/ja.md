```julia
open(f::Function, command, args...; kwargs...)
```

`open(command, args...; kwargs...)`と似ていますが、結果のプロセスストリームで`f(stream)`を呼び出し、その後入力ストリームを閉じてプロセスの完了を待ちます。成功した場合は`f`が返す値を返します。プロセスが失敗した場合や、プロセスがstdoutに何かを印刷しようとした場合はエラーをスローします。
