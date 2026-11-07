# Embedding Julia

[Calling C and Fortran Code](@ref)で見たように、JuliaにはCで書かれた関数を簡単かつ効率的に呼び出す方法があります。しかし、逆にCコードからJulia関数を呼び出す必要がある場合もあります。これを使えば、すべてを書き直すことなく、Juliaコードをより大規模なC/C++プロジェクトに組み込めます。これを可能にするため、JuliaにはC APIが用意されています。ほとんどのプログラミング言語にはC関数を呼び出す方法があるため、JuliaのC APIを使って、さらに他の言語とのブリッジ（たとえば、Python、Rust、C#からJuliaを呼び出すもの）を構築することもできます。RustとC++はいずれもC埋め込みAPIを直接利用できますが、どちらにもそれを支援するパッケージがあります。C++では[Jluna](https://github.com/Clemapfel/jluna)が便利です。

## High-Level Embedding

**注**: この節では、Unix系オペレーティングシステムでJuliaコードをCに埋め込む方法を説明します。Windowsでの方法については、次の節[High-Level Embedding on Windows with Visual Studio](@ref)を参照してください。

まず、Juliaを初期化してJuliaコードを実行する、簡単なCプログラムから始めましょう。

```c
#include <julia.h>
JULIA_DEFINE_FAST_TLS // only define this once, in an executable (not in a shared library) if you want fast code.

int main(int argc, char *argv[])
{
    /* required: setup the Julia context */
    jl_init();

    /* run Julia commands */
    jl_eval_string("print(sqrt(2.0))");

    /* strongly recommended: notify Julia that the
         program is about to terminate. this allows
         Julia time to cleanup pending write requests
         and run all finalizers
    */
    jl_atexit_hook(0);
    return 0;
}
```

このプログラムをビルドするには、Juliaのヘッダーファイルへのパスをインクルードパスに追加し、`libjulia`にリンクする必要があります。たとえば、Juliaが`$JULIA_DIR`にインストールされている場合、上記のテストプログラム`test.c`は、次のように`gcc`を使ってコンパイルできます。

```
gcc -o test -fPIC -I$JULIA_DIR/include/julia -L$JULIA_DIR/lib -Wl,-rpath,$JULIA_DIR/lib test.c -ljulia
```

別の方法として、Juliaソースツリーの`test/embedding/`フォルダーにある`embedding.c`プログラムを参照してください。`cli/loader_exe.c`プログラムも、`libjulia`にリンクする際に`jl_options`オプションを設定する方法を示す、もう一つの簡単な例です。

他のJulia C関数を呼び出す前に、まずJuliaを初期化する必要があります。これは`jl_init`を呼び出して行います。この関数はJuliaのインストール場所を自動的に特定しようとします。独自の場所を指定する場合や、読み込むシステムイメージを指定する場合は、代わりに`jl_init_with_image_file`または`jl_init_with_image_handle`を使います。

テストプログラムの2つ目の文では、`jl_eval_string`を呼び出してJuliaの文を評価しています。

プログラムの終了前には、`jl_atexit_hook`を呼び出すことを強く推奨します。上記のサンプルプログラムでは、`main`から戻る直前にこれを呼び出しています。

!!! note
    現在、`libjulia`共有ライブラリを動的リンクするには、`RTLD_GLOBAL`オプションを渡す必要があります。Pythonでは、次のようになります。

    ```
    >>> julia=CDLL('./libjulia.dylib',RTLD_GLOBAL)
    >>> julia.jl_init.argtypes = []
    >>> julia.jl_init()
    250593296
    ```


!!! note
    juliaプログラムがメイン実行ファイルのシンボルにアクセスする必要がある場合、Linuxではコンパイル時に、後述する`julia-config.jl`が生成するオプションに加えて、リンカーフラグ`-Wl,--export-dynamic`を追加する必要がある場合があります。共有ライブラリをコンパイルする場合は、この指定は不要です。


### Using julia-config to automatically determine build parameters

`julia-config.jl`スクリプトは、Juliaを埋め込むプログラムに必要なビルドパラメーターを特定しやすくするために作成されました。このスクリプトは、呼び出し元のJuliaディストリビューションのビルドパラメーターとシステム構成を使い、そのディストリビューションと連携する埋め込みプログラムに必要なコンパイラーフラグを出力します。このスクリプトはJuliaの共有データディレクトリにあります。

