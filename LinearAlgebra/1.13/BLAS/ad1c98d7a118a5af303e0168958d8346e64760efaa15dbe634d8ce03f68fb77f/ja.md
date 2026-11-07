```julia
get_num_threads()
```

BLASライブラリが使用しているスレッド数を取得します。

!!! compat "Julia 1.6"
    `get_num_threads`にはJulia 1.6以降が必要です。


!!! note
    Apple Accelerateなど、一部のBLASライブラリでは、使用するスレッド数を固定できません。これらのバックエンドでは、`get_num_threads()`は常に`1`を返します。[`set_num_threads`](@ref)も参照してください。

