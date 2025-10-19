# Static analyzer annotations for GC correctness in C code

## Running the analysis

分析を行うアナライザープラグインは、juliaに付属しています。そのソースコードは`src/clangsa`にあります。これを実行するには、clang依存関係をビルドする必要があります。適切なバージョンのclangをビルドするために、Make.user内で`BUILD_LLVM_CLANG`変数を設定してください。また、`USE_BINARYBUILDER_LLVM`オプションを使用して、事前ビルドされたバイナリを使用することも検討してください。

代わりに（またはこれらが不十分な場合）、試してみてください。

```sh
make -C src install-analysis-deps
```

ジュリアのトップレベルディレクトリから。

その後、ソースツリーに対して分析を実行するのは、`make -C src analyzegc`を実行するだけで簡単です。

## General Overview

JuliaのGCは正確であるため、GCが発生する可能性のある任意の値に対して正しいルーティング情報を維持する必要があります。これらの場所は`safepoints`として知られており、関数のローカルコンテキストでは、この名称を再帰的に`safepoint`に到達する可能性のある任意の関数呼び出しに拡張します。

生成されたコードでは、GCルート配置パスによって自動的に処理されます（LLVMコード生成開発ドキュメントのGCルーティングに関する章を参照）。しかし、Cコードでは、GCルートをランタイムに手動で通知する必要があります。これは、次のマクロを使用して行います：

```
// The value assigned to any slot passed as an argument to these
// is rooted for the duration of this GC frame.
JL_GC_PUSH{1,...,6}(args...)
// The values assigned into the size `n` array `rts` are rooted
// for the duration of this GC frame.
JL_GC_PUSHARGS(rts, n)
// Pop a GC frame
JL_GC_POP
```

これらのマクロが必要な場所で使用されない場合、または不適切に使用されると、結果は静かなメモリ破損になります。そのため、すべての適用可能なコードで正しく配置されることが非常に重要です。

そのため、これらのマクロが正しく使用されることを保証するために、静的解析（特にclang静的解析器）を使用します。この文書の残りの部分では、この静的解析の概要を示し、物事を機能させるためにjuliaコードベースで必要なサポートについて説明します。

## GC Invariants

2つの単純な不変条件の正しさがあります：

  * すべての `GC_PUSH` 呼び出しは、適切な `GC_POP` に続く必要があります（実際には、これを関数レベルで強制しています）。
  * もし値が以前にどのセーフポイントにもルートされていなかった場合、その後はもはや参照されない可能性があります。

もちろん、ここでの詳細が重要です。特に上記の2番目の条件を満たすためには、私たちは以下を知る必要があります：

  * どの呼び出しがセーフポイントで、どの呼び出しがそうでないか
  * どの値が任意のセーフポイントに根ざしているか、またどの値が根ざしていないか
  * 値が参照されるのはいつですか

特に2番目のポイントについては、ランタイムでどのメモリ位置がルートとして考慮されるかを知る必要があります（つまり、そのような位置に割り当てられた値がルートになります）。これには、`GC_PUSH`マクロのいずれかに渡すことによって明示的に指定された位置、グローバルにルートされた位置と値、およびそれらの位置から再帰的に到達可能な任意の位置が含まれます。

## Static Analysis Algorithm

アイデア自体は非常にシンプルですが、実装はかなり複雑です（主に多くの特別なケースとCおよびC++の複雑さのためです）。本質的には、すべてのルートしている場所、すべてのルート可能な値、および任意の式（代入、割り当てなど）がルート可能な値のルート性に影響を与えることを追跡します。そして、任意のセーフポイントで「シンボリックGC」を実行し、指定された場所でルートされていない値を毒します。これらの値が後で参照されると、エラーを発生させます。

Clang静的解析器は、状態のグラフを構築し、このグラフを探索してエラーの原因を特定することで機能します。このグラフのいくつかのノードは解析器自体によって生成されます（例えば、制御フローのために）が、上記の定義は私たち自身の状態でこのグラフを拡張します。

静的解析器は手続き間であり、関数の境界を越えた制御フローを分析できます。しかし、静的解析器は完全に再帰的ではなく、探索する呼び出しについてヒューリスティックな決定を行います（さらに、一部の呼び出しはクロストランスレーションユニットであり、解析器には見えません）。私たちのケースでは、正確性の定義は完全な情報を必要とします。そのため、手続き間静的解析によって通常は利用可能な情報であっても、すべての関数呼び出しのプロトタイプに必要な情報を注釈として付加する必要があります。

