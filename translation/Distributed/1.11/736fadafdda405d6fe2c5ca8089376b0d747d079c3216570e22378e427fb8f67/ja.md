```julia
put!(rr::RemoteChannel, args...)
```

[`RemoteChannel`](@ref)に値のセットを格納します。チャネルが満杯の場合、スペースが利用可能になるまでブロックします。最初の引数を返します。
