```
StatStruct
```

A struct which stores the information from `stat`. The following fields of this struct is considered public API:

| Name    | Type                            | Description                                                        |
|:------- |:------------------------------- |:------------------------------------------------------------------ |
| desc    | `Union{String, Base.OS_HANDLE}` | The path or OS file descriptor                                     |
| size    | `Int64`                         | The size (in bytes) of the file                                    |
| device  | `UInt`                          | ID of the device that contains the file                            |
| inode   | `UInt`                          | The inode number of the file                                       |
| mode    | `UInt`                          | The protection mode of the file                                    |
| nlink   | `Int`                           | The number of hard links to the file                               |
| uid     | `UInt`                          | The user id of the owner of the file                               |
| gid     | `UInt`                          | The group id of the file owner                                     |
| rdev    | `UInt`                          | If this file refers to a device, the ID of the device it refers to |
| blksize | `Int64`                         | The file-system preferred block size for the file                  |
| blocks  | `Int64`                         | The number of 512-byte blocks allocated                            |
| mtime   | `Float64`                       | Unix timestamp of when the file was last modified                  |
| ctime   | `Float64`                       | Unix timestamp of when the file's metadata was changed             |

See also: [`stat`](@ref)
