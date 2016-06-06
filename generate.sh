#!/usr/bin/bash
#generate site from markdown

outdir=output
curdir=$(pwd)

if [[ -z $outdir ]]; then
  exit
fi

rm -r $outdir/*

markdown index.md > ${outdir}/index.html
ln -s ${curdir}/css    ${outdir}/css
ln -s ${curdir}/images ${outdir}/images

postsdir=${outdir}/posts
mkdir ${postsdir}

for i in posts/*; do
  file=$(basename "$i")
  markdown "$i" > "${postsdir}/${file%%.*}.html"
done
