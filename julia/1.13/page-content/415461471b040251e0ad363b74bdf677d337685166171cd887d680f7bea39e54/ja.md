# ARM (Linux)

Julia は ARMv8（AArch64）プロセッサを完全にサポートしており、いくつかの注意点はありますが、ARMv7 および ARMv6（AArch32）もサポートしています。このファイルでは、特定のデバイス向けの手順に加えて、コンパイルに関する一般的なガイドラインを説明します。

ARM 向けの [known issues](https://github.com/JuliaLang/julia/labels/arm) の一覧を参照できます。問題が発生した場合は、`cat /proc/cpuinfo` の出力を添えて issue を作成してください。

## 32-bit (ARMv6, ARMv7)

Julia は、次の ARMv6 および ARMv7 デバイスの複数のバリエーションで、正常にコンパイルされています。

  * Ubuntu Linux を Crouton 上で実行する ARMv7 / Cortex A15 搭載 Samsung Chromebook
  * [Raspberry Pi](https://www.raspberrypi.org)
  * [Odroid](https://www.hardkernel.com)

Julia の実行には、少なくとも `armv6` および `vfpv2` の命令セットが必要です。`armv7-a` の使用を推奨します。`armv5` またはソフトフロートはサポートされていません。

### Raspberry Pi 1 / Raspberry Pi Zero

Raspberry Pi で使用されている ARM CPU の種類が LLVM によって検出されない場合は、`Make.user` に次の設定を追加して、CPU ターゲットを明示的に指定してください。

```
JULIA_CPU_TARGET=arm1176jzf-s
```

ビルドを完了するには、スワップファイルのサイズを増やす必要がある場合があります。その場合は、`/etc/dphys-swapfile` を編集し、次の行を

```
CONF_SWAPSIZE=100
```

次のように変更してから、

```
CONF_SWAPSIZE=512
```

スワップファイルのサービスを再起動します。

```
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
```

### Raspberry Pi 2

Raspberry Pi 2 で使用されている ARM CPU の種類は、LLVM によって検出されません。`Make.user` に次の設定を追加して、CPU ターゲットを明示的に指定してください。

`JULIA_CPU_TARGET=cortex-a7`

使用するコンパイラやディストリビューションによっては、サポートされていないインラインアセンブリが原因でビルドに失敗することがあります。その場合は、`Make.user` に `MCPU=armv7-a` を追加してください。

## AArch64 (ARMv8)

Julia は ARMv8 CPU で動作し、ビルドできる見込みです。一般的な [build instructions](https://github.com/JuliaLang/julia/blob/master/README.md) に従ってください。Julia 自体をビルドするには、約 8 GB の RAM または有効なスワップ領域が必要です。

### Known issues

Julia v1.10 以降では、LLVM 15 以降とリンクする場合、このアーキテクチャではすべてのオペレーティングシステムで [JITLink](https://llvm.org/docs/JITLink.html) が自動的に有効になります。[bug in LLVM memory manager](https://github.com/llvm/llvm-project/issues/63236) により、負荷の大きい処理ではメモリマッピングが過剰に生成されることがあります。Linux では、これによってメモリマッピング数が `/proc/sys/vm/max_map_count` ファイルで設定された上限（`mmap`）を超え、次のようなエラーが発生する場合があります。

```
JIT session error: Cannot allocate memory
```

この問題が発生した場合は、次のコマンドなどを使ってメモリマッピング数の上限を引き上げるよう、システム管理者に依頼してください。

```
sysctl -w vm.max_map_count=262144
```
