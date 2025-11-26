program image;

uses sdl2,sdl2_image, SDL2_MIXER;

const
	SURFACEWIDTH=640; {largeur en pixels de la surface de jeu}
	SURFACEHEIGHT=512; {hauteur en pixels de la surface de jeu}
	IMAGEWIDTH=194; {largeur en pixels de l'image}
	IMAGEHEIGHT=187; {hauteur en pixels de l'image}
	SPRITESIZE=64; {taille des sprites}

	AUDIO_FREQUENCY:INTEGER=22050;
	AUDIO_FORMAT:WORD=AUDIO_S16;
	AUDIO_CHANNELS:INTEGER=2;
	AUDIO_CHUNKSIZE:INTEGER=4096;

    {TSpriteSheet est une feuille de textures qui contient toutes les textures du jeu}
    Type TSpriteSheet=record {Definition du type enregistrement}
        grass, up,down,right,left,donkrieg:PSDL_Texture;
    end;
  
  
	type direction=(gauche,droite,haut,bas);

	Type coord=record
		x,y:Integer;
		dir : direction;
	end;


{Procedure d'initialisation des elements de l'affichage: 
* la fenetre et l'image}
procedure initialise(var sdlwindow: PSDL_Window; var sdlRenderer:PSDL_Renderer;var sword : PSDL_TEXTURE);
begin
	{charger la bibliotheque}
	SDL_Init(SDL_INIT_VIDEO);
  	SDL_Init(SDL_INIT_AUDIO);

	{création de la fenêtre et du rendu de l'affichage}
	SDL_CreateWindowAndRenderer(SURFACEWIDTH, SURFACEHEIGHT, SDL_WINDOW_SHOWN, @sdlwindow, @sdlRenderer);								
	{chargement de l'image comme texture}									
	sword := IMG_LoadTexture(sdlRenderer, 'epee.png');

end;

{Procedure pour quitter proprement la SDL}
procedure termine(var sdlwindow: PSDL_WINDOW; var sdlRenderer:PSDL_Renderer; var sword : PSDL_TEXTURE; var sound : pMIX_MUSIC);
begin
	{vider la memoire correspondant a l'image et a la fenetre}
	SDL_DestroyTexture(sword);	
	SDL_DestroyRenderer(sdlRenderer);
	SDL_DestroyWindow(sdlwindow);
	{vider la memoire correspondant au son}
	MIX_FREEMUSIC(sound);
	Mix_CloseAudio();
	{decharger les bibliotheques}
	Mix_CloseAudio();
	SDL_Quit();
end;

{Procedure de mise en musique}
procedure son(var sound : pMIX_MUSIC);
begin
	{charger la bibliothèque}
    if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT,AUDIO_CHANNELS, 
		AUDIO_CHUNKSIZE)<>0 then HALT;
		
	{Charger le fichier son}
	sound := MIX_LOADMUS('Automotivo Bibi Fogosa (Instrumental) 1 hour_j-RPj_FEHCE.mp3');

	{Choisir le volume et lancer le son}
    MIX_VolumeMusic(MIX_MAX_VOLUME);
    MIX_PlayMusic(sound, -1);
end;


function initSprites(sdlRenderer:PSDL_Renderer):TSpriteSheet;
{On charge les textures en mémoire}
var newSpriteSheet : TSpriteSheet;
begin
    
    newSpriteSheet.grass:=IMG_LoadTexture(sdlRenderer, 'herbe.png');
    //newSpriteSheet.up:=IMG_LoadTexture(sdlRenderer,'ressources/haut.png');
    //newSpriteSheet.down:=IMG_LoadTexture(sdlRenderer,'ressources/bas.png');
    //newSpriteSheet.right:=IMG_LoadTexture(sdlRenderer,'ressources/droite.png');
    //newSpriteSheet.left:=IMG_LoadTexture(sdlRenderer,'ressources/gauche.png');
    newSpriteSheet.donkrieg:=IMG_LoadTexture(sdlRenderer,'donkrieg.png');
    initSprites:=newSpriteSheet;
end;


procedure disposeSprite(sprite_sheet: TSpriteSheet);
{On décharge les textures de la mémoire}
begin
    SDL_DestroyTexture(sprite_sheet.grass);
    //SDL_DestroyTexture(sprite_sheet.ups);
    //SDL_DestroyTexture(sprite_sheet.down);
    //SDL_DestroyTexture(sprite_sheet.right);
    //SDL_DestroyTexture(sprite_sheet.left);
    SDL_DestroyTexture(sprite_sheet.donkrieg);

end;



{Procedure d'affichage}
procedure affiche(var sdlRenderer: PSDL_Renderer; sword: PSDL_TEXTURE);
	var destination_rect : TSDL_RECT;
begin
	{Choix de la position et taille de l'element a afficher}
	destination_rect.x:=(SURFACEWIDTH - IMAGEWIDTH) div 2;
	destination_rect.y:=(SURFACEHEIGHT - IMAGEHEIGHT) div 2;
	destination_rect.w:=IMAGEWIDTH;
	destination_rect.h:=IMAGEHEIGHT;
	
	{Coller l'element sword dans le rendu en cours avec les 
	* caracteristiques destination_rect}
	SDL_RenderCopy(sdlRenderer, sword, nil, @destination_rect);

	{Générer le rendu de la nouvelle image}
	SDL_RenderPresent(sdlRenderer);
end;

procedure drawScene(screen:PSDL_Window;var sdlRenderer:PSDL_Renderer; sprite_sheet: TSpriteSheet; gentil, mechant : coord);
{On affiche la scène de jeu à l'écran}
var i,j:Integer;
    destination_rect:TSDL_RECT;
    player_sprite:PSDL_Texture;
begin
		SDL_RenderClear(sdlRenderer);
		{Les dessins sont faits en arrière plan sur une surface invisible à l'écran }
       {On remplit la surface de gazon}
       for i:=0 to ((SURFACEWIDTH div SPRITESIZE) -1) do
        for j:=0 to ((SURFACEHEIGHT div SPRITESIZE )-1) do
       
        begin
            {Rectangle de la surface où viendra se placer le sprite du gazon}
            {Attention, les coordonées (0,0) sont en haut à gauche}
            destination_rect.x:=i*SPRITESIZE;
            destination_rect.y:=j*SPRITESIZE;
            destination_rect.w:=SPRITESIZE;
            destination_rect.h:=SPRITESIZE;
            {On affiche sur la surface un bout de gazon}
            SDL_RenderCopy(sdlRenderer, sprite_sheet.grass, nil, @destination_rect);

        end;
       {Rectangle de la surface où viendra se placer le sprite du heros}
       destination_rect.x:=gentil.x*SPRITESIZE;
       destination_rect.y:=gentil.y*SPRITESIZE;
       destination_rect.w:=SPRITESIZE;
       destination_rect.h:=SPRITESIZE;
       {On choisit la texture du chat suivant son orientation}
       case gentil.dir of
           droite: player_sprite:=sprite_sheet.right;
           gauche: player_sprite:=sprite_sheet.left;
           bas: player_sprite:=sprite_sheet.down;
           haut: player_sprite:=sprite_sheet.up;
       end;
       {On affiche sur la surface le chat}
       //SDL_BlitSurface(player_sprite,NIL,screen,@destination_rect);
       SDL_RenderCopy(sdlRenderer, player_sprite, nil, @destination_rect);
       
       {Rectangle de la surface où viendra se placer le sprite du méchant}
       destination_rect.x:=mechant.x*SPRITESIZE;
       destination_rect.y:=mechant.y*SPRITESIZE;
       destination_rect.w:=SPRITESIZE;
       destination_rect.h:=SPRITESIZE;
       //SDL_BlitSurface(p_sprite_sheet^.badguy,NIL,screen,@destination_rect);
		SDL_RenderCopy(sdlRenderer, sprite_sheet.donkrieg, nil, @destination_rect);
      
       {On a fini le calcul on génère l'affichage à l'écran}
       SDL_RenderPresent(sdlRenderer)
end;

{gestion clavier}
procedure processKey(key:TSDL_KeyboardEvent;var gentil:coord);
begin
    {Suivant la touche appuyée on change la direction du heros et on le déplace
    * sans sortir de la fenetre}
    {Attention, les coordonées (0,0) sont en haut à gauche}
    case key.keysym.sym of
        SDLK_LEFT:  begin
                        gentil.dir:=gauche;
                        if gentil.x>0 then
                            gentil.x:=gentil.x-1;
                    end;
        SDLK_RIGHT: begin
                       gentil.dir:=droite;
                        if gentil.x< (SURFACEWIDTH div SPRITESIZE) -1 then
                            gentil.x:=gentil.x+1;
                    end;
        SDLK_UP:    begin
                        gentil.dir:=haut;
                        if gentil.y>0 then
                            gentil.y:=gentil.y-1;
                    end;
        SDLK_DOWN:  begin
                        gentil.dir:=bas;
                        if gentil.y < (SURFACEHEIGHT div SPRITESIZE) -1 then
                            gentil.y:=gentil.y+1;
                    end;
    end;
    
    writeln(SDL_getKeyName(key.keysym.sym));
    
    
end;


{Gestion clic souris}
procedure processMouseEvent(mouseEvent:TSDL_MouseButtonEvent; var suite : Boolean);//mouseEvent = sdlEvent^.motion
var
   x,y : LongInt ;
begin
	{recuperation des coordonnees}
   //SDL_GetMouseState( x, y );
	x:=mouseEvent.x;
	y:=mouseEvent.y;
    {test de la position: dans l'image?}
   if (x > (SURFACEWIDTH - IMAGEWIDTH) div 2) and ( x<(SURFACEWIDTH + IMAGEWIDTH) div 2) 
		and ( y > (SURFACEHEIGHT - IMAGEHEIGHT) div 2) and ( y<(SURFACEHEIGHT + IMAGEHEIGHT) div 2) then
			suite:=True
	else
		suite:=False;
end; 
var fenetre: PSDL_Window;
	epee: PSDL_Texture;
	rendu: PSDL_Renderer;
	music: pMIX_MUSIC=NIL;
	event: TSDL_Event; {Un événement}
    suite,fin: boolean;
    heros,sorcier:coord;
    sprites:TSpriteSheet;
begin
	initialise(fenetre,rendu, epee);
	affiche(rendu,epee);
	son(music);
    //SDL_EnableKeyRepeat(0,500);// Obsolète, trouver une solution

  suite:=False;
  
 
	repeat
		{On se limite a 100 fps.}
		SDL_Delay(10);
		{On affiche la scene}
		affiche(rendu,epee);
		{On lit un evenement et on agit en consequence}
		SDL_PollEvent(@event);
	   
		if event.type_=SDL_MOUSEBUTTONDOWN then
		   processMouseEvent(event.button, suite);
		 
		if event.type_ = SDL_QUITEV then 
			suite:=True;	
	until suite;	
  
  {initialisations du jeu: boucle, textures, positions}
  fin:=False;
  sprites:=initSprites(rendu);
  heros.x:=0;
  heros.y:=0;
  heros.dir:=bas;
  
  sorcier.x:=5;
  sorcier.y:=5;
  
 
	repeat
		{On se limite a 25 fps.}
		SDL_Delay(40);
		{On affiche la scene}
		//procedure drawScene(screen:PSDL_Surface;var sdlRenderer:PSDL_Renderer; p_sprite_sheet: PSpriteSheet; gentil, mechant : coord);
		drawScene(fenetre,rendu, sprites,heros,sorcier);
		{On lit un evenement et on agit en consequence}
		SDL_PollEvent(@event);
	   
	   if event.type_=SDL_KEYDOWN then
			processKey(event.key,heros);
		 
		if event.type_ = SDL_QUITEV then 
			fin:=True;	
	  until fin;
	//procedure termine(var sdlwindow: PSDL_WINDOW; var sdlRenderer:PSDL_Renderer; var sword : PSDL_TEXTURE; var sound : pMIX_MUSIC);
	disposeSprite(sprites);
	termine(fenetre,rendu, epee, music);
end.
