```julia
OncePerProcess{T}(init::Function)() -> T
```

`OncePerProcess`オブジェクトを呼び出すと、関数`initializer`をプロセスごとに正確に1回実行することで、型`T`の値が返されます。同じプロセス内のすべての同時および将来の呼び出しは、正確に同じ値を返します。これは、キャッシュやシリアル化されない他の状態を設定できるため、事前コンパイルされるコードで便利です。

!!! compat "Julia 1.12"
    この型はJulia 1.12以降が必要です。


## 例

```jldoctest
julia> const global_state = Base.OncePerProcess{Vector{UInt32}}() do
           println("Lazy global valueを作成中...完了。")
           return [Libc.rand()]
       end;

julia> (procstate = global_state()) |> typeof
Lazy global valueを作成中...完了。
Vector{UInt32} (alias for Array{UInt32, 1})

julia> procstate === global_state()
true

julia> procstate === fetch(@async global_state())
true
```
