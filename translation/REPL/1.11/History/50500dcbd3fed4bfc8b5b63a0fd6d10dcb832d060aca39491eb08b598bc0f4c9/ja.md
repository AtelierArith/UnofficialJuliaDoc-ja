```julia
redisplay_prompt(io::IO, oldstate::SelectorState, newstate::SelectorState, pstate::PromptState)
```

更新したクエリ、区切り文字、ヒントを使って、プロンプト行だけを再描画します。

`pstate` 内のカーソル位置に基づいて、スタイルのプレフィックス、マッチタイプのインジケーター、結果数を表示します。
