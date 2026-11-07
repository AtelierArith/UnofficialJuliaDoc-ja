`EASY_HOOK`は、新しい`Downloader`オブジェクトのデフォルトの`easy_hook`として使用される、変更可能なグローバルフックです。これにより、`Curl.setopt`を介して`Downloader`のオプションを設定できます。

このフックは、`Easy`構造体と、`url`、`method`、`headers`という名前を持つ`info` NamedTupleを引数に取る関数であることが想定されています。
