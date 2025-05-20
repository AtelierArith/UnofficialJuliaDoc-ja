# ARM (Linux)

JuliaはARMv8（AArch64）プロセッサを完全にサポートしており、ARMv7およびARMv6（AArch32）もいくつかの注意点とともにサポートしています。このファイルは、特定のデバイスに関する指示に加えて、コンパイルの一般的なガイドラインを提供します。

ARM用の[known issues](https://github.com/JuliaLang/julia/labels/arm)のリストが利用可能です。問題が発生した場合は、`cat /proc/cpuinfo`の出力を含む問題を作成してください。

## 32-bit (ARMv6, ARMv7)

Juliaは、以下のARMv6およびARMv7デバイスのいくつかのバリアントで正常にコンパイルされています：

  * ARMv7 / Cortex A15 の Samsung Chromebook で Crouton を使用して Ubuntu Linux を実行しています;
  * [Raspberry Pi](https://www.raspberrypi.org)
  * [Odroid](https://www.hardkernel.com)

Juliaは少なくとも`armv6`および`vfpv2`命令セットを必要とします。`armv7-a`の使用が推奨されます。`armv5`またはソフトフロートはサポートされていません。

### Raspberry Pi 1 / Raspberry Pi Zero

ARM CPUの種類がLLVMによって検出されない場合は、次の内容を`Make.user`に追加してCPUターゲットを明示的に設定します:

```
JULIA_CPU_TARGET=arm1176jzf-s
```

ビルドを完了するには、スワップファイルのサイズを増やす必要があるかもしれません。そのためには、`/etc/dphys-swapfile`を編集し、次の行を変更します:

```
CONF_SWAPSIZE=100
```

へ:

```
CONF_SWAPSIZE=512
```

スワップファイルサービスを再起動する前に:

```
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
```

### Raspberry Pi 2

Raspberry Pi 2で使用されているARM CPUのタイプはLLVMによって検出されません。次の内容を`Make.user`に追加してCPUターゲットを明示的に設定してください:

`JULIA_CPU_TARGET=cortex-a7`

コンパイラとディストリビューションによっては、サポートされていないインラインアセンブリのためにビルド失敗が発生することがあります。その場合は、`Make.user`に`MCPU=armv7-a`を追加してください。

## AArch64 (ARMv8)

ジュリアはARMv8 CPU上で作業し、構築されることが期待されています。一般的な [build instructions](https://github.com/JuliaLang/julia/blob/master/README.md) に従うべきです。ジュリアは自らを構築するために約8GBのRAMまたはスワップが有効であることを期待しています。

### Known issues

Julia v1.10以降、[JITLink](https://llvm.org/docs/JITLink.html)は、このアーキテクチャでLLVM 15以降のバージョンにリンクする際にすべてのオペレーティングシステムで自動的に有効になります。[bug in LLVM memory manager](https://github.com/llvm/llvm-project/issues/63236)のため、非自明なワークロードは、Linuxで設定されたメモリマッピングの制限（`mmap`）を超える可能性があるため、`/proc/sys/vm/max_map_count`ファイルにエラーが発生することがあります。

```
JIT session error: Cannot allocate memory
```

このようなことが起こった場合は、システム管理者にメモリマッピングの制限を増やすよう依頼してください。例えば、次のコマンドを使用します。

```
sysctl -w vm.max_map_count=262144
```
