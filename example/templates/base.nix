{
  body,
  head,
  ...
}: {
  name = "base";

  output = /*html*/''
    <html>
      <head>
        <link rel="stylesheet" href="/base.css" />
        ${head}
      </head>
      <body>
        <div id="navigation">
          <a href="/">./</a>
          <hr/>
          <a href="/posts/index.html">./posts</a>
        </div>
        <hr/>
        ${body}
      </body>
    </html>
  '';
}
