unit GameSound;

// GameSound gère les musiques et sons du jeu, ainsi que leur fonctionnement (permenant ou momentané)

interface

// déclaration des bibliothèques utiles à l'unité
uses 
	sdl2, sdl2_image, SDL2_MIXER;

// déclaration des constantes utiles à l'unité
const 
	AUDIO_FREQUENCY : Integer = 22050;
	AUDIO_FORMAT : Word = AUDIO_S16;
	AUDIO_CHANNELS : Integer = 2;
	AUDIO_CHUNKSIZE : Integer = 4096;

// déclaration des variables utiles à l'unité
var 
	option: String; // choix de la musique par le joueur, sauvegarde du choix ensuite
	sound: pMIX_MUSIC; // pMix_Music permet de répéter à l'infini la musique à la fin de celle-ci 
	son : pMix_Chunk; // pMix_Chunk joue une seule fois le son, possibilité d'introduire un délai avant une prochaine action du programme

// déclaration des procédures
procedure sonScore(var son : pMix_Chunk);
procedure sonDefeat(var son : pMix_Chunk);
procedure sonInGame1(var sound : pMix_Music);
procedure sonInGame2(var sound : pMix_Music);
procedure sonInGame3(var sound : pMix_MUSIC);
procedure sonInGame4(var sound : pMix_MUSIC);
procedure sonInGame5(var sound : pMix_MUSIC); 
procedure sonInMenu(var sound : pMix_MUSIC);
procedure termine_musique(var sound : pMIX_MUSIC);

implementation

// lancement d'un son d'ambiance lorsque le joueur atteinte un palier important en terme de score
procedure sonScore(var son : pMix_Chunk);
begin
	if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) then
		Halt(1);
	son := Mix_LoadWAV('ScoreSound.mp3');
	Mix_PlayChannel(-1, son, 0);
	SDL_Delay(500); // lorsque le joueur atteinte un palier de score précis, le jeu se met en pause durant 5000ms (= 5sec) pour mettre en évidence le score atteint
	Mix_FreeChunk(son);
end;

// lancement d'un son d'ambiance lorsque le joueur perd la partie à cause du ballon qui atteint l'une des deux limites de l'espace de jeu
procedure sonDefeat(var son : pMix_Chunk);
begin
	if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) then
		Halt(1);
	son:= Mix_LoadWAV('DefeatSound.mp3');
	Mix_PlayChannel(-1, son, 0);
	SDL_Delay(2000);
	Mix_FreeChunk(son);
end;

// première musique disponible en jeu
procedure sonInGame1(var sound : pMix_MUSIC);
begin
	if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS, AUDIO_CHUNKSIZE) <> 0 then
		begin
			writeln('Erreur lors de l''ouverture audio : ', Mix_GetError());
			halt;
		end;
	sound := MIX_LOADMUS('InGameMusic1.mp3');
	if sound = nil then
		begin
			writeln('Erreur lors du chargement du fichier audio : ', Mix_GetError());
			halt;
		end;
	MIX_VolumeMusic(MIX_MAX_VOLUME);
	MIX_PlayMusic(sound, -1);
end;

// seconde musique disponible en jeu
procedure sonInGame2(var sound : pMix_MUSIC);
begin
	if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS, AUDIO_CHUNKSIZE) <> 0 then
		begin
			writeln('Erreur lors de l''ouverture audio : ', Mix_GetError());
			halt;
		end;
	sound := MIX_LOADMUS('InGameMusic2.mp3');
	if sound = nil then
		begin
			writeln('Erreur lors du chargement du fichier audio : ', Mix_GetError());
			halt;
		end;
	MIX_VolumeMusic(MIX_MAX_VOLUME);
	MIX_PlayMusic(sound, -1);
end;

// troisième musique disponible en jeu
procedure sonInGame3(var sound : pMix_MUSIC);
begin
	if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS, AUDIO_CHUNKSIZE) <> 0 then
		begin
			writeln('Erreur lors de l''ouverture audio : ', Mix_GetError());
			halt;
		end;
	sound := MIX_LOADMUS('InGameMusic3.mp3');
	if sound = nil then
		begin
			writeln('Erreur lors du chargement du fichier audio : ', Mix_GetError());
			halt;
		end;
	MIX_VolumeMusic(MIX_MAX_VOLUME);
	MIX_PlayMusic(sound, -1);
end;

// quatrième musique disponible en jeu
procedure sonInGame4(var sound : pMix_MUSIC);
begin
	if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS, AUDIO_CHUNKSIZE) <> 0 then
		begin
			writeln('Erreur lors de l''ouverture audio : ', Mix_GetError());
			halt;
		end;
	sound := MIX_LOADMUS('InGameMusic4.mp3');
	if sound = nil then
		begin
			writeln('Erreur lors du chargement du fichier audio : ', Mix_GetError());
			halt;
		end;
	MIX_VolumeMusic(MIX_MAX_VOLUME);
	MIX_PlayMusic(sound, -1);
end;

// cinquième musique disponible en jeu
procedure sonInGame5(var sound : pMix_MUSIC);
begin
	if MIX_OpenAudio(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS, AUDIO_CHUNKSIZE) <> 0 then
		begin
			writeln('Erreur lors de l''ouverture audio : ', Mix_GetError());
			halt;
		end;
	sound := MIX_LOADMUS('InGameMusic5.mp3');
	if sound = nil then
		begin
			writeln('Erreur lors du chargement du fichier audio : ', Mix_GetError());
			halt;
		end;
	MIX_VolumeMusic(MIX_MAX_VOLUME);
	MIX_PlayMusic(sound, -1);
end;

// musique dans le menu (non-modifiable par le joueur)
procedure sonInMenu(var sound : pMix_MUSIC);
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

// quitter proprement la SDL son
procedure termine_musique(var sound : pMIX_MUSIC);
begin	
	MIX_FREEMUSIC(sound);
	Mix_CloseAudio();
end;

end.
