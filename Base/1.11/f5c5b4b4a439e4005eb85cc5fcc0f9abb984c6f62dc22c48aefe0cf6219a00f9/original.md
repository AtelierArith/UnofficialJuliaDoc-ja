```
WeakKeyDict([itr])
```

`WeakKeyDict()` constructs a hash table where the keys are weak references to objects which may be garbage collected even when referenced in a hash table.

See [`Dict`](@ref) for further help.  Note, unlike [`Dict`](@ref), `WeakKeyDict` does not convert keys on insertion, as this would imply the key object was unreferenced anywhere before insertion.

See also [`WeakRef`](@ref).
