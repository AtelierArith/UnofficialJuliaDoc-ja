```julia
from_interprocedural!(interp::AbstractInterpreter, rt, sv::AbsIntState,
                      arginfo::ArgInfo, maybecondinfo) -> newrt
```

手続き間の戻り値型 `rt` を、現在のローカル解析フレーム `sv` のコンテキストに適したローカル格子要素 `newrt` に変換します。特に、次の処理を行います。

  * `rt::LimitedAccuracy` をアンラップし、その制約を現在のフレーム `sv` に取り込みます。
  * 真偽値 `rt` を新しい真偽値 `newrt` に変換します。これにより、`newrt` が追加の条件付き絞り込み情報を伝播できるようになります。たとえば、`rt::InterConditional` を、`sv` 内の変数に関する型制約情報を保持する `newrt::Conditional` に変換します。

`abstract_call_method` または `abstract_call_method_with_const_args` から返された結果を伝播する箇所では、この関数を使用する*べきです*。

`maybecondinfo !== nothing` の場合、この関数は追加の条件付き引数型絞り込みも試みます。その場合、`maybecondinfo` は次のいずれかである必要があります。

  * `maybecondinfo::Tuple{Vector{Any},Vector{Any}}`: 事前計算された引数型の絞り込み情報
  * メソッド呼び出しのシグネチャタプル型

複数の `MethodMatch`es を扱う場合は、各メソッド呼び出しの引数シグネチャ型を `tmerge` して、`maybecondinfo` を事前計算しておくのが望ましいです。
