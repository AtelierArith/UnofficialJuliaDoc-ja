# Working with LLVM

これは LLVM のドキュメントに代わるものではなく、Julia 向けに LLVM を扱う際のヒントをまとめたものです。

## Overview of Julia to LLVM Interface

Julia はデフォルトで LLVM を動的リンクします。静的リンクするには、`USE_LLVM_SHLIB=0` を指定してビルドします。

Julia の AST を LLVM IR に lower するコード、または AST を直接解釈するコードは、ディレクトリ `src/` にあります。

| ファイル                             | 説明                                                 |
|:-------------------------------- |:-------------------------------------------------- |
| `aotcompile.cpp`                 | コンパイラの C インターフェースのエントリーポイントとオブジェクトファイルの出力          |
| `builtins.c`                     | 組み込み関数                                             |
| `ccall.cpp`                      | [`ccall`](@ref) の lowering                         |
| `cgutils.cpp`                    | lowering ユーティリティ。特に配列やタプルへのアクセスを扱う                 |
| `codegen.cpp`                    | コード生成の最上位部分、パスの一覧、組み込み関数の lowering                 |
| `debuginfo.cpp`                  | JIT コードのデバッグ情報を管理                                  |
| `disasm.cpp`                     | ネイティブオブジェクトファイルと JIT コードの逆アセンブルを処理                 |
| `gf.c`                           | ジェネリック関数                                           |
| `intrinsics.cpp`                 | intrinsic の lowering                               |
| `jitlayers.cpp`                  | JIT 固有のコード、ORC コンパイルレイヤー／ユーティリティ                   |
| `llvm-alloc-helpers.cpp`         | Julia 固有のエスケープ解析                                   |
| `llvm-alloc-opt.cpp`             | ヒープ割り当てをスタックに降格するカスタム LLVM パス                      |
| `llvm-cpufeatures.cpp`           | CPU ベースの関数（例: haveFMA）を lower するカスタム LLVM パス       |
| `llvm-demote-float16.cpp`        | 16 ビット浮動小数点演算を 32 ビット浮動小数点演算に lower するカスタム LLVM パス |
| `llvm-final-gc-lowering.cpp`     | GC 呼び出しを最終形に lower するカスタム LLVM パス                  |
| `llvm-gc-invariant-verifier.cpp` | Julia の GC 不変条件を検証するカスタム LLVM パス                   |
| `llvm-julia-licm.cpp`            | Julia 固有の intrinsic を hoist／sink するカスタム LLVM パス    |
| `llvm-late-gc-lowering.cpp`      | GC 追跡対象の値を root 化するカスタム LLVM パス                    |
| `llvm-multiversioning.cpp`       | 複数アーキテクチャ向けに sysimg コードを生成するカスタム LLVM パス           |
| `llvm-propagate-addrspaces.cpp`  | addrspace を正規化するカスタム LLVM パス                       |
| `llvm-ptls.cpp`                  | TLS 操作を lower するカスタム LLVM パス                       |
| `llvm-remove-addrspaces.cpp`     | Julia の addrspace を削除するカスタム LLVM パス                |
| `llvm-remove-ni.cpp`             | Julia の非積分 addrspace を削除するカスタム LLVM パス             |
| `llvm-simdloop.cpp`              | [`@simd`](@ref) 用のカスタム LLVM パス                     |
| `pipeline.cpp`                   | 新しいパスマネージャーのパイプライン、パイプラインの解析                       |
| `sys.c`                          | I/O およびオペレーティングシステムのユーティリティ関数                      |

`.cpp` ファイルの一部は、ひとまとまりになって単一のオブジェクトにコンパイルされます。

intrinsic と builtin の違いは、builtin が他の Julia 関数と同様に使える第一級関数であるのに対し、intrinsic はボックス化されていないデータに対してのみ動作するため、引数の型が静的に決まっていなければならない点です。

### [Alias Analysis](@id LLVM-Alias-Analysis)

