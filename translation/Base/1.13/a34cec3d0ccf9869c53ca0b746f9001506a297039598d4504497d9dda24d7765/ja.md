```julia
memoryindex(ref::GenericMemoryRef)::Int
```

`GenericMemory`内での`ref`の1始まりのインデックスを取得します。

# Examples

```jldoctest
julia> mem = Memory{String}(undef, 10);

julia> ref = Base.memoryindex(memoryref(mem, 3))
3

julia> Base.memoryindex(memoryref(Memory{Nothing}(undef, 10), 8))
8
```

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13以降が必要です。

