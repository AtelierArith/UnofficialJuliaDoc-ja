```julia
partially_inline!(code::Vector{Any}, slot_replacements::Vector{Any},
                  type_signature::Type{<:Tuple}, static_param_values::Vector{Any},
                  slot_offset::Int, statement_offset::Int,
                  boundscheck::Symbol)
```

`code` に格納されている Julia IR に対してインプレースで部分的なインライン化パスを実行し、それを返します。

この関数が行うのは、メソッド呼び出しの実行時の型シグネチャと、対応するメソッドの lowered IR だけが与えられた場合に、一般に可能なインライン化変換です。したがって、この関数は主に、`@generated` 関数から出力する Julia IR を準備する際に役立ちます。

実行される変換は次のとおりです。

  * `1:length(slot_replacements)` の範囲内にあるスロット番号を、`slot_replacements` 内の対応する要素に置き換える
  * それ以外のスロット番号に `slot_offset` を加算する
  * 静的パラメーターのプレースホルダー（例：`Expr(:static_parameter, 1)`）を、次に含まれる対応する値に置き換える

`static_param_values`

  * IR 内に存在するすべての文インデックス（`GotoNode`、`SSAValue` など）に `statement_offset` を加算する

（呼び出し側で IR の先頭に新しい文を追加する予定がある場合に役立ちます）

  * 境界チェックを無効にする（`boundscheck === :off` の場合）、または境界チェックを伝播させる（`boundscheck === :propagate` の場合）

この関数は `Core.Compiler.ssa_substitute!` に似ていますが、オプティマイザーの IR ではなく、型推論前の IR を処理します。
