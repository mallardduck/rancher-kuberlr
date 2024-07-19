# rancher-kuberlr
A basic container image of the `kuberlr` binary.

## Branches, Releases, and Rancher & Kuberlr

TODO

### Compatability

Each "kuberlr base image" will be essentially universally compatible like `kuberlr` is.

### Development
When a new `kuberlr` releases our automation will add the tag to the versions file via PR.
Then upon merge another workflow will build and release new base images tagged matching that new version.
After which, the `rancher-kuberlr-kubectl` images will need a PR to update those to use the new `rancher-kuberlr`.
And once ready to release new RCs can be created which will ship the new `kuberlr`.