$(document).ready(function() {

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()

  $(window).bind('keydown', event, move);

  function move(event)
  {
    var left = 37,
        right = 39,
        up = 38,
        down = 40;

    function ajax(dir)
    {
      console.log(dir);
      var request = $.ajax({
        url: "/move",
        method: "POST",
        data: "dir=" + dir,
        dataType: "text"
      });
       
    }
    switch (event.keyCode){
      case left:
        ajax('left')
      case right:

      case up:

      case down:
    }


    // console.log(event);
  }
});
