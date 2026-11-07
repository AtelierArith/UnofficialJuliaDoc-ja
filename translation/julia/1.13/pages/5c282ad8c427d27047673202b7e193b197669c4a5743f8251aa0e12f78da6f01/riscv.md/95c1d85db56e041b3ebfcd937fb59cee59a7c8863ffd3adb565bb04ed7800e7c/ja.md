# RISC-V (Linux)

Juliaは、Linuxを実行する64ビットRISC-V（RV64）プロセッサを実験的にサポートしています。このファイルでは、コンパイルに関する一般的なガイドラインに加え、特定のデバイス向けの手順を説明します。

RISC-V向けの[known issues](https://github.com/JuliaLang/julia/labels/system:riscv)の一覧を参照できます。問題が発生した場合は、`cat /proc/cpuinfo`の出力を添えてissueを作成してください。

## Compiling Julia

RISC-V向けにJuliaをコンパイルするには、対象とするアーキテクチャと、必要に応じてCPUを手動で指定する必要があります。これは、`Make.user`で`MARCH`および`MCPU`変数を設定して行います。

`MARCH`変数には、RISC-V ISA文字列を設定する必要があります。これは、デバイスのドキュメントを確認するか、`/proc/cpuinfo`を調べることで確認できます。コンパイラがサポートするフラグのみを使用してください。たとえば、`gcc -march=help`を実行すると、サポートされているフラグの一覧を確認できます。一般的な値は`rv64gc`で、出発点として適しています。

`MCPU`変数は省略可能で、特定のCPU向けに生成コードをさらに最適化するために使用できます。判断がつかない場合は、設定しないことをおすすめします。`gcc --target-help`を実行すると、サポートされている値の一覧を確認できます。

たとえば、SiFive U74をベースとするJH7110プロセッサを搭載したStarFive VisionFive2を使用している場合は、次のようにフラグを設定できます。

```make
MARCH := rv64gc_zba_zbb
MCPU := sifive-u74
```

移植性を重視したビルドにする場合は、次のように設定できます。

```make
MARCH := rv64gc

# also set JULIA_CPU_TARGET to the expanded form of rv64gc
# (it normally copies the value of MCPU, which we don't set)
JULIA_CPU_TARGET := generic-rv64,i,m,a,f,d,zicsr,zifencei,c
```

### Cross-compilation

RISC-Vデバイス上でネイティブビルドを行うと、非常に時間がかかる場合があります。そのため、より高速なマシンでJuliaをクロスコンパイルすることもできます。

まず、C、C++、FortranをサポートするRISC-Vクロスコンパイルツールチェーンを用意します。[riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)リポジトリをチェックアウトし、次のようにビルドします。

```sh
sudo mkdir /opt/riscv && sudo chown $USER /opt/riscv
./configure --prefix=/opt/riscv --with-languages=c,c++,fortran
make linux -j$(nproc)
```

次に、RISC-V用のQEMUユーザーモードエミュレーターをインストールし、ホストマシン上でRISC-Vバイナリを実行できるように`binfmt`のサポートも導入します。具体的な手順はディストリビューションによって異なります。たとえばArch Linuxでは、`qemu-user-static`および`qemu-user-static-binfmt`パッケージをインストールします。RISC-Vバイナリを実際に実行するには、QEMUがRISC-Vのシステムルートを見つけられる必要があります。ルートファイルシステムのパスを`QEMU_LD_PREFIX`環境変数に設定すると、これを実現できます。

最後に、前のセクションで設定した変数に加えて、次の`Make.user`変数を指定してJuliaをコンパイルします。

```make
XC_HOST=riscv64-unknown-linux-gnu
OS=Linux
export QEMU_LD_PREFIX=/opt/riscv/sysroot
```

`PATH`にクロスコンパイルツールチェーンを含めた状態で、`make`を実行する必要があります。たとえば、次のように実行します。

```sh
PATH=/opt/riscv/bin:$PATH make -j$(nproc)
```

使用するRISC-Vのsysrootは非常に最小限の構成であるため、Juliaのビルドシステムがシステム全体にインストールされていることを前提としているライブラリを追加する必要がある場合があります。たとえば、現在のビルドではシステム提供の`libz`に依存しているため、Juliaのビルドからこのライブラリをシステムルートにコピーする必要がある場合があります。

```sh
make -C deps install-zlib
cp -v usr/lib/libz.*   /opt/riscv/sysroot/usr/lib
cp -v usr/include/z*.h /opt/riscv/sysroot/usr/include
```
