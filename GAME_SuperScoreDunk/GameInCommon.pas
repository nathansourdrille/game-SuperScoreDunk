unit GameInCommon;

// GameInCommon regroupe les variables, fonctions et le type partagés par différentes unités du programme 

interface

// déclaration des bibliothèques utiles à l'unité
uses 
	crt, sysutils, 
	sdl2,sdl2_image, SDL2_MIXER, sdl2_ttf;
	
// déclaration du type Bouttons nécessaire à la SDL graphique et commun aux unités GameMenu et GameGraphique
// stockage des textures SDL graphique pour les boutons du jeu
Type Bouttons = record 
	 basket : PSDL_Texture ;
end;

// déclaration des variables utiles à l'unité
var 
	score, HauteurEcran, NombreDePaniers : integer;
	codeCouleurBallon, codeCouleurBordures, codeCouleurPaniers : integer;
	nomFichier : String;
	// couleurs par défaut 
    CouleurBallonChoisi : String = 'Blue'; 
    CouleurBorduresChoisi : String = 'Green';
    CouleurPaniersChoisi : String = 'White';
    TempsDebutCouleur : Cardinal;

// déclaration des procédures et fonctions
function ObtenirCodeCouleur(const nomCouleur : String) : Integer;
function Joke(joke1, joke2, joke3 : String) : String;
  
implementation

// conversion de la couleur entrée par l'utilisateur (= une chaîne de caractères) en code de couleur CRT utilisable par textcolor()
// --> la fonction prend en paramètre le nom d'une couleur (nomCouleur) qui est une chaîne de caractères et renvoie le code CRT associé (un integer)
// "Red" correspond à un numéro CRT donc il est naturel que la fonction renvoie un integer 
function ObtenirCodeCouleur(const nomCouleur : String) : Integer;
begin
	case nomCouleur of 
		'Red':
			ObtenirCodeCouleur := Red;
		'Blue':
			ObtenirCodeCouleur := Blue;
		'White':
			ObtenirCodeCouleur := White;
		'Black':
			ObtenirCodeCouleur := Black;
		'Green':
			ObtenirCodeCouleur := Green;
		'Cyan':
			ObtenirCodeCouleur := Cyan;
		'Magenta':
			ObtenirCodeCouleur := Magenta;
		'Brown':
			ObtenirCodeCouleur := Brown;
		'LightGray':
			ObtenirCodeCouleur := LightGray;
		'DarkGray':
			ObtenirCodeCouleur := LightBlue;
		'LightBlue':
			ObtenirCodeCouleur := LightGreen;
		'LightGreen':
			ObtenirCodeCouleur := LightGreen;
		'LightCyan':
			ObtenirCodeCouleur := LightCyan;
		'LightRed':
			ObtenirCodeCouleur := LightRed;
		'LightMagenta':
			ObtenirCodeCouleur := LightMagenta;
		'Yellow':
			ObtenirCodeCouleur := Yellow;
    end;
end;

// prise en compte d'une des trois phrases associé au score du joueur, on y associe une valeur de 0 à 2 et on utilise la fonction random() pour afficher au hasard l'une des phrases 
function Joke(joke1, joke2, joke3 : String) : String;
begin
	random(2);
	if random(2) = 0 then
		joke:=joke1
	else if random(2) = 1 then
		joke:=joke2
	else 
		joke:=joke3
end;

end.
