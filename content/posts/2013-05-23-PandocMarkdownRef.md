---
title: "Pandoc's Markdown Reference"
modified: 2015-02-11T10:53:31+08:00
tags: ["Markdown"]
date: 2013-05-23T01:53:31+08:00
---

<font color="red">
#### [2015-02-12]This article doesn't render properly since I switched from Google Blogger to Github Pages. I won't fix this problem.
</font>
Pandoc實現了基本的Markdown語法外, 還加了一些extention.  
細節可參考:  
[Pandoc's Markdown][pmd]  
[Markdown語法][mdsyntax]  
[Markdown:Syntax][mds]  
[Pandoc Markdown and ReST Compared][MDcmpReST]

[pmd]: http://johnmacfarlane.net/pandoc/demo/example9/pandocs-markdown.html  
[mdsyntax]: http://markdown.tw/  
[mds]: http://daringfireball.net/projects/markdown/syntax  
[MDcmpReST]: http://www.unexpected-vortices.com/doc-notes/markdown-and-rest-compared.html  

## Headers (Setext and atx)

Setext-style只有兩階也就是HTML語法裡的`h1`及`h2` tag,`-`跟`=`的個數沒有限制.  
atx-style共有6階, `h1`~`h6`.

    # This is H1.
    ## This is H2.
    ### This is H3.
    #### ...  
    ###### This is H6.  

除了階層較多之外, atx-style還可以使用Markdown syntax.  

    ###This is *H3* header.

Output: 

### This is *H3* header.

## Inline Formatting

### Basic Emphasis

斜體字: `*`, `_` , 粗體字: `**`, `__`, 

    *single asterisks*  
    _single underscores_  
    **double asterisks**  
    __double underscores__  

Output:  
*single asterisks*  
_single underscores_  
**double asterisks**  
__double underscores__  

---  

### Pandoc Inline

#### strikeout, superscript and subscript

    ~~~deleted text~~~  
    H~2~O is a liquid.  
    2^10^ is 1024.  

Output:  

~~~deleted text~~~  
H~2~O is a liquid.  
2^10^ is 1024.  

---

#### Math  

Pandoc可以使用LaTeX來表示數學式子, 可參考[Getting Started with LaTeX](http://www.maths.tcd.ie/~dwilkins/LaTeXPrimer/)  

```
$a^2 = b^2 + c^2$  
$x^{17} - 1$  
$M^\bot = \{ f \in V' : f(m) = 0 \mbox{ for all } m \in M \}.$  
$\[ \cos(\theta + \phi) = \cos \theta \cos \phi - \sin \theta \sin \phi \]$  
$\[ |y - x| < \delta \]$ then $\[ |f(y) - f(x)| < \epsilon. \]$  
\newcommand{\tuple}[1]{\langle #1 \rangle}  
$\tuple{a, b, c}$  
```

output:  

```
$$a^2 = b^2 + c^2$$  
$$x^{17} - 1$$  
$$M^\bot = \{ f \in V' : f(m) = 0 \mbox{ for all } m \in M \}.$$  
$$\[ \cos(\theta + \phi) = \cos \theta \cos \phi - \sin \theta \sin \phi \]$$  
$$\[ |y - x| < \delta \]$ then $\[ |f(y) - f(x)| < \epsilon. \]$$  
$$\newcommand{\tuple}[1]{\langle #1 \rangle}\tuple{a, b, c}$$
```

## Links

```
This is an automatic link <http://www.google.com>.  
This is [inline link](http://example.com/ "Title") inline link with title.  
This is [inline link](http://example.com/ ) inline link without title attribute.  
This is [reference link ][ref] with ID.  
This is [reference link][] without ID.  
This is [Inline Internal link](#TOC).  
This is [Internal link].  

[ref]: http://example.com/  
[reference link]: http://www.google.com  
[Internal link]: #pandocs-markdown-reference  
```

Output:  

This is an automatic link <http://www.google.com>.  
This is [inline link](http://example.com/ "Title") inline link with title.  
This is [inline link](http://example.com/ ) inline link without title attribute.  
This is [reference link ][ref] with ID.  
This is [reference link][] without ID.  
This is [Inline Internal link](#TOC).  
This is [Internal link].  

[ref]: http://example.com/  
[reference link]: http://www.google.com  
[Internal link]: #pandocs-markdown-reference  

## Images

Markddown images sytax  

```
![](http://3.bp.bloGspot.com/-BLhmfBdELH0/UBT3uUd7r5I/AAAAAAAAADw/-rnn2kz5vjY/s220/oops_monk01_120.jpg "OopsMonk")

![Alt text][pic2]

[pic2]: http://3.bp.bloGspot.com/-BLhmfBdELH0/UBT3uUd7r5I/AAAAAAAAADw/-rnn2kz5vjY/s220/oops_monk01_120.jpg  
```

Output:  

![](http://3.bp.bloGspot.com/-BLhmfBdELH0/UBT3uUd7r5I/AAAAAAAAADw/-rnn2kz5vjY/s220/oops_monk01_120.jpg "OopsMonk")

![Alt text][pic2]

[pic2]: http://3.bp.bloGspot.com/-BLhmfBdELH0/UBT3uUd7r5I/AAAAAAAAADw/-rnn2kz5vjY/s220/oops_monk01_120.jpg  

---  

Markdown的貼圖不能指定圖片大小, 可以用HTML來放圖片.  

```
<img src="http://3.bp.bloGspot.com/-BLhmfBdELH0/UBT3uUd7r5I/AAAAAAAAADw/-rnn2kz5vjY/s220/oops_monk01_120.jpg" width="50">
```

Output:  

{{< rawhtml >}}
<img src="http://3.bp.bloGspot.com/-BLhmfBdELH0/UBT3uUd7r5I/AAAAAAAAADw/-rnn2kz5vjY/s220/oops_monk01_120.jpg" width="100">
{{< /rawhtml >}}

## Embedded Video

Markdown沒有嵌入影片的語法, 需要使用HTML.  

```
<iframe src="http://embed.ted.com/talks/lang/zh-tw/ken_robinson_how_to_escape_education_s_death_valley.html"
width="560" height="315" frameborder="0" scrolling="no" 
webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
```

Output:  

{{< rawhtml >}}
<iframe src="http://embed.ted.com/talks/lang/zh-tw/ken_robinson_how_to_escape_education_s_death_valley.html"
width="560" height="315" frameborder="0" scrolling="no"
webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>

{{< /rawhtml >}}

## Code block

### Basic Code block

```
This is one line code block `function()`   
``There is a literal backtick (`) here.``  
Bellow is a code block:  

    if(x == 0){
        printf("x = 0");
    else
        printf("x =/= 0");
```

Output:
 
This is one line code block `function()`   
``There is a literal backtick (`) here.``  
Bellow is a code block:  

    if(x == 0){
        printf("x = 0");
    else
        printf("x =/= 0");

---  

### Pandoc Code Block

#### Force code block(more then three `~`)

~~~~~~~~~
~~~~~~~
if (a > 3) {
  moveShip(5 * gravity, DOWN);
  }
~~~~~~~
~~~~~~~~~

Output  

~~~~~~~
if (a > 3) {
  moveShip(5 * gravity, DOWN);
  }
~~~~~~~

---  

#### Code Syntax highlight

~~~
```python
import os
import sys

def application(env, start_response):  
    start_response('200 OK', [('Content-Type','text/html')])  
    return "Hello WSGI!!"
```
~~~

Output:  

```python
import os
import sys

def application(env, start_response):  
    start_response('200 OK', [('Content-Type','text/html')])  
    return "Hello WSGI!!"
```

---  

#### Line Number

~~~~~~  
~~~~ {#pycode .python .numberLines startFrom="10"}
import os
import sys

def application(env, start_response):  
    start_response('200 OK', [('Content-Type','text/html')])  
    return "Hello WSGI!!"
~~~~
~~~~~~  

Output:  

~~~~ {#pycode .python .numberLines startFrom="10"}
import os
import sys

def application(env, start_response):  
    start_response('200 OK', [('Content-Type','text/html')])  
    return "Hello WSGI!!"
~~~~

## Blockquotes

```
> This is a block quote.
>
> > A block quote within a block quote.
> > 
> > > Nets.
```

Output: 
 
> This is a block quote.
>
> > A block quote within a block quote.
> > 
> > > Nets.

## Lists

### Basic list

#### Unordered(Bulleted)

```
* fruits
    + apples
        - macintosh
        - red delicious
    + pears
    + peaches
* vegetables
    + brocolli
    + chard
```

Output:

* fruits
    + apples
        - macintosh
        - red delicious
    + pears
    + peaches
* vegetables
    + brocolli

---  

#### Ordered (Numbered)

```
1. list1.
1. list2.
1. list3.
1. list4.
```

Output: 

1. list1.
1. list2.
1. list3.
1. list4.

### Pandoc List Extension

#### startnum

```
5) Five
    i. 5-1
    i. 5-2
5) Six
    iii. 6-1
        * 6-1-1
        * 6-1-2
    iii. 6-2
    iii. 6-3
5) Seven
    a. 7-1
    i. 7-2
        #. 7-2-1
        #. 7-2-2
    i. 7-3

<!-- -->

5) Five again.  
```

Output:  

5) Five
    i. 5-1
    i. 5-2
5) Six
    iii. 6-1
        * 6-1-1
        * 6-1-2
    iii. 6-2
    iii. 6-3
5) Seven
    a. 7-1
    i. 7-2
        #. 7-2-1
        #. 7-2-2
    i. 7-3

<!-- --> 

5) Five again.  

---  

#### Definition lists

語法中為`:`與`Definition`之間為 `TAB` 鍵.  

```
    Term 1

    :   Definition 1

    Term 2 with *inline markup*

    :   Definition 2

            { some code, part of Definition 2 }

        Third paragraph of definition 2.
```

Output:  

Term 1

:   Definition 1

Term 2 with *inline markup*

:   Definition 2

        { some code, part of Definition 2 }

    Third paragraph of definition 2.

----  

另一種寫法, 裡面無法放入code block.  

```
Term 1
  ~ Definition 1
Term 2
  ~ Definition 2a  
  ~ Definition 2b
```

Output:  
 
Term 1
  ~ Definition 1
Term 2
  ~ Definition 2a  
  ~ Definition 2b

---  

#### Example lists  

```
(@)  My first example will be numbered (1).
(@)  My second example will be numbered (2).

Explanation of examples.

(@)  My third example will be numbered (3).  

(@good)  This is a good example.

As (@good) illustrates, ...  
```

Output:  

(@)  My first example will be numbered (1).
(@)  My second example will be numbered (2).

Explanation of examples.

(@)  My third example will be numbered (3).  

(@good)  This is a good example.

As (@good) illustrates, ...


## Pandoc Footnotes

註解會出現在文章的最後面.  

    Here is an inline note.^[Inlines notes are easier to write, since
    you don't have to pick an identifier and move down to type the
    note.]  

    Here is a footnote reference,^[^[^1]^]^ and another.[^longnote]

    [^1]: Here is the footnote.

    [^longnote]: Here's one with multiple blocks.

        Subsequent paragraphs are indented to show that they
    belong to the previous footnote.

            { some.code }

        The whole paragraph can be indented, or just the first
        line.  In this way, multi-paragraph footnotes work like
        multi-paragraph list items.

    This paragraph won't be part of the note, because it
    isn't indented.

Output:  

Here is an inline note.^[Inlines notes are easier to write, since
you don't have to pick an identifier and move down to type the
note.]  

Here is a footnote reference,^[^[^1]^]^ and another.[^longnote]

[^1]: Here is the footnote.

[^longnote]: Here's one with multiple blocks.

    Subsequent paragraphs are indented to show that they
belong to the previous footnote.

        { some.code }

    The whole paragraph can be indented, or just the first
    line.  In this way, multi-paragraph footnotes work like
    multi-paragraph list items.

This paragraph won't be part of the note, because it
isn't indented.

## Pandoc Table  
標準的Markdown沒有實現表格的標示.  

### Simple tables  

      Right     Left     Center     Default
    -------     ------ ----------   -------
         12     12        12            12
        123     123       123          123
          1     1          1             1

Output:  

  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

---  

### Multiline tables  

    --------------------------
     Centered   Default           Right Left
      Header    Aligned         Aligned Aligned
    ----------- ------- --------------- -------------------------
       First    row                12.0 Example of a row that
                                        spans multiple lines.

      Second    row                 5.0 Here's another one. Note
                                        the blank line between
                                        rows.
    --------------------------

Output:  

--------------------------
 Centered   Default           Right Left
  Header    Aligned         Aligned Aligned
----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here's another one. Note
                                    the blank line between
                                    rows.
--------------------------

---  

    ----------- ------- --------------- -------------------------
       First    row                12.0 Example of a row that
                                        spans multiple lines.

      Second    row                 5.0 Here's another one. Note
                                        the blank line between
                                        rows.
    ----------- ------- --------------- -------------------------

Output:  

----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here's another one. Note
                                    the blank line between
                                    rows.
----------- ------- --------------- -------------------------

---  

### Grid tables  

Grid table syntax:  

    : Sample grid table.

    +---------------+---------------+--------------------+
    | Fruit         | Price         | Advantages         |
    +===============+===============+====================+
    | Bananas       | $1.34         | - built-in wrapper |
    |               |               | - bright color     |
    +---------------+---------------+--------------------+
    | Oranges       | $2.10         | - cures scurvy     |
    |               |               | - tasty            |
    +---------------+---------------+--------------------+

Output:  

: Sample grid table.

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | - built-in wrapper |
|               |               | - bright color     |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | - cures scurvy     |
|               |               | - tasty            |
+---------------+---------------+--------------------+

**This is end of article, show defined footnotes as below:**  
