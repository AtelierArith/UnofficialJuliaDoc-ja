# Diagnostics used by the package ecosystem

このページでは、Julia に組み込まれている「フック」について説明します。これらは主に外部ツールで使用されます。こうしたツールの多くは、Julia 本体に組み込むには複雑すぎる分析を行うために設計されています。

## SnoopCompile

SnoopCompile は Julia のコンパイラーを「覗き見」し、無効化や型推論に関する分析用の情報を抽出します。用途に応じて、いくつかの内部機能を使用します。

  * 無効化の記録: `Base.StaticData.debug_method_invalidation` と `ccall(:jl_debug_method_invalidation, ...)` は、異なるモードの無効化を記録します。SnoopCompile のユーザーは、たとえばパッケージの読み込み時に、これらを一時的に有効にします。それぞれ標準的なログ形式で記録されます。ログ形式を変更する場合は、SnoopCompile に対応するプルリクエストが必要になることがあります。SnoopCompile はこれらのログを処理し、メソッドテーブルやバインディングに対する特定の変更に起因する、無効化された CodeInstance のツリーを生成します。
  * 推論の観測: `ccall(:jl_set_newly_inferred, ...)` と `ccall(:jl_set_inference_entrance_backtraces, ...)` は、推論がどのように開始されるかを把握するために使用します。主な目的は、パフォーマンス診断で TTFX の発生源を特定できるようにすることです。後者の `ccall` は、型推論に入るたびにバックトレースを記録します。これにより SnoopCompile は、動的ディスパッチ呼び出しの呼び出し元を特定できます。これは、新たな型推論の「原因」を特定するために必要です。

    `jl_set_inference_entrance_backtraces` 関数は、推論開始イベントを記録する配列を受け取ります。各推論イベントは、配列の連続する 2 要素に格納されます。最初の要素は `CodeInstance` オブジェクト、次の要素はバックトレース表現です。したがって、推論イベントが N 件の場合、配列には `[ci₁, bt₁, ci₂, bt₂, ..., ciₙ, btₙ]` のように並んだ 2N 個の要素が格納されます。

    バックトレース要素 `btᵢ` には、生のバックトレースデータが含まれています。分析に使えるスタックトレース形式に変換するには、通常 `stacktrace(Base._reformat_bt(btᵢ...))` を使って処理する必要があります。
