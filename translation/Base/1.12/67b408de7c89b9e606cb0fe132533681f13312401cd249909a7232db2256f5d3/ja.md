```julia
OncePerTask{T}(init::Function)() -> T
```

`OncePerTask`オブジェクトを呼び出すと、関数`initializer`をTaskごとに正確に1回実行することで、型`T`の値が返されます。同じTask内のすべての将来の呼び出しは、正確に同じ値を返します。

関連情報: [`task_local_storage`](@ref).

!!! compat "Julia 1.12"
    この型はJulia 1.12以降が必要です。


## 例

```jldoctest
julia> const task_state = Base.OncePerTask{Vector{UInt32}}() do
           println("Lazy task valueを作成中...完了。")
           return [Libc.rand()]
       end;

julia> (taskvec = task_state()) |> typeof
Lazy task valueを作成中...完了。
Vector{UInt32} (alias for Array{UInt32, 1})

julia> taskvec === task_state()
true

julia> taskvec === fetch(@async task_state())
Lazy task valueを作成中...完了。
false
```
