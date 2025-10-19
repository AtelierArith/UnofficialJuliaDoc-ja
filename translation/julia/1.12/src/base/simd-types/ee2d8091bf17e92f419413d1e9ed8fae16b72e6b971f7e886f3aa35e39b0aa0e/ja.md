# SIMD Support

`VecElement{T}` 型は、SIMD 操作のライブラリを構築するために意図されています。実際に使用するには `llvmcall` を使用する必要があります。この型は次のように定義されています：

```julia
struct VecElement{T}
    value::T
end
```

特別なコンパイルルールがあります：`VecElement{T}`の同種タプルは、`T`がプリミティブビット型であるときにLLVMの`vector`型にマップされます。

`-O3`で、コンパイラはそのようなタプルに対する操作を自動的にベクトル化する*可能性*があります。例えば、次のプログラムは、`julia -O3`でコンパイルすると、x86システム上で2つのSIMD加算命令（`addps`）を生成します：

```julia
const m128 = NTuple{4,VecElement{Float32}}

function add(a::m128, b::m128)
    (VecElement(a[1].value+b[1].value),
     VecElement(a[2].value+b[2].value),
     VecElement(a[3].value+b[3].value),
     VecElement(a[4].value+b[4].value))
end

triple(c::m128) = add(add(c,c),c)

code_native(triple,(m128,))
```

ただし、自動ベクトル化に依存できないため、今後の使用は主に `llvmcall` を使用するライブラリを介して行われるでしょう。
