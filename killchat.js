if (window.location.hostname === 'www.youtube.com' || window.location.hostname === 'youtube.com') {
    setTimeout(function(){
        document.getElementById("chatframe").remove();
        document.getElementById("chat").remove();
    }, 2000);
}
