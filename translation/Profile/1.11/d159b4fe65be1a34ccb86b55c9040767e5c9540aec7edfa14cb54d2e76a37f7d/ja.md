```julia
Profile.take_page_profile(io::IOStream)
Profile.take_page_profile(filepath::String)
```

JuliaのプールアロケータからのページのJSONスナップショットを作成し、すべてのプール割り当てオブジェクトについて、それがガーベジであるか、その型を印刷します。
