# Documentation Site

Flame's documentation is written in **Markdown**. It is then rendered into HTML with the help of
the [Sphinx] engine and its [MyST] plugin. The rendered files are then manually (but with the help
of a script) published to [flame-docs-site], where the site is served via [GitHub Pages].

[Sphinx]: https://www.sphinx-doc.org/en/master/
[MyST]: https://myst-parser.readthedocs.io/en/latest/
[flame-docs-site]: https://github.com/flame-engine/flame-docs-site
[GitHub Pages]: https://pages.github.com/


## Markdown

The main documentation site is written in Markdown. We assume that you're already familiar with the
basics of the Markdown syntax (if not, there are plenty of guides on the Internet). Instead, this
section will focus on the Markdown extensions that are enabled in our build system.


### Table of contents

The table of contents for the site must be created manually. This is done using special `{toctree}`
blocks, one per each subdirectory:

`````{markdown}
```{toctree}
:hidden:

First Topic    <topic1.md>
Second Topic   <topic2.md>
```
`````

When adding new documents into the documentation site, make sure that they are mentioned in one of
the toctrees -- otherwise you will see a warning during the build that the document is orphaned.


### Admonitions

Admonitions are emphasized blocks of text with a distinct appearance. They are created using the
triple-backticks syntax:

`````{markdown}
```{note}
Please note this very important caveat.
```
```{warning}
Don't look down, or you will encounter an error.
```
```{error}
I told you so.
```
```{seealso}
Also check out this cool thingy.
```
`````

```{note}
Please note this very important caveat.
```

```{warning}
Don't look down, or you will encounter an error.
```

```{error}
I told you so.
```

```{seealso}
Also check out this cool thingy.
```


### Deprecations

The special `{deprecated}` block can be used to mark some part of documentation or syntax as being
deprecated. This block requires specifying the version when the deprecation has occurred

`````{markdown}
```{deprecated} v1.3.0

Please use this **other** thing instead.
```
`````

Which would be rendered like this:

```{deprecated} v1.3.0

Please use this **other** thing instead.
```


### Live examples

Our documentation site includes a custom-built **flutter-app** directive which allows creating
Flutter widgets and embedding them alongside with the overall documentation content.

In Markdown, the code for inserting an embed looks like this:

`````{markdown}
```{flutter-app}
:sources: ../flame/examples
:page: tap_events
:show: widget code popup
```
``````

Here's what the different options mean:

- **sources**: specifies the name of the root directory where the Flutter code that you wish to run
  is located. This directory must be a Flutter repository, and there must be a `pubspec.yaml` file
  there. The path is considered relative to the `doc/_sphinx` directory.

- **page**: a sub-path within the root directory given in `sources`. This option has two effects:
  first, it is appended to the path of the html page of the widget, like so: `main.dart.html?$page`.
  Secondly, the button to show the source code of the embed will display the code from the file or
  directory with the name given by `page`.

  The purpose of this option is to be able to bundle multiple examples into a single executable.
  When using this option, the `main.dart` file of the app should route the execution to the proper
  widget according to the `page` being passed.

- **show**: contains a subset of modes: `widget`, `code`, `infobox`, and `popup`. The `widget` mode
  creates an iframe with the embedded example, directly within the page. The `code` mode will show
  a button that allows the user to see the code that produced this example. The `popup` mode also
  shows a button, which displays the example in an overlay window. This is more suitable for
  demoing larger apps. Using both "widget" and "popup" modes at the same time is not recommended.
  Finally, the `infobox` mode will display the result in a floating window -- this mode is best
  combined with `widget` and `code`.

```{flutter-app}
:sources: ../flame/examples
:page: tap_events
:show: widget code popup
```


## Building documentation locally

Building the documentation site on your own computer is fairly simple. All you need is the
following:

1. A working **Flutter** installation, accessible from the command line;

2. A **Python** environment, with python version 3.6 or higher;
    - You can verify this by running `python --version` from the command line;
    - Having a dedicated python virtual environment is recommended but not required;

3. A set of python **modules** listed in the `doc/_sphinx/requirements.txt` file;
    - The easiest way to install these is to run

      ```console
      pip install -r doc/_sphinx/requirements.txt
      ```

Once these prerequisites are met, you can build the documentation by switching to the `doc/_sphinx`
directory and running `make html`:

```console
cd doc/_sphinx
make html
```

The **make html** command here renders the documentation site into HTML. This command needs to be
re-run every time you make changes to any of the documents. Luckily, it is smart enough to only
rebuild the documents that have changed since the previous run, so usually a rebuild takes only
a second or two.

There are other make commands that you may find occasionally useful too: **make clean** removes all
cached generated files (in case the system gets stuck in a bad state); and **make linkcheck** to
check whether there are any broken links in the documentation.

The generated html files will be in the `doc/_build/html` directory, you can view them directly
by opening the file `doc/_build/html/index.html` in your browser. The only drawback is that the
browser won't allow any dynamic content in a file opened from a local drive. The solution to this
is to run your own local http server:

```console
python -m http.server 8000 --directory doc/_build/html
```

Then you can open the site at `http://localhost:8000/`.

If you ever run the `make clean` command, the server will need to be restarted, because the clean
command deletes the entire `html` directory.
