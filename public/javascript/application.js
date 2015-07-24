$(document).ready(function() {

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()

  $(window).bind('keydown', event, move);

  function insertTiles(message){
    // console.log("hello", message);
    // document.getElementsByTagName("body")[0].appendChild(message);
    $('.map_wrapper').remove();
    $('.inventory_wrapper').remove();
    $('body').append(message);
    $('.tile_row')[1].children[1].className += " player"

  }

  function move(e)
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
        dataType: "text",
        success: insertTiles
      });
       
    }
    if(e.keyCode == left){
      ajax('left');
    }else
    if(e.keyCode == right){
      ajax('right');
    }else
    if(e.keyCode == up){
      ajax('up');
    }else
    if(e.keyCode == down){
      ajax('down');
    }


    // console.log(event);
  }
});
