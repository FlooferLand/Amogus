extends Node

# Variables
var savefile_directory = OS.get_user_data_dir()
const bug_submission_url      := "https://gamejolt.com/p/bug-glitch-submission-post-mxegw4xf"
const speedrun_submission_url := "https://gamejolt.com/p/official-speedrun-submission-post-nrptj9hf"
const gamejolt_profile        := "https://gamejolt.com/@FlooferLand"
const leonz_youtube           := "https://www.youtube.com/c/Leonz1"

# Version stuff
const version := "1.2.0"
var changelog := {
	"1.0.0": {
		"name": "Official release!",
		"changes": ["The first release of the game!"]
	},
	"1.1.0": {
		"name": "The Dababy update!",
		"changes": [
			"Added the Dababy difficulty",
			"Added a changelog section",
			"Implemented the settings menu [i](in-game only)[/i]",
			"Added a save file" \
			+ "\n[i]The file only gets created once you start the game, it's stored in " + Global.bb_link(savefile_directory) + "[/i]",
			"Improved player movement on slopes",
			"Made player movement feel smoother",
			"Fixed some bugs regarding the player's hitbox",
			"Made stuff pixel-perfect [i](close enough anyway)[/i]",
			"Changed death sound effect to the Vine boom [i](kinda sus)[/i]",
			"Added cool particle effects [i](Godot's particle system is amazing tbh)[/i]",
			"Added an official speedrun submission page" + Global.bb_link(speedrun_submission_url, "(click here)"),
			"Added a bug reporting page" + Global.bb_link(bug_submission_url, "(click here)"),
			"Other stuff i forgor " + Global.bb_emoji("skull")
		]
	},
	"1.1.4": {
		"name": "Important v1.1.0 bug fixes",
		"changes": [
			"Fixed a bug where the speedrun timer was reset when the player died and respawned using a checkpoint [i](This caused an issue where you could place a checkpoint at the end of the map, die, and respawn and complete the game in an extremely short amount of time)[/i]",
			"Fixed broken in-game touchscreen buttons",
			"Added the game's version to the end screen [i]NOTE: Speedruns using a version older than 1.1.4 might not be approved due to the bugs that were present in the previous versions.[/i]",
			"Added in a debug mode, allowing me to fly around to test stuff [i](not available unless you're running a debug build of the game)[/i]",
			"Made UI more touch-friendly",
			"Made it so the save file only gets created once you change a setting in the settings menu",
		]
	},
	"1.2.0": {
		"name": "General enhancements",
		"changes": [
			"Redesigned the UI",
			"Added a fancy camera zoom in/out effect calculated using player velocity",
			"Extended the map by a lil bit",
			"Added in some base components for a level editor [i](not available to the public yet!)[/i]",
			"Added in a cutscene at the start of the game because yes. [i](it can be skipped by pressing any key)[/i]",
			"Fixed a bug where the player could place a checkpoint right after they died",
			"Changed the minimum window size from [code]1000x600[/code] to [code]1100x800[/code] because not even your grandma uses that low of a screen resolution " + Global.bb_emoji("stare"),
			"Made player velocity 0 when the player hits a wall",
			"Made player movement a tiny bit harder [i](still a rage game after-all, some previous changes accidentally made the player movement easier)[/i]",
			"Made the player be able to jump a few frames after they ran off a platform [i](this fixed an issue where the jump button wouldn't work sometimes)[/i]",
			"Made the player actually crouch when the crouch button is held [i](Wow!!)[/i]",
			"Added in some fancy post-processing effects",
			"Fixed player animations glitching out on ledges by using [code]move_and_slide_with_snap[/code] instead of [code]move_and_slide[/code]",
			"Changed up the tileset [i](Added new tiles, and adjusted previous tiles)[/i]",
			"Added some hidden trololololo features " + Global.bb_emoji("kekw"),
			"Fixed a bug where the player gained negative momentum when running and jumping to the left [i](Might still be broken? I'm honestly not sure)[/i]",
			"Added in extra settings, allowing you to change the volume of music and sound effects, and etc",
			"Added in framerate capping [i](lowers GPU usage)[/i], it can be toggled in the settings.",
			"Fixed a bug where the settings didn't save 50% of the time when quiting the game by adding in a separate \"Save settings\" button.",
			"Added in the ability to pogo [i](you can continuously jump if you just hold the jump button)[/i]",
			"Added/fixed some other small things i forgot to list.",
			"Fixed a bug where you could spam R to constantly reset, which allowed the camera to zoom out enough for you to see the entire map " + Global.bb_emoji("skull")
		]
	}
}

# Other variables
var version_name: String = changelog[version].name
