```julia
opt_params::OptimizationParams
```

オプティマイザーの動作を制御するパラメーター。

---

  * `opt_params.inlining::Bool = inlining_enabled()` インライン化を有効にするかどうかを制御します。

---

  * `opt_params.inline_cost_threshold::Int = 100` インライン化する価値がなくなるCPUサイクル数を指定します。

---

  * `opt_params.inline_nonleaf_penalty::Int = 1000` 動的ディスパッチのペナルティコストを指定します。

---

  * `opt_params.inline_tupleret_bonus::Int = 250` 具象型でないタプル戻り値型を持つメソッド特殊化について、インライン化をどれだけ積極的に行うかを指定します（分割を促すため）。インライン化の判断時に、`opt_params.inline_tupleret_bonus` が `opt_params.inline_cost_threshold` に加算されます。

---

  * `opt_params.max_tuple_splat::Int = 32` `Core._apply_iterate` のインライン化を試みる際、タプルの要素数がこの値を超えている場合は最適化を中止します。

---

  * `opt_params.compilesig_invokes::Bool = true` `true` の場合、過剰な特殊化を避けるため、[`@nospecialize`](@ref) アノテーションに基づいて `:invoke` 式を生成する際に呼び出す `MethodInstance` を変更する権限をインライナーに与えます。

---

  * `opt_params.assume_fatal_throw::Bool = false` `true` の場合、オプティマイザーは任意の `throw` が致命的であると仮定できるため、`throw` 後の状態は外部から観測できないものとして扱えます。特に、特定のコードパス内で観測されないことが証明された副作用を、例外を投げる呼び出しの前後に移動する権限をオプティマイザーに与えます。デフォルトは `false` です。

---

  * `opt_params.preserve_local_sources::Bool = false` `true` の場合、インライナーは `CallInfo` オブジェクトに保持されているローカルキャッシュ済みソースを変更できず、呼び出し元のコンテキストにインライン化する前に必ずコピーを作成します。デフォルトは `false` です。

---
