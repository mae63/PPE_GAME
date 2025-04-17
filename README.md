# Jeu de Quiz 3D en Godot

Ce projet est un jeu de quiz 3D développé avec le moteur de jeu Godot 4. Le joueur évolue dans un environnement 3D et peut interagir avec des boutons pour accéder à différents niveaux de quiz.

## Structure du Projet

```
iles_ppe/
├── scenes/                  # Scènes du jeu
│   ├── map.tscn             # Scène principale avec la carte 3D
│   ├── quiz_facile.tscn     # Scène du quiz facile
│   ├── quiz_moyen.tscn      # Scène du quiz moyen
│   └── quiz_difficile.tscn  # Scène du quiz difficile
├── script/                  # Scripts GDScript
│   ├── player_3d.gd         # Contrôle du personnage
│   ├── button_interactif.gd # Gestion des boutons interactifs
│   ├── global_data.gd       # Données globales (position du joueur, etc.)
│   ├── quiz_facile.gd       # Logique du quiz facile
│   ├── quiz_moyen.gd        # Logique du quiz moyen
│   └── quiz_difficile.gd    # Logique du quiz difficile
└── assets/                  # Ressources graphiques et sonores
```

## Fonctionnalités

### Système de Navigation 3D
- Le joueur peut se déplacer librement dans l'environnement 3D
- Contrôles : ZQSD/WASD pour se déplacer, souris pour regarder autour
- Détection de collision avec le sol et les obstacles

### Système de Quiz
- Trois niveaux de difficulté : facile, moyen, difficile
- Chaque quiz contient 10 questions sélectionnées aléatoirement parmi 20
- Système de score basé sur le temps de réponse
- Timer de 100 secondes par quiz
- Affichage du score final et du nombre de réponses correctes

### Interaction avec l'Environnement
- Boutons interactifs qui affichent "Appuyez sur E" lorsque le joueur est à proximité
- Transition fluide entre la carte et les quiz
- Sauvegarde de la position du joueur lors des transitions

## Comment Reprendre le Projet

### Prérequis
- Godot 4.x installé sur votre machine
- Connaissances de base en GDScript (le langage de programmation de Godot)

### Étapes pour Reprendre le Projet

1. **Cloner le dépôt**
   ```bash
   git clone [URL_DU_REPO]
   cd iles_ppe
   ```

2. **Ouvrir le projet dans Godot**
   - Lancez Godot
   - Cliquez sur "Importer"
   - Sélectionnez le dossier du projet

3. **Structure des Scènes**
   - La scène principale est `map.tscn`
   - Les scènes de quiz sont `quiz_facile.tscn`, `quiz_moyen.tscn` et `quiz_difficile.tscn`
   - Chaque scène de quiz a son script correspondant dans le dossier `script/`

4. **Système de Données Globales**
   - Le script `global_data.gd` est enregistré comme Autoload dans les paramètres du projet
   - Il gère la sauvegarde de la position du joueur lors des transitions entre scènes

5. **Personnalisation des Quiz**
   - Pour modifier les questions, éditez la fonction `populate_all_questions()` dans les scripts de quiz
   - Format des questions :
     ```gdscript
     {
         "question": "Texte de la question",
         "answers": ["Réponse 1", "Réponse 2", "Réponse 3", "Réponse 4"],
         "correct": 0  # Index de la réponse correcte (0-3)
     }
     ```

## Système de Contrôle du Personnage

Le script `player_3d.gd` gère les mouvements du personnage :
- Mouvement relatif à la caméra
- Détection de collision avec le sol
- Gestion de la gravité
- Interaction avec les boutons

## Système de Boutons Interactifs

Le script `button_interactif.gd` gère l'interaction avec les boutons :
- Détection de la proximité du joueur
- Affichage du message "Appuyez sur E"
- Transition vers la scène de quiz correspondante
- Sauvegarde de la position du joueur

## Système de Quiz

Chaque niveau de quiz fonctionne de la même manière :
1. Sélection aléatoire de 10 questions parmi 20
2. Affichage des questions une par une
3. Calcul du score en fonction du temps de réponse
4. Affichage du récapitulatif à la fin
5. Possibilité de recommencer ou de retourner à la carte

## Conseils pour le Développement Futur

- Pour ajouter de nouvelles questions, modifiez la fonction `populate_all_questions()` dans les scripts de quiz
- Pour modifier l'environnement 3D, éditez la scène `map.tscn`
- Pour ajouter de nouveaux types de quiz, créez une nouvelle scène basée sur les scènes de quiz existantes
- Pour améliorer les graphismes, remplacez les assets dans le dossier `assets/`

## Dépannage Courant

- **Le personnage tombe à travers le sol** : Vérifiez la configuration du `CollisionShape3D` et du `FloorRay`
- **Les boutons ne réagissent pas** : Assurez-vous que le joueur est dans le groupe "player" et que l'action "interact" est configurée
- **Les transitions entre scènes ne fonctionnent pas** : Vérifiez que `global_data.gd` est bien enregistré comme Autoload

## Contribution

Pour contribuer à ce projet :
1. Forkez le dépôt
2. Créez une branche pour votre fonctionnalité
3. Committez vos changements
4. Poussez vers la branche
5. Ouvrez une Pull Request


## 🎮 Captures d’écran

<img src="src/picture/fond.jpeg" width="500"/>

---

## ⚙️ Technologies utilisées

- [Godot Engine 4.x](https://godotengine.org/)
- GDScript
- VS Code (pour l’édition de code)
- Git & GitHub (pour la gestion de version)
- Outils graphiques (illustrations, icônes)
- Tutoriels Youtube pour prendre en main godot 

---

## 📂 Organisation du projet

```bash
PPE_GAME/
│
├── scenes/             # Scènes Godot (quiz, menu, options...)
├── script/             # Scripts GDScript
├── src/picture/        # Ressources graphiques (boutons, fond...)
├── audio/              # Musique et sons
├── project.godot       # Fichier de configuration Godot
└── README.md           # Ce fichier
