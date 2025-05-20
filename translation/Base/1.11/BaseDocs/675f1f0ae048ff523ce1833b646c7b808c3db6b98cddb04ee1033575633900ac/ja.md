```
baremodule
```

`baremodule`は、`using Base`や[`eval`](@ref Main.eval)および[`include`](@ref Base.include)のローカル定義を含まないモジュールを宣言します。それでも`Core`はインポートします。言い換えれば、

```julia
module Mod

...

end
```

は次のように等価です。

```julia
baremodule Mod

using Base

eval(x) = Core.eval(Mod, x)
include(p) = Base.include(Mod, p)

...

end
```
