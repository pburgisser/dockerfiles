#!/bin/bash

#REPO_URL="${REPO_URL:-r.j3ss.co}"
REPO_URL=""
SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
ERRORS="$(pwd)/errors"

build_and_push(){
  base=$1
  suite=$2
  build_dir=$3

  echo "Building ${REPO_URL}/${base}:${suite} for context ${build_dir}"
  docker build --rm --force-rm -t "${base}:${suite}" "${build_dir}" || return 1
  # on successful build, push the image
  echo "                       ---                                   "
  echo "Successfully built ${base}:${suite} with context ${build_dir}"
  echo "                       ---                                   "
}

dofile() {
	f=$1
	image=${f%Dockerfile}
	base=${image%%\/*}
	build_dir=$(dirname "$f")
	suite=${build_dir##*\/}

	if [[ -z "$suite" ]] || [[ "$suite" == "$base" ]]; then
		suite=latest
	fi

	{

		build_and_push "${base}" "${suite}" "${build_dir}"
	} || {
	# add to errors
	echo "${base}:${suite}" >> "$ERRORS"
}
echo
echo
}

main(){
  files=$(find -L . -iname '*Dockerfile' | sed 's|./||' | sort)
  for file in $files;do
    dofile ${file}
  done
}

main
