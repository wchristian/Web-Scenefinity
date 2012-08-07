var player;
var default_id = "svGk_pF67gc";
var playlist = [];
var current_id;
var playlist_is_updating;

function onYouTubePlayerReady(player_id) {
    player = document.getElementById(player_id);
    player.addEventListener("onStateChange", "on_yt_state_change");
    update_playlist();
}

function on_yt_state_change(new_state) {
    if (new_state != 0) return;
    play_next_video();
}

function play_next_video() {
    var next_id = playlist.shift();
    if (!next_id) next_id = default_id;
    player.loadVideoById(next_id);
    update_playlist();
}

function update_playlist() {
    if (playlist.length > 5) return;
    if (playlist_is_updating) return;

    playlist_is_updating = 1;

    $.get('/more_demos', function(data) {
        playlist = playlist.concat(data);
        playlist_is_updating = 0;
    }, "json").error(function(jqXHR, textStatus, errorThrown) {
        alert(textStatus + " : " + errorThrown + " :\n" + jqXHR.responseText);
        playlist_is_updating = 0;
    });
}