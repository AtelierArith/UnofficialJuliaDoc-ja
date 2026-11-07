# Sanitizer support

[Sanitizers](https://github.com/google/sanitizers) は、Julia の内部 C/C++ コードにおける特定の種類のエラーを検出しやすくするため、カスタムの Julia ビルドで使用できます。

## Address Sanitizer: easy build

Julia のソースチェックアウトから、次のようにして Julia と LLVM でアドレスサニタイザーを有効にしたバージョンをビルドできます。

```sh
$ mkdir /tmp/julia
$ contrib/asan/build.sh /tmp/julia/
```

ここではビルドディレクトリとして `/tmp/julia` を選んでいますが、任意のディレクトリを指定できます。ビルド後、テストしたいワークロードを `/tmp/julia/julia` で実行してください。メモリのバグがあるとエラーが発生します。

カスタマイズが必要な場合や、詳しい情報を知りたい場合は、以下のドキュメントを参照してください。

## General considerations

Clang のサニタイザーを使うには当然 Clang が必要ですが、もう一つ注意点があります。ほとんどのサニタイザーはホストコンパイラが提供するランタイムライブラリを必要とし、Julia の JIT が生成する計測済みコードはそのライブラリの機能に依存します。そのため、ホストコンパイラの LLVM バージョンは、Julia 内で使われている LLVM ライブラリのバージョンと一致していなければなりません。

簡単な解決策は、一致するツールチェーンを用意する専用のビルドフォルダを作り、`BUILD_LLVM_CLANG=1` を指定してビルドすることです。その後、別のビルドフォルダから `CC` と `CXX` の各変数を上書きすれば、このツールチェーンを参照できます。

サニタイザーは、`RTLD_DEEPBIND` を使って共有ライブラリが開かれたことを検出するとエラーを出します（参照: [google/sanitizers#611](https://github.com/google/sanitizers/issues/611)）。[libblastrampoline](https://github.com/staticfloat/libblastrampoline) はデフォルトで `RTLD_DEEPBIND` を使うため、サニタイザーを使うときは環境変数 `LBT_USE_RTLD_DEEPBIND=0` を設定する必要があります。

サニタイザーを使うには、`SANITIZE=1` を設定し、続けて使用するサニタイザーに対応するフラグを指定します。

macOS では、動作させるために追加のフラグが必要になる場合があります。たとえば、以下のように指定します。これに加えて、下記の `SANITIZE_*` フラグを1つ以上指定してください。

```
make -C deps USE_BINARYBUILDER_LLVM=0 LLVM_VER=svn stage-llvm

make -C src SANITIZE=1 \
    CC=~+/deps/scratch/llvm-svn/build_Release/bin/clang \
    CXX=~+/deps/scratch/llvm-svn/build_Release/bin/clang++ \
    CPPFLAGS="-isysroot $(xcode-select -p)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" \
    CXXFLAGS="-isystem $(xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1"
```

（または、これらを `Make.user` に設定しておけば、毎回指定する必要はありません。）

## Address Sanitizer (ASAN)

メモリのバグを検出またはデバッグするには、Clang の [address sanitizer (ASAN)](https://clang.llvm.org/docs/AddressSanitizer.html) を使用できます。`SANITIZE_ADDRESS=1` を指定してコンパイルすると、Julia コンパイラとその生成コードで ASAN が有効になります。さらに、`LLVM_SANITIZE=1` を指定すると、LLVM ライブラリもサニタイズできます。ただし、これらのオプションを使うと、パフォーマンスとメモリ使用量に大きなコストがかかります。たとえば、Julia と LLVM の両方で ASAN を使うと、`testall1` の実行時間は8～10倍になり、メモリ使用量は20倍になります（以下で説明するオプションを使えば、それぞれ3倍、4倍まで抑えられます）。

デフォルトでは、シグナルを正しく配信するために必要な `allow_user_segv_handler=1` ASAN フラグが Julia によって設定されます。`ASAN_OPTIONS` 環境フラグを使ってほかのオプションを指定することもできますが、その場合は前述のデフォルトオプションも再度指定する必要があります。たとえば、`fast_unwind_on_malloc=0` と `malloc_context_size=2` を指定すると、バックトレースの精度は低下しますが、メモリ使用量を削減できます。現時点では Julia は `detect_leaks=0` も設定していますが、将来的には削除される予定です。

### Example setup

#### Step 1: Install toolchain

`$TOOLCHAIN_WORKTREE` に Git のワークツリーをチェックアウトする（またはソースツリー外にビルドディレクトリを作成する）とともに、次の内容で設定ファイル `$TOOLCHAIN_WORKTREE/Make.user` を作成します。

```
USE_BINARYBUILDER_LLVM=1
BUILD_LLVM_CLANG=1
```

次を実行します。

```sh
cd $TOOLCHAIN_WORKTREE
make -C deps install-llvm install-clang install-llvm-tools
```

これにより、ツールチェーンのバイナリが `$TOOLCHAIN_WORKTREE/usr/tools` にインストールされます。

#### Step 2: Build Julia with ASAN

`$BUILD_WORKTREE` に Git のワークツリーをチェックアウトする（またはソースツリー外にビルドディレクトリを作成する）とともに、次の内容で設定ファイル `$BUILD_WORKTREE/Make.user` を作成します。

```
TOOLCHAIN=$(TOOLCHAIN_WORKTREE)/usr/tools

# use our new toolchain
override CC=$(TOOLCHAIN)/clang
override CXX=$(TOOLCHAIN)/clang++
export ASAN_SYMBOLIZER_PATH=$(TOOLCHAIN)/llvm-symbolizer

USE_BINARYBUILDER_LLVM=1

override SANITIZE=1
override SANITIZE_ADDRESS=1

# make the GC use regular malloc/frees, which are hooked by ASAN
override WITH_GC_DEBUG_ENV=1

# default to a debug build for better line number reporting
override JULIA_BUILD_MODE=debug

# make ASAN consume less memory
export ASAN_OPTIONS=detect_leaks=0:fast_unwind_on_malloc=0:allow_user_segv_handler=1:malloc_context_size=2

JULIA_PRECOMPILE=1

# tell libblastrampoline to not use RTLD_DEEPBIND
export LBT_USE_RTLD_DEEPBIND=0
```

次を実行します。

```sh
cd $BUILD_WORKTREE
make debug
```

これにより、`julia-debug` が ASAN 有効でビルドされます。

## Memory Sanitizer (MSAN)

初期化されていないメモリの使用を検出するには、`SANITIZE_MEMORY=1` を指定してコンパイルし、Clang の [memory sanitizer (MSAN)](https://clang.llvm.org/docs/MemorySanitizer.html) を使用できます。

## Thread Sanitizer (TSAN)

データ競合やその他のスレッド関連の問題をデバッグするには、`SANITIZE_THREAD=1` を指定してコンパイルし、Clang の [thread sanitizer (TSAN)](https://clang.llvm.org/docs/ThreadSanitizer.html) を使用できます。
