extends Node

func get_color_heros(color):
	var list = []
	for card in card_list_dict:
		if card_list_dict[card]["tipo"] == "hero" and (color in card_list_dict[card]["colori"]):
			list.append(card)
	return(list)
func get_color_spells(color):
	var list = []
	for card in card_list_dict:
		if card_list_dict[card]["tipo"] in ["spell", "event"] and (color in card_list_dict[card]["colori"]):
			list.append(card)
	return(list)
func get_all_events():
	var list = []
	for card in card_list_dict:
		if card_list_dict[card]["tipo"] == "event":
			list.append(card)
	return(list)
func get_pietanze():
	var list = [1, 19, 56, 57, 80] 
	return list
func get_girls():
	var list = [42, 45, 46, 50, 70, 86, 89] 
	return list
func get_alcolici():
	var list = [12, 13, 58]
	return list
func get_giochi():
	var list = [14, 35, 39, 43, 88]
	return list
func get_libri():
	var list = [6, 72, 84, 85]
	return list
func get_bevande():
	var list = [12, 13, 58]
	return list

var objective_list_dict = {
	1:{
		"nome" : "Risolvi il calo di libido",
		"img" : preload("res://Resources/obj_1.png"),
		"color" : "red",
		"trigger" : "begin_turn"
		},
	2:{
		"nome" : "Dimentica il/la tuo/a ex",
		"img" : preload("res://Resources/obj_2.png"),
		"color" : "green",
		"trigger" : "begin_turn"
		},
	3:{
		"nome" : "Prendi una laurea",
		"img" : preload("res://Resources/obj_3.png"),
		"color" : "blue",
		"trigger" : "begin_turn"
		},
	4:{
		"nome" : "Partecipa ad un'orgia",
		"img" : preload("res://Resources/obj_4.png"),
		"color" : "red",
		"trigger" : "end_turn"
		},
	5:{
		"nome" : "SCATENA IL CAOS!!!",
		"img" : preload("res://Resources/obj_5.png"),
		"color" : "green",
		"trigger" : "end_turn"
		},
	6:{
		"nome" : "Trova la pace interiore",
		"img" : preload("res://Resources/obj_6.png"),
		"color" : "blue",
		"trigger" : "end_turn"
		},
	7:{
		"nome" : "Prepara una cena romantica",
		"img" : preload("res://Resources/obj_7.png"),
		"color" : "red",
		"trigger" : "end_turn"
		},
	8:{
		"nome" : "Forma una band death metal",
		"img" : preload("res://Resources/obj_8.png"),
		"color" : "green",
		"trigger" : "end_turn"
		},
	9:{
		"nome" : "Vinci le olimpiadi di mate",
		"img" : preload("res://Resources/obj_9.png"),
		"color" : "blue",
		"trigger" : "begin_turn"
		},
	
	
	}

