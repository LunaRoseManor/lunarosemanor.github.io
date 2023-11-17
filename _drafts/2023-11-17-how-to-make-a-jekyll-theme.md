---
layout: post
title: How to Make a Jekyll Theme
---

Generally speaking, you shouldn't.

There are already [dozens available](https://jekyllrb.com/docs/themes). Just because a solution
[wasn't invented here](https://en.wikipedia.org/wiki/Not_invented_here) doesn't
make it lesser. Your aim should be to become a writer, not a theme developer.
If you have a mind like mine however, that's not an acceptable answer.
You don't just want to avoid learning about a topic like this, you want to know
it. It's from this line of thinking that I came up with the idea for
[String Theory](https://github.com/LunaRoseManor/string-theory). It's my answer
to the question...

> '...what's the smallest possible Jekyll theme?'

As it turns out, it's not that small. Around 10 KB when it had all the features
I would consider necessary given Jekyll's core feature set. I want to go into
more detail about the challenges I faced in case anyone else needs help with it.

# Goals
I had three key goals going into this project:

- Speed
- Style
- Simplicity

In that order. I didn't need a lot of functionality and people's attention span
is limited. I needed something that I could show off on a typical mobile phone
signal as quickly as possible. But I also wanted it to look a bit easier on
the eyes than [this](https://info.cern.ch/hypertext/WWW/TheProject.html). Since
I didn't know how to write my own, I used a couple of already released
themes as reference for what a new user might expect. Luckily the code used for
themes like [minima](https://github.com/jekyll/minima) is relatively small, if
a little sparsely documented. Though it towers over the default files included
with the `Jekyll new theme` command, primarily because of the plugins included.

# Speed
Most people's computers, network connections and browsers are enough to handle
very simple websites. The problems start when you realise that we don't all
use the same hardware and software to look at them, and they're not lookers to
begin with. In the before times, I would reach for frameworks and get to work
elsewhere. This works for some applications and not for others. For example,
[normalize.css](https://necolas.github.io/normalize.css/) is around 6 KB.
[Skeleton](https://http://getskeleton.com/) is around 10 KB when zipped. If you
want to go truly fast, you want to avoid as many micro-dependencies as possible.

This goes double for functionality. Sure, having comments on your blog posts is
cool and all, but if you have to pull in jQuery *and* the Disqus library to do
it, was it really worth it? I don't think so. I would also say that custom
typefaces aren't worth the hassle, since the user will almost certainly not
have them on their system and need to drag it by the feet to their memory card.

Less is more.

# Style
This is in direct competition with the first design goal. The more "cool" a
website looks, the more markup and styles are required to support it. At the
same time, I get genuinely uncomfortable looking at sites that show a wanton
disregard for size and spacing, so there's a balance that needs to be struck.
It needs to be just the right amount of visual design to stand out and focused
enough to get the job done. "Getting the job done" here to me would be:

- A centralised layout
- With wide, responsive margins
- That has imperfect contrast
- Given to text accessible to all

Luckily, most of this stuff is pretty routine and doable.
[Centering things in CSS](https://www.w3.org/Style/Examples/007/center.en.html)
has and continues to be a pain for the foreseeable future, but it's mostly plain
sailing from there. [The box model](https://www.w3schools.com/Css/css_boxmodel.asp)
aside, it only takes about ~40 lines of code to get what you see here. I cut out
a lot of bloat by refusing to use media queries and focusing solely on desktops.

# Simplicity
The tricky part. Jekyll's core feature set is pretty feature rich, even without
plugins. This means if you're starting from scratch, you've got to work within
the same assumptions. For String Theory I decided to only go with things that
were in minima. That way, there'd be nothing lost or added between themes. Only
problem is that GitHub pages (where this site is currently hosted) assumes that
you want analytics and search engine optimization.

## Layouts
The handbook states clearly that you should create a default layout that all
other layouts inherit from. This allows you to use included files to get ahold
of the header and footer while keeping the “ of the document consistent.
Here I opted to basically copy what minima was doing. `/_layouts/default.html`
contains all the boilerplate code for pages including the doc type and schema.
`/_layouts/post.html` tailors that layout specifically to blog posts, including
information about the author and when it was written. I also created a layout
for pages more broadly. Since the existence of
[front matter](https://jekyllrb.com/docs/front-matter/)
is how Jekyll determines which files should be copied and built to the public
layout, any new files you add will be totally blank unless you explicitly
[configure one](https://jekyllrb.com/docs/configuration/front-matter-defaults/).

## Post Listings
Minima's default behaviour is to shove every post into a big list and stick it
on the home page. It also optionally paginates, something that's
[well documented](https://jekyllrb.com/docs/pagination/#enable-pagination).
However if you want more complex behaviour like having each post fall under the
year of its release, then you'll have to spend time sorting through the data
until you get what you need.

## Navigation Bar
This one had me stumped for hours. The idea itself is simple. Anchor tags don't
nest by default, so all you need to do is iterate through the global list of
pages and find ones that aren't for site structure. Except it doesn't really 
work that way. I wrote the code for the navbar several times leading up to this
post. At some point, I may have to write it again. The problem is that if you
just include every page in the navigation bar's iteration step, then you run the
risk of including things that aren't meant to be distinct pages. You don't give
the user enough control over their layout.

Minima has the right idea. Only adding pages to the navbar by default that
have titles and giving you the option to overwrite them with data. But actually
understanding *how* that's supposed to work requires looking at the
[source code](https://github.com/jekyll/minima/blob/master/_includes/header.html).
The actual snippet contains a lot of content that isn't actually useful to
understanding what's going on, so let's fix that:

```html
{%- assign default_paths = site.pages | map: "path" -%}
{%- assign page_paths = site.header_pages | default: default_paths -%}
{%- assign titles_size = site.pages | map: 'title' | join: '' | size -%}

{%- if titles_size > 0 -%}
    <nav class="site-nav">
    {%- for path in page_paths -%}
        {%- assign my_page = site.pages | where: "path", path | first -%}
        {%- if my_page.title -%}
            <a class="page-link" href="{{ my_page.url | relative_url }}">{{ my_page title | escape }}</a>
        {%- endif -%}
    {%- endfor -%}
    </nav>
{%- endif -%}
```

Now that it's finally cleaned up, you can see that the first line is obtaining
a list of all the file paths related to pages included in the site. This means
that when the second line attempts to find a list of headings from the
`_config.yml` file, there's a chance to use those to inform the navbar instead.
Some themes just skip the attempt to automatically find content and just get it
from data. I'd much prefer to not have something else to remember.
The next part is tricky to understand because it goes over two lines. You don't
want to throw any errors by trying to render data that isn't there.

The way this gets fixed is to create a string that concatenates all of the
titles of each page together. This gives a much clearer picture of whether pages
with titles exist, because if you obtain the list through `map` a site with no
titled pages will have a length greater than zero. This is possible because
any pages that don't have titles still get scraped by this code, they'll just
return `null`.

Finally, you iterate over the paths and not the pages themselves, because
otherwise you don't have any way of filtering them and all references to the
config file will be rendered moot.

The fact I have to do so much to explain this code probably means it's better to
rely on data to figure out what pages should be included in the navigation bar.
If there's a more readable way to implement this behaviour, I don't see it.

# Success?
Ultimately, I ended up having to throw out most of the code I'd written for
String Theory.