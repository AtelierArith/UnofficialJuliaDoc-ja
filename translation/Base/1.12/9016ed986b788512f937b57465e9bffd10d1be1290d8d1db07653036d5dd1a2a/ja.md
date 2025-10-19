```julia
retry(f;  delays=ExponentialBackOff(), check=nothing) -> Function
```

関数 `f` を呼び出す無名関数を返します。例外が発生した場合、`check` が `true` を返すたびに、`delays` で指定された秒数待った後に `f` が繰り返し呼び出されます。`check` は `delays` の現在の状態と `Exception` を入力する必要があります。

!!! compat "Julia 1.2"
    Julia 1.2 より前は、このシグネチャは `f::Function` に制限されていました。


# 例

```julia
retry(f, delays=fill(5.0, 3))
retry(f, delays=rand(5:10, 2))
retry(f, delays=Base.ExponentialBackOff(n=3, first_delay=5, max_delay=1000))
retry(http_get, check=(s,e)->e.status == "503")(url)
retry(read, check=(s,e)->isa(e, IOError))(io, 128; all=false)
```
