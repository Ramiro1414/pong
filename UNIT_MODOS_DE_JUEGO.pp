unit UNIT_MODOS_DE_JUEGO;
interface
uses sysutils,ptccrt,ptcGraph;
const
    r=6;                 //Radio
    X1Linea_Sup=10;       //X de la linea superior de la cancha
    Y1Linea_Sup=15;       //Y de la linea superior de la cancha 

procedure PONG1V1();
procedure PONG1VSIA_FACIL();
procedure PONG1VSIA_INTERMEDIO();
procedure PONG1VSIA_DIFICIL();

implementation
var
    leetecla:char;
    driver, modo: integer;
    PuntoxPelotaReal, PuntoyPelotaReal: real;
    angulopelota: integer;
    dx:integer;
    dy:integer;
    valordx:integer = 3;
    valordy:integer = 5;
    PuntoyPalIzq1:integer= 185;                //Coordenada Y del primer punto del palito izquierdo
    PuntoyPalIzq2:integer= 285;                //Coordenada Y del segundo punto del palito izquierdo
    PuntoyPalDer1:integer= 185;                // Coordenada Y del primer punto del palito derecho
    PuntoyPalDer2:integer= 285;                //Coordenada Y del segundo punto del palito derecho
    PuntoxPelota:integer= 319;                 // Coordenada x del punto de la pelota
    PuntoyPelota:integer=239;                  // Coordenada y del punto de la pelota
    GolPlayerIzq: integer = 0;
    GolPlayerDer: integer = 0;
    SeMovioJugadorIzq: integer;
    SeMovioJugadorDer: integer;
    SorteoDeSaque: integer = 0;
    HayGanador: boolean = false;
    Dificultad: integer;
    TimeOut: integer = 0;
    HaySaqueIzquierdo: boolean = false;
    HaySaqueDerecho: boolean = false;

procedure DIBUJACANCHA ();
begin
    Line (X1Linea_Sup,Y1Linea_Sup,630,15);                    //Linea de arriba de la cancha
    Line (10,465,630,465);                                   //Linea de abajo de la cancha
    bar(25,PuntoyPalIzq1,35,PuntoyPalIzq2);                   //Palito izq
    bar (600,PuntoyPalDer1,610,PuntoyPalDer2);                 //Palito der
    setcolor (white);
    Line (319,15,319,463);                                  //Linea del medio
    setcolor (red);
    setfillstyle (1,red);
    fillellipse (PuntoxPelota, PuntoyPelota, r, r);
end;
procedure SeSorteaSaque();
begin
    Randomize;
    SorteoDeSaque:= Random (4);
    case SorteoDeSaque of
            0: begin
                    dx:= -dx;
                    dy:= -dy; 
               end;
            1: begin
                    dx:=-dx;
                    dy:=dy; 
               end;
            2: begin
                    dx:=dx;
                    dy:=-dy; 
               end;
            3: begin
                    dx:=dx;
                    dy:=dy; 
               end;
        end;
