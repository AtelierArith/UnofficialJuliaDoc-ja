デフォルトでは、`AbstractInterpreter` は次の推論打ち切りロジックを実装しています。

  * `bail_out_toplevel_call(::AbstractInterpreter, sig, ::InferenceState)`: トップレベルおよび具象でない呼び出し箇所 `callsig` を推論する際、プロシージャ間推論を打ち切る
  * `bail_out_call(::AbstractInterpreter, rt, ::InferenceState)`: 戻り値の型 `rt` が `Any` まで拡大した場合、プロシージャ間推論を打ち切る
  * `bail_out_apply(::AbstractInterpreter, rt, ::InferenceState)`: 戻り値の型 `rt` が `Any` まで拡大した場合、`_apply_iterate` 推論を打ち切る

また、いずれかの束要素が `Bottom` まで低下すると、ローカル文／フレーム推論も打ち切ります。ただし、`AbstractInterpreter` には、これを設定するための専用インターフェースはありません。
