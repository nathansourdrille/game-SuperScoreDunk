unit SDLson;

interface

uses sdl2, sdl2_image, SDL2_MIXER;

var 
  option: String;
  sound: pMIX_MUSIC;
  son : pMix_Chunk;

const 
  AUDIO_FREQUENCY: Integer = 22050;
  AUDIO_FORMAT: Word = AUDIO_S16;
  AUDIO_CHANNELS: Integer = 2;
  AUDIO_CHUNKSIZE: Integer = 4096;

procedure sonInGame1(var sound: pMix_Music);
procedure sonInGame2(var sound: pMix_Music);
procedure sonInGame3(var sound: pMix_MUSIC);
procedure sonInGame4(var sound: pMix_MUSIC);
procedure sonInGame5(var sound: pMix_MUSIC); 
procedure sonDefeat(var son : pMix_Chunk);
procedure son100(var son: pMix_Chunk);
procedure termine_musique(var sound: pMIX_MUSIC);
procedure sonInMenu(var sound: pMix_MUSIC);

implementation

procedure son100(var son: pMix_Chunk);
begin
	if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) then
		Halt(1);
	son:= Mix_LoadWAV('ScoreSound.mp3');
	Mix_PlayChannel(-1, son, 0);
	SDL_Delay(500);
	Mix_FreeChunk(son);
end;

procedure sonDefeat(var son : pMix_Chunk);
begin
	if (Mix_OpenAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) < 0) then
		Halt(1);
	son:= Mix_LoadWAV('DefeatSound.mp3');
	Mix_PlayChannel(-1, son, 0);
	SDL_Delay(2000);
	Mix_FreeChunk(son);
end;

procedure sonInGame1(var sound: pMix_MUSIC);
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

procedure sonInGame2(var sound: pMix_MUSIC);
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

procedure sonInGame3(var sound: pMix_MUSIC);
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

procedure sonInGame4(var sound: pMix_MUSIC);
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

procedure sonInGame5(var sound: pMix_MUSIC);
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

procedure sonInMenu(var sound: pMix_MUSIC);
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

procedure termine_musique(var sound: pMIX_MUSIC);
begin	
  MIX_FREEMUSIC(sound);
  Mix_CloseAudio();
end;

end.
