program SDLgraph;

uses sdl2, sdl2_image, SDL2_MIXER, sdl2_ttf,sysutils, crt;

const
	SURFACEWIDTH=1920;
	SURFACEHEIGHT=1200;
	IMAGEWIDTH=1920;
	IMAGEHEIGHT=1200;
	
	AUDIO_FREQUENCY : integer = 22050;
	AUDIO_FORMAT : word = audio_S16;
	AUDIO_CHANNELS : integer = 2;
	AUDIO_CHUNKSIZE : integer = 4096;
	
procedure initialiseBasket(var sdlwindow: PSDL_Window; var sdlRenderer: PSDL_Renderer; var basket: PSDL_TEXTURE);
begin
	SDL_Init(SDL_INIT_VIDEO);
	SDL_CreateWindowAndRenderer(SURFACEWIDTH, SURFACEHEIGHT, SDL_WINDOW_SHOWN, @sdlwindow, @sdlRenderer);
	basket := IMG_LoadTexture(sdlRenderer, 'basket.jpg');
end;

procedure termine(var sdlwindow: PSDL_WINDOW; var sdlRenderer: PSDL_Renderer; var basket: PSDL_TEXTURE);
begin
	SDL_DestroyTexture(basket);
	SDL_DestroyRenderer(sdlRenderer);
	SDL_DestroyWindow(sdlwindow);
	SDL_Quit();
end;

procedure afficheBasket(sdlRenderer: PSDL_RENDERER; basket: PSDL_TEXTURE);
var destination_rect: TSDL_RECT;
begin
	destination_rect.x:=(SURFACEWIDTH-IMAGEWIDTH) div 2;
	destination_rect.y:=(SURFACEHEIGHT-IMAGEHEIGHT) div 2;
	destination_rect.w:=IMAGEWIDTH;
	destination_rect.h:=IMAGEHEIGHT;
	SDL_RenderCopy(sdlRenderer, basket, nil, @destination_rect);
	SDL_RenderPresent(sdlRenderer);
end;

procedure sonChargement(var sound: pMix_MUSIC);
begin
	if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS, AUDIO_CHUNKSIZE) <> 0 then
		begin
			writeln('Erreur lors de l''ouverture audio : ', Mix_GetError());
			halt;
		end;
	sound := MIX_LOADMUS('MenuMusic.mp3');
	if sound = nil then
		begin
			writeln('Erreur lors du chargement du fichier audio : ', Mix_GetError());
			halt;
		end;
	MIX_VolumeMusic(MIX_MAX_VOLUME);
	MIX_PlayMusic(sound, -1);
end;

procedure termine_musique(var sound : pMix_MUSIC);
begin
	MIX_FREEMUSIC(sound);
	MIX_CloseAudio();
end;

procedure processMouseEvent(mouseEvent: TSDL_MouseButtonEvent; var suite : Boolean);
var x, y:LongInt;
begin
	x:=mouseEvent.x;
	y:=mouseEvent.y;
	if (x>(SURFACEWIDTH-IMAGEWIDTH)div 2) and (x>(SURFACEWIDTH+IMAGEWIDTH) div 2) and (y>(SURFACEWIDTH-IMAGEWIDTH)div 2) and (y>(SURFACEWIDTH+IMAGEWIDTH) div 2) then
		suite:=True
	else
		suite:=False;
	if suite = True then
	mouseEvent.x:=3;
	x:=mouseEvent.x
end;



var fenetre: PSDL_WINDOW;
	rendu: PSDL_Renderer;
	basket : PSDL_TEXTURE;
	event: TSDL_Event; {Un evenement}
    suite: boolean;
	
begin
	initialiseBasket(fenetre, rendu, basket);
	afficheBasket(rendu, basket);
	suite := false;
	repeat
	SDL_delay(1);
	afficheBasket(rendu, basket);
	SDL_PollEvent(@event);
		if event.Type_=SDL_MOUSEBUTTONDOWN then
					processMouseEvent(event.button, suite);
		if event.type_ = SDL_QUITEV then 
		suite:=True;
	until suite or (event.type_=SDL_QUITEV);
	termine(fenetre, rendu, basket);
end.
