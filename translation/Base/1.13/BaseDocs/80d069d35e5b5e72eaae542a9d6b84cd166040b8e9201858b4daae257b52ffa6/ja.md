```julia
setglobal!(module::Module, name::Symbol, x, [order::Symbol=:monotonic])
```

モジュール `module` 内の束縛 `name` の値を `x` に設定または変更します。型変換は行われないため、束縛にすでに型が宣言されている場合、`x` は適切な型でなければならず、そうでない場合はエラーが発生します。

この操作では、アトミック順序を指定することもできます。指定しない場合は、デフォルトで monotonic になります。

通常、ユーザーは [`setproperty!`](@ref Base.setproperty!) 関数または対応する構文（つまり `module.name = x`）を通じてこの機能を利用するため、これは非常に限定的な用途を想定しています。

!!! compat "Julia 1.9"
    この関数を使用するには、Julia 1.9 以降が必要です。


関連項目: [`setproperty!`](@ref Base.setproperty!) および [`getglobal`](@ref)

# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*\n.*)*"
julia> module M; global a; end;

julia> M.a  # same as `getglobal(M, :a)`
ERROR: UndefVarError: `a` not defined in `M`
Suggestion: add an appropriate import or assignment. This global was declared but not assigned.
Stacktrace:
 [1] getproperty(x::Module, f::Symbol)
   @ Base ./Base_compiler.jl:40
 [2] top-level scope
   @ none:1

julia> setglobal!(M, :a, 1)
1

julia> M.a
1
```
