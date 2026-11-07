```julia
info::ConstCallInfo <: CallInfo
```

The precision of this call was improved using constant information. In addition to the original call information `info.call`, this info also keeps the results of constant inference `info.results::Vector{Union{Nothing,ConstResult}}`.
