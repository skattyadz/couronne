var socket;
var gotBalls = false;

function setup(){
  connect();
  setInterval(tick,10);

  $(document).keypress(function(e){
    var char = String.fromCharCode(e.keyCode);
    socket.send(char);
  });
};

function send(string){
  socket.send(string);
}

function connect(){
  socket = new WebSocket('ws://127.0.0.1:8080');
  socket.onmessage = function(mess) {
    $('#loading').hide();
    data = $.parseJSON(mess.data);
    console.log(data['type']);
    switch(data['type']){
    case 'init':
      balls = data['balls'];
      cue.x = data['cue'].x;
      cue.y = data['cue'].y;
      cue.vx = data['cue'].vx;
      cue.vy = data['cue'].vy;
      data = null;
      break;
    case 'move':
      cue.vx = data['cue'].vx;
      cue.vy = data['cue'].vy;
      data = null;
      animating = true;
      break;
    case 'sync':
      break;
    default:
      alert('bugger');
      console.log(data);
      break;
    }
  };
};

window.onload += setup();