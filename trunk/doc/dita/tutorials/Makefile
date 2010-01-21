

VERSION=dev

prepare:
	-rm -fr tmp
	-mkdir tmp

pdf: prepare
	ant -f $$DITA_HOME/build_demo.xml -Dprompt.ditamap.filename=`pwd`/tutorials.ditamap -Dprompt.output.type=pdf -Dprompt.output.directory=`pwd`/tmp -Dprompt.output.confirm=y
	mv `pwd`/tmp/tutorials.pdf `pwd`/tmp/Tutorial_Book_${VERSION}.pdf

html: prepare
	ant -f $$DITA_HOME/build_demo.xml -Dprompt.ditamap.filename=`pwd`/tutorials.ditamap -Dprompt.output.type=web -Dprompt.output.directory=`pwd`/tmp -Dprompt.output.confirm=y

front: html
	# this page is only dedicated to website, it needs to integrate TOC
	# prepare generated TOC for web publishing
	cd ../../../tools/japp && python htmlizer.py japp_config.py ../../doc/dita/tutorials/tmp/toc.html
	ant -Dargs.transtype=xhtml -Doutput.dir=`pwd`/tmp -Dargs.input=`pwd`/tutorial_book.xml  -Dargs.target=init -f $$DITA_HOME/build.xml dita2xhtml
	# the beauty and magic of sed :)
	cat tmp/tutorial_book.html | sed -e '/Table of Content/rtmp/topublish/content' -e "s#@VERSION@#${VERSION}#g" > tmp/tutorial_book.html.toc
	mv tmp/tutorial_book.html.toc tmp/tutorial_book.html
	mv tmp/topublish tmp/topublish.toc
	cd ../../../tools/japp && python htmlizer.py japp_config.py ../../doc/dita/tutorials/tmp/tutorial_book.html
