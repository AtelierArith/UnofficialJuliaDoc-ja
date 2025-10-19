```julia
close(c::Channel[, excp::Exception])
```

Close a channel. An exception (optionally given by `excp`), is thrown by:

  * [`put!`](@ref) on a closed channel.
  * [`take!`](@ref) and [`fetch`](@ref) on an empty, closed channel.
