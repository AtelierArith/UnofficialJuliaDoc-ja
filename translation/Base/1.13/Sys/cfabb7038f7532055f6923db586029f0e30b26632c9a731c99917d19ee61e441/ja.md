```julia
Sys.detectwsl()
```

JuliaがWindows Subsystem for Linux（WSL）上で実行されているかを判定する実行時述語。

!!! note
    `Sys.iswindows`や`Sys.islinux`などとは異なり、これは実行時の判定です。そのため、`@static if`構文では意味のある使い方ができません。


!!! compat "Julia 1.12"
    この関数を使うには、Julia 1.12以降が必要です。

