program menu;

uses Crt, ptcCrt, ptcGraph, MMSystem, UNIT_MODOS_DE_JUEGO;

var
Driver, Modo: integer;
tecla: char = 'a';

Procedure IniciarModoGrafico;
begin
{
    Inicia el modo grafico. Pantalla 640px * 480px.
}
Driver := VGA;
Modo := VgaHi;
InitGraph(Driver, Modo, 'c:\tp\bgi');
end;

Procedure DrawMenu;
begin
{
    Dibujo el menu con las opciones para seleccionar.
}
    setcolor(white);
    SetTextStyle(0,HorizDir,2);
    OutTextXY(250, 20, 'Pong Game');
    Line(250, 40, 390, 40);
    Line(250, 45, 390, 45);
    OutTextXY(250, 100, 'Jugar [J]');
    OutTextXY(250, 130, 'Ayuda [A]');
    OutTextXY(235, 160, 'Salir [Esc]');
end;

Procedure DrawAyuda;
{
    Dibujo la ayuda para el jugador.
}
begin
setcolor(white);
OutTextXY(15, 20, 'Pong es un videojuego basado en tenis '); 
OutTextXY(15, 40, 'de mesa o ping pong, en el cual los');
OutTextXY(15, 60, 'jugadores deben moverse verticalmente');
OutTextXY(15, 80, '(usando las teclas W & S y UpArrow &');
OutTextXY(15, 100, 'DownArrow) y golpear una pelota');
OutTextXY(15, 120, 'logrando que el otro jugador no');
OutTextXY(15, 140, 'devuelva el tiro.');
OutTextXY(15, 180, 'Alumnos:');
OutTextXY(15, 200, 'Eric Anderson y Ramiro Parra.');
OutTextXY(15, 220, 'Docentes:');
OutTextXY(15, 240, 'Leonardo Moreno y Juan Manuel Cortez');
SetColor(cyan);
OutTextXY(250, 280, 'UNPSJB');
SetColor(white);
OutTextXY(70, 320, 'Para volver al menu presione');
OutTextXY(200, 340, '<BACKSPACE>')
end;

procedure DrawSeleccionarModoJuego;
begin
setcolor(white);
OutTextXY(15, 20, 'Jugador contra maquina:');
OutTextXY(60, 60, 'Facil [1]');
setfillstyle(1,white);
fillellipse(50, 67, 2, 2);
OutTextXY(60, 100, 'Intermedio [2]');
fillellipse(50, 107, 2, 2);
OutTextXY(60, 140, 'Dificil [3]');
fillellipse(50, 147, 2, 2);
OutTextXY(15, 180, 'Jugador contra jugador (local) [4]');
end;

begin {program}
IniciarModoGrafico;
while (tecla <> #27) do // Mientras el usuario esté en el menu, y no presione la tecla Esc, el programa seguirá corriendo.
    begin
        PlaySound('StartupMenu.wav',0,1);
        ClearDevice;
        DrawMenu; // Dibuja menu.
        tecla:= readkey;
            case tecla of
                ('a'), ('A'): // El usuario presiona 'a' o 'A' para ingresar al menu de ayuda
                begin
                PlaySound('MenuSelect.wav',0,1);
                    while (tecla <> #8) do // El usuario regresa al menu al presionar <Backspace>
                        begin
                            ClearDevice;
                            DrawAyuda; // Dibuja menu de ayuda.
                            tecla:= readkey;
                            if tecla = #27 then
                            begin
                                exit
                            end;
                        end; {while}
                end; {ayuda}
                ('j'), ('J'): // El usuario presiona 'j' o 'J' para jugar.
                begin
                PlaySound('MenuSelect.wav',0,1);
                    while (tecla <> #8) do // El usuario debe presionar <Backspace para volver al menu>
                        begin
                            ClearDevice;
                            DrawSeleccionarModoJuego; // Dibuja menu de seleccion de modo.
                            tecla:= readkey;
                            if tecla = #27 then
                            begin
                                exit
                            end;
                                case tecla of
                                #49: // Si el usuario ingresa '1'
                                    begin
                                        ClearDevice;
                                        PlaySound('GamemodeSelect.wav',0,1);
                                        PONG1VSIA_FACIL;
                                    end;
                                #50: // Si el usuario ingresa '2'
                                begin
                                    ClearDevice;
                                    PlaySound('GamemodeSelect.wav',0,1);
                                    PONG1VSIA_INTERMEDIO;
                                end;
                                #51: // Si el usuario ingresa '3'
                                begin
                                    ClearDevice;
                                    PlaySound('GamemodeSelect.wav',0,1);
                                    PONG1VSIA_DIFICIL;
                                end;
                                #52: // Si el usuario ingresa '3'
                                begin
                                    ClearDevice;
                                    PlaySound('GamemodeSelect.wav',0,1);
                                    PONG1V1;
                                end;
                                end; {case opcion juego}
                        end; {while}
                end; {jugar}
            end; {case Tecla}
    end; {while}
end. {program}