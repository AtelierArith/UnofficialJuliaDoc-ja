# Working with LLVM

これはLLVMのドキュメントの代わりではなく、JuliaのためにLLVMで作業するためのヒントのコレクションです。

## Overview of Julia to LLVM Interface

JuliaはデフォルトでLLVMに動的リンクします。静的リンクするには`USE_LLVM_SHLIB=0`でビルドしてください。

JuliaのASTをLLVM IRに変換するか、直接解釈するためのコードは`src/`ディレクトリにあります。

| File                             | Description                                                        |
|:-------------------------------- |:------------------------------------------------------------------ |
| `aotcompile.cpp`                 | Compiler C-interface entry and object file emission                |
| `builtins.c`                     | Builtin functions                                                  |
| `ccall.cpp`                      | Lowering [`ccall`](@ref)                                           |
| `cgutils.cpp`                    | Lowering utilities, notably for array and tuple accesses           |
| `codegen.cpp`                    | Top-level of code generation, pass list, lowering builtins         |
| `debuginfo.cpp`                  | Tracks debug information for JIT code                              |
| `disasm.cpp`                     | Handles native object file and JIT code diassembly                 |
| `gf.c`                           | Generic functions                                                  |
| `intrinsics.cpp`                 | Lowering intrinsics                                                |
| `jitlayers.cpp`                  | JIT-specific code, ORC compilation layers/utilities                |
| `llvm-alloc-helpers.cpp`         | Julia-specific escape analysis                                     |
| `llvm-alloc-opt.cpp`             | Custom LLVM pass to demote heap allocations to the stack           |
| `llvm-cpufeatures.cpp`           | Custom LLVM pass to lower CPU-based functions (e.g. haveFMA)       |
| `llvm-demote-float16.cpp`        | Custom LLVM pass to lower 16b float ops to 32b float ops           |
| `llvm-final-gc-lowering.cpp`     | Custom LLVM pass to lower GC calls to their final form             |
| `llvm-gc-invariant-verifier.cpp` | Custom LLVM pass to verify Julia GC invariants                     |
| `llvm-julia-licm.cpp`            | Custom LLVM pass to hoist/sink Julia-specific intrinsics           |
| `llvm-late-gc-lowering.cpp`      | Custom LLVM pass to root GC-tracked values                         |
| `llvm-lower-handlers.cpp`        | Custom LLVM pass to lower try-catch blocks                         |
| `llvm-muladd.cpp`                | Custom LLVM pass for fast-match FMA                                |
| `llvm-multiversioning.cpp`       | Custom LLVM pass to generate sysimg code on multiple architectures |
| `llvm-propagate-addrspaces.cpp`  | Custom LLVM pass to canonicalize addrspaces                        |
| `llvm-ptls.cpp`                  | Custom LLVM pass to lower TLS operations                           |
| `llvm-remove-addrspaces.cpp`     | Custom LLVM pass to remove Julia addrspaces                        |
| `llvm-remove-ni.cpp`             | Custom LLVM pass to remove Julia non-integral addrspaces           |
| `llvm-simdloop.cpp`              | Custom LLVM pass for [`@simd`](@ref)                               |
| `pipeline.cpp`                   | New pass manager pipeline, pass pipeline parsing                   |
| `sys.c`                          | I/O and operating system utility functions                         |

いくつかの `.cpp` ファイルは、単一のオブジェクトにコンパイルされるグループを形成します。

内蔵関数と内在関数の違いは、内蔵関数が他のJulia関数のように使用できる第一級関数であるのに対し、内在関数はアンボックスデータのみに作用できるため、その引数は静的に型付けされている必要があるということです。

### [Alias Analysis](@id LLVM-Alias-Analysis)

