```julia
names(x::Module; all::Bool=false, imported::Bool=false, usings::Bool=false) -> Vector{Symbol}
```

モジュールの公開名のベクターを取得します。非推奨の名前は除外されます。`all` が true の場合、リストにはモジュール内で定義された非公開名、非推奨名、およびコンパイラ生成名も含まれます。`imported` が true の場合、他のモジュールから明示的にインポートされた名前も含まれます。`usings` が true の場合、`using` を介して明示的にインポートされた名前も含まれます。名前はソートされた順序で返されます。

特別なケースとして、`Main` に定義されたすべての名前は「公開」と見なされます。なぜなら、`Main` の名前を明示的に公開としてマークすることは慣習的ではないからです。

!!! note
    `sym ∈ names(SomeModule)` は `isdefined(SomeModule, sym)` を意味しません。`names` は、モジュール内で定義されていなくても、`public` または `export` とマークされたシンボルを返すことがあります。


!!! warning
    `names` は重複した名前を返すことがあります。重複は、例えば、インポートされた名前が既存の識別子と衝突する場合に発生します。


参照: [`Base.isexported`](@ref), [`Base.ispublic`](@ref), [`Base.@locals`](@ref), [`@__MODULE__`](@ref).
