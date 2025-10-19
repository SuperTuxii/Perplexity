extends Node

signal server_files_changed

var server_files: Dictionary = {
	"Server": {
		"unlock": {
			"type": "executable",
			"size": "1,2KB",
			"modified": "Today",
			"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	var unlock_code_exec: UnlockCode = preload("res://scenes/monitor_scenes/file_executables/unlock_code.tscn").instantiate()
	unlock_code_exec.correct_code = "1234"
	unlock_code_exec.data = data
	return unlock_code_exec
		},
		"give me a hint": {
			"type": "executable",
			"size": "923B",
			"modified": "Today",
			"title": "Hint",
			"value": func run(_path: String, _data: Dictionary) -> ScreenPopup:
	var hint: ScreenPopupText = preload("res://scenes/monitor_scenes/screen_popup_text.tscn").instantiate()
	hint.text = "There might be something in that folder"
	return hint
		},
		"notes": {
			"type": "text_edit",
			"size": "0B",
			"modified": "Today",
			"title": "Notes",
			"value": ""
		},
		"folder": {
			"type": "folder",
			"size": "1 item",
			"modified": "Today",
			"value": {
				"code": {
					"type": "text",
					"size": "8B",
					"modified": "Today",
					"title": "Code",
					"value": "1234"
				}
			}
		}
	},
	"Server 1A": {
		"tutorial": {
			"type": "text",
			"size": "514B",
			"modified": "Today",
			"width": 400,
			"height": 400,
			"title": "Tutorial",
			"value": "In every hacked server you will find an \"unlock\" executable. [i]It is useful to run this first, so you know what you need to unlock the server (In this case it is a 4 digit code).[/i]\nTo find whatever is needed to unlock the server, you should investigate the files that can be found on this or previous servers. [i]The \"modified\" property for every file may hint at what files are important, but don't trust it too much![/i]\nIf you've got no clue what to do next, you may click the \"give me a hint\" executable to receive a hint (hints don't give you the answer directly and you will still need to use your brain)."
		},
		"unlock": {
			"type": "executable",
			"size": "1,2KB",
			"modified": "Today",
			"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	var unlock_exec: UnlockCode = preload("res://scenes/monitor_scenes/file_executables/unlock_code.tscn").instantiate()
	unlock_exec.correct_code = "3518"
	unlock_exec.data = data
	return unlock_exec
		},
		"give me a hint": {
			"type": "executable",
			"size": "923B",
			"modified": "Today",
			"title": "Hint",
			"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	var hints_exec: HintsLvl1 = preload("res://scenes/monitor_scenes/file_executables/hints_lvl1.tscn").instantiate()
	hints_exec.data = data
	return hints_exec
		},
		"notes": {
			"type": "text_edit",
			"size": "0B",
			"modified": "Today",
			"title": "Notes",
			"value": ""
		},
		"code": {
			"type": "image",
			"size": "4,8KB",
			"modified": "Today",
			"title": "Code",
			"value": "res://assets/textures/server_1a/code.svg"
		},
		"reports": {
			"type": "folder",
			"size": "3 items",
			"modified": "Today",
			"value": {
				"report-45": {
					"type": "image",
					"size": "7,1KB",
					"modified": "Last Month",
					"value": "res://assets/textures/server_1a/report-45.png"
				},
				"report-58": {
					"type": "text",
					"size": "193B",
					"modified": "2 weeks ago",
					"width": 300,
					"height": 300,
					"value": "The kitchen service wasn't done yesterday, but I also haven't seen the employee that was in charge of it yesterday for quite some time. Is he even still part of this company? Would be nice to know so I could update the plan if that is the case."
				},
				"report-83": {
					"type": "text",
					"size": "231B",
					"modified": "Last week",
					"width": 300,
					"height": 350,
					"value": "There is a creepy looking person in front of the company building! They suddenly came out of nowhere and told me: \"The square is the file size's last digit\". I have no idea what that is supposed to mean, but I am reporting this, because they looked like a security risk and so that we know this happened once already if this were to happen again."
				},
				"report-87": {
					"type": "text",
					"size": "126B",
					"modified": "Last week",
					"width": 300,
					"height": 200,
					"value": "HELP, my pc won't turn on. Is there anyone who can help me? If that is the case please come over to my desk and I promise I won't be too much of a pain."
				},
				"report-90": {
					"type": "text",
					"size": "196B",
					"modified": "Last week",
					"width": 300,
					"height": 300,
					"value": "I just came in and noticed some random piece of paper on my desk. It has a circle and the number 5 on it. In case anyone lost it, I will keep it till the end of the week, so come and get it from me. I would love to know how it got there and what you were doing at my desk ^^."
				},
				"report-99": {
					"type": "text",
					"size": "153B",
					"modified": "3 days ago",
					"width": 300,
					"height": 200,
					"value": "Good morning,\nI think I lost my USB Stick. In case anyone spots a blue USB Stick please return it to me. Thanks in advance."
				},
				"report-103": {
					"type": "image",
					"size": "12,8KB",
					"modified": "Today",
					"value": "res://assets/textures/server_1a/report-103.png"
				},
				"report-107": {
					"type": "text",
					"size": "134B",
					"modified": "Yesterday",
					"width": 300,
					"height": 350,
					"value": "The toilet on the south side of the second floor is clogged again. The janitor isn't available, so in the meantime don't try to flush that toilet under any circumstances! The reason probably is that the cleaning people keep emptying their buckets in the toilets even though they were told multiple times not to do that. Maybe someone should tell them again, but I doubt that it will help."
				}
			}
		}
	},
	"Server 2A": {
		"README": {
			"type": "text",
			"size": "252B",
			"modified": "Today",
			"width": 300,
			"height": 300,
			"value": "WHAT, you already finished my first puzzle!? You are really fast! I didn't expect that so I am not really finished with the next level yet. Sooo take a break and drink some water.\n[i]I'm working on adding more content/puzzles and finishing this level, because at the moment you can't complete it. I hope you enjoyed it this far.[/i]"
		},
		"unlock": {
			"type": "executable",
			"size": "1,2KB",
			"modified": "Today",
			"current_shapes": [ "circle", "star", "hexagon", "triangle" ],
			"current_colors": [ Color.CYAN, Color.GREEN, Color.MAGENTA, Color.RED ],
			"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	var unlock_exec: UnlockSymbolCombination = preload("res://scenes/monitor_scenes/file_executables/unlock_symbol_combination.tscn").instantiate()
	unlock_exec.correct_shapes = [ "star", "square", "hexagon", "circle" ]
	unlock_exec.correct_colors = [ Color.GREEN, Color.CYAN, Color.YELLOW, Color.BLUE ]
	unlock_exec.data = data
	return unlock_exec
		},
		"give me a hint": {
			"type": "text",
			#"type": "executable",
			"size": "923B",
			"modified": "Today",
			"title": "Hint",
			"value": "Coming soon"
			#"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	#var hints_exec: HintsLvl1 = preload("res://scenes/monitor_scenes/file_executables/hints_lvl1.tscn").instantiate()
	#hints_exec.data = data
	#return hints_exec
		},
		"notes": {
			"type": "text_edit",
			"size": "0B",
			"modified": "Today",
			"title": "Notes",
			"value": ""
		},
		"code": {
			"type": "image",
			"size": "4,8KB",
			"modified": "Today",
			"title": "Code",
			"value": "res://assets/textures/server_2a/code.svg"
		},
		"staff": {
			"type": "folder",
			"size": "3 items",
			"modified": "Today",
			"value": {
				"staff-0": {
					"type": "staff",
					"size": "3,2KB",
					"modified": "Last Year",
					"profile_color": Color.DIM_GRAY,
					"name": "Bob",
					"job_title": "Owner",
					"department": "Owner",
					"superior": "---",
					"telephone": "000",
					"responsibilities": "- [color=" + ScreenPopupStaff.apply_color_shader(Color.RED).to_html() + "]leadership[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.GREEN).to_html() + "]planning[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.MAGENTA).to_html() + "]financial management[/color]",
					"qualifications": "- [color=" + ScreenPopupStaff.apply_color_shader(Color.CYAN).to_html() + "]interpersonal skills[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.YELLOW).to_html() + "]leadership[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.BLUE).to_html() + "]creativity[/color]"
				}
			}
		}
	}
}:
	set(value):
		server_files = value
		server_files_changed.emit()

var telephone_actions: Dictionary = {
	"Server 2A": {
		"000": [
			{
				"scope": -1,
				"from_color": Color.CYAN,
				"to_color": Color.RED
			},
			{
				"scope": -1,
				"from_color": Color.YELLOW,
				"to_color": Color.GREEN
			},
			{
				"scope": -1,
				"from_color": Color.BLUE,
				"to_color": Color.MAGENTA
			}
		]
	}
}