#### Example

```c
#include <julia.h>

int main(int argc, char *argv[])
{
    jl_init();
    (void)jl_eval_string("println(sqrt(2.0))");
    jl_atexit_hook(0);
    return 0;
}
```

#### On the command line

このスクリプトは、コマンドラインから簡単に利用できます。`julia-config.jl`が`/usr/local/julia/share/julia`にあるとすると、コマンドラインから直接実行でき、次の3つのフラグを任意に組み合わせて指定できます。

```
/usr/local/julia/share/julia/julia-config.jl
Usage: julia-config [--cflags|--ldflags|--ldlibs]
```

上記のソースコードを`embed_example.c`というファイルに保存した場合、次のコマンドでLinuxおよびWindows（MSYS2環境）上の実行可能プログラムにコンパイルできます。macOSでは、`gcc`の代わりに`clang`を指定してください。

```
/usr/local/julia/share/julia/julia-config.jl --cflags --ldflags --ldlibs | xargs gcc embed_example.c
```

#### Use in Makefiles

一般に、埋め込みを行うプロジェクトは上記の例より複雑になるため、以下では汎用的なMakefileにも対応できるようにします。**shell**マクロ展開を使うため、GNU makeを前提としています。また、`julia-config.jl`は通常`/usr/local`ディレクトリにありますが、そうでない場合でもJulia自体を使って`julia-config.jl`を見つけられるため、Makefileでこれを利用できます。上記の例を拡張し、Makefileを使うと次のようになります。

```
JL_SHARE = $(shell julia -e 'print(joinpath(Sys.BINDIR, Base.DATAROOTDIR, "julia"))')
CFLAGS   += $(shell $(JL_SHARE)/julia-config.jl --cflags)
CXXFLAGS += $(shell $(JL_SHARE)/julia-config.jl --cflags)
LDFLAGS  += $(shell $(JL_SHARE)/julia-config.jl --ldflags)
LDLIBS   += $(shell $(JL_SHARE)/julia-config.jl --ldlibs)

all: embed_example
```

これで、ビルドコマンドは`make`だけです。

## High-Level Embedding on Windows with Visual Studio

`JULIA_DIR`環境変数が設定されていない場合は、Visual Studioを起動する前に、システムパネルから設定してください。JULIA_DIRの下にある`bin`フォルダーが、システムのPATHに含まれている必要があります。

まずVisual Studioを開き、新しいコンソールアプリケーションプロジェクトを作成します。「stdafx.h」ヘッダーファイルを開き、末尾に次の行を追加します。

```c
#include <julia.h>
```

次に、プロジェクトのmain()関数を以下のコードに置き換えます。

```c
int main(int argc, char *argv[])
{
    /* required: setup the Julia context */
    jl_init();

    /* run Julia commands */
    jl_eval_string("print(sqrt(2.0))");

    /* strongly recommended: notify Julia that the
         program is about to terminate. this allows
         Julia time to cleanup pending write requests
         and run all finalizers
    */
    jl_atexit_hook(0);
    return 0;
}
```

次に、Juliaのインクルードファイルとライブラリを見つけられるよう、プロジェクトを設定します。Juliaのインストールが32ビットか64ビットかを確認することが重要です。先に進む前に、Juliaのインストールに対応しないプラットフォーム構成は削除してください。

プロジェクトのプロパティダイアログで、`C/C++` | `General`を開き、追加のインクルードディレクトリのプロパティに`$(JULIA_DIR)\include\julia\`を追加します。次に、`Linker` | `General`を開き、追加のライブラリディレクトリのプロパティに`$(JULIA_DIR)\lib`を追加します。最後に、`Linker` | `Input`で、ライブラリの一覧に`libjulia.dll.a;libopenlibm.dll.a;`を追加します。

これで、プロジェクトをビルドして実行できるはずです。

## Converting Types

実際のアプリケーションでは、式を実行するだけでなく、その値をホストプログラムに返す必要があります。`jl_eval_string`は`jl_value_t*`を返します。これは、ヒープに確保されたJuliaオブジェクトへのポインターです。[`Float64`](@ref)のような単純なデータ型をこの方法で格納することを`boxing`と呼び、格納されたプリミティブデータを取り出すことを`unboxing`と呼びます。Juliaで2の平方根を計算し、その結果をCで読み取るように改良したサンプルプログラムでは、関数本体に次のコードが含まれます。

```c
jl_value_t *ret = jl_eval_string("sqrt(2.0)");

