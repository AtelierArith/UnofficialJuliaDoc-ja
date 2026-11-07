```julia
bcf = flatten(bc)
```

Create a "flat" representation of a lazy-broadcast operation. From    f.(a, g.(b, c), d) we produce the equivalent of    h.(a, b, c, d) where    h(w, x, y, z) = f(w, g(x, y), z) In terms of its internal representation,    Broadcasted(f, a, Broadcasted(g, b, c), d) becomes    Broadcasted(h, a, b, c, d)

This is an optional operation that may make custom implementation of broadcasting easier in some cases.
