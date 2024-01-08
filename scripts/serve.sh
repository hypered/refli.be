#!/usr/bin/env nix-shell
#!nix-shell -i bash -p busybox

DIR=$(nix-build --attr public --no-out-link)

echo "Now serving ${DIR}..."
echo "You can now visit http://127.0.0.1:9000/fr/"
echo "or http://127.0.0.1:9000/changelog.html."
httpd -f -p 9000 -h $DIR
