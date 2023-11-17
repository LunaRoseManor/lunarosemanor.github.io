---
layout: post
title: How to Make a Jekyll Theme
---

Don't.

Use one someone else made and write. There are
[dozens available](https://jekyllrb.com/docs/themes). Just because a solution
[wasn't invented here](https://en.wikipedia.org/wiki/Not_invented_here) doesn't
make it lesser. If you have a mind like mine, however that's probably not good
advice for you. You don't just want 

There's actually a name for this problem:
[Not invented here](https://en.wikipedia.org/wiki/Not_invented_here). It was
first adopted as a term to describe companies suspicious of external products
for legal reasons, but I think that some individuals are guilty of it as well.
I certainly am. On this occasion I was unable to resist the siren's song and
had to make my own from scratch.

If you still insist, I'll
tell you some of the challenges I had working on
[String Theory](https://github.com/LunaRoseManor/string-theory). It's my attempt
at a minimum viable product, basically an answer to the question "what's the
most basic a Jekyll theme can be?", to which I had three main goals in mind:

- Speed
- Style
- Features

In order of importance from top to bottom. Ultimat

Don't.

Seriously, just use one of the default themes and get writing. There are dozens
of themes available from the official website and similar portals. The only
reason you should be writing your own theme is if you want to become a theme
developer.

It's about the same conundrum as game development as a programmer. You want to
make games, but all those pre-built engines are old and stuffy. You don't
actually understand how they work. You *need* to understand how they work,
because otherwise there isn't any sense of satisfaction.

There's actually a name for this problem:
[Not invented here](https://en.wikipedia.org/wiki/Not_invented_here). It was
first adopted as a term to describe companies suspicious of external products
for legal reasons, but I think that some individuals are guilty of it as well.
I certainly am. On this occasion I was unable to resist the siren's song and
had to make my own from scratch.

There's no reason to do this other than to make yourself look smart. If you
still insist on it, I'll tell you.

First, you need to install the Jekyll toolchain. If you're a Windows user, this
is kind of a pain. First, you need to run the
[Ruby Installer](https://rubyinstaller.org/), making sure to install a copy of
Msys2 along with it. Because of the way Windows works, you need to make sure
that you also have it installed onto your `C:` drive. I have a secondary `D:`
drive on my machine at time of writing. When I sent the ruby files there with
Chocolatey, I got a bunch of anomalous behaviour, mainly relating to executables
not being related to the PATH environment variable automatically. Other
platforms actually use package managers and a variable access file system, so
all you need to do is run the command for that.

This should give you both `bundle` and `gem`, which you can use to
`gem install jekyll`. You'll probably also want to install the
`jekyll-theme-minima` as a baseline to start with.

(Wait, do I want to talk about themes in general or specifically my theme)

There's already a
[pretty good tutorial](https://jekyllrb.com/docs/themes/#creating-a-gem-based-theme)
for creating themes on the official Jekyll website, and it covers most but not
all of what you need to know. Its the stuff that they leave out that I find the
most frustrating. For example, it doesn't cover the basic functionality that
you'd expect to have with a theme. In particular this means that your default
theme won't have the ability to list posts, automatically update its navbar or
display a favicon. They just left all that stuff out of the toolchain for
whatever reason. It's more simple that way but doesn't actually explain it.

You need to remember to set up the Gemfile. I'm pretty sure the tutorial tells
you how to do this, but I'm not at all certain.

The first thing I struggled with was this. How do I style things? Linking to
a regular CSS file seems not to work. Well what the program actually wants you
to do is to stuff all your assets that aren't markdown into the assets folder.
The program will then copy them over when it goes to build, which you can access
via `/assets/filename.extension`. So remember that. You need to search for non
HTML pages at that root directory.

Jekyll actually uses Sass in order to give you nested styles. You can use the
SCSS Format or look into doing the unbracketed style. I prefer the one without
brackets, but it means that it's not compliant with regular CSS since the line
terminator operator is counted as an unrecognised character. That probably
explains why the Sass developers seem to be prioritising it less.

That was a pun, wasn't it? Dammit.

The next stumbling block was getting a good baseline for the layouts. What
Jekyll wants you to do is to create a file called `/_layouts/default.html` and
have every other layout file point back to it. Like:

```
---
layout: default
---

<header>
...
```

At the very least, you need one layout for HTML generally, another for posts
and one more for general pages that aren't blog posts. These can include the
header of the page specified by the YAML data but I opted not to. Whilst you're
at it, you also want to make sure you're properly escaping titles with
{{ [your_url] | escape }}, just in case any unsanitary HTML characters make it
through.

From here things progress simply enough. Any Markdown files you write should be
correctly processed as long as they have front matter. Jekyll just kind of
ignores anything in the build step that doesn't have it, such as image files or
plain text files without it. Eventually, you're going to want to make things a
little more complicated.

Just whilst you're here, Jekyll has a special case for HTTP errors. You need to
write individual files for each error code, which are named the error code itself
plus the outlook of HTML. There's no real documentation for this being the case.

It's where the post list comes in that things get a little more complicated.
Personally, I found the documentation of Jekyll's default styles to be a bit
convuluted. The variables are poorly explained. As stated on Jekyll's website,
there are several variables passed as globals to every Jekyll page. You've got
the site variable, the page variable and the config variable.

Frustratingly, there's no easy way to get the data out. Sometimes putting in
one combination of variables into an output function in liquid gives wildly
different results. `{{ site.pages | jsonify | escape }}` was my primary filter
of choice though it doesn't appear to pretty print. There's no way to beautify
the text into something a human is actually able to read. So what I ended up
doing is making it so that I would output the filter above, but that an external
tool would actually neaten it up for me.

I would suggest to the developers going forward that they actually do a proper
investigation of this. There's not enough transparency and it makes actually
debugging problems in templates difficult. Liquid could also do with a `prettify`
filter.

Anyway, there's a big hurdle that comes with actually displaying recent posts.
There's far too many ways to do this and it all just depends on your needs.
At this early stage, I just wanted a big, monolithic list of dates and 
hyperlinks. I decided to put everything related to listing posts in their own
include. It didn't make sense to just shunt them into a home layout and hope
for the best. There had to be a better way.

I solved this by putting it in an include. That way if I figure out a better way
of putting everything into a single post file then I can just reuse it. For
example, if I want an archive, I can just use the page data to change the
settings on the include. This was probably an unecessary step but all the
data related to posts is stored in `site.posts` that you can just iterate
through.

It was the navbar that kept me awake for hours on end. It was such an irriatting
issue that I actually included a detailed explanation in the code, increasing
the file size of the theme (which was against the stated goals) in exchange for
actually explaining what's going on.

Throughout most of this project, I was actually copying minima and its conventions.
I did this because it's the default theme for github pages. The people who
designed that presumably know better than me about the inner operations of
Jekyll and are able to better determine where things should go. Having said that,
it's mostly because I needed the compatability.

The algorithm for displaying the navbar is messy. I don't like it. My
implementation is slapdash and doesn't explain nearly enough of itself by
itself. The problem with displaying the navbar is that we only want certain
major pages on it. Those pages should appear automatically without further user
input. This generally saves a lot of time.

Alternatively, you could architect the navbar to work exclusively on data. I
made it so that it has an auto default behaviour and then overrides itself with
distinct header pages supplied by the user if they exist in the `_config.yml`
file. So first you have to get the file paths to all the pages on the site.
Luckily you don't have to search for them manually. The site data map has them
all there under `site.pages["path"]` so a quick `map` filter in Liquid can find
them.

Then you need to optionally ovewrite those pages with the default paths. If you
skip this step, the user has no way to hide pages they don't immediately want
visible. If I was to do this again I'd have a bit of a design think about
higher requirements. Instead of having a page only visible by its use of a
title, I'd also want to check the layout to make it just that little bit harder
to list a post by accident. Those also have titles but don't show up.

Also, you don't want to list the navbar at all if there aren't any pages with
distinct titles at all, so I want to skip that. From there it's about as easy as
iterating over all the paths you found, optionally overwritten with the defaults
that the user set. You only display paths in the navbar that have a title. You
can't filter these out to begin with.

OK, maybe you can with `where`, but it's much easier and clearer to do an if for
every single one. I'm not sure how performant that is exactly. I'd probably want
to run some tests, but at this early stage I'm not sure how.

So we have a list of posts, layouts for pages and posts as well as a navbar that
takes care of itself. What next? Honestly, it's just CSS. CSS is a name that
shall forever live on with the likes of "leviathan" and "dragon" in programming
history. Just this awful beast of a thing that doesn't like to be told what to
do.

At one point, I almost had everything set up the way I want, and then all of a
sudden... pop. All my styles disappeared. Once I introduced an actual system
in the liquid template for specifying new stylesheets through data, I went back
and introduced a whole other system for allowing the inclusion of custom
stylesheets included in the assets folder. This meant that if I want normalize
or skeleton or bootstrap I can just shunt them in there. Not that you generally
should if you can at all avoid it. The goal of this project was optimal
performance, remember?

So finally, I figure out all of the weirdness with the CSS and it turns out that
GitHub pages doesn't actually support themes like I thought they did. Drat.
So now I've got to solve even more issues with stuffing my already convuluted
knot of Jekyll includes and layouts into the git repo to force their version
to get it working. Except it doesn't work. Because my ultra-minimal approach
left out support for several key gems.

And the syntax highlighting! Rouge is fairly simple once you know what the
class names are. You can usually just download your preferred theme as an scss
file and have your way with it. But ultimately it is annoying to waste minutes
of your life setting those colours manually.

Now, finally, after two days of work with very little time for rest, you have
your own Jekyll theme. Is it worth it? I would say so. Except for the fact I
didn't sleep. I really need to keep an eye on that else I'm not going to be
around to write rediculous coding projects from now on. You can access string
theory from the official git repo, though keep in mind that the theme in this
website is basically an entirely different project at this point. I'll probably
be making further changes as I go along.

I like that I understand the inner workings of Jekyll more (I actually dug
through the source code to get some of this information), but I would have had
at least a couple more articles written by now had it not been for that. I'm
excited to write more.