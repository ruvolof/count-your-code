CYC - Count your Code
==========================

Count Your Code is a Perl script to analyze your source tree and cound how many code lines you've written.
It can easily discern programming languages by file extensions and give you a comprehensive view of your
programming activity.

### Installation ###

First of all, clone the git repository on your machine:

`git clone git://github.com/ruvolof/count-your-code cyc`  
`cd cyc`

Now, you should run `install.sh` as follows:

`./install.sh`

You could do it as root, in which case CYC will be installed in /usr/bin, or with your user account,
in which case CYC will be installed in $HOME/bin and $HOME/bin will be added tou your PATH variable
if it's not yet there.

If you get tired of it, you can unistall it by running:

`./install.sh uninstall`

Which, of course, will require root privileges if you installed it under /usr/bin.

### Usage ###

Since CYC will recursive check the whole source tree, you can run it as follows:

`cyc path/to/source/tree`

You can use __--stats__ in order to have a different counting for every programming language:

`cyc --stats path/to/tree/source`

Or:

`cyc --stats my/whole/programming/directory`
`cyc --stats *`
`cyc --stats folder1 folder2 file1 file2`
