unit GameMenu;

// GameMenu gère le menu principal, les options , les préférences et sous-menus

interface

// déclaration des bibliothèques et autres unités utiles à l'unité
uses
	crt,
	sdl2, sdl2_image, SDL2_MIXER,
	GameDefeat,
	GameDifficulty,
	GameUpdate,
	GameKeys,
	Game0,
	GameHoops,
	GameInCommon,
	GameSound,
	GameGraphique;


// déclaration des procédures et fonctions
procedure Text1;
procedure Text2;
procedure ExecuterOptionMenu(var sound : pMix_MUSIC; option : String; var bordureBasY : integer);
procedure Screen1(option : String);
function InitButtonScreen1(sdlRenderer : PSDL_Renderer) : Bouttons;
function ouvrirMenuScreen1(option : String) : String;
function InitButtonScreen2(sdlRenderer : PSDL_Renderer) : Bouttons;
function ouvrirMenuScreen2(option : String) : String;
procedure MenuPrincipal(option : String);

implementation

// déclaration des variables utiles à l'unité
var
	ballonX, ballonY, vitesse_du_ballon, gravite, bordureHautY, bordureBasY, musiquePendantJeu : integer;
	niveauChoisi : string;
	retourAuMenuPrincipal, Twice, Fast, Switch, BorduresOff, DefeatOff, Boom, Helllvl1, Helllvl2, Helllvl3 : boolean; 
	niveauDChoisi : NiveauxDeDifficulte;
  
// affichage du menu principal et conditions d'affichage de certains élements à l'écran
procedure Text1;
var 
	k : integer;
begin 
	// déclaration de la constante de la bordure du haut pour tous les niveaux de difficulté et modes de jeu
	bordureHautY := 3;
	// affichage six fois du nom du jeu en haut du menu
    textcolor(Magenta); 
    gotoxy(5, 2);
    for k := 1 to 6 do
		begin
			write('__SuperScoreDunk___');
		end;
	// conditions d'affichage selon si les modes de jeu sont activés, pour donner l'information au joueur
	if Twice = True then
		begin
			gotoxy(52, 6);
			write('Twice as More Hoops!');
		end;
	if Fast = True then
		begin
			gotoxy(57, 7);
			write('Fast Hoops');
		end;
	if Switch = True then
		begin
			gotoxy(56, 8);
			write('Switch  Only');
		end;
	if BorduresOff = True then
		begin
			gotoxy(56, 9);
			write('NoBoundaries');
		end;
	if DefeatOff = True then
		begin
			gotoxy(58, 10);
			write('NoDefeat');
		end;
	if Boom = True then
		begin
			gotoxy(57,11);
			write('Boom Score');
		end;
	if (Helllvl1 or Helllvl2 or Helllvl3) = True then
		begin
			gotoxy(53, 3);
			textcolor(red);
			write('Welcome To  Hell');
			if (Helllvl2 or Helllvl3) = True then
				begin
					gotoxy(47, 4);
					write('ne cligne pas trop des yeux ..');
				end;
		end;
	// esthétique de l'affichage du menu principal
	textcolor(White);
    gotoxy(54, 5);
    writeln('Menu principal');
    gotoxy(46, 13);
    writeln('Appuyez sur');
    gotoxy(59, 13);
    textcolor(Red);
    write('espace');
    gotoxy(66, 13);
    textcolor(White);
    write(' pour Jouer');
    textcolor(White);
    gotoxy(51, 17);
    writeln('Historique des scores'); 
    gotoxy(56, 19);
    writeln('Preferences');
    gotoxy(47, 30);
    textcolor(DarkGray);
    writeln('Appuyez sur echap pour Quitter');
    gotoxy(41, 27);
    textcolor(LightGray);
    writeln('2 : Historique des scores . 3 : Preferences');
 end;
 
