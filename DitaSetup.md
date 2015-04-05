# Introduction #

DITA is an Open Source documentation tool, from IBM, and is somewhat similar to DocBook. It uses XML files to store content, and generators to produce different output from this content.

DITA may be more suitable for jallib use. While Docbook is used to strictly build a whole content of information (say a book), DITA allow to have information split and aggregated, to build different content version. Ex: tutorials can be used to produce a tutorial book, but maybe some of them, the most important ones, could be used to enrich an jallib introduction document. That's just an example.

# Prerequisites #

DITA depends upon Java, so you will need to have it installed on your system _before_ starting the main DITA install.  For Unix-family systems, you can check whether Java is already available using the command `"java -version"` (which should display a brief message with the JRE revision information), or if that fails, `"whereis java"` (which will give the path to where java is installed).  If both of these fail, you will need to install something like OpenJDK v7 (an open-source Java package) using the package manager on your particular system.

# Installing DITA #

To use DITA, we first need to install a toolkit. This can be downloadable from DITA Open Tookit main page: http://dita-ot.sourceforge.net/. We'll use DITA-OT version 1.5, see this [list of files](http://dita-ot.sourceforge.net/).

  * Download the full easy package, named `DITA-OT1.5_full_easy_install_M21_bin.zip` (or tarball `DITA-OT1.5_full_easy_install_M21_bin.tar.gz`). Note the version is **1.5**, annotated **full\_easy\_install** and, very important, **M21**. If not available with given link, have at `test_build` section of download section. (As of 2009-11-22, M23 version also seems to work...). Direct link: http://sourceforge.net/projects/dita-ot/files/DITA-OT%20Latest%20Test%20Build/DITA%20OT%201.5%20M21/
  * create a DITA\_HOME env. variable, to tell DITA where it's installed.
  * enter `DITA-OT1.5` and run `startcmd.sh` (Linux & Co) or `startcmd.bat` (Windows). This automatically setup a lot of environment variables, this will ease a lot DITA use. **Remember to run this script before trying to compile any DITA documents**.

DITA is now ready to be used. That means we're now able to compile some DITA documentation. And that's what we're going to do right now, to make sure installation is fully functional.

  * Compile the DITA example, typing `ant -f build_demo.xml`. Answer questions, by accepting defaults. This will generate an HTML version of example, stored in `out` directory.

You should see something like this, at the end of the compiling process

```

dita.outer.topics.xhtml:

dita2xhtml:

prompt.output.docbook:

prompt.output:
     [echo]
     [echo]                     output in the out directory
     [echo]
     [echo]                     Before rebuilding, please delete the output or the directory.

BUILD SUCCESSFUL
Total time: 17 second
```

Open your favorite web browser and in the `out` directory to see the results. Repeat the procedure to produce a PDF version, this time typing `pdf` when prompted for the format. You'll get a PDF in `out` directory.



# Installing Serna XML editor #

While this is not mandatory, it may help you having an XML editor with DITA flavor, particularly at the beginning, when you don't all the XML elements you need. While testing, I've selected two such editors:

  * **XMLmind XML editor**: http://www.xmlmind.com/xmleditor/
  * **Syntext Serna XML** : http://www.syntext.com/products/serna-free/

Both are nice, but I found Serna more powerful and maybe easier (but that's a matter of taste...). So I'll explain Serna, but you can choose whatever you want.

Installation is very easy, just [download](http://www.syntext.com/downloads/serna-free/) your package, either this exe for Windows, or Zip for Linux. Run the exe, or run `./install.sh` script, after unzip package.

Serna comes with a DITA-OT (Open Toolkit), in version 1.4, whereas we've installed a more recent version 1.5. While we'll stay with 1.5, having DITA-OT 1.4 integrated can be useful for the beginner, as pressing Ctrl-P will just publish the content, by asking format, and output directory. Remember to try to compile your files using our DITA-OT 1.5.

When creating a new document, always select DITA 1.0, not DITA 1.1. See this other wiki page for DITA tutorial (TODO...).

Note: `also, while Serna proposes to create DITA 1.0 or DITA 1.1 document (DITA versions are different from DITA-OT versions, it's about XML specification version), I've never been able to use 1.1 version, without delete some xmlns statements. I won't go into details, just remember to use DITA 1.0 documents, **not** 1.1.


# Installing Jallib customization #

When writing DITA content, you just write content, with very few information about how things are being displayed. This is by design: content is somewhere (XML files), output is done elsewhere, using PDF, HTML, RTF, DocBook, TXT, etc... generators.

This means you can't just decide what police to use, which size, put this in red, etc... You just say, using XML elements, that this is a paragraph, that is a title, the following lines are code. This is how content is always displayed the same, and looks really clean (hopefully).

Output is then handled while compiling the DITA document. During this step, stylesheets are used to produce the results, namely XSL stylesheets. By slightly modifying these stylesheets, we can customize output. XSL can be very complex to read, use, maintain, so customization can be highly time-consuming... That said, I've made few customization for jallib: adding page breaks, modifying titles, displaying authors, add more spaces between section, etc...

These customization are done the DITA way: you add and override definition in custom.xsl files, and declare these new XSL files in XML catalog. Anyway... I've made these customization against the `demo` example. To deploy them, just unzip `/doc/dita/jallib_custom.zip` into DITA\_HOME. Ex:

```
$ export DITA_HOME=/home/sirloon/jallib/tools/DITA-OT1.5
$ cd $DITA_HOME
$ unzip ../../doc/dita/jallib_custom.zip
```

If asked, accept to overwrite existing files. To check if customizations are correctly installed, you can compile the tutorial book, using this horrible command line:

```
ant -f $DITA_HOME/build_demo.xml -Dprompt.ditamap.filename=/absolute/path/to/jallib/doc/dita/tutorials/tutorials.ditamap -Dprompt.output.type=pdf
```

You should see "Jallib Tutorials" on top of pages, instead of "Open Topic".