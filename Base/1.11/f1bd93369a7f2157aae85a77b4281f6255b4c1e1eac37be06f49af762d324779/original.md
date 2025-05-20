```
istaskstarted(t::Task) -> Bool
```

Determine whether a task has started executing.

# Examples

```jldoctest
julia> a3() = sum(i for i in 1:1000);

julia> b = Task(a3);

julia> istaskstarted(b)
false
```
