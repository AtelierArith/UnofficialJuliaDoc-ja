# Stack Traces

`StackTraces` モジュールは、人間が読みやすく、プログラム的に使いやすいシンプルなスタックトレースを提供します。

## Viewing a stack trace

主にスタックトレースを取得するために使用される関数は [`stacktrace`](@ref) です:

```julia-repl
6-element Array{Base.StackTraces.StackFrame,1}:
 top-level scope
 eval at boot.jl:317 [inlined]
 eval(::Module, ::Expr) at REPL.jl:5
 eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
 macro expansion at REPL.jl:116 [inlined]
 (::getfield(REPL, Symbol("##28#29")){REPL.REPLBackend})() at event.jl:92
```

[`stacktrace()`](@ref) を呼び出すと、[`StackTraces.StackFrame`](@ref) のベクトルが返されます。使いやすさのために、エイリアス [`StackTraces.StackTrace`](@ref) を `Vector{StackFrame}` の代わりに使用できます。（`[...]` を含む例は、コードの実行方法によって出力が異なる可能性があることを示しています。）

```julia-repl
julia> example() = stacktrace()
example (generic function with 1 method)

julia> example()
7-element Array{Base.StackTraces.StackFrame,1}:
 example() at REPL[1]:1
 top-level scope
 eval at boot.jl:317 [inlined]
[...]

julia> @noinline child() = stacktrace()
child (generic function with 1 method)

julia> @noinline parent() = child()
parent (generic function with 1 method)

julia> grandparent() = parent()
grandparent (generic function with 1 method)

julia> grandparent()
9-element Array{Base.StackTraces.StackFrame,1}:
 child() at REPL[3]:1
 parent() at REPL[4]:1
 grandparent() at REPL[5]:1
[...]
```

[`stacktrace()`](@ref)を呼び出すと、通常は`eval at boot.jl`のフレームが表示されます。REPLから`4d61726b646f776e2e436f64652822222c2022737461636b747261636528292229_40726566`を呼び出すと、通常は`REPL.jl`からのいくつかの追加フレームがスタックに表示され、次のようになります:

```julia-repl
julia> example() = stacktrace()
example (generic function with 1 method)

julia> example()
7-element Array{Base.StackTraces.StackFrame,1}:
 example() at REPL[1]:1
 top-level scope
 eval at boot.jl:317 [inlined]
 eval(::Module, ::Expr) at REPL.jl:5
 eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
 macro expansion at REPL.jl:116 [inlined]
 (::getfield(REPL, Symbol("##28#29")){REPL.REPLBackend})() at event.jl:92
```

## Extracting useful information

各 [`StackTraces.StackFrame`](@ref) には、関数名、ファイル名、行番号、ラムダ情報、フレームがインライン化されているかどうかを示すフラグ、C関数であるかどうかを示すフラグ（デフォルトではC関数はスタックトレースに表示されません）、および [`backtrace`](@ref) によって返されるポインタの整数表現が含まれています。

```julia-repl
julia> frame = stacktrace()[3]
eval(::Module, ::Expr) at REPL.jl:5

julia> frame.func
:eval

julia> frame.file
Symbol("~/julia/usr/share/julia/stdlib/v0.7/REPL/src/REPL.jl")

julia> frame.line
5

julia> frame.linfo
MethodInstance for eval(::Module, ::Expr)

julia> frame.inlined
false

julia> frame.from_c
false

julia> frame.pointer
0x00007f92d6293171
```

これにより、スタックトレース情報がプログラム的に利用可能になり、ログ記録、エラーハンドリングなどに役立ちます。

## Error handling

コールスタックの現在の状態に関する情報に簡単にアクセスできることは、多くの場面で役立ちますが、最も明白な応用はエラーハンドリングとデバッグです。

