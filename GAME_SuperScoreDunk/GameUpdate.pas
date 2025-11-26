unit GameUpdate;

// GameUpdate met à jour de manière continue l'état du jeu (ballon, paniers, bordures, modes de jeu, couleurs)

interface

// déclaration des bibliothèques et autres unités utiles à l'unité
uses 
	crt, sysutils,
	GameHoops,
	GameDefeat,
	GameInCommon;

// déclaration des procédures
procedure AffichageDuJeu(ballonX, ballonY, score : integer; BorduresOff, Helllvl1, Helllvl2, Helllvl3 : Boolean);
procedure ActualisationDuJeu(var score, ballonX, ballonY, vitesse_du_ballon, gravite : integer; var retourAuMenuPrincipal, Switch, Fast, DefeatOff, Boom : boolean);

implementation

procedure AffichageDuJeu(ballonX, ballonY, score : integer; BorduresOff, Helllvl1, Helllvl2, Helllvl3 : Boolean);
var 
	x, z : integer;
begin
	clrscr;
	textcolor(White);
	// affichage des paniers
	AfficherPaniers(Helllvl3);
	// affichage du nom du jeu et du score
	gotoxy(55, 26);
	textcolor(LightGray);
	write('SuperScoreDunk');
	gotoxy(57, 27);
	textcolor(Red);
	write('Score :  ', score);
	textcolor(Black);
	codeCouleurBallon := ObtenirCodeCouleur(CouleurBallonChoisi);
	textcolor(codeCouleurBallon);
	gotoxy(ballonX, ballonY);
    if (Helllvl2 or Helllvl3) = False then
        TempsDebutCouleur := GetTickCount64;
	if (Helllvl2 or Helllvl3) and ((GetTickCount64 - TempsDebutCouleur) mod 3000 < 2000) then
        begin
			codeCouleurBallon := ObtenirCodeCouleur(CouleurBallonChoisi);
			textcolor(codeCouleurBallon);
		end
	else
		textcolor(Black);
	
	if (Helllvl2 or Helllvl3) = False  then
		begin
			codeCouleurBallon := ObtenirCodeCouleur(CouleurBallonChoisi);
			textcolor(codeCouleurBallon);
		end;
	write('O');
	
	z:=120;
	x:=1;
	// la bordure prend la couleur choisie par l'utilisateur dans "preferences"
	codeCouleurBordures := ObtenirCodeCouleur(CouleurBorduresChoisi);
	textcolor(codeCouleurBordures);
	// conditions d'affichage de la bordure supérieure (idem aux conditions sur la bordure inférieure)
	if BorduresOff = False then
		begin
			if Helllvl1 = True then
				textcolor(Black);
			while x<z do
				begin
					// affichage de la bordure supérieure du jeu pour tous les modes de jeu ou l'affichage est autorisé 
					cursoroff;
					GotoXY(x, 3);
					write('_');
					x:=x+3;
				end;
		end;
end;

// gestion dynamique de l'état du jeu durant la partie (mise à jour de la trajectoire verticale du ballon et défilement des paniers)
procedure ActualisationDuJeu(var score, ballonX, ballonY, vitesse_du_ballon, gravite : integer; var retourAuMenuPrincipal, Switch, Fast, DefeatOff, Boom : boolean);
begin
	vitesse_du_ballon := vitesse_du_ballon + gravite; // mise à jour de la vitesse_du_ballon de manière dynamique en prenant en compte la dernière valeur de vitesse enregistrée et la gravité
	ballonY := ballonY + vitesse_du_ballon;
	// limites imposées au ballon, dans le cas ou le mode "NoBoundaries" est activé
	if ballonY >= 31 then
		ballonY := 30;
	if ballonY <= 1 then 
		ballonY := 1;
	// défilement des paniers de manière continue, permettant un défilement continue aussi dynamique que l'affichage du ballon
	FaireDefilerPaniers(ballonX, ballonY, vitesse_du_ballon, retourAuMenuPrincipal, Switch, Fast, DefeatOff, Boom); 
end;

end.

