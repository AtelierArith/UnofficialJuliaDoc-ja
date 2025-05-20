```
setfieldonce!(value, name::Union{Int,Symbol}, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> success::Bool
```

与えられた値にフィールドを設定する操作を原子的に実行します。ただし、以前に設定されていなかった場合のみ実行します。

```
ok = !isdefined(value, name, fail_order)
if ok
    setfield!(value, name, desired, success_order)
end
return ok
```

!!! compat "Julia 1.11"
    この関数はJulia 1.11以降が必要です。

