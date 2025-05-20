```
remotecall_fetch(f, id::Integer, args...; kwargs...)
```

`fetch(remotecall(...))`を1つのメッセージで実行します。キーワード引数がある場合、それらは`f`に渡されます。リモート例外は[`RemoteException`](@ref)にキャプチャされ、スローされます。

他に[`fetch`](@ref)と[`remotecall`](@ref)も参照してください。

# 例

```julia-repl
$ julia -p 2

julia> remotecall_fetch(sqrt, 2, 4)
2.0

julia> remotecall_fetch(sqrt, 2, -4)
ERROR: On worker 2:
DomainError with -4.0:
sqrtは負の実引数で呼び出されましたが、複素引数で呼び出された場合にのみ複素結果を返します。sqrt(Complex(x))を試してください。
...
```
