{
  title,
  author,
  created,
  content,
  ...
}: {
  name = "post";

  output = {
    template = "base";

    head = /*html*/''
      <title>${title}</title>
      <link rel="stylesheet" href="/posts/post.css" />
    '';
    body = /*html*/''
      <div id="metadata">
        <h1>${title}</h1>
        <div id="less-metadata">
          <h4>${author} | published: ${created}</h4>
        </div>
      </div>

      <hr/>

      <div id="content">
        ${content}
      </div>
    '';
  };
}
