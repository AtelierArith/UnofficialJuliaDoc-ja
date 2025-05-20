```
Profile.take_page_profile(io::IOStream)
Profile.take_page_profile(filepath::String)
```

JuliaのプールアロケータからのページのJSONスナップショットを作成し、すべてのプールに割り当てられたオブジェクトについて、それがガーベジであるか、そのタイプを印刷します。