ジュリアは現在、LLVMの [Type Based Alias Analysis](https://llvm.org/docs/LangRef.html#tbaa-metadata) を使用しています。包含関係を文書化するコメントを見つけるには、 `src/codegen.cpp` で `static MDNode*` を探してください。

`-O`オプションはLLVMの[Basic Alias Analysis](https://llvm.org/docs/AliasAnalysis.html#the-basic-aa-pass)を有効にします。

## Building Julia with a different version of LLVM

デフォルトのLLVMのバージョンは`deps/llvm.version`に指定されています。これを上書きするには、トップレベルディレクトリに`Make.user`というファイルを作成し、次のような行を追加します:

```
LLVM_VER = 13.0.0
```

LLVMのリリース番号に加えて、`USE_BINARYBUILDER_LLVM = 0`と組み合わせて`DEPS_GIT = llvm`を使用することで、LLVMの最新の開発バージョンに対してビルドすることもできます。

LLVMのデバッグバージョンをビルドするように指定することもできます。これは、`Make.user`ファイル内で`LLVM_DEBUG = 1`または`LLVM_DEBUG = Release`のいずれかを設定することで行えます。前者はLLVMの完全に最適化されていないビルドであり、後者はLLVMの最適化されたビルドを生成します。ニーズに応じて、後者で十分であり、かなり速くなります。`LLVM_DEBUG = Release`を使用する場合は、異なるパスの診断を有効にするために`LLVM_ASSERTIONS = 1`も設定する必要があります。`LLVM_DEBUG = 1`のみがデフォルトでそのオプションを暗示します。

## Passing options to LLVM

LLVMにオプションを渡すには、環境変数 [`JULIA_LLVM_ARGS`](@ref JULIA_LLVM_ARGS) を使用します。以下は `bash` 構文を使用した設定の例です：

  * `export JULIA_LLVM_ARGS=-print-after-all` は、各パスの後にIRをダンプします。
  * `export JULIA_LLVM_ARGS=-debug-only=loop-vectorize` は、ループベクトル化のための LLVM `DEBUG(...)` 診断を出力します。「不明なコマンドライン引数」についての警告が表示された場合は、`LLVM_ASSERTIONS = 1` で LLVM を再ビルドしてください。
  * `export JULIA_LLVM_ARGS=-help` は利用可能なオプションのリストを表示します。 `export JULIA_LLVM_ARGS=-help-hidden` はさらに多くのオプションを表示します。
  * `export JULIA_LLVM_ARGS="-fatal-warnings -print-options"` は、複数のオプションを使用する方法の例です。

### Useful `JULIA_LLVM_ARGS` parameters

  * `-print-after=PASS`: `PASS`の実行後にIRを出力します。これは、パスによって行われた変更を確認するのに便利です。
  * `-print-before=PASS`: `PASS`の実行前にIRを印刷します。これは、パスへの入力を確認するのに便利です。
  * `-print-changed`: IRが変更されるたびにIRを出力します。これは、どのパスが問題を引き起こしているかを特定するのに役立ちます。
  * `-print-(before|after)=MARKER-PASS`: Juliaパイプラインには、問題や最適化が発生している場所を特定するために使用できるいくつかのマーカーパスが含まれています。マーカーパスは、パイプライン内に1回だけ現れ、IRに対して変換を行わないパスとして定義されており、print-before/print-afterをターゲットにするためだけに役立ちます。現在、パイプラインには以下のマーカーパスが存在します：

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
  * `-time-passes`: 各パスにかかる時間を表示し、どのパスが長時間かかっているかを特定するのに役立ちます。
  * `-print-module-scope`: `-print-(before|after)` と組み合わせて使用すると、パスによって受け取られる IR ユニットではなく、モジュール全体を取得します。
  * `-debug`: LLVM全体で多くのデバッグ情報を出力します
  * `-debug-only=NAME`は、`DEBUG_TYPE`が`NAME`に定義されているファイルからデバッグステートメントを出力し、問題に関する追加のコンテキストを得るのに役立ちます。

## Debugging LLVM transformations in isolation

時折、LLVMの変換をJuliaシステムの他の部分から独立してデバッグすることが有用な場合があります。例えば、`julia`内で問題を再現するのに時間がかかりすぎる場合や、LLVMのツール（例：bugpoint）を利用したい場合です。

LLVMを使用するための開発者ツールをインストールするには、次のコマンドを実行します：

```
make -C deps install-llvm-tools
```

システムイメージ全体の最適化されていないIRを取得するには、システムイメージビルドプロセスに`--output-unopt-bc unopt.bc`オプションを渡します。これにより、最適化されていないIRが`unopt.bc`ファイルに出力されます。このファイルは、通常通りLLVMツールに渡すことができます。`libjulia`はLLVMパスプラグインとして機能し、LLVMツールにロードすることができ、julia特有のパスをこの環境で利用可能にします。さらに、IR全体に対してJuliaパスパイプラインを実行する`-julia`メタパスを公開しています。例えば、古いパスマネージャを使用してシステムイメージを生成するには、次のようにします：

```

llc -o sys.o opt.bc
cc -shared -o sys.so sys.o
```

新しいパス管理者を使用してシステムイメージを生成するには、次のようにします：

```
opt -load-pass-plugin=libjulia-codegen.so --passes='julia' -o opt.bc unopt.bc
llc -o sys.o opt.bc
cc -shared -o sys.so sys.o
```

このシステムイメージは、その後通常通り `julia` にロードできます。

特定のJulia関数のためだけにLLVM IRモジュールをダンプすることも可能です。次のようにします：

```julia
fun, T = +, Tuple{Int,Int} # Substitute your function of interest here
optimize = false
open("plus.ll", "w") do file
    println(file, InteractiveUtils._dump_function(fun, T, false, false, false, true, :att, optimize, :default, false))
end
```

これらのファイルは、上記に示した最適化されていない sysimg IR と同じ方法で処理できます。

## Running the LLVM test suite

ローカルでllvmテストを実行するには、まずツールをインストールし、juliaをビルドする必要があります。その後、テストを実行できます：

```
make -C deps install-llvm-tools
make -j julia-src-release
make -C test/llvmpasses
```

個々のテストファイルを直接実行したい場合は、各テストファイルの先頭にあるコマンドを使用します。ここでの最初のステップでは、ツールが `./usr/tools/opt` にインストールされます。その後、手動で `%s` をテストファイルの名前に置き換える必要があります。

## Improving LLVM optimizations for Julia

LLVMのコード生成を改善するには、通常、JuliaのローワリングをLLVMのパスに対してよりフレンドリーに変更するか、パスを改善することが含まれます。

もしパスを改善することを計画しているなら、必ず [LLVM developer policy](https://llvm.org/docs/DeveloperPolicy.html) を読んでください。最良の戦略は、LLVMの `opt` ツールを使用して、興味のあるパスを孤立して研究できる形式でコード例を作成することです。

1. Create an example Julia code of interest.
2. `JULIA_LLVM_ARGS=-print-after-all`を使用してIRをダンプします。
3. 関心のあるパスが実行される直前のポイントでIRを選択してください。
4. デバッグメタデータを削除し、TBAAメタデータを手動で修正します。

最後のステップは手間がかかります。より良い方法についての提案をいただけるとありがたいです。

## The jlcall calling convention

ジュリアは最適化されていないコードのための一般的な呼び出し規約を持っており、次のようになります:

```c
jl_value_t *any_unoptimized_call(jl_value_t *, jl_value_t **, int);
```

最初の引数はボックス化された関数オブジェクトであり、2番目の引数はスタック上の引数の配列、3番目は引数の数です。ここで、引数配列のためにallocaを発行するという単純な低下を行うことができます。しかし、これは呼び出しサイトでの使用のSSA特性を損なうことになり、最適化（GCルートの配置を含む）が大幅に難しくなります。代わりに、次のように発行します：

```llvm
call %jl_value_t *@julia.call(jl_value_t *(*)(...) @any_unoptimized_call, %jl_value_t *%arg1, %jl_value_t *%arg2)
```

これにより、オプティマイザ全体で使用されるSSAの特性を保持することができます。GCルートの配置は後でこの呼び出しを元のC ABIに低下させます。

## GC root placement

GCルートの配置は、LLVMのパスパイプラインの後半で行われます。この遅い段階でGCルートの配置を行うことで、LLVMはGCルートを必要とするコード周辺でより攻撃的な最適化を行うことができ、また必要なGCルートとGCルートストア操作の数を減らすことができます（LLVMは私たちのGCを理解していないため、GCフレームに格納された値に対して何が許可されているかを知ることができず、保守的に非常に少ないことを行います）。例として、エラーパスを考えてみましょう。

```julia
if some_condition()
    #= Use some variables maybe =#
    error("An error occurred")
end
```

定数折りたたみ中に、LLVMは条件が常に偽であることを発見し、基本ブロックを削除することができます。しかし、GCルートの低下が早期に行われると、削除されたブロックで使用されていたGCルートスロットや、エラーパスで使用されていたためにのみ生き残っている値がLLVMによって生き残ることになります。GCルートの低下を遅く行うことで、LLVMに通常の最適化（定数折りたたみ、死コード削除など）を行う権限を与え、どの値がGCで追跡されるかについてあまり心配する必要がなくなります。

しかし、遅延GCルート配置を行うためには、a) どのポインタがGCによって追跡されているか、b) そのようなポインタのすべての使用を特定できる必要があります。したがって、GC配置パスの目標はシンプルです：

必要なGCルート/ストアの数を最小限に抑え、すべてのセーフポイントで、ライブのGCトラッキングポインタ（つまり、このポイント以降にこのポインタの使用が含まれるパスがあるもの）が何らかのGCスロットにあるという制約を満たすようにします。

### Representation

主な難しさは、プログラムが最適化を通過した後でも、GCトラッキングされたポインタとその使用を特定できるIR表現を選択することです。私たちの設計は、これを達成するために3つのLLVM機能を利用しています：

  * カスタムアドレス空間
  * オペランドバンドル
  * 非整数ポインタ

カスタムアドレス空間を使用すると、最適化を通じて保持する必要がある整数で各ポイントにタグを付けることができます。コンパイラは、元のプログラムに存在しなかったアドレス空間間でキャストを挿入することはできず、ロード/ストアなどの操作でポインタのアドレス空間を変更してはいけません。これにより、最適化に対して抵抗力のある方法で、どのポインタがGCトラッキングされているかを注釈付けすることができます。メタデータでは同じ目的を達成できないことに注意してください。メタデータは、プログラムのセマンティクスを変更することなく常に破棄可能であるべきです。しかし、GCトラッキングされたポインタを特定できないと、結果として得られるプログラムの動作が劇的に変わります - おそらくクラッシュするか、間違った結果を返すでしょう。現在、私たちは3つの異なるアドレス空間を使用しています（その番号は `src/codegen_shared.cpp` に定義されています）：

  * GC トラッキングポインタ (現在 10): これは、GC フレームに格納される可能性のあるボックス化された値へのポインタです。C 側の `jl_value_t*` ポインタにおおよそ相当します。注意: このアドレス空間に、GC スロットに格納できないポインタを持つことは違法です。
  * 派生ポインタ（現在11）：これらは、GCによって追跡されるポインタから派生したポインタです。これらのポインタの使用は、元のポインタの使用を生成します。ただし、これらは必ずしもGCに知られている必要はありません。GCルート配置パスは、常にこのポインタが派生したGC追跡ポインタを見つけ、それをルートへのポインタとして使用しなければなりません。
  * Callee Rooted Pointers (現在12): これは、呼び出し先に根ざした値の概念を表現するためのユーティリティアドレス空間です。このアドレス空間のすべての値は、GCルートに保存可能でなければなりません（ただし、将来的にこの条件を緩和することは可能です）。しかし、他のポインタとは異なり、呼び出しに渡す場合は根ざしている必要はありません（定義と呼び出しの間に別のセーフポイントを越えて生存している場合は、根ざしている必要があります）。
  * トラッキングされたオブジェクトから読み込まれたポインタ（現在13）：これは配列によって使用され、配列自体が管理されたデータへのポインタを含んでいます。このデータ領域は配列によって所有されていますが、それ自体はGCによってトラッキングされるオブジェクトではありません。コンパイラは、このポインタが生きている限り、このポインタが読み込まれたオブジェクトが生き続けることを保証します。

### Invariants

GCルート配置パスは、フロントエンドによって遵守され、最適化ツールによって保持されるいくつかの不変条件を利用します。

最初に、次のアドレス空間キャストのみが許可されています：

  * 0->{トラッキング済み、派生、呼び出し元に固定}: トラッキングされていないポインタを他のいずれかに変換することは許可されています。ただし、最適化プログラムはそのような値をルート化しない広範な権限を持っていることに注意してください。GCルートを必要とする値（またはそれから派生した値）がプログラムのどの部分にもアドレス空間0に存在することは決して安全ではありません。
  * 追跡された->派生: これは内部値の標準的な減衰経路です。配置パスは、これらを探して、使用するためのベースポインタを特定します。
  * Tracked->CalleeRooted: Addrspace CalleeRootedは、GCルートが必要ないことを示すヒントとしてのみ機能します。ただし、Derived->CalleeRootedの減衰は禁止されていることに注意してください。ポインタは一般的にこのアドレス空間内でもGCスロットに格納可能であるべきです。

さて、使用を構成するものについて考えてみましょう：

  * アドレス空間のいずれかに読み込まれた値を持つロード
  * アドレス空間の1つにある値を位置に格納する
  * アドレス空間のいずれかにポインタを格納します。
  * アドレス空間のいずれかに値がオペランドである呼び出し
  * jlcall ABI における呼び出しでは、引数配列に値が含まれています。
  * 指示を返します。

アドレス空間 Tracked/Derived では、ロード/ストアおよび単純な呼び出しを明示的に許可します。jlcall 引数配列の要素は常にアドレス空間 Tracked に存在しなければなりません（それらが有効な `jl_value_t*` ポインタであることは ABI によって要求されています）。戻り命令についても同様です（ただし、構造体の戻り引数は任意のアドレス空間を持つことが許可されています）。アドレス空間 CalleeRooted ポインタの唯一の許可される使用法は、それを呼び出しに渡すことです（その呼び出しは適切に型付けされたオペランドを持たなければなりません）。

さらに、アドレス空間 Tracked での `getelementptr` を禁止します。これは、操作が noop でない限り、結果のポインタが GC スロットに有効に格納できないため、このアドレス空間に存在しない可能性があるからです。そのようなポインタが必要な場合は、まず addrspace Derived にデカイされるべきです。

最後に、これらのアドレス空間では `inttoptr`/`ptrtoint` 命令を禁止します。これらの命令があると、いくつかの `i64` 値が実際にはGCによって追跡されていることを意味します。これは問題であり、GC関連のポインタを特定できるという要件を破ることになります。この不変性は、LLVM 5.0で新しく追加されたLLVMの「非整数ポインタ」機能を使用して達成されます。これにより、最適化がこれらの操作を導入することを禁止されます。なお、アドレス空間0で `inttoptr` を使用して静的定数をJIT時に挿入し、その後適切なアドレス空間にデカイすることはまだ可能です。

### Supporting [`ccall`](@ref)

これまでの議論で欠けている重要な側面の一つは、[`ccall`](@ref)の取り扱いです。`4d61726b646f776e2e436f64652822222c20226363616c6c2229_40726566`は、使用の場所と範囲が一致しないという特異な特徴を持っています。例として考えてみましょう：

```julia
A = randn(1024)
ccall(:foo, Cvoid, (Ptr{Float64},), A)
```

配列からポインタへの変換が挿入され、配列の値への参照が失われます。しかし、もちろん、[`ccall`](@ref)を実行している間、配列が生き続けることを確認する必要があります。これがどのように行われるかを理解するために、上記のコードの仮想的な近似的な低下を見てみましょう：

```julia
return $(Expr(:foreigncall, :(:foo), Cvoid, svec(Ptr{Float64}), 0, :(:ccall), Expr(:foreigncall, :(:jl_array_ptr), Ptr{Float64}, svec(Any), 0, :(:ccall), :(A)), :(A)))
```

最後の `:(A)` は、低下中に挿入された追加の引数リストであり、コード生成器に対して、この [`ccall`](@ref) の期間中に保持する必要があるJuliaレベルの値を通知します。次に、この情報を使用して、IRレベルで「オペランドバンドル」として表現します。オペランドバンドルは、本質的に呼び出しサイトに添付された偽の使用です。IRレベルでは、これは次のようになります：

```llvm
call void inttoptr (i64 ... to void (double*)*)(double* %5) [ "jl_roots"(%jl_value_t addrspace(10)* %A) ]
```

GCルート配置パスは、`jl_roots`オペランドバンドルを通常のオペランドのように扱います。しかし、最終ステップとして、GCルートが挿入された後に、命令選択を混乱させないようにオペランドバンドルを削除します。

### Supporting [`pointer_from_objref`](@ref)

[`pointer_from_objref`](@ref) は特別です。なぜなら、ユーザーがGCルーティングを明示的に制御する必要があるからです。上記の不変条件により、この関数は不正です。なぜなら、10から0へのアドレス空間キャストを行うからです。しかし、特定の状況では有用であるため、特別なイントリンシックを提供します：

```llvm
declared %jl_value_t *julia.pointer_from_objref(%jl_value_t addrspace(10)*)
```

GCルートの低下後に対応するアドレス空間キャストに低下されます。ただし、この内在関数を使用することにより、呼び出し元は問題の値がルートされていることを確認するすべての責任を負うことに注意してください。さらに、この内在関数は使用と見なされないため、GCルート配置パスは関数に対してGCルートを提供しません。その結果、外部のルーティングは、値がまだシステムによって追跡されている間に手配する必要があります。つまり、この操作の結果を使用してグローバルルートを確立しようとすることは無効です - オプティマイザはすでにその値を削除している可能性があります。

### Keeping values alive in the absence of uses

特定のケースでは、コンパイラからは見えないオブジェクトの使用がないにもかかわらず、そのオブジェクトを生かしておく必要があります。これは、オブジェクトのメモリ表現に直接操作を行う低レベルのコードや、Cコードとインターフェースを持つ必要があるコードの場合に該当することがあります。これを可能にするために、LLVMレベルで以下の内部関数を提供します：

```
token @llvm.julia.gc_preserve_begin(...)
void @llvm.julia.gc_preserve_end(token)
```

（名前に含まれる `llvm.` は `token` 型を使用するために必要です。）これらのインストリンシックの意味は次のとおりです： `gc_preserve_begin` 呼び出しによって支配されているが、対応する `gc_preserve_end` 呼び出し（つまり、`gc_preserve_begin` 呼び出しによって返されたトークンを引数に持つ呼び出し）によって支配されていない任意のセーフポイントにおいて、`gc_preserve_begin` に渡された引数の値は生き続けます。`gc_preserve_begin` はこれらの値の通常の使用としてカウントされるため、標準のライフタイムセマンティクスにより、保存領域に入る前に値が生き続けることが保証されます。
