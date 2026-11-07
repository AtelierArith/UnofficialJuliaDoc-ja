```julia
result::InferenceResult
```

コードの一部に対して型推論を実行した結果を表す型です。コンストラクターは2つあります。

  * 通常の型推論用の `InferenceResult(mi::MethodInstance, [𝕃::AbstractLattice])`。`result.argtypes` に含まれる拡張格子情報は含みません。
  * 定数推論用の `InferenceResult(mi::MethodInstance, argtypes::Vector{Any}, overridden_by_const::BitVector)`。`result.argtypes` に含まれる拡張格子情報を含みます。
