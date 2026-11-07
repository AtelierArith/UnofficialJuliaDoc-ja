# Working with LLVM

これはLLVMのドキュメントに代わるものではなく、Julia向けにLLVMを扱う際のヒントをまとめたものです。

## Overview of Julia to LLVM Interface

JuliaはデフォルトでLLVMを動的リンクします。静的リンクするには、`USE_LLVM_SHLIB=0`を指定してビルドします。

JuliaのASTをLLVM IRにloweringするコード、およびASTを直接解釈するコードは、`src/`ディレクトリにあります。

| ファイル                             | 説明                                             |
|:-------------------------------- |:---------------------------------------------- |
| `aotcompile.cpp`                 | コンパイラのCインターフェースのエントリーポイントとオブジェクトファイルの出力        |
| `builtins.c`                     | 組み込み関数                                         |
| `ccall.cpp`                      | [`ccall`](@ref)のlowering                       |
| `cgutils.cpp`                    | loweringユーティリティ。特に配列やタプルへのアクセス                 |
| `codegen.cpp`                    | コード生成のトップレベル、パス一覧、組み込み関数のlowering              |
| `debuginfo.cpp`                  | JITコードのデバッグ情報を管理                               |
| `disasm.cpp`                     | ネイティブオブジェクトファイルとJITコードの逆アセンブルを処理               |
| `gf.c`                           | ジェネリック関数                                       |
| `intrinsics.cpp`                 | intrinsicのlowering                             |
| `jitlayers.cpp`                  | JIT固有のコード、ORCコンパイルレイヤー／ユーティリティ                 |
| `llvm-alloc-helpers.cpp`         | Julia固有のエスケープ解析                                |
| `llvm-alloc-opt.cpp`             | ヒープ割り当てをスタックに降格するカスタムLLVMパス                    |
| `llvm-cpufeatures.cpp`           | CPU機能に基づく関数（例: haveFMA）をloweringするカスタムLLVMパス   |
| `llvm-demote-float16.cpp`        | 16ビット浮動小数点演算を32ビット浮動小数点演算にloweringするカスタムLLVMパス |
| `llvm-final-gc-lowering.cpp`     | GC呼び出しを最終形にloweringするカスタムLLVMパス                |
| `llvm-gc-invariant-verifier.cpp` | JuliaのGC不変条件を検証するカスタムLLVMパス                    |
| `llvm-julia-licm.cpp`            | Julia固有のintrinsicをhoist／sinkするカスタムLLVMパス       |
| `llvm-late-gc-lowering.cpp`      | GC追跡対象の値をroot化するカスタムLLVMパス                     |
| `llvm-multiversioning.cpp`       | 複数のアーキテクチャ向けにsysimgコードを生成するカスタムLLVMパス          |
| `llvm-propagate-addrspaces.cpp`  | addrspaceを正規化するカスタムLLVMパス                      |
| `llvm-ptls.cpp`                  | TLS操作をloweringするカスタムLLVMパス                     |
| `llvm-remove-addrspaces.cpp`     | Juliaのaddrspaceを削除するカスタムLLVMパス                 |
| `llvm-remove-ni.cpp`             | Juliaの非積分addrspaceを削除するカスタムLLVMパス              |
| `llvm-simdloop.cpp`              | [`@simd`](@ref)用のカスタムLLVMパス                    |
| `pipeline.cpp`                   | 新しいパスマネージャーのパイプライン、パイプラインの解析                   |
| `sys.c`                          | I/OおよびOSユーティリティ関数                              |

`.cpp`ファイルの一部は、まとめて1つのオブジェクトにコンパイルされます。

intrinsicとbuiltinの違いは、builtinが他のJulia関数と同様に使える第一級関数であるのに対し、intrinsicはボックス化されていないデータに対してのみ動作し、その引数を静的に型付けする必要がある点です。

### [Alias Analysis](@id LLVM-Alias-Analysis)

