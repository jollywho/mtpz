#!/usr/bin/bash
#generate site from markdown

outdir=output
curdir=$(pwd)

if [[ -z $outdir ]]; then
  exit
fi

rm -rf ${outdir}
mkdir ${outdir}

markdown index.md > ${outdir}/index.html

cd ${outdir}
ln -s ../css    css
ln -s ../images images

postsdir=posts
mkdir ${postsdir}

for i in ${curdir}/posts/*; do
  file=$(basename "$i")
  markdown "$i" > "${postsdir}/${file%%.*}.html"
done
