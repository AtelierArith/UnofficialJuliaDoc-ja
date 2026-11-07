```julia
MultiDoc
```

関連するオブジェクト、つまり `Function`/`DataType` と、それに関連付けられた `Method` オブジェクトの docstring をまとめて格納します。

`MultiDoc` 内の各ドキュメント対象オブジェクトは、そのシグネチャで参照されます。シグネチャは、`Tuple` 型の `Union` で表されます。たとえば、次の `Method` 定義は

```julia
f(x, y) = ...
```

`MultiDoc` 内では `Tuple{Any, Any}` として格納されます。一方、

```julia
f(x::T, y = ?) where {T} = ...
```

は `Union{Tuple{T, Any}, Tuple{T}} where T` として格納されます。

注: `Function`/`DataType` オブジェクトのシグネチャは、常に `Union{}` です。
