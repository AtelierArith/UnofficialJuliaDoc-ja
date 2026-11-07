# Diagnostics used by the package ecosystem

このページでは、主に外部ツールが利用するためにJuliaに組み込まれている「フック」について説明します。これらのツールの多くは、Julia本体に組み込むには複雑すぎる解析を行うために設計されています。

## SnoopCompile

SnoopCompileはJuliaのコンパイラを「覗き見」し、無効化や型推論に関する解析用の情報を抽出します。用途に応じて、いくつかの内部機能を利用します。

  * 無効化の記録: `Base.StaticData.debug_method_invalidation`と`ccall(:jl_debug_method_invalidation, ...)`は、異なるモードの無効化を記録します。SnoopCompileのユーザーは、たとえばパッケージの読み込み時に、これらを一時的に有効にします。それぞれ標準的なログ形式で記録されます。ログ形式を変更する場合は、SnoopCompileへの対応するプルリクエストが必要になることがあります。SnoopCompileはこれらのログを処理し、メソッドテーブルやバインディングに対する特定の変更に起因する、無効化されたCodeInstanceのツリーを生成します。
  * 推論の観測: `ccall(:jl_set_newly_inferred, ...)`と`ccall(:jl_set_inference_entrance_backtraces, ...)`は、推論がどのように開始されるかを把握するために使われます。主な目的は、パフォーマンス診断でTTFXの発生源を特定できるようにすることです。後者の`ccall`は、型推論に入るたびにバックトレースを記録します。これによりSnoopCompileは、動的ディスパッチされた呼び出しの呼び出し元を特定できます。これは、新たな型推論の「原因」を特定するために必要です。

    `jl_set_inference_entrance_backtraces`関数は、推論開始イベントを記録する配列を受け取ります。各推論イベントは、配列の連続する2要素に格納されます。最初の要素は`CodeInstance`オブジェクト、次の要素はバックトレース表現です。したがって、推論イベントがN件ある場合、配列には次のように2N個の要素が格納されます: `[ci₁, bt₁, ci₂, bt₂, ..., ciₙ, btₙ]`。

    バックトレース要素`btᵢ`には生のバックトレースデータが含まれており、解析に使えるスタックトレース形式に変換するには、通常`stacktrace(Base._reformat_bt(btᵢ...))`を使って処理する必要があります。
