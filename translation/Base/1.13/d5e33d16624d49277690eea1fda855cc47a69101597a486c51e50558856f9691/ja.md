```julia
names(x::Module; all::Bool=false, imported::Bool=false, usings::Bool=false, world::UInt=Base.tls_world_age())::Vector{Symbol}
```

`Module` の公開名を、非推奨の名前を除いてベクトルとして取得します。`all` が true の場合、モジュール内で定義された非公開名、非推奨の名前、コンパイラが生成した名前もリストに含まれます。`imported` が true の場合、他のモジュールから明示的にインポートされた名前も含まれます。`usings` が true の場合、`using` を介して明示的または暗黙的にインポートされた名前も含まれます。名前はソートされた順序で返されます。

特例として、`Main` で定義された名前はすべて「公開」とみなされます。`Main` の名前を明示的に公開指定するのは、慣用的ではないためです。

`world` 引数は、バインディングのパーティションを検索する際に使用するワールドエイジを指定します。デフォルトは現在のタスクのワールドエイジです。最新のワールドにある名前を含めるには、`world=Base.get_world_counter()` を渡します。

!!! note
    `sym ∈ names(SomeModule)` は `isdefined(SomeModule, sym)` を意味するものではありません。`names` は、モジュール内で定義されていなくても、`public` または `export` としてマークされたシンボルを返すことがあります。


!!! warning
    `names` は、重複した名前を返すことがあります。たとえば、`import` された名前が既存の識別子と競合すると、重複が発生します。


!!! compat "Julia 1.12"
    `usings` 引数を使用するには、Julia 1.12 以降が必要です。


関連項目: [`Base.isexported`](@ref)、[`Base.ispublic`](@ref)、[`Base.@locals`](@ref)、[`@__MODULE__`](@ref)。
