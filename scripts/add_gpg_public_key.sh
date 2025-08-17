#!/bin/bash

# Required environment variables:
#   GPG_PUBLIC_KEY_BINARY_BASE64 - the binary (not armored) and base64-encoded export of the gpg pulic key 

# constants
EXPECTED_SHA256_BINARY_BASE64='c56a7fc499669c37391f61b72c796a60fc5bb01ee88bf5da25547684c1a438a3  ./public_key_binary_base64encoded.gpg'

# echo environment var into file(s)
echo $GPG_PUBLIC_KEY_BINARY_BASE64 > ./public_key_binary_base64encoded.gpg

# calculate sha256 hash of file(s)
calculated_sha256_binary_base64=$(shasum -a 256 ./public_key_binary_base64encoded.gpg)

# output
echo
echo "checksum of the base64-encoded binary gpg public key:"
echo "expected sha256 checksum:    $EXPECTED_SHA256_BINARY_BASE64"
echo "calculated sha256 checksum:  $calculated_sha256_binary_base64"
