```julia
remotecall_fetch(f, id::Integer, args...; kwargs...)
```

`fetch(remotecall(...))` を1つのメッセージ内で実行します。キーワード引数がある場合は、`f` に渡されます。リモートで発生した例外は [`RemoteException`](@ref) に格納され、スローされます。

[`fetch`](@ref) と [`remotecall`](@ref) も参照してください。

# Examples

```julia-repl
$ julia -p 2

julia> remotecall_fetch(sqrt, 2, 4)
2.0

julia> remotecall_fetch(sqrt, 2, -4)
ERROR: On worker 2:
DomainError with -4.0:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
...
```
