```julia
Const(A::Array)
```

Mark an Array as constant/read-only. The invariant guaranteed is that you will not modify an Array (through another reference) within an `@aliasscope` scope.

!!! warning
    Experimental API. Subject to change without deprecation.

