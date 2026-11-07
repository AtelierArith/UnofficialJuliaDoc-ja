```julia
set_num_threads(n::Integer)
set_num_threads(::Nothing)
```

BLASライブラリが使用するスレッド数を`n::Integer`に設定します。

`nothing`も指定できます。この場合、juliaはデフォルトのスレッド数を推測しようとします。`nothing`を渡すことは推奨されません。主に歴史的な理由で残されています。

!!! note
    Apple Accelerateなど、一部のBLASライブラリは使用するスレッド数を固定できません。これらのバックエンドでは、`set_num_threads()`は何も行いません。[`get_num_threads`](@ref)も参照してください。

