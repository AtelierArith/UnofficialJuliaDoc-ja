```
setcpuaffinity(original_command::Cmd, cpus) -> command::Cmd
```

`command`のCPUアフィニティをCPU IDのリスト（1ベース）`cpus`によって設定します。`cpus = nothing`を渡すと、`original_command`にアフィニティが設定されている場合はそれを解除します。

この関数はLinuxとWindowsでのみサポートされています。macOSではlibuvがアフィニティ設定をサポートしていないため、サポートされていません。

!!! compat "Julia 1.8"
    この関数は少なくともJulia 1.8が必要です。


# 例

Linuxでは、`taskset`コマンドラインプログラムを使用して`setcpuaffinity`の動作を確認できます。

```julia
julia> run(setcpuaffinity(`sh -c 'taskset -p $$'`, [1, 2, 5]));
pid 2273's current affinity mask: 13
```

マスク値`13`は、最下位の位置から数えて最初、第二、第五のビットがオンになっていることを反映しています：

```julia
julia> 0b010011
0x13
```
