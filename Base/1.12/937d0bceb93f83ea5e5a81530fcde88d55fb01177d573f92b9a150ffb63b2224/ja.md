```julia
unsafe_replace!(p::Ptr{T}, expected, desired,
               [success_order::Symbol[, fail_order::Symbol=success_order]]) -> (; old, success::Bool)
```

これらは、メモリアドレスを指定された値に条件付きで設定するための操作を原子的に実行します。ハードウェアがサポートしている場合、これは適切なハードウェア命令に最適化される可能性がありますが、そうでない場合、その実行は次のようになります：

```julia
y = unsafe_load(p, fail_order)
ok = y === expected
if ok
    unsafe_store!(p, desired, success_order)
end
return (; old = y, success = ok)
```

この関数の `unsafe` プレフィックスは、ポインタ `p` が有効であることを確認するための検証が行われないことを示しています。Cと同様に、プログラマーはこの関数を呼び出している間に参照されているメモリが解放されたりガーベジコレクトされたりしないようにする責任があります。誤った使用はプログラムをセグメンテーションフォルトさせる可能性があります。

!!! compat "Julia 1.10"
    この関数は少なくともJulia 1.10を必要とします。


関連情報: [`replaceproperty!`](@ref Base.replaceproperty!), [`atomic`](@ref)
