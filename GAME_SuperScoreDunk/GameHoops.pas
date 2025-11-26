unit GameHoops;

// GameHoops gère la méchanique des paniers

interface

// déclaration des bibliothèques et autres unités utiles à l'unité
uses
	crt, sysutils, 
	sdl2, sdl2_image, SDL2_MIXER, 
	GameSound, 
	GameDifficulty,
	GameInCommon, 
	Game0;
  
// déclaration des constantes utiles à l'unité
const
	LargeurEcran = 100; 
	DureeDAttente = 18; 
// déclaration des variables utiles à l'unité
var
	PaniersX, PaniersY, DelaisInitiaux : array[1..20] of Integer; // stockage des positions des paniers dans un tableau, stockage des délais d'attente initiaux entre chaque apparition de panier
	NiveauDifficulteChoisi : NiveauxDeDifficulte;
  
// déclaration des procédures
procedure InitialiserPaniers(NiveauDifficulteChoisi : NiveauxDeDifficulte; Twice, Fast, Switch : Boolean);
procedure AfficherPaniers(Helllvl3 : boolean);
procedure FaireDefilerPaniers(ballonX, ballonY, vitesse_du_ballon :  integer; var retourAuMenuPrincipal, Switch, Fast, DefeatOff, Boom : boolean);
procedure ShowMessage(const message : String; X, Y, DureeEnSecondes : Integer);
procedure Enregistrement;
  
implementation 

// affichage d'un message à l'écran pour une durée determinée 
procedure ShowMessage(const message : String; X, Y, DureeEnSecondes : Integer);
var
	TempsDebutMessage : Cardinal; // Real n'est adapté ici, cardinal est plutôt utilisé pour mesurer le temps
begin
	// GetTickCount64 renvoie le nombre de millisecondes écoulées depuis le démarrage du système
	// GetTickCount64 renvoie un entier de 64 bits
	TempsDebutMessage := GetTickCount64; 
	// on prend un point de référence au début de l'éxecution de la procédure et on mesure le temps écoulé en observant la valeur de la différence du temps actuel selon le temps de référene
	repeat
		begin
			gotoxy(X, Y);
			write(message)
		end 
	until (GetTickCount64 - TempsDebutMessage) >= (DureeEnSecondes * 30); // conversion de la durée en millisecondes en multipliant par 30
end;

// enregistrement du score dans un fichier texte à la fin de la partie
procedure Enregistrement;
var 
	fichier : text;
	reponse : String;
begin
	gotoxy(36, 17);
	writeln('Appuyez sur o pour enregistrer le score de votre partie');
	gotoxy(38, 18);
	writeln('Appuyez sur entree pour retourner au menu principal');
	gotoxy(33, 19);
	readln(reponse);
	if reponse = 'o' then
		begin
			nomFichier := 'HistoriqueDesScoresSSD';
			assign(fichier, nomFichier);
			// ouverture du fichier en écriture sans effacer les anciens scores
			append(fichier);
			writeln(fichier, 'score : ');
			writeln(fichier, score);
			// fermeture du fichier pour ne pas rencontrer d'erreur
			close(fichier);
		end;
end;

// initiliasation des positions du panier 
procedure InitialiserPaniers(NiveauDifficulteChoisi : NiveauxDeDifficulte; Twice, Fast, Switch : Boolean);
var
  j : Integer;
begin
	// adaptation aux différents modes de jeu
	if Twice = True then
			NombreDePaniers := 10
	else if Fast = True then
			NombreDePaniers := 4
	else
		// limitation du nombre de paniers à l'écran (équilibrage des paniers)
		NombreDePaniers := 5;
	for j := 1 to NombreDePaniers do
		begin
			PaniersY[j] := 6 + Random(14); // position y du panier aléatoire
			// initialisation individuelle de chaque panier 
			// équilibrage du jeu : les paniers ne doivent pas apparaître hors des limites de jeu ou trop proches des limites 
			while (PaniersY[j] >= fBordureBasY(NiveauDifficulteChoisi) - 4) or (PaniersY[j] < 9) or (PaniersY[j] = fBordureBasY(NiveauDifficulteChoisi) - 2) do
				begin
					PaniersY[j] := 11;
					if PaniersY[j] <= 9 then 
						PaniersY[j] := 11;
					if PaniersY[j] = 2 then
						PaniersY[j] := 11;
				end;
			writeln(PaniersY[j]);
			PaniersX[j] := 70; // constante
			if Twice = True then
				DelaisInitiaux[j] := (j-2) * DureeDAttente
			else 
				DelaisInitiaux[j] := (j -1) * DureeDAttente; // DelaisInitiaux[j] est determiné selon j
		end;
