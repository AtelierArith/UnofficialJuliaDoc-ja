```julia
Profile.take_page_profile(io::IOStream)
Profile.take_page_profile(filepath::String)
```

Julia のプールアロケータにあるページのスナップショットを JSON 形式で出力します。プールで割り当てられた各オブジェクトについて、ガベージかどうか、またはその型を出力します。
