Unit GameGraphique;

interface

uses 
	sdl2,sdl2_image, SDL2_MIXER, sdl2_ttf,sysutils;


{ TSpriteSheet est une feuille de textures qui contient toutes les textures du jeu }
Type TSpriteSheet = record { Definition du type enregistrement }
	ballon, background, bordure_haut, bordure_bas : PSDL_Texture ;
end;

const 
SPRITESIZE = 16;
LONGUEUR = 64;
LARGEUR = 32;
SURFACEWIDTH = 1024;
SURFACEHEIGHT = 800;

const
    IMAGEWIDTH=1024; {largeur en pixels de l'image}
    IMAGEHEIGHT=800; {hauteur en pixels de l'image}

procedure initialise(var sdlwindow: PSDL_Window; var sdlRenderer:PSDL_Renderer);
function initSprites(sdlRenderer:PSDL_Renderer):TSpriteSheet;
procedure drawScene (var sdlRenderer:PSDL_Renderer; sprite_sheet: TSpriteSheet); {On affiche la scene de jeu }
procedure MenuAffiche(var sdlRenderer: PSDL_Renderer; var basket: PSDL_TEXTURE);
procedure termine(var sdlwindow: PSDL_WINDOW; var sdlRenderer:PSDL_Renderer);
procedure CoordoneeClic(mouseEvent:TSDL_MouseButtonEvent; var x,y:LongInt);
procedure Selection(var Clique:Boolean; var choix: Char);


implementation

{Procedure d'initialisation des elements de l'affichage: 
* la fenetre et l'image}
procedure initialise(var sdlwindow: PSDL_Window; var sdlRenderer:PSDL_Renderer);
begin
	{charger la bibliotheque}
	SDL_Init(SDL_INIT_VIDEO);
  	SDL_Init(SDL_INIT_AUDIO);

	{initialiser la surface de la fenetre: largeur, hauteur}
	SDL_CreateWindowAndRenderer(SURFACEWIDTH, SURFACEHEIGHT, SDL_WINDOW_SHOWN, @sdlwindow, @sdlRenderer);

end;

{Procedure pour quitter proprement la SDL}
procedure termine(var sdlwindow: PSDL_WINDOW; var sdlRenderer:PSDL_Renderer);
begin
	{vider la memoire correspondant a l'image et a la fenetre}
	SDL_DestroyRenderer(sdlRenderer);
	SDL_DestroyWindow(sdlwindow);

	{decharger les bibliotheques}
	SDL_Quit();
end;


function initSprites(sdlRenderer:PSDL_Renderer):TSpriteSheet;
{On charge les textures en memoire }
var newSpriteSheet : TSpriteSheet;
begin
	newSpriteSheet.ballon := IMG_LoadTexture (sdlRenderer, 'ressources/ballon.png');
	newSpriteSheet.background := IMG_LoadTexture(sdlRenderer, 'ressources/background.png');
	newSpriteSheet.bordure_haut := IMG_LoadTexture(sdlRenderer, 'ressources/bordure_haut.png');
	newSpriteSheet.bordure_bas := IMG_LoadTexture(sdlRenderer, 'ressources/bordure_bas.png');
	initSprites:=newSpriteSheet;
end;

procedure drawScene (var sdlRenderer:PSDL_Renderer; sprite_sheet: TSpriteSheet); {On affiche la scene de jeu }
var i,j: Integer ;
	destination_rect : TSDL_RECT ;
begin
	//SDL_RenderClear(sdlRenderer);
	{ Les dessins sont faits en arriere plan sur une surface invisible }
	{On remplit la surface de terre }
	for i:=1 to LARGEUR do
	begin
		for j:=1 to LONGUEUR do
		begin
			destination_rect.y:= i*SPRITESIZE - SPRITESIZE;
			destination_rect.x:= j*SPRITESIZE - SPRITESIZE;
			destination_rect.w:= SPRITESIZE ;
			destination_rect.h:= SPRITESIZE ;


			case i of 
				1: begin SDL_RenderCopy (sdlRenderer, sprite_sheet.bordure_haut, NIL, @destination_rect);end;
				32: begin SDL_RenderCopy (sdlRenderer, sprite_sheet.bordure_bas, NIL, @destination_rect);end;
				else SDL_RenderCopy (sdlRenderer, sprite_sheet.background, NIL, @destination_rect);
			end;
		end;
	end;

	destination_rect.y:= 16;
	destination_rect.x:= 0;
	destination_rect.w:= SPRITESIZE ;
	destination_rect.h:= SPRITESIZE ;
	SDL_RenderCopy (sdlRenderer, sprite_sheet.ballon, NIL, @destination_rect);

	{On a finit le calcul on bascule la surface }
	SDL_RenderPresent(sdlRenderer)
end;

{Procedure d'affichage}
procedure MenuAffiche(var sdlRenderer: PSDL_Renderer; var basket: PSDL_TEXTURE);
	var destination_rect : TSDL_RECT;
begin

    {Boutton Classement}
	destination_rect.x:=(SURFACEWIDTH - IMAGEWIDTH) div 2;
	destination_rect.y:= (SURFACEHEIGHT- IMAGEHEIGHT) div 2;
	destination_rect.w:=IMAGEWIDTH;
	destination_rect.h:=IMAGEHEIGHT;
	

	SDL_RenderCopy(sdlRenderer, basket, nil, @destination_rect);

	{Générer le rendu de la nouvelle image}
	SDL_RenderPresent(sdlRenderer);
end;

{Gestion clic souris}
procedure CoordoneeClic(mouseEvent:TSDL_MouseButtonEvent; var x,y:LongInt);
begin
	{recuperation des coordonnees}
  	x:=mouseEvent.x;
	y:=mouseEvent.y;
end; 

procedure Selection(var Clique:Boolean; var choix: Char);
var x,y:LongInt;
    event: TSDL_Event;

begin
    Clique:=False;

    repeat
        SDL_PollEvent(@event);
        if event.type_=SDL_MOUSEBUTTONDOWN then
            begin
            CoordoneeClic(event.button,x,y);
            Clique:=True;
            end;
    until Clique;

    if (x > (SURFACEWIDTH - IMAGEWIDTH) div 2) and ( x<(SURFACEWIDTH + IMAGEWIDTH) div 2) and
        ( y > 250) and (y<375)
        then 
            choix:='j';
    if (x>(SURFACEWIDTH - IMAGEWIDTH) div 2) and (x<(SURFACEWIDTH + IMAGEWIDTH) div 2) and (y>400) and (y<575)
        then 
            choix:='s';
    if (x>(SURFACEWIDTH - IMAGEWIDTH) div 2) and (x<(SURFACEWIDTH + IMAGEWIDTH) div 2) and (y>550) and (y<675)
        then 
            choix:='q';
end;

begin

end.
