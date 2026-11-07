# Static analyzer annotations for GC correctness in C code

## Running the analysis

解析を実行するアナライザープラグインは、Julia に同梱されています。ソースコードは `src/clangsa` にあります。実行には clang のビルドが必要です。適切なバージョンの clang をビルドするには、Make.user で `BUILD_LLVM_CLANG` 変数を設定してください。ビルド済みバイナリを使う場合は、`USE_BINARYBUILDER_LLVM` オプションも利用できます。

または（これらで不十分な場合も含めて）、Julia のトップレベルディレクトリから次を実行してください。

```sh
make -C src install-analysis-deps
```

その後、ソースツリー全体の解析は、`make -C src analyzegc` を実行するだけです。

## General Overview

Julia の GC は正確な GC であるため、GC が発生し得るあらゆる時点で参照される可能性のある値について、正しいルート情報を維持する必要があります。こうした箇所は `safepoints` と呼ばれます。また、関数のローカルな文脈では、この呼び方を、再帰的にたどるとセーフポイントに到達する可能性のある関数呼び出しにも拡張します。

生成コードでは、GC ルート配置パスがこの処理を自動的に行います（LLVM コード生成の開発者向けドキュメントにある GC rooting の章を参照）。一方、C コードでは、GC ルートをランタイムに手動で知らせる必要があります。これは次のマクロを使って行います。

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

必要な箇所でこれらのマクロを使わなかったり、誤った使い方をしたりすると、気づかないうちにメモリが破損します。そのため、該当するすべてのコードで、マクロを正しい位置に配置することが非常に重要です。

そこで、これらのマクロが正しく使われていることを確認するため、静的解析（特に clang の静的アナライザー）を利用します。このドキュメントの残りでは、この静的解析の概要と、解析を機能させるために Julia のコードベースで必要となるサポートについて説明します。

## GC Invariants

正しさを保証するための単純な不変条件は、次の2つです。

  * すべての `GC_PUSH` 呼び出しの後には、適切な `GC_POP` が必要です（実際には、これを関数単位で強制しています）。
  * ある値が以前のどのセーフポイントでもルートされていなかった場合、その後はその値を参照してはなりません。

もちろん、詳細は単純ではありません。特に、上記の2つ目の条件を満たすには、次のことを把握する必要があります。

  * どの呼び出しがセーフポイントで、どれがそうでないか
  * 任意のセーフポイントで、どの値がルートされていて、どの値がルートされていないか
  * 値がいつ参照されるか

特に2つ目の点については、実行時にルートとして扱われるメモリ位置（つまり、そこに代入された値がルートされる位置）を把握する必要があります。これには、`GC_PUSH` マクロのいずれかに渡すことで明示的に指定された位置、グローバルにルートされる位置や値、さらにそれらの位置から再帰的に到達可能な位置が含まれます。

## Static Analysis Algorithm

考え方自体は非常に単純ですが、実装はかなり複雑です（主な理由は、C と C++ に多くの特殊ケースや細かな事情があるためです）。基本的には、ルートとなるすべての位置、ルート可能なすべての値、および式（代入、割り当てなど）がルート可能な値のルート状態に与える影響を追跡します。そして各セーフポイントで「記号的 GC」を実行し、その時点でルートされていない値を無効化します。そうした値が後で参照された場合は、エラーを出力します。

clang の静的アナライザーは、状態のグラフを構築し、エラーの原因を探してそのグラフを探索します。このグラフのノードの一部（制御フローなど）はアナライザー自身が生成しますが、上記の定義に基づいて、独自の状態もグラフに追加します。

静的アナライザーは関数間解析を行い、関数境界をまたいだ制御フローも解析できます。ただし、解析は完全に再帰的ではなく、どの呼び出しを探索するか（グラフに追加するか）はヒューリスティックに判断されます（さらに、翻訳単位をまたぐためアナライザーから見えない呼び出しもあります）。今回の正しさの定義では、すべての情報が必要です。そのため、関数間の静的解析で情報を得られる場合であっても、解析に必要な情報をすべての関数呼び出しのプロトタイプに注釈として付ける必要があります。

ただし幸いなことに、この関数間解析を利用して、関数に付けた注釈がその実装に照らして正しいことを確認できます。

## The analyzer annotations

これらの注釈は src/support/analyzer_annotations.h にあります。アナライザーの使用時にのみ有効になり、プロトタイプに付ける注釈は何も展開されず、関数のように使う注釈は何もしない処理に展開されます。

### `JL_NOTSAFEPOINT`

これはおそらく最もよく使われる注釈で、GC セーフポイントに到達する可能性がないと分かっている関数に付けます。一般に、そのような関数が安全に実行できるのは、算術演算、メモリアクセス、および `JL_NOTSAFEPOINT` の注釈が付いた関数や、セーフポイントではないと別途分かっている関数（C 標準ライブラリの関数など。これらはアナライザーにそのようにハードコードされています）の呼び出しだけです。

