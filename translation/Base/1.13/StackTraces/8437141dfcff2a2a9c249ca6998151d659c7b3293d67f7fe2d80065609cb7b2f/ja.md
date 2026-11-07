```julia
StackFrame
```

実行コンテキストを表すスタック情報。次のフィールドを持ちます。

  * `func::Symbol`

    実行コンテキストを含む関数の名前。
  * `linfo::Union{Method, Core.MethodInstance, Core.CodeInstance, Core.CodeInfo, Nothing}`

    実行コンテキストを含む Method、MethodInstance、CodeInstance、または CodeInfo（見つかった場合）。見つからない場合は nothing（たとえば、マクロ展開の結果としてインライン化された場合）。
  * `file::Symbol`

    実行コンテキストを含むファイルへのパス。
  * `line::Int`

    実行コンテキストを含むファイルの行番号。
  * `from_c::Bool`

    コードが C 由来の場合は True。
  * `inlined::Bool`

    コードがインライン化されたフレーム由来の場合は True。
  * `pointer::UInt64`

    `backtrace` が返す、実行コンテキストへのポインターの表現。
