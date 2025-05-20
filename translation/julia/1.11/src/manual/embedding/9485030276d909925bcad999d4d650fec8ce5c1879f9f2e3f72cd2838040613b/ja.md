# Embedding Julia

私たちが [Calling C and Fortran Code](@ref) で見たように、Julia には C で書かれた関数を呼び出すためのシンプルで効率的な方法があります。しかし、逆のことが必要な状況もあります：C コードから Julia 関数を呼び出すことです。これは、すべてを C/C++ で書き直すことなく、Julia コードをより大きな C/C++ プロジェクトに統合するために使用できます。Julia にはこれを可能にする C API があります。ほとんどのプログラミング言語には C 関数を呼び出す方法があるため、Julia の C API はさらに言語ブリッジを構築するためにも使用できます（例：Python、Rust、または C# から Julia を呼び出す）。Rust と C++ は C 埋め込み API を直接使用できますが、両方ともそれを助けるパッケージがあります。C++ 用の [Jluna](https://github.com/Clemapfel/jluna) が便利です。

## High-Level Embedding

**Note**: This section covers embedding Julia code in C on Unix-like operating systems. For doing this on Windows, please see the section following this, [High-Level Embedding on Windows with Visual Studio](@ref).

私たちは、Juliaを初期化し、いくつかのJuliaコードを呼び出すシンプルなCプログラムから始めます：

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

このプログラムを構築するには、Juliaヘッダーへのパスをインクルードパスに追加し、`libjulia`にリンクする必要があります。たとえば、Juliaが`$JULIA_DIR`にインストールされている場合、上記のテストプログラム`test.c`を`gcc`を使用してコンパイルすることができます:

```
gcc -o test -fPIC -I$JULIA_DIR/include/julia -L$JULIA_DIR/lib -Wl,-rpath,$JULIA_DIR/lib test.c -ljulia
```

代わりに、Juliaソースツリーの`test/embedding/`フォルダーにある`embedding.c`プログラムを見てください。ファイル`cli/loader_exe.c`プログラムは、`libjulia`にリンクしながら`jl_options`オプションを設定する方法の別の簡単な例です。

Juliaの他のC関数を呼び出す前に最初に行うべきことは、Juliaを初期化することです。これは、`jl_init`を呼び出すことで行われ、Juliaのインストール場所を自動的に特定しようとします。カスタムの場所を指定する必要がある場合や、読み込むシステムイメージを指定する必要がある場合は、代わりに`jl_init_with_image`を使用してください。

テストプログラムの2番目のステートメントは、`jl_eval_string`を呼び出してJuliaのステートメントを評価します。

プログラムが終了する前に、`jl_atexit_hook`を呼び出すことを強く推奨します。上記の例のプログラムは、`main`から戻る直前にこれを呼び出します。

!!! note
    現在、`libjulia`共有ライブラリと動的にリンクするには、`RTLD_GLOBAL`オプションを渡す必要があります。Pythonでは、これは次のようになります：

    ```
    >>> julia=CDLL('./libjulia.dylib',RTLD_GLOBAL)
    >>> julia.jl_init.argtypes = []
    >>> julia.jl_init()
    250593296
    ```


!!! note
    もしJuliaプログラムがメイン実行ファイルからシンボルにアクセスする必要がある場合、Linuxでコンパイル時に`julia-config.jl`によって生成されたものに加えて、`-Wl,--export-dynamic`リンカーフラグを追加する必要があるかもしれません。共有ライブラリをコンパイルする際には、これは必要ありません。


### Using julia-config to automatically determine build parameters

スクリプト `julia-config.jl` は、埋め込みJuliaを使用するプログラムに必要なビルドパラメータを特定するのを助けるために作成されました。このスクリプトは、呼び出された特定のJuliaディストリビューションのビルドパラメータとシステム構成を使用して、そのディストリビューションと相互作用するための埋め込みプログラムに必要なコンパイラフラグをエクスポートします。このスクリプトは、Juliaの共有データディレクトリにあります。

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

このスクリプトの簡単な使い方は、コマンドラインからです。`julia-config.jl` が `/usr/local/julia/share/julia` にあると仮定すると、コマンドラインから直接呼び出すことができ、3つのフラグの任意の組み合わせを受け取ります：

