```julia
OncePerProcess{T}(init::Function)() -> T
```

`OncePerProcess` オブジェクトを呼び出すと、プロセスごとに関数 `initializer` がちょうど1回実行され、その戻り値として型 `T` の値が返されます。同じプロセス内での並行呼び出しや、それ以降の呼び出しでは、常にまったく同じ値が返されます。これは、事前コンパイルされるコードで、シリアライズされないキャッシュやその他の状態を設定する場合に便利です。

!!! compat "Julia 1.12"
    この型を使用するには、Julia 1.12 以降が必要です。


## Example

```jldoctest
julia> const global_state = Base.OncePerProcess{Vector{UInt32}}() do
           println("Making lazy global value...done.")
           return [Libc.rand()]
       end;

julia> (procstate = global_state()) |> typeof
Making lazy global value...done.
Vector{UInt32} (alias for Array{UInt32, 1})

julia> procstate === global_state()
true

julia> procstate === fetch(@async global_state())
true
```
