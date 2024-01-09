# Introducing Refli

Or maybe this should be a second blog post titled "The core of Refli" ? Or "Lex
Iterata, the first layer of Refli" ?

2024-01-12 ?

Works on Refli have been ongoing for almost a year now and it's long overdue
that we write a blog post to introduce the vision behind it. First here is our
current mission statement:

> Refli's mission is to make payroll calculation rules in Belgium accessible,
> by providing documentation, data, and calculation tools all on one platform.
> Our goal is to be useful to a wide audience, including students, payroll
> professionals and software developers alike.
>
> We believe that even the most complex concepts can be made understandable,
> and we're committed to breaking down barriers in payroll calculation.

Because we want to ground our work in a solid underpinning, we envision to form
Refli around three layers, from the Belgian legislative texts up to complete
and precise computations.

x: The realisation of those layers are quite technical and we try to introduce
in this blog post the involved concepts along the way.

``` pikchr
    scale = 0.75
    fontscale = 1.1
    lineht *= 0.4
    charht *= 1.15
    down

    $margin = lineht * 2.5

L3: box "Computations" width 150% height 75% fill white
    arrow
L2: box same "Data"
    arrow
L1: box same "Legislative texts"

    box height (L3.north.y - L1.south.y) + $margin \
      width L3.width + $margin \
      at L2 fill 0xFFF4C1 \
      behind L3
    line invisible from 0.25 * $margin east of last.sw up last.height \
      "Core" italic aligned
```

# Legislative texts

