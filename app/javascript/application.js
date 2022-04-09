// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
function search() {
    var input, mangalist;
    input = document.getElementById("search");
    //search for manga
}

function favClick() {
    if (document.getElementById("button_fav").style.color == "#f32121") {
        document.getElementById("button_fav").style.color = "white";
        document.getElementById("button_fav").style.backgroundColor = "#f32121";
        document.querySelector("button_fav").value = "登録済み";
    } else if (document.getElementById("button_fav").style.color == "white"){
        document.getElementById("button_fav").style.color = "#f32121";
        document.getElementById("button_fav").style.backgroundColor = "white";
        document.querySelector("button_fav").value = "お気に入り登録";
    }
}

/**function openSide() {
    document.getElementById("sidemenu").style.width = "250px";
    document.getElementById("container").style.marginLeft = "250px";
    document.body.style.backgroundColor = "rgba(0,0,0,0.4)";
}

function closeSide() {
    document.getElementById("sidemenu").style.width = "0";
    document.getElementById("container").style.marginLeft= "0";
    document.body.style.backgroundColor = "white";
}**/
