#!/usr/bin/env nix-shell
#!nix-shell -i bash -p busybox

DIR=$(nix-build --attr public --no-out-link)

echo "You can now visit http://127.0.0.1:9000/."
httpd -f -p 9000 -h $DIR
