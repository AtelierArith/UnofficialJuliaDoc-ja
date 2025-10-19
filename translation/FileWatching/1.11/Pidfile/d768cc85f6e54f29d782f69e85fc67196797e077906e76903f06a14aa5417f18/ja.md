```julia
open_exclusive(path::String; mode, poll_interval, wait, stale_age, refresh) :: File
```

読み書きの助言的排他アクセスのために新しいファイルを作成します。`wait`が`false`の場合、ロックファイルが存在する場合はエラーを出力し、そうでない場合はロックを取得するまでブロックします。

キーワード引数の説明については、[`mkpidlock`](@ref)を参照してください。
