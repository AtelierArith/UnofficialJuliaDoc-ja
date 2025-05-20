generic_syconv(F, gettri::Bool=true) -> (TLU<:Union{AbstractMatrix,Nothing}, e<:AbstractVector,     d<:Union{AbstractVector,Nothing})

`generic_syconv` takes the Bunch-Kaufman object `F` and returns the block-diagonal factor `D`, and the triangular factor `L` (or `U`) if requested. If the `L` or `U` factor is requested then both `L` (or `U`) and the main diagonal of `D` will be stored in `TLU`, following LAPACK format, and `d` will be set to `nothing`. `e` contains the first subdiagonal of `D`. If the triangular factor is not requested, then `TLU` will not be set to `nothing`, and the main diagonal of `D` will be stored in `d`.

`gettri` is a `Bool`, indicating whether the `L` (or `U`) triangular factor should be computed (`gettri==true`) or not (`gettri==false`). If the triangular factor is required, a copy of `A.LD` will be created, and the triangular factor will be computed in-place in said copy.
