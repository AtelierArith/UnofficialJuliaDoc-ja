```julia
__init__
```

モジュール内の`__init__()`関数は、実行時にそのモジュールが初めて読み込まれた直後に実行されます。この関数は、モジュール内のほかのすべての文が実行された後に、一度だけ呼び出されます。モジュールのインポートが完了した後に呼び出されるため、サブモジュールの`__init__`関数が先に実行されます。`__init__`の典型的な用途として、外部Cライブラリの実行時初期化関数の呼び出しや、外部ライブラリから返されたポインターを含むグローバル定数の初期化があります。詳しくは[manual section about modules](@ref modules)を参照してください。

関連項目: [`OncePerProcess`](@ref)。

# Examples

```julia
const foo_data_ptr = Ref{Ptr{Cvoid}}(0)
function __init__()
    ccall((:foo_init, :libfoo), Cvoid, ())
    foo_data_ptr[] = ccall((:foo_data, :libfoo), Ptr{Cvoid}, ())
    nothing
end
```
