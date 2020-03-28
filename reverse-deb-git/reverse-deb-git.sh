#!/bin/bash

# echo "Reverse dependencies of $@" >&2
pkgs="$@"
# this skips " |pkg" lines:
for pkg in $(apt-cache rdepends $@ | sed -n 's/^  //gp'); do
    if info=$(debcheckout -p $pkg); then
        split=($info)
        # git https://salsa.debian.org/haskell-team/DHG_packages.git [p/haskell-hxt-curl]
        # git https://anonscm.debian.org/git/collab-maint/xmlrpc-c.git -b debian/unstable
        if [ "${split[0]}" == 'git' ]; then
            repo="${split[1]}"
            # echo Checking HEAD of "$pkg" "$repo" >&2
            if commit=$(git ls-remote "$repo" HEAD); then
                commit=$(echo "$commit" | sed -E -n 's/^([0-9a-f]{40})\t.*/\1/gp')
                echo "$pkg $repo $commit"
            fi
        fi
        
        # I was getting connection timeouts from salsa.debian.org
        # A delay might help
        sleep 10
    fi
done | jq --raw-input 'split(" ") | {
    "repo_url": .[1],
    "commit_hash": .[2],
    "input_type": "GitRepoCommit"
}' | jq -s '{
    "name": "Debian packages that depend on: '"$pkgs"'",
    "version": "0.0.1",
    "description": "Git development repositories for Debian packages that depend on: '"$pkgs"'",
    "inputs": . | unique
}'
