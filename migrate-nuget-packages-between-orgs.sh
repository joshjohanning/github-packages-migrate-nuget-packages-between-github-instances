#!/bin/bash

# Usage: ./migrate-nuget-packages-between-orgs.sh <source-org> <source-host> <target-org> <target-pat> <path-to-gpr>
#
#
# Prereqs:
# 1. gh cli installed and logged in (`gh auth login`)
# 2. Auth to read packages with gh, ie: `gh auth refresh -h github.com -s read:packages`
# 3. `<source-pat>` must have `read:packages` scope
# 4. gpr installed: `dotnet tool install gpr -g` (https://github.com/jcansdale/gpr)
# 5. Can use this to find GPR path for `<path-to-gpr>`: `find / -wholename "*tools/gpr" 2> /dev/null`
# 6. `<target-pat>` must have `write:packages` scope
# 7. This assumes that the target org's repo name is the same as the source.
# 
# Passing `gpr` as a parameter explicitly because sometimes `gpr` is aliased to `git pull --rebase` and that's not what we want here
#

if [ -z "$6" ]; then
    echo "Usage: $0 <source-org> <source-host> <souce-pat> <target-org> <target-pat> <path-to-gpr>"
    exit 1
fi

echo "..."

SOURCE_ORG=$1
SOURCE_HOST=$2
SOURCE_PAT=$3
TARGET_ORG=$4
TARGET_PAT=$5 
GPR_PATH=$6

# check if GPR_PATH is valid
if [ ! -f "$GPR_PATH" ]; then
    echo "Error: $GPR_PATH does not exist"
    echo "Install gpr with: dotnet tool install gpr -g"
    exit 1
fi

packages=$(GH_HOST="$SOURCE_HOST" gh api "/orgs/$SOURCE_ORG/packages?package_type=nuget" -q '.[] | .name + " " + .repository.name')

echo "$packages" | while IFS= read -r response; do

  packageName=$(echo "$response" | cut -d ' ' -f 1)
  repoName=$(echo "$response" | cut -d ' ' -f 2)

  echo "$repoName --> $packageName"
  
  versions=$(GH_HOST="$SOURCE_HOST" gh api "/orgs/$SOURCE_ORG/packages/nuget/$packageName/versions" -q '.[] | .name')
  for version in $versions
  do
    echo "$version"
    url="https://nuget.pkg.$SOURCE_HOST/$SOURCE_ORG/download/$packageName/$version/$packageName.$version.nupkg"
    echo $url
    curl -Ls -H "Authorization: token $SOURCE_PAT" $url --output "${packageName}_${version}.nupkg" -s

    # must do this otherwise there is errors (multiple of each file)
    zip -d "${packageName}_${version}.nupkg" "_rels/.rels" "\[Content_Types\].xml" # there seemed to be duplicate of these files in the nupkg that led to errors in gpr
    eval $GPR_PATH push ./"${packageName}_${version}.nupkg" --repository https://github.com/$TARGET_ORG/$repoName -k $TARGET_PAT
  done

  echo "..."

done

echo "Run this to clean up your working dir: rm ./*.nupkg ./*.zip"
