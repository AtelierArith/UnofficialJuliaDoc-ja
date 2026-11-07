```julia
print_matrix(io::IO, mat, pre, sep, post, hdots, vdots, ddots, hmod, vmod)
```

Prints a matrix with limited output size. If `io` sets `:limit` to true, then only the corners of the matrix are printed, separated with vertical, horizontal, and diagonal ellipses as appropriate. Optional arguments are string pre (printed before the matrix, e.g. an opening bracket) which will cause a corresponding same-size indent on following rows, and string post (printed at the end of the last row of the matrix). Also options to use different ellipsis characters hdots, vdots, ddots. These are repeated every hmod or vmod elements.
