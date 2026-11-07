```julia
Base.julia_cmd(juliapath=joinpath(Sys.BINDIR, julia_exename()); cpu_target::Union{Nothing,String}=nothing)
```

実行中のプロセスに似た julia コマンドを返します。デフォルト値以外に設定されている `--cpu-target`、`--sysimage`、`--compile`、`--sysimage-native-code`、`--compiled-modules`、`--pkgimages`、`--inline`、`--check-bounds`、`--optimize`、`--min-optlevel`、`-g`、`--code-coverage`、`--track-allocation`、`--color`、`--startup-file`、`--depwarn` の各コマンドライン引数を引き継ぎます。

特に、`--math-mode`、`--warn-overwrite`、`--trace-compile` などは、現在引き継がれません。

`nothing` に設定されていない場合、キーワード引数 `cpu_target` を使って、実行中のプロセスに設定されている CPU ターゲットを上書きできます。

コマンドライン引数を引き継がずに julia コマンドを取得するには、`julia_cmd()[1]` を使用します。

!!! compat "Julia 1.1"
    Julia 1.1 より前は、`--cpu-target`、`--sysimage`、`--depwarn`、`--compile`、`--check-bounds` のフラグのみが引き継がれていました。


!!! compat "Julia 1.5"
    `--color` と `--startup-file` のフラグは Julia 1.5 で追加されました。


!!! compat "Julia 1.9"
    キーワード引数 `cpu_target` は 1.9 で追加されました。フラグ `--pkgimages` は Julia 1.9 で追加されました。

