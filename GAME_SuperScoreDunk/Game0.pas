unit Game0;

// Game0 initialise les variables du jeu à chaque nouvelle partie
// chaque début de partie est le même, pour ce qui concerne le ballon

interface

// déclaration de la bibliothèque utile à l'unité
uses 
	crt;

// déclaration de la procédure
procedure InitialisationDuJeu(var ballonX, ballonY, vitesse_du_ballon, gravite, score : integer);

implementation

// affichage initial du jeu à chaque nouvelle partie 
procedure InitialisationDuJeu(var ballonX, ballonY, vitesse_du_ballon, gravite, score : integer); 
begin
	ballonX := 15; // position initiale du ballon en x 
	ballonY := 10; // position initiale du ballon en y 
	vitesse_du_ballon := 0; // vitesse initiale du ballon
	gravite := 1; // gravité pour faire 'tomber' le ballon à la verticale
				  // cela donne de la fluidité au ballon
	score := 0; // initialisation du score à 0 à chaque partie
end;

end.
