func _on_answer_pressed(index):
	# Empêcher de cliquer plusieurs fois en ignorant les clics supplémentaires
	if selected_answer != -1:
		return
		
	selected_answer = index
	
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
	
	# Attendre un court délai pour que le joueur voie sa réponse
	await get_tree().create_timer(1.0).timeout
	
	# Réinitialiser selected_answer pour la prochaine question
	selected_answer = -1
	
	# Passer directement à la question suivante
	current_question += 1
	if current_question < questions.size():
		load_question()
	else:
		show_recap_screen() 
