# Stack Traces

`StackTraces` モジュールは、人間が読みやすく、プログラムからも簡単に利用できるスタックトレースを提供します。

## Viewing a stack trace

スタックトレースを取得するための主な関数は、[`stacktrace`](@ref) です。

```julia-repl
6-element Array{Base.StackTraces.StackFrame,1}:
 top-level scope
 eval at boot.jl:317 [inlined]
 eval(::Module, ::Expr) at REPL.jl:5
 eval_user_input(::Any, ::REPL.REPLBackend) at REPL.jl:85
 macro expansion at REPL.jl:116 [inlined]
 (::getfield(REPL, Symbol("##28#29")){REPL.REPLBackend})() at event.jl:92
```

[`stacktrace()`](@ref) を呼び出すと、[`StackTraces.StackFrame`](@ref) のベクトルが返されます。使いやすさのため、`Vector{StackFrame}` の代わりにエイリアス [`StackTraces.StackTrace`](@ref) を使用できます。（`[...]` を含む例では、コードの実行方法によって出力が異なる場合があります。）

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

[`stacktrace()`](@ref) を呼び出すと、通常は `eval at boot.jl` を含むフレームが表示されます。REPL から [`stacktrace()`](@ref) を呼び出すと、`REPL.jl` によるフレームもスタックにいくつか追加されます。通常は次のようになります。

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

各 [`StackTraces.StackFrame`](@ref) には、関数名、ファイル名、行番号、ラムダ情報、フレームがインライン化されているかどうかを示すフラグ、C 関数かどうかを示すフラグ（デフォルトでは C 関数はスタックトレースに表示されません）、および [`backtrace`](@ref) が返すポインターを整数で表した値が含まれます。

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

これにより、ログ記録やエラー処理などで、スタックトレースの情報をプログラムから利用できます。

## Error handling

呼び出しスタックの現在の状態に関する情報を簡単に取得できると、さまざまな場面で役立ちますが、最も分かりやすい用途はエラー処理とデバッグです。

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

上の例では、最初のスタックフレームが *bad_function* の呼び出し箇所である 2 行目ではなく、[`stacktrace`](@ref) の呼び出し箇所である 4 行目を指しており、`bad_function` のフレームが完全に欠落していることに気づくかもしれません。これは、[`stacktrace`](@ref) が *catch* のコンテキストから呼び出されているためです。この例ではエラーの実際の発生源を簡単に特定できますが、複雑なケースでは特定が容易ではありません。

[`catch_backtrace`](@ref) の結果を [`stacktrace`](@ref) に渡すことで、この問題を解決できます。[`catch_backtrace`](@ref) は、現在のコンテキストの呼び出しスタック情報ではなく、直近の例外が発生したコンテキストのスタック情報を返します。

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

スタックトレースに、適切な行番号と欠落していたフレームが表示されていることに注目してください。

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
    例外スタックを利用するには、Julia 1.1 以降が必要です。


例外を処理している最中に、さらに例外が発生することがあります。問題の根本原因を特定するために、こうした例外をすべて調べると役立つ場合があります。Julia ランタイムは、例外が発生するたびに内部の *例外スタック* に追加することで、これをサポートしています。コードが `catch` を正常に抜けると、対応する `try` 内でスタックに追加された例外は、正常に処理されたものとみなされ、スタックから削除されます。

現在の例外スタックには、[`current_exceptions`](@ref) 関数を使ってアクセスできます。たとえば、次のようになります。

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

この例では、根本原因となった例外（A）がスタックの先頭にあり、その後に別の例外（B）が続いています。両方の catch ブロックを正常に抜けると（つまり、さらに例外を投げずに抜けると）、すべての例外がスタックから削除され、アクセスできなくなります。

例外スタックは、例外が発生した `Task` に保存されます。タスクが捕捉されない例外によって失敗した場合は、`current_exceptions(task)` を使って、そのタスクの例外スタックを調べることができます。

## Comparison with [`backtrace`](@ref)

[`backtrace`](@ref) を呼び出すと、`Union{Ptr{Nothing}, Base.InterpreterIP}` のベクトルが返されます。このベクトルを [`stacktrace`](@ref) に渡すと、スタックトレースに変換できます。

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

[`backtrace`](@ref) が返したベクトルには 18 個の要素がある一方、[`stacktrace`](@ref) が返したベクトルには 6 個しかないことに注目してください。これは、デフォルトで [`stacktrace`](@ref) がスタックから下位レベルの C 関数を取り除くためです。C 関数の呼び出しによるスタックフレームも含めるには、次のようにします。

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

[`backtrace`](@ref) が返す個々のポインターは、[`StackTraces.lookup`](@ref) に渡すことで [`StackTraces.StackFrame`](@ref) に変換できます。

```julia-repl
julia> pointer = backtrace()[1];

julia> frame = StackTraces.lookup(pointer)
1-element Array{Base.StackTraces.StackFrame,1}:
 jl_apply_generic at gf.c:2167

julia> println("The top frame is from $(frame[1].func)!")
The top frame is from jl_apply_generic!
```
