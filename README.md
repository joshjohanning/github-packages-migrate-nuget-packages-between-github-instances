# Migrate NuGet Packages Between GitHub Instances

Migrate NuGet packages from one GitHub instance to another

This should be able to migrate packages from GitHub Enterprise Server to GitHub.com using the `<source-host>` parameter. If GitHub.com to GitHub.com, set `<source-host>` to `github.com`.

## Prerequisites

1. [gh cli](https://cli.github.com) installed
2. Set the source GitHub PAT env var: `export GH_SOURCE_PAT=ghp_abc` (must have at least `read:packages`, `read:org` scope)
3. Set the target GitHub PAT env var: `export GH_TARGET_PAT=ghp_xyz` (must have at least `write:packages`, `read:org` scope)

Notes:

- This script installs [gpr](https://github.com/jcansdale/gpr) locally to the `./temp/tools` directory
- This script assumes that the target org's repo name is the same as the source (the target repo doesn't _need_ to exist, the package just won't be mapped to a repo)

## Usage

```bash
./migrate-nuget-packages-between-orgs.sh \
  <source-org> \
  <source-host> \
  <target-org>
```

## Example

```bash
./migrate-nuget-packages-between-orgs.sh \
  joshjohanning-org-packages \
  github.com \
  joshjohanning-org-packages-migrated
```

<details>

<summary>Example output</summary>

    ...
    packages-repo1 --> NUnit3.DotNetNew.Template
    1.7.0
    https://nuget.pkg.github.com/joshjohanning-org-packages/download/NUnit3.DotNetNew.Template/1.7.0/NUnit3.DotNetNew.Template.1.7.0.nupkg
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo1. Version: 1.7.0. Size: 20847 bytes. 
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Uploading package.
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Successfully registered nuget package: NUnit3.DotNetNew.Template (1.7.0)

    1.7.2
    https://nuget.pkg.github.com/joshjohanning-org-packages/download/NUnit3.DotNetNew.Template/1.7.2/NUnit3.DotNetNew.Template.1.7.2.nupkg
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [NUnit3.DotNetNew.Template.1.7.2.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo1. Version: 1.7.2. Size: 21247 bytes. 
    [NUnit3.DotNetNew.Template.1.7.2.nupkg]: Uploading package.
    [NUnit3.DotNetNew.Template.1.7.2.nupkg]: Successfully registered nuget package: NUnit3.DotNetNew.Template (1.7.2)

    1.7.1
    https://nuget.pkg.github.com/joshjohanning-org-packages/download/NUnit3.DotNetNew.Template/1.7.1/NUnit3.DotNetNew.Template.1.7.1.nupkg
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [NUnit3.DotNetNew.Template.1.7.1.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo1. Version: 1.7.1. Size: 20864 bytes. 
    [NUnit3.DotNetNew.Template.1.7.1.nupkg]: Uploading package.
    [NUnit3.DotNetNew.Template.1.7.1.nupkg]: Successfully registered nuget package: NUnit3.DotNetNew.Template (1.7.1)

    ...
    packages-repo2 --> Newtonsoft.Json
    11.0.2
    https://nuget.pkg.github.com/joshjohanning-org-packages/download/Newtonsoft.Json/11.0.2/Newtonsoft.Json.11.0.2.nupkg
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [Newtonsoft.Json.11.0.2.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo2. Version: 11.0.2. Size: 2407521 bytes. 
    [Newtonsoft.Json.11.0.2.nupkg]: Uploading package.
    [Newtonsoft.Json.11.0.2.nupkg]: Successfully registered nuget package: Newtonsoft.Json (11.0.2)

    11.0.1
    https://nuget.pkg.github.com/joshjohanning-org-packages/download/Newtonsoft.Json/11.0.1/Newtonsoft.Json.11.0.1.nupkg
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [Newtonsoft.Json.11.0.1.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo2. Version: 11.0.1. Size: 2410114 bytes. 
    [Newtonsoft.Json.11.0.1.nupkg]: Uploading package.
    [Newtonsoft.Json.11.0.1.nupkg]: Successfully registered nuget package: Newtonsoft.Json (11.0.1)

    ...
    Run this to clean up your working dir: rm ./*.nupkg ./*.zip
</details>

## Notes

- Uses [jcansdale/gpr](https://github.com/jcansdale/gpr) to do the nuget push
- Had to delete `_rels/.rels` and `[Content_Types].xml` because there was somehow two copies of each file in the package and it causes `gpr` to fail when extracting/zipping the package to re-push
- Run this to clean up your working directory: `rm -rf ./temp`