var card_list_dict = {
	-1:{
		"tipo" : null,
		"quantità": 0,
		"nome" : "null",
		"effetti": [],
		"vita" : 0,
		"colori": [],
		"img": preload("res://Resources/-1.png")
		},
	0:{
		"tipo" : null,
		"quantità": 0,
		"nome" : "il nulla",
		"effetti": [],
		"vita" : 0,
		"colori": [],
		"img": preload("res://Resources/0.png")
		},
		
	1:{
		"nome" : "Polenta eterna",
		"tipo" : "spell",
		"effetti": ["end_turn", "dead"],
		"vita" : 5,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/1.png"),
		"sound" : preload("res://Resources/1.wav")
		},
	2:{
		"nome" : "Spesa per capodanno",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue","green"],
		"img" : preload("res://Resources/2.png"),
		"sound" : preload("res://Resources/2.wav")
		},
	3:{
		"nome" : "Fugace toccata al culo",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/3.png"),
		"sound" : preload("res://Resources/3.wav")
		},
	4:{
		"nome" : "I can wash it",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue", "red"],
		"img" : preload("res://Resources/4.png"),
		"sound" : preload("res://Resources/4.wav")
		},
	5:{
		"nome" : "Oceano di sensazioni",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/5.png"),
		"sound" : preload("res://Resources/5.wav")
		},
	6:{
		"nome" : "Il grande libro della polenta",
		"tipo" : "spell",
		"effetti": ["hero_played", "dead"],
		"vita" : 6,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/6.png"),
		"sound" : preload("res://Resources/6.wav")
		},
	7:{
		"nome" : "Coda al supermercato",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/7.png"),
		"sound" : preload("res://Resources/7.wav")
		},
	8:{
		"nome" : "Bumbumbum'bu, Capotribù",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 10,
		"attacco" : 3,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/8.png"),
		"sound" : preload("res://Resources/8.wav")
		},
	9:{
		"nome" : "Mum'bo, Capotribù",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 10,
		"attacco" : 3,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/9.png"),
		"sound" : preload("res://Resources/9.wav")
		},
	10:{
		"nome" : "Albero di banane",
		"tipo" : "spell",
		"effetti": ["end_turn", "begin_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/10.png"),
		"sound" : preload("res://Resources/10.wav")
		},
	11:{
		"nome" : "Reggiseno assassino",
		"tipo" : "hero",
		"effetti": ["played", "dead"],
		"vita" : 2,
		"attacco" : 9,
		"quantità": 3,
		"colori" : ["green", "red"],
		"img" : preload("res://Resources/11.png"),
		"sound" : preload("res://Resources/11.wav")
		},
	12:{
		"nome" : "Birra",
		"tipo" : "spell",
		"effetti": ["end_turn", "dead"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/12.png"),
		"sound" : preload("res://Resources/12.wav")
		},
	13:{
		"nome" : "Jack Daniel's (col miele)",
		"tipo" : "spell",
		"effetti": ["hero_teased"],
		"silenzia" : ["hero_teased"], #non fa vedere il fulmine di attivazione quando un avversario attiva cose
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/13.png"),
		"sound" : preload("res://Resources/13.wav")
		},
	14:{
		"nome" : "Gioco della chiave",
		"tipo" : "spell",
		"effetti": ["played"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/14.png"),
		"sound" : preload("res://Resources/14.wav")
		},
	15:{
		"nome" : "Quello bendato",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 2,
		"attacco" : 0,
		"quantità": 0,
		"colori" : ["blue"],
		"img" : preload("res://Resources/15.png"),
		"sound" : preload("res://Resources/15.wav")
		},
	16:{
		"nome" : "Quello seduto 1",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 2,
		"attacco" : 0,
		"quantità": 0,
		"colori" : ["blue"],
		"img" : preload("res://Resources/16.png"),
		"sound" : preload("res://Resources/16.wav")
		},
	17:{
		"nome" : "Chiave segreta",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 0,
		"colori" : ["blue"],
		"img" : preload("res://Resources/17.png"),
		"sound" : preload("res://Resources/17.wav")
		},
	18:{
		"nome" : "Quello seduto 2",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 2,
		"attacco" : 0,
		"quantità": 0,
		"colori" : ["blue"],
		"img" : preload("res://Resources/18.png"),
		"sound" : preload("res://Resources/18.wav")
		},
	19:{
		"nome" : "Glutine",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/19.png"),
		"sound" : preload("res://Resources/19.wav")
		},
	20:{
		"nome" : "The battery is low",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/20.png"),
		"sound" : preload("res://Resources/20.wav")
		},
	21:{
		"nome" : "Propositi per l'anno nuovo",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue","green"],
		"img" : preload("res://Resources/21.png"),
		"sound" : preload("res://Resources/21.wav")
		},
	22:{
		"nome" : "Maschera di Bonny",
		"tipo" : "spell",
		"effetti": ["dead"],
		"vita" : 4,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/22.png"),
		"sound" : preload("res://Resources/22.wav")
		},
	23:{
		"nome" : "Partita a Lupus",
		"tipo" : "spell",
		"effetti": ["played", "end_turn", "dead"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green", "blue", "red"],
		"img" : preload("res://Resources/23.png"),
		"sound" : preload("res://Resources/23.wav")
		},
	24:{
		"nome" : "Lupo",
		"tipo" : "hero",
		"effetti": ["dead"],
		"vita" : 10,
		"attacco" : 3,
		"quantità": 0,
		"colori" : ["blue"],
		"img" : preload("res://Resources/24.png"),
		"sound" : preload("res://Resources/24.wav")
		},
	25:{
		"nome" : "Bresciano",
		"tipo" : "hero",
		"effetti": [],
		"vita" : 6,
		"attacco" : 3,
		"quantità": 0,
		"colori" : ["green"],
		"img" : preload("res://Resources/25.png"),
		"sound" : preload("res://Resources/25.wav")
		},
	26:{
		"nome" : "Puttana",
		"tipo" : "hero",
		"effetti": ["killing_hero", "dead"],
		"silenzia" : ["killing_hero"],
		"vita" : 10,
		"attacco" : 2,
		"quantità": 0,
		"colori" : ["red"],
		"img" : preload("res://Resources/26.png"),
		"sound" : preload("res://Resources/26.wav")
		},
	27:{
		"nome" : "Alex, il creatore",
		"tipo" : "hero",
		"effetti": ["dead"],
		"vita" : 6,
		"attacco" : 6,
		"quantità": 1,
		"colori" : ["green"],
		"img" : preload("res://Resources/27.png"),
		"sound" : preload("res://Resources/27.wav")
		},
	28:{
		"nome" : "Dario l'argenteo",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 8,
		"attacco" : 3,
		"quantità": 1,
		"colori" : ["green"],
		"img" : preload("res://Resources/28.png"),
		"sound" : preload("res://Resources/28.wav")
		},
	29:{
		"nome" : "The power of music",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 9,
		"attacco" : 9,
		"quantità": 3,
		"colori" : ["blue", "green"],
		"img" : preload("res://Resources/29.png"),
		"sound" : preload("res://Resources/29.wav")
		},
	30:{
		"nome" : "Zona studio",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/30.png"),
		"sound" : preload("res://Resources/30.wav")
		},
	31:{
		"nome" : "Quindi tu hai il cazzo grosso?",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/31.png"),
		"sound" : preload("res://Resources/31.wav")
		},
	32:{
		"nome" : "Materasso gonfiabile",
		"tipo" : "hero",
		"effetti": ["end_turn"],
		"vita" : 8,
		"attacco" : 3,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/32.png"),
		"sound" : preload("res://Resources/32.wav")
		},
	33:{
		"nome" : "Indizio medio",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/33.png"),
		"sound" : preload("res://Resources/33.wav")
		},
	34:{
		"nome" : "The Broken Car",
		"tipo" : "hero",
		"effetti": ["killing_hero", "attacking_hero"],
		"silenzia" : ["killing_hero", "attacking_hero"],
		"vita" : 1,
		"attacco" : 3,
		"quantità": 3,
		"colori" : ["green", "blue"],
		"img" : preload("res://Resources/34.png"),
		"sound" : preload("res://Resources/34.wav")
		},
	35:{
		"nome" : "Escape room",
		"tipo" : "spell",
		"effetti": ["begin_turn"],
		"vita" : 4,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/35.png"),
		"sound" : preload("res://Resources/35.wav")
		},
	36:{
		"nome" : "Gabriele, quel sorriso...",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 6,
		"attacco" : 9,
		"quantità": 1,
		"colori" : ["red"],
		"img" : preload("res://Resources/36.png"),
		"sound" : preload("res://Resources/36.wav")
		},
	37:{
		"nome" : "La batteria",
		"tipo" : "spell",
		"effetti": ["begin_turn", "dead"],
		"vita" : 4,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/37.png"),
		"sound" : preload("res://Resources/37.wav")
		},
	38:{
		"nome" : "Indizio grande",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/38.png"),
		"sound" : preload("res://Resources/38.wav")
		},
	39:{
		"nome" : "Improvvisazione",
		"tipo" : "spell",
		"effetti": ["end_turn", "damaging_hero"],
		"silenzia" : ["damaging_hero"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green", "red", "blue"],
		"img" : preload("res://Resources/39.png"),
		"sound" : preload("res://Resources/39.wav")
		},
	40:{
		"nome" : "Indizio piccolo",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/40.png"),
		"sound" : preload("res://Resources/40.wav")
		},
	41:{
		"nome" : "Sosso, il folle illuminato",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 5,
		"attacco" : 7,
		"quantità": 1,
		"colori" : ["green"],
		"img" : preload("res://Resources/41.png"),
		"sound" : preload("res://Resources/41.wav")
		},
	42:{
		"nome" : "Chiara, il raziocinio supremo",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 8,
		"attacco" : 8,
		"quantità": 1,
		"colori" : ["blue"],
		"img" : preload("res://Resources/42.png"),
		"sound" : preload("res://Resources/42.wav")
		},
	43:{
		"nome" : "Intervista",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green", "blue"],
		"img" : preload("res://Resources/43.png"),
		"sound" : preload("res://Resources/43.wav")
		},
	44:{
		"nome" : "Enrico, l'hacker",
		"tipo" : "hero",
		"effetti": ["end_turn"],
		"vita" : 9,
		"attacco" : 7,
		"quantità": 1,
		"colori" : ["blue"],
		"img" : preload("res://Resources/44.png"),
		"sound" : preload("res://Resources/44.wav")
		},
	45:{
		"nome" : "Elena Cuc., la tuttofare",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 6,
		"attacco" : 10,
		"quantità": 1,
		"colori" : ["red"],
		"img" : preload("res://Resources/45.png"),
		"sound" : preload("res://Resources/45.wav")
		},
	46:{
		"nome" : "Alice, la cuoca felice",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 10,
		"attacco" : 7,
		"quantità": 1,
		"colori" : ["blue"],
		"img" : preload("res://Resources/46.png"),
		"sound" : preload("res://Resources/46.wav")
		},
	47:{
		"nome" : "Davide, il fignore delle effe",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 8,
		"attacco" : 8,
		"quantità": 1,
		"colori" : ["blue"],
		"img" : preload("res://Resources/47.png"),
		"sound" : preload("res://Resources/47.wav")
		},
	48:{
		"nome" : "Marco Muro, il paladino",
		"tipo" : "hero",
		"effetti": ["healing_player"],
		"silenzia" : ["healing_player"],
		"vita" : 9,
		"attacco" : 5,
		"quantità": 1,
		"colori" : ["blue"],
		"img" : preload("res://Resources/48.png"),
		"sound" : preload("res://Resources/48.wav")
		},
	49:{
		"nome" : "Marco G., il musicista sexy",
		"tipo" : "hero",
		"effetti": ["end_turn"],
		"vita" : 15,
		"attacco" : 3,
		"quantità": 1,
		"colori" : ["red"],
		"img" : preload("res://Resources/49.png"),
		"sound" : preload("res://Resources/49.wav")
		},
	50:{
		"nome" : "Elena Cr., la colta",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 9,
		"attacco" : 5,
		"quantità": 1,
		"colori" : ["blue"],
		"img" : preload("res://Resources/50.png"),
		"sound" : preload("res://Resources/50.wav")
		},
	51:{
		"nome" : "Alessandro G., il sexy lavapiatti",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 8,
		"attacco" : 6,
		"quantità": 1,
		"colori" : ["red"],
		"img" : preload("res://Resources/51.png"),
		"sound" : preload("res://Resources/51.wav")
		},
	52:{
		"nome" : "Pillola rossa o pillola blu",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["red", "blue"],
		"img" : preload("res://Resources/52.png"),
		"sound" : preload("res://Resources/52.wav")
		},
	53:{
		"nome" : "Fate l'amore, non la guerra",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["red", "green"],
		"img" : preload("res://Resources/53.png"),
		"sound" : preload("res://Resources/53.wav")
		},
	54:{
		"nome" : "Mano sinistra di Bonny",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/54.png"),
		"sound" : preload("res://Resources/54.wav")
		},
	55:{
		"nome" : "Mano destra di Bonny",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/55.png"),
		"sound" : preload("res://Resources/55.wav")
		},
	56:{
		"nome" : "Peperoncini calabresi",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 4,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green", "red"],
		"img" : preload("res://Resources/56.png"),
		"sound" : preload("res://Resources/56.wav")
		},
	57:{
		"nome" : "Panettone gustoso",
		"tipo" : "spell",
		"effetti": ["begin_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/57.png"),
		"sound" : preload("res://Resources/57.wav")
		},
	58:{
		"nome" : "3 bottiglie di vino",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/58.png"),
		"sound" : preload("res://Resources/58.wav")
		},
	59:{
		"nome" : "La vecchia maschera",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 6,
		"attacco" : 3,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/59.png"),
		"sound" : preload("res://Resources/59.wav")
		},
	60:{
		"nome" : "Il portatile",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue", "green"],
		"img" : preload("res://Resources/60.png"),
		"sound" : preload("res://Resources/60.wav")
		},
	61:{
		"nome" : "Otite improvvisa",
		"tipo" : "spell",
		"effetti": ["end_turn", "dead"],
		"vita" : 2,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/61.png"),
		"sound" : preload("res://Resources/61.wav")
		},
	62:{
		"nome" : "Cassa Bluetooth",
		"tipo" : "spell",
		"effetti": ["begin_turn", "played"],
		"vita" :3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green", "blue"],
		"img" : preload("res://Resources/62.png"),
		"sound" : preload("res://Resources/62.wav")
		},
	63:{
		"nome" : "Alexander Hamilton",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 4,
		"attacco" : 3,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/63.png"),
		"sound" : preload("res://Resources/63.wav")
		},
	64:{
		"nome" : "The mechanic",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 6,
		"attacco" : 3,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/64.png"),
		"sound" : preload("res://Resources/64.wav")
		},
	65:{
		"nome" : "Muro",
		"tipo" : "hero",
		"effetti": [],
		"vita" : 20,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue", "red", "green"],
		"img" : preload("res://Resources/65.png"),
		"sound" : preload("res://Resources/65.wav")
		},
	66:{
		"nome" : "L'uomo senza identità",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 1,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue", "red", "green"],
		"img" : preload("res://Resources/66.png"),
		"sound" : preload("res://Resources/66.wav")
		},
	67:{
		"nome" : "Bonny, l'essenza del BMC",
		"tipo" : "hero",
		"effetti": ["played", "dead"],
		"vita" : 12,
		"attacco" : 12,
		"quantità": 1,
		"colori" : ["green"],
		"img" : preload("res://Resources/67.png"),
		"sound" : preload("res://Resources/67.wav")
		},
	68:{
		"nome" : "L'esperto di cazzi grandi",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 4,
		"attacco" : 5,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/68.png"),
		"sound" : preload("res://Resources/68.wav")
		},
	69:{
		"nome" : "Il mediatore congolese",
		"tipo" : "hero",
		"effetti": ["attacking_hero"],
		"silenzia" : ["attacking_hero"],
		"vita" : 10,
		"attacco" : 1,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/69.png"),
		"sound" : preload("res://Resources/69.wav")
		},
	70:{
		"nome" : "L'urlatrice della follia",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 7,
		"attacco" : 7,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/70.png"),
		"sound" : preload("res://Resources/70.wav")
		},
	71:{
		"nome" : "Discepolo di Petronio",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 5,
		"attacco" : 5,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/71.png"),
		"sound" : preload("res://Resources/71.wav")
		},
	72:{
		"nome" : "Satyricon",
		"tipo" : "spell",
		"effetti": ["healed_player"],
		"silenzia": ["healed_player"],
		"vita" : 5,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["red"],
		"img" : preload("res://Resources/72.png"),
		"sound" : preload("res://Resources/72.wav")
		},
	73:{
		"nome" : "Coppia di ballerini",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 4,
		"attacco" : 3,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/73.png"),
		"sound" : preload("res://Resources/73.wav")
		},
	74:{
		"nome" : "Brindisi rischioso",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/74.png"),
		"sound" : preload("res://Resources/74.wav")
		},
	75:{
		"nome" : "Piede destro di Bonny",
		"tipo" : "spell",
		"effetti": ["hero_teased"],
		"silenzia" : ["hero_teased"],
		"vita" : 5,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/75.png"),
		"sound" : preload("res://Resources/75.wav")
		},
	76:{
		"nome" : "Piede sinistro di Bonny",
		"tipo" : "spell",
		"effetti": ["begin_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/76.png"),
		"sound" : preload("res://Resources/76.wav")
		},
	77:{
		"nome" : "Lucine decorative",
		"tipo" : "spell",
		"effetti": ["hero_played"],
		"silenzia" : ["hero_played"],
		"vita" : 5,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green", "red", "blue"],
		"img" : preload("res://Resources/77.png"),
		"sound" : preload("res://Resources/77.wav")
		},
	78:{
		"nome" : "Informazioni non molto precise",
		"tipo" : "spell",
		"effetti": ["healed_player"],
		"silenzia": ["healed_player"],
		"vita" : 5,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/78.png"),
		"sound" : preload("res://Resources/78.wav")
		},
	79:{
		"nome" : "Silenzio della notte",
		"tipo" : "spell",
		"effetti": ["healed_player"],
		"silenzia": ["healed_player"],
		"vita" : 5,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/79.png"),
		"sound" : preload("res://Resources/79.wav")
		},
	80:{
		"nome" : "Tazza di caffè",
		"tipo" : "event",
		"effetti": ["played"],
		"vita" : 0,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/80.png"),
		"sound" : preload("res://Resources/80.wav")
		},
	81:{
		"nome" : "Macchinetta del caffè",
		"tipo" : "spell",
		"effetti": ["begin_turn", "enemy_begin_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/81.png"),
		"sound" : preload("res://Resources/81.wav")
		},
	82:{
		"nome" : "Conto alla rovescia",
		"tipo" : "spell",
		"effetti": ["dead"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/82.png"),
		"sound" : preload("res://Resources/82.wav")
		},
	83:{
		"nome" : "Vecchio ubriaco",
		"tipo" : "hero",
		"effetti": ["played"],
		"vita" : 5,
		"attacco" : 4,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/83.png"),
		"sound" : preload("res://Resources/83.wav")
		},
	84:{
		"nome" : "Divina commedia",
		"tipo" : "spell",
		"effetti": ["end_turn"],
		"vita" : 3,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/84.png"),
		"sound" : preload("res://Resources/84.wav")
		},
	85:{
		"nome" : "Odissea",
		"tipo" : "spell",
		"effetti": ["begin_turn"],
		"vita" : 4,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["green"],
		"img" : preload("res://Resources/85.png"),
		"sound" : preload("res://Resources/85.wav")
		},
	86:{
		"nome" : "Veronica, la vincitrice",
		"tipo" : "hero",
		"effetti": ["begin_turn"],
		"vita" : 10,
		"attacco" : 10,
		"quantità": 1,
		"colori" : ["green"],
		"img" : preload("res://Resources/86.png"),
		"sound" : preload("res://Resources/86.wav")
		},
	87:{
		"nome" : "Jacopo, il fotografo",
		"tipo" : "hero",
		"effetti": [],
		"vita" : 9,
		"attacco" : 6,
		"quantità": 1,
		"colori" : ["red"],
		"img" : preload("res://Resources/87.png"),
		"sound" : preload("res://Resources/87.wav")
		},
	88:{
		"nome" : "Gioco della memoria",
		"tipo" : "spell",
		"effetti": ["hero_played", "event_played", "spell_played"],
		"silenzia": ["hero_played", "event_played", "spell_played"],
		"vita" : 5,
		"attacco" : 0,
		"quantità": 3,
		"colori" : ["blue"],
		"img" : preload("res://Resources/88.png"),
		"sound" : preload("res://Resources/88.wav")
		},
	89:{
		"nome" : "Eleonora, la mente viaggiante",
		"tipo" : "hero",
		"effetti": ["end_turn"],
		"vita" : 8,
		"attacco" : 5,
		"quantità": 1,
		"colori" : ["green"],
		"img" : preload("res://Resources/89.png"),
		"sound" : preload("res://Resources/89.wav")
		},
	90:{
		"nome" : "Nicolò, la folta chioma",
		"tipo" : "hero",
		"effetti": ["attacking_hero"],
		"silenzia" : ["attacking_hero"],
		"vita" : 30,
		"attacco" : 2,
		"quantità": 1,
		"colori" : ["red"],
		"img" : preload("res://Resources/90.png"),
		"sound" : preload("res://Resources/90.wav")
		},
	}

