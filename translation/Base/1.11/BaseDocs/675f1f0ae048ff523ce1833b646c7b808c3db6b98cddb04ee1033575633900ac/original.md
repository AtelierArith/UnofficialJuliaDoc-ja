```
baremodule
```

`baremodule` declares a module that does not contain `using Base` or local definitions of [`eval`](@ref Main.eval) and [`include`](@ref Base.include). It does still import `Core`. In other words,

```julia
module Mod

...

end
```

is equivalent to

```julia
baremodule Mod

using Base

eval(x) = Core.eval(Mod, x)
include(p) = Base.include(Mod, p)

...

end
```
