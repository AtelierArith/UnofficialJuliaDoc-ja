```julia
format(io::IO, tok::AbstractDateToken, dt::TimeType, locale)
```

`dt`から`tok`トークンをフォーマットし、`io`に書き込みます。フォーマットは`locale`に基づいて指定できます。

`AbstractDateToken`のすべてのサブタイプは、このトークンを含む`DateFormat`に従ってDate / DateTimeオブジェクトを出力できるように、このメソッドを定義する必要があります。
