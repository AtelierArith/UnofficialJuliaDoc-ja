```julia
baremodule
```

`baremodule` は、`using Base` を含まず、[`eval`](@ref Main.eval) と [`include`](@ref Base.include) のローカル定義も持たないモジュールを宣言します。ただし、`Core` はインポートします。つまり、

```julia
module Mod

...

end
```

と同等です。

```julia
baremodule Mod

using Base

eval(x) = Core.eval(Mod, x)
include(p) = Base.include(Mod, p)

...

end
```
