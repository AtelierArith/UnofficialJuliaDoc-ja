```julia
setcpuaffinity(original_command::Cmd, cpus) -> command::Cmd
```

`command` の CPU アフィニティを、CPU ID（1 始まり）のリスト `cpus` で設定します。`cpus = nothing` を渡すと、`original_command` に CPU アフィニティが設定されている場合、それを解除します。

この関数は Linux と Windows でのみサポートされています。libuv がアフィニティの設定をサポートしていないため、macOS では利用できません。

!!! compat "Julia 1.8"
    この関数を使用するには、Julia 1.8 以降が必要です。


# Examples

Linux では、コマンドラインプログラム `taskset` を使って、`setcpuaffinity` の動作を確認できます。

```julia
julia> run(setcpuaffinity(`sh -c 'taskset -p $$'`, [1, 2, 5]));
pid 2273's current affinity mask: 13
```

マスク値 `13` は、最下位ビットから数えて1番目、2番目、5番目のビットがオンになっていることを表します。

```julia
julia> 0b010011
0x13
```