if (jl_typeis(ret, jl_float64_type)) {
    double ret_unboxed = jl_unbox_float64(ret);
    printf("sqrt(2.0) in C: %e \n", ret_unboxed);
}
else {
    printf("ERROR: unexpected return type from sqrt(::Float64)\n");
}
```

`ret`が特定のJulia型かどうかを確認するには、`jl_isa`、`jl_typeis`、または`jl_is_...`関数を使います。Juliaのシェルで`typeof(sqrt(2.0))`を実行すると、戻り値の型が[`Float64`](@ref)（Cでは`double`）であることがわかります。上記のコード例では、ボックス化されたJuliaの値をCのdoubleに変換するために`jl_unbox_float64`関数を使っています。

逆方向の変換には、対応する`jl_box_...`関数を使います。

```c
jl_value_t *a = jl_box_float64(3.0);
jl_value_t *b = jl_box_float32(3.0f);
jl_value_t *c = jl_box_int32(3);
```

次に見るように、特定の引数を指定してJulia関数を呼び出すには、ボックス化が必要です。

## Calling Julia Functions

`jl_eval_string`を使うと、CからJulia式の結果を取得できますが、Cで計算した引数をJuliaに渡すことはできません。そのためには、`jl_call`を使ってJulia関数を直接呼び出す必要があります。

```c
jl_value_t *func = jl_get_function(jl_base_module, "sqrt");
jl_value_t *argument = jl_box_float64(2.0);
jl_value_t *ret = jl_call1(func, argument);
```

最初に、`jl_get_function`を呼び出して、Julia関数`sqrt`へのハンドルを取得します。`jl_get_function`に渡す最初の引数は、`sqrt`が定義されている`Base`モジュールへのポインターです。次に、`jl_box_float64`を使ってdouble値をボックス化します。最後に、`jl_call1`を使って関数を呼び出します。引数の数に応じて使い分けられる`jl_call0`、`jl_call2`、`jl_call3`関数も用意されています。さらに多くの引数を渡すには、`jl_call`を使います。

```
jl_value_t *jl_call(jl_value_t *f, jl_value_t **args, int32_t nargs)
```

第2引数の`args`は、`jl_value_t*`引数の配列であり、`nargs`は引数の数です。

Julia関数を呼び出す方法として、別の、おそらくより簡単な方法もあります。それは[`@cfunction`](@ref)を介する方法です。`@cfunction`を使うと、型変換をJulia側で行えます。通常、これはC側で行うより簡単です。上記の`sqrt`の例は、`@cfunction`を使うと次のように書けます。

```c
double (*sqrt_jl)(double) = jl_unbox_voidpointer(jl_eval_string("@cfunction(sqrt, Float64, (Float64,))"));
double ret = sqrt_jl(2.0);
```

ここではまず、JuliaでCから呼び出せる関数を定義し、その関数ポインターを取り出してから呼び出しています。高水準言語側で型変換を行うことで簡潔になるだけでなく、`@cfunction`ポインターを介してJulia関数を呼び出すと、すべての引数が「ボックス化」される`jl_call`に伴う動的ディスパッチのオーバーヘッドもなくなり、ネイティブのC関数ポインターと同等の性能が得られるはずです。

## Memory Management

これまで見てきたように、JuliaオブジェクトはCでは`jl_value_t*`型のポインターとして表されます。ここで、これらのオブジェクトを誰が解放するのかという疑問が生じます。

通常、Juliaオブジェクトはガベージコレクター（GC）が解放します。しかし、GCはCからJuliaの値への参照を保持していることを自動的には認識しません。そのため、GCがオブジェクトを解放してしまい、ポインターが無効になることがあります。

GCが実行されるのは、新しいJuliaオブジェクトが割り当てられるときだけです。`jl_box_float64`のような呼び出しではメモリが割り当てられますが、Juliaコードの実行中であれば、どの時点でも割り当てが発生する可能性があります。

Juliaを埋め込むコードを書く場合、通常は`jl_value_t*`の値を`jl_...`呼び出しの間で使う分には安全です（GCが起動するのはそのような呼び出しのときだけです）。ただし、`jl_...`呼び出しをまたいで値を保持するには、Juliaの[root](https://www.cs.purdue.edu/homes/hosking/690M/p611-fenichel.pdf)値への参照を保持していることをJuliaに知らせる必要があります。この処理を「GCルート化」と呼びます。値をルート化すると、GCがその値を誤って未使用と判断して解放し、その値のメモリを回収するのを防げます。これは`JL_GC_PUSH`マクロを使って行えます。

```c
jl_value_t *ret = jl_eval_string("sqrt(2.0)");
JL_GC_PUSH1(&ret);
// Do something with ret
JL_GC_POP();
```

`JL_GC_POP`を呼び出すと、先行する`JL_GC_PUSH`によって確立された参照が解放されます。`JL_GC_PUSH`はCスタックに参照を格納するため、スコープを抜ける前に、必ず対応する`JL_GC_POP`を呼び出す必要があります。つまり、関数から戻る前、または`JL_GC_PUSH`を呼び出したブロックから制御フローが抜ける前に呼び出してください。

`JL_GC_PUSH2`から`JL_GC_PUSH6`までのマクロを使うと、複数のJulia値を一度にプッシュできます。

```
JL_GC_PUSH2(&ret1, &ret2);
// ...
JL_GC_PUSH6(&ret1, &ret2, &ret3, &ret4, &ret5, &ret6);
```

Julia値の配列をプッシュするには、`JL_GC_PUSHARGS`マクロを使います。使用例は次のとおりです。

```c
jl_value_t **args;
JL_GC_PUSHARGS(args, 2); // args can now hold 2 `jl_value_t*` objects
args[0] = some_value;
args[1] = some_other_value;
// Do something with args (e.g. call jl_... functions)
JL_GC_POP();
```

各スコープで`JL_GC_PUSH*`を呼び出せるのは1回だけであり、対応する`JL_GC_POP`の呼び出しも1回だけにする必要があります。ルート化したい変数をすべて1回の`JL_GC_PUSH*`呼び出しでプッシュできない場合、またはプッシュする変数が6個を超え、引数配列を使えない場合は、内側のブロックを使います。

```c
jl_value_t *ret1 = jl_eval_string("sqrt(2.0)");
JL_GC_PUSH1(&ret1);
jl_value_t *ret2 = 0;
{
    jl_value_t *func = jl_get_function(jl_base_module, "exp");
    ret2 = jl_call1(func, ret1);
    JL_GC_PUSH1(&ret2);
    // Do something with ret2.
    JL_GC_POP();    // This pops ret2.
}
JL_GC_POP();    // This pops ret1.
```

`JL_GC_PUSH*`を呼び出す前に、`jl_value_t*`の値が有効である必要はありません。複数の値を`NULL`で初期化しておき、それらを`JL_GC_PUSH*`に渡してから、実際のJulia値を作成しても問題ありません。たとえば、次のようにします。

```
jl_value_t *ret1 = NULL, *ret2 = NULL;
JL_GC_PUSH2(&ret1, &ret2);
ret1 = jl_eval_string("sqrt(2.0)");
ret2 = jl_eval_string("sqrt(3.0)");
// Use ret1 and ret2
JL_GC_POP();
```

関数間（またはブロックスコープ間）で変数へのポインターを保持する必要がある場合、`JL_GC_PUSH*`は使えません。この場合は、Juliaのグローバルスコープに変数への参照を作成して保持する必要があります。簡単な方法の一つは、参照を保持するグローバルな`IdDict`を使い、GCによる解放を防ぐことです。ただし、この方法が正しく機能するのは可変型の場合だけです。

```c
// This functions shall be executed only once, during the initialization.
jl_value_t* refs = jl_eval_string("refs = IdDict()");
jl_value_t* setindex = jl_get_function(jl_base_module, "setindex!");

