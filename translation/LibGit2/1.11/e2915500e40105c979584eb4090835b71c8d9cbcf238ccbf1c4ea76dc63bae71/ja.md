```
GitHash(ptr::Ptr{UInt8})
```

`UInt8`データへのポインタから`GitHash`を構築します。このデータにはSHA-1ハッシュのバイトが含まれています。ポインタがnull、すなわち`C_NULL`と等しい場合、コンストラクタはエラーをスローします。
