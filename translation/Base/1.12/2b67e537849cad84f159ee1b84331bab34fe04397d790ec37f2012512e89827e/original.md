```julia
PersistentDict
```

`PersistentDict` is a dictionary implemented as an hash array mapped trie, which is optimal for situations where you need persistence, each operation returns a new dictionary separate from the previous one, but the underlying implementation is space-efficient and may share storage across multiple separate dictionaries.

!!! note
    It behaves like an IdDict.


```julia
PersistentDict(KV::Pair)
```

# Examples

```jldoctest
julia> dict = Base.PersistentDict(:a=>1)
Base.PersistentDict{Symbol, Int64} with 1 entry:
  :a => 1

julia> dict2 = Base.delete(dict, :a)
Base.PersistentDict{Symbol, Int64}()

julia> dict3 = Base.PersistentDict(dict, :a=>2)
Base.PersistentDict{Symbol, Int64} with 1 entry:
  :a => 2
```
