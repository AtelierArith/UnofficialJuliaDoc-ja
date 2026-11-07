```julia
replacefield!(value, name::Symbol, expected, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
replacefield!(value, i::Int, expected, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
```

フィールドの値を取得し、条件に応じて指定した値に設定する操作をアトミックに実行します。

```julia
y = getfield(value, name, fail_order)
ok = y === expected
if ok
    setfield!(value, name, desired, success_order)
end
return (; old = y, success = ok)
```

ハードウェアが対応している場合は、適切なハードウェア命令に最適化されます。対応していない場合は、ループを使用します。

!!! compat "Julia 1.7"
    この関数を使用するには、Julia 1.7 以降が必要です。

