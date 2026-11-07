```julia
setgid(original_command::Cmd, gid) -> command::Cmd
```

`command` のグループ ID（GID）を設定します。Unix システムでは、これによりコマンドを別のグループとして実行できます。`gid = nothing` を渡すと、以前に設定した GID が解除されます。

この関数は Unix 系システム（Linux、macOS など）でのみサポートされています。GID の設定には適切な権限が必要です。

!!! compat "Julia 1.13"
    この関数を使用するには、Julia 1.13 以降が必要です。


# Examples

```julia
julia> run(setgid(`id -g`, 1000));
1000
```
