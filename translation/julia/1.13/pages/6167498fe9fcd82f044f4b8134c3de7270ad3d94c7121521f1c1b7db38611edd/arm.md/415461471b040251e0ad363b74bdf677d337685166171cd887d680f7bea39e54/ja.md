# ARM (Linux)

JuliaはARMv8（AArch64）プロセッサを完全にサポートしており、ARMv7およびARMv6（AArch32）もいくつかの注意点を除いてサポートしています。このファイルでは、特定のデバイス向けの手順に加えて、コンパイルに関する一般的なガイドラインを説明します。

ARM向けの[known issues](https://github.com/JuliaLang/julia/labels/arm)の一覧を参照できます。問題が発生した場合は、`cat /proc/cpuinfo`の出力を添えてissueを作成してください。

## 32-bit (ARMv6, ARMv7)

Juliaは、以下のARMv6およびARMv7デバイスの複数のモデルでコンパイルに成功しています。

  * Ubuntu LinuxをCrouton上で実行する、ARMv7 / Cortex A15搭載のSamsung Chromebook
  * [Raspberry Pi](https://www.raspberrypi.org)
  * [Odroid](https://www.hardkernel.com)

Juliaには、少なくとも`armv6`および`vfpv2`の命令セットが必要です。`armv7-a`の使用を推奨します。`armv5`およびソフトフロートはサポートされていません。

### Raspberry Pi 1 / Raspberry Pi Zero

Raspberry Piで使用されているARM CPUの種類がLLVMによって検出されない場合は、`Make.user`に以下を追加して、CPUターゲットを明示的に設定してください。

```
JULIA_CPU_TARGET=arm1176jzf-s
```

ビルドを完了するには、スワップファイルのサイズを増やす必要がある場合があります。その場合は、`/etc/dphys-swapfile`を編集し、次の行を

```
CONF_SWAPSIZE=100
```

次のように変更してから、

```
CONF_SWAPSIZE=512
```

スワップファイルのサービスを再起動してください。

```
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
```

### Raspberry Pi 2

Raspberry Pi 2で使用されているARM CPUの種類は、LLVMによって検出されません。`Make.user`に以下を追加して、CPUターゲットを明示的に設定してください。

`JULIA_CPU_TARGET=cortex-a7`

使用するコンパイラやディストリビューションによっては、サポートされていないインラインアセンブリが原因でビルドに失敗することがあります。その場合は、`Make.user`に`MCPU=armv7-a`を追加してください。

## AArch64 (ARMv8)

JuliaはARMv8 CPU上で動作し、ビルドできる見込みです。一般的な[build instructions](https://github.com/JuliaLang/julia/blob/master/README.md)に従ってください。Julia自体をビルドするには、約8GBのRAMまたはスワップ領域が必要です。

### Known issues

Julia v1.10以降では、LLVM 15以降とリンクする場合、このアーキテクチャ上のすべてのOSで[JITLink](https://llvm.org/docs/JITLink.html)が自動的に有効になります。[bug in LLVM memory manager](https://github.com/llvm/llvm-project/issues/63236)のため、負荷の高い処理ではメモリマッピングが過剰に生成されることがあります。その結果、Linuxでは`/proc/sys/vm/max_map_count`ファイルで設定されているメモリマッピング数の上限（`mmap`）を超え、次のようなエラーが発生する場合があります。

```
JIT session error: Cannot allocate memory
```

この問題が発生した場合は、たとえば次のコマンドを使ってメモリマッピング数の上限を引き上げるよう、システム管理者に依頼してください。

```
sysctl -w vm.max_map_count=262144
```
