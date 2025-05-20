`EASY_HOOK` は、新しい `Downloader` オブジェクトのデフォルト `easy_hook` として使用される修正可能なグローバルフックです。これは、`Curl.setopt` を介して `Downloader` のオプションを設定するためのメカニズムを提供します。

これは、2つの引数を取る関数であることが期待されています: `Easy` 構造体と、`url`、`method`、および `headers` という名前を持つ `info` NamedTuple です。
