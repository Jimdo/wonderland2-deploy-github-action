# wonderland2-deploy-github-action

# This action is deprecated and will be unmantained soon. Please migrate to [wonderland2-setup-action](https://github.com/Jimdo/wonderland2-setup-action)

A GitHub action to deploy or delete services to Wonderland2.
Pinned to a known working realease of WL2 CLI, which might not be the latest. See [cli_version parameter](#cli_version).

*For infos how to release a new version have a look at [How to
release][htr]*

[htr]: #how-to-release

## How to use it

1. Provide a valid Wonderland 2 manifest
2. Add a `WONDERLAND_GITHUB_TOKEN` and `BASTION_KEY` to your repository secrets
3. Add this step to your deployment job

```yaml
- name: Deploy to Wonderland 2
  uses: Jimdo/wonderland2-deploy-github-action@v0.3.0
  with:
    token: ${{ secrets.WONDERLAND_CI_GITHUB_TOKEN }}
    bastion_key: ${{ secrets.WONDERLAND_CI_SSH_KEY }}
    wonderland_manifest: wonderland2.yaml
    environment: stage
    timeout: 45s
```

## Inputs

### timeout

Maximum time to wait for the deployment to become available (default: **5m**)

### wonderland_manifest

The Wonderland 2 manifest file (default: **wonderland2.yaml**)

### environment

The Wonderland 2 environment in which the service should be deployed.
Currently `stage` or `prod`.

### bastion_key

**required** Ssh key for authentication in the bastion host (`secrets.BASTION_KEY`)

### token

**required** A GitHub token to use with wonderland (`secrets.WONDERLAND_GITHUB_TOKEN`)

### delete

set this to `"true"` if you intend to delete the service instead of deploying it

### cli_version

By default the action will use a known working release of WL2 CLI.
This parameter allows switching to a custom version. Use with caution.

## How to release

- Choose a new version number
- Consider updating the default WL2 CLI version
- Update README example with new version number
- Go to [draft a new release][dnr]
- Create the new version number
- Put the version number in the title
- Press `Auto-generate release notes`
- Press `Publish release`
- Done

[dnr]: https://github.com/Jimdo/wonderland2-deploy-github-action/releases/new
