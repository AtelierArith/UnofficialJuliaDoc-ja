```julia
has_system_clipboard() -> Bool
```

オペレーティングシステムでクリップボード機能が利用可能な場合は、`true`を返します。macOSとWindowsでは、常に`true`です。LinuxとFreeBSDでは、`wl-clipboard`に含まれる`xclip`、`xsel`、または`wl-copy`が存在するかどうかを確認します。それ以外のシステムでは、`false`を返します。

!!! compat "Julia 1.14"
    この関数を使用するには、Julia 1.14以降が必要です。


[`clipboard`](@ref)も参照してください。
