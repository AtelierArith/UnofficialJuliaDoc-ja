```julia
Sys.detectwsl()
```

Julia が Windows Subsystem for Linux（WSL）上で実行されているかどうかを判定するランタイム述語です。

!!! note
    `Sys.iswindows` や `Sys.islinux` などとは異なり、これはランタイム時の判定です。そのため、`@static if` 構文では意味のある形で使用できません。


!!! compat "Julia 1.12"
    この関数を使用するには、Julia 1.12 以降が必要です。

