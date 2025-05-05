# POCSAG

# 📡 **POCSAG eBook — Guide complet sur l’interception et le décodage en France**

Ce eBook offre une exploration complète des réseaux POCSAG en France, en se concentrant sur l’histoire, les aspects techniques et les usages actuels (notamment par les pompiers et le service e\*Message). Il est conçu pour un public allant des passionnés de radioamateur aux spécialistes des écoutes radio.

### ✨ **Contenu principal**

✅ Historique et évolution des réseaux POCSAG
✅ Présentation technique des protocoles et de l’architecture réseau
✅ Analyse des usages professionnels (notamment pompiers et alertes)
✅ Tutoriel détaillé : interception et décodage POCSAG avec SDR
✅ Encarts « Pour aller plus loin » pour approfondir les aspects techniques

### 🛠 **Pour qui ?**

* Radioamateurs
* Passionnés d’écoute radio
* Curieux des technologies d’alerte
* Spécialistes en sécurité des communications

### 📖 **Objectif**

Ce guide vise à rendre accessible les connaissances sur les réseaux POCSAG tout en fournissant des explications poussées et des tutoriels pratiques pour permettre aux lecteurs d’expérimenter par eux-mêmes.

---

# 🛠 **Simulation d’un système POCSAG simplifié**

Ce document présente une approche pédagogique pour simuler un système POCSAG simplifié, en s’appuyant sur MATLAB pour modéliser l’encodage, la génération de signal, la transmission, la détection et le décodage des messages. Il s’adresse principalement aux étudiants, passionnés de radiocommunications et chercheurs curieux de comprendre les bases des protocoles de radiomessagerie.

### ✨ **Contenu principal**

✅ Introduction aux principes du POCSAG
✅ Modélisation d’un émetteur et d’un récepteur simplifiés
✅ Génération de signal numérique (code binaire, modulation)
✅ Visualisation des signaux transmis et bruités
✅ Détection et décodage du signal côté récepteur
✅ Analyse des résultats et discussion des performances

### 🔧 **Outils utilisés**

* MATLAB (scripts fournis pour chaque étape)
* Concepts de traitement numérique du signal

### 🎯 **Objectif**

Permettre aux lecteurs de :

* Comprendre le fonctionnement interne d’un système POCSAG ;
* Expérimenter par simulation les étapes critiques d’une chaîne de transmission ;
* Identifier les limitations et les pistes d’amélioration pour des systèmes réels.

---

# 📶 **Simulation MATLAB : Liaison RF POCSAG**

Ce script MATLAB simule une chaîne complète de transmission POCSAG, incluant l’encodage, la modulation, la transmission bruitée, la démodulation et le décodage. Il fournit aussi des visualisations détaillées des signaux et des erreurs détectées, offrant un outil pédagogique puissant pour comprendre les systèmes de radiomessagerie numériques.

### ✨ **Fonctionnalités principales**

✅ Encodage POCSAG avec préambule, synchronisation et message utilisateur
✅ Modulation et génération du signal RF simulé
✅ Passage par un canal bruité (AWGN) configurable
✅ Démodulation et récupération des bits reçus
✅ Décodage final et comparaison des messages
✅ Visualisation graphique des signaux, trames et erreurs

### 🔧 **Détails techniques**

* Langage : MATLAB (version 2024b)
* Fréquence porteuse : 1200 Hz
* Débit binaire : 1200 bps
* SNR configurable (par défaut : 50 dB)
* Détection des erreurs par comparaison bit-à-bit

### 🛠 **Utilisation prévue**

Ce script est destiné aux :

* Étudiants en télécommunications
* Chercheurs en radiocommunications
* Radioamateurs curieux des aspects techniques
* Passionnés de simulation numérique et traitement du signal

### 📂 **Structure du code**

* `pogsag_encoder` : prépare les bits à transmettre
* `pogsag_modulator` : génère le signal modulé
* `awgn` : ajoute du bruit simulé
* `pogsag_demodulator` : extrait les bits du signal reçu
* `pogsag_decoder` : reconstitue le message original
* Visualisations : 4 sous-graphes comparant les signaux émis/reçus, la trame, les bits et les erreurs

---
