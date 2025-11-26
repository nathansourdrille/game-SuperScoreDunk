unit GameDifficulty;

// GameDifficulty gère le niveau de difficulté du jeu
// la difficulté du jeu correspond uniquement à la position y de la bordure inférieure
// implicitement, la difficulté est aussi relativement plus basse lors des niveaux facile et moyen car pour ces niveaux de difficultés, selon certains positions y des paniers, lorsque la position x du panier dépasse la position x du ballon, il n'y a pas de défaite 

interface

// Type regroupant les quatre niveaux de difficulté du jeu
type NiveauxDeDifficulte = (Facile, Moyen, Difficile, Hardcore);

// déclaration de la fonction
function fBordureBasY(niveau : NiveauxDeDifficulte) : integer;

implementation

function fBordureBasY(niveau : NiveauxDeDifficulte) : integer;
begin
	case niveau of
		// détermine la valeur y de la bordure basse en fonction du choix du niveau de difficulté (à partir de "préférences" ou la seconde fenêtre graphique)
		Facile : fBordureBasY := 29;
		Moyen : fBordureBasY := 25;
		Difficile : fBordureBasY := 23;
		Hardcore : fBordureBasY := 21;
	end;
end;

end.

