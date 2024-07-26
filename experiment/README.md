## Running locally

In this directory, type `python3 -m http.server`

In a browser, navigate to `http://localhost:8000/?block=0&pid=1111&sound=1` you must include the arguments otherwise it will error. In this example, you're choosing `pid` = `1111`, `block` = `0`, `sound` = `1`.

`pid` can be any integer. 

The options for `block` are:
- `0` - training block
- `1` - first block 
- `2` - second block 

The options for `sound` are: 
- `1` - sound appears first
- `2` - sound appears second

The images and sounds were generated from a [custom fork](https://github.com/samchin/visbrain) of [`visbrain`](https://github.com/EtienneCmb/visbrain) and appear in the `/data` folder.

## Deploying to github
This assumes you have already set up a [repo for hosting](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site). 

Enable github pages: Settings > Actions (under "Code and Automation") and direct it to the `/root` folder as depicted below.

Then navigate to `https://<your-username>.github.io/SoundspindleExperiment/?block=0&pid=1111&sound=1` where it should be hosted. Similar to locally, you must include the arguments otherwise it will error. In this example, you're choosing `pid` = `1111`, `block` = `0`, `sound` = `1`.

<img width="677" alt="image" src="https://github.com/nathanww/SoundspindleExperiment/assets/10756682/39185965-4b44-416e-b670-26985c5e36b6">



