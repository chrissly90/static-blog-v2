## Youtube without all that tracking shit? That works. With [invidio.us](https://invidio.us/).

Youtube is the treasure trove for everything from crochet instructions to the Metallica concert. A whole youth culture is based on the heroes of the platform. "Youtuber" has become a serious career wish.

But all these beautiful videos in the hands of a single company? Youtube belongs to Google. Google's business model is to log, analyse and exploit people's behaviour. If you don't want that, you will miss a lot of great things on Youtube.

With [invidio.us](https://invidio.us/) there is a service that switches between Youtube and the user. First of all it is an alternative user interface. You can browse all videos on Youtube and play them there - undisturbed by advertising.

Normally the videos are then played directly from the Youtube server. In the [settings](https://invidio.us/preferences), however, you can specify that a proxy is used. Then another server will download the video. From there it is played. Of course, this always takes a little longer. But then Google doesn't get to see anything anymore from me as a user.

Additionally [invidio.us](https://invidio.us/preferences) offers the possibility to download the videos in different qualities and formats. The "List" mode is also practical. Then only the sound is streamed. Who used Youtube so far as Internet radio, can save so bandwidth. And if you have fallen in love with a song, you can simply play it in loop.

## Alternatives

If [invidio.us](https://invidio.us/) is too slow, there are [more installations](https://github.com/omarroth/invidious/wiki/Invidious-Instances#list-of-public-invidious-instances). Because Invidious is free software. If you want, you can even install it yourself.

In my case [invidious.snopyta.org](https://invidious.snopyta.org/) works with the server in Germany for example faster than the .us original.

## Firefox Plugins

[invidio.us](https://invidio.us/) uses the same URL structure as youtube. So you only have to replace youtube.com with invido.us in the URL https://www.youtube.com/watch?v=_VTwPSO1CPc and you come out with the [same video](https://invidio.us/watch?v=_VTwPSO1CPc).

The Firefox plugin [Invidious Redirect](https://addons.mozilla.org/de/firefox/addon/hooktube-redirect/?src=search) takes advantage of this. The plugin automatically replaces all Youtube links with invidio.us links. So if you want to avoid Youtube, you can do it this way and there are hardly any disadvantages.

The plugin Invidious Embed also replaces embedded Youtube videos with invidious versions.

Alternatively to the two plugins there is a script for the [Greasemonkey](https://addons.mozilla.org/de/firefox/addon/greasemonkey/?src=search) plugin. With ["Youtube to Invidious"](https://greasyfork.org/en/scripts/375264-youtube-to-invidious) you can redirect links as well as embeds and you can configure your own favorite invidious instance in the clear source code.

## WordPress Embed

Of course, the videos can also be embedded in WordPress articles. All you have to do is [activate](https://gist.github.com/ngm/868e7ae1617fd41a185eddc4599681f0) the embeds.
