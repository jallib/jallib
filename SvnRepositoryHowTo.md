# Why SVN ? #

First, SVN (as CVS and all other version control systems) is aimed to help people working together, on the same project. There's a central repository, on the server. But no one is working directly on the server (there's fortunately no way to do this).

## Accessing SVN in read-only mode ##

Everyone can access SVN in **read-only mode**, or as **anonymous**. In this mode, you won't be able to commit, add or delete anything to the repository. This is for people who want to remain anonymous ;), want to contribute by testing code from the repository, but don't want to modify things, etc...

To retrieve the sources from the repository, in read-only mode:

> `svn checkout http://jallib.googlecode.com/svn/trunk/ jallib-read-only`

Notes:
  * there is not "s" with "http://..." scheme.
  * you don't need to provide any username (it's anonymous...)


## Accessing SVN in read/write mode ##

The first thing to be sure is to have a **jallib account**. Do you have one ?  Then you can access the SVN in read/write mode. So, you first checkout a local copy:

> `svn checkout https://jallib.googlecode.com/svn/trunk/ jallib --username <your_username>`

You'll need to use a generated password, this is **not** the password used with your Google account. See _Source_ tab to generate one.

This command says: "gimme the last revision copy on the trunk, please". You can specify a lot more, such as given a date, a given revision. So, in your "jallib", you should get the current SVN hierarchy.

Notes:
  * careful, it's "https://..." with a "s"


Once done, whether in **read-only** or **read/write** mode, you should have a look at


# Absolute minimum SVN commands #

## Common commands: read-only and read/write mode ##

Once entered in the "jallib" dir:


  * get some information about your local copy

> `svn info`

  * update your copy

> `svn update`

  * check the current status of your local copy against the repos:

> `svn status      # shows what's changed on your local copy, without actually querying the server`

> `svn status -u  # same, but also query the server, potentially showing new/modifiedl/deleted files on the server. Modifications would appear in your copy if you 'svn update'`

  * show the difference

> `svn diff a_file   # show differences `

> Note: some of SVN commands, like _diff_, can take a date, a revision, or special keywords as argument. This is particurlarly interesting when you want to understand changes:

> `svn diff -rPREV afile  # shows diff between local copy and previous revision for this file`

> `svn diff -rHEAD afile  # shows diff between local copy and the last available on the server. Useful to know understand changes before an update`

  * history of a file

> `svn log a_file       # show all revisions involved with this file, and commit logs`

  * get help :)

> `svn help`

> `svn help <command>`

## Commands for read/write mode only ##


  * add something new. This is only needed the first time:

> `svn add <a_file_or_a_dir>`

  * commit something, that is, sending your local modifications to the server so everybody can have access to your last work !

> `svn commit            # will commit all your modifications`

> `svn commit a_file   # commit just this file`

> You'll be asked to enter a message, a comment for this commit. Unless modifications are obvious, it's really important to describe _what_ are the modications and _why_ you've done such modifications (and not _how_).

> Note that since the last time you've checkout/updated your local repository, people may have committed a lot. If it's specifically things you're working on, there will be conflicts and svn will refuse your commit. In case of error, and as a good practice, **check your local repository's status against the server with `svn status -u`**, and if needed `svn update`, so you're up-to-date before actually committing your stuff.

  * rename something, files or directories. As in Unix/Linux, it's also used to move files or directories.

> `svn mv <old_name> <new_name>`

  * erase/delete files or directories

> `svn rm <something>`



In any case, you can go the [Source](http://code.google.com/p/jallib/source/checkout) tab and more information from Google Code (SVN clients, specifically).


# Troubleshooting #

### "It says  my client is too old, and I should update it or downgrade my working copy. What does this mean ?" ###

You probably updated you're working copy with a recent SVN client (say 1.6) and now you want to update it with an older one (say 1.5). Either update your client 1.5 to 1.6, or downgrade your working copy from 1.6 to 1.5, following instructions here: http://subversion.apache.org/faq.html#working-copy-format-change