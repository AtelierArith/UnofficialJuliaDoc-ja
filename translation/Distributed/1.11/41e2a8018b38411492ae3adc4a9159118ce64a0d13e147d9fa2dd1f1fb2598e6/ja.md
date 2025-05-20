```
isready(rr::Future)
```

[`Future`](@ref) に値が格納されているかどうかを判断します。

引数 `Future` が別のノードによって所有されている場合、この呼び出しは応答を待つためにブロックします。`rr` を別のタスクで待機するか、ローカルの [`Channel`](@ref) をプロキシとして使用することをお勧めします：

```julia
p = 1
f = Future(p)
errormonitor(@async put!(f, remotecall_fetch(long_computation, p)))
isready(f)  # ブロックしない
```
