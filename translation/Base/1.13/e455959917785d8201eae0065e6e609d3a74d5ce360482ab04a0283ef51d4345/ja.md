```julia
close(c::Channel[, excp::Exception])
```

チャネルを閉じます。次の場合に例外（省略可能な `excp` で指定）がスローされます。

  * 閉じたチャネルに対する [`put!`](@ref)。
  * 空で閉じたチャネルに対する [`take!`](@ref) および [`fetch`](@ref)。
