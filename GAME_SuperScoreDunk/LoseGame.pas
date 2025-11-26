unit LoseGame;

interface

uses sdl2, sdl2_image, SDL2_MIXER, SDLson, crt, sysutils, CommunVar, Game0, PANIER;

procedure BorduresDuJeu(bordureHautY, bordureBasY, ballonY : integer; var retourAuMenuPrincipal: boolean);
procedure DefaiteBordures(bordureHautY, bordureBasY, ballonY, score : integer; var retourAuMenuPrincipal: boolean);

implementation

procedure DefaiteBordures(bordureHautY, bordureBasY, ballonY, score : integer; var retourAuMenuPrincipal: boolean);
var reponse : char;
var son : pMix_Chunk;
var joke1, joke2, joke3 : String;
begin
  if (ballonY <= bordureHautY) or (ballonY >= bordureBasY) then
  begin
    sonDefeat(son);
    if score <=4 then
    begin
    joke1:='La touche espace ne marchait plus !?';
    joke2:='Ton historique doit etre terrible ..';
	joke3:='Pas fou ce score, n''est-ce pas ? ..';
    gotoxy(44, 6);
    textcolor(LightMagenta); 
	write(Joke(joke1, joke2, joke3));
    textcolor(Red);
    gotoxy(54, 7);
    write('Votre score : ',score);
    end;
    if (score>5) and (score <=100) then
    begin
    joke1:='Essaye de viser un plus gros score !';
    joke2:='Pas mal du tout pour un debutant ...';
	joke3:='Continue a t''entrainer, ca va venir';
    gotoxy(44, 6);
    textcolor(LightMagenta); 
    write(Joke(joke1, joke2, joke3));
    textcolor(Red);
    gotoxy(54, 7);
    write('Votre score : ',score);
    end;
    if score>100 then
    begin
    joke1:='Tu commences a avoir un petit niveau';
    joke2:='Plus de 100 ! Incroyable, 2OO next ?';
	joke3:='Tu commences a maitriser le ballon !';
    gotoxy(44, 6);
    textcolor(LightMagenta); 
    write(Joke(joke1, joke2, joke3));
    textcolor(Red);
    gotoxy(57, 7);
    write('Votre score : ',score);
    end;
    gotoxy(45, 9);
    textcolor(White);
    writeln('Appuyez sur espace pour continuer');
    
    repeat
      if keypressed then 
      begin
        reponse := readkey;
        if reponse = #32 then
		  begin
          retourAuMenuPrincipal := true;
          Enregistrement;
          end
        else
          retourAuMenuPrincipal := false;
      end;
    until retourAuMenuPrincipal; // Attend la pression de la touche espace pour revenir au menu principal
  end;
end;

procedure BorduresDuJeu(bordureHautY, bordureBasY, ballonY : integer; var retourAuMenuPrincipal: boolean);
var x, z: integer;
begin
  // affichage de la bordure en haut de l'écran
  z := 120;
  x := 1; // pour ajuster la longueur de la bordure à la taille de l'écran pour donner l'aspect infinie à la bordure
  {for x := 1 to z do
  begin
    cursoroff;
    GotoXY(x, bordureHautY);
    write('-');
  end;}
  
  while x<z do
  begin
    cursoroff;
    GotoXY(x, bordureBasY);
    write('_');
    x:=x+3;
  end;
  
  DefaiteBordures(bordureHautY, bordureBasY, ballonY, score, retourAuMenuPrincipal);
end;

end.


