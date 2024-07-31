# rancher-kuberlr
A basic container image of the `kuberlr` binary.

Images found at: https://hub.docker.com/r/mallardduck/rancher-kuberlr

## Branches, Releases, and Rancher & Kuberlr

TODO

### Compatability

Each "kuberlr base image" will be essentially universally compatible like `kuberlr` is.

### Development
When a new `kuberlr` releases our automation will add the tag to the versions file via PR.
Then upon merge another workflow will build and release new base images tagged matching that new version.
After which, the `rancher-kuberlr-kubectl` images will need a PR to update those to use the new `rancher-kuberlr`.
And once ready to release new RCs can be created which will ship the new `kuberlr`.

# Upon move to `rancher/` do
1. Request EIO create:
   1. GitHub repo,
   2. Docker Hub repo,
   3. Secrets for the GitHub to push to dockerhub
2. Find and replace `mallardduck/rancher-kuberlr` to `rancher/kuberlr`,
3. Find and replace `rancher-kuberlr` to `rancher/kuberlr`,
4. Update workflows to use EIO provided secrets
5. Add renovate (maybe it'll help catch docker tags used to build)
6. Review CIs and ensure all images and releases are published,