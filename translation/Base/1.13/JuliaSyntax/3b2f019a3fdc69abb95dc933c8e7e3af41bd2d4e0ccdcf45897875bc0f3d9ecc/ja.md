```julia
bump(stream [, flags=EMPTY_FLAGS];
     skip_newlines=false, error, remap_kind)
```

入力ストリームの現在のトークンを出力にコピーします。指定されたフラグを出力トークンに追加します（通常はデフォルトの `EMPTY_FLAGS` または `TRIVIA_FLAG` になります）。

キーワード引数:

  * `skip_newlines` - `true` の場合、改行は空白として扱われます。
  * `error` - 設定されている場合、このトークンについてエラーを出力します。
  * `remap_kind` - 変更が必要な場合に、出力トークンストリームで使用するトークンの種類。