この属性が付いた関数の呼び出しをまたいで、値をルートされていないまま保持しても問題ありません。

使用例：

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

関数の引数に `JL_MAYBE_UNROOTED` を付けると、その引数がルートされていなくても渡してよいことを示します。通常、Julia ABI では、呼び出し元が値をルートしてから呼び出し先に渡すことが保証されています。しかし、この ABI に従わず、値がルートされていなくても受け取れる関数もあります。ただし、この注釈だけでは、その引数が保持されるとは限りません。`ROOTS_TEMPORARILY` 注釈を付けると、値がルートされていない状態で渡されてもよいだけでなく、呼び出し先が内部でセーフポイントを通過してもその値が保持されることを、より強く保証します。

`JL_NOTSAFEPOINT` は、実質的に `JL_MAYBE_UNROOTED`/`JL_ROOTS_TEMPORARILY` を含意します。関数内にセーフポイントがなければ、引数がルートされているかどうかは関係ないためです。

もう1点、これらの注釈は呼び出し元と呼び出し先の両方に適用されます。呼び出し元側では、通常 Julia ABI の関数に求められるルート化の制約を緩和します。呼び出し先側では逆に、これらの引数が暗黙にルートされているものとして扱われないようにします。

これらの注釈を関数全体に付けた場合、関数のすべての引数に適用されます。通常、これが必要なのは可変長引数関数だけです。

使用例：

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

この注釈は、別のオブジェクトに格納されたルート可能なオブジェクトを返すアクセサー関数によく使われます。関数の引数に付けると、その引数のルートが、関数の戻り値にも適用されることをアナライザーに伝えます。

使用例：

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

これは基本的に、`JL_PROPAGATES_ROOT` に対応する代入側の注釈です。すでにルートされている値のフィールドに別の値を代入すると、代入された値は、代入先の値のルートを引き継ぎます。

使用例：

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

この注釈は、その関数が GC ランタイムを無効にした状態でのみ呼び出されることを示します。この種の関数は、起動時や GC コード内でよく見られます。この注釈はランタイムの有効化・無効化呼び出しと照合されるため、虚偽の注釈を付けても clang に検出されます。GC が実際には無効になっていない関数の解析を無効にする目的で使うのは適切ではありません（どうしても必要なら、その用途には `ifdef __clang_analyzer__` を使ってください）。

使用例：

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

この注釈は、呼び出し元に対し、ルートされたスロット（つまり、そのスロットに代入された値がルートされるスロット）を渡すよう要求します。

使用例：

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

この注釈は、指定された値が常にグローバルにルートされていることを示します。グローバル変数の宣言に付けると、その変数の値（宣言が配列の場合は各要素）に適用されます。関数に付けると、その関数の戻り値に適用されます（たとえば、常に非公開のグローバルルート値を返す関数など）。

使用例：

```
extern JL_DLLEXPORT jl_datatype_t *jl_any_type JL_GLOBALLY_ROOTED;
jl_ast_context_t *jl_ast_ctx(fl_context_t *fl) JL_GLOBALLY_ROOTED;
```

### `JL_ALWAYS_LEAFTYPE`

この注釈は基本的に `JL_GLOBALLY_ROOTED` と同等ですが、値がリーフ型であることによってグローバルにルートされている場合にのみ使います。リーフ型のルート化は少し複雑です。通常、リーフ型は対応する `TypeName` の `cache` フィールドを通じてルートされます。このフィールド自体は、それを含むモジュールによってルートされるため、モジュールが有効である限りリーフ型もルートされます。一般に、リーフ型は使用箇所でルートされていると見なせますが、将来的にこの性質を見直す可能性があります。そのため、グローバルにルートされる理由を区別できるよう、別の注釈が用意されています。

また、アナライザーはリーフ型かどうかのチェックを自動的に検出し、その経路では GC ルートが不足していても警告しません。

```
JL_DLLEXPORT jl_value_t *jl_apply_array_type(jl_value_t *type, size_t dim) JL_ALWAYS_LEAFTYPE;
```

### `JL_GC_PROMISE_ROOTED`

これは関数のように使う注釈です。この注釈に渡された値は、現在の関数のスコープ内でルートされているものとして扱われます。アナライザーの能力不足や複雑な状況に対処するための回避策ですが、アナライザー自体を改善することを優先し、使用は必要最小限にとどめてください。

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

アナライザーが参照するのはローカルな情報だけです。特に、上記の `PROPAGATES_ROOT` の例では、対象のメモリが変更されるのはアナライザーが確認できる方法に限られ、呼び出された関数内（解析時にたまたま調べると判断された場合を除く）や、並行して実行されるスレッド内では変更されないと仮定します。そのため、問題のあるケースを見逃すことがあります。ただし実際には、このような並行変更はかなりまれです。こうしたケースをさらに扱えるようアナライザーを改善することは、今後の課題として興味深いかもしれません。