end;

procedure AfficherPaniers(Helllvl3 : boolean);
var
  j : Integer;
  TempsDebutCouleur : Cardinal;
begin
	clrscr;
	for j := 1 to NombreDePaniers do
		begin
			// pour le défilement des paniers, le délai initial de chaque panier est décrémenté (= le panier se déplace), à chaque itération de la boucle principale
			// si le délai est supérieur à 0 alors le panier suivant n'apparaît pas (il est en attente)
			if (PaniersX[j] > 0) and (DelaisInitiaux[j] <= 0) and (PaniersY[j] > 5) then
				begin
					// affichage du panier en x = 70 et en y = random(), sous conditions
					gotoxy(PaniersX[j], PaniersY[j]);
					// prise en compte des différentes modes de jeu 
					if not Helllvl3 then
						TempsDebutCouleur := GetTickCount64;
					// ici, si Helllvl3 est vrai, alors on fait disparaître ou apparaître le panier durant une certaine période en modifiant sa couleur
					if Helllvl3 and ((GetTickCount64 - TempsDebutCouleur) mod 3000 < 2000) then
						begin
							codeCouleurPaniers := ObtenirCodeCouleur(CouleurPaniersChoisi);
							textcolor(codeCouleurPaniers);
						end
					else
						textcolor(Black);
        
					if Helllvl3= False then
						begin
							codeCouleurPaniers := ObtenirCodeCouleur(CouleurPaniersChoisi);
							textcolor(codeCouleurPaniers);
						end;
						
					// représentation du panier
					write('\_______/');
				end;
		end;
end;

// défilement des paniers
procedure FaireDefilerPaniers(ballonX, ballonY, vitesse_du_ballon : integer; var retourAuMenuPrincipal, Switch, Fast, DefeatOff, Boom : boolean);
var
	j : Integer;
	reponse : Char;
	joke1, joke2, joke3 : String;
	son : pMix_Chunk;
