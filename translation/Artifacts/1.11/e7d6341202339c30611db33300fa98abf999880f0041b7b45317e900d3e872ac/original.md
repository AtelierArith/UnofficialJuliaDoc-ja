```
ARTIFACT_OVERRIDES
```

Artifact locations can be overridden by writing `Overrides.toml` files within the artifact directories of Pkg depots.  For example, in the default depot `~/.julia`, one may create a `~/.julia/artifacts/Overrides.toml` file with the following contents:

```
78f35e74ff113f02274ce60dab6e92b4546ef806 = "/path/to/replacement"
c76f8cda85f83a06d17de6c57aabf9e294eb2537 = "fb886e813a4aed4147d5979fcdf27457d20aa35d"

[d57dbccd-ca19-4d82-b9b8-9d660942965b]
c_simple = "/path/to/c_simple_dir"
libfoo = "fb886e813a4aed4147d5979fcdf27457d20aa35d""
```

This file defines four overrides; two which override specific artifacts identified through their content hashes, two which override artifacts based on their bound names within a particular package's UUID.  In both cases, there are two different targets of the override: overriding to an on-disk location through an absolute path, and overriding to another artifact by its content-hash.
