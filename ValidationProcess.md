The purpose of this document is to describe how files are included into a release. The whole SVN repository contains many libraries and samples, some are tested, some aren't, so here's the way we decide how a library or a sample goes to a release package.

Also, we describe how to generate a new release, and how to announce it to the 'world'.


## Validation criteria ##

All jal files must follow these rules:

  1. **it must pass the JSG validator**
  1. **it must compile against the jallib repository, without any warnings (and errors...)**
  1. **if the file is a library, there must be at least one sample, available for at least one target chip**


## The validation process ##

  1. each commiter is responsible enough to know when the time has come for his library or sample to be included in a release.
  1. This means when there's a lot of debates on jallib's group, if people still disagree or have strong suggestions (about API, performances, implementation), then the file should **not** be included.
  1. If everybody agree, and if the commiter feels he has enough tested it, then he adds the file' path into the **TORELEASE** file (sorted, please keep order).
  1. when a file is added to **TORELEASE** file, it may be necessary (usually it is) to update **CHANGELOG** to add a very brief description of what's been added. This is very important to track changes over the version, and contemplate progress :)

**Note**: this process of filling **TORELEASE** file is a continuous process. This means TORELEASE must be populated as soon as the library or sample is ready, not waiting the last minute before the release. Why ? As soon as it's populated, it's not forgotten, it's available on weekly builds "bee" packages, since it's done, other members may want to give a look and review, etc...


## "When do we release ?" ##

Once enough (new or updated) files have been included, once everybody is happy, a new release _can_ be created. There's no criteria written in the marble, it usually goes with compiler updates, or with major enhancements, or just because "it's been a long time".

The release is a 3 step process:

  1. an announcement is made to the jallib list, of your intention to generate a release. Since the next step (creating the beta), is a time-consuming process, it is best to allow a few days before taking the next step, to see if anyone knows of a missing file, or 'this Great Library' that really should be included in this release.
  1. a beta is created (see below for detailed instructions). Release packages are put under the jallib group's file section, so it's publicly available to developpers (but not on download section, as it may confuse users). We usually wait at least 2 weeks, to let people have a look, test, etc..
  1. if everything is OK past these 2 weeks, a final release is created.

**Note**: "if everything is OK" usually means there's no packaging error (eg. documentation hasn't been generated, this file shouldn't be in this directory, ...). If a file is missing in the release (eg. this Great Library), it can't be added between the beta and the final release. It should have been before (see "The validation process"). A new beta could be created to include this package, but this would make the whole release late, penalizing everybody. So this is something to discuss on jallib group, in case it happens.

**Note**: During this 'beta release' time-frame, developers should consider a 'feature freeze' to be in effect -- Do not add new entry to TORELEASE. If you feel a library isn't stable enough, you can remove it from TORELEASE.

### Creating the beta release ###

Creating the beta is done acting on SVN trunk (not creating a new beta branch). The name "beta" should occur in package filenames. If version is "0.6", then packages will include "0.6beta" version in their filename

Beta can be created with `tools/Makefile`:

```
make release VERSION=<the_version>beta 2>&1 | tee <the_version>beta.log
```

Packages are then available under "tools/distrib" directory. They must be **uploaded to group's file section** and mail must be sent to **jallib group, with the log file attached**. This log file has everything needed to check how the beta has been built, including the SVN revision used.

The whole 'beta release' recipe looks like:

  1. in order to setup DITA environment, go to your DITA\_HOME and run ./start\_cmd.sh
  1. then type `make release 2>&1 VERSION=<the_version>beta 2>&1 | tee <the_version>beta.log`. Wait a little. Packages are available in `distrib` directory.
  1. these tarball and zip files are uploaded to the **files** section of jallib group.
  1. announce mail to **jallib**, including `<the_version>beta.log` file !!!


### Creating the final release ###

Creating the final release now requires a SVN branch. This way, we can checkout this branch to exactly build the same packages, without much thinking. This is a foolproof, and browsing this release on SVN web through Google Code is easy.


Final release can be created with `tools/Makefile`:

```
make release VERSION=<the_version> 2>&1 | tee <the_version>.log
```


Packages are then available under "tools/distrib" directory. They must be **uploaded to the download section of jallib googlecode website**, while **deprecating packages from previous version** (we obviously don't delete them). Once done, a "Honored Guy" must be designated: he will send the release announcement to jallist (that's why he's honored...). So, the Honored Guy must send a mail to **jallist**, and also to **jallib group**. Evenually the log should be sent to jallib group (not useful for jallist).


The whole 'final release' recipe looks like:

  1. edit CHANGELOG in `trunk`, and replace "next" with the actual released version, remove empty sections, fill release date, etc... Don't put a new "next" section, it'll be done later. CHANGELOG must be as the final one for this release.
  1. a new svn branch is then created, so we always have access to the release's content at this time. `svn copy https://jallib.googlecode.com/svn/trunk https://jallib.googlecode.com/svn/branches/jallib-the_version`
  1. go to the branch (`svn checkout` it)
  1. edit `tools/Makefile` and change `VERSION=dev` to `VERSION=the_version`. Also replace `trunk` by `branches/jallib-${VERSION}`. This way, one can checkout the branch, and simply `make release` to **exactly** produce the same release packages
  1. in any SVN external references, adjust them so they point to a fixed revision, by specifying "-rrevnum"
  1. in order to setup DITA environment, go to your DITA\_HOME and run ./start\_cmd.sh
  1. just to be sure the branch will contain up-to-date documentation, re-generate it with `make doc` (doc will also be generated from scratch for the packages)
  1. then type `make release 2>&1 | tee <the_version>.log`. Wait a little. packages are available in `distrib` directory.
  1. these tarball and zip files are uploaded to the **download** section of jallib google code project.
  1. announce mail to jallist,  "cc" jallib
  1. include log file in reply to jallib
  1. go to `trunk`, edit CHANGELOG and add a new "next" section for next release!