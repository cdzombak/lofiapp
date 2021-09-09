if (window.location.hostname === 'www.youtube.com' || window.location.hostname === 'youtube.com') {
  var removedChatFrame = false;
  var removedChat = false;
  var ytChatInterval = setInterval(function(){
    if (document.getElementById("chatframe") !== null) {
      document.getElementById("chatframe").remove();
      removedChatFrame = true;
    }
    if (document.getElementById("chat") !== null) {
      document.getElementById("chat").remove();
      removedChat = true;
    }
    if (removedChatFrame && removedChat) {
      clearInterval(ytChatInterval);
    }
  }, 500);
}

if (window.location.hostname === 'www.lofi.cafe' || window.location.hostname === 'lofi.cafe') {
  if (window.localStorage.getItem('lowEnergyMode') === null) {
    window.localStorage.setItem('lowEnergyMode', 'true');
    window.location.reload();
  }
}
