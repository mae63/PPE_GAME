extends Control

# --- Déclaration des tableaux et variables ---
var all_questions = []   # Tableau de 20 questions
var questions = []       # Tableau qui contiendra les 10 questions sélectionnées

# Variables pour suivre l'état du quiz
var current_question = 0
var selected_answer = -1
var total_time = 100     # Temps total du quiz (en secondes)
var total_score = 0      # Score total accumulé
var correct_answers = 0  # Nombre de réponses correctes
var question_start_time = 0  # Temps restant au début de la question

# --- Références aux nœuds (assure-toi que les chemins sont corrects) ---
@onready var question_label = $QuestionLabel
@onready var question_progress_label = $QuestionProgressLabel
@onready var answers_container = $AnswersContainer
@onready var next_button = $NextButton
@onready var timer_label = $TimerLabel
@onready var timer = $QuestionTimer
@onready var recap_screen = $RecapScreen
@onready var score_label = $RecapScreen/ScoreLabel
@onready var correct_answers_label = $RecapScreen/CorrectAnswersLabel
@onready var time_left_label = $RecapScreen/TimeLeftLabel
@onready var retry_button = $RecapScreen/RetryButton
@onready var menu_button = $RecapScreen/MenuButton

# --- Fonction _ready() ---
func _ready():
	# Connexion du bouton Menu
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Connexion du bouton Retour
	$RecapScreen/RetourButton.pressed.connect(_on_retour_pressed)

	# Générer la liste complète de 20 questions
	populate_all_questions()
	
	# Initialiser le générateur aléatoire et mélanger les questions
	randomize()
	all_questions.shuffle()
	# On sélectionne les 10 premières questions du tableau mélangé
	questions = all_questions.slice(0, 10)
	
	# Connecter les signaux du bouton Retry et du Timer (en Godot 4, on utilise Callable)
	if not retry_button.is_connected("pressed", Callable(self, "_on_retry_pressed")):
		retry_button.pressed.connect(Callable(self, "_on_retry_pressed"))
	if not timer.is_connected("timeout", Callable(self, "_on_time_out")):
		timer.timeout.connect(Callable(self, "_on_time_out"))
	
	# Connecter une seule fois le signal "pressed" pour chaque bouton de réponse
	# On suppose qu'il y a exactement 4 boutons dans AnswersContainer.
	for i in range(answers_container.get_child_count()):
		var button = answers_container.get_child(i)
		if not button.is_connected("pressed", Callable(self, "_on_answer_pressed").bind(i)):
			button.pressed.connect(Callable(self, "_on_answer_pressed").bind(i))
	
	# Masquer l'écran de récapitulatif au départ
	recap_screen.visible = false
	
	# Réinitialiser les compteurs du quiz et charger la première question
	current_question = 0
	total_score = 0
	correct_answers = 0
	load_question()
	
	# Configurer et démarrer le Timer
	timer.wait_time = total_time
	timer.start()
	next_button.visible = true #hide the next button
	next_button.disabled = true # Désactivé tant que pas de réponse

func _on_answer_selected(index):
	selected_answer = index
	next_button.disabled = false #no need to undisable next button

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

