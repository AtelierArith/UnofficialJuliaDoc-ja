```julia
StackFrame
```

実行コンテキストを表すスタック情報で、以下のフィールドがあります：

  * `func::Symbol`

    実行コンテキストを含む関数の名前。
  * `linfo::Union{Method, Core.MethodInstance, Core.CodeInstance, Core.CodeInfo, Nothing}`

    実行コンテキストを含むMethod、MethodInstance、CodeInstance、またはCodeInfo（見つかった場合）、または何もない（例えば、インライン化がマクロ展開の結果であった場合）。
  * `file::Symbol`

    実行コンテキストを含むファイルへのパス。
  * `line::Int`

    実行コンテキストを含むファイルの行番号。
  * `from_c::Bool`

    コードがCからのものである場合は真。
  * `inlined::Bool`

    コードがインラインフレームからのものである場合は真。
  * `pointer::UInt64`

    `backtrace`によって返される実行コンテキストへのポインタの表現。
