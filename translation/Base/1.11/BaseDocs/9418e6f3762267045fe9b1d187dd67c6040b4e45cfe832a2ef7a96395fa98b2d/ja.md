```
replacefield!(value, name::Symbol, expected, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
replacefield!(value, i::Int, expected, desired,
              [success_order::Symbol, [fail_order::Symbol=success_order]) -> (; old, success::Bool)
```

原子操作を実行して、フィールドを指定された値に条件付きで設定します。

```
y = getfield(value, name, fail_order)
ok = y === expected
if ok
    setfield!(value, name, desired, success_order)
end
return (; old = y, success = ok)
```

ハードウェアがサポートしている場合、これは適切なハードウェア命令に最適化される可能性があります。そうでない場合は、ループを使用します。

!!! compat "Julia 1.7"
    この関数はJulia 1.7以降が必要です。

