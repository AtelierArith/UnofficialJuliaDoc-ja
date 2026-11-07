```julia
setuid(original_command::Cmd, uid) -> command::Cmd
```

`command` のユーザー ID（UID）を設定します。Unix システムでは、これによりコマンドを別のユーザーとして実行できます。`uid = nothing` を渡すと、以前に設定された UID が解除されます。

この関数は Unix 系システム（Linux、macOS など）でのみサポートされています。UID の設定には適切な権限が必要です。

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13 以降が必要です。


# Examples

```julia
julia> run(setuid(`id -u`, 1000));
1000
```