現在、Julia は LLVM の [Type Based Alias Analysis](https://llvm.org/docs/LangRef.html#tbaa-metadata) を使用しています。インクルード関係を説明するコメントを探すには、`src/codegen.cpp` 内で `static MDNode*` を検索してください。

`-O` オプションを指定すると、LLVM の [Basic Alias Analysis](https://llvm.org/docs/AliasAnalysis.html#the-basic-aa-pass) が有効になります。

## Building Julia with a different version of LLVM

LLVM のデフォルトバージョンは `deps/llvm.version` で指定されています。トップレベルディレクトリに `Make.user` というファイルを作成し、たとえば次のような行を追加すれば、バージョンを上書きできます。

```
LLVM_VER = 13.0.0
```

LLVM のリリース番号のほか、`DEPS_GIT = llvm` と `USE_BINARYBUILDER_LLVM = 0` を組み合わせて、LLVM の最新の開発版を使ったビルドもできます。

`Make.user` ファイルで `LLVM_DEBUG = 1` または `LLVM_DEBUG = Release` を設定すると、LLVM のデバッグ版をビルドするよう指定できます。前者では LLVM が最適化なしでビルドされ、後者では最適化ありでビルドされます。必要に応じては後者で十分で、ビルドもかなり高速です。`LLVM_DEBUG = Release` を使う場合は、各種パスの診断情報を有効にするため、`LLVM_ASSERTIONS = 1` も設定するとよいでしょう。このオプションがデフォルトで有効になるのは `LLVM_DEBUG = 1` のみです。

## Passing options to LLVM

環境変数 [`JULIA_LLVM_ARGS`](@ref JULIA_LLVM_ARGS) を使って、LLVM にオプションを渡せます。以下は `bash` 構文での設定例です。

  * `export JULIA_LLVM_ARGS=-print-after-all` は各パスの実行後に IR を出力します。
  * `export JULIA_LLVM_ARGS=-debug-only=loop-vectorize` はループベクトライザーの LLVM `DEBUG(...)` 診断情報を出力します。「Unknown command line argument」という警告が出る場合は、LLVM を `LLVM_ASSERTIONS = 1` を指定して再ビルドしてください。
  * `export JULIA_LLVM_ARGS=-help` は利用可能なオプションの一覧を表示します。`export JULIA_LLVM_ARGS=-help-hidden` では、さらに多くのオプションが表示されます。
  * `export JULIA_LLVM_ARGS="-fatal-warnings -print-options"` は複数のオプションを使う例です。

### Useful `JULIA_LLVM_ARGS` parameters

  * `-print-after=PASS`: `PASS` の実行後に IR を出力します。パスによる変更の確認に便利です。
  * `-print-before=PASS`: `PASS` の実行前に IR を出力します。パスへの入力の確認に便利です。
  * `-print-changed`: パスによって IR が変更されるたびに IR を出力します。問題の原因となっているパスを絞り込むのに便利です。
  * `-print-(before|after)=MARKER-PASS`: Julia のパイプラインには、問題や最適化が発生している箇所を特定するためのマーカーパスがいくつか含まれています。マーカーパスとは、パイプラインに一度だけ現れ、IR を変換せず、print-before／print-after の対象を指定する目的でのみ使われるパスです。現在、パイプラインには次のマーカーパスがあります。

      * BeforeOptimization
      * BeforeEarlySimplification
      * AfterEarlySimplification
      * BeforeEarlyOptimization
      * AfterEarlyOptimization
      * BeforeLoopOptimization
      * BeforeLICM
      * AfterLICM
      * BeforeLoopSimplification
      * AfterLoopSimplification
      * AfterLoopOptimization
      * BeforeScalarOptimization
      * AfterScalarOptimization
      * BeforeVectorization
      * AfterVectorization
      * BeforeIntrinsicLowering
      * AfterIntrinsicLowering
      * BeforeCleanup
      * AfterCleanup
      * AfterOptimization
  * `-time-passes`: 各パスの所要時間を出力します。時間のかかっているパスの特定に便利です。
  * `-print-module-scope`: `-print-(before|after)` と併用すると、パスが受け取る IR 単位ではなくモジュール全体を取得します。
  * `-debug`: LLVM 全体にわたって大量のデバッグ情報を出力します。
  * `-debug-only=NAME` は、`DEBUG_TYPE` が `NAME` に定義されているファイルからデバッグ文を出力します。問題の背景情報を得るのに便利です。

## Debugging LLVM transformations in isolation

Julia システムの他の部分から切り離して LLVM の変換をデバッグすると便利な場合があります。たとえば、`julia` 内で問題を再現するのに時間がかかりすぎる場合や、LLVM のツール（bugpoint など）を活用したい場合です。

まず、次のコマンドで LLVM 用の開発ツールをインストールできます。

```
make -C deps install-llvm-tools
```

システムイメージ全体の未最適化 IR を取得するには、システムイメージのビルド時に `--output-unopt-bc unopt.bc` オプションを渡します。未最適化 IR は `unopt.bc` ファイルに出力されます。このファイルは通常どおり LLVM のツールに渡せます。`libjulia` は LLVM パスプラグインとして機能し、LLVM のツールに読み込むことで、この環境で Julia 固有のパスを利用できるようになります。また、IR 全体に Julia のパスパイプラインを適用する `-julia` メタパスも公開します。たとえば、旧パスマネージャーを使ってシステムイメージを生成するには、次のようにします。

```

llc -o sys.o opt.bc
cc -shared -o sys.so sys.o
```

新しいパスマネージャーを使ってシステムイメージを生成するには、次のようにします。

```
./usr/tools/opt -load-pass-plugin=libjulia-codegen.so --passes='julia' -o opt.bc unopt.bc
./usr/tools/llc -o sys.o opt.bc
./usr/tools/cc -shared -o sys.so sys.o
```

このシステムイメージは、通常どおり `julia` で読み込めます。

次のようにして、Julia の特定の関数だけを含む LLVM IR モジュールを出力することもできます。

```julia
fun, T = +, Tuple{Int,Int} # Substitute your function of interest here
optimize = false
open("plus.ll", "w") do file
    code_llvm(file, fun, T; raw=true, dump_module=true, optimize)
end
```

これらのファイルは、上記の未最適化 sysimg IR と同じ方法で処理できます。また、LLVM IR を自分で確認し、追加の検証も実行したい場合は、次のコマンドを使えます。

```
./usr/tools/opt -load-pass-plugin=libjulia-codegen.so --passes='julia' -S -verify-each plus.ll
```

（MacOS では `libjulia-codegen.dylib`、Windows では `libjulia-codegen.dll` になります。）

## Running the LLVM test suite

ローカルで llvm テストを実行するには、まずツールをインストールして Julia をビルドし、その後テストを実行します。

```
make -C deps install-llvm-tools
make -j julia-src-release
make -C test/llvmpasses
```

各テストファイルの先頭にあるコマンドを使って個別のテストファイルを直接実行する場合、最初の手順でツールが `./usr/tools/opt` にインストールされています。その後、`%s` をテストファイル名に手動で置き換えてください。

## Improving LLVM optimizations for Julia

LLVM のコード生成を改善するには、通常、Julia の lowering を LLVM のパスにとって扱いやすい形に変更するか、パス自体を改善します。

パスの改善を予定している場合は、[LLVM developer policy](https://llvm.org/docs/DeveloperPolicy.html) を必ず読んでください。最善の方法は、LLVM の `opt` ツールを使って、対象のコードとパスを切り離して調べられる形のコード例を作ることです。

1. 調べたい Julia コードの例を作成します。
2. `JULIA_LLVM_ARGS=-print-after-all` を使って IR を出力します。
3. 対象のパスが実行される直前の IR を取り出します。
4. デバッグメタデータを削除し、TBAA メタデータを手作業で修正します。

最後の手順にはかなり手間がかかります。よりよい方法があれば、ぜひ提案してください。

## The jlcall calling convention

Julia には未最適化コード用の汎用呼び出し規約があり、おおよそ次のような形です。

```c
jl_value_t *any_unoptimized_call(jl_value_t *, jl_value_t **, int);
```

第 1 引数はボックス化された関数オブジェクト、第 2 引数は引数を格納したスタック上の配列、第 3 引数は引数の個数です。素直に lowering するなら、引数配列用の alloca を出力できます。しかし、そうすると呼び出し箇所での使用が SSA の性質を失い、最適化（GC root の配置を含む）が大幅に難しくなります。そのため、代わりに次のように出力します。

```llvm
call %jl_value_t *@julia.call(jl_value_t *(*)(...) @any_unoptimized_call, %jl_value_t *%arg1, %jl_value_t *%arg2)
```

これにより、最適化器全体を通じて使用箇所の SSA 性を保てます。その後、GC root の配置時に、この呼び出しは元の C ABI に lower されます。

## GC root placement

GC root の配置は、パイプラインの後半で LLVM パスによって行われます。GC root の配置を遅らせることで、GC root を必要とするコードの周辺で LLVM がより積極的に最適化できるようになります。また、必要な GC root と GC root の store 操作の数も減らせます（LLVM は Julia の GC を理解していないため、GC フレームに格納された値に対して何をしてよいか、何をしてはいけないかが分からず、そうでなければ保守的にほとんど何もしません）。例として、エラー処理の経路を考えてみましょう。

```julia
if some_condition()
    #= Use some variables maybe =#
    error("An error occurred")
end
```

定数畳み込みの際に、LLVM が条件は常に false だと判断し、その基本ブロックを削除することがあります。しかし、GC root の lowering を早い段階で行うと、削除されたブロックで使われていた GC root スロットや、エラー処理の経路で使われるという理由だけでそれらのスロットに保持されていた値が、LLVM によって生存状態のまま維持されてしまいます。GC root の lowering を遅らせれば、どの値が GC 追跡対象かを過度に気にせず、定数畳み込みやデッドコード除去など、通常の最適化を LLVM に行わせることができます。

ただし、GC root の配置を遅らせるには、a) どのポインターが GC 追跡対象か、b) そのようなポインターのすべての使用箇所を特定できなければなりません。したがって、GC 配置パスの目的は単純です。

必要な GC root とその store の数を最小限に抑えつつ、各セーフポイントで、生存中の GC 追跡対象ポインター（つまり、その地点以降にそのポインターの使用箇所を含む経路があるもの）が、いずれかの GC スロットに格納されていることを保証します。

### Representation

主な難しさは、プログラムが最適化器を通過した後でも、GC 追跡対象ポインターとその使用箇所を特定できる IR 表現を選ぶことです。この設計では、次の 3 つの LLVM 機能を利用します。

  * カスタムアドレス空間
  * Operand Bundle
  * 非積分ポインター

カスタムアドレス空間を使うと、最適化を通じて保持する必要のある整数値で各ポインターにタグを付けられます。コンパイラは、元のプログラムに存在しなかったアドレス空間間のキャストを挿入してはならず、load／store などの操作でポインターのアドレス空間を変更してはなりません。これにより、最適化の影響を受けにくい形で、どのポインターが GC 追跡対象かを注釈できます。メタデータでは同じことは実現できません。メタデータは、プログラムの意味を変えずに常に破棄できるものであるべきです。しかし、GC 追跡対象ポインターを特定できないと、プログラムの動作が大きく変わり、おそらくクラッシュしたり誤った結果を返したりします。現在、次の 3 種類のアドレス空間を使っています（番号は `src/codegen_shared.cpp` で定義されています）。

  * GC 追跡対象ポインター（現在は 10）: GC フレームに格納される可能性のある、ボックス化された値へのポインターです。C 側の `jl_value_t*` ポインターにおおむね相当します。注: このアドレス空間に、GC スロットに格納できないポインターを置くことは決して許されません。
  * 派生ポインター（現在は 11）: GC 追跡対象ポインターから派生したポインターです。これらのポインターを使うと、元のポインターも使用されたものとして扱われます。ただし、派生ポインター自体を GC に認識させる必要はありません。GC root 配置パスは、必ずこのポインターの派生元である GC 追跡対象ポインターを見つけ、それを root 化しなければなりません。
  * 呼び出し先 root 化ポインター（現在は 12）: 呼び出し先で root 化された値という概念を表すためのユーティリティ用アドレス空間です。このアドレス空間の値はすべて GC root に格納可能でなければなりません（将来的にはこの条件を緩和できる可能性があります）。ただし、他のポインターとは異なり、呼び出しに渡す際に root 化する必要はありません（定義から呼び出しまでの間に別のセーフポイントをまたいで生存する場合は、root 化が必要です）。
  * 追跡対象オブジェクトからロードされたポインター（現在は 13）: 配列で使われます。配列自体は管理対象データへのポインターを保持しています。このデータ領域は配列が所有しますが、それ自体は GC 追跡対象オブジェクトではありません。コンパイラは、このポインターが生存している間、ポインターのロード元であるオブジェクトも生存し続けることを保証します。

### Invariants

GC root 配置パスはいくつかの不変条件を前提としており、フロントエンドはこれらを守り、最適化器はこれらを維持する必要があります。

まず、許可されるアドレス空間キャストは次のものに限られます。

  * 0->{Tracked,Derived,CalleeRooted}: 追跡対象外のポインターを、他のいずれかのアドレス空間に変換することは許されます。ただし、最適化器には、その値を root 化しない広い裁量がある点に注意してください。GC root が必要な値、またはその値から派生した値がプログラムのどこかにある場合、アドレス空間 0 の値をプログラム内に置くことは決して安全ではありません。
  * Tracked->Derived: 内部値を変換する標準的な経路です。配置パスはこれを探し、使用箇所に対応するベースポインターを特定します。
  * Tracked->CalleeRooted: Addrspace CalleeRooted は、GC root が不要であることを示すヒントにすぎません。ただし、Derived->CalleeRooted への変換は禁止されています。このアドレス空間でも、ポインターは通常 GC スロットに格納可能であるべきだからです。

次に、何を使用箇所とみなすかを考えます。

  * ロードされた値がいずれかのアドレス空間に属する load
  * いずれかのアドレス空間に属する値を、ある場所に格納する store
  * いずれかのアドレス空間に属するポインターへの store
  * いずれかのアドレス空間に属する値をオペランドに持つ呼び出し
  * 引数配列に値を含む、jlcall ABI の呼び出し
  * return 命令

Tracked／Derived アドレス空間では、load／store と単純な呼び出しを明示的に許可しています。jlcall の引数配列の要素は、必ず Tracked アドレス空間に属していなければなりません（ABI 上、有効な `jl_value_t*` ポインターである必要があります）。return 命令も同様です（ただし、構造体の戻り値引数には、どのアドレス空間も指定できます）。CalleeRooted アドレス空間のポインターに許される使用は、呼び出しへの受け渡しだけです（その場合、オペランドの型も適切でなければなりません）。

さらに、addrspace Tracked では `getelementptr` を禁止しています。noop でない限り、結果のポインターは GC スロットに有効な形で格納できず、このアドレス空間に属してはならないためです。そのようなポインターが必要な場合は、まず addrspace Derived に変換してください。

最後に、これらのアドレス空間では `inttoptr`／`ptrtoint` 命令を禁止しています。これらの命令があると、一部の `i64` 値が実際には GC 追跡対象であることになります。GC に関係するポインターを特定できなければならないという前述の要件に反するため、これは問題です。この不変条件は、LLVM 5.0 で導入された「非積分ポインター」機能を使って実現しています。この機能により、最適化器がこれらの操作を導入する最適化を行えなくなります。なお、JIT 時に静的定数を挿入することは引き続き可能です。その場合は、アドレス空間 0 で `inttoptr` を使い、その後で適切なアドレス空間に変換します。

### Supporting [`ccall`](@ref)

これまでの説明で触れていない重要な点として、[`ccall`](@ref) の扱いがあります。[`ccall`](@ref) には、使用箇所の位置とスコープが一致しないという特異な性質があります。例を見てみましょう。

```julia
A = randn(1024)
ccall(:foo, Cvoid, (Ptr{Float64},), A)
```

lowering の際、コンパイラは配列からポインターへの変換を挿入し、配列値への参照を破棄します。しかし、当然ながら、[`ccall`](@ref) の実行中は配列が生存し続けるようにしなければなりません。これをどのように実現するか、上記のコードを仮におおよそ次のように lowering した場合を見てみましょう。

```julia
return $(Expr(:foreigncall, Expr(:tuple, :(:foo)), Cvoid, svec(Ptr{Float64}), 0, :(:ccall), Expr(:foreigncall, Expr(:tuple, :(:jl_array_ptr)), Ptr{Float64}, svec(Any), 0, :(:ccall), :(A)), :(A)))
```

最後の `:(A)` は、lowering 時に挿入される追加の引数リストです。これは、[`ccall`](@ref) の実行中に生存させておく必要がある Julia レベルの値をコード生成器に伝えます。この情報は IR レベルで「operand bundle」として表現されます。operand bundle は、呼び出し箇所に付加される、実質的には偽の使用箇所です。IR レベルでは次のようになります。

```llvm
call void inttoptr (i64 ... to void (double*)*)(double* %5) [ "jl_roots"(%jl_value_t addrspace(10)* %A) ]
```

GC root 配置パスは、`jl_roots` operand bundle を通常のオペランドと同様に扱います。ただし、最後の手順として、GC root を挿入した後に operand bundle を削除し、命令選択を混乱させないようにします。

### Supporting [`pointer_from_objref`](@ref)

[`pointer_from_objref`](@ref) は、GC root 化をユーザーが明示的に制御する必要があるため、特殊です。上記の不変条件に従うと、この関数はアドレス空間 10 から 0 へのキャストを行うため不正です。しかし、状況によっては有用なため、専用の intrinsic を用意しています。

```llvm
declared %jl_value_t *julia.pointer_from_objref(%jl_value_t addrspace(10)*)
```

これは、GC root の lowering 後に、対応するアドレス空間キャストへ lower されます。ただし、この intrinsic を使う場合、対象の値が root 化されていることを保証する責任はすべて呼び出し側が負います。また、この intrinsic は使用箇所とはみなされないため、GC root 配置パスはこの関数に GC root を用意しません。そのため、値がシステムによって追跡されている間に、外部で root 化しておく必要があります。つまり、この操作の結果を使ってグローバル root を確立しようとしても無効です。最適化器がすでにその値を破棄している可能性があるためです。

### Keeping values alive in the absence of uses

コンパイラから見える使用箇所がない場合でも、オブジェクトを生存させておく必要があることがあります。オブジェクトのメモリ表現を直接扱う低レベルコードや、C コードと連携する必要があるコードでは、そのような場合があります。これを可能にするため、LLVM レベルで次の intrinsic を用意しています。

```
token @llvm.julia.gc_preserve_begin(...)
void @llvm.julia.gc_preserve_end(token)
```

（`token` 型を使えるようにするには、名前に `llvm.` が必要です。）これらの intrinsic の意味は次のとおりです。`gc_preserve_begin` 呼び出しによって支配されているセーフポイントのうち、対応する `gc_preserve_end` 呼び出し（つまり、`gc_preserve_begin` 呼び出しが返したトークンを引数に取る呼び出し）によって支配されていないものでは、`gc_preserve_begin` に渡された値が生存状態に保たれます。なお、`gc_preserve_begin` はこれらの値の通常の使用箇所としても扱われるため、標準のライフタイム規則によって preserve 領域に入る前も値が生存状態に保たれます。