Starting from the bottom of the above schema, the first layer is a set of
legislative texts (e.g. laws or orders). The official version of these texts
are published as PDFs (the "paper" version, that they also call images") on the
Official Belgian Journal web site (maintained by the PFS Justice).

In addition of those PDFs, the PFS Justice makes available three other
representations: an HTML version of those PDFs, but also a PDF and its HTML
version of "consolidated" texts. The consolidated texts are offered in a
separate part of their web site called
["Justel"](https://www.ejustice.just.fgov.be/cgi_loi/loi.pl). (HTML is the main
computer code used to describe web pages.)

To create the first layer within the core of Refli, we currently process the
consolidated HTML version of these texts. We call that layer [Lex
Iterata](https://refli.be/fr/lex).

Iterata is a latin word that means "repeated". It also looks like the word
"iterated". We want to convey that we present legislative texts "again", in a
novel way, and the we intend to build the rest of Refli progressively on top of
it.

The processing of the consolidated texts entails recovering the high-level
structure (headings, articles, paragraphs, ...) of the texts themselves and
some metadata (for instance a link to the original PDF or its page number
within it). We then store the recovered structured content in a relational
database for further processing or querying.

In other words, Lex Iterata offers the consolidated texts of the Official
Belgian Journal in a new HTML form but we want to go a bit further by
leveraging our structured representation.

To better see the various forms that the legislative texts can take, here are
some links for an example text, as offered by the PFS Justice:

- [The official PDF "image"](https://www.ejustice.just.fgov.be/mopdf/2023/12/27_2.pdf#Page266)
- [Its HTML version](https://www.ejustice.just.fgov.be/eli/arrete/2023/12/17/2023206853/moniteur)
- [Its consolidated PDF version](https://www.ejustice.just.fgov.be/img_l/pdf/2023/12/17/2023206853_F.pdf)
- [Its consolidated HTML version](https://www.ejustice.just.fgov.be/eli/arrete/2023/12/17/2023206853/justel)

And here is a link for the same text, as offered by Lex Iterata:

- [A new consolidated HTML version](https://refli.be/fr/lex/2023206853)

---

For the reader with a technical background or simply more curious about our
work, we describe some additional representations we make available. Feel free
to skip this section.

In addition of the HTML representation, here are some other links for the same
text that Lex Iterata also offers:

- [A structured representation as JSON](https://refli.be/lex/2023206853)
- [A Markdown representation](https://raw.githubusercontent.com/hypered/iterata-md/main/texts/2023/20/2023206853.md)
- [The Markdown representation rendered by GitHub](https://github.com/hypered/iterata-md/blob/main/texts/2023/20/2023206853.md)

The JSON reprentation is a technical representation for software developers
(and more precisely, for the software they might create) that is easier for
machines to process than an HTML page.

The Markdown representation is a simple textual format that is popular with
software developers. It is designed to be simple to write (for humans) and can
be processed (by machines). For instance, the last link above shows how GitHub
(a popular service to host source code and other text formats) can render it.
(Note that the block enclosed between the lines `---` at the top of the
Markdown file are an addition to the Markdown format; it is yet another textual
format similar to JSON, called YAML.)

Since we talk a lot about various formats, you might want to see some HTML. You
can do so directly in your web browser by right clicking on a page and choosing
"View Page Source". A keyboard shortcut to do the same operation is normally
`Ctrl-u`. (For instance, you can do this on one of the above links pointing to
some HTML representation.)

A nice side effect of offering a Markdown representation of the legislative
texts is that it makes it easier to see how they evolve. On [this GitHub
page](https://github.com/hypered/iterata-md/commit/b38d0897ac3395161a13adcd386d1d50c9053dde)
you can see how two versions of the same texts have been changed. Again, such
kind of change visualisation is very popular with software developers.

For convenience, we also store the original HTML pages of the PFS Justice, and
we can see [the corresponding
page](https://github.com/hypered/iterata-src/commit/e66fbef1c87168dd9673984348665cad8b6e6f6c)
for the same conceptual changes.

---

This work is really just a start and there are a lot of ways we can build upon
what we have today:

- In the future, we would like to extend our work with other sources of
  official records (e.g. enterprise data from the national bank, case laws,
  ...).
- We can improve the processing we do to recover even more fine-grained
  structure. For instance we could identify dates or turn references appearing
  within the texts into links to the referenced texts.
- We can offer a more direct access to the underlying structured data that we
  recover. The JSON representation above is an example but we could also offer
  for instance a copy of our relational database.
- We have to build a search interface. We could extend it with newer ways to
  query them (e.g. using a vector database and a LLM).

# Data

The second layer in our schema is about data, i.e. values that are meaningful
and that could change later. Values can be "simple" such as numbers or words
but can be richer, such as lists or tables.

The example legislative text above is a perfect example of such data as it
defines the (new) values of two fractions used in another legislative text for
the year 2024.

This layer on its own is quite conceptual. Within Refli, we can see that layer
taking shape as some of the tables appearing in our documentation of the gross
to net computation, for instance about the [social security
contributions](https://refli.be/fr/documentation/computation/contribution).

Unlike Lex Iterata which embodies very clearly the first layer of our schema,
this one has not yet a clear delineation within Refli, but this is something
that we want to emphasize.

# Computations

The third layer is the computational core of Refli. This is where Refli stops
being about information and data, and starts becoming an online computer
software. It aims to simplify the _application_ of legal rules when those rules
can be followed by a computer, and bring this simplification to a broad range
of public.

Currently, Refli offers a single computation: given a gross salary amount, what
should be the corresponding net amount. Here is an [example for a gross amount
of 3600EUR](https://refli.be/fr/describe/3600.00?details).

# A beginning

The three layers described above form the conceptual basis of Refli. Each of
them can be extended significantly with its own set of richer features but
more importantly Refli itself should grow.

On top of those layers we have to build additional features (such as user
accounts for individuals or companies, search interface, saving results or
offering them as PDFs, managing multiple computations over time, ...).

Depending on interests, we might want to focus on different things in the
future. For instance this could be Lex Iterata (i.e. legislative texts), or on
some other core aspect of Refli. For instance we can offer the raw
computational capabilities of Refli over a network API, or instead turn it into
a user-facing standalone product.

We have a software developer profile but we are not specialized in human
resources management, salaries or legal topics. If what we're building is of
interest to you, please get in touch, we'd love to talk to you.
