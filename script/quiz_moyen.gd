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

func _on_answer_selected(index):
	selected_answer = index

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
		"question": "Combien y a-t-il d’os dans le corps humain adulte ?",
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
		"question": "Quelle est la capitale de l’Australie ?",
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


# --- Fonction pour charger et afficher la question courante ---
func load_question():
	# Stocker le temps restant au début de la question
	question_start_time = timer.time_left
	
	# Récupérer la question courante
	var q = questions[current_question]
	question_label.text = q["question"]
	question_progress_label.text = "Question " + str(current_question + 1) + "/" + str(questions.size())
	
	var answers = q["answers"]
	# Mettre à jour le texte et l'état de chaque bouton de réponse
	for i in range(answers.size()):
		var button = answers_container.get_child(i)
		button.text = answers[i]
		button.disabled = false   # Activer le bouton
	# Désactiver le bouton "Next" tant qu'aucune réponse n'est sélectionnée
	selected_answer = -1

# --- Fonction _process() pour mettre à jour le Timer ---
func _process(_delta):
	var time_left = int(timer.time_left)
	timer_label.text = "Temps restant : " + str(time_left) + "s"

# --- Fonction appelée lorsqu'un bouton de réponse est pressé ---
# L'argument 'index' correspond à l'indice du bouton (0 à 3)
func _on_answer_pressed(index):
	selected_answer = index
	
	# Calcul du temps écoulé pour répondre
	var time_taken = question_start_time - timer.time_left
	if time_taken < 0:
		time_taken = 0

	# Calcul des points (1000 points - 100 points par seconde) minimum 100
	var points = 1000 - int(time_taken * 100)
	if points < 100:
		points = 100

	# Vérifier la réponse et mettre à jour le score
	if selected_answer == questions[current_question]["correct"]:
		total_score += points
		correct_answers += 1

	print("Temps pris : ", time_taken, "s | Points gagnés : ", points)

	# Passer automatiquement à la question suivante
	current_question += 1
	if current_question < questions.size():
		load_question()
	else:
		show_recap_screen()


# --- Fonction appelée lorsque le Timer atteint 0 ---
func _on_time_out():
	show_recap_screen()

# --- Afficher l'écran de récapitulatif ---
func show_recap_screen():
	question_label.visible = false
	answers_container.visible = false
	timer_label.visible = false
	recap_screen.visible = true
	
	score_label.text = "Score final : " + str(total_score) + " points"
	correct_answers_label.text = "Réponses correctes : " + str(correct_answers) + "/" + str(questions.size())
	var time_left = int(timer.time_left)
	time_left_label.text = "Temps restant : " + str(time_left) + "s"

# --- Fonction appelée lorsque le bouton Retry est pressé ---
func _on_retry_pressed():
	current_question = 0
	selected_answer = -1
	total_score = 0
	correct_answers = 0
	timer.wait_time = total_time
	timer.start()
	
	recap_screen.visible = false
	question_label.visible = true
	answers_container.visible = true
	timer_label.visible = true
	
	load_question()
	
# --- Fonction appelée lorsque le bouton Menu est pressé ---
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menue.tscn")