```
/usr/local/julia/share/julia/julia-config.jl
Usage: julia-config [--cflags|--ldflags|--ldlibs]
```

上記の例のソースがファイル `embed_example.c` に保存されている場合、次のコマンドを使用してLinuxおよびWindows（MSYS2環境）で実行可能なプログラムにコンパイルします。macOSでは、`gcc` の代わりに `clang` を使用してください。

```
/usr/local/julia/share/julia/julia-config.jl --cflags --ldflags --ldlibs | xargs gcc embed_example.c
```

#### Use in Makefiles

一般的に、埋め込みプロジェクトは上記の例よりも複雑になるため、以下では一般的なmakefileサポートも提供します。これは、**shell**マクロ展開の使用によりGNU makeを前提としています。さらに、`julia-config.jl`は通常`/usr/local`ディレクトリにありますが、そうでない場合は、Julia自体を使用して`julia-config.jl`を見つけることができ、makefileはこれを活用できます。上記の例はmakefileを使用するように拡張されています：

```
JL_SHARE = $(shell julia -e 'print(joinpath(Sys.BINDIR, Base.DATAROOTDIR, "julia"))')
CFLAGS   += $(shell $(JL_SHARE)/julia-config.jl --cflags)
CXXFLAGS += $(shell $(JL_SHARE)/julia-config.jl --cflags)
LDFLAGS  += $(shell $(JL_SHARE)/julia-config.jl --ldflags)
LDLIBS   += $(shell $(JL_SHARE)/julia-config.jl --ldlibs)

all: embed_example
```

現在、ビルドコマンドは単に `make` です。

## High-Level Embedding on Windows with Visual Studio

`JULIA_DIR` 環境変数が設定されていない場合は、Visual Studio を起動する前にシステムパネルを使用して追加してください。`JULIA_DIR` の下の `bin` フォルダーは、システムの PATH に含まれている必要があります。

Visual Studioを開き、新しいコンソールアプリケーションプロジェクトを作成します。 'stdafx.h' ヘッダーファイルを開き、最後に以下の行を追加します:

```c
#include <julia.h>
```

次に、プロジェクト内の main() 関数をこのコードに置き換えてください：

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

次のステップは、Juliaのインクルードファイルとライブラリを見つけるためにプロジェクトを設定することです。Juliaのインストールが32ビットか64ビットかを知ることが重要です。進む前に、Juliaのインストールに対応しないプラットフォーム設定を削除してください。

