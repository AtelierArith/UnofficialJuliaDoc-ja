```julia
sync_selection!(state::SelectorState, nadded::Int) -> SelectorState
```

`nadded` 個の候補が先頭に追加された後、`state` の選択を更新します。

アクティブな選択は、引き続き同じ項目を指すようにずらされます。また、新しい候補のうち収集済みの項目は、アクティブな選択に移されます。返される状態では、残りの収集済み項目に合わせてスクロール位置とホバー位置が調整されます。