end;
procedure MovimientoJugadorIzquierdo();
begin
    leetecla:= ' ';
    SeMovioJugadorIzq:=0;
    SeMovioJugadorDer:=0;
    If keypressed then
        begin
            leetecla:= ReadKey;
        end;
    If (leetecla= 'w' ) or (leetecla='W') then                  {Tecla 'w'} {Palo izquierdo}
        begin
            If (PuntoyPalIzq1 >= 25) then
                begin
                    PuntoyPalIzq1:= PuntoyPalIzq1 - 10;
                    SeMovioJugadorIzq := -10;
                    SetFillStyle (1,white);                            
                    bar (25,PuntoyPalIzq1,35,PuntoyPalIzq2);
                    SetFillStyle (1,black);
                    bar (25,PuntoyPalIzq2-10,35,PuntoyPalIzq2);
                    PuntoyPalIzq2:= PuntoyPalIzq2 - 10;
                    setcolor (white);                   //Color linea superior
                    Line (X1Linea_Sup,Y1Linea_Sup,630,15);                //Linea superior de la cancha
                    setcolor (white);                   // Color linea inferior
                    Line (10,465,630,465);              //Linea inferior de la cancha
                end;
        end;
    If (leetecla= 's' ) or (leetecla='S') then                                {Tecla 's'} {Palo izquierdo}
        begin
            If (PuntoyPalIzq2 <= 460) then
                begin
                    PuntoyPalIzq2:= PuntoyPalIzq2 + 10;
                    SeMovioJugadorIzq:= 10;
                    SetFillStyle (1,white);                              
                    bar (25,PuntoyPalIzq1,35,PuntoyPalIzq2);
                    SetFillStyle (1,black);
                    bar (25,PuntoyPalIzq1,35,PuntoyPalIzq1+10);   
                    PuntoyPalIzq1:= PuntoyPalIzq1 + 10; 
                    setcolor (white);                                //Color linea superior
                    Line (X1Linea_Sup,Y1Linea_Sup,630,15);                //Linea superior de la cancha
                    setcolor (white);                               // Color linea inferior
                    Line (10,465,630,465);                            //Linea inferior de la cancha
                end;
        end;
end;

procedure MovimientoIA ();
begin
    If (PuntoxPelota >= Dificultad) and (PuntoxPelota <= 589) then
        begin
            If (PuntoyPelota <= PuntoyPalDer1 + 50) and (PuntoyPalDer1 >= 25) then
                begin
                    PuntoyPalDer1:= PuntoyPalDer1 - 10;        
                    SetFillStyle (1,white);                                                     
                    bar (600,PuntoyPalDer1,610,PuntoyPalDer2);
                    SetFillStyle (1,black);
                    bar (600,PuntoyPalDer2-10,610,PuntoyPalDer2);
                    PuntoyPalDer2:= PuntoyPalDer2 - 10;
                    setcolor (white);                                //Color linea superior
                    Line (X1Linea_Sup,Y1Linea_Sup,630,15);           //Linea superior de la cancha
                    setcolor (white);                               // Color linea inferior
                    Line (10,465,630,465);                          //Linea inferior de la cancha
                end;
            If (PuntoyPelota >= PuntoyPalDer2 - 50) and (PuntoyPalDer2 <= 460) then
                begin
                    PuntoyPalDer2:= PuntoyPalDer2 + 10;
                    SetFillStyle (1,white);
                    bar (600,PuntoyPalDer1,610,PuntoyPalDer2);              
                    SetFillStyle (1,black);
                    bar (600,PuntoyPalDer1,610,PuntoyPalDer1+10);   
                    PuntoyPalDer1:= PuntoyPalDer1 + 10; 
                    setcolor (white);                               //Color linea superior
                    Line (X1Linea_Sup,Y1Linea_Sup,630,15);         //Linea superior de la cancha
                    setcolor (white);                               // Color linea inferior
                    Line (10,465,630,465);                          //Linea inferior de la cancha
                end;
        end;
