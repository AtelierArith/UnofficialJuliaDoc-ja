```julia
retry(f;  delays=ExponentialBackOff(), check=nothing) -> Function
```

`f` を呼び出す無名関数を返します。例外が発生した場合、`check` が `true` を返すたびに、`delays` で指定された秒数だけ待機してから、`f` を繰り返し呼び出します。`check` には、`delays` の現在の状態と `Exception` を渡します。

!!! compat "Julia 1.2"
    Julia 1.2 より前では、このシグネチャは `f::Function` に制限されていました。


# Examples

```julia
retry(f, delays=fill(5.0, 3))
retry(f, delays=rand(5:10, 2))
retry(f, delays=Base.ExponentialBackOff(n=3, first_delay=5, max_delay=1000))
retry(http_get, check=(s,e)->e.status == "503")(url)
retry(read, check=(s,e)->isa(e, IOError))(io, 128; all=false)
```