...

// `var` is the variable we want to protect between function calls.
jl_value_t* var = 0;

...

// `var` is a `Vector{Float64}`, which is mutable.
var = jl_eval_string("[sqrt(2.0); sqrt(4.0); sqrt(6.0)]");

// To protect `var`, add its reference to `refs`.
jl_call3(setindex, refs, var, var);
```

変数が不変型の場合は、`IdDict`にプッシュする前に、同等の可変コンテナー、またはできれば`RefValue{Any}`でラップする必要があります。この方法では、たとえば`jl_new_struct`関数を使い、Cコードからコンテナーを作成するか、値を格納する必要があります。`jl_call*`でコンテナーを作成した場合は、Cコードで使うポインターを再読み込みする必要があります。

```c
// This functions shall be executed only once, during the initialization.
jl_value_t* refs = jl_eval_string("refs = IdDict()");
jl_value_t* setindex = jl_get_function(jl_base_module, "setindex!");
jl_datatype_t* reft = (jl_datatype_t*)jl_eval_string("Base.RefValue{Any}");

...

// `var` is the variable we want to protect between function calls.
jl_value_t* var = 0;

...

// `var` is a `Float64`, which is immutable.
var = jl_eval_string("sqrt(2.0)");

// Protect `var` until we add its reference to `refs`.
JL_GC_PUSH1(&var);

