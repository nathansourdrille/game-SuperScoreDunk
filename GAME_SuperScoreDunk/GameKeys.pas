unit GameKeys;

// GameKeys gère l'entrée clavier de la touche "espace", directement liée à la méchanique au coeur du jeu

interface 

// déclaration de la bibliothèque utile à l'unité
uses 
	crt;

// déclaration de la procédure
procedure MechaniqueDuBallon(var vitesse_du_ballon : integer);

implementation

procedure MechaniqueDuBallon(var vitesse_du_ballon : integer);
begin
	if keypressed then 
		// appuyer sur "espace" permet au ballon de monter de manière verticale
		if readkey = ' ' then 
			vitesse_du_ballon := -3; // on utilise une variable vitesse_du_ballon pour donner de la fluidité au ballon dans son affichage
			// une vitesse négative est fournie au ballon car l'axe y du terminal est orientée du haut vers le bas donc le ballon 'monte' lorsque la valeur de y baisse
end;

end.
