$(document).ready(function() {

  $('#leave_message').bind('click', event, leaveMessage);
  $(window).bind('keydown', event, move);
  function insertTiles(message){
    $('.outer_game_wrapper').empty();
    $('.outer_game_wrapper').append(message);
    $('.tile_row')[1].children[1].className += " player";
  }
  function ajax(data, route, callBack)
  {
    var request = $.ajax({
      url: route,
      method: "POST",
      data: data,
      dataType: "text",
      success: callBack
    });
  }

  function leaveMessage(e)
  {
    var message = $('#message_text').text();
    data = "message=" + message;
    ajax(data, '/game/leave_message');
    $('#message_text').text('z');
  }

  function move(e)
  {
    var left = 37,
        right = 39,
        up = 38,
        down = 40;
    if(e.keyCode == left){
      ajax('dir=left', '/game/move', insertTiles);
    }else
    if(e.keyCode == right){
      ajax('dir=right', '/game/move', insertTiles);
    }else
    if(e.keyCode == up){
      ajax('dir=up', '/game/move', insertTiles);
    }else
    if(e.keyCode == down){
      ajax('dir=down', '/game/move', insertTiles);
    }
  }
});