幸運なことに、私たちはこの手続き間分析を使用して、特定の関数に置く注釈が、その関数の実装に照らして正しいことを確認することができます。

## The analyzer annotations

これらの注釈は、src/support/analyzer_annotations.hにあります。アナライザーが使用されているときのみアクティブで、プロトタイプ注釈の場合は何もないものに、関数のような注釈の場合はノーオプに展開されます。

### `JL_NOTSAFEPOINT`

これはおそらく最も一般的な注釈であり、GCセーフポイントに到達する可能性がないことが知られている任意の関数に配置されるべきです。一般的に、このような関数が安全に実行できるのは、算術演算、メモリアクセス、および`JL_NOTSAFEPOINT`として注釈された関数や、セーフポイントでないことが知られている関数（例えば、分析ツールでハードコーディングされているC標準ライブラリの関数）への呼び出しのみです。

この属性で注釈された任意の関数への呼び出しの間、値をルート化しないまま保持することは有効です:

使用例:

```c
void jl_get_one() JL_NOTSAFEPOINT {
  return 1;
}

jl_value_t *example() {
  jl_value_t *val = jl_alloc_whatever();
  // This is valid, even though `val` is unrooted, because
  // jl_get_one is not a safepoint
  jl_get_one();
  return val;
}
```

### `JL_MAYBE_UNROOTED`/`JL_ROOTS_TEMPORARILY`

`JL_MAYBE_UNROOTED`が関数の引数に注釈されている場合、その引数はルート化されていなくても渡される可能性があることを示します。通常の状況では、julia ABIは呼び出し元が値を呼び出し先に渡す前にルート化することを保証します。しかし、一部の関数はこのABIに従わず、ルート化されていない値を渡すことを許可します。ただし、これは自動的にその引数が保持されることを意味するわけではありません。`ROOTS_TEMPORARILY`注釈は、値が渡されるときにルート化されていない可能性があるだけでなく、呼び出し先による内部セーフポイントを通じて保持されるというより強い保証を提供します。

`JL_NOTSAFEPOINT`は本質的に`JL_MAYBE_UNROOTED`/`JL_ROOTS_TEMPORARILY`を意味します。なぜなら、関数にセーフポイントが含まれていない場合、引数のルート状態は無関係だからです。

1つ追加のポイントとして、これらの注釈は呼び出し側と呼び出され側の両方に適用されることに注意してください。呼び出し側では、通常はjulia ABI関数に必要とされる根付き制限を解除します。呼び出され側では、これらの引数が暗黙的に根付きと見なされるのを防ぐ逆の効果があります。

関数全体にこれらの注釈のいずれかが適用される場合、それは関数のすべての引数に適用されます。これは一般的に可変引数関数に対してのみ必要です。

使用例:

```c
JL_DLLEXPORT void JL_NORETURN jl_throw(jl_value_t *e JL_MAYBE_UNROOTED);
jl_value_t *jl_alloc_error();

void example() {
  // The return value of the allocation is unrooted. This would normally
  // be an error, but is allowed because of the above annotation.
  jl_throw(jl_alloc_error());
}
```

### `JL_PROPAGATES_ROOT`

この注釈は、別のオブジェクト内に格納されている1つのルート可能なオブジェクトを返すアクセサ関数によく見られます。関数の引数に注釈が付けられている場合、それはアナライザーに対して、その引数のルートが関数によって返される値にも適用されることを示します。

使用例:

```c
jl_value_t *jl_svecref(jl_svec_t *t JL_PROPAGATES_ROOT, size_t i) JL_NOTSAFEPOINT;

size_t example(jl_svec_t *svec) {
  jl_value_t *val = jl_svecref(svec, 1)
  // This is valid, because, as annotated by the PROPAGATES_ROOT annotation,
  // jl_svecref propagates the rooted-ness from `svec` to `val`
  jl_gc_safepoint();
  return jl_unbox_long(val);
}
```

### `JL_ROOTING_ARGUMENT`/`JL_ROOTED_ARGUMENT`

これは本質的に `JL_PROPAGATES_ROOT` の割り当ての対応物です。すでにルート化されている別の値のフィールドに値を割り当てると、割り当てられた値は、割り当てられた値のルートを継承します。

使用例:

```c
void jl_svecset(void *t JL_ROOTING_ARGUMENT, size_t i, void *x JL_ROOTED_ARGUMENT) JL_NOTSAFEPOINT


size_t example(jl_svec_t *svec) {
  jl_value_t *val = jl_box_long(10000);
  jl_svecset(svec, val);
  // This is valid, because the annotations imply that the
  // jl_svecset propagates the rooted-ness from `svec` to `val`
  jl_gc_safepoint();
  return jl_unbox_long(val);
}
```

