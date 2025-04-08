extends Control

# Liste de 10 questions de culture générale
var questions = [
	{"question": "Quelle est la capitale de la France ?", "answers": ["Londres", "Paris", "Madrid", "Berlin"], "correct": 1},
	{"question": "Qui a peint la Joconde ?", "answers": ["Van Gogh", "Picasso", "Léonard de Vinci", "Monet"], "correct": 2},
	{"question": "Quelle est la planète la plus proche du soleil ?", "answers": ["Venus", "Mars", "Mercure", "Jupiter"], "correct": 2},
	{"question": "Combien de continents existe-t-il ?", "answers": ["4", "5", "6", "7"], "correct": 3},
	{"question": "Quel est l'élément chimique O ?", "answers": ["Oxygène", "Or", "Osmium", "Ozone"], "correct": 0},
	{"question": "Quelle est la monnaie du Japon ?", "answers": ["Yuan", "Won", "Yen", "Ringgit"], "correct": 2},
	{"question": "Qui a écrit 'Les Misérables' ?", "answers": ["Zola", "Hugo", "Balzac", "Voltaire"], "correct": 1},
	{"question": "Quel est le plus grand océan ?", "answers": ["Atlantique", "Pacifique", "Indien", "Arctique"], "correct": 1},
	{"question": "Quel est le symbole chimique du fer ?", "answers": ["Fe", "Ir", "In", "F"], "correct": 0},
	{"question": "Quelle est la langue officielle du Brésil ?", "answers": ["Espagnol", "Anglais", "Portugais", "Français"], "correct": 2}
]

var current_question = 0
var selected_answer = -1
var total_time = 100  # Temps total pour tout le quiz
var total_score = 0  # Score total
var correct_answers = 0  # Nombre de réponses correctes
var question_start_time = 0  # Temps de début de chaque question

@onready var correct_answers_label = $RecapScreen/CorrectAnswersLabel
@onready var question_progress_label = $QuestionProgressLabel
@onready var time_left_label = $RecapScreen/TimeLeftLabel
@onready var question_label = $QuestionLabel
@onready var timer_label = $TimerLabel
@onready var answers_container = $AnswersContainer
@onready var next_button = $NextButton
@onready var timer = $QuestionTimer
@onready var recap_screen = $RecapScreen  # Écran de récapitulatif
@onready var score_label = $RecapScreen/ScoreLabel
@onready var retry_button = $RecapScreen/RetryButton

func _ready():
	var main_menu_scene = get_tree().root.get_node("MainMenu") # Remplacez "MainMenu" par le nom de votre scène de menu principal.
	if main_menu_scene:
		main_menu_scene.hard_mode_changed.connect(set_mode) # Connexion au signal
	timer.timeout.connect(_on_time_out) # Connexion du signal timeout
	retry_button.pressed.connect(_on_retry_pressed)
	recap_screen.visible = false # Masquer l'écran récap au début
	load_question()
	timer.wait_time = total_time
	timer.start()
	next_button.visible = false #hide the next button


func _on_answer_selected(index):
	selected_answer = index
	#next_button.disabled = false #no need to undisable next button

	# Calculate time and points
	var time_taken = question_start_time - timer.time_left
	if time_taken < 0:
		time_taken = 0
	var points = 1000 - int(time_taken * 100)
	if points < 100:
		points = 100

	if selected_answer == questions[current_question]["correct"]:
		total_score += points
		correct_answers += 1

	print("Temps pris : ", time_taken, "s | Points gagnés : ", points)

	# Automatically go to the next question
	current_question += 1

	if current_question < questions.size():
		load_question()
	else:
		show_recap_screen()


func set_mode(hard_mode: bool):
	if hard_mode:
		print("Mode difficile activé !")
		# Ici, tu peux modifier d'autres paramètres si nécessaire
		total_time = 50 # Par exemple, réduire le temps en mode difficile
	else:
		print("Mode normal activé !")
		total_time = 100
	timer.wait_time = total_time #Update the timer


func load_question():
	question_start_time = timer.time_left  # Stocke le temps au début de la question
	question_label.text = questions[current_question]["question"]
	
	# Mettre à jour la progression du quiz
	question_progress_label.text = "Question " + str(current_question + 1) + "/" + str(questions.size())
	
	# Réinitialiser les boutons de réponse
	var answers = questions[current_question]["answers"]
	for i in range(answers.size()):
		var button = answers_container.get_child(i)
		button.text = answers[i]
		button.disabled = false
		button.pressed.connect(_on_answer_selected.bind(i))

	next_button.disabled = true
	selected_answer = -1

func _process(_delta):
	var time_left = int(timer.time_left)
	timer_label.text = "Temps restant : " + str(time_left) + "s"

func _on_NextButton_pressed():
	current_question += 1

	if current_question < questions.size():
		load_question()
	else:
		show_recap_screen()  # Affiche l’écran de fin

func _on_time_out():
	show_recap_screen()  # Affiche l’écran récapitulatif si le temps est écoulé

func show_recap_screen():
	question_label.visible = false
	answers_container.visible = false
	next_button.visible = false
	timer_label.visible = false
	recap_screen.visible = true

	# Affichage du score final en entier
	score_label.text = "Score final : " + str(total_score) + " points"
	correct_answers_label.text = "Réponses correctes : " + str(correct_answers) + "/10"
	# Affichage du temps restant et du nombre de bonnes réponses
	var time_left = int(timer.time_left)
	time_left_label.text = "Temps restant : " + str(time_left) + "s"

func _on_retry_pressed():
	# Réinitialiser le jeu
	current_question = 0
	selected_answer = -1
	total_score = 0  # Réinitialiser le score
	correct_answers = 0  # Réinitialiser le nombre de réponses correctes
	timer.wait_time = total_time
	timer.start()
	
	# Cacher l’écran récapitulatif
	recap_screen.visible = false
	
	# Réafficher les éléments du quiz
	question_label.visible = true
	answers_container.visible = true
	next_button.visible = true
	timer_label.visible = true

	load_question()