// Wrap `var` in `RefValue{Any}` and push to `refs` to protect it.
jl_value_t* rvar = jl_new_struct(reft, var);
JL_GC_POP();

jl_call3(setindex, refs, rvar, rvar);
```

変数への参照がほかの場所に保持されていないことを条件に、`delete!`関数を使って`refs`からその変数への参照を削除すれば、GCが変数を解放できるようになります。

```c
jl_value_t* delete = jl_get_function(jl_base_module, "delete!");
jl_call2(delete, refs, rvar);
```

非常に単純なケースでは、代わりに`Vector{Any}`型のグローバルコンテナーを作成し、必要に応じてそこから要素を取得する方法もあります。また、ポインターごとにグローバル変数を一つ作成することもできます。

```c
jl_module_t *mod = jl_main_module;
jl_sym_t *var = jl_symbol("var");
jl_binding_t *bp = jl_get_binding_wr(mod, var, 1);
jl_checked_assignment(bp, mod, var, val);
```

### Updating fields of GC-managed objects

GCは、古い世代のオブジェクトから若い世代のオブジェクトへの参照をすべて把握していることを前提としています。この前提を崩すようにポインターを更新した場合は、次のように`jl_gc_wb`（ライトバリア）関数を使って、そのことをGCに通知する必要があります。

```c
jl_value_t *parent = some_old_value, *child = some_young_value;
((some_specific_type*)parent)->field = child;
jl_gc_wb(parent, child);
```

実行時にどの値が古い世代になるかを一般に予測することはできないため、明示的なストアの後には必ずライトバリアを挿入する必要があります。例外として、`parent`オブジェクトを割り当てた直後で、その後にGCが実行されていない場合は不要です。なお、ほとんどの`jl_...`関数は、場合によってGCを実行することがあります。

ポインター配列のデータを直接更新する場合にも、ライトバリアが必要です。通常は`jl_array_ptr_set`を呼び出す方法が望ましいですが、直接更新することもできます。たとえば、次のようにします。

```c
jl_array_t *some_array = ...; // e.g. a Vector{Any}
void **data = jl_array_data(some_array, void*);
jl_value_t *some_value = ...;
data[0] = some_value;
jl_gc_wb(jl_array_owner(some_array), some_value);
```

### Controlling the Garbage Collector

GCを制御する関数もいくつかあります。通常の用途では、これらを使う必要はありません。

| 関数                                 | 説明                                       |
|:---------------------------------- |:---------------------------------------- |
| `jl_gc_collect(JL_GC_FULL)`        | すべてのオブジェクトに対してGCを強制実行する                  |
| `jl_gc_collect(JL_GC_INCREMENTAL)` | 若い世代のオブジェクトだけに対してGCを強制実行する               |
| `jl_gc_collect(JL_GC_AUTO)`        | GCを強制実行し、フルGCとインクリメンタルGCのどちらを行うか自動的に選択する |
| `jl_gc_enable(0)`                  | GCを無効にし、以前の状態をintで返す                     |
| `jl_gc_enable(1)`                  | GCを有効にし、以前の状態をintで返す                     |
| `jl_gc_is_enabled()`               | 現在の状態をintで返す                             |

## Working with Arrays

JuliaとCでは、コピーせずに配列データを共有できます。次の例でその方法を説明します。

Juliaの配列は、Cでは`jl_array_t*`データ型で表されます。基本的に、`jl_array_t`は次の情報を含む構造体です。

  * データ型に関する情報
  * データブロックへのポインター
  * 配列のサイズに関する情報

説明を簡単にするため、まず1次元配列から始めます。長さ10のFloat64要素を含む配列は、次のように作成できます。

```c
jl_value_t* array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 1);
jl_array_t* x          = jl_alloc_array_1d(array_type, 10);
```

すでに配列を確保している場合は、そのデータを薄いラッパーで包むこともできます。

```c
double *existingArray = (double*)malloc(sizeof(double)*10);
jl_array_t *x = jl_ptr_to_array_1d(array_type, existingArray, 10, 0);
```

最後の引数は、Juliaがデータの所有権を取得するかどうかを示すブール値です。この引数がゼロ以外の場合、配列への参照がなくなったときに、GCはデータポインターに対して`free`を呼び出します。

`x`のデータにアクセスするには、`jl_array_data`を使います。

```c
double *xData = jl_array_data(x, double);
```

これで配列に値を格納できます。

```c
for (size_t i = 0; i < jl_array_nrows(x); i++)
    xData[i] = i;
