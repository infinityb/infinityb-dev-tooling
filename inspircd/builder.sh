#!/bin/bash
set -e
unset PATH
unset PKG_CONFIG_PATH

for p in $buildInputs; do
  if [ -d "$p/bin" ]
  then
    PATH="${p}/bin${PATH:+:}${PATH}"
  fi
  if [ -d "${p}/lib/pkgconfig" ]
  then
    PKG_CONFIG_PATH="${p}/lib/pkgconfig${PKG_CONFIG_PATH:+:}${PKG_CONFIG_PATH}"
  fi
done

export PATH
export PKG_CONFIG_PATH

if ! pkg-config --exists openssl
then
  echo "no openssl!"
  exit 1
fi

echo "${buildInputs}"
echo "PATH=${PATH}"
echo "PKG_CONFIG_PATH=${PKG_CONFIG_PATH}"

set -x 
# which mkdir
# which pkg-config
# strace -f -s $(( 2 ** 16 )) pkg-config openssl

mkdir -p /usr/bin
ln -s $(which env) /usr/bin/env
ls -l /usr/bin/env
set +x 

tar -xf $src

for d in *; do
  if [ -d "$d" ]; then
    cd "$d"
    break
  fi
done

# strace -f -s $(( 2 ** 16 )) \
./configure --enable-extras=m_ssl_openssl
./configure --disable-auto-extras --disable-interactive --prefix=$out
make -j4
make install
