# 20230310 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* création du dépôt
* copie du programme existant (non finalisé)
* mise à jour de la doc FR/EN
* mise à niveau du projet lors de sa première ouverture avec activation des plateformes manquantes (cibles de compilation ajoutées sur Delphi depuis 2019)
* ajout du dépôt de ce projet sur le dépôt de code [DeveloppeurPascal/_AllProjects](https://github.com/DeveloppeurPascal/_AllProjects)
* création de l'icône / logo pour ce programme avec [Pic Mob Generator](https://github.com/DeveloppeurPascal/PicMobGenerator)
* mise à jour de l'icone dans les options de projet
* mise à jour des informations de version
* création de l'application chez Apple, Google et Amazon
* updated rights list in project options
* updated Android permissions list
* changed storrage folder in DEBUG mode + file extension (PNG to JPG)
* changed photo display filter (JPG+PNG) and storrage file extension constant
* correction du fonctionnement et dessin des boutons d'interface (empilement zone de clic/SVG et activation/désactivation)
* bogue : sur images trop volumineuses, impossible de les ouvrir en 32 bits, ok en 64 bits. Corrigé en prenant une version retaillée (carrée) de l'image sélectionnée pour ne travailler que sur de petites images en mémoire.
* prise en charge BitmapScale sur l'image 5 (ellipse avec travail sur le TCanvas)
* correction : quand on a 2 ou 3 images, l'arrondi final fait perdre une ou deux colonnes de pixels (donc ligne rouge en DEBUG qui n'apparaît pas en RELEASE, puisque blanc pour le fond par défaut)
* ajout de dépendances (librairies + about box) sous forme de sous module git
* sur Windows/Linux/Mac, au lieu d'afficher le chemin vers l'image, ouvrir le fichier directement
* ajout d'une boite de dialogue "à propos" sur l'écran d'accueil au dessus de la liste d'images
* déploiement du logiciel pour Windows 32/64 bits
* envoi des codes sources et ouverture d'une release sur GitHub
