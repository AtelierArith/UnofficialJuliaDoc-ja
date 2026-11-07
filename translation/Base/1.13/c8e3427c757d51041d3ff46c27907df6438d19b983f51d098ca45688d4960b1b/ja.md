```julia
struct InterConditional
    slot::Int
    thentype
    elsetype
end
```

`Conditional`と同様ですが、呼び出し引数に課されるプロシージャ間制約を表します。ロジックエラーを検出できるよう、`Conditional`とは別に扱います。呼び出しの処理中は格子要素名が`InterConditional`で、それ以外の場所では`Conditional`です。
