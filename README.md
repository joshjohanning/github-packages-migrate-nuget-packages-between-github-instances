# github-packages-migrate-nuget-packages
Migrate NuGet packages from one GitHub instance to another

This should be able to migrate packages from GitHub Enterprise Server to GitHub.com using the `<source-host>` parameter. If GitHub.com to GitHub.com, set `<source-host>` to `github.com`.
## Usage

```bash
./migrate-nuget-packages-between-orgs.sh \
  <source-org> 
  <source-host> \
  <target-org> \
  <target-pat> \
  <path-to-gpr>
```

## Example

```bash
./migrate-nuget-packages-between-orgs.sh \
  joshjohanning-org-packages \
  github.com \
  joshjohanning-org-packages-migrated \
  ghp_xyz \
  /home/codespace/.dotnet/tools/gpr
```

## Notes

- Uses [jcansdale/gpr](https://github.com/jcansdale/gpr) to do the nuget push
- Had to delete `_rels/.rels` and `\[Content_Types\].xml` because there was somehow two copies of each file in the package and it causes `gpr` to fail when extracting/zipping the package to re-push
- Run this to clean up your working dir: rm *.nupkg *.zip

<details>

<summary>Example output</summary>

    ...
    packages-repo1 --> NUnit3.DotNetNew.Template
    1.7.0
    https://github-registry-files.githubusercontent.com/...
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo1. Version: 1.7.0. Size: 20847 bytes. 
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Uploading package.
    [NUnit3.DotNetNew.Template.1.7.0.nupkg]: Successfully registered nuget package: NUnit3.DotNetNew.Template (1.7.0)

    1.7.2
    https://github-registry-files.githubusercontent.com/...=filename%3DNUnit3.DotNetNew.Template.1.7.2.nupkg&response-content-type=application%2Foctet-stream
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [NUnit3.DotNetNew.Template.1.7.2.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo1. Version: 1.7.2. Size: 21247 bytes. 
    [NUnit3.DotNetNew.Template.1.7.2.nupkg]: Uploading package.
    [NUnit3.DotNetNew.Template.1.7.2.nupkg]: Successfully registered nuget package: NUnit3.DotNetNew.Template (1.7.2)

    1.7.1
    https://github-registry-files.githubusercontent.com/569437697/...=filename%3DNUnit3.DotNetNew.Template.1.7.1.nupkg&response-content-type=application%2Foctet-stream
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
    https://github-registry-files.githubusercontent.com/569437813/...=filename%3DNewtonsoft.Json.11.0.2.nupkg&response-content-type=application%2Foctet-stream
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [Newtonsoft.Json.11.0.2.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo2. Version: 11.0.2. Size: 2407521 bytes. 
    [Newtonsoft.Json.11.0.2.nupkg]: Uploading package.
    [Newtonsoft.Json.11.0.2.nupkg]: Successfully registered nuget package: Newtonsoft.Json (11.0.2)

    11.0.1
    https://github-registry-files.githubusercontent.com/569437813/...=filename%3DNewtonsoft.Json.11.0.1.nupkg&response-content-type=application%2Foctet-stream
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    deleting: _rels/.rels
    deleting: [Content_Types].xml
    Found 1 package.
    [Newtonsoft.Json.11.0.1.nupkg]: Repository url: https://github.com/joshjohanning-org-packages-migrated/packages-repo2. Version: 11.0.1. Size: 2410114 bytes. 
    [Newtonsoft.Json.11.0.1.nupkg]: Uploading package.
    [Newtonsoft.Json.11.0.1.nupkg]: Successfully registered nuget package: Newtonsoft.Json (11.0.1)

    ...
    Run this to clean up your working dir: rm *.nupkg *.zip
</details>
