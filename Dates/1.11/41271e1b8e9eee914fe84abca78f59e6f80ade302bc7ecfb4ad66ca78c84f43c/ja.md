```julia
format(io::IO, tok::AbstractDateToken, dt::TimeType, locale)
```

`dt`から`tok`トークンをフォーマットし、`io`に書き込みます。フォーマットには`locale`を使用できます。

`AbstractDateToken`のすべてのサブタイプは、このトークンを含む`DateFormat`に従ってDate / DateTimeオブジェクトを出力できるように、このメソッドを定義する必要があります。
