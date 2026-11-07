```julia
unsafe_replace!(p::Ptr{T}, expected, desired,
               [success_order::Symbol[, fail_order::Symbol=success_order]]) -> (; old, success::Bool)
```

これらの関数は、メモリアドレスの値を取得し、指定した値に条件付きで設定する操作をアトミックに実行します。ハードウェアが対応している場合は、適切なハードウェア命令に最適化されることがあります。対応していない場合、実行内容は次のようになります。

```julia
y = unsafe_load(p, fail_order)
ok = y === expected
if ok
    unsafe_store!(p, desired, success_order)
end
return (; old = y, success = ok)
```

この関数名の接頭辞 `unsafe` は、ポインター `p` が有効かどうかの検証を行わないことを示しています。C と同様に、この関数の呼び出し中に参照先のメモリが解放されたり、ガベージコレクションされたりしないようにする責任はプログラマーにあります。誤った使い方をすると、プログラムがセグフォルトを起こす可能性があります。

!!! compat "Julia 1.10"
    この関数を使用するには、Julia 1.10 以降が必要です。


関連項目: [`replaceproperty!`](@ref Base.replaceproperty!)、[`atomic`](@ref)
