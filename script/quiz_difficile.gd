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
	all_questions.clear()

	all_questions.append({
		"question": "Quel philosophe a écrit 'Critique de la raison pure' ?",
		"answers": ["Descartes", "Kant", "Nietzsche", "Platon"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quel est le nom de la plus haute montagne d'Afrique ?",
		"answers": ["Kilimandjaro", "Mont Kenya", "Ruwenzori", "Table Mountain"],
		"correct": 0
	})
	all_questions.append({
		"question": "Qui a découvert la radioactivité ?",
		"answers": ["Curie", "Einstein", "Becquerel", "Rutherford"],
		"correct": 2
	})
	all_questions.append({
		"question": "Dans quelle ville s'est tenue la première révolution industrielle ?",
		"answers": ["Londres", "Manchester", "Berlin", "New York"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quel est le plus long fleuve d'Asie ?",
		"answers": ["Mékong", "Yangtsé", "Gange", "Amour"],
		"correct": 1
	})
	all_questions.append({
		"question": "En quelle année a eu lieu la Révolution française ?",
		"answers": ["1776", "1789", "1804", "1792"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quel est le nom latin de la Terre ?",
		"answers": ["Terra", "Gaia", "Tellus", "Mundi"],
		"correct": 0
	})
	all_questions.append({
		"question": "Qui a écrit 'Du contrat social' ?",
		"answers": ["Rousseau", "Voltaire", "Montesquieu", "Machiavel"],
		"correct": 0
	})
	all_questions.append({
		"question": "Combien de chromosomes possède un humain ?",
		"answers": ["44", "46", "48", "42"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quel est l'élément chimique avec le symbole 'W' ?",
		"answers": ["Wolfram", "Tungstène", "Tantal", "Téllure"],
		"correct": 1  # Le tungstène, aussi appelé wolfram
	})
	all_questions.append({
		"question": "Quel est l'auteur de 'La condition humaine' ?",
		"answers": ["Malraux", "Camus", "Sartre", "Zola"],
		"correct": 0
	})
	all_questions.append({
		"question": "Dans quelle ville se situe l'ONU ?",
		"answers": ["Genève", "New York", "Bruxelles", "Paris"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quel est le nom du satellite naturel de Mars ?",
		"answers": ["Io", "Titan", "Phobos", "Europa"],
		"correct": 2
	})
	all_questions.append({
		"question": "Quel est le pays avec le plus de prix Nobel de littérature ?",
		"answers": ["États-Unis", "France", "Royaume-Uni", "Allemagne"],
		"correct": 1
	})
	all_questions.append({
		"question": "Qui est l'inventeur du calcul intégral ?",
		"answers": ["Leibniz", "Newton", "Descartes", "Euler"],
		"correct": 0
	})
	all_questions.append({
		"question": "Quelle molécule a pour formule C6H12O6 ?",
		"answers": ["Glucose", "Ethanol", "Fructose", "Acide lactique"],
		"correct": 0
	})
	all_questions.append({
		"question": "Quel pays a colonisé l’Indonésie ?",
		"answers": ["Royaume-Uni", "Espagne", "Pays-Bas", "France"],
		"correct": 2
	})
	all_questions.append({
		"question": "Combien d’États composent les États-Unis ?",
		"answers": ["50", "48", "52", "51"],
		"correct": 0
	})
	all_questions.append({
		"question": "Qui a été le premier empereur de Rome ?",
		"answers": ["César", "Auguste", "Néron", "Caligula"],
		"correct": 1
	})
	all_questions.append({
		"question": "Quel philosophe a déclaré : 'Je pense, donc je suis' ?",
		"answers": ["Kant", "Socrate", "Platon", "Descartes"],
		"correct": 3
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
	next_button.disabled = true
	selected_answer = -1

# --- Fonction _process() pour mettre à jour le Timer ---
func _process(_delta):
	var time_left = int(timer.time_left)
	timer_label.text = "Temps restant : " + str(time_left) + "s"

# --- Fonction appelée lorsqu'un bouton de réponse est pressé ---
# L'argument 'index' correspond à l'indice du bouton (0 à 3)
func _on_answer_pressed(index):
	selected_answer = index
	next_button.disabled = false
	
	# Calcul du temps écoulé pour répondre à la question
	var time_taken = question_start_time - timer.time_left
	if time_taken < 0:
		time_taken = 0
	# Calcul des points : 1000 points moins 100 points par seconde écoulée (minimum 100 points)
	var points = 1000 - int(time_taken * 100)
	if points < 100:
		points = 100
	# Vérifier la réponse et mettre à jour le score
	if selected_answer == questions[current_question]["correct"]:
		total_score += points
		correct_answers += 1
	print("Temps pris : ", time_taken, "s | Points gagnés : ", points)

# --- Fonction appelée lorsque le bouton "Next" est pressé ---
func _on_NextButton_pressed():
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
	next_button.visible = false
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
	next_button.visible = true
	timer_label.visible = true
	
	load_question()
	
# --- Fonction appelée lorsque le bouton Menu est pressé ---
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menue.tscn")
