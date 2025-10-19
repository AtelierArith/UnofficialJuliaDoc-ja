# RISC-V (Linux)

Juliaは、Linuxを実行する64ビットRISC-V（RV64）プロセッサの実験的サポートを提供しています。このファイルは、特定のデバイスに関する指示に加えて、コンパイルの一般的なガイドラインを提供します。

[known issues](https://github.com/JuliaLang/julia/labels/system:riscv) の RISC-V 用のリストが利用可能です。問題が発生した場合は、`cat /proc/cpuinfo` の出力を含む問題を作成してください。

## Compiling Julia

現在、Juliaはすべての依存関係を含めて、完全にソースからコンパイルする必要があります。これは、次の`Make.user`を使用して実行できます：

```make
USE_BINARYBUILDER := 0
```

さらに、どのアーキテクチャを指定し、オプションでどのCPUをビルドするかを示す必要があります。これは、`Make.user`内の`MARCH`および`MCPU`変数を設定することで行うことができます。

`MARCH` 変数は RISC-V ISA 文字列に設定する必要があります。この文字列は、デバイスのドキュメントを確認するか、`/proc/cpuinfo` を調べることで見つけることができます。コンパイラがサポートしているフラグのみを使用してください。例えば、`gcc -march=help` を実行すると、サポートされているフラグのリストが表示されます。一般的な値は `rv64gc` で、良い出発点です。

`MCPU` 変数はオプションであり、特定の CPU に対して生成されるコードをさらに最適化するために使用できます。わからない場合は、設定しないことをお勧めします。サポートされている値のリストは、`gcc --target-help` を実行することで見つけることができます。

例えば、SiFive U74に基づくJH7110プロセッサを搭載したStarFive VisionFive2を使用している場合、これらのフラグを次のように設定できます：

```make
MARCH := rv64gc_zba_zbb
MCPU := sifive-u74
```

ポータブルビルドを好む場合は、次のように使用できます：

```make
MARCH := rv64gc

# also set JULIA_CPU_TARGET to the expanded form of rv64gc
# (it normally copies the value of MCPU, which we don't set)
JULIA_CPU_TARGET := generic-rv64,i,m,a,f,d,zicsr,zifencei,c
```

### Cross-compilation

RISC-Vデバイス上でのネイティブビルドは非常に長い時間がかかる場合があるため、より高速なマシンでJuliaをクロスコンパイルすることも可能です。

まず、C、C++、FortranをサポートするRISC-Vクロスコンパイルツールチェーンを入手します。これは、[riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain)リポジトリをチェックアウトし、次のようにビルドすることで行えます：

```sh
sudo mkdir /opt/riscv && sudo chown $USER /opt/riscv
./configure --prefix=/opt/riscv --with-languages=c,c++,fortran
make linux -j$(nproc)
```

次に、RISC-V用のQEMUユーザーモードエミュレーターをインストールし、ホストマシンでRISC-Vバイナリを実行できるように`binfmt`サポートを追加します。正確な手順はディストリビューションによって異なります。たとえば、Arch Linuxでは`qemu-user-static`および`qemu-user-static-binfmt`パッケージをインストールする必要があります。RISC-Vバイナリを実際に実行するには、QEMUがRISC-Vシステムルートを見つけられる必要があり、これは`QEMU_LD_PREFIX`環境変数をルートファイルシステムのパスに設定することで実現できます。

最後に、次の `Make.user` 変数を使用して Julia をコンパイルします（前のセクションのものに加えて）：

```make
XC_HOST=riscv64-unknown-linux-gnu
OS=Linux
export QEMU_LD_PREFIX=/opt/riscv/sysroot
```

`make`を実行する際には、`PATH`にクロスコンパイルツールチェーンを含める必要があることに注意してください。例えば、次のように実行します:

```sh
PATH=/opt/riscv/bin:$PATH make -j$(nproc)
```

RISC-V sysrootが非常に乏しいため、Juliaビルドシステムが現在システム全体で利用可能であることを期待している追加のライブラリを追加する必要があるかもしれません。たとえば、ビルドは現在、システム提供の`libz`に依存しているため、このライブラリをJuliaビルドからシステムルートにコピーする必要があるかもしれません。

```sh
make -C deps install-zlib
cp -v usr/lib/libz.*   /opt/riscv/sysroot/usr/lib
cp -v usr/include/z*.h /opt/riscv/sysroot/usr/include
```
