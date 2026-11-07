```julia
close(c::Channel[, excp::Exception])
```

チャネルを閉じます。次の場合、（省略可能な `excp` を指定して）例外がスローされます。

  * 閉じたチャネルに対する [`put!`](@ref)。
  * 空で閉じたチャネルに対する [`take!`](@ref) および [`fetch`](@ref)。
