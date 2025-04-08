extends Node

var music_player: AudioStreamPlayer

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music" # Use your preferred bus name
	
func play_music(stream: AudioStream) -> void:
	if music_player.stream == stream and music_player.playing:
		return # Already playing this music
		
	music_player.stream = stream
	music_player.play()
	
func stop_music() -> void:
	music_player.stop()
	
func set_paused(paused: bool) -> void:
	music_player.stream_paused = paused