```julia-repl
julia> @noinline bad_function() = undeclared_variable
bad_function (generic function with 1 method)

julia> @noinline example() = try
           bad_function()
       catch
           stacktrace()
       end
example (generic function with 1 method)

julia> example()
7-element Array{Base.StackTraces.StackFrame,1}:
 example() at REPL[2]:4
 top-level scope
 eval at boot.jl:317 [inlined]
[...]
```

上記の例では、最初のスタックフレームが行4を指していることに気付くかもしれません。ここでは [`stacktrace`](@ref) が呼び出されており、行2で呼び出されている *bad_function* のフレームは完全に欠落しています。これは理解できます。なぜなら、`4d61726b646f776e2e436f64652822222c2022737461636b74726163652229_40726566` が *catch* のコンテキストから呼び出されているからです。この例では、エラーの実際の原因を見つけるのは比較的簡単ですが、複雑なケースではエラーの原因を追跡することが難しくなります。

この問題は、[`catch_backtrace`](@ref)の結果を[`stacktrace`](@ref)に渡すことで解決できます。現在のコンテキストのコールスタック情報を返す代わりに、`4d61726b646f776e2e436f64652822222c202263617463685f6261636b74726163652229_40726566`は、最も最近の例外のコンテキストに関するスタック情報を返します：

```julia-repl
julia> @noinline bad_function() = undeclared_variable
bad_function (generic function with 1 method)

julia> @noinline example() = try
           bad_function()
       catch
           stacktrace(catch_backtrace())
       end
example (generic function with 1 method)

julia> example()
8-element Array{Base.StackTraces.StackFrame,1}:
 bad_function() at REPL[1]:1
 example() at REPL[2]:2
[...]
```

スタックトレースが適切な行番号と欠落しているフレームを示していることに注意してください。

```julia-repl
julia> @noinline child() = error("Whoops!")
child (generic function with 1 method)

julia> @noinline parent() = child()
parent (generic function with 1 method)

julia> @noinline function grandparent()
           try
               parent()
           catch err
               println("ERROR: ", err.msg)
               stacktrace(catch_backtrace())
           end
       end
grandparent (generic function with 1 method)

julia> grandparent()
ERROR: Whoops!
10-element Array{Base.StackTraces.StackFrame,1}:
 error at error.jl:33 [inlined]
 child() at REPL[1]:1
 parent() at REPL[2]:1
 grandparent() at REPL[3]:3
[...]
```

## Exception stacks and [`current_exceptions`](@ref)

!!! compat "Julia 1.1"
    例外スタックは少なくともJulia 1.1が必要です。


例外を処理している間に、さらに例外が発生することがあります。これらのすべての例外を調査して問題の根本原因を特定することは有用です。Juliaランタイムは、例外が発生するたびに各例外を内部の*例外スタック*にプッシュすることでこれをサポートしています。コードが`catch`を通常通りに終了すると、関連する`try`でスタックにプッシュされた例外はすべて正常に処理されたと見なされ、スタックから削除されます。

現在の例外のスタックは、[`current_exceptions`](@ref) 関数を使用してアクセスできます。例えば、

```julia-repl
julia> try
           error("(A) The root cause")
       catch
           try
               error("(B) An exception while handling the exception")
           catch
               for (exc, bt) in current_exceptions()
                   showerror(stdout, exc, bt)
                   println(stdout)
               end
           end
       end
(A) The root cause
Stacktrace:
 [1] error(::String) at error.jl:33
 [2] top-level scope at REPL[7]:2
 [3] eval(::Module, ::Any) at boot.jl:319
 [4] eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
 [5] macro expansion at REPL.jl:117 [inlined]
 [6] (::getfield(REPL, Symbol("##26#27")){REPL.REPLBackend})() at task.jl:259
(B) An exception while handling the exception
Stacktrace:
 [1] error(::String) at error.jl:33
 [2] top-level scope at REPL[7]:5
 [3] eval(::Module, ::Any) at boot.jl:319
 [4] eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
 [5] macro expansion at REPL.jl:117 [inlined]
 [6] (::getfield(REPL, Symbol("##26#27")){REPL.REPLBackend})() at task.jl:259
```

