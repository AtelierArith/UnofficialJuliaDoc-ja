```julia
put!(rr::RemoteChannel, args...)
```

値の集合を[`RemoteChannel`](@ref)に格納します。チャネルが満杯の場合は、空きができるまでブロックします。最初の引数を返します。