begin
	for j := 1 to NombreDePaniers do // la boucle parcourt tous les paniers 
		begin
			// si le délai initial du panier j est > 0, il est décrémenté sinin il se déplace
			if DelaisInitiaux[j] > 0 then 
				DelaisInitiaux[j] := DelaisInitiaux[j] - 1
			else
				begin
					if PaniersX[j] > 0 then
						if Fast = True then
							// déplacement de 2 unités vers la gauche (mode "FastHoops")
							PaniersX[j] := PaniersX[j] - 2
						else 
							// déplacement de 1 unité vers la gauche (déplacement classique du panier)
							PaniersX[j] := PaniersX[j] - 1
					else
						begin
							// affichage de tous les paniers dans les limites de l'écran et conditions de jeu
							PaniersX[j] := LargeurEcran - 10;
							PaniersY[j] := Random(HauteurEcran) + 2;
							DelaisInitiaux[j] := DureeDAttente;
						end;
				end;
			// vérification des conditions de chaque mode de jeu
			if Switch = True then
				begin
					if (ballonX >= PaniersX[j]+3) and (ballonX <= PaniersX[j] + 4) and (ballonY >= PaniersY[j]) and (ballonY <= PaniersY[j] + 2) and (vitesse_du_ballon > 0 + 1) then
						begin
							// incrémentation du score (mode "BoomScore")
							if Boom = True then
								score := score + 3
							else
							// incrémentation du score (classique)
								score := score + 1;
							textcolor(red);
							// effacement de l'écran du panier quand le panier est marqué
							PaniersX[j] := -6;
							if Boom = True then
								begin
									if (ballonY < 8) or (ballonY >15) then
										ShowMessage('+3, BOOM !', ballonX +2, ballonY -4, 1)
									else 
										ShowMessage('+3', ballonX +2, ballonY -4, 1);
								end
							else
								// affichage de l'incrémentation du score, de manière brève
								if (ballonY < 8) or (ballonY >15) then
									ShowMessage('+1, nice one !', ballonX +2, ballonY -4, 1)
								else 
									ShowMessage('+1', ballonX +2, ballonY -4, 1);
							if (score = 100) or (score = 200) or (score = 300) or (score = 400) or (score = 500) then
								begin
									ShowMessage('Great !', 60, 8, 50);
									sonScore(son);
								end;
						end;
				end
			else if Fast = True then
				begin
					if (ballonX >= PaniersX[j]) and (ballonX <= PaniersX[j]+10) and (ballonY >= PaniersY[j]) and (ballonY <= PaniersY[j] + 2) and (vitesse_du_ballon > 0 + 1) then
						begin
							if Boom = True then
								score := score + 3
							else
								score := score + 1;
							textcolor(red);
							PaniersX[j] := -6;
							if Boom = True then
								begin
									if (ballonY < 8) or (ballonY >15) then
										ShowMessage('+3, BOOM !', ballonX +2, ballonY -4, 1)
									else 
										ShowMessage('+3', ballonX +2, ballonY -4, 1);
								end
							else
								if (ballonY < 8) or (ballonY >15) then
									ShowMessage('+1, nice one !', ballonX +2, ballonY -4, 1)
								else 
									ShowMessage('+1', ballonX +2, ballonY -4, 1);
								if (score = 100) or (score = 200) or (score = 300) or (score = 400) or (score = 500) then
									begin
										ShowMessage('Great !', 60, 8, 50);
										sonScore(son);
									end;
						end;
				end
			else 
				begin
					if (ballonX > PaniersX[j]) and (ballonX < PaniersX[j] + 8) and (ballonY >= PaniersY[j]) and (ballonY <= PaniersY[j] + 2) and (vitesse_du_ballon > 0 + 1) then
						begin
							if Boom = True then
								score := score + 3
							else
								score := score + 1;
							textcolor(red);
							PaniersX[j] := -6;
							if Boom = True then
								begin
									if (ballonY < 8) or (ballonY >15) then
										ShowMessage('+3, BOOM !', ballonX +2, ballonY -4, 1)
									else 
										ShowMessage('+3', ballonX +2, ballonY -4, 1);
								end
							else
								if (ballonY < 8) or (ballonY >15) then
									ShowMessage('+1, nice one !', ballonX +2, ballonY -4, 1)
								else 
									ShowMessage('+1', ballonX +2, ballonY -4, 1);
							if (score = 100) or (score = 200) or (score = 300) or (score = 400) or (score = 500) then
								begin
									ShowMessage('Great !', 60, 8, 50);
									sonScore(son);
								end;
						end;
					textcolor(Magenta);
				end;
 
			if DefeatOff = False then
				begin
					// affichage des phrases (humoristiques) uniquement en cas de défaite du au manquement d'un des paniers 
					if (PaniersX[j]=4) and (PaniersY[j]>5) and (PaniersY[j]<25) then
						begin
							textcolor(Red);
							gotoxy(45,24);
							write('Tu dois mettre tous les paniers !!');
								begin
									joke1:='La touche espace ne marchait plus !?';
									joke2:='Ton historique doit etre terrible ..';
									joke3:='Pas fou ce score, n''est-ce pas ? ..';
									gotoxy(44, 6);
									textcolor(LightMagenta); 
									write(Joke(joke1, joke2, joke3));
									textcolor(Red);
									gotoxy(54, 7);
									write('Votre score : ',score);
								end;
							if (score>5) and (score <=100) then
								begin
										joke1:='Essaye de viser un plus gros score !';
										joke2:='Pas mal du tout pour un debutant ...';
										joke3:='Continue a t''entrainer, ca va venir';
										gotoxy(44, 6);
										textcolor(LightMagenta); 
										write(Joke(joke1, joke2, joke3));
										textcolor(Red);
										gotoxy(54, 7);
										write('Votre score : ',score);
								end;
							if score>100 then
								begin
									joke1:='Tu commences a avoir un petit niveau';
									joke2:='Plus de 100 ! Incroyable, 2OO next ?';
									joke3:='Tu commences a maitriser le ballon !';
									gotoxy(44, 6);
									textcolor(LightMagenta); 
									write(Joke(joke1, joke2, joke3));
									textcolor(Red);
									gotoxy(57, 7);
									write('Votre score : ',score);
								end;
							gotoxy(45, 9);
							textcolor(White);
							writeln('Appuyez sur espace pour continuer');
							repeat
								// défaite donc retour au menu principal grâce à espace, possibilité d'enregister le score de la partie
								if KeyPressed then
									begin
										reponse := ReadKey;
										if reponse = #32 then
											begin
												retourAuMenuPrincipal := True;
												Enregistrement;
											end
										else
											retourAuMenuPrincipal := False;
									end;
							until retourAuMenuPrincipal;
						end;
				end;
		end;
end;

end.
