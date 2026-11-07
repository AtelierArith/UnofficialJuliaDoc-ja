```julia
close(io::IO)
```

Close `io`. Performs a [`flush`](@ref) first.

Closing an IO signals that its underlying resources (OS handle, network connections, etc) should be destroyed. A closed IO is in an undefined state and should not be written to or read from. When attempting to do so, the IO may throw an exception, continue to behave normally, or read/write zero bytes, depending on the implementation. However, implementations should make sure that reading to or writing from a closed IO does not cause undefined behaviour.

See also: [`isopen`](@ref)
