```julia
redisplay_prompt(io::IO, oldstate::SelectorState, newstate::SelectorState, pstate::PromptState)
```

更新したクエリ、区切り文字、ヒントを使って、プロンプト行だけを再描画します。

カーソル位置に基づいて、`pstate`内のスタイル接頭辞、マッチタイプのインジケーター、結果件数を表示します。
