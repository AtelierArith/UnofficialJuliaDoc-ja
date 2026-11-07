```julia
State
```

パーサーの状態を表す構造体です（見方によっては状態モナドとも言えます）。

初期状態を作成するには、次のコンストラクターを使います。     State(content::AbstractString, mod::Union{Module, Nothing}=nothing) -> State

各フィールドの内容は次のとおりです。

  * `content::String`：エスケープ解除済みの入力文字列
  * `bytes::Vector{UInt8}`：`content`のコードユニット。エスケープ文字の削除などで配列を変更する必要があるため、`CodeUnits{UInt8}`ではなく`Vector{UInt8}`です。
  * `s::Iterators.Stateful`：`content`の`(index, char)`イテレーター
  * `mod::Union{Module, Nothing}`：インライン式の評価に使う（任意の）コンテキスト。スタイル付きマークアップがマクロ呼び出しから生成される場合に限り、指定する必要があります。
  * `parts::Vector{Any}`：パース結果。`annotatedstring`に渡すとスタイル付きマークアップ文字列を生成する要素のリストです。値の型は多岐にわたるため、要素型には`Any`を使います。
  * `active_styles::Vector{Vector{Tuple{Int, Int, Union{Symbol, Expr, Tuple{Symbol, Any}}}}}}`：まだコンテンツに適用されていないスタイルのバッチのリスト。各バッチのエントリーは`(source_position, start_position, style)`タプルで構成されます。`style`は、フェイスを参照するシンボル、`Tuple{Symbol, Any}`アノテーション、または有効なアノテーションを返す`Expr`（`mod`が設定されている場合）です。
  * `pending_styles::Vector{Tuple{UnitRange{Int}, Union{Symbol, Expr, Tuple{Symbol, Any}}}}`：終了済みのスタイルのリスト。これらのスタイルが適用される範囲は確定していますが、まだ適用されていません。
  * `offset::Int`：マークアップ構造を取り込む際の、`content`のインデックスと、生成されるスタイル付き文字列内のインデックスとの対応を記録します。
  * `point::Int`：`content`内の現在のインデックス
  * `escape::Bool`：直前に読み取った文字がエスケープ文字かどうか
  * `interpolations::Int`：これまでに読み取った補間値の数。評価が必要かどうかが分かれば、可能な場合にマクロ展開時点で結果の文字列を計算できます。また、補間値の数が分かることで、いくつかのマイクロ最適化も可能になります。
  * `errors::Vector`：パース中に発生したエラー。無効なスタイル付きマークアップを書いた人が問題を一つずつ解決しなくても済むよう、すぐに例外を投げるのではなく、できるだけ多くの問題をまとめて報告できるように収集します。通常、`styerr!`の呼び出しによって設定されます。