この例では、ルート原因の例外 (A) がスタックの最初にあり、その後に別の例外 (B) が続いています。両方のキャッチブロックを通常通りに終了した後（つまり、さらなる例外をスローすることなく）、すべての例外はスタックから削除され、もはやアクセスできなくなります。

例外スタックは、例外が発生した `Task` に保存されます。タスクが未処理の例外で失敗した場合、`current_exceptions(task)` を使用してそのタスクの例外スタックを検査できます。

## Comparison with [`backtrace`](@ref)

[`backtrace`](@ref)への呼び出しは、`Union{Ptr{Nothing}, Base.InterpreterIP}`のベクターを返し、その後、[`stacktrace`](@ref)に渡して翻訳することができます。

```julia-repl
julia> trace = backtrace()
18-element Array{Union{Ptr{Nothing}, Base.InterpreterIP},1}:
 Ptr{Nothing} @0x00007fd8734c6209
 Ptr{Nothing} @0x00007fd87362b342
 Ptr{Nothing} @0x00007fd87362c136
 Ptr{Nothing} @0x00007fd87362c986
 Ptr{Nothing} @0x00007fd87362d089
 Base.InterpreterIP(CodeInfo(:(begin
      Core.SSAValue(0) = backtrace()
      trace = Core.SSAValue(0)
      return Core.SSAValue(0)
  end)), 0x0000000000000000)
 Ptr{Nothing} @0x00007fd87362e4cf
[...]

julia> stacktrace(trace)
6-element Array{Base.StackTraces.StackFrame,1}:
 top-level scope
 eval at boot.jl:317 [inlined]
 eval(::Module, ::Expr) at REPL.jl:5
 eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
 macro expansion at REPL.jl:116 [inlined]
 (::getfield(REPL, Symbol("##28#29")){REPL.REPLBackend})() at event.jl:92
```

[`backtrace`](@ref) が返すベクターには18の要素が含まれているのに対し、[`stacktrace`](@ref) が返すベクターには6つしか含まれていません。これは、デフォルトでは `4d61726b646f776e2e436f64652822222c2022737461636b74726163652229_40726566` がスタックから低レベルのC関数を削除するためです。C呼び出しからスタックフレームを含めたい場合は、次のようにします：

```julia-repl
julia> stacktrace(trace, true)
21-element Array{Base.StackTraces.StackFrame,1}:
 jl_apply_generic at gf.c:2167
 do_call at interpreter.c:324
 eval_value at interpreter.c:416
 eval_body at interpreter.c:559
 jl_interpret_toplevel_thunk_callback at interpreter.c:798
 top-level scope
 jl_interpret_toplevel_thunk at interpreter.c:807
 jl_toplevel_eval_flex at toplevel.c:856
 jl_toplevel_eval_in at builtins.c:624
 eval at boot.jl:317 [inlined]
 eval(::Module, ::Expr) at REPL.jl:5
 jl_apply_generic at gf.c:2167
 eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
 jl_apply_generic at gf.c:2167
 macro expansion at REPL.jl:116 [inlined]
 (::getfield(REPL, Symbol("##28#29")){REPL.REPLBackend})() at event.jl:92
 jl_fptr_trampoline at gf.c:1838
 jl_apply_generic at gf.c:2167
 jl_apply at julia.h:1540 [inlined]
 start_task at task.c:268
 ip:0xffffffffffffffff
```

個々のポインタは [`backtrace`](@ref) から返され、[`StackTraces.StackFrame`](@ref) に変換されます。これらは [`StackTraces.lookup`](@ref) に渡すことによって得られます。

```julia-repl
julia> pointer = backtrace()[1];

julia> frame = StackTraces.lookup(pointer)
1-element Array{Base.StackTraces.StackFrame,1}:
 jl_apply_generic at gf.c:2167

julia> println("The top frame is from $(frame[1].func)!")
The top frame is from jl_apply_generic!
```
