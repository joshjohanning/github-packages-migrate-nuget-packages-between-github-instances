#!/bin/bash

# Usage: ./migrate-nuget-packages-between-orgs.sh <source-org> <source-host> <target-org> <target-pat> <path-to-gpr>
#
#
# Prereqs:
# 1. gh cli installed and logged in
# 2. Auth to read packages with gh, ie: `gh auth refresh -h github.com -s read:packages`
# 2. gpr: `dotnet tool install gpr -g`
# 3. Can use this to find GPR path: `find / -wholename "*tools/gpr" 2> /dev/null`
# 4. `<target-pat>` must have `write:packages` scope
# 
# Passing `gpr` explicitly because sometimes `gpr` is aliased to `git pull --rebase` and that's not what we want here
#

if [ -z "$5" ]; then
    echo "Usage: $0 <source-org> <source-host> <target-org> <target-pat> <path-to-gpr>"
    exit 1
fi

echo "..."

SOURCE_ORG=$1
SOURCE_HOST=$2
TARGET_ORG=$3
TARGET_PAT=$4 
GPR_PATH=$5

packages=$(GH_HOST="$SOURCE_HOST" gh api "/orgs/$SOURCE_ORG/packages?package_type=nuget" -q '.[] | .name + " " + .repository.name') 

echo "$packages" | while IFS= read -r response; do

  packageName=$(echo "$response" | cut -d ' ' -f 1)
  repoName=$(echo "$response" | cut -d ' ' -f 2)

  echo "$repoName --> $packageName"
  
  versions=$(GH_HOST="$SOURCE_HOST" gh api "/orgs/$SOURCE_ORG/packages/nuget/$packageName/versions" -q '.[] | .name')
  for version in $versions
  do
    echo "$version"
    url=$(GH_HOST="$SOURCE_HOST" gh api graphql -f owner="$SOURCE_ORG" -f repo="$repoName" -f packageName="$packageName" -f packageVersion="$version" -f query='
    query ($owner: String!, $repo: String!, $packageName: [String!], $packageVersion: String!) {
      repository(owner: $owner, name: $repo) {
        packages(first: 100, packageType: NUGET, names: $packageName) {
          edges {
            node {
              id
              name
              packageType
              version(version: $packageVersion) {
                id
                version
                files(first: 10) {
                  nodes {
                    name
                    updatedAt
                    size
                    url
                  }
                }
              }
            }
          }
        }
      }
    }' -q '.data.repository.packages.edges[].node.version.files.nodes[].url')

    echo $url

    curl $url --output "${packageName}_${version}.nupkg" -s
    # must do this otherwise there is errors (multiple of each file)
    zip -d "${packageName}_${version}.nupkg" "_rels/.rels" "\[Content_Types\].xml" # there seemed to be duplicate of these files in the nupkg that led to errors in gpr
    eval $GPR_PATH push ./"${packageName}_${version}.nupkg" --repository https://github.com/$TARGET_ORG/$repoName -k $TARGET_PAT
  done

  echo "..."

done

echo "Run this to clean up your working dir: rm *.nupkg *.zip"
