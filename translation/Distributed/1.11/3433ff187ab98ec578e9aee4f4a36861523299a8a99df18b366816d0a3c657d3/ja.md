```
put!(rr::RemoteChannel, args...)
```

[`RemoteChannel`](@ref)に値のセットを格納します。チャネルが満杯の場合、空きが出るまでブロックします。最初の引数を返します。
