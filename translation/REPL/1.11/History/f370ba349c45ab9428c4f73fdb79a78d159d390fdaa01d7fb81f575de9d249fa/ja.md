```julia
redisplay_all(io::IO, oldstate::SelectorState, newstate::SelectorState, pstate::PromptState; buf)
```

UI 全体（候補、プレビュー、プロンプト）を差分更新して再描画します。

ANSI 同期シーケンスを使って、`oldstate` と `newstate` の間で変更された領域だけを更新し、その後プロンプトを再表示します。
