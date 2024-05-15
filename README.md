# rancher-kuberlr
A simple way to invoke the correct [kubectl](https://github.com/rancher/kubectl) version on a Rancher managed cluster using [kuberlr](https://github.com/flavio/kuberlr).

## Artifacts of this repo
This repo produces:
- The base generic kuberlr images `mallardduck/rancher-kuberlr:base-{version}` (matching [kuberlr](https://github.com/flavio/kuberlr) versions 1:1),
  - This is simply a container with `kuberlr` binary in it.
- Rancher specific kuberlr `mallardduck/rancher-kuberlr:{version}`.
  - This container uses the latest `kuberlr` and bundles each [kubectl](https://github.com/rancher/kubectl) supported by the Rancher version the release supports.

## Branches, Releases, and Rancher
| branch | Release | Rancher |
|--------|---------|---------|
|main (default)|base-v0.Y.Z|n/a|
|main (to be renamed release/v2.9)|v2.Y.Z|2.9.Z|
|release/v2.8|v1.Y.Z|2.8.Z|

### Notes:
- The workflows for the base images of kuberlr have to live in the `default branch`(currently main).
- It could go live upstream in the kuberlr repo - but this is easy enough to do.
- Each minor Rancher release will get a kubler image tag major to match it.
  - This gives us full "Y" and "Z" control on versioning the component to target Rancher minors.
  - E.x. Rancher 2.8.x releases will get varying versions of 1.Y.Z
