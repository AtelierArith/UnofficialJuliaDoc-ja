```
format(io::IO, tok::AbstractDateToken, dt::TimeType, locale)
```

`dt`から`tok`トークンをフォーマットし、それを`io`に書き込みます。フォーマットは`locale`に基づくことができます。

`AbstractDateToken`のすべてのサブタイプは、このメソッドを定義する必要があります。そうしないと、そのトークンを含む`DateFormat`に従ってDate / DateTimeオブジェクトを印刷できません。
