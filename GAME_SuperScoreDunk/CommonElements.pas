unit GameInCommun;

interface

uses crt, sdl2, sdl2_image, SDL2_MIXER, SDLson;

var score, HauteurEcran : integer;
	codeCouleurBallon, codeCouleurBordures, codeCouleurPaniers : integer;
	nomFichier : String;
    CouleurBallonChoisi : String = 'White'; 
    CouleurBorduresChoisi : String = 'Red';
    CouleurPaniersChoisi : String = 'LightGray';// Couleurs par défaut

function ObtenirCodeCouleur(const nomCouleur: String): Integer;
function Joke(joke1, joke2, joke3 : String): String;
  
implementation

function ObtenirCodeCouleur(const nomCouleur: String): Integer; // PERMET DE POUVOIR UTILISER TEXTCOLOR AVEC LE STRING COULEUR RENTRE PAR L'UTILISATEUR
begin
  // Convertir le nom de couleur en code de couleur CRT
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

function Joke(joke1, joke2, joke3 : String): String;
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
