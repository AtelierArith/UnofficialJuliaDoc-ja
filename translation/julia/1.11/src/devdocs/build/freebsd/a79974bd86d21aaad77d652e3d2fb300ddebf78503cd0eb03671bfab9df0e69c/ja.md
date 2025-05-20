# FreeBSD

ClangはFreeBSD 11.0-RELEASE以降のデフォルトコンパイラです。残りのビルドツールはPorts Collectionから入手可能で、`pkg install git gcc gmake cmake pkgconf`を使用してインストールできます。Juliaをビルドするには、単に`gmake`を実行します。（FreeBSDの`make`はGNU Makeではなく互換性のないBSD Makeに対応しているため、`gmake`を使用する必要があります。）

上記のように、`USE_SYSTEM_*` フラグは FreeBSD で慎重に使用する必要があることに注意してください。これは、多くのシステムライブラリや、Ports Collection のライブラリがシステムの `libgcc_s.so.1` にリンクしているか、またはシステムの `libgcc_s` にリンクする別のライブラリにリンクしているためです。このライブラリはその GCC バージョンを 4.6 と宣言しており、これは Julia をビルドするには古すぎ、リンク時に他のライブラリと競合します。したがって、Julia がすべての依存関係をビルドできるようにすることを強くお勧めします。もし `USE_SYSTEM_*` フラグを使用することを選択する場合、デフォルトでは `/usr/local` がコンパイラパスに含まれていないため、`Make.user` に `LDFLAGS=-L/usr/local/lib` と `CPPFLAGS=-I/usr/local/include` を追加する必要があるかもしれませんが、そうすると他の依存関係に干渉する可能性があります。

x86アーキテクチャはコンパイラランタイムライブラリのサポートがないためスレッドをサポートしていないことに注意してください。そのため、32ビットシステムを使用している場合は、`Make.user`に`JULIA_THREADS=0`を設定する必要があるかもしれません。
