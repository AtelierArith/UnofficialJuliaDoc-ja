```
getglobal(module::Module, name::Symbol, [order::Symbol=:monotonic])
```

モジュール `module` からバインディング `name` の値を取得します。オプションで、操作のための原子的な順序を定義できます。指定しない場合は、デフォルトで単調になります。

[`getfield`](@ref) を使用してモジュールのバインディングにアクセスすることは互換性を維持するためにまだサポートされていますが、`getglobal` を使用することが常に推奨されます。なぜなら、`getglobal` は原子的な順序を制御できるため（`getfield` は常に単調です）、ユーザーやコンパイラに対してコードの意図をより明確に示すことができるからです。

ほとんどのユーザーはこの関数を直接呼び出す必要はありません – [`getproperty`](@ref Base.getproperty) 関数または対応する構文（すなわち `module.name`）が、非常に特定の使用ケースを除いて常に推奨されます。

!!! compat "Julia 1.9"
    この関数は Julia 1.9 以降が必要です。


他にも [`getproperty`](@ref Base.getproperty) と [`setglobal!`](@ref) を参照してください。

# 例

```jldoctest
julia> a = 1
1

julia> module M
       a = 2
       end;

julia> getglobal(@__MODULE__, :a)
1

julia> getglobal(M, :a)
2
```