プロジェクトのプロパティダイアログを使用して、`C/C++` | `General`に移動し、Additional Include Directoriesプロパティに`$(JULIA_DIR)\include\julia\`を追加します。次に、`Linker` | `General`セクションに移動し、Additional Library Directoriesプロパティに`$(JULIA_DIR)\lib`を追加します。最後に、`Linker` | `Input`の下で、ライブラリのリストに`libjulia.dll.a;libopenlibm.dll.a;`を追加します。

この時点で、プロジェクトはビルドされ、実行されるべきです。

## Converting Types

実際のアプリケーションは、式を実行するだけでなく、その値をホストプログラムに返す必要があります。 `jl_eval_string` は `jl_value_t*` を返し、これはヒープに割り当てられたJuliaオブジェクトへのポインタです。 [`Float64`](@ref) のような単純なデータ型をこの方法で保存することを `boxing` と呼び、保存されたプリミティブデータを抽出することを `unboxing` と呼びます。 2の平方根を計算し、Cで結果を読み取る改善されたサンプルプログラムの本体には、現在このコードが含まれています：

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

`ret`が特定のJulia型であるかどうかを確認するために、`jl_isa`、`jl_typeis`、または`jl_is_...`関数を使用できます。Juliaシェルに`typeof(sqrt(2.0))`と入力すると、返り値の型は[`Float64`](@ref)（Cの`double`）であることがわかります。上記のコードスニペットでは、ボックス化されたJulia値をCのdoubleに変換するために`jl_unbox_float64`関数が使用されます。

対応する `jl_box_...` 関数は、逆方向に変換するために使用されます：

```c
jl_value_t *a = jl_box_float64(3.0);
jl_value_t *b = jl_box_float32(3.0f);
jl_value_t *c = jl_box_int32(3);
```

次に見るように、特定の引数を持つJulia関数を呼び出すにはボクシングが必要です。

## Calling Julia Functions

`jl_eval_string`はCがJulia式の結果を取得することを可能にしますが、Cで計算された引数をJuliaに渡すことはできません。これを行うには、`jl_call`を使用してJulia関数を直接呼び出す必要があります。

```c
jl_function_t *func = jl_get_function(jl_base_module, "sqrt");
jl_value_t *argument = jl_box_float64(2.0);
jl_value_t *ret = jl_call1(func, argument);
```

最初のステップでは、`jl_get_function`を呼び出すことでJulia関数`sqrt`へのハンドルが取得されます。`jl_get_function`に渡される最初の引数は、`sqrt`が定義されている`Base`モジュールへのポインタです。次に、ダブル値は`jl_box_float64`を使用してボックス化されます。最後のステップでは、`jl_call1`を使用して関数が呼び出されます。異なる数の引数を便利に処理するために、`jl_call0`、`jl_call2`、および`jl_call3`関数も存在します。より多くの引数を渡すには、`jl_call`を使用します：

```
jl_value_t *jl_call(jl_function_t *f, jl_value_t **args, int32_t nargs)
```

その第二引数 `args` は `jl_value_t*` 引数の配列であり、`nargs` は引数の数です。

別の、より簡単な方法でJulia関数を呼び出すこともでき、それは [`@cfunction`](@ref) を介して行います。 `@cfunction` を使用すると、Julia側で型変換を行うことができ、通常はC側で行うよりも簡単です。上記の `sqrt` の例は、 `@cfunction` を使用して次のように書かれます：

```c
double (*sqrt_jl)(double) = jl_unbox_voidpointer(jl_eval_string("@cfunction(sqrt, Float64, (Float64,))"));
double ret = sqrt_jl(2.0);
```

最初にJuliaでC呼び出し可能な関数を定義し、そこから関数ポインタを抽出し、最終的にそれを呼び出します。高水準言語で型変換を行うことで簡素化するだけでなく、`@cfunction`ポインタを介してJulia関数を呼び出すことで、すべての引数が「ボックス化」される`jl_call`によって必要とされる動的ディスパッチのオーバーヘッドを排除し、ネイティブC関数ポインタと同等のパフォーマンスを持つはずです。

## Memory Management

私たちが見たように、JuliaオブジェクトはCでは`jl_value_t*`型のポインタとして表現されます。これにより、これらのオブジェクトを解放する責任が誰にあるのかという疑問が生じます。

通常、Juliaオブジェクトはガベージコレクタ（GC）によって解放されますが、GCはCからJulia値への参照を保持していることを自動的に認識しません。これは、GCがオブジェクトをあなたの下から解放する可能性があり、ポインタが無効になることを意味します。

GCは新しいJuliaオブジェクトが割り当てられるときにのみ実行されます。`jl_box_float64`のような呼び出しは割り当てを行いますが、割り当てはJuliaコードの実行中の任意のポイントでも発生する可能性があります。

Juliaを埋め込むコードを書く際、一般的に`jl_value_t*`値を`jl_...`呼び出しの間で使用することは安全です（GCはこれらの呼び出しによってのみトリガーされるため）。しかし、`jl_...`呼び出しの間に値が生存できることを確認するためには、Juliaに対してまだJulia [root](https://www.cs.purdue.edu/homes/hosking/690M/p611-fenichel.pdf) 値への参照を保持していることを伝える必要があります。このプロセスは「GCルーティング」と呼ばれます。値をルート化することで、ガベージコレクタがこの値を未使用として誤って識別し、その値を支えるメモリを解放しないようにすることができます。これは`JL_GC_PUSH`マクロを使用して行うことができます：

```c
jl_value_t *ret = jl_eval_string("sqrt(2.0)");
JL_GC_PUSH1(&ret);
// Do something with ret
JL_GC_POP();
```

`JL_GC_POP` 呼び出しは、前の `JL_GC_PUSH` によって確立された参照を解放します。 `JL_GC_PUSH` は C スタックに参照を格納するため、スコープを退出する前に必ず `JL_GC_POP` と正確にペアにする必要があります。つまり、関数が戻る前、または制御フローが `JL_GC_PUSH` が呼び出されたブロックを離れる前に行う必要があります。

複数のJulia値を一度にプッシュするには、`JL_GC_PUSH2`から`JL_GC_PUSH6`マクロを使用します:

```
JL_GC_PUSH2(&ret1, &ret2);
// ...
JL_GC_PUSH6(&ret1, &ret2, &ret3, &ret4, &ret5, &ret6);
```

配列のJulia値をプッシュするには、`JL_GC_PUSHARGS`マクロを使用できます。これは次のように使用できます：

```c
jl_value_t **args;
JL_GC_PUSHARGS(args, 2); // args can now hold 2 `jl_value_t*` objects
args[0] = some_value;
args[1] = some_other_value;
// Do something with args (e.g. call jl_... functions)
JL_GC_POP();
```

各スコープには `JL_GC_PUSH*` への呼び出しが1回だけ必要であり、単一の `JL_GC_POP` 呼び出しとペアである必要があります。ルート化したいすべての必要な変数を1回の `JL_GC_PUSH*` 呼び出しでプッシュできない場合、またはプッシュする変数が6つを超え、引数の配列を使用するオプションがない場合は、内部ブロックを使用できます：

```c
jl_value_t *ret1 = jl_eval_string("sqrt(2.0)");
JL_GC_PUSH1(&ret1);
jl_value_t *ret2 = 0;
{
    jl_function_t *func = jl_get_function(jl_base_module, "exp");
    ret2 = jl_call1(func, ret1);
    JL_GC_PUSH1(&ret2);
    // Do something with ret2.
    JL_GC_POP();    // This pops ret2.
}
JL_GC_POP();    // This pops ret1.
```

`jl_value_t*` の有効な値を `JL_GC_PUSH*` を呼び出す前に持っている必要はないことに注意してください。いくつかを `NULL` に初期化しておき、それらを `JL_GC_PUSH*` に渡してから実際の Julia 値を作成することは問題ありません。例えば：

```
jl_value_t *ret1 = NULL, *ret2 = NULL;
JL_GC_PUSH2(&ret1, &ret2);
ret1 = jl_eval_string("sqrt(2.0)");
ret2 = jl_eval_string("sqrt(3.0)");
// Use ret1 and ret2
JL_GC_POP();
```

関数（またはブロックスコープ）間で変数へのポインタを保持する必要がある場合、`JL_GC_PUSH*`を使用することはできません。この場合、Juliaのグローバルスコープで変数への参照を作成し保持する必要があります。これを達成する簡単な方法は、参照を保持するグローバルな`IdDict`を使用することで、GCによる解放を回避します。ただし、この方法は可変型に対してのみ正しく機能します。

```c
// This functions shall be executed only once, during the initialization.
jl_value_t* refs = jl_eval_string("refs = IdDict()");
jl_function_t* setindex = jl_get_function(jl_base_module, "setindex!");

