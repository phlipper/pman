#
# pman -- create, print, save, view PDF man pages
#
# Author: ntk
# License: The MIT License, Copyright (c) 2007 ntk
# Description: (batch) convert man pages into PDF documents and save them to a specified directory; (batch) print or view PDF man pages from the command line
# Platform: Mac OS X 10.4.10; man bash
# Installation: put pman() into ~/.bash_login (or alternatives)
#
# Usage:
# pman ls; pman getopts                                 # convert a singel man page to a PDF file, save and open it
# pman 8 sticky                                         # same with manual section number
# pman m toe
# pman -b ls 'open(2)' dd "chmod(2)" curl 'open(n)'     # batch convert man pages into PDF files
# pman -p rm srm open\(2\) 'toe(m)' 'ncurses(3)'        # print man pages using the default printer
pman() {
  section="$1"
  manpage="$2"
  mandir="/Users/Shared/manpages"    #  save the created PDF man pages to the specified directory

  # batch process man pages to PDF files with the "-b" switch and save them to $mandir
  # example: pman -b ls 'open(2)' dd 'chmod(2)' 'open(n)' 'sticky(8)'
  # cf. man -aW open for "man n open"

  if [[ "$1" = "-b" ]]; then

    if [[ ! -d $mandir ]]; then
      mkdir -p $mandir
      chmod 1777 $mandir
    fi

    shift   # remove "-b" from "$@"

    for manfile in "$@"; do

    # example for $manfile: open(2)
    manpage="`echo $manfile | grep -Eos '^[^\(]+'`"                              # extract name of man page
    section="`echo $manfile | grep -Eos '\([^\)]+\)' | grep -Eos '[^\(\)]+'`"    # extract section of man page

    if [[ ! "$section" ]]; then
      section="1"
    fi

    if [[ ! -f "`man ${section} -W ${manpage} 2>/dev/null`" ]]; then
      #if [[ ! -f "`man -W ${section} ${manpage} 2>/dev/null `" ]]; then
      echo "No such man page: man ${section} ${manpage}"
      continue
    fi

    manfile="${mandir}/${manpage}(${section}).pdf"
    echo "$manfile"

    if [[ ! -f "$manfile" ]]; then
      man $section -t $manpage 2>/dev/null | pstopdf -i -o "$manfile" 2>/dev/null
      chmod 1755 "$manfile"
      # hide file extension .pdf
      if [[ -f /Developer/Tools/SetFile ]]; then /Developer/Tools/SetFile -a E "$manfile"; fi
      fi

    done

    return 0

  fi          # END of batch processing man pages to PDF files



  # print PDF man pages using the default printer (see man lpr and man lpoptions)
  # if necessary, create the specified PDF man pages and save them to $mandir
  # example: pman -p rm srm

  if [[ "$1" = "-p" ]]; then

    if [[ ! -d $mandir ]]; then
      mkdir -p $mandir
      chmod 1777 $mandir
    fi

    shift   # remove "-p" from "$@"

    for manfile in "$@"; do

    # example for $manfile: open(2)
    manpage="`echo $manfile | grep -Eos '^[^\(]+'`"                              # extract name of man page
    section="`echo $manfile | grep -Eos '\([^\)]+\)' | grep -Eos '[^\(\)]+'`"    # extract section of man page

    if [[ ! "$section" ]]; then
      section="1"
    fi

    if [[ ! -f "`man ${section} -W ${manpage} 2>/dev/null`" ]]; then
      echo "No such man page: man ${section} ${manpage}"
      continue
    fi

    manfile="${mandir}/${manpage}(${section}).pdf"
    echo "$manfile"

    if [[ ! -f "$manfile" ]]; then
      man -t $section $manpage 2>/dev/null | pstopdf -i -o "$manfile" 2>/dev/null
      chmod 1755 "$manfile"
      # hide file extension .pdf
      if [[ -f /Developer/Tools/SetFile ]]; then /Developer/Tools/SetFile -a E "$manfile"; fi
        lpr "$manfile"
      else
        lpr "$manfile"
      fi

    done

    return 0

  fi          # END of printing man pages using the default printer



  # convert a single man page to a PDF file, save it to $mandir and then open it in a PDF viewer

  if [[ -z "$1" ]] || [[ $# -gt 2 ]]; then       # check number of arguments
    #if [[ -z "$1" || $# -gt 2 ]]; then
    #if [ -z "$1" -o $# -gt 2 ]; then
    echo "Wrong number of arguments!"
    return 1
  fi

  if [[ ! "$manpage" ]]; then     # turn "pman ls" into "pman 1 ls"
    manpage="$section"         # if $manpage is an empty string because there has been no "$2" then $manpage is set to "$section" and ...
    section="1"                # ... $section is set to "1"
  fi

  if [[ ! -f "`man ${section} -W ${manpage} 2>/dev/null`" ]]; then
    echo "No such man page: man ${section} ${manpage}"
    return 1
  fi

  if [[ ! -d $mandir ]]; then
    mkdir -p $mandir
    chmod 1777 $mandir
  fi

  manfile="${mandir}/${manpage}(${section}).pdf"

  if [[ -f "$manfile" ]]; then
    open "$manfile"
  else
    man $section -t $manpage 2>/dev/null | pstopdf -i -o "$manfile" 2>/dev/null

  chmod 1755 "$manfile"
  # hide file extension .pdf
  if [[ -f /Developer/Tools/SetFile ]]; then /Developer/Tools/SetFile -a E "$manfile"; fi
    open "$manfile"
  fi

  return 0
}