```

次に、`x`に対してインプレース操作を行うJulia関数を呼び出してみましょう。

```c
jl_value_t *func = jl_get_function(jl_base_module, "reverse!");
jl_call1(func, (jl_value_t*)x);
```

配列を出力すれば、`x`の要素が逆順になったことを確認できます。

### Accessing Returned Arrays

Julia関数が配列を返す場合、`jl_eval_string`および`jl_call`の戻り値を`jl_array_t*`にキャストできます。

```c
jl_value_t *func  = jl_get_function(jl_base_module, "reverse");
jl_array_t *y = (jl_array_t*)jl_call1(func, (jl_value_t*)x);
```

これで、先ほどと同じように`jl_array_data`を使って`y`の内容にアクセスできます。配列を使用している間は、常にその参照を保持するようにしてください。

### Multidimensional Arrays

Juliaの多次元配列は、メモリ上では列優先順で格納されます。以下のコードでは、2次元配列を作成し、そのプロパティにアクセスします。

```c
// Create 2D array of float64 type
jl_value_t *array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 2);
int dims[] = {10,5};
jl_array_t *x  = jl_alloc_array_nd(array_type, dims, 2);

// Get array pointer
double *p = jl_array_data(x, double);
// Get number of dimensions
int ndims = jl_array_ndims(x);
// Get the size of the i-th dim
size_t size0 = jl_array_dim(x,0);
size_t size1 = jl_array_dim(x,1);

// Fill array with data
for(size_t i=0; i<size1; i++)
    for(size_t j=0; j<size0; j++)
        p[j + size0*i] = i + j;
```

Juliaの配列は1始まりのインデックスを使いますが、C APIでは、Cらしいコードになるように0始まりのインデックスを使います（たとえば、`jl_array_dim`の呼び出しなど）。

## Exceptions

Juliaコードは例外をスローすることがあります。たとえば、次のコードを考えてみましょう。

```c
jl_eval_string("this_function_does_not_exist()");
```

この呼び出しは何も起きていないように見えます。しかし、例外がスローされたかどうかを確認できます。

```c
if (jl_exception_occurred())
    printf("%s \n", jl_typeof_str(jl_exception_occurred()));
