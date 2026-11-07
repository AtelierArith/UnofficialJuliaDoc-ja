```julia
OncePerTask{T}(init::Function)() -> T
```

`OncePerTask` オブジェクトを呼び出すと、Task ごとに関数 `initializer` がちょうど 1 回実行され、`T` 型の値が返されます。同じ Task 内で以降に呼び出した場合は、常にまったく同じ値が返されます。

関連項目: [`task_local_storage`](@ref)。

!!! compat "Julia 1.12"
    この型を使用するには Julia 1.12 以降が必要です。


## Example

```jldoctest
julia> const task_state = Base.OncePerTask{Vector{UInt32}}() do
           println("Making lazy task value...done.")
           return [Libc.rand()]
       end;

julia> (taskvec = task_state()) |> typeof
Making lazy task value...done.
Vector{UInt32} (alias for Array{UInt32, 1})

julia> taskvec === task_state()
true

julia> taskvec === fetch(@async task_state())
Making lazy task value...done.
false
```
