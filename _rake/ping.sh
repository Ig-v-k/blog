#!/bin/bash
set -e
set -x

links=$1
report=$2

function ping_uri {
  curl --location \
    --silent \
    --output /dev/null \
    --max-time 15 \
    --fail \
    -H 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36' \
    -H 'Accept: text/html,*/*' \
    -H 'Accept-Encoding: gzip, deflate' \
    -H 'Cache-Control: max-age=0' \
    --retry 4 \
    --write-out '%{http_code} %{url_effective}\n' $1
}
export -f ping_uri

cmd="ping_uri \"\$0\" >> \"${report}\"; echo \"\$0\";"
cat "${links}" | xargs -P 10 -n 1 /bin/bash -c "${cmd}"
