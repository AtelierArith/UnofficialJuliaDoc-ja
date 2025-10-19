```julia
istaskfailed(t::Task) -> Bool
```

タスクが例外がスローされたために終了したかどうかを判断します。

# 例

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
    この関数は少なくともJulia 1.3が必要です。