...

// `var` is the variable we want to protect between function calls.
jl_value_t* var = 0;

...

// `var` is a `Vector{Float64}`, which is mutable.
var = jl_eval_string("[sqrt(2.0); sqrt(4.0); sqrt(6.0)]");

// To protect `var`, add its reference to `refs`.
jl_call3(setindex, refs, var, var);
```

変数が不変である場合、それは同等の可変コンテナ、または好ましくは `RefValue{Any}` にラップされてから `IdDict` にプッシュする必要があります。このアプローチでは、コンテナは C コードを使用して、例えば `jl_new_struct` 関数を使って作成または填充される必要があります。コンテナが `jl_call*` によって作成された場合、C コードで使用するためにポインタを再読み込みする必要があります。

```c
// This functions shall be executed only once, during the initialization.
jl_value_t* refs = jl_eval_string("refs = IdDict()");
jl_function_t* setindex = jl_get_function(jl_base_module, "setindex!");
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

GCは、他のどこにも変数への参照が保持されていない場合に、`refs`からその参照を削除することで、`delete!`関数を使用して変数のメモリを解放することが許可されます。

```c
jl_function_t* delete = jl_get_function(jl_base_module, "delete!");
jl_call2(delete, refs, rvar);
```

非常に単純なケースの代替として、`Vector{Any}` 型のグローバルコンテナを作成し、必要に応じてそこから要素を取得することが可能です。また、ポインタごとに1つのグローバル変数を作成することもできます。