end;
procedure MovimientoDosJugadores();
begin
    leetecla:= ' ';
    SeMovioJugadorIzq:=0;
    SeMovioJugadorDer:=0;
    If keypressed then
        begin
            leetecla:= ReadKey;
        end;
    If (leetecla= 'w' ) or (leetecla='W') then                  {Tecla 'w'} {Palo izquierdo}
        begin
            If (PuntoyPalIzq1 >= 25) then
                begin
                    PuntoyPalIzq1:= PuntoyPalIzq1 - 10;
                    SeMovioJugadorIzq := -10;
                    SetFillStyle (1,white);                            
                    bar (25,PuntoyPalIzq1,35,PuntoyPalIzq2);
                    SetFillStyle (1,black);
                    bar (25,PuntoyPalIzq2-10,35,PuntoyPalIzq2);
                    PuntoyPalIzq2:= PuntoyPalIzq2 - 10;
                    setcolor (white);                   //Color linea superior
                    Line (X1Linea_Sup,Y1Linea_Sup,630,15);                //Linea superior de la cancha
                    setcolor (white);                   // Color linea inferior
                    Line (10,465,630,465);              //Linea inferior de la cancha
                end;
        end;
    If (leetecla= 's' ) or (leetecla='S') then                                {Tecla 's'} {Palo izquierdo}
        begin
            If (PuntoyPalIzq2 <= 460) then
                begin
                    PuntoyPalIzq2:= PuntoyPalIzq2 + 10;
                    SeMovioJugadorIzq:= 10;
                    SetFillStyle (1,white);                              
                    bar (25,PuntoyPalIzq1,35,PuntoyPalIzq2);
                    SetFillStyle (1,black);
                    bar (25,PuntoyPalIzq1,35,PuntoyPalIzq1+10);   
                    PuntoyPalIzq1:= PuntoyPalIzq1 + 10; 
                    setcolor (white);                                //Color linea superior
                    Line (X1Linea_Sup,Y1Linea_Sup,630,15);                //Linea superior de la cancha
                    setcolor (white);                               // Color linea inferior
                    Line (10,465,630,465);                            //Linea inferior de la cancha
                end;
        end;
    If (leetecla= #$48 ) then                               { Flechita para arriba } {Palo derecho}
        begin
            If (PuntoyPalDer1 >= 25) then
                begin
                    PuntoyPalDer1:= PuntoyPalDer1 - 10;        
                    SeMovioJugadorDer:= -10;     
                    SetFillStyle (1,white);                                                     
                    bar (600,PuntoyPalDer1,610,PuntoyPalDer2);
                    SetFillStyle (1,black);
                    bar (600,PuntoyPalDer2-10,610,PuntoyPalDer2);
                    PuntoyPalDer2:= PuntoyPalDer2 - 10;
                    setcolor (white);                                //Color linea superior
                    Line (X1Linea_Sup,Y1Linea_Sup,630,15);           //Linea superior de la cancha
                    setcolor (white);                               // Color linea inferior
                    Line (10,465,630,465);                          //Linea inferior de la cancha
                end;
        end;
    If (leetecla= #$50) then                                {Flechita para abajo} {Palo derecho}
        begin
            If (PuntoyPalDer2 <= 460) then                                 
                begin
                    PuntoyPalDer2:= PuntoyPalDer2 + 10;
                    SeMovioJugadorDer:= 10;
                    SetFillStyle (1,white);
                    bar (600,PuntoyPalDer1,610,PuntoyPalDer2);              
                    SetFillStyle (1,black);
                    bar (600,PuntoyPalDer1,610,PuntoyPalDer1+10);   
                    PuntoyPalDer1:= PuntoyPalDer1 + 10; 
                    setcolor (white);                               //Color linea superior
                    Line (X1Linea_Sup,Y1Linea_Sup,630,15);         //Linea superior de la cancha
                    setcolor (white);                               // Color linea inferior
                    Line (10,465,630,465);                          //Linea inferior de la cancha
                end;
        end;    
end;
procedure FisicaDeLaPelota ();
begin
    setcolor (white);                          //Color linea superior
    Line (X1Linea_Sup,Y1Linea_Sup,630,15);      //Linea superior de la cancha
    setcolor (white);                   // Color linea inferior
    Line (10,465,630,465);              //Linea inferior de la cancha
    setcolor (black);
    setfillstyle (1,black);
    fillellipse (PuntoxPelota, PuntoyPelota, r, r);
    PuntoxPelota:= PuntoxPelota + dx;
    PuntoyPelota:= PuntoyPelota + dy;
    If PuntoyPelota > 458 then
        begin
            dy:= -dy;                           //Rebote en borde inferior
        end;
    If PuntoyPelota < 21 then                               
        begin   
            dy:= -dy;                           //Rebote en borde superior
        end;
    If (PuntoxPelota <= 44) and (PuntoxPelota > 32) and (PuntoyPelota>=PuntoyPalIzq1-r) and (PuntoyPelota<=PuntoyPalIzq2+r) then    //Rebote pelota en palo izq
        begin
            //Se divide el palo en 5 rectangulos, cada uno con rebote distinto, y se analiza en cada cuadrito la situacion de si la pelota viene de arriba o de abajo
            If  (PuntoyPelota >= PuntoyPalIzq1) and (PuntoyPelota <= PuntoyPalIzq1+20) then //Primer rectangulo   
                begin
                    If (dx < 0) and (dy > 0) then
                        begin
                            dy:= 7;
                            dx:=-dx;
                        end;
                    If (dx < 0) and (dy < 0) then
                        begin
                            dy:=-7;
                            dx:=-dx;
                        end;
                end;
            If (PuntoyPelota > PuntoyPalIzq1 + 20) and (PuntoyPelota <= PuntoyPalIzq1 + 40) then   //Segundo rectangulo
                begin
                    If (dx < 0) and (dy > 0) then
                        begin
                            dy:= 6;
                            dx:=-dx;
                        end;
                    If (dx < 0) and (dy < 0) then
                        begin
                            dy:=-6;
                            dx:=-dx;
                        end;
                end;
            If (PuntoyPelota > PuntoyPalIzq1 + 40) and (PuntoyPelota <= PuntoyPalIzq1 + 60) then  //Tercer rectangulo
                begin
                    If (dx < 0) and (dy > 0) then
                        begin
                            dy:= 2;
                            dx:=-dx;
                        end;
                    If (dx < 0) and (dy < 0) then
                        begin
                            dy:=-2;
                            dx:=-dx;
                        end;
                end;
            If (PuntoyPelota > PuntoyPalIzq1 + 60) and (PuntoyPelota <= PuntoyPalIzq1 + 80) then     //Cuarto rectangulo
                begin
                    If (dx < 0) and (dy > 0) then
                        begin
                            dy:= 6;
                            dx:=-dx;
                        end;
                    If (dx < 0) and (dy < 0) then
                        begin
                            dy:=-6;
                            dx:=-dx;
                        end;
                end;
            If (PuntoyPelota > PuntoyPalIzq1 + 80) and (PuntoyPelota <= PuntoyPalIzq2) then   //Quinto rectangulo
                begin
                    If (dx < 0) and (dy > 0) then
                        begin
                            dy:= 7;
                            dx:=-dx;
                        end;
                    If (dx < 0) and (dy < 0) then
                        begin
                            dy:=-7;
                            dx:=-dx;
                        end;
                end;
        end;
        
    If (PuntoxPelota >= 592) and (PuntoxPelota < 597) and (PuntoyPelota>=PuntoyPalDer1-r) and (PuntoyPelota<=PuntoyPalDer2+r) then    //Rebote pelota en palo der.
        begin
            //Se divide el palo en 5 rectangulos, cada uno con rebote distinto, y se analiza en cada cuadrito la situacion de si la pelota viene de arriba o de abajo
            If  (PuntoyPelota >= PuntoyPalDer1) and (PuntoyPelota <= PuntoyPalDer1+20) then //Primer rectangulo   
                begin
                    If (dx > 0) and (dy > 0) then
                        begin
                            dy:= 7;
                            dx:=-dx;
                        end;
                    If (dx > 0) and (dy < 0) then
                        begin
                            dy:=-7;
                            dx:=-dx;
                        end;
                end;
            If (PuntoyPelota > PuntoyPalDer1 + 20) and (PuntoyPelota <= PuntoyPalDer1 + 40) then   //Segundo rectangulo
                begin
                    If (dx > 0) and (dy > 0) then
                        begin
                            dy:= 6;
                            dx:=-dx;
                        end;
                    If (dx > 0) and (dy < 0) then
                        begin
                            dy:=-6;
                            dx:=-dx;
                        end;
                end;
            If (PuntoyPelota > PuntoyPalDer1 + 40) and (PuntoyPelota <= PuntoyPalDer1 + 60) then  //Tercer rectangulo
                begin
                    If (dx > 0) and (dy > 0) then
                        begin
                            dy:= 2;
                            dx:=-dx;
                        end;
                    If (dx > 0) and (dy < 0) then
                        begin
                            dy:=-2;
                            dx:=-dx;
                        end;
                end;
            If (PuntoyPelota > PuntoyPalDer1 + 60) and (PuntoyPelota <= PuntoyPalDer1 + 80) then     //Cuarto rectangulo
                begin
                    If (dx > 0) and (dy > 0) then
                        begin
                            dy:= 6;
                            dx:=-dx;
                        end;
                    If (dx > 0) and (dy < 0) then
                        begin
                            dy:=-6;
                            dx:=-dx;
                        end;
                end;
            If (PuntoyPelota > PuntoyPalDer1 + 80) and (PuntoyPelota <= PuntoyPalDer2) then   //Quinto rectangulo
                begin
                    If (dx > 0) and (dy > 0) then
                        begin
                            dy:= 7;
                            dx:=-dx;
                        end;
                    If (dx > 0) and (dy < 0) then
                        begin
                            dy:=-7;
                            dx:=-dx;
                        end;
                end;
        end;
    setcolor (red);
    SetFillStyle (1,red);                                           //Color pelota
    fillellipse (PuntoxPelota,PuntoyPelota,r,r);                    //Pelota
    delay (5);   
    setcolor (white);
    Line (319,15,319,463);                    //Linea del medio
end;
procedure Marcador ();
begin
    case GolPlayerIzq of
        0: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (1,466,'0');
           end;
        1: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (1,466,'1');
           end;
        2: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (1,466,'2');
           end;
        3: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (1,466,'3');
           end;
        4: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (1,466,'4');
           end;
        5: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (1,466,'5');
           end;
    end;
    case GolPlayerDer of
        0: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (625,466,'0');
           end;
        1: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (625,466,'1');
           end;
        2: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (625,466,'2');
           end;
        3: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (625,466,'3');
           end;
        4: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (625,466,'4');
           end;
        5: begin
                setcolor (white);
                settextstyle (1,HorizDir,2);
                OutTextXY (625,466,'5');
           end;
    end;
end;

procedure EvaluaGol();
begin
    FisicaDeLaPelota ();
    If (PuntoxPelota < 0) then
        begin
            GolPlayerDer := GolPlayerDer + 1;                   //Suma gol
            setfillstyle (1,black);                         
            bar (625,466,639,479);                  //Tapa contador
            bar (0,0,10,464);                    //Tapa pelota que se fue afuera
            PuntoxPelota := 35 + r + 1;                       
            PuntoyPelota:= PuntoyPalIzq2 - 50;
            setcolor (red);
            SetFillStyle (1,red);                                         
            fillellipse (PuntoxPelota,PuntoyPelota,r,r);
            While (leetecla <> 'a') do
                begin
                    MovimientoDosJugadores();
                    If SeMovioJugadorIzq <> 0 then
                        begin
                            setcolor (black);
                            setfillstyle (1,black);
                            fillellipse (PuntoxPelota,PuntoyPelota,r,r);
                            PuntoyPelota:= PuntoyPelota + SeMovioJugadorIzq;
                            setcolor (red);
                            setfillstyle(1,red);
                            fillellipse (PuntoxPelota,PuntoyPelota,r,r);
                        end;
                    Marcador();
                end;
            dx:=-dx;
            FisicaDeLaPelota ();
        end;
    If (PuntoxPelota > 640) then
        begin
            GolPlayerIzq := GolPlayerIzq + 1;
            setfillstyle (1,black);
            bar (1,466,15,479);
            bar (630,0,640,464);
            PuntoxPelota := 600 - r - 1;
            PuntoyPelota:= PuntoyPalDer1 + 50;
            setcolor (red);
            SetFillStyle (1,red);                                         
            fillellipse (PuntoxPelota,PuntoyPelota,r,r);  
            While (leetecla <> 'm') do
                begin
                    MovimientoDosJugadores();
                    If SeMovioJugadorDer <> 0 then
                        begin
                            setcolor (black);
                            setfillstyle (1,black);
                            fillellipse (PuntoxPelota,PuntoyPelota,r,r);
                            PuntoyPelota:= PuntoyPelota + SeMovioJugadorDer;
                            setcolor (red);
                            setfillstyle(1,red);
                            fillellipse (PuntoxPelota,PuntoyPelota,r,r);
                        end;
                    Marcador();
                end;
            dx:=-dx;
            FisicaDeLaPelota ();
        end;
end;

procedure EvaluaGolIA();
begin
If TimeOut > 1 then
        begin
            TimeOut:= TimeOut - 1;
            exit;
        end;
    If TimeOut = 1 then
        begin
            dx:=-valordx;
            TimeOut:= 0;
        end;
FisicaDeLaPelota ();
    If (PuntoxPelota < 0) then
        begin
            GolPlayerDer := GolPlayerDer + 1;                   //Suma gol
            setfillstyle (1,black);                         
            bar (625,466,639,479);                  //Tapa contador
            bar (0,16,10,464);                    //Tapa pelota que se fue afuera
            PuntoxPelota := 35 + r + 4;                       
            PuntoyPelota:= PuntoyPalIzq2 - 50;
            setcolor (red);
            SetFillStyle (1,red);                                         
            fillellipse (PuntoxPelota,PuntoyPelota,r,r);  
            While (leetecla <> 'a') do
                begin
                    MovimientoJugadorIzquierdo();
                    If SeMovioJugadorIzq <> 0 then
                        begin
                            setcolor (black);
                            setfillstyle (1,black);
                            fillellipse (PuntoxPelota,PuntoyPelota,r,r);
                            PuntoyPelota:= PuntoyPelota + SeMovioJugadorIzq;
                            setcolor (red);
                            setfillstyle(1,red);
                            fillellipse (PuntoxPelota,PuntoyPelota,r,r);
                        end;
                    Marcador();
                end;
            FisicaDeLaPelota ();
        end;
    If (PuntoxPelota > 640) then
        begin
            TimeOut := 5000;
            dx:= 0;
            GolPlayerIzq := GolPlayerIzq + 1;
            setfillstyle (1,black);
            bar (1,466,15,479);
            bar (630,16,640,464);
            PuntoxPelota := 600 - r - 4;
            PuntoyPelota:= PuntoyPalDer1 + 50;
            setcolor (red);
            SetFillStyle (1,red);                                         
            fillellipse(PuntoxPelota,PuntoyPelota,r,r);  
            Marcador();
        end;
        FisicaDeLaPelota();
    end;

// procedure EvaluaGol();
// begin
//     FisicaDeLaPelota ();
//     If (PuntoxPelota < 0) then
//         begin
//             GolPlayerDer := GolPlayerDer + 1;                   //Suma gol
//             HaySaqueIzquierdo:= true;
//         end;
//     If (PuntoxPelota > 640) then
//         begin
//             GolPlayerIzq := GolPlayerIzq + 1;
//             HaySaqueDerecho:= true;
//         end;
// end;

// procedure Saque();
// begin
//     If HaySaqueDerecho then
//         begin
//             setfillstyle (1,black);
//             bar (1,466,15,479);
//             bar (630,0,640,464);
//             PuntoxPelota := 600 - r - 1;
//             PuntoyPelota:= PuntoyPalDer1 + 50;
//             setcolor (red);
//             SetFillStyle (1,red);                                         
//             fillellipse (PuntoxPelota,PuntoyPelota,r,r);  
//             While (leetecla <> 'm') do
//                 begin
//                     MovimientoDosJugadores();
//                     If SeMovioJugadorDer <> 0 then
//                         begin
//                             setcolor (black);
//                             setfillstyle (1,black);
//                             fillellipse (PuntoxPelota,PuntoyPelota,r,r);
//                             PuntoyPelota:= PuntoyPelota + SeMovioJugadorDer;
//                             setcolor (red);
//                             setfillstyle(1,red);
//                             fillellipse (PuntoxPelota,PuntoyPelota,r,r);
//                         end;
//                     Marcador();
//                 end;
//             dx:=-dx;
//             FisicaDeLaPelota ();
//         end;
//     If HaySaqueIzquierdo then
//         begin
//             setfillstyle (1,black);                         
//             bar (625,466,639,479);                  //Tapa contador
//             bar (0,0,10,464);                    //Tapa pelota que se fue afuera
//             PuntoxPelota := 35 + r + 1;                       
//             PuntoyPelota:= PuntoyPalIzq2 - 50;
//             setcolor (red);
//             SetFillStyle (1,red);                                         
//             fillellipse (PuntoxPelota,PuntoyPelota,r,r);
//             While (leetecla <> 'a') do
//                 begin
//                     MovimientoDosJugadores();
//                     If SeMovioJugadorIzq <> 0 then
//                         begin
//                             setcolor (black);
//                             setfillstyle (1,black);
//                             fillellipse (PuntoxPelota,PuntoyPelota,r,r);
//                             PuntoyPelota:= PuntoyPelota + SeMovioJugadorIzq;
//                             setcolor (red);
//                             setfillstyle(1,red);
//                             fillellipse (PuntoxPelota,PuntoyPelota,r,r);
//                         end;
//                     Marcador();
//                 end;
//             dx:=-dx;
//             FisicaDeLaPelota ();
//         end;
// end;

procedure PONG1V1();
begin
    dy:=valordy;
    dx:= valordx;
    DIBUJACANCHA();
    SeSorteaSaque();
    // INICIAGRAPH();
    while (leetecla <> #27) do
    begin
        Marcador ();
        MovimientoDosJugadores();
        EvaluaGol();
    end;
    // FisicaDeLaPelota();
end;

procedure PONG1VSIA_FACIL();
begin
    dy:=valordy;
    dx:= valordx;
    Dificultad:= 430;
    // INICIAGRAPH();
    DIBUJACANCHA();
    // While (leetecla <> #27) or (GolPlayerDer <> 1) or (GolPlayerIzq <> 1) do                              //Mientras no se halla apretado el escape
    While (leetecla <> #27) do
        begin
            MovimientoJugadorIzquierdo();
            MovimientoIA();
            EvaluaGolIA();
            Marcador();
        end;
    ClearDevice;
end;

procedure PONG1VSIA_INTERMEDIO();
begin
    dy:=valordy;
    dx:= valordx;
    Dificultad:= 220;
    // INICIAGRAPH();
    DIBUJACANCHA();
    // While (leetecla <> #27) or (GolPlayerDer <> 1) or (GolPlayerIzq <> 1) do                              //Mientras no se halla apretado el escape
    While (leetecla <> #27) do
        begin
            MovimientoJugadorIzquierdo();
            MovimientoIA();
            EvaluaGolIA();
            Marcador();
        end;
end;

procedure PONG1VSIA_DIFICIL();
begin
    dy:=valordy;
    dx:= valordx;
    Dificultad:= 1;
    // INICIAGRAPH();
    DIBUJACANCHA();
    // While (leetecla <> #27) or (GolPlayerDer <> 1) or (GolPlayerIzq <> 1) do                              //Mientras no se halla apretado el escape
    While (leetecla <> #27) do
        begin
            MovimientoJugadorIzquierdo();
            MovimientoIA();
            EvaluaGolIA();
            Marcador();
        end;
end;

end.