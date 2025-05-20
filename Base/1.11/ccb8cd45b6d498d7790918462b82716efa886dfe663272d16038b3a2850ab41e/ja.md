```
names(x::Module; all::Bool = false, imported::Bool = false)
```

`Module`の公開名のベクターを取得します。非推奨の名前は除外されます。`all`がtrueの場合、リストにはモジュール内で定義された非公開名、非推奨の名前、およびコンパイラ生成の名前も含まれます。`imported`がtrueの場合、他のモジュールから明示的にインポートされた名前も含まれます。名前はソートされた順序で返されます。

特別なケースとして、`Main`で定義されたすべての名前は「公開」と見なされます。なぜなら、`Main`からの名前を明示的に公開としてマークすることは慣習的ではないからです。

!!! note
    `sym ∈ names(SomeModule)`は`isdefined(SomeModule, sym)`を意味しません。`names`は、モジュール内で定義されていなくても、`public`または`export`としてマークされたシンボルを返します。


参照: [`Base.isexported`](@ref), [`Base.ispublic`](@ref), [`Base.@locals`](@ref), [`@__MODULE__`](@ref).
