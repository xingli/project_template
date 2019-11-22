# Template for project folders

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

2. You can easily create a markdown file (.md) using any text editor. There are some better-designed interface, say, [macdown](https://macdown.uranusjr.com) for mac. I have no recommendation for PC, but you may check online review, say, [here](https://www.sitepoint.com/best-markdown-editors-windows/)

3. If you use any markdown editor, you can easily convert the .md script into html or pdf. If you want to pile up all documentation in ONE script, you may use command-line tool [markdown_py](https://python-markdown.github.io/cli/). After installing the module in python, you can run the following command in terminal (only in mac, or unix-like environment. Not sure about PC)
    cat head.md.aux d*.md | markdown_py -x markdown.extensions.toc > alldoc.html
    



