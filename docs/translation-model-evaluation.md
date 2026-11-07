# 翻訳失敗ケースのモデル比較と調査（2026-11-07）

初回翻訳中に Luna で３回の検証に失敗した docstring 27件を固定して比較した。通信失敗は除外した。全ドキュメントを代表する無作為標本ではなく、難しい失敗ケースに限定した試験である。

## 比較条件

- 入力・システムプロンプト・検証器は同一。各ケース・各モデルで１回ずつ、評価用４並列。
- Luna は `none` と temperature=0、Sol/Astra は `medium`（対応しない temperature は送信しない）。
- 通常の全体ビルドも同時に動作していたため、時間は参考値。通常の翻訳キャッシュには評価結果を保存していない。

## API 再評価の結果

| モデル | 対象 | 検証通過 | 応答時間中央値 |
|---|---|---:|---:|
| gpt-6-luna | 27件 | 2 / 27 | 2.88秒 |
| gpt-6.1-sol | 同じ27件 | 21 / 27 | 3.56秒 |
| gpt-6-astra | Sol が失敗した６件のみ | 1 / 6 | 4.45秒 |

Astra は別の難しい６件だけを測っているため、27件の Sol/Luna と単純に成功率を比較できない。検証通過は翻訳の意味の完全な正しさを保証するものではない。

## モデル以外に見つかった問題

- **表の復元不具合（修正済み）**：`open` の表内の `truncate \| append` などを復元すると、セル用のエスケープが失われた。翻訳を行わず identity を返しても再現した。復元する保護要素に表用のエスケープ層を保持するよう修正し、通常・強調内のコードについて回帰テストを追加した。
- **マーカー欠落・重複**：変数名・型・リンク・関数シグネチャの欠落、同じ変数を説明し直した際のマーカー重複など。強いモデルで改善するケースが多いが、Sol/Astra でも一部残る。
- **新しいインラインコード表記**：原文でコード表記でなかった `inbounds` や True を、訳文がバッククォート付きにすると現行の検証が拒否する場合がある。検証側の追加検討対象。
- **復元後の解析境界**：元文書の対応しないバッククォートや、URL と日本語が空白なしで隣接する場合など。モデル変更だけでは十分に解決しない。

表の修正後に、保存済み API 応答を **追加 API 呼び出しなし**で再検証した結果：

| モデル | 表の修正前 | 表の修正後 |
|---|---:|---:|
| gpt-6-luna | 2 / 27 | 3 / 27 |
| gpt-6.1-sol | 21 / 27 | 22 / 27 |
| gpt-6-astra | 1 / 6 | 2 / 6 |

## 採用した運用

通常は Luna を使い、最大３回の試行後に失敗した文書だけ Sol（medium）で１回再試行する。両方が失敗した場合は原文でビルドを続行する。不合格の訳文や原文へのフォールバックは翻訳済みキャッシュに保存しない。Astra への自動切り替えは実装していない。

通常料金・短いコンテキスト・キャッシュ割引なしの同一トークン数では、Sol は Luna の20倍、Astra は100倍。今回の27件の使用トークン数からの概算は Luna $0.0079564、Sol $0.164428（約20.7倍）。請求額そのものではない。[公式料金表](https://developers.openai.com/api/docs/pricing)、[推論モデルのパラメーター](https://developers.openai.com/api/docs/guides/latest-model)

## ケース一覧（表の修正前の API 評価）

| ケース | 対象の先頭シグネチャ | Luna | Sol | Astra |
|---|---|---|---|---|
| 1 | `@propagate_inbounds` | 失敗 | 通過 | 未評価 |
| 2 | `CartesianIndices(sz::Dims) -> R` | 失敗 | 通過 | 未評価 |
| 3 | `Float64 <: AbstractFloat <: Real` | 失敗 | 通過 | 未評価 |
| 4 | `DEPOT_PATH` | 失敗 | 通過 | 未評価 |
| 5 | `WeakRef(x)` | 失敗 | 通過 | 未評価 |
| 6 | `countlines(io::IO; eol::AbstractChar = '\n')` | 失敗 | 通過 | 未評価 |
| 7 | `convert(::Type{Node}, md::Markdown.MD) -> Node` | 失敗 | 失敗 | 失敗 |
| 8 | `endswith(s::AbstractString, suffix::Union{AbstractString,Base.Chars})` | 失敗 | 失敗 | 通過 |
| 9 | `evalpoly(x, p)` | 失敗 | 通過 | 未評価 |
| 10 | `findprev(pattern::AbstractString, string::AbstractString, start::Integer)` | 失敗 | 通過 | 未評価 |
| 11 | `findnext(pattern::AbstractString, string::AbstractString, start::Integer)` | 失敗 | 通過 | 未評価 |
| 12 | `getglobal(module::Module, name::Symbol, [order::Symbol=:monotonic])` | 失敗 | 通過 | 未評価 |
| 13 | `join([io::IO,] iterator [, delim [, last]])` | 通過 | 失敗 | 失敗 |
| 14 | `isreadable(ctx::SSLContext)` | 失敗 | 失敗 | 失敗 |
| 15 | `log2(x)` | 通過 | 通過 | 未評価 |
| 16 | `open(filename::AbstractString; lock = true, keywords...)::IOStream` | 失敗 | 失敗 | 失敗 |
| 17 | `reverse(A; dims=:)` | 失敗 | 通過 | 未評価 |
| 18 | `round(z::Complex[, RoundingModeReal, [RoundingModeImaginary]])` | 失敗 | 通過 | 未評価 |
| 19 | `set_zero_subnormals(yes::Bool)::Bool` | 失敗 | 通過 | 未評価 |
| 20 | `repr(mime, x; context=nothing)` | 失敗 | 通過 | 未評価 |
| 21 | `replace([io::IO], s::AbstractString, pat=>r, [pat2=>r2, ...]; [count::Integer])` | 失敗 | 通過 | 未評価 |
| 22 | `sizeof(T::DataType)` | 失敗 | 通過 | 未評価 |
| 23 | `startswith(s::AbstractString, prefix::Union{AbstractString,Base.Chars})` | 失敗 | 失敗 | 失敗 |
| 24 | `TimeType` | 失敗 | 通過 | 未評価 |
| 25 | `DateFormat(format::AbstractString, locale="english")` | 失敗 | 通過 | 未評価 |
| 26 | `callers(funcname, [data, lidict], [filename=<filename>], [linerange=<start:stop>])::Vector{Tupl` | 失敗 | 通過 | 未評価 |
| 27 | `Xoshiro(seed::Union{Integer, AbstractString})` | 失敗 | 通過 | 未評価 |

生データとプロンプト・応答は `julia/doc/_build/model-comparison/` の `results.json`、`astra-results.json`、`replay-after-table-fix.json` と各モデルのサブディレクトリに保存している。キーは保存していない。
