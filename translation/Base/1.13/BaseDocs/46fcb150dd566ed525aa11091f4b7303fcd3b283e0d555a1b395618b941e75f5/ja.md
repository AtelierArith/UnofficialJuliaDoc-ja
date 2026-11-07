```julia
setfieldonce!(value, name::Union{Int,Symbol}, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> success::Bool
```

フィールドがまだ設定されていない場合に限り、指定した値を設定する操作をアトミックに実行します。

```julia
ok = !isdefined(value, name, fail_order)
if ok
    setfield!(value, name, desired, success_order)
end
return ok
```

!!! compat "Julia 1.11"
    この関数を使用するには、Julia 1.11 以降が必要です。

