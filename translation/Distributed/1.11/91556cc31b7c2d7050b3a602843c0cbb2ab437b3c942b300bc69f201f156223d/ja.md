```julia
isready(rr::Future)
```

[`Future`](@ref)に値が格納されているかどうかを判定します。

引数`Future`が別のノードに所有されている場合、この呼び出しは応答を待つためにブロックします。代わりに、別のタスクで`rr`を待つか、ローカルの[`Channel`](@ref)をプロキシとして使用することをおすすめします。

```julia
p = 1
f = Future(p)
errormonitor(@async put!(f, remotecall_fetch(long_computation, p)))
isready(f)  # will not block
```
