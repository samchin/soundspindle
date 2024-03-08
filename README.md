## Running locally

In this directory, type `python3 -m http.server`
Navigate to `http://localhost:8000/?block=0&pid=1111&sound=1`, you must include the arguments otherwise it will error. 

In this example, you're choosing `pid` = `1111`, `block` = `0`, `sound` = `1`.

`pid` can be any integer. 

The options for `block` are:
- `0` - training block
- `1` - first block 
- `2` - second block 

The options for `sound` are: 
- `1` - sound appears first
- `2` - sound appears second

The images and sounds were generated from a [custom fork](https://github.com/samchin/visbrain) of [`visbrain`](https://github.com/EtienneCmb/visbrain). 