```c
jl_module_t *mod = jl_main_module;
jl_sym_t *var = jl_symbol("var");
jl_binding_t *bp = jl_get_binding_wr(mod, var, 1);
jl_checked_assignment(bp, mod, var, val);
```

### Updating fields of GC-managed objects

ガーベジコレクタは、すべての古い世代のオブジェクトが若い世代のオブジェクトを指しているという前提の下で動作します。この前提を破るポインタが更新されるたびに、`jl_gc_wb`（書き込みバリア）関数を使ってコレクタに通知する必要があります。

```c
jl_value_t *parent = some_old_value, *child = some_young_value;
((some_specific_type*)parent)->field = child;
jl_gc_wb(parent, child);
```

一般的に、ランタイムでどの値が古くなるかを予測することは不可能なので、書き込みバリアはすべての明示的なストアの後に挿入する必要があります。注目すべき例外は、`parent`オブジェクトがちょうど割り当てられたばかりで、それ以降にガーベジコレクションが実行されていない場合です。ほとんどの`jl_...`関数は、時折ガーベジコレクションを呼び出すことがあることに注意してください。

配列のポインタのデータを直接更新する際にも、書き込みバリアが必要です。通常、`jl_array_ptr_set`を呼び出す方がはるかに好まれます。しかし、直接更新も可能です。例えば：

```c
jl_array_t *some_array = ...; // e.g. a Vector{Any}
void **data = jl_array_data(some_array, void*);
jl_value_t *some_value = ...;
data[0] = some_value;
jl_gc_wb(jl_array_owner(some_array), some_value);
```

### Controlling the Garbage Collector

GCを制御するためのいくつかの関数があります。通常の使用ケースでは、これらは必要ないはずです。

| Function             | Description                                  |
|:-------------------- |:-------------------------------------------- |
| `jl_gc_collect()`    | Force a GC run                               |
| `jl_gc_enable(0)`    | Disable the GC, return previous state as int |
| `jl_gc_enable(1)`    | Enable the GC,  return previous state as int |
| `jl_gc_is_enabled()` | Return current state as int                  |

## Working with Arrays

JuliaとCは、配列データをコピーせずに共有できます。次の例では、これがどのように機能するかを示します。

Juliaの配列はCではデータ型`jl_array_t*`によって表されます。基本的に、`jl_array_t`は次の内容を含む構造体です：

  * データ型に関する情報
  * データブロックへのポインタ
  * 配列のサイズに関する情報

物事をシンプルに保つために、1D配列から始めます。長さ10のFloat64要素を含む配列を作成するには、次のようにします：

```c
jl_value_t* array_type = jl_apply_array_type((jl_value_t*)jl_float64_type, 1);
jl_array_t* x          = jl_alloc_array_1d(array_type, 10);
```

代わりに、すでに配列を割り当てている場合は、そのデータの周りに薄いラッパーを生成できます：

```c
double *existingArray = (double*)malloc(sizeof(double)*10);
jl_array_t *x = jl_ptr_to_array_1d(array_type, existingArray, 10, 0);
```

最後の引数は、Juliaがデータの所有権を持つべきかどうかを示すブール値です。この引数がゼロ以外の場合、GCは配列がもはや参照されなくなったときにデータポインタに対して`free`を呼び出します。

`x`のデータにアクセスするには、`jl_array_data`を使用できます:

```c
double *xData = jl_array_data(x, double);
```

今、配列を埋めることができます：

```c
for (size_t i = 0; i < jl_array_nrows(x); i++)
    xData[i] = i;
```

今、`x`に対してインプレース操作を行うJulia関数を呼び出しましょう：

```c
jl_function_t *func = jl_get_function(jl_base_module, "reverse!");
jl_call1(func, (jl_value_t*)x);
```

配列を印刷することで、`x`の要素が逆になったことを確認できます。

### Accessing Returned Arrays

