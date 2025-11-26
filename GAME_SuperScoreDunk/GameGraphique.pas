Unit GameGraphique;

// GameGraphique gère l'affichage des deux fenêtres graphiques lors de l'exécution du programme

interface

// déclaration des bibliothèques utiles à l'unité
uses 
	sysutils, 
	sdl2,sdl2_image, SDL2_MIXER, sdl2_ttf;

// déclaration des constantes utiles à l'unité
const 
	SURFACEWIDTH = 1024;
	SURFACEHEIGHT = 800;
    IMAGEWIDTH = 1024;
    IMAGEHEIGHT = 800; 

// déclaration des fonctions
procedure initialise(var sdlwindow : PSDL_Window; var sdlRenderer : PSDL_Renderer);
procedure termine(var sdlwindow : PSDL_WINDOW; var sdlRenderer : PSDL_Renderer);
procedure MenuAffiche(var sdlRenderer : PSDL_Renderer; var basket : PSDL_TEXTURE);
procedure CoordoneeClic(mouseEvent : TSDL_MouseButtonEvent; var x,y : LongInt);
procedure SelectionScreen1(var Clique : Boolean; var choix : Char);
procedure SelectionScreen2(var Clique : Boolean; var choix : Char);

implementation

// initialisation de la SDL graphique
procedure initialise(var sdlwindow : PSDL_Window; var sdlRenderer : PSDL_Renderer);
begin
	SDL_Init(SDL_INIT_VIDEO);
  	SDL_Init(SDL_INIT_AUDIO);
	SDL_CreateWindowAndRenderer(SURFACEWIDTH, SURFACEHEIGHT, SDL_WINDOW_SHOWN, @sdlwindow, @sdlRenderer);
end;

// quitter la SDL graphique de manière propre
procedure termine(var sdlwindow : PSDL_WINDOW; var sdlRenderer : PSDL_Renderer);
begin
	SDL_DestroyRenderer(sdlRenderer);
	SDL_DestroyWindow(sdlwindow);
	SDL_Quit();
end;

// affichage de la fenêtre selon les constantes déclarées de manière globale
procedure MenuAffiche(var sdlRenderer : PSDL_Renderer; var basket : PSDL_TEXTURE);
var 
	destination_rect : TSDL_RECT;
begin
	destination_rect.x := (SURFACEWIDTH - IMAGEWIDTH) div 2;
	destination_rect.y := (SURFACEHEIGHT- IMAGEHEIGHT) div 2;
	destination_rect.w := IMAGEWIDTH;
	destination_rect.h := IMAGEHEIGHT;
	SDL_RenderCopy(sdlRenderer, basket, nil, @destination_rect);
	SDL_RenderPresent(sdlRenderer);
end;

// récupération des coordonnées du clic de la souris 
procedure CoordoneeClic(mouseEvent : TSDL_MouseButtonEvent; var x, y : LongInt);
begin
	x := mouseEvent.x;
	y := mouseEvent.y;
end; 

// gestion des clics de la souris pour la fenêtre graphique 1 
procedure SelectionScreen1(var Clique : Boolean; var choix : Char);
var 
	x,y : LongInt;
    event : TSDL_Event;
begin
	Clique := False; // aucun clique n'a été effectué
    repeat
		SDL_PollEvent(@event); // récupération d'un évènement
        if event.type_ = SDL_MOUSEBUTTONDOWN then // évènement : clique de la souris 
			begin
				CoordoneeClic(event.button,x,y); // récupération des coordonnées du clic
				Clique := True; // clique effectué
            end;
		until Clique; // répétition jusqu'au clique de l'utilisateur
		if (x > 350) and (x < 670) and (y > 600) and (y < 665) then  
			choix := 'q'; 
end;

// gestion des clics de la souris pour la fenêtre graphique 2
procedure SelectionScreen2(var Clique : Boolean; var choix : Char);
var 
	x, y : LongInt;
    event : TSDL_Event;
begin
	Clique := False;
    repeat
		SDL_PollEvent(@event);
        if event.type_ = SDL_MOUSEBUTTONDOWN then
			begin
				CoordoneeClic(event.button,x,y);
				Clique := True;
            end;
		until Clique;
		// selon les coordonnées du clic, choix prend une valeur différente, cela permet d'offrir plusieurs options au joueur, ici, il choisit la difficulté du jeu
		if (x > 110) and (x < 515) and (y > 100) and (y < 420) then 
			choix := 'q';
		if (x > 110) and (x < 515) and (y > 430) and (y < 755) then 
			choix := 's';
		if (x > 545) and (x < 950) and (y > 100) and (y < 420) then 
			choix := 't';
		if (x > 545) and (x < 950) and (y > 430) and (y < 755) then 
			choix := 'v';		
end;

end.