// affichage des trois sous-menus : bibliothèque des couleurs, pour la personnalisation de l'écran de jeu selon les envies du joueur
procedure Text2;
begin
	gotoxy(5, 2);
	writeln('Bibliotheque des couleurs');
	gotoxy(5,4);
    write('1. Red');
    gotoxy(5,5);
    writeln('2. Blue');
    gotoxy(5,6);
    writeln('3. White');
    gotoxy(5,7);
    writeln('4. Black');
    gotoxy(5,8);
    writeln('5. Green');
    gotoxy(5,9);
    writeln('6. Cyan');
    gotoxy(5,10);
    writeln('7. Magenta');
    gotoxy(5,11);
    writeln('8. Brown');
    gotoxy(5,12);
    writeln('9. LightGray');
    gotoxy(5,13);
    writeln('10. DarkGray');
    gotoxy(5,14);
    writeln('11  LightBlue');
    gotoxy(5,15);
    writeln('12. LightGreen');
    gotoxy(5,16);
    writeln('13. LightCyan');
    gotoxy(5,17);
    writeln('14. LightRed');
    gotoxy(5,18);
    writeln('15. LightMagenta');
    gotoxy(5,19);
    writeln('16. Yellow');
    gotoxy(5,21);
    write('Votre choix : ');                
end;

// exécution des différentes actions disponibles depuis le menu ou les sous-menus
// exécution du jeu 
procedure ExecuterOptionMenu(var sound : pMix_MUSIC; option : String; var bordureBasY : integer);
var
  a : boolean;
  answer1, answer2, answer3, chaine, couleurBallon, couleurBordures, couleurPaniers : String;
  fichier : text;
