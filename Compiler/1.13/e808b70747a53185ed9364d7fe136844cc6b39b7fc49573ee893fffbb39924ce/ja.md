```julia
inf_params::InferenceParams
```

抽象解釈に基づく型推論の動作を制御するパラメーターです。

---

  * `inf_params.max_methods::Int = 3` 一致するメソッドが `max_methods` 個を超える場合、型推論はその呼び出しの解析を打ち切ります。これは、コンパイラーのレイテンシーと生成コードの性能とのトレードオフを調整します。通常、多数のメソッドを考慮すると、質の低い型情報を得るために*多くの*時間を費やすことになるため、このオプションの値は小さく保つべきです。[`Base.Experimental.@max_methods`](@ref) を使うと、モジュール単位またはメソッド単位の注釈によって、この設定をより細かく制御できます。

---

  * `inf_params.max_union_splitting::Int = 4` 一致するメソッドまたは条件型の集合を計算する前に、入れ替えまたは展開するユニオンタプルの最大数を指定します。

---

  * `inf_params.max_apply_union_enum::Int = 8` `Core._apply_iterate` の呼び出しを推論する際に、入れ替えまたは展開するユニオンタプルの最大数を指定します。

---

  * `inf_params.max_tuple_splat::Int = 32` `Core._apply_iterate` の呼び出しを推論する際、タプルの要素数がこの値を超えると解析を中止します。

---

  * `inf_params.tuple_complexity_limit_depth::Int = 3` 再帰的な呼び出しグラフを推論する際、特殊化されたメソッドシグネチャに現れる大きなタプル型の最大深度を指定します。

---

  * `inf_params.ipo_constant_propagation::Bool = true` が `false` の場合、拡張格子情報を用いた解析を無効にします。つまり、具体評価、半具体解釈、定数伝播をすべて無効にします。[`Base.@constprop :none`](@ref Base.@constprop) を使うと、メソッド単位の注釈によって、この設定をより細かく制御できます。

---

  * `inf_params.aggressive_constant_propagation::Bool = false` が `true` の場合、拡張格子情報が利用可能なときは、すべてのメソッドで定数伝播を強制します。[`Base.@constprop :aggressive`](@ref Base.@constprop) を使うと、メソッド単位の注釈によって、この設定をより細かく制御できます。

---

  * `inf_params.assume_bindings_static::Bool = false` が `true` の場合、新しいバインディングは追加されないものとみなします。つまり、推論時に存在しないバインディングは実行時にも常に存在しないと仮定できます（したがって、たとえばそれへのアクセスは `throw` になります）。この仮定はネイティブコード実行時の Julia のセマンティクスでは成り立たないため、既定値は `false` です。

---

  * `inf_params.force_enable_inference::Bool = false` が `true` の場合、モジュールレベルで `Base.Experimental.@compiler_options` によって無効化されているかどうかにかかわらず、関数の推論を実行します。

---
