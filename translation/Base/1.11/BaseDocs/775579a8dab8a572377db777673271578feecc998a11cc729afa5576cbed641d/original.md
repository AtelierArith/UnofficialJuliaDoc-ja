```
;
```

`;` has a similar role in Julia as in many C-like languages, and is used to delimit the end of the previous statement.

`;` is not necessary at the end of a line, but can be used to separate statements on a single line or to join statements into a single expression.

Adding `;` at the end of a line in the REPL will suppress printing the result of that expression.

In function declarations, and optionally in calls, `;` separates regular arguments from keywords.

In array literals, arguments separated by semicolons have their contents concatenated together. A separator made of a single `;` concatenates vertically (i.e. along the first dimension), `;;` concatenates horizontally (second dimension), `;;;` concatenates along the third dimension, etc. Such a separator can also be used in last position in the square brackets to add trailing dimensions of length 1.

A `;` in first position inside of parentheses can be used to construct a named tuple. The same `(; ...)` syntax on the left side of an assignment allows for property destructuring.

In the standard REPL, typing `;` on an empty line will switch to shell mode.

# Examples

```jldoctest
julia> function foo()
           x = "Hello, "; x *= "World!"
           return x
       end
foo (generic function with 1 method)

julia> bar() = (x = "Hello, Mars!"; return x)
bar (generic function with 1 method)

julia> foo();

julia> bar()
"Hello, Mars!"

julia> function plot(x, y; style="solid", width=1, color="black")
           ###
       end

julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> [1; 3;; 2; 4;;; 10*A]
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  2
 3  4

[:, :, 2] =
 10  20
 30  40

julia> [2; 3;;;]
2×1×1 Array{Int64, 3}:
[:, :, 1] =
 2
 3

julia> nt = (; x=1) # without the ; or a trailing comma this would assign to x
(x = 1,)

julia> key = :a; c = 3;

julia> nt2 = (; key => 1, b=2, c, nt.x)
(a = 1, b = 2, c = 3, x = 1)

julia> (; b, x) = nt2; # set variables b and x using property destructuring

julia> b, x
(2, 1)

julia> ; # upon typing ;, the prompt changes (in place) to: shell>
shell> echo hello
hello
```
