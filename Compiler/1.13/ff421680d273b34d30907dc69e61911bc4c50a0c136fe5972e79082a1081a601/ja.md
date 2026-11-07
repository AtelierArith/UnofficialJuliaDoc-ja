```julia
cnd::Conditional
```

この値の型は`Bool`である可能性があります。ただし、ある程度のバックプロパゲーションを可能にするため、この`Bool`値がどのように作られたかについての情報も保持します。特に、この値に基づいて分岐する場合、真の分岐では`SlotNumber(cnd.slot)`の型が`cnd.thentype`に制限され、偽の分岐では`cnd.elsetype`に制限されると仮定できます。例：

```julia
let cond = isa(x::Union{Int, Float}, Int)::Conditional(x, Int, Float)
    if cond
       # May assume x is `Int` now
    else
       # May assume x is `Float` now
    end
end
```
