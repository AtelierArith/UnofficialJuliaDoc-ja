```julia
Slice(indices)
```

Represent an AbstractUnitRange of indices as a vector of the indices themselves, with special handling to signal they represent a complete slice of a dimension (:).

Upon calling `to_indices`, Colons are converted to Slice objects to represent the indices over which the Colon spans. Slice objects are themselves unit ranges with the same indices as those they wrap. This means that indexing into Slice objects with an integer always returns that exact integer, and they iterate over all the wrapped indices, even supporting offset indices.
