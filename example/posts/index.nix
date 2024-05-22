{
  pkgs,
  ...
} @ entryArgs: let
  inherit (pkgs) lib;
  inherit (lib.lists) map;
  inherit (lib.strings) concatStrings;
in {
  template = "base";
  file = "posts/index.html";

  head = /*html*/''
    <title>nte posts</title>
    <link rel="stylesheet" href="/posts/index.css" />
  '';

  body = let
    postItem = post: /*html*/''
      <div class="post-item">
        <div class="post-title">
          <a href="/${post.file}"><h2>${post.title}</h2></a>
        </div>
        <h3>${post.created}</h3>
      </div>
    '';
  in /*html*/''
    <div id="posts">
      ${concatStrings (map (postFile: postItem ((import postFile) entryArgs))
        [
          ./test.nix
        ]
      )}
    </div>
  '';
}
