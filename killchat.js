if (window.location.hostname === 'www.youtube.com' || window.location.hostname === 'youtube.com') {
  setInterval(function(){
    if (document.getElementById("chatframe") !== null) {
      document.getElementById("chatframe").remove();
    }
    if (document.getElementById("chat") !== null) {
      document.getElementById("chat").remove();
    }
  }, 2500);
}
