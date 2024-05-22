{
  h2,
  ...
}: {
  template = "post";
  file = "posts/test.html";

  title = "Test post (using nte)";
  author = "jacekpoz";
  created = "2024-05-22";
  content = /*html*/''
    <p>
      This is a test post on an example nte site. Feel free to read the <a href="#lorem-ipsum">lorem ipsum</a> below. Its header was generated using an additional helper function added to <code>extraArgs</code>
    </p>
    ${h2 "Lorem ipsum"}
    <p>
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas a lobortis augue. Suspendisse finibus turpis massa, eget aliquam justo ultricies eu. Aliquam augue elit, vulputate ut elit a, porta imperdiet nisi. Sed suscipit sed eros a maximus. Nullam congue sit amet metus non porta. Nunc iaculis euismod orci, sed cursus eros pellentesque sed. Sed lacinia purus nec magna mattis ullamcorper. In aliquet neque sed est pharetra posuere. Donec mauris turpis, tempus at tempor eget, pellentesque nec nibh. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed volutpat orci eget justo auctor bibendum. Sed elementum odio et odio vulputate congue at eu tortor.
    </p>

    <p>
      Morbi eget volutpat justo. Maecenas erat ante, interdum non odio nec, sagittis tristique orci. Ut pulvinar sem vitae odio dictum facilisis. Vestibulum sit amet tristique eros. Phasellus ac tortor arcu. In hac habitasse platea dictumst. Fusce laoreet fringilla facilisis. Vestibulum feugiat luctus elit sit amet rhoncus. Vivamus sed orci quis elit pharetra pretium eu a libero. In sed pretium ante, eget dictum augue.
    </p>

    <p>
      Maecenas odio ligula, vehicula nec eros id, rhoncus auctor ante. Sed sodales est eu sapien sollicitudin placerat. Maecenas consequat est ac condimentum faucibus. Aenean vel augue sed nunc dapibus sollicitudin. Phasellus sed nisi vel nulla aliquet pellentesque. Etiam euismod euismod felis a cursus. Morbi consequat aliquet ex, nec auctor odio varius non. Etiam finibus sem at orci semper, in volutpat odio sagittis. Etiam id mauris sit amet orci sodales tristique eget ut mauris.
    </p>

    <p>
      Vestibulum magna sem, tempor et ultricies vitae, cursus ut nunc. Ut eleifend dignissim augue, eu feugiat urna maximus nec. Praesent eget pulvinar velit, a condimentum purus. Nunc dapibus, ligula sed efficitur mattis, velit justo pharetra ipsum, eu malesuada erat erat sed orci. Integer orci orci, ultrices in ipsum et, interdum vestibulum dolor. Mauris varius tellus eu erat lobortis, et viverra ante volutpat. Nam nunc est, posuere eget bibendum tincidunt, posuere et sem. Integer egestas aliquam nibh eu viverra.
    </p>

    <p>
      Morbi in dignissim erat. Aenean non diam at libero eleifend gravida nec et lorem. Ut nibh sapien, blandit sit amet dui id, tincidunt tempor velit. Aliquam cursus libero lacus, eget pretium ligula scelerisque eget. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Integer tristique metus massa, nec auctor purus imperdiet a. Proin eu turpis quis augue mattis tempus at at dolor. Vestibulum eu justo tincidunt nibh eleifend sollicitudin at ac massa. Praesent sit amet ultricies lorem. Sed eleifend laoreet elit, ac auctor diam finibus vel. Nam iaculis felis neque, eu hendrerit ligula pellentesque in. Sed gravida lacus tempus dictum scelerisque. Ut commodo nec tellus sit amet consequat.
    </p>

    <p>
      Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras eleifend sit amet arcu id euismod. Suspendisse vel bibendum diam, ut posuere nunc. Cras eget purus sit amet ex consequat laoreet quis eget sapien. Pellentesque vel lacus mollis, fringilla lectus tristique, condimentum justo. Donec orci augue, efficitur eget dolor vitae, venenatis malesuada orci. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc eros enim, viverra sed semper ac, aliquam et odio. Curabitur a venenatis est. Praesent lacinia non enim quis gravida.
    </p>

    <p>
      Nunc porta risus a nisl commodo, in tempor est tempor. Quisque facilisis varius nunc, ac ullamcorper magna pharetra et. Aenean lectus nulla, blandit quis mi ac, bibendum convallis nunc. Proin scelerisque porttitor turpis, sed pharetra velit ullamcorper quis. Vivamus hendrerit diam ac neque commodo ornare. Curabitur hendrerit a nulla ut auctor. Nulla sed laoreet lorem. Morbi ullamcorper ipsum mollis, lobortis lectus ut, tempus lacus. Proin lobortis dui sapien, eu facilisis dui molestie at. Fusce ut suscipit nisl, nec mollis ex. Curabitur ut cursus mauris.
    </p>

    <p>
      Nulla vulputate eget sapien eget congue. Proin et gravida urna. In hendrerit posuere dolor, eget efficitur ex aliquam a. Sed tristique lacus sit amet pulvinar dignissim. Quisque volutpat mi ac posuere feugiat. Etiam elementum molestie tortor ut rhoncus. Integer at orci enim. Pellentesque malesuada, neque faucibus aliquet vehicula, ligula neque maximus mauris, non scelerisque nisl libero sit amet nibh. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.
    </p>

    <p>
      Vivamus at mattis augue, non ullamcorper diam. Ut euismod sed erat ut efficitur. Sed mollis dui sit amet ultricies rutrum. Cras sit amet justo nisl. Aliquam at orci velit. Vestibulum vel dolor ut lectus fermentum scelerisque ut ullamcorper risus. Sed diam nibh, tempor id arcu at, eleifend placerat turpis.
    </p>

    <p>
      Morbi ut bibendum mi, id finibus odio. Suspendisse commodo leo a nisi porta, sed imperdiet turpis posuere. Mauris interdum neque sit amet metus tristique semper vitae tincidunt ipsum. Phasellus bibendum nulla venenatis nisi aliquam condimentum ac eget metus. Quisque dignissim viverra interdum. Mauris non semper magna. Nam ultricies dui at lacinia fermentum. Quisque sed diam vestibulum, mollis libero eu, sollicitudin elit. Nam quis hendrerit urna, a interdum tortor. Mauris ac augue non neque malesuada eleifend. Etiam accumsan ligula hendrerit, accumsan ante id, faucibus mi. 
    </p>
  '';
}
