# FreeBSD

FreeBSD 11.0-RELEASE以降では、Clangがデフォルトのコンパイラです。その他のビルドツールはPorts Collectionから入手でき、`pkg install git gcc gmake cmake pkgconf`を使ってインストールできます。Juliaをビルドするには、`gmake`を実行するだけです。（FreeBSDでは`make`がGNU Makeではなく、互換性のないBSD Makeに対応するため、`make`ではなく`gmake`を使う必要がある点に注意してください。）

前述のとおり、FreeBSDでは`USE_SYSTEM_*`フラグを慎重に使うことが重要です。これは、多くのシステムライブラリやPorts Collectionのライブラリでさえ、システムの`libgcc_s.so.1`にリンクしているか、システムの`libgcc_s`にリンクする別のライブラリに依存しているためです。このライブラリはGCCのバージョンを4.6と宣言していますが、これはJuliaのビルドには古すぎるうえ、リンク時に他のライブラリと競合します。そのため、Juliaに依存関係をすべてビルドさせることを強く推奨します。`USE_SYSTEM_*`フラグを使う場合は、`/usr/local`がデフォルトではコンパイラのパスに含まれていないため、`LDFLAGS=-L/usr/local/lib`と`CPPFLAGS=-I/usr/local/include`を`Make.user`に追加する必要があるかもしれません。ただし、そうすると他の依存関係に影響する可能性があります。

x86アーキテクチャではコンパイラのランタイムライブラリがスレッド処理をサポートしていないため、スレッド機能は利用できません。したがって、32ビットシステムを使用している場合は、`Make.user`で`JULIA_THREADS=0`を設定する必要があるかもしれません。
