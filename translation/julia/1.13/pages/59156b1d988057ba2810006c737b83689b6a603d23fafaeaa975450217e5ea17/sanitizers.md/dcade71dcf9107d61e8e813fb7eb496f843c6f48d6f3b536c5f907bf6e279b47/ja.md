# Sanitizer support

[Sanitizers](https://github.com/google/sanitizers)を使うと、Juliaの内部C/C++コードにおける特定の種類のエラーを検出しやすくするため、カスタムビルドを作成できます。

## Address Sanitizer: easy build

Juliaのソースチェックアウトから、次のようにしてJuliaとLLVMでアドレスサニタイザーを有効にしたバージョンをビルドできます。

```sh
$ mkdir /tmp/julia
$ contrib/asan/build.sh /tmp/julia/
```

ここではビルドディレクトリとして`/tmp/julia`を選んでいますが、任意のディレクトリを指定できます。ビルド後、テストしたいワークロードを`/tmp/julia/julia`で実行してください。メモリ関連のバグがあると、エラーが発生します。

カスタマイズが必要な場合や、詳しい情報を知りたい場合は、以下のドキュメントを参照してください。

## General considerations

Clangのサニタイザーを使うには当然Clangが必要ですが、もう一つ注意点があります。ほとんどのサニタイザーはホストコンパイラが提供するランタイムライブラリを必要とし、JuliaのJITが生成する計測済みコードはそのライブラリの機能に依存します。そのため、ホストコンパイラのLLVMバージョンは、Julia内部で使われているLLVMライブラリのバージョンと一致している必要があります。

簡単な解決策は、一致するツールチェーンを用意する専用のビルドフォルダを作成し、`BUILD_LLVM_CLANG=1`を指定してビルドすることです。その後、別のビルドフォルダから`CC`と`CXX`の変数を上書きすれば、このツールチェーンを参照できます。

サニタイザーは、`RTLD_DEEPBIND`を使って共有ライブラリが開かれたことを検出するとエラーを出します（参照：[google/sanitizers#611](https://github.com/google/sanitizers/issues/611)）。[libblastrampoline](https://github.com/staticfloat/libblastrampoline)はデフォルトで`RTLD_DEEPBIND`を使うため、サニタイザーを使うときは環境変数`LBT_USE_RTLD_DEEPBIND=0`を設定する必要があります。

サニタイザーを使うには、`SANITIZE=1`を設定し、続けて使用するサニタイザーに対応するフラグを指定します。

macOSでは、動作させるために追加のフラグが必要になる場合があります。以下に示す`SANITIZE_*`フラグを1つ以上加えると、全体としては次のようになります。

```
make -C deps USE_BINARYBUILDER_LLVM=0 LLVM_VER=svn stage-llvm

make -C src SANITIZE=1 \
    CC=~+/deps/scratch/llvm-svn/build_Release/bin/clang \
    CXX=~+/deps/scratch/llvm-svn/build_Release/bin/clang++ \
    CPPFLAGS="-isysroot $(xcode-select -p)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" \
    CXXFLAGS="-isystem $(xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1"
```

（または、これらを`Make.user`に設定しておけば、毎回指定する必要はありません。）

## Address Sanitizer (ASAN)

メモリ関連のバグを検出またはデバッグするには、Clangの[address sanitizer (ASAN)](https://clang.llvm.org/docs/AddressSanitizer.html)を使えます。`SANITIZE_ADDRESS=1`を指定してコンパイルすると、Juliaコンパイラとその生成コードでASANが有効になります。さらに、`LLVM_SANITIZE=1`を指定すると、LLVMライブラリもサニタイズできます。これらのオプションを使うと、パフォーマンスとメモリ使用量に大きなコストがかかる点に注意してください。たとえば、JuliaとLLVMの両方でASANを有効にすると、`testall1`の実行時間は8～10倍になり、メモリ使用量は20倍になります（以下で説明するオプションを使えば、それぞれ3倍、4倍まで抑えられます）。

デフォルトでは、シグナルを正しく配信するために必要な`allow_user_segv_handler=1` ASANフラグがJuliaによって設定されます。`ASAN_OPTIONS`環境フラグを使ってほかのオプションを指定することもできますが、その場合は前述のデフォルトオプションも再度指定する必要があります。たとえば、`fast_unwind_on_malloc=0`と`malloc_context_size=2`を指定すると、バックトレースの精度は低下しますが、メモリ使用量を削減できます。現時点ではJuliaは`detect_leaks=0`も設定していますが、将来的には削除される予定です。

### Example setup

#### Step 1: Install toolchain

`$TOOLCHAIN_WORKTREE`にGitのワークツリーをチェックアウトする（またはソースツリー外にビルドディレクトリを作成する）とともに、`$TOOLCHAIN_WORKTREE/Make.user`という設定ファイルを作成し、次の内容を記述します。

```
USE_BINARYBUILDER_LLVM=1
BUILD_LLVM_CLANG=1
```

次を実行します。

```sh
cd $TOOLCHAIN_WORKTREE
make -C deps install-llvm install-clang install-llvm-tools
```

これにより、ツールチェーンのバイナリが`$TOOLCHAIN_WORKTREE/usr/tools`にインストールされます。

#### Step 2: Build Julia with ASAN

`$BUILD_WORKTREE`にGitのワークツリーをチェックアウトする（またはソースツリー外にビルドディレクトリを作成する）とともに、`$BUILD_WORKTREE/Make.user`という設定ファイルを作成し、次の内容を記述します。

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

これにより、ASANを有効にして`julia-debug`をビルドします。

## Memory Sanitizer (MSAN)

初期化されていないメモリの使用を検出するには、`SANITIZE_MEMORY=1`を指定してコンパイルし、Clangの[memory sanitizer (MSAN)](https://clang.llvm.org/docs/MemorySanitizer.html)を使います。

## Thread Sanitizer (TSAN)

データ競合やその他のスレッド関連の問題をデバッグするには、`SANITIZE_THREAD=1`を指定してコンパイルし、Clangの[thread sanitizer (TSAN)](https://clang.llvm.org/docs/ThreadSanitizer.html)を使います。
