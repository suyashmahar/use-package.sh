# sources.list format documentation
## Fields
```
<t> <address>
```
Field description:
`<t>`: Time of retrival, seconds since epoch  
`<address>`: Address of the source (network or local)  

## Address format
```
<type>:<address>
```

Field description:  
`<type>`: `network`, `local` and `git`
`<address>`: `url` for network and `file system path` for local