### `JL_GC_DISABLED`

この注釈は、この関数がGCランタイムが無効になっているときのみ呼び出されることを示唆しています。この種の関数は、起動時やGCコード自体で最もよく見られます。この注釈はランタイムの有効/無効呼び出しに対してチェックされるため、clangはあなたが嘘をついているかどうかを知ることになります。GCが実際に無効になっていない場合に特定の関数の処理を無効にするための良い方法ではありません（どうしても必要な場合は`ifdef __clang_analyzer__`を使用してください）。

使用例:

```c
void jl_do_magic() JL_GC_DISABLED {
  // Wildly allocate here with no regard for roots
}

void example() {
  int en = jl_gc_enable(0);
  jl_do_magic();
  jl_gc_enable(en);
}
```

### `JL_REQUIRE_ROOTED_SLOT`

このアノテーションは、呼び出し元がルートされたスロットを渡すことを要求します（つまり、このスロットに割り当てられた値はルートされます）。

使用例:

```c
void jl_do_processing(jl_value_t **slot JL_REQUIRE_ROOTED_SLOT) {
  *slot = jl_box_long(1);
  // Ok, only, because the slot was annotated as rooting
  jl_gc_safepoint();
}

void example() {
  jl_value_t *slot = NULL;
  JL_GC_PUSH1(&slot);
  jl_do_processing(&slot);
  JL_GC_POP();
}
```

### `JL_GLOBALLY_ROOTED`

この注釈は、特定の値が常にグローバルにルートされていることを示唆しています。これはグローバル変数の宣言に適用でき、その場合はそれらの変数の値（または配列の宣言の場合は値）に適用されます。また、関数に適用することもでき、その場合はそのような関数の戻り値に適用されます（例：常にプライベートでグローバルにルートされた値を返す関数の場合）。

使用例:

```
extern JL_DLLEXPORT jl_datatype_t *jl_any_type JL_GLOBALLY_ROOTED;
jl_ast_context_t *jl_ast_ctx(fl_context_t *fl) JL_GLOBALLY_ROOTED;
```

### `JL_ALWAYS_LEAFTYPE`

このアノテーションは本質的に `JL_GLOBALLY_ROOTED` と同等ですが、これは値がリーフタイプであることによってグローバルにルートされている場合にのみ使用する必要があります。リーフタイプのルーティングは少し複雑です。リーフタイプは一般的に対応する `TypeName` の `cache` フィールドを通じてルートされており、その `TypeName` 自体は含まれているモジュールによってルートされています（したがって、含まれているモジュールが正常である限り、リーフタイプはルートされています）。一般的に、リーフタイプは使用される場所でルートされていると仮定できますが、将来的にこの特性を洗練させる可能性があるため、別のアノテーションがグローバルにルートされている理由を分けるのに役立ちます。

アナライザーは、leaftype-nessのチェックも自動的に検出し、これらのパスでGCルートが欠落していることについて文句を言うことはありません。

```
JL_DLLEXPORT jl_value_t *jl_apply_array_type(jl_value_t *type, size_t dim) JL_ALWAYS_LEAFTYPE;
```

### `JL_GC_PROMISE_ROOTED`

これは関数のようなアノテーションです。このアノテーションに渡された値は、現在の関数のスコープに対してルートと見なされます。これは、アナライザーの不十分さや複雑な状況に対する逃げ道として設計されています。ただし、アナライザー自体を改善することを優先し、控えめに使用するべきです。

```
void example() {
  jl_value_t *val = jl_alloc_something();
  if (some_condition) {
    // We happen to know for complicated external reasons
    // that val is rooted under these conditions
    JL_GC_PROMISE_ROOTED(val);
  }
}
```

## Completeness of analysis

アナライザーはローカル情報のみを考慮します。特に、上記の `PROPAGATES_ROOT` の場合、アナライザーはそのようなメモリが見える方法でのみ変更されると仮定し、呼び出された関数内で変更されることはありません（分析においてそれらを考慮することを決定しない限り）し、同時に実行されているスレッド内でも変更されません。そのため、いくつかの問題のあるケースを見逃す可能性がありますが、実際にはそのような同時変更はかなり稀です。アナライザーを改善して、より多くのそのようなケースを処理できるようにすることは、将来の作業にとって興味深いトピックかもしれません。
