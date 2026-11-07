```julia
Compute line number annotations for an IRCode or CodeInfo.
```

This functions compute three sets of annotations for each IR line. Take the following example (taken from `@code_typed sin(1.0)`):

```julia
    **                                                    ***         **********
    35 6 ── %10  = :(Base.mul_float)(%%2, %%2)::Float64   │╻╷         sin_kernel
       │    %11  = :(Base.mul_float)(%10, %10)::Float64   ││╻          *
```

The three annotations are indicated with `*`. The first one is the line number of the active function (printed once whenever the outer most line number changes). The second is the inlining indicator. The number of lines indicate the level of nesting, with a half-size line (╷) indicating the start of a scope and a full size line (│) indicating a continuing scope. The last annotation is the most complicated one. It is a heuristic way to print the name of the entered scope. What it attempts to do is print the outermost scope that hasn't been printed before. Let's work a number of examples to see the impacts and tradeoffs involved.

```julia
f() = leaf_function() # Deliberately not defined to end up in the IR verbatim
g() = f()
h() = g()
top_function() = h()
```

After inlining, we end up with:

```julia
1 1 ─ %1 = :(Main.leaf_function)()::Any   │╻╷╷ h
  └──      return %1                      │
```

We see that the only function printed is the outermost function. This certainly loses some information, but the idea is that the outermost function would have the most semantic meaning (in the context of the function we're looking at).

On the other hand, let's see what happens when we redefine f:

```julia
function f()
    leaf_function()
    leaf_function()
    leaf_function()
end
```

We get:

```julia
1 1 ─      :(Main.leaf_function)()::Any   │╻╷╷ h
  │        :(Main.leaf_function)()::Any   ││┃│  g
  │   %3 = :(Main.leaf_function)()::Any   │││┃   f
  └──      return %3                      │
```

Even though we were in the `f` scope since the first statement, it took us two statements to catch up and print the intermediate scopes. Which scope is printed is indicated both by the indentation of the method name and by an increased thickness of the appropriate line for the scope.