# --- Fonction pour générer 20 questions de culture générale ---
func populate_all_questions():
	all_questions.clear()  # Vider au cas où

	all_questions.append({
		"question": "Quel pays a inventé les Jeux Olympiques ?",
		"answers": ["Grèce", "Italie", "France", "Égypte"],
		"correct": 0
	})
	all_questions.append({
		"question": "Combien y a-t-il d'os dans le corps humain adulte ?",
		"answers": ["206", "201", "210", "220"],
		"correct": 0
	})
	all_questions.append({
		"question": "Qui a écrit 'Le Petit Prince' ?",
		"answers": ["Jules Verne", "Victor Hugo", "Antoine de Saint-Exupéry", "Molière"],
		"correct": 2
	})
	all_questions.append({
		"question": "Dans quelle ville italienne trouve-t-on le Colisée ?",
		"answers": ["Rome", "Venise", "Florence", "Naples"],
		"correct": 0
	})
	all_questions.append({
		"question": "En quelle année l'homme a-t-il marché sur la Lune ?",
		"answers": ["1969", "1972", "1959", "1965"],
		"correct": 0
	})
	all_questions.append({
		"question": "Quel pays est traversé par le Nil ?",
		"answers": ["Égypte", "Afrique du Sud", "Éthiopie", "Maroc"],
		"correct": 0
	})
	all_questions.append({
		"question": "Combien de joueurs dans une équipe de football ?",
		"answers": ["9", "10", "11", "12"],
		"correct": 2
	})
	all_questions.append({
		"question": "Quel est le symbole chimique du sodium ?",
		"answers": ["Na", "S", "So", "Sn"],
		"correct": 0
	})
	all_questions.append({
		"question": "Quel est le plus grand désert du monde ?",
		"answers": ["Sahara", "Arctique", "Antarctique", "Gobi"],
		"correct": 2
	})
	all_questions.append({
		"question": "Quelle est la capitale de l'Australie ?",
		"answers": ["Sydney", "Melbourne", "Canberra", "Brisbane"],
		"correct": 2
	})
	all_questions.append({
		"question": "Quelle est la langue la plus parlée au monde ?",
		"answers": ["Espagnol", "Anglais", "Hindi", "Mandarin"],
		"correct": 3
	})
	all_questions.append({
		"question": "Quel pays a le plus de fuseaux horaires ?",
		"answers": ["Chine", "États-Unis", "France", "Russie"],
		"correct": 2  # Grâce à ses DOM-TOM !
	})
	all_questions.append({
		"question": "Combien de côtés a un hexagone ?",
		"answers": ["5", "6", "7", "8"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quel compositeur est devenu sourd ?",
		"answers": ["Mozart", "Bach", "Beethoven", "Vivaldi"],
		"correct": 2
	})
	all_questions.append({
		"question": "Quelle est la capitale du Canada ?",
		"answers": ["Toronto", "Ottawa", "Vancouver", "Montréal"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quel est le plus haut volcan actif du monde ?",
		"answers": ["Etna", "Kilimandjaro", "Ojos del Salado", "Fuego"],
		"correct": 2
	})
	all_questions.append({
		"question": "Qui a peint 'La Nuit étoilée' ?",
		"answers": ["Monet", "Van Gogh", "Gauguin", "Picasso"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quelle ville est surnommée la 'ville lumière' ?",
		"answers": ["Paris", "New York", "Londres", "Berlin"],
		"correct": 0
	})
	all_questions.append({
		"question": "Quel scientifique a proposé la théorie de la relativité ?",
		"answers": ["Galilée", "Newton", "Einstein", "Bohr"],
		"correct": 2
	})
	all_questions.append({
		"question": "Quel pays a remporté la Coupe du Monde 2018 ?",
		"answers": ["Argentine", "France", "Allemagne", "Brésil"],
		"correct": 1
	})

# --- Fonction pour charger une question ---
func load_question():
	if current_question < questions.size():
		question_start_time = timer.time_left
		var question = questions[current_question]
		question_label.text = question["question"]
		question_progress_label.text = "Question %d/10" % (current_question + 1)
		
		# Mettre à jour les boutons de réponse
		for i in range(answers_container.get_child_count()):
			answers_container.get_child(i).text = question["answers"][i]
		
		# Réinitialiser l'état des boutons
		selected_answer = -1
		next_button.disabled = true
		for button in answers_container.get_children():
			button.disabled = false

# --- Fonction pour afficher l'écran de récapitulation ---
func show_recap_screen():
	recap_screen.visible = true
	score_label.text = "Score final : %d" % total_score
	correct_answers_label.text = "Réponses correctes : %d/10" % correct_answers
	time_left_label.text = "Temps restant : %d secondes" % int(timer.time_left)
	
	# Désactiver les boutons de réponse
	for button in answers_container.get_children():
		button.disabled = true

# --- Fonction appelée lorsque le temps est écoulé ---
func _on_time_out():
	show_recap_screen()

# --- Fonction appelée lorsque le bouton Retry est pressé ---
func _on_retry_pressed():
	get_tree().reload_current_scene()

# --- Fonction appelée lorsque le bouton Menu est pressé ---
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://map.tscn")

# --- Fonction appelée lorsque le bouton Retour est pressé ---
func _on_retour_pressed():
	get_tree().change_scene_to_file("res://map.tscn")

# --- Fonction pour mettre à jour le timer ---
func _process(_delta):
	if not recap_screen.visible:
		timer_label.text = "Temps restant : %d" % int(timer.time_left)

# --- Fonction appelée lorsqu'une réponse est sélectionnée ---
func _on_answer_pressed(index: int):
	_on_answer_selected(index) 
