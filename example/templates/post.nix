{
  title,
  author,
  created,
  content,
  ...
} @ extraArgs : let
  inherit (extraArgs) file;
in {
  name = "post";

  output = {
    template = "base";
    inherit file;

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
