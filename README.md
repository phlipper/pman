# pman

(batch) convert man pages into PDF documents and save them to a specified directory; (batch) print or view PDF man pages from the command line


## Platform

Mac OS X 10.4.10+
bash


## Installation

Add `pman()` into `~/.bash_login` (or alternatives) or `source` it from a custom location.


## Usage

Examples:

Convert a single man page to a PDF file, save and open it:

```
$ pman ls; pman getopts
```

Same with manual section number:

```
$ pman 8 sticky
$ pman m toe
```

Batch convert man pages into PDF files:

```
$ pman -b ls 'open(2)' dd "chmod(2)" curl 'open(n)'
```

Print man pages using the default printer:

```
$ pman -p rm srm open\(2\) 'toe(m)' 'ncurses(3)'
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

**pman**

* Freely distributable and licensed under the [MIT license](http://phlipper.mit-license.org/2007-2012/license.html).
* Copyright (c) 2007-2012 Phil Cohen (github@phlippers.net) [![endorse](http://api.coderwall.com/phlipper/endorsecount.png)](http://coderwall.com/phlipper)
* http://phlippers.net/


**Original source:**

License: The MIT License, Copyright (c) 2007 ntk
