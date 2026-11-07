```julia
Profile.take_page_profile(io::IOStream)
Profile.take_page_profile(filepath::String)
```

Julia のプールアロケーターにあるページのスナップショットを JSON 形式で書き出します。プールで割り当てられた各オブジェクトについて、ガベージかどうか、またはその型を出力します。
