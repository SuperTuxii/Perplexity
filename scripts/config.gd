extends Node

signal server_files_changed

var server_files: Dictionary = {
	"Server": {
		"unlock_file": {
			"type": "executable",
			"size": "1,2KB",
			"modified": "Today",
			"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	var unlock_code_exec: UnlockCode = preload("res://scenes/monitor_scenes/file_executables/unlock_code.tscn").instantiate()
	unlock_code_exec.correct_code = "1234"
	unlock_code_exec.data = data
	return unlock_code_exec
		},
		"give_me_a_hint_file": {
			"type": "executable",
			"size": "923B",
			"modified": "Today",
			"title": "give_me_a_hint_title",
			"value": func run(_path: String, _data: Dictionary) -> ScreenPopup:
	var hint: ScreenPopupText = preload("res://scenes/monitor_scenes/screen_popup_text.tscn").instantiate()
	hint.text = "tutorial_hint"
	return hint
		},
		"notes_file": {
			"type": "text_edit",
			"size": "0B",
			"modified": "Today",
			"title": "notes_title",
			"value": ""
		},
		"tutorial_folder": {
			"type": "folder",
			"size": "1",
			"size_unit": "item",
			"modified": "Today",
			"value": {
				"code_file": {
					"type": "text",
					"size": "8B",
					"modified": "Today",
					"title": "code_title",
					"value": "1234"
				}
			}
		}
	},
	"Server 1A": {
		"tutorial_file": {
			"type": "text",
			"size": "514B",
			"modified": "Today",
			"width": 400,
			"height": 400,
			"title": "tutorial_title",
			"value": "In every hacked server you will find an \"unlock\" executable. [i]It is useful to run this first, so you know what you need to unlock the server (In this case it is a 4 digit code).[/i]\nTo find whatever is needed to unlock the server, you should investigate the files that can be found on this or previous servers. [i]The \"modified\" property for every file may hint at what files are important, but don't trust it too much![/i]\nIf you've got no clue what to do next, you may click the \"give me a hint\" executable to receive a hint (hints don't give you the answer directly and you will still need to use your brain)."
		},
		"unlock_file": {
			"type": "executable",
			"size": "1,2KB",
			"modified": "Today",
			"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	var unlock_exec: UnlockCode = preload("res://scenes/monitor_scenes/file_executables/unlock_code.tscn").instantiate()
	unlock_exec.correct_code = "3518"
	unlock_exec.data = data
	return unlock_exec
		},
		"give_me_a_hint_file": {
			"type": "executable",
			"size": "923B",
			"modified": "Today",
			"title": "give_me_a_hint_title",
			"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	var hints_exec: HintsLvl1 = preload("res://scenes/monitor_scenes/file_executables/hints_lvl1.tscn").instantiate()
	hints_exec.data = data
	return hints_exec
		},
		"notes_file": {
			"type": "text_edit",
			"size": "0B",
			"modified": "Today",
			"title": "notes_title",
			"value": ""
		},
		"code_file": {
			"type": "image",
			"size": "4,8KB",
			"modified": "Today",
			"title": "code_title",
			"value": "res://assets/textures/server_1a/code.svg"
		},
		"reports": {
			"type": "folder",
			"size": "3",
			"size_unit": "items",
			"modified": "Today",
			"value": {
				"report-45": {
					"type": "image",
					"size": "7,1KB",
					"modified": "Last month",
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
		"unlock_file": {
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
		"give_me_a_hint_file": {
			"type": "executable",
			"size": "923B",
			"modified": "Today",
			"title": "give_me_a_hint_title",
			"value": func run(_path: String, data: Dictionary) -> ScreenPopup:
	var hints_exec: HintsLvl2 = preload("res://scenes/monitor_scenes/file_executables/hints_lvl2.tscn").instantiate()
	hints_exec.data = data
	return hints_exec
		},
		"notes_file": {
			"type": "text_edit",
			"size": "0B",
			"modified": "Today",
			"title": "notes_title",
			"value": ""
		},
		"code_file": {
			"type": "image",
			"size": "4,8KB",
			"modified": "Today",
			"title": "code_title",
			"value": "res://assets/textures/server_2a/code.svg"
		},
		"staff": {
			"type": "folder",
			"size": "8",
			"size_unit": "items",
			"modified": "6 months ago",
			"value": {
				"staff-0": {
					"type": "staff",
					"size": "658B",
					"modified": "Last year",
					"profile_color": Color.DIM_GRAY,
					"name": "Thomas",
					"job_title": "Owner",
					"department": "Owner",
					"superior": "---",
					"telephone": "000",
					"responsibilities": "- [color=" + ScreenPopupStaff.apply_color_shader(Color.RED).to_html() + "]leadership[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.YELLOW).to_html() + "]planning[/color]\n4 [color=" + ScreenPopupStaff.apply_color_shader(Color.BLUE).to_html() + "]financial management[/color]",
					"qualifications": "- [color=" + ScreenPopupStaff.apply_color_shader(Color.CYAN).to_html() + "]interpersonal skills[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.GREEN).to_html() + "]leadership[/color]\n4 [color=" + ScreenPopupStaff.apply_color_shader(Color.MAGENTA).to_html() + "]creativity[/color]"
				},
				"staff-3": {
					"type": "staff",
					"size": "679B",
					"modified": "Last year",
					"profile_color": Color.DARK_GRAY,
					"name": "Sharyl",
					"job_title": "HR Manager",
					"department": "HR",
					"superior": "Thomas",
					"telephone": "010",
					"responsibilities": "1 [color=" + ScreenPopupStaff.apply_color_shader(Color.CYAN).to_html() + "]managing employees[/color]\n3 [color=" + ScreenPopupStaff.apply_color_shader(Color.MAGENTA).to_html() + "]record keeping[/color]\n4 [color=" + ScreenPopupStaff.apply_color_shader(Color.RED).to_html() + "]health and safety[/color]",
					"qualifications": "1 interpersonal skills\n3 coaching\n4 skills management"
				},
				"staff-5": {
					"type": "staff",
					"size": "873B",
					"modified": "Last year",
					"profile_color": Color.DARK_GRAY,
					"name": "Michelle",
					"job_title": "Manager",
					"department": "Management",
					"superior": "Sharyl",
					"telephone": "021",
					"responsibilities": "1 [color=" + ScreenPopupStaff.apply_color_shader(Color.GREEN).to_html() + "]setting goals[/color]\n3 [color=" + ScreenPopupStaff.apply_color_shader(Color.GREEN).to_html() + "]delegating tasks[/color]\n4 [color=" + ScreenPopupStaff.apply_color_shader(Color.INDIGO).to_html() + "]leading a team[/color]",
					"qualifications": "1 [color=" + ScreenPopupStaff.apply_color_shader(Color.RED).to_html() + "]communication[/color]\n3 [color=" + ScreenPopupStaff.apply_color_shader(Color.MAGENTA).to_html() + "]leadership[/color]\n4 [color=" + ScreenPopupStaff.apply_color_shader(Color.ORANGE).to_html() + "]time management[/color]"
				},
				"staff-13": {
					"type": "staff",
					"size": "591B",
					"modified": "10 months ago",
					"profile_color": Color.WHITE,
					"name": "John",
					"job_title": "Janitor",
					"department": "Building",
					"superior": "Michelle",
					"telephone": "801",
					"responsibilities": "- maintenance\n- supply\n- cleaning",
					"qualifications": "- physical stamina\n- cleaning knowledge\n- safety awareness"
				},
				"staff-14": {
					"type": "staff",
					"size": "688B",
					"modified": "9 months ago",
					"profile_color": Color.GRAY,
					"name": "James",
					"job_title": "IT Supporter",
					"department": "IT",
					"superior": "Michelle",
					"telephone": "174",
					"responsibilities": "- support\n- system management\n- configuring hardware",
					"qualifications": "- communication\n- problem solving\n- hardware knowledge"
				},
				"staff-15": {
					"type": "staff",
					"size": "614B",
					"modified": "9 months ago",
					"profile_color": Color.GRAY,
					"name": "Bob",
					"job_title": "Developer",
					"department": "Development",
					"superior": "Michelle",
					"telephone": "236",
					"responsibilities": "- software maintenance\n- testing & debugging\n- information security",
					"qualifications": "- analytical thinking skills\n- problem solving\n- experience"
				},
				"staff-19": {
					"type": "staff",
					"size": "667B",
					"modified": "7 months ago",
					"profile_color": Color.DARK_GRAY,
					"name": "Phil",
					"job_title": "Server Guy",
					"department": "Server",
					"superior": "Michelle",
					"telephone": "139",
					"responsibilities": "- server maintenance\n- monitoring\n- security measures",
					"qualifications": "- technical skills\n- maintenance\n- problem solving"
				},
				"staff-21": {
					"type": "staff",
					"size": "529B",
					"modified": "6 months ago",
					"profile_color": Color.GRAY,
					"name": "Davin",
					"job_title": "Developer",
					"department": "Development",
					"superior": "Michelle",
					"telephone": "254",
					"responsibilities": "2 [color=" + ScreenPopupStaff.apply_color_shader(Color.CYAN).to_html() + "]customer projects[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.MAGENTA).to_html() + "]software design[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.CYAN).to_html() + "]update maintenance[/color]",
					"qualifications": "2 [color=" + ScreenPopupStaff.apply_color_shader(Color.YELLOW).to_html() + "]knowledge[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.RED).to_html() + "]problem solving[/color]\n- [color=" + ScreenPopupStaff.apply_color_shader(Color.MAGENTA).to_html() + "]analytical thinking skills[/color]"
				},
			}
		},
		"requests": {
			"type": "folder",
			"size": "4",
			"size_unit": "items",
			"modified": "Yesterday",
			"value": {
				"key_upgrade_template": {
					"type": "text",
					"size": "134B",
					"modified": "Last year",
					"width": 350,
					"height": 250,
					"value": "Name: ________\nDepartment: ________\nTelephone: ___\n\nPrevious Permissions:\n1: ____, 2: ____, 3: ____, 4: ____\nRequested Permissions:\n1: ____, 2: ____, 3: ____, 4: ____"
				},
				"request-7": {
					"type": "text",
					"size": "241B",
					"modified": "7 months ago",
					"width": 350,
					"height": 250,
					"value": "Name: James\nDepartment: IT\nTelephone: 174\n\nPrevious Permissions:\n1: star, 2: triangle, 3: -, 4: -\nRequested Permissions:\n1: star, 2: square, 3: -, 4: -"
				},
				"request-9": {
					"type": "text",
					"size": "196B",
					"modified": "This week",
					"width": 600,
					"height": 200,
					"value": "[b]Higher key permissions for server maintenance (HIGH PRIORITY)[/b]\nHey,\nthis is Phil from the Server department. I need to do some pretty urgent server maintenance. But my current key doesn't have the needed permissions for that, so could someone please upgrade my square permissions to circle?\nThanks!"
				},
				"requests-10": {
					"type": "text",
					"size": "274B",
					"modified": "Yesterday",
					"width": 300,
					"height": 350,
					"value": "[b]Janitor key no longer working[/b]\nMy electronic key stopped working today and I was told that is a big security risk and my key should be deactivated immediately. I don't know about that but make sure to deactivated it and give me a new one, I guess. In case you need it, I currently have the key permissions 1 star, 2 triangle and 4 square.\n\n[i]unresolved[/i]"
				}
			}
		}
	},
	"Server 3A": {
		"README": {
			"type": "text",
			"size": "252B",
			"modified": "Today",
			"width": 300,
			"height": 300,
			"value": "WHAT, you already finished my first puzzle!? You are really fast! I didn't expect that so I am not really finished with the next level yet. Sooo take a break and drink some water.\n[i]I'm working on adding more content/puzzles. I hope you enjoyed it this far.[/i]"
		}
	},
	"USB": {
		"README": {
			"type": "text",
			"size": "82B",
			"modified": "Today",
			"width": 300,
			"height": 150,
			"value": "There is nothing here yet. But surely in the future :)"
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
				"from_color": Color.GREEN,
				"to_color": Color.YELLOW
			},
			{
				"scope": 3,
				"from_color": Color.MAGENTA,
				"to_color": Color.BLUE
			}
		],
		"010": [
			{
				"scope": 0,
				"to_color": Color.CYAN
			},
			{
				"scope": 2,
				"to_color": Color.MAGENTA
			},
			{
				"scope": 3,
				"to_color": Color.RED
			}
		],
		"021": [
			{
				"scope": 0,
				"from_color": Color.RED,
				"to_color": Color.GREEN
			},
			{
				"scope": 2,
				"from_color": Color.MAGENTA,
				"to_color": Color.GREEN
			},
			{
				"scope": 3,
				"from_color": Color.ORANGE,
				"to_color": Color.INDIGO
			}
		],
		"801": [
			{
				"scope": 0,
				"to_shape": "star"
			},
			{
				"scope": 1,
				"to_shape": "triangle"
			},
			{
				"scope": 3,
				"to_shape": "square"
			}
		],
		"174": [
			{
				"scope": 1,
				"from_shape": "triangle",
				"to_shape": "square"
			}
		],
		"139": [
			{
				"scope": -1,
				"from_shape": "square",
				"to_shape": "circle"
			}
		],
		"254": [
			{
				"scope": 1,
				"from_color": Color.YELLOW,
				"to_color": Color.CYAN
			},
			{
				"scope": -1,
				"from_color": Color.MAGENTA,
				"to_color": Color.CYAN
			},
			{
				"scope": -1,
				"from_color": Color.RED,
				"to_color": Color.MAGENTA
			}
		]
	}
}

