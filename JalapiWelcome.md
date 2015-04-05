# What is the jalapi #

**jalapi** is the jallib API documentation (API = Application Programming Interface -- information you, as a programmer, need to know to easily utilize the individual libraries within jallib). You can access the jalapi from here:

  * [jalapi](http://jallib.googlecode.com/svn/trunk/doc/html/index.html)


**jalapi** is directly integrated into jallib's SVN repository. It is also available under the doc/html directory in all of the downloadable jallib packages.


# jalapi for developers #

## Description ##

**jalapi** documentation is generated from the comments found in jal libraries, particularly from:

  * [JSG](JallibStyleGuide.md) headers. A library must be strictly [JSG](JallibStyleGuide.md) compliant before being integrated to jalapi.

  * comments found directly above `var`, `const`, `procedure` and `function`.

## How to write comments ##

The two following examples show how to correctly format comments in your code so that **jalapi** can extract them.

**good**
```

-- this my procedure
-- it's amazing !
procedure my_proc() is
end procedure
```

**bad**
```
-- this is still my procedure

-- it's not that amazing
procedure my_proc() is
end procedure
```


In the second example, only the line directly above the procedure will be considered to be a valid comment; because there's an empty line intervening, **jalapi** will ignore the "this is still..." comment.

## About syntax... ##

**jalapi** also converts your comments to html, following the Google Code Wiki Markup Syntax. That is, you can add bullet list, tables, etc... just like you'd do here, in a wiki page. _But_, while GC wiki doesn't respect line feeds (or carriage return), **jalapi** _does_ try to preserve your carriage returns: where there's a "`\n`", it produces an "`<br/>`" html element.

Finally, keep in mind the following rules: _don't make comments too fancy_. While they may look beautiful in your code (though it can be heavy-going to read them), they'll be converted to html, and this can sometimes produce weird effects.

Exception: long dash lines, used to ease the identification of code blocks, can be used in a jal file, but will be removed while generating html. To be precise, everything starting with "-- -" will be ignored. Ex:

```
-- --------------------
-- this is my comment
-- --------------------
procedure blabla() is
   --
end procedure
```

Only the single line, "this is my comment", will be kept.


**Keep it simple!**


## Howto generate doc ##

There are two main scripts to generate your documentation. Both can only be run from Unix/Linux, because they use `grep`, `sed`, etc.

### jalapi.py ###

`jalapi.py` takes a template and a jal file as inputs. It also needs the `SAMPLEDIR` environment variable to be defined. It prints the html result on stdout.

Ex
```
cd path/to/tools
SAMPLEDIR=../sample python jalapi.py jalapi_html.tmpl mylib.jal > mylib.html
```

Since html files are directly integrated to SVN, and served by the GC apache server, you will also need to adjust the mimetype of the generated files so that there're recognized as "real" html files and not just raw ascii text (they won't display correctly if you don't do this):

```
svn propset svn:mime-type text/html mylib.html
```


### jalapi\_generate.sh ###

Because all of this can be a real p.i.t.a, there's a second script to glue the whole thing together, which will automatically generate documentation for all **libraries** found, **except for device files**  (device files are not included because there are no relevant comments in the code and those comments which are present would generate a lot of duplicate output).

Running this script is as simple as:

```
cd ..../tools
./jalapi_generate.sh path/to/trunk
```

It automatically finds libraries, sets SAMPLEDIR, adds files to the `doc/html` directory and correctly sets the SVN properties.