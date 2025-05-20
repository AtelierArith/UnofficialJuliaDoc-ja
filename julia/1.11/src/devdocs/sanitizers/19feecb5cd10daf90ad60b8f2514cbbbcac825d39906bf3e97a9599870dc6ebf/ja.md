# Sanitizer support

[Sanitizers](https://github.com/google/sanitizers) は、カスタムJuliaビルドで使用され、Juliaの内部C/C++コードにおける特定の種類のエラーを検出しやすくします。

## Address Sanitizer: easy build

ソースチェックアウトからJuliaを取得すると、以下のようにJuliaとLLVMでアドレスサニタイズをサポートするバージョンをビルドできるはずです：

```sh
$ mkdir /tmp/julia
$ contrib/asan/build.sh /tmp/julia/
```

ここではビルドディレクトリとして `/tmp/julia` を選択しましたが、任意のディレクトリを選ぶことができます。ビルドが完了したら、テストしたいワークロードを `/tmp/julia/julia` で実行してください。メモリバグがあるとエラーが発生します。

カスタマイズや詳細が必要な場合は、以下のドキュメントを参照してください。

## General considerations

Clangのサニタイザを使用するには、明らかにClangを使用する必要があります（`USECLANG=1`）。しかし、もう一つの注意点があります。ほとんどのサニタイザは、ホストコンパイラによって提供されるランタイムライブラリを必要としますが、JuliaのJITによって生成されたインストゥルメンテッドコードは、そのライブラリの機能に依存しています。これは、ホストコンパイラのLLVMバージョンが、Julia内で使用されるLLVMライブラリのバージョンと一致する必要があることを意味します。

簡単な解決策は、`BUILD_LLVM_CLANG=1`を使用して一致するツールチェーンを提供する専用のビルドフォルダーを持つことです。次に、`CC`および`CXX`変数を上書きしながら`USECLANG=1`を指定することで、別のビルドフォルダーからこのツールチェーンを参照できます。

サニタイザは、`RTLD_DEEPBIND`を使用して開かれる共有ライブラリを検出するとエラーを出します（参照: [google/sanitizers#611](https://github.com/google/sanitizers/issues/611)）。デフォルトで[libblastrampoline](https://github.com/staticfloat/libblastrampoline)は`RTLD_DEEPBIND`を使用するため、サニタイザを使用する際には環境変数`LBT_USE_RTLD_DEEPBIND=0`を設定する必要があります。

サニタイザーの1つを使用するには、`SANITIZE=1`を設定し、使用したいサニタイザーに適したフラグを指定します。

macOSでは、これが動作するために追加のフラグが必要な場合があります。全体として、以下のように見えるかもしれません。さらに、以下にリストされている1つ以上の`SANITIZE_*`フラグを追加することができます：

```
make -C deps USE_BINARYBUILDER_LLVM=0 LLVM_VER=svn stage-llvm

make -C src SANITIZE=1 USECLANG=1 \
    CC=~+/deps/scratch/llvm-svn/build_Release/bin/clang \
    CXX=~+/deps/scratch/llvm-svn/build_Release/bin/clang++ \
    CPPFLAGS="-isysroot $(xcode-select -p)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" \
    CXXFLAGS="-isystem $(xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1"
```

（または、これらを `Make.user` に入れて、毎回覚えておく必要がないようにします）。

## Address Sanitizer (ASAN)

メモリバグを検出またはデバッグするために、Clangの [address sanitizer (ASAN)](https://clang.llvm.org/docs/AddressSanitizer.html) を使用できます。 `SANITIZE_ADDRESS=1` でコンパイルすると、Juliaコンパイラとその生成コードに対してASANが有効になります。さらに、 `LLVM_SANITIZE=1` を指定すると、LLVMライブラリもサニタイズされます。これらのオプションは高いパフォーマンスとメモリコストを伴うことに注意してください。たとえば、JuliaとLLVMにASANを使用すると、 `testall1` の実行時間が8〜10倍になり、メモリ使用量が20倍になります（これは、以下に説明するオプションを使用することで、それぞれ3倍と4倍に減らすことができます）。

デフォルトでは、Juliaは信号の配信が正しく機能するために必要な`allow_user_segv_handler=1` ASANフラグを設定します。他のオプションを定義するには、`ASAN_OPTIONS`環境フラグを使用しますが、その場合は前述のデフォルトオプションを繰り返す必要があります。たとえば、`fast_unwind_on_malloc=0`と`malloc_context_size=2`を指定することでメモリ使用量を削減できますが、バックトレースの精度が犠牲になります。現時点では、Juliaは`detect_leaks=0`も設定していますが、これは将来的に削除されるべきです。

### Example setup

#### Step 1: Install toolchain

`$TOOLCHAIN_WORKTREE` に Git ワークツリーをチェックアウトする（またはツリー外ビルドディレクトリを作成する）し、次の内容の設定ファイル `$TOOLCHAIN_WORKTREE/Make.user` を作成します。

```
USE_BINARYBUILDER_LLVM=1
BUILD_LLVM_CLANG=1
```

実行:

```sh
cd $TOOLCHAIN_WORKTREE
make -C deps install-llvm install-clang install-llvm-tools
```

`$TOOLCHAIN_WORKTREE/usr/tools` にツールチェーンバイナリをインストールするには

#### Step 2: Build Julia with ASAN

`$BUILD_WORKTREE` に Git ワークツリーをチェックアウトする（またはツリー外ビルドディレクトリを作成する）し、次の内容の設定ファイル `$BUILD_WORKTREE/Make.user` を作成します。

```
TOOLCHAIN=$(TOOLCHAIN_WORKTREE)/usr/tools

# use our new toolchain
USECLANG=1
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

実行:

```sh
cd $BUILD_WORKTREE
make debug
```

`julia-debug`をASANでビルドする。

## Memory Sanitizer (MSAN)

未初期化メモリの使用を検出するには、Clangの [memory sanitizer (MSAN)](https://clang.llvm.org/docs/MemorySanitizer.html) を使用し、`SANITIZE_MEMORY=1` でコンパイルします。

## Thread Sanitizer (TSAN)

スレッド関連の問題やデータレースのデバッグには、Clangの [thread sanitizer (TSAN)](https://clang.llvm.org/docs/ThreadSanitizer.html) を使用できます。`SANITIZE_THREAD=1` でコンパイルしてください。