```

Python、C#、C++など、例外をサポートする言語からJulia C APIを使う場合は、`libjulia`の各呼び出しを、例外がスローされたか確認する関数でラップし、その後、ホスト言語側で例外を再スローするとよいでしょう。

### Throwing Julia Exceptions

Cから呼び出せるJulia関数を書く際、引数を検証し、エラーを示すために例外をスローする必要がある場合があります。典型的な型チェックは次のようになります。

```c
if (!jl_typeis(val, jl_float64_type)) {
    jl_type_error(function_name, (jl_value_t*)jl_float64_type, val);
}
```

一般的な例外は、次の関数を使って発生させられます。

```c
void jl_error(const char *str);
void jl_errorf(const char *fmt, ...);
```

`jl_error`はC文字列を受け取り、`jl_errorf`は`printf`と同様に呼び出します。

```c
jl_errorf("argument x = %d is too large", x);
```

この例では、`x`は整数であると仮定しています。

### Thread-safety

一般に、Julia C APIは完全なスレッドセーフではありません。マルチスレッドアプリケーションにJuliaを埋め込む場合は、次の制約に違反しないよう注意する必要があります。

  * `jl_init()`は、アプリケーションの存続期間中に1回だけ呼び出せます。`jl_atexit_hook()`も同様であり、`jl_init()`の後にのみ呼び出せます。
  * `jl_...()` API関数を呼び出せるのは、`jl_init()`が呼び出されたスレッド、またはJuliaランタイムが起動したスレッドだけです。ユーザーが起動したスレッドからJulia API関数を呼び出すことはサポートされておらず、未定義の動作やクラッシュにつながる可能性があります。

上記の2つ目の条件から、Juliaが起動していないスレッドから`jl_...()`関数を安全に呼び出すことはできません（ただし、`jl_init()`を呼び出したスレッドは例外です）。たとえば、次のコードはサポートされておらず、高い確率でセグメンテーション違反が発生します。

```c
void *func(void*)
{
    // Wrong, jl_eval_string() called from thread that was not started by Julia
    jl_eval_string("println(Threads.threadid())");
    return NULL;
}

int main()
{
    pthread_t t;

    jl_init();

    // Start a new thread
    pthread_create(&t, NULL, func, NULL);
    pthread_join(t, NULL);

    jl_atexit_hook(0);
}
```

代わりに、Juliaの呼び出しをすべて同じユーザー作成スレッドから行えば、問題なく動作します。

```c
void *func(void*)
{
    // Okay, all jl_...() calls from the same thread,
    // even though it is not the main application thread
    jl_init();
    jl_eval_string("println(Threads.threadid())");
    jl_atexit_hook(0);
    return NULL;
}

int main()
{
    pthread_t t;
    // Create a new thread, which runs func()
    pthread_create(&t, NULL, func, NULL);
    pthread_join(t, NULL);
}
```

Julia自身が起動したスレッドからJulia C APIを呼び出す例を示します。

```c
#include <julia/julia.h>
JULIA_DEFINE_FAST_TLS

double c_func(int i)
{
    printf("[C %08x] i = %d\n", pthread_self(), i);

    // Call the Julia sqrt() function to compute the square root of i, and return it
    jl_value_t *sqrt = jl_get_function(jl_base_module, "sqrt");
    jl_value_t* arg = jl_box_int32(i);
    double ret = jl_unbox_float64(jl_call1(sqrt, arg));

    return ret;
}

int main()
{
    jl_init();

    // Define a Julia function func() that calls our c_func() defined in C above
    jl_eval_string("func(i) = ccall(:c_func, Float64, (Int32,), i)");

    // Call func() multiple times, using multiple threads to do so
    jl_eval_string("println(Threads.threadpoolsize())");
    jl_eval_string("use(i) = println(\"[J $(Threads.threadid())] i = $(i) -> $(func(i))\")");
    jl_eval_string("Threads.@threads for i in 1:5 use(i) end");

    jl_atexit_hook(0);
}
```

このコードをJuliaスレッド2つで実行すると、次の出力が得られます（注: 出力は実行ごと、システムごとに異なります）。

```sh
$ JULIA_NUM_THREADS=2 ./thread_example
2
[C 3bfd9c00] i = 1
[C 23938640] i = 4
[J 1] i = 1 -> 1.0
[C 3bfd9c00] i = 2
[J 1] i = 2 -> 1.4142135623730951
[C 3bfd9c00] i = 3
[J 2] i = 4 -> 2.0
[C 23938640] i = 5
[J 1] i = 3 -> 1.7320508075688772
[J 2] i = 5 -> 2.23606797749979
```

このように、Juliaスレッド1はpthread ID 3bfd9c00に、Juliaスレッド2はID 23938640に対応しています。これは、Cレベルで複数のスレッドが実際に使われており、それらのスレッドからJulia C APIのルーチンを安全に呼び出せることを示しています。
