```julia
partially_inline!(code::Vector{Any}, slot_replacements::Vector{Any},
                  type_signature::Type{<:Tuple}, static_param_values::Vector{Any},
                  slot_offset::Int, statement_offset::Int,
                  boundscheck::Symbol)
```

`code` に格納された Julia IR に対して、インプレースで部分的なインライン化パスを実行し、それを返します。

この関数が行うインライン化変換は、一般に、メソッド呼び出しの実行時型シグネチャと、対応するメソッドの低水準化された IR だけから実行できるものです。そのため、この関数は主に、`@generated` 関数から出力する Julia IR を準備する際に役立ちます。

実行される変換は次のとおりです。

  * `1:length(slot_replacements)` の範囲内のスロット番号を、`slot_replacements` 内の対応する要素で置き換える
  * それ以外のスロット番号に `slot_offset` を加算する
  * 静的パラメーターのプレースホルダー（例：`Expr(:static_parameter, 1)`）を、対応する値で置き換える

値は `static_param_values` に含まれます。

  * IR 内に存在する文のインデックス（`GotoNode`、`SSAValue` など）に `statement_offset` を加算する

（呼び出し元で IR の先頭に新しい文を追加する場合に役立ちます）

  * 境界チェックを無効にする（`boundscheck === :off` の場合）、または境界チェックを伝播する（`boundscheck === :propagate` の場合）

この関数は `Core.Compiler.ssa_substitute!` に似ていますが、オプティマイザーの IR ではなく、型推論前の IR を対象に動作します。
