```
Module
```

A `Module` is a separate global variable workspace. See [`module`](@ref) and the [manual section about modules](@ref modules) for details.

```
Module(name::Symbol=:anonymous, std_imports=true, default_names=true)
```

Return a module with the specified name. A `baremodule` corresponds to `Module(:ModuleName, false)`

An empty module containing no names at all can be created with `Module(:ModuleName, false, false)`. This module will not import `Base` or `Core` and does not contain a reference to itself.