var level1_hints: Dictionary = {
	"triangle_hints": [
		"The digit is hidden in an image",
		"Someone reported a paper with something like this some time ago"
	],
	"circle_hints": [
		"It's hidden in a text",
		"I might have lost something with a circle some time ago"
	],
	"square_hints": [
		"It's hidden in a text",
		"There was a rumor about a man and something with a square"
	], 
	"octagon_hints": [
		"I wonder what this looks like",
		"The digit is hidden in an image",
		"It looks like a certain traffic sign"
	]
}

var level2_hints: Dictionary = {
	"shape_hints": [
		"the requests folder may contain some information",
		"try searching for related telephone numbers and observe what happens in the unlock executable when calling them",
		"if you can't find the telephone numbers, search in the staff folder for a matching staff file",
		"find out in which cases there are conditions for shape changes and what the result is\n(in unlock)",
		"use the notes file to take notes on the effects of the telephone numbers and to plan ahead"
	],
	"color_hints": [
		"the staff folder may contain some information",
		"the colors in some staff files look suspicious",
		"try searching for related telephone numbers and observe what happens in the unlock executable when calling them",
		"don't get lost with the details at the top of staff files. Only telephone, (colors of) responsibilities and qualifications are important",
		"try to find out what a number or a \"-\" in front of responsibilities/qualifications means by calling the telephone numbers of the staff",
		"what function do the colors under responsibilites vs. qualifications have and which colors belong together?",
		"use the notes file to take notes on the effects of the telephone numbers and to plan ahead"
	]
}
