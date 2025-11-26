program SuperScoreDunk; 

// déclaration des bibliothèques et de l'unité utiles au programme
uses
	crt,
	sdl2, SDL2_MIXER, SDLson,
	GameMenu;
  
// déclaration des variables utiles au programme
var
	option : String; 
	sound : pMIX_MUSIC;
 
// programme principal
begin
	// répétition juqu'à ce que le joueur quitte le jeu
	repeat
		cursoroff;
		option := ' '; 
		Screen1(option); // lancement de la première fenêtre graphique
		MenuPrincipal(ouvrirMenuScreen2(option)); // lancement de la seconde fenêtre graphique et exécution du menu 
		termine_musique(sound) // quitter proprement la SDL son
	until false;
end.
