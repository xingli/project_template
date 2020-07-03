# Template for project folders

**Before go through the README, click the green button of "clone or download" on the top-right, and download a copy to the local.**

I usually use the structure here to organize all my files in one research projects. The sub-folders include:

- doc: project document, recording everything that has been done till now
- data: place to put raw data
- code: stata/python/R code
- literature: related literature
- draft: all versions of drafts
- slide: all versions of slides

Here are the details for each sub-folders.

## ./doc: project document

1. Write everything in Markdown. Markdown is a mark-up language designed by Daring Fireball. The very first documentation is [here](https://daringfireball.net/projects/markdown/). 

2. You can easily create a markdown file (.md) using any text editor. There are some better-designed interface, say, [obsidian](https://obsidian.md).

3. If you use any markdown editor, you can easily convert the .md script into html or pdf. If you want to pile up all documentation in ONE script (say, adsDoc.html), you may use command-line tool [markdown_py](https://python-markdown.github.io/cli/). After installing the module in python, you can run the following command in terminal (only in mac, or unix-like environment. Not sure about PC)

    ```
    cat head.md.aux d*.md | markdown_py -x markdown.extensions.toc > alldoc.html
    ```

4. Naming the file: start with the same prefix, say, d01_xxx, d02_xxx, and you may want to add your name at the end, say, d01_startupXL.md. And put all "md" files directly under "./doc".

5. As the style inside md, try report math equations, regression tables, and figures, in a nice way. See adsDoc.html, and existing md files as examples.

    a. Use relative path instead of absolute path to insert images. The difference between two can be found [here](https://web.stanford.edu/class/archive/cs/cs107/cs107.1202/resources/paths) and [here](https://baike.baidu.com/item/相对路径) in Chinese.

## ./literature: literature

Naming: AuthorYearJournal_shortsummary.pdf, see examples

## ./code, and ./draft

1. Use differnet prefix, say, a01_, a02_, for stata file, p01_, p02_, for python file

2. Add name at the suffix, say, a01_startXL.do

3. In the draft folder, name the draft using ProjectDateEditor.txt, say, adsdraft191112XL.docx.







