```julia
setcpuaffinity(original_command::Cmd, cpus) -> command::Cmd
```

CPU ID（1始まり）のリスト`command`を指定して、`cpus`のCPUアフィニティを設定します。`cpus = nothing`を渡すと、`original_command`にCPUアフィニティが設定されている場合、それを解除します。

この関数はLinuxとWindowsでのみサポートされています。libuvがアフィニティの設定をサポートしていないため、macOSでは利用できません。

!!! compat "Julia 1.8"
    この関数を使用するには、Julia 1.8以降が必要です。


# Examples

Linuxでは、コマンドラインプログラム`taskset`を使って、`setcpuaffinity`の動作を確認できます。

```julia
julia> run(setcpuaffinity(`sh -c 'taskset -p $$'`, [1, 2, 5]));
pid 2273's current affinity mask: 13
```

マスク値`13`は、最下位ビットから数えて1番目、2番目、5番目のビットがオンになっていることを表します。

```julia
julia> 0b010011
0x13
```