もしJulia関数が配列を返す場合、`jl_eval_string`および`jl_call`の戻り値は`jl_array_t*`にキャストできます:

```c
jl_function_t *func  = jl_get_function(jl_base_module, "reverse");
jl_array_t *y = (jl_array_t*)jl_call1(func, (jl_value_t*)x);
```

今、`y`の内容には以前と同様に`jl_array_data`を使用してアクセスできます。常に、配列が使用中である間は参照を保持することを忘れないでください。

### Multidimensional Arrays

ジュリアの多次元配列は、メモリに列優先順序で格納されます。以下は、2D配列を作成し、そのプロパティにアクセスするコードです：

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

注意してください。Juliaの配列は1ベースのインデックスを使用しますが、C APIは0ベースのインデックスを使用します（例えば、`jl_array_dim`を呼び出す際）ので、慣用的なCコードとして読みやすくなっています。

## Exceptions

Juliaのコードは例外をスローすることがあります。例えば、次のようなものです：

```c
jl_eval_string("this_function_does_not_exist()");
```

この呼び出しは何もしていないように見えます。しかし、例外がスローされたかどうかを確認することは可能です：

```c
if (jl_exception_occurred())
    printf("%s \n", jl_typeof_str(jl_exception_occurred()));
```

もしあなたが例外をサポートする言語（例：Python、C#、C++）からJulia C APIを使用している場合、`libjulia`への各呼び出しを、例外がスローされたかどうかをチェックし、ホスト言語で例外を再スローする関数でラップすることが理にかなっています。

### Throwing Julia Exceptions

Juliaの呼び出し可能な関数を書く際には、引数を検証し、エラーを示すために例外を投げる必要がある場合があります。典型的な型チェックは次のようになります：

```c
if (!jl_typeis(val, jl_float64_type)) {
    jl_type_error(function_name, (jl_value_t*)jl_float64_type, val);
}
```

一般的な例外は、次の関数を使用して発生させることができます：

```c
void jl_error(const char *str);
void jl_errorf(const char *fmt, ...);
```

`jl_error` は C 文字列を受け取り、`jl_errorf` は `printf` のように呼び出されます:

```c
jl_errorf("argument x = %d is too large", x);
```

この例では `x` は整数であると仮定されています。

### Thread-safety

一般的に、Julia C APIは完全にスレッドセーフではありません。マルチスレッドアプリケーションにJuliaを埋め込む際には、以下の制限を違反しないように注意する必要があります：

  * `jl_init()` はアプリケーションのライフタイム中に一度だけ呼び出すことができます。同様に `jl_atexit_hook()` も、`jl_init()` の後にのみ呼び出すことができます。
  * `jl_...()` API 関数は、`jl_init()` が呼び出されたスレッド、または Julia ランタイムによって開始されたスレッドからのみ呼び出すことができます。ユーザーが開始したスレッドから Julia API 関数を呼び出すことはサポートされておらず、未定義の動作やクラッシュを引き起こす可能性があります。

上記の第二の条件は、Juliaによって開始されていないスレッドから `jl_...()` 関数を安全に呼び出すことができないことを意味します（`jl_init()` を呼び出すスレッドは例外です）。例えば、以下のようなことはサポートされておらず、最も可能性が高いのはセグメンテーションフォルトを引き起こすことです：

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

代わりに、同じユーザー作成スレッドからすべてのJulia呼び出しを実行することができます:

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

Julia自身によって開始されたスレッドからJulia C APIを呼び出す例：

```c
#include <julia/julia.h>
JULIA_DEFINE_FAST_TLS

double c_func(int i)
{
    printf("[C %08x] i = %d\n", pthread_self(), i);

    // Call the Julia sqrt() function to compute the square root of i, and return it
    jl_function_t *sqrt = jl_get_function(jl_base_module, "sqrt");
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

このコードを2つのJuliaスレッドで実行すると、次の出力が得られます（注：出力は実行やシステムによって異なります）：

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

ご覧のとおり、Juliaスレッド1はpthread ID 3bfd9c00に対応し、Juliaスレッド2はID 23938640に対応しています。これは、Cレベルで複数のスレッドが使用されていることを示しており、これらのスレッドからJulia C APIルーチンを安全に呼び出すことができることを示しています。
