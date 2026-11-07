```julia
finalizer(f, x)
```

`f(x)` を、`x` へのプログラムからアクセス可能な参照がなくなったときに呼び出されるよう登録し、`x` を返します。`x` の型は `mutable struct` でなければなりません。そうでない場合、この関数は例外をスローします。

`f` はタスク切り替えを引き起こしてはなりません。そのため、`println` など、ほとんどの I/O 操作は実行できません。デバッグ時には、`@async` マクロ（コンテキスト切り替えをファイナライザーの外側に遅延させるため）や、`ccall` を使って C の I/O 関数を直接呼び出すと役立つ場合があります。

`f` の実行時の world age は保証されていないことに注意してください。ファイナライザーが登録された時点の world age、またはそれ以降の任意の world age で呼び出される可能性があります。

# Examples

```julia
finalizer(my_mutable_struct) do x
    @async println("Finalizing $x.")
end

finalizer(my_mutable_struct) do x
    ccall(:jl_safe_printf, Cvoid, (Cstring, Cstring), "Finalizing %s.", repr(x))
end
```

オブジェクトの構築時にファイナライザーを登録することもできます。次の例では、新たに作成された可変構造体 `x` をファイナライザーが返すことに暗黙的に依存している点に注意してください。

```julia
mutable struct MyMutableStruct
    bar
    function MyMutableStruct(bar)
        x = new(bar)
        f(t) = @async println("Finalizing $t.")
        finalizer(f, x)
    end
end
```
