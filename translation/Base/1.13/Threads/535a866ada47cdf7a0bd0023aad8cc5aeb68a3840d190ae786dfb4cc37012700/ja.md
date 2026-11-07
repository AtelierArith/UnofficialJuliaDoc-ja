```julia
Threads.Atomic{T}
```

`T` 型のオブジェクトへの参照を保持し、そのオブジェクトへのアクセスが常にアトミック（スレッドセーフ）になるようにします。

非アトミックな値から新しいアトミックオブジェクトを作成できます。値を指定しない場合、アトミックオブジェクトはゼロで初期化されます。

アトミックオブジェクトには、次の `[]` 記法でアクセスできます。

# Examples

```jldoctest
julia> x = Threads.Atomic{Int}(3)
Base.Threads.Atomic{Int64}(3)

julia> x[] = 1
1

julia> x[]
1
```

アトミック操作では、`atomic_` という接頭辞を使用します。たとえば、[`atomic_add!`](@ref)、[`atomic_xchg!`](@ref) などです。
