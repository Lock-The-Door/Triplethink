extends Node2D

@onready var _scroll_container: ScrollContainer = get_node("Minigame/ScrollContainer")
@onready var _text_container: HFlowContainer = get_node("Minigame/ScrollContainer/TextContainer")
@onready var _score_label: Label = get_node("Minigame/GameDetails/ScoreValue")
@onready var _start_button: Button = get_node("Minigame/ScrollContainer/TextContainer/Rules/StartButton")

var truth_label: LabelSettings = preload("res://resources/truth_text_label_settings.tres")
var false_label: LabelSettings = preload("res://resources/false_text_label_settings.tres")

var started := false
var score := 0
var scroll_value := 0.0
var scroll_speeds := [100, 150, 200, 250, 300]

var root_words := ["think", "good", "speak", "free", "peace", "war", "love", "hate", "truth", "light", "hot", "open", "push", "up", "eat", "work", "hit", "run", "dog", "tree", "sugar", "house", "field", "man", "life", "crime", "belly", "old", "walk", "thing", "duck", "face", "own", "feed", "food"]
var prefixes := ["un", "anti", "plus", "doubleplus"]
var suffixes := ["ful", "wise", "ed", "less"]
var special_words := ["Minitruth", "Minipax", "Miniluv", "Ingsoc", "Big Brother", "doublethink", "thoughtcrime", "facecrime", "ownlife", "goodthink", "crimethink", "prolefeed", "joycamp", "bellyfeel", "duckspeak", "blackwhite"]

var banned_words := {}

func _ready() -> void:
    # Select a few banned words and their replacements based on the special words
    var banned_words_count = 5
    while banned_words.size() < banned_words_count:
        var word = special_words[randi() % special_words.size()]
        if banned_words.has(word):
            continue
        banned_words[word] = _generate_newspeak()

    # Set up the start button
    _start_button.connect("pressed", _start_game)

func _process(_delta: float) -> void:
    if not started:
        return

    # Generate words until the text container is full
    if _text_container.size.y - _scroll_container.scroll_vertical < 2000:
        var next_word = _generate_newspeak()
        var label = TruthWord.new(next_word, banned_words.has(next_word))
        if banned_words.has(next_word):
            label.word_corrected.connect(_word_corrected)
            label.word_missed.connect(_word_missed)
        label.word_miscorrected.connect(_word_miscorrected)

        _text_container.add_child(label)

    # Scroll the container
    var target_scroll_speed = scroll_speeds[min(score / 10.0, scroll_speeds.size() - 1)]
    scroll_value += target_scroll_speed * _delta
    _scroll_container.scroll_vertical = int(scroll_value)

func _start_game() -> void:
    started = true
    _start_button.visible = false

func _generate_newspeak() -> String:
    # Randomly dispense a special word
    if randi() % 10 == 0:
        return special_words[randi() % special_words.size()]
    
    # Otherwise use a root word
    var word = root_words[randi() % root_words.size()]

    # Randomly add a prefix
    if randi() % 2 == 0:
        word = prefixes[randi() % prefixes.size()] + word

    # Randomly add a suffix or a second root word (part of category B words)
    if randi() % 2 == 0:
        if randi() % 2 == 0:
            word += suffixes[randi() % suffixes.size()]
        else:
            word += root_words[randi() % root_words.size()]

    return word

func _word_corrected(label: TruthWord) -> void:
    if not started:
        return
    label.text = banned_words[label.text.trim_suffix(" ")] + " "
    score += 1
    _score_label.text = str(score)

func _word_missed(_label: TruthWord) -> void:
    _end_game()

func _word_miscorrected(label: TruthWord) -> void:
    if not started:
        return
    var garbage_text = ""
    for i in range(label.text.length() - 1):
        garbage_text += char(randi() % 26 + 65 + 32)

    label.text = garbage_text + " "
    label.label_settings = false_label
    _end_game()

func _end_game() -> void:
    started = false
    print("Game over! Score is " + str(score) + ".")
    var transition := Transitioner.new(true, "two_minutes_hate_cutscene")
    add_child(transition)