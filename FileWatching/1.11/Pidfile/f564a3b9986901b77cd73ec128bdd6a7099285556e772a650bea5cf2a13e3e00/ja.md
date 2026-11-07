```julia
open_exclusive(path::String; mode, poll_interval, wait, stale_age, refresh) :: File
```

読み書き可能なアドバイザリ排他アクセス用の新しいファイルを作成します。`wait` が `false` の場合、ロックファイルが存在すればエラーを返し、存在しなければロックを取得できるまで待機します。

キーワード引数の説明については、[`mkpidlock`](@ref) を参照してください。
