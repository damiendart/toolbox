# See "$TOOLBOX_ROOT/bin/export-images" for more information.
#
# Copyright (C) Damien Dart, <damiendart@pobox.com>.
# This file is distributed under the MIT licence. For more information,
# please refer to the accompanying "LICENCE" file.

FROM dpokidov/imagemagick:7.1.2-12-trixie

RUN <<EOT
  set -ex
  apt-get -y update
  apt-get -y upgrade
  apt-get install -y --no-install-recommends curl
EOT

RUN <<EOT
  set -ex
  TEMP="$(mktemp)"
  curl --location --output "$TEMP" "https://github.com/shssoichiro/oxipng/releases/download/v10.1.0/oxipng_10.1.0-1_amd64.deb"
  echo "62cdfec9711f18bed51de535b4f060fcca46fd1e08cfe8e5ed07a6918b076c5c $TEMP" | sha256sum -c --quiet -
  dpkg -i "$TEMP"
  rm -f "$TEMP"
EOT

RUN <<EOT
  set -ex
  TEMP="$(mktemp)"
  curl --location --output "$TEMP" "https://github.com/kornelski/cavif-rs/releases/download/v1.5.6/cavif_1.5.6-1_amd64.deb"
  echo "f4a76b0c8b525978e094f45ffbdc65a62da5aafd5d1699c5249720e9bdb558bf $TEMP" | sha256sum -c --quiet -
  dpkg -i "$TEMP"
  rm -f "$TEMP"
EOT

ENTRYPOINT []
