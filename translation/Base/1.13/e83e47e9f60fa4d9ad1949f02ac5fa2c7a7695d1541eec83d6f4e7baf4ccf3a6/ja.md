```julia
istaskfailed(t::Task)::Bool
```

例外がスローされたためにタスクが終了したかどうかを判定します。

# Examples

```jldoctest
julia> a4() = error("task failed");

julia> b = Task(a4);

julia> istaskfailed(b)
false

julia> schedule(b);

julia> yield();

julia> istaskfailed(b)
true
```

!!! compat "Julia 1.3"
    この関数を使用するには、Julia 1.3 以降が必要です。

