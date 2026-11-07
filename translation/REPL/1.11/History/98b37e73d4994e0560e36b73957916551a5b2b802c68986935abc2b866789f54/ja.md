```julia
componentrows(state::SelectorState) -> (; candidates::Int, preview::Int)
```

利用可能なターミナルの行数を、候補リストとプレビューのペインに分割します。

プレビューの高さを、使用可能な領域の3分の1から3分の2の範囲に制限します。
