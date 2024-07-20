#!/bin/bash
GITHUB_API_URL="https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest"
version_info=$(curl --silent -H "Authorization: Bearer ${GITHUB_TOKEN}" "${GITHUB_API_URL}")
version=$(echo "$version_info" | jq '.tag_name' -r)
download_file_url=$(echo "$version_info" | jq '.assets.[0].browser_download_url' -r)
currentversion=$(cat currentversion)
echo "$version_info" | jq '.assets | .[0]' -r
echo "currentversion:$currentversion version:$version download_file_url:$download_file_url"
echo "$version" >currentversion
if [[ "$currentversion" == "$version" ]]; then
    exit
fi
sed -i 's/^ARG GHIDRA_RELEASE_URL.*$/ARG GHIDRA_RELEASE_URL='"$download_file_url"'/i' Dockerfile
sed -i 's/^ARG GHIDRA_VERSION.*$/ARG GHIDRA_VERSION='"$version"'/i' Dockerfile

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git add currentversion
git commit -a -m "Auto Update to Ghidra $version"
git tag -f "$version"
git push
git push origin --tags -f