begin
	// le joueur peut se déplacer librement dans les menus ou sous-menus jusqu'à ce qu'il quitte le jeu (échap)
	repeat
		// la variable option effectue différentes actions selon la touche enfoncée par le joueur, si celle-ci possède une action ci-dessous, sinon il ne se passe rien
		option := readkey;
		case option of
			// code ASCII de la touche espace, permet de lancer la partie
			// initialisation de toutes les préférences choisis par le joueur, qui sont sauvegardées parties après parties
			#32:
				begin
					textcolor(LightMagenta);
					// effacement du menu principal pour laisser apparaître l'environnement de jeu
					clrscr;
					retourAuMenuPrincipal := false;
					// initialisation (selon le choix sauvegardé du joueur) du niveau de difficulté
					case niveauChoisi of
						'F', 'f', 'Facile', 'FACILE':
							begin
								niveauDChoisi := Facile;
								bordureBasY := fBordureBasY(Facile);
								HauteurEcran := 27;
							end;
						'M', 'm', 'Moyen', 'MOYEN':
							begin
								niveauDChoisi := Moyen;
								bordureBasY := fBordureBasY(Moyen);
								HauteurEcran := 24;
							end;
						'D', 'd', 'Difficile', 'DIFFICILE':
							begin
								niveauDChoisi := Difficile;
								bordureBasY := fBordureBasY(Difficile);
								HauteurEcran := 20;
							end;
						'H', 'h', 'Hardcore', 'HARDCORE':
							begin
								niveauDChoisi := Hardcore;
								bordureBasY := fBordureBasY(Hardcore);
								HauteurEcran := 16;
							end;
					end;
	
			if not retourAuMenuPrincipal then
				begin
					// initialisation (selon le choix sauvegardé du joueur) de la musique durant la partie
					case musiquePendantJeu of
						1: sonInGame1(sound);
						2: sonInGame2(sound);
						3: sonInGame3(sound);
						4: sonInGame4(sound);
						5: sonInGame5(sound);
					end;

					// initialisation des paramètres du ballon avant le début de la partie, le score retourne à zéro
					InitialisationDuJeu(ballonX, ballonY, vitesse_du_ballon, gravite, score);
					// initialisation des paramètres des paniers et des modes de jeu choisis
					InitialiserPaniers(niveauDChoisi, Twice, Fast, Switch); 
					// répétition de l'affichage du jeu : ballon, paniers, modes de jeu choisis, jusqu'à la défaite du joueur et son retour au menu principal
					repeat
						cursoroff;
						// mise à jour constante de l'état du jeu pour afficher un jeu dynamique
						AffichageDuJeu(ballonX, ballonY, score, BorduresOff, Helllvl1, Helllvl2, Helllvl3);
						// affichage de la bordure supérieur du jeu et condition de défaite liée aux bordures
						BorduresDuJeu(bordureHautY, bordureBasY, ballonY, retourAuMenuPrincipal, BorduresOff, Helllvl1);
						// interaction joueur - ballon
						MechaniqueDuBallon(vitesse_du_ballon);
						// puis mise à jour du ballon pour afficher un ballon fluide 
						ActualisationDuJeu(score, ballonX, ballonY, vitesse_du_ballon, gravite, retourAuMenuPrincipal, Switch, Fast, DefeatOff, Boom);
						delay(100);
					until retourAuMenuPrincipal;
					cursoron;
					// fin de la musique de la partie, lancement de la musique du menu principal (qui n'est pas modifiable par le joueur)
					termine_musique(sound);
				end;
			end;
        
			// ouvertue du sous-menu "historique des scores"
			'2': 
				begin
					clrscr;
					nomFichier:='HistoriqueDesScoresSSD';
					assign(fichier, nomFichier);
					reset(fichier);
					while not(eof(fichier)) do
						begin
							readln(fichier, chaine);
							writeln(chaine);
						end;
					close(fichier);
					gotoxy(51, 30);
					writeln('0. Retour au menu pricipal');
					readln(option);
					if option = '0' then
						begin
						retourAuMenuPrincipal := True;
						end;
				end;

			// ouverture du sous-menu "préférences" et affichages de toutes les options disponibles, qui seront sauvegardés juqu'à une nouvelle modification de la part du joueur, ou une réouverture du programme
			'3':
				begin
					repeat
						// effacement du menu principal, affichage du sous-menu "préférence"
						clrscr;
						// esthétique du sous-menu, différents choix
						gotoxy(5, 2);
						write('Preferences');
						gotoxy(5,4);
						writeln('1. Choix Musique');
						gotoxy(5, 5);
						writeln('2. Niveaux de difficulte');
						gotoxy(5, 6);
						writeln('3. Couleur Ballon');
						gotoxy(5, 7);
						writeln('4. Couleur Bordures');
						gotoxy(5, 8);
						writeln('5. Couleur Paniers');
						gotoxy(5, 9);
						writeln('6. Modes de jeu');
						gotoxy(5,11);
						write('Votre choix : ');
						readln(answer1);
						// effacement du sous-menu "préférences" et ouvertue d'un sous-menu de "préférences" selon le choix du joueur
						clrscr;
						case answer1 of
							'1':
								begin
									// affichage de la bibliothèque des musiques
									gotoxy(5, 2);
									writeln('Bibliotheque des musiques');
									gotoxy(5, 4);
									writeln('1. Automotivo Bibi Fogosa');
									gotoxy(5, 5);
									writeln('2. Home Resonance');
									gotoxy(5, 6);
									writeln('3. Bando Sped up');
									gotoxy(5, 7);
									writeln('4. Yum Yum');
									gotoxy(5, 8);
									writeln('5. Bit Rush Arcade');
									gotoxy(5, 10);
									writeln('Votre choix : ');
									gotoxy(19, 10);
									readln(answer2);
									case answer2 of
										// enregistrement de la sélection du joueur
										'1': 
											musiquePendantJeu := 1;
										'2':
											musiquePendantJeu := 2;
										'3': 
											musiquePendantJeu := 3;
										'4': 
											musiquePendantJeu := 4;
										'5': 
											musiquePendantJeu := 5;
									end;
									// retour au menu principal après sélection
									retourAuMenuPrincipal := True;
								end;

							'2':
								begin
									// choix de la difficulté
									a := false;
									gotoxy(5, 2);
									writeln('Choix de la difficulte');
									textcolor(Green);
									gotoxy(5, 4);
									write('F. Facile');
									textcolor(Brown);
									gotoxy(5, 5);
									write('M. Moyen');
									textcolor(LightRed);
									gotoxy(5, 6);
									write('D. Difficile');
									textcolor(Red);
									gotoxy(5, 7);
									write('H. Hardcore'); 
									textcolor(White);
									gotoxy(5, 9);
									writeln('Votre choix : ');
									gotoxy(19, 9);
									readln(niveauChoisi);
									case niveauChoisi of
										// enregistrement permanent du choix de la difficulté
										'F', 'f', 'Facile', 'FACILE':
											begin
												bordureBasY := fBordureBasY(Facile);
												HauteurEcran := 24;
											end;
										'M', 'm', 'Moyen', 'MOYEN':
											begin
												bordureBasY := fBordureBasY(Moyen);
												HauteurEcran:= 21;
											end;
										'D', 'd', 'Difficile', 'DIFFICILE':
											begin
												bordureBasY := fBordureBasY(Difficile);
												HauteurEcran:= 18;
											end;
										'H', 'h', 'Hardcore', 'HARDCORE':
											begin
												bordureBasY := fBordureBasY(Hardcore);
												HauteurEcran:= 15;
											end;
										else
											a := true;
											writeln('Aucun des niveaux proposes n''a ete choisi, mode FACILE choisi par defaut');
											bordureBasY := fBordureBasY(Facile);
									end;

									// si l'entrée de l'utilisateur est éronnée, utilisation du dernier niveau choisie par le joueur
									if not a then
										begin
											clrscr;
											Text1;
											gotoxy(44, 22);
											if (bordureBasY = fBordureBasY(Facile)) then
												writeln('Vous avez choisi le niveau FACILE')
											else if (bordureBasY = fBordureBasY(Moyen)) then
												writeln('Vous avez choisi le niveau MOYEN')
											else if (bordureBasY = fBordureBasY(Difficile)) then
												writeln('Vous avez choisi le niveau DIFFICILE')
											else if (bordureBasY = fBordureBasY(Hardcore)) then
												writeln('Vous avez choisi le niveau HARDCORE');               
										end;
									retourAuMenuPrincipal := True;
								end;
                
							'3':
								begin
									// choix de la couleur du ballon et enregistrement du choix
									clrscr;
									Text2;
									readln(answer2);
									case answer2 of
										// toutes les couleurs sont disponibles
										'1': 
											couleurBallon := 'Red';
										'2':
											couleurBallon := 'Blue';
										'3': 
											couleurBallon := 'White';
										'4': 
											couleurBallon := 'Black';
										'5': 
											couleurBallon := 'Green';
										'6':
											couleurBallon := 'Cyan';
										'7':
											couleurBallon := 'Magenta';
										'8':
											couleurBallon := 'Brown';
										'9':
											couleurBallon := 'LightGray';
										'10':
											couleurBallon := 'DarkGray';
										'11': 
											couleurBallon := 'LightBlue';
										'12': 
											couleurBallon := 'LightGreen';
										'13': 
											couleurBallon := 'LightCyan';
										'14': 
											couleurBallon := 'LightRed';
										'15': 
											couleurBallon := 'LightMagenta';
										'16': 
											couleurBallon := 'Yellow'
										else
											couleurBallon := 'White';
									end;
									CouleurBallonChoisi := couleurBallon;
									retourAuMenuPrincipal := True;
								end;
							'4':
								begin
									// choix de la couleur du ballon et enregistrement du choix
									clrscr;
									Text2;
									readln(answer2);
									case answer2 of
										'1':
											couleurBordures := 'Red';
										'2': 
											couleurBordures := 'Blue';
										'3':
											couleurBordures := 'White';
										'4':	
											couleurBordures := 'Black';
										'5':
											couleurBordures := 'Green';
										'6':
											couleurBordures := 'Cyan';
										'7':
											couleurBordures := 'Magenta';
										'8':
											couleurBordures := 'Brown';
										'9':
											couleurBordures := 'LightGray';
										'10':
											couleurBordures := 'DarkGray';
										'11':
											couleurBordures := 'LightBlue';
										'12': 
											couleurBordures := 'LightGreen';
										'13': 
											couleurBordures := 'LightCyan';
										'14': 
											couleurBordures := 'LightRed';
										'15':
											couleurBordures := 'LightMagenta';
										'16':
											couleurBordures := 'Yellow'
										else
											couleurBordures := 'White'; 
									end;
									CouleurBorduresChoisi := couleurBordures;
									retourAuMenuPrincipal := True;
								end;
							'5':
								begin
									// choix de la couleur du ballon et enregistrement du choix
									clrscr;
									Text2;
									readln(answer2);
									case answer2 of
										'1':
											couleurPaniers := 'Red';
										'2': 
											couleurPaniers := 'Blue';
										'3': 
											couleurPaniers := 'White';
										'4': 
											couleurPaniers := 'Black';
										'5': 
											couleurPaniers := 'Green';
										'6': 
											couleurPaniers := 'Cyan';
										'7':
											couleurPaniers := 'Magenta';
										'8': 
											couleurPaniers := 'Brown';
										'9': 
											couleurPaniers := 'LightGray';
										'10': 
											couleurPaniers := 'DarkGray';
										'11': 
											couleurPaniers := 'LightBlue';
										'12': 
											couleurPaniers := 'LightGreen';
										'13': 
											couleurPaniers := 'LightCyan';
										'14': 
											couleurPaniers := 'LightRed';
										'15': 
											couleurPaniers:= 'LightMagenta';
										'16': 
											couleurPaniers := 'Yellow'
										else
											couleurPaniers := 'White';
									end;	
									CouleurPaniersChoisi := couleurPaniers;
									retourAuMenuPrincipal := True;
								end;
							'6':
								begin
								// liste des différents modes de jeu
									gotoxy(5, 2);
									write('Modes de jeu');
									gotoxy(5,4);	
									write('1. Twice as more hoops : deux fois plus de paniers apparaissent !');
									gotoxy(5,5);
									write('2. Fast Hoops : les paniers se deplacent deux fois plus vite !');
									gotoxy(5,6);
									write('3. Switch Only : marque un panier parfait sinon tu perds !');
									gotoxy(5,7);
									write('4. NoBoundaries : les bordures en haut et en bas s''effondrent !');
									gotoxy(5, 8);
									write('5. NoDefeat : rater un panier ne te fait plus perdre !');
									gotoxy(5, 9);
									write('6. BoomScore : gagne 3 points par panier !');
									gotoxy(5, 11);
									write('7. Hellx2 : les bordures en haut et en bas disparaissent dans la nuit ...');
									gotoxy(5, 12);
									write('8. Hell4Real : le ballon n''est plus aussi visibles qu''avant');
									gotoxy(5, 13);
									write('9. Nightmares : la nuit s''empare du jeu !');
									gotoxy(5, 15);
									write('Appuyez sur x pour desactiver tous les modes');
									gotoxy(5, 17);
									write('Votre choix : '); 
									// choix du mode de jeu
									readln(answer3);
									// activation du mode de jeu selon le choix de l'utilisateur
									if answer3 = '1' then
										Twice := True;
									if answer3 = '2' then
										Fast := True;
									if answer3 = '3' then
										Switch := True;
									if answer3 = '4' then
										BorduresOff := True;
									if answer3 = '5' then
										DefeatOff := True;
									if answer3 = '6' then
										Boom := True;
									if answer3 = '7' then
										begin
											Helllvl1 := True;
											Helllvl2 := False;
											Helllvl3 := False;
										end;
									// Helllvl2 = True permet d'activer le mode de jeu "Hell4Real" qui est une combinaison du mode de jeu "Hellx2" et d'une nouvelle méchanique (effacement des paniers) 
									// Ainsi, on déclare les deux modes de jeu comme vrais
									if answer3 = '8' then
										begin
											Helllvl1 := True;
											Helllvl2 := True;
											Helllvl3 := False;
										end;
									// idem, donc on déclare les trois modes de jeu vrais
									if answer3 = '9' then
										begin
											Helllvl1 := True;
											Helllvl2 := True;
											Helllvl3 := True;
										end;
									// effacement de l'ensemble des modes de jeu --> retour du jeu initial et effacement de l'affichage des modes de jeu dans le menu principal
									if answer3 = 'x' then
										begin
											Twice := False;
											Fast := False;
											Switch := False;
											BorduresOff := False;
											DefeatOff := False;
											Boom := False;
											Helllvl1 := False;
											Helllvl2 := False;
											Helllvl3 := False;
										end;
									InitialiserPaniers(niveauDChoisi, Twice, Fast, Switch);
									retourAuMenuPrincipal := True;
								end;
							'0':
								// retourner au menu principal sans avoir voulu changer un des paramètres du jeu
								begin
									retourAuMenuPrincipal := True;
								end;
								end;
								until retourAuMenuPrincipal;
							end;
						#27:
							// code ASCII de "echap" pour quitter et fermer le jeu
							begin
								halt; // fin immédiate de l'éxecution du programme
							end;
		end;
	// fin de l'affichage du menu principal uniquement si : le joueur choisi de lancer une partie, consulter son histoque, modifier les paramètres de jeu ou quitter le jeu
	until (option = #32) or (option = '2') or (option = '3') or retourAuMenuPrincipal;
end;

// itinialisation des boutons graphiques pour la SDL. Chargement de la première image à partir du fichier
function InitButtonScreen1(sdlRenderer : PSDL_Renderer) : Bouttons;
var 
	newSpriteSheet : Bouttons;
begin
	newSpriteSheet.basket := IMG_LoadTexture(sdlRenderer, 'HomeScreen.jpg');
	InitButtonScreen1 := newSpriteSheet;
end;

// ouverture de la première fenêtre SDL
function ouvrirMenuScreen1(option : String) : String;
var
	fenetre : PSDL_Window;
	rendu: PSDL_Renderer;
	sprites_Menu : Bouttons;
	Clique : Boolean;
	choix : Char;
begin
	initialise(fenetre,rendu);
	sprites_Menu := InitButtonScreen1(rendu);
	repeat
		MenuAffiche (rendu, sprites_Menu.basket);
		SelectionScreen1(Clique,choix);
	until (choix='q');
	termine(fenetre,rendu);
	ouvrirMenuScreen1 := choix;
end;

// itinialisation des boutons graphiques pour la SDL. Chargement de  la seconde image à partir du fichier
function InitButtonScreen2(sdlRenderer : PSDL_Renderer) : Bouttons;
var 
	newSpriteSheet : Bouttons;
begin
	newSpriteSheet.basket := IMG_LoadTexture(sdlRenderer, 'Difficulty3.jpg');
	InitButtonScreen2 := newSpriteSheet;
end;

// ouvertue de la seconde fenêtre SDL
function ouvrirMenuScreen2(option : String) : String;
var
	fenetre : PSDL_Window;
	rendu: PSDL_Renderer;
	sprites_Menu : Bouttons;
	Clique : Boolean;
	choix : Char;
begin
	initialise(fenetre,rendu);
	sprites_Menu := InitButtonScreen2(rendu);
	repeat
		MenuAffiche (rendu, sprites_Menu.basket);
		SelectionScreen2(Clique,choix);
	// choix du niveau de difficulté selon les coordonnées du clique du joueur
	until (choix='q') or (choix='s') or (choix='t') or (choix='v');
	if choix='q' then
		begin
			niveauDChoisi := Facile;
			bordureBasY := fBordureBasY(Facile);
		end;
	if choix='t' then
		begin
			niveauDChoisi := Moyen;
			bordureBasY := fBordureBasY(Moyen);
		end;
	if choix='s' then
		begin
			niveauDChoisi := Difficile;
			bordureBasY := fBordureBasY(Difficile);
		end;
	if choix='v' then
		begin
			niveauDChoisi := Hardcore;
			bordureBasY := fBordureBasY(Hardcore);
		end;
	// fermeture de la fenêtre graphique suite au choix de la difficulté
	termine(fenetre,rendu);
	ouvrirMenuScreen2 := choix;
end;
      
// point d'entrée pour l'ouverture du premier écran graphique
procedure Screen1(option : String);
begin
	ouvrirMenuScreen1(option);
end;

// gestion du menu principal du jeu : gestion des touches du clavier et exécution des actions associés aux différentes touches
// lancement de la musique du menu principal
// répétition jusqu'à ce que le joueur quitte le jeu
procedure MenuPrincipal(option : String);
begin
	repeat
		sonInMenu(sound); // lancement du son dans le menu
		Text1; // affichage du menu principal
		option := readkey; // l'entrée du touche est possible et la touche entrée par l'utilisateur est stockée
		ExecuterOptionMenu(sound, option, bordureBasY);
		clrscr; // nouvel affichage du menu lors du retour au menu principal après une partie
    until false;
end;

end.







