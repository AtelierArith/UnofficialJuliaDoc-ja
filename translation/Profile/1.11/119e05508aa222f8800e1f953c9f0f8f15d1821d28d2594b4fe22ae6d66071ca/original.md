```
Profile.take_page_profile(io::IOStream)
Profile.take_page_profile(filepath::String)
```

Write a JSON snapshot of the pages from Julia's pool allocator, printing for every pool allocated object, whether it's garbage, or its type.
