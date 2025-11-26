unit GameDefeat;

// GameDefeat gère la condition de défaite du jeu, selon le niveau de difficulté choisi par le joueur, c'est à dire en cas de dépassement des bordures par le ballon et donc de l'espace de jeu

interface

// déclaration des bibliothèques et autres unités utiles à l'unité
uses 
	crt, sysutils, 
	sdl2, sdl2_image, SDL2_MIXER, sdl2_ttf,
	GameSound, 
	GameInCommon,
	Game0, 
	GameHoops,
	GameGraphique;

// déclaration des procédures 
procedure BorduresDuJeu(bordureHautY, bordureBasY, ballonY : integer; var retourAuMenuPrincipal, BorduresOff, Helllvl1 : boolean);
procedure DefaiteBordures(bordureHautY, bordureBasY, ballonY, score : integer; var retourAuMenuPrincipal, BorduresOff : boolean);

implementation

procedure DefaiteBordures(bordureHautY, bordureBasY, ballonY, score : integer; var retourAuMenuPrincipal, BorduresOff : boolean);
var 
	reponse : char;
	joke1, joke2, joke3 : String;
	son : pMix_Chunk;
begin
	// condition du mode de jeu "NoBoundaries" : l'ensemble des actions suivantes ne s'éxecute pas si le mdoe est activé car le joueur ne peut plus perdre en touchant l'une des bordures
	if BorduresOff = False then
		begin
			// condition de défaite : le ballon a dépassé (ou atteint) l'une des limites de l'espace de jeu
			if (ballonY <= bordureHautY) or (ballonY >= bordureBasY) then
				begin
					// son d'ambiance lors de la défaite du joueur lorsqu'il touche l'une des des bordures
					sonDefeat(son);
					// petite bibliothèqe de phrases qui s'affichent à la fin de la partie, de manière aléatoire
					// encourage le joueur à relancer une partie et à faire mieux que la précédente
					// les blagues varient en fonction du score du joueur (de la blague (score faible), aux encouragements (score élevé))
					if score <= 4 then
						begin
							joke1 := 'La touche espace ne marchait plus !?';
							joke2 := 'Ton historique doit etre terrible ..';
							joke3 := 'Pas fou ce score, n''est-ce pas ? ..';
							gotoxy(44, 6);
							textcolor(LightMagenta); 
							write(Joke(joke1, joke2, joke3));
							textcolor(Red);
							gotoxy(54, 7);
							write('Votre score : ',score);
						end;
					if (score > 5) and (score <= 100) then
						begin
							joke1 := 'Essaye de viser un plus gros score !';
							joke2 := 'Pas mal du tout pour un debutant ...';
							joke3 := 'Continue a t''entrainer, ca va venir';
							gotoxy(44, 6);
							textcolor(LightMagenta); 
							write(Joke(joke1, joke2, joke3));
							textcolor(Red);
							gotoxy(54, 7);
							write('Votre score : ',score);
						end;
					if score > 100 then
						begin
							joke1 := 'Tu commences a avoir un petit niveau';
							joke2 := 'Plus de 100 ! Incroyable, 2OO next ?';
							joke3 :='Tu commences a maitriser le ballon !';
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
					// retour au menu principal en appuyant sur espace, sinon il ne se passe rien
					repeat
						if keypressed then 
							begin
								reponse := readkey;
								if reponse = #32 then
									begin
										retourAuMenuPrincipal := true;
										// demande d'enregistrement du score de la partie 
										Enregistrement;
									end
								else
									retourAuMenuPrincipal := false;
							end;
					until retourAuMenuPrincipal; 
				end;
		end;
end;

procedure BorduresDuJeu(bordureHautY, bordureBasY, ballonY : integer; var retourAuMenuPrincipal, BorduresOff, Helllvl1 : boolean);
var 
	x, z: integer;
begin
	// affichage de la bordure inférieure du jeu  pour tous les modes de jeu ou l'affichage est autorisé 
	if BorduresOff = False then
		begin
			if Helllvl1 = True then
				textcolor(Black);
			z := 120;
			x := 1; 
			while x<z do
				begin
					cursoroff;
					GotoXY(x, bordureBasY);
					write('_');
					x:=x+3;
			end;
		end;
	// vérification des variables du jeu et affichage de l'écran de défaite si la partie est perdue
	DefaiteBordures(bordureHautY, bordureBasY, ballonY, score, retourAuMenuPrincipal, BorduresOff);
end;

end.


