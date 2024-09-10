#!/usr/bin/env bash

# pandoc -f gfm+smart+fancy_lists+subscript+superscript -t docx -o test.docx Testing/test.md

# Enable recursive **/*
shopt -s globstar

orig=$PWD

for dir in **/
do
    echo "- $dir"
    cd $dir
    # if [ $(ls -A 2>/dev/null) ]; then
    #     echo "    EMPTY!"
    # fi
    cp $orig/reference.docx ./~normal.docx
    cp $orig/reference-mla.docx ./~mla.docx
    cp $orig/reference-modern.docx ./~modern.docx
    for file in *.md
    do
        if [ "$file" == "*.md" ]; then
            break
        fi
        # type=${${file#*.}%.md}
        suffix=${file#*.}
        type=${suffix%.md}
        echo "   $file - $type"

        if [ "$type" == "mla" ]; then
            cp ./~mla.docx ./~reference.docx
        elif [ "$type" == "modern" ]; then
            cp ./~modern.docx ./~reference.docx
        else
            cp ./~normal.docx ./~reference.docx
        fi

        base=${file%%.*}
        pandoc -f gfm+smart+fancy_lists+subscript+superscript -t docx --reference-doc=~reference.docx -o "${file%.md}.docx" "$file"

        rm ./~reference.docx
    done

    rm ./~normal.docx
    rm ./~mla.docx
    rm ./~modern.docx

    cd $orig
done
