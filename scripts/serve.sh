#!/usr/bin/env nix-shell
#!nix-shell -i bash -p busybox

nix-build --attr html.all-with-static site/

echo "You can now visit http://127.0.0.1:9000/."
httpd -f -p 9000 -h result
