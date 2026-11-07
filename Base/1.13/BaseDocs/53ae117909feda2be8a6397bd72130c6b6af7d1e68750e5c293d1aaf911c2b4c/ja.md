```julia
getglobal(module::Module, name::Symbol, [order::Symbol=:monotonic])
```

モジュール `module` から、束縛 `name` の値を取得します。この操作にはアトミック順序を任意で指定できます。指定しない場合、デフォルトは monotonic です。

互換性を維持するため、[`getfield`](@ref) によるモジュールの束縛へのアクセスも引き続きサポートされていますが、常に `getglobal` を優先して使用すべきです。`getglobal` ではアトミック順序を制御でき（`getfield` は常に monotonic）、ユーザーにもコンパイラにもコードの意図がより明確に伝わるためです。

ほとんどのユーザーは、この関数を直接呼び出す必要はありません。ごく少数の非常に限定的なユースケースを除き、[`getproperty`](@ref Base.getproperty) 関数または対応する構文（`module.name`）を優先して使用すべきです。

!!! compat "Julia 1.9"
    この関数には Julia 1.9 以降が必要です。


[`getproperty`](@ref Base.getproperty) および [`setglobal!`](@ref) も参照してください。

# Examples

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