現在、JuliaはLLVMの[Type Based Alias Analysis](https://llvm.org/docs/LangRef.html#tbaa-metadata)を使用しています。インクルード関係を説明するコメントを探すには、`src/codegen.cpp`内で`static MDNode*`を検索してください。

`-O`オプションを指定すると、LLVMの[Basic Alias Analysis](https://llvm.org/docs/AliasAnalysis.html#the-basic-aa-pass)が有効になります。

## Building Julia with a different version of LLVM

LLVMのデフォルトバージョンは`deps/llvm.version`で指定されています。これを上書きするには、トップレベルディレクトリに`Make.user`というファイルを作成し、たとえば次のような行を追加します。

```
LLVM_VER = 13.0.0
```

LLVMのリリース番号に加えて、`DEPS_GIT = llvm`を`USE_BINARYBUILDER_LLVM = 0`と組み合わせると、LLVMの最新の開発版を使ってビルドできます。

`Make.user`ファイルで`LLVM_DEBUG = 1`または`LLVM_DEBUG = Release`を設定すると、LLVMのデバッグ版をビルドすることもできます。前者では最適化を一切行わないLLVMがビルドされ、後者では最適化されたLLVMがビルドされます。用途によっては後者で十分で、ビルドもかなり高速です。`LLVM_DEBUG = Release`を使う場合は、各パスの診断情報を有効にするため、`LLVM_ASSERTIONS = 1`も設定するとよいでしょう。このオプションがデフォルトで有効になるのは、`LLVM_DEBUG = 1`だけです。

## Passing options to LLVM

環境変数[`JULIA_LLVM_ARGS`](@ref JULIA_LLVM_ARGS)を使って、LLVMにオプションを渡せます。以下は、`bash`形式での設定例です。

  * `export JULIA_LLVM_ARGS=-print-after-all`: 各パスの実行後にIRを出力します。
  * `export JULIA_LLVM_ARGS=-debug-only=loop-vectorize`: ループベクトライザーに関するLLVMの`DEBUG(...)`診断情報を出力します。「Unknown command line argument」という警告が出る場合は、`LLVM_ASSERTIONS = 1`を指定してLLVMを再ビルドしてください。
  * `export JULIA_LLVM_ARGS=-help`: 使用可能なオプションの一覧を表示します。`export JULIA_LLVM_ARGS=-help-hidden`では、さらに多くのオプションが表示されます。
  * `export JULIA_LLVM_ARGS="-fatal-warnings -print-options"`: 複数のオプションを使う方法の例です。

### Useful `JULIA_LLVM_ARGS` parameters

  * `-print-after=PASS`: `PASS`の実行後にIRを出力します。パスによる変更の確認に便利です。
  * `-print-before=PASS`: `PASS`の実行前にIRを出力します。パスへの入力の確認に便利です。
  * `-print-changed`: パスによってIRが変更されるたびにIRを出力します。問題の原因となっているパスを絞り込むのに便利です。
  * `-print-(before|after)=MARKER-PASS`: Juliaのパイプラインには複数のマーカーパスが含まれており、問題や最適化が発生する箇所の特定に利用できます。マーカーパスとは、パイプラインに一度だけ現れ、IRを変換せず、print-before／print-afterの対象を指定する目的でのみ使われるパスです。現在、パイプラインには次のマーカーパスがあります。

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
  * `-time-passes`: 各パスの実行時間を出力します。時間のかかっているパスの特定に便利です。
  * `-print-module-scope`: `-print-(before|after)`と併用すると、パスが受け取るIR単位ではなくモジュール全体を取得します。
  * `-debug`: LLVM全体にわたって大量のデバッグ情報を出力します。
  * `-debug-only=NAME`: `DEBUG_TYPE`が定義されているファイルから`NAME`までのデバッグ文を出力します。問題の背景情報を得るのに便利です。

## Debugging LLVM transformations in isolation

Juliaシステムの他の部分から切り離してLLVMの変換をデバッグすると便利な場合があります。たとえば、`julia`内で問題を再現するのに時間がかかりすぎる場合や、LLVMのツール（bugpointなど）を利用したい場合です。

まず、LLVMを扱うための開発ツールを次のようにインストールします。

```
make -C deps install-llvm-tools
```

システムイメージ全体の未最適化IRを取得するには、システムイメージのビルド時に`--output-unopt-bc unopt.bc`オプションを渡します。未最適化IRは`unopt.bc`ファイルに出力されます。このファイルは通常どおりLLVMのツールに渡せます。`libjulia`はLLVMのパスプラグインとして機能し、LLVMのツールに読み込むことで、この環境でJulia固有のパスを利用できるようになります。また、IR全体にJuliaのパスパイプラインを適用する`-julia`メタパスも提供します。たとえば、旧パスマネージャーを使ってシステムイメージを生成するには、次のようにします。

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

このシステムイメージは、通常どおり`julia`で読み込めます。

次のようにして、Juliaの特定の関数だけを含むLLVM IRモジュールをダンプすることもできます。

```julia
fun, T = +, Tuple{Int,Int} # Substitute your function of interest here
optimize = false
open("plus.ll", "w") do file
    code_llvm(file, fun, T; raw=true, dump_module=true, optimize)
end
```

これらのファイルは、上記の未最適化sysimg IRと同じ方法で処理できます。また、LLVM IRを自分で確認し、追加の検証も実行したい場合は、次のようにします。

```
./usr/tools/opt -load-pass-plugin=libjulia-codegen.so --passes='julia' -S -verify-each plus.ll
```

（MacOSでは`libjulia-codegen.dylib`、Windowsでは`libjulia-codegen.dll`になります。）

## Running the LLVM test suite

llvmテストをローカルで実行するには、まずツールをインストールしてJuliaをビルドし、その後テストを実行します。

```
make -C deps install-llvm-tools
make -j julia-src-release
make -C test/llvmpasses
```

各テストファイルの先頭にあるコマンドを使って個別のテストファイルを直接実行する場合、最初の手順でツールが`./usr/tools/opt`にインストールされています。その後、`%s`をテストファイル名に手動で置き換えてください。

## Improving LLVM optimizations for Julia

LLVMのコード生成を改善するには、通常、LLVMのパスが扱いやすい形になるようJuliaのloweringを変更するか、パス自体を改善します。

パスの改善を予定している場合は、必ず[LLVM developer policy](https://llvm.org/docs/DeveloperPolicy.html)を読んでください。最善の方法は、LLVMの`opt`ツールを使って、対象のコードとパスを切り離して調べられる形のコード例を作ることです。

1. 対象となるJuliaコードの例を作成します。
2. `JULIA_LLVM_ARGS=-print-after-all`を使ってIRをダンプします。
3. 対象のパスが実行される直前のIRを取り出します。
4. デバッグメタデータを削除し、TBAAメタデータを手作業で修正します。

最後の手順には手間がかかります。よりよい方法があれば、ぜひ提案してください。

## The jlcall calling convention

Juliaには、未最適化コード向けの汎用呼び出し規約があり、おおよそ次のようになります。

```c
jl_value_t *any_unoptimized_call(jl_value_t *, jl_value_t **, int);
```

第1引数はボックス化された関数オブジェクト、第2引数は引数を格納したスタック上の配列、第3引数は引数の個数です。単純にloweringして引数配列用のallocaを出力することもできます。しかし、それでは呼び出し箇所での使用がSSAの性質を失い、最適化（GC rootの配置を含む）が大幅に難しくなります。そのため、代わりに次のように出力します。

```llvm
call %jl_value_t *@julia.call(jl_value_t *(*)(...) @any_unoptimized_call, %jl_value_t *%arg1, %jl_value_t *%arg2)
```

これにより、オプティマイザー全体を通じて使用箇所のSSA性を保てます。その後、GC rootの配置時に、この呼び出しは元のC ABIにloweringされます。

## GC root placement

GC rootの配置は、パイプラインの後半でLLVMパスによって行われます。GC rootの配置を遅らせることで、GC rootを必要とするコードの周辺でLLVMがより積極的に最適化できるようになり、必要なGC rootとGC rootへのストア操作の数も減らせます（LLVMはJuliaのGCを理解していないため、GCフレームに格納された値に対して何をしてよいか、何をしてはいけないかが分からず、そうでなければ保守的にほとんど何もしません）。例として、エラー処理の経路を考えてみましょう。

```julia
if some_condition()
    #= Use some variables maybe =#
    error("An error occurred")
end
```

定数畳み込みの際に、LLVMが条件は常にfalseだと判断し、その基本ブロックを削除することがあります。しかし、GC rootのloweringを早い段階で行うと、削除されたブロックで使われていたGC rootスロットや、エラー処理の経路で使われるという理由だけでそのスロットに保持されていた値が、LLVMによって生存状態のまま維持されてしまいます。GC rootのloweringを遅らせれば、どの値がGC追跡対象かを過度に気にせず、定数畳み込みやデッドコード除去など、通常の最適化をLLVMに任せられます。

ただし、GC rootの配置を遅らせるには、a) どのポインターがGC追跡対象か、b) そのようなポインターのすべての使用箇所を特定できなければなりません。したがって、GC配置パスの目的は単純です。

必要なGC rootとそのストアの数を最小限に抑えつつ、各セーフポイントで、生存しているGC追跡対象ポインター（つまり、その地点以降にそのポインターの使用を含む経路があるもの）が、いずれかのGCスロットに格納されていることを保証します。

### Representation

主な課題は、プログラムがオプティマイザーを通過した後でも、GC追跡対象ポインターとその使用箇所を特定できるIR表現を選ぶことです。この設計では、次の3つのLLVM機能を利用します。

  * カスタムアドレス空間
  * Operand Bundle
  * 非積分ポインター

カスタムアドレス空間を使うと、最適化を通じて保持する必要がある各ポインターに整数値のタグを付けられます。コンパイラは、元のプログラムに存在しないアドレス空間間のキャストを挿入してはならず、load/storeなどの操作でポインターのアドレス空間を変更してはなりません。これにより、オプティマイザーの影響を受けにくい形で、どのポインターがGC追跡対象かを注釈できます。メタデータでは同じ目的を達成できない点に注意してください。メタデータは、プログラムの意味を変えずに常に破棄できるものであるべきです。しかし、GC追跡対象ポインターを特定できないと、プログラムの動作が大きく変わり、おそらくクラッシュしたり誤った結果を返したりします。現在、次の3種類のアドレス空間を使っています（番号は`src/codegen_shared.cpp`で定義されています）。

  * GC追跡対象ポインター（現在は10）: GCフレームに格納できる、ボックス化された値へのポインターです。C側の`jl_value_t*`ポインターにおおむね相当します。注: このアドレス空間に、GCスロットに格納できないポインターを置くことはできません。
  * 派生ポインター（現在は11）: GC追跡対象ポインターから派生したポインターです。これらのポインターの使用は、元のポインターの使用として扱われます。ただし、派生ポインター自体をGCに認識させる必要はありません。GC root配置パスは、派生元のGC追跡対象ポインターを必ず見つけ、それをroot化するポインターとして使わなければなりません。
  * 呼び出し先root化ポインター（現在は12）: 呼び出し先でroot化された値という概念を表すためのユーティリティ用アドレス空間です。このアドレス空間の値はすべてGC rootに格納可能でなければなりません（将来的にはこの条件を緩和できる可能性があります）。ただし、他のポインターとは異なり、呼び出しに渡す際にroot化する必要はありません（定義から呼び出しまでの間に別のセーフポイントをまたいで生存する場合は、root化が必要です）。
  * 追跡対象オブジェクトからロードされたポインター（現在は13）: 配列で使われます。配列自体は管理対象データへのポインターを持っています。このデータ領域は配列が所有しますが、それ自体はGC追跡対象オブジェクトではありません。コンパイラは、このポインターが生存している間、ロード元のオブジェクトも生存し続けることを保証します。

### Invariants

GC root配置パスはいくつかの不変条件を利用します。これらはフロントエンドが守り、オプティマイザーによって維持される必要があります。

まず、許可されるアドレス空間キャストは次のものだけです。

  * 0->{Tracked,Derived,CalleeRooted}: 追跡対象でないポインターを、他のいずれかのアドレス空間に変換できます。ただし、オプティマイザーには、その値をroot化しない広い裁量がある点に注意してください。GC rootが必要な値（またはその値から派生した値）がプログラムのどこかに存在する場合、アドレス空間0の値を使うのは決して安全ではありません。
  * Tracked->Derived: 内部値を変換する標準的な経路です。配置パスはこの変換を探し、各使用箇所のベースポインターを特定します。
  * Tracked->CalleeRooted: Addrspace CalleeRootedは、GC rootが不要であることを示すヒントにすぎません。ただし、Derived->CalleeRootedへの変換は禁止されています。このアドレス空間でも、ポインターは通常GCスロットに格納可能であるべきだからです。

次に、何を使用とみなすかを考えます。

  * ロードされた値がいずれかのアドレス空間に属するload
  * いずれかのアドレス空間に属する値を、ある場所に格納するstore
  * いずれかのアドレス空間に属するポインターへのstore
  * いずれかのアドレス空間に属する値をオペランドに持つ呼び出し
  * 引数配列に値を含む、jlcall ABIでの呼び出し
  * return命令

Tracked／Derivedアドレス空間でのload/storeと単純な呼び出しは明示的に許可しています。jlcallの引数配列の要素は、必ずTrackedアドレス空間に属していなければなりません（ABI上、有効な`jl_value_t*`ポインターである必要があります）。return命令も同様です（ただし、構造体の戻り値引数には任意のアドレス空間を指定できます）。CalleeRootedアドレス空間のポインターに許される使用は、適切な型のオペランドを持つ呼び出しに渡すことだけです。

さらに、Trackedアドレス空間での`getelementptr`は禁止しています。操作がno-opでない限り、結果のポインターはGCスロットに有効な形で格納できず、このアドレス空間に属してはならないためです。そのようなポインターが必要な場合は、まずDerivedアドレス空間に変換してください。

最後に、これらのアドレス空間では`inttoptr`／`ptrtoint`命令を禁止しています。これらの命令があると、一部の`i64`値が実際にはGC追跡対象であることになります。GCに関係するポインターを特定できるという要件が破られるため、これは問題です。この不変条件は、LLVM 5.0で導入されたLLVMの「非積分ポインター」機能によって実現されています。この機能により、オプティマイザーがこれらの操作を導入する最適化を行えなくなります。なお、JIT時に静的定数を挿入することは引き続き可能です。アドレス空間0で`inttoptr`を使い、その後、適切なアドレス空間に変換してください。

### Supporting [`ccall`](@ref)

これまでの説明で触れていない重要な点として、[`ccall`](@ref)の扱いがあります。[`ccall`](@ref)には、使用箇所とそのスコープが一致しないという特異な性質があります。例を見てみましょう。

```julia
A = randn(1024)
ccall(:foo, Cvoid, (Ptr{Float64},), A)
```

lowering時に、コンパイラは配列からポインターへの変換を挿入し、配列値への参照を破棄します。しかし、当然ながら、[`ccall`](@ref)の実行中は配列が生存し続けるようにする必要があります。これをどのように実現するか理解するため、上記のコードを仮にloweringした場合の例を見てみましょう。

```julia
return $(Expr(:foreigncall, Expr(:tuple, :(:foo)), Cvoid, svec(Ptr{Float64}), 0, :(:ccall), Expr(:foreigncall, Expr(:tuple, :(:jl_array_ptr)), Ptr{Float64}, svec(Any), 0, :(:ccall), :(A)), :(A)))
```

最後の`:(A)`は、lowering時に挿入される追加の引数リストです。これは、[`ccall`](@ref)の実行中に生存させておく必要があるJuliaレベルの値をコードジェネレーターに伝えます。この情報をIRレベルの「operand bundle」として表現します。operand bundleは、呼び出し箇所に付加される擬似的な使用です。IRレベルでは次のようになります。

```llvm
call void inttoptr (i64 ... to void (double*)*)(double* %5) [ "jl_roots"(%jl_value_t addrspace(10)* %A) ]
```

GC root配置パスは、`jl_roots` operand bundleを通常のオペランドとして扱います。ただし最後の手順として、GC rootを挿入した後、命令選択を混乱させないようoperand bundleを削除します。

### Supporting [`pointer_from_objref`](@ref)

[`pointer_from_objref`](@ref)は、GC root化をユーザーが明示的に制御する必要があるため、特殊です。上記の不変条件に照らすと、この関数はアドレス空間10から0へのキャストを行うため不正です。しかし、状況によっては有用なため、専用のintrinsicを用意しています。

```llvm
declared %jl_value_t *julia.pointer_from_objref(%jl_value_t addrspace(10)*)
```

これは、GC rootのlowering後に対応するアドレス空間キャストへloweringされます。ただし、このintrinsicを使う場合、対象の値がroot化されていることを保証する責任はすべて呼び出し側が負います。また、このintrinsicは使用として扱われないため、GC root配置パスはこの関数にGC rootを用意しません。そのため、値がシステムによって追跡されている間に、外部でroot化を行う必要があります。つまり、この操作の結果を使ってグローバルrootを確立することはできません。オプティマイザーがすでに値を破棄している可能性があるためです。

### Keeping values alive in the absence of uses

コンパイラから見える使用箇所がなくても、オブジェクトを生存させておく必要がある場合があります。オブジェクトのメモリ表現を直接操作する低レベルコードや、Cコードと連携するコードでは、このような状況が起こり得ます。これに対応するため、LLVMレベルで次のintrinsicを用意しています。

```
token @llvm.julia.gc_preserve_begin(...)
void @llvm.julia.gc_preserve_end(token)
```

（`token`型を使えるようにするには、名前に`llvm.`が必要です。）これらのintrinsicの意味は次のとおりです。`gc_preserve_begin`呼び出しに支配されているセーフポイントのうち、対応する`gc_preserve_end`呼び出し（つまり、`gc_preserve_begin`呼び出しが返したトークンを引数に取る呼び出し）には支配されていないものでは、`gc_preserve_begin`に渡された値が生存状態に保たれます。`gc_preserve_begin`はこれらの値の通常の使用としても扱われるため、標準的なlifetimeの意味論により、preserve領域に入る前も値は生存状態に保たれます。
