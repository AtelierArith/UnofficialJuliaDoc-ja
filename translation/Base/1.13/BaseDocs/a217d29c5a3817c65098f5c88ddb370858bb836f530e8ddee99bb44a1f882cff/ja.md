```julia
declare_const(module::Module, name::Symbol, [x])
```

`module` 内の定数 `name` を、新しい値 `x` で作成または置き換えます。置き換える場合、`x` は元の定数と同じ型である必要はありません。

`x` が指定されていない場合、`name` は未定義の定数になります。読み書きはできませんが、再定義は可能です。

`const` という構文とは異なり、この関数を呼び出しても、現在のフレームのワールドエイジを更新するための `Core.@latestworld` は挿入されません。

```julia
julia> begin
           const x = 1
           println(x)
           const x = 2
           println(x)
           Core.declare_const(Main, :x, 3)
           println(x)
           Core.@latestworld
           println(x)
       end
1
2
2
3
```

!!! compat "Julia 1.12"
    この関数を使用するには、Julia 1.12 以降が必要です。それ以前のバージョンの Julia で定数を再定義した場合の動作は予測できません。


関連項目: [`const`](@ref)。
