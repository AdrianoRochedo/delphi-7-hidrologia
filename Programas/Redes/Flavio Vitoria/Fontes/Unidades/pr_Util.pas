Unit pr_Util;

Interface
uses Windows, Shapes, Classes, Graphics, IniFiles;

{ programa para, a partir de uma reta r formada por dois pontos P1 e P2, se construa um
quadrado com centro em P2, e que se considere um novo sistema xoy de coordenadas, conforme
documentado no papel,Achando- se, neste novo sistema, as coordenadas dos vértices de um
triângulo A1 A2 A3 , no qual A1 jaz entre P1 e P2, pela intersecção da reta r com uma dada
circunferência de raio l/2 contida no quadrado de TamLado l que fora construído.}

{entrada: TamLado, P1(xp1,yp1) e P2(xp2,yp2)
  saída: A1(xa1,ya1), A2(xa2,ya2) e A3(xa3,ya3)  }

   { |----------------------------------------------------------->x
     |(0,0)
     |
     |
     |              K1(0,0).---------.-----------.K2(TamLado,0) _____ x'
     |                     |        A2          |
     |                     |                    |
     |                     |                    |
     |                     |                    |
     |                     |         .          |
     |                     |      P2(xp2,yp2)   |
     |                     .A1                . |
     |                     |                 A3 |
     |              .      |                    |
     |        P1(xp1,yp1)  .--------------------.
     |                     K3(0,TamLado)            K4(TamLado,TamLado)
      y                    |
                           |
                           y'
}

  Function  ObtemTriangulo(TamLado: Integer; P1, P2: TPoint): TTriangle;
  Function  DistanciaDeUmPonto_aUmaReta(Ponto, PR1, PR2: TPoint): Integer;
  Function  DistanciaEntre2Pontos(P1, P2: TPoint): Integer;

  procedure DesenhaSeta(Canvas: TCanvas;
                        P1, P2: TPoint;
                        Tam: Integer = 10;
                        Dist_P2: Integer = 0);

  procedure SalvarBitmapEmArquivo(Bitmap: TBitmap; Arquivo: TCustomIniFile; const Secao: String);
  function  LerBitmapDoArquivo(Arquivo: TCustomIniFile; const Secao: String): TBitmap;

Implementation
uses stSTRs, SysUtils;

Function ObtemTriangulo(TamLado: Integer; P1, P2: TPoint): TTriangle;
var
  xa1,ya1,xa2,ya2,xa3,ya3,xp1,yp1,xp2,yp2,alfa,beta,gama,theta1,theta2,
  theta3,v1,v2,u1,u2,d1,d2,k1,k2,k3,m1,m2,t1,t2,t3,xk1,yk1,a2i,a2j,a3i,a3j,
  b2i,b2j,b3i,b3j,x1,y1, x2, y2:real;

  procedure AtribuiResultado;
  begin
    Result.P1 := Point(Round(xa1), Round(ya1));
    Result.P2 := Point(Round(xa2), Round(ya2));
    Result.P3 := Point(Round(xa3), Round(ya3));
  end;

begin
  xp1 := P1.x; yp1 := P1.y;
  xp2 := P2.x; yp2 := P2.y;

  xk1:=(2*xp2-TamLado)/2 ; yk1:=(2*yp2-TamLado)/2 ;{coordenadas xk1 eyk1 no sistema antigo}

  alfa:=yp1-yp2;
  beta:=xp2-xp1;

  if alfa=0 then
     begin
     xa1:=0; ya1:=TamLado/2;
     xa2:=(3*TamLado)/2; ya2:=(TamLado*(2-sqrt(3)))/4;
     xa3:=(3*TamLado)/2; ya3:=(TamLado*(2+sqrt(3)))/4;
     AtribuiResultado;
     exit;
     end; {fim da execução}

  if beta=0 then
     begin
     xa1:=TamLado/2; ya1:=0;
     xa2:=(TamLado*(2+sqrt(3)))/4; ya2:=(3*TamLado)/2;
     xa3:=(TamLado*(2-sqrt(3)))/4; ya3:=(3*TamLado)/2;
     AtribuiResultado;
     exit;
     end; {fim da execução}

  if ((alfa<>0)and(beta<>0))then
     begin
     gama:=(xp1-xk1)*(yp2-yk1)-(xp2-xk1)*(yp1-yk1);
     theta1:=4*(sqr(alfa) + sqr(beta));
     theta2:=4*(2*beta*gama+alfa*TamLado*beta-sqr(alfa)*TamLado);
     theta3:=4*sqr(gama) + 4*alfa*TamLado*gama + sqr(alfa)*sqr(TamLado);

     v1:=(-theta2+sqrt(sqr(theta2) - 4*theta1*theta3)) / (2*theta1);
     v2:=(-theta2-sqrt(sqr(theta2) - 4*theta1*theta3)) / (2*theta1);

     u1:=(-beta*v1-gama)/alfa;
     u2:=(-beta*v2-gama)/alfa;

     x1:=x1-xk1 ; y1:=y1-yk1;
     d1:=sqrt(sqr(x1-u1) + sqr(y1-v1));
     d2:=sqrt(sqr(x2-u2) + sqr(y2-v2));

     if (d1>d2) then
       begin
       xa1:=u2;
       ya1:=v2;
       end
     else
       begin
       xa1:=u1;
       ya1:=v2;
       end;                 {com isso acham-se as coordenadas de A1}

     m1:=(4*alfa*beta+sqrt(3)* (sqr(alfa) + sqr(beta)))/(sqr(alfa)-3*sqr(beta));

     k1:=1+m1*m1;
     k2:=2*m1*(ya1-m1*xa1)-TamLado*(1+m1);
     k3:=sqr(ya1-m1*xa1) - TamLado*(ya1-m1*xa1) + sqr(TamLado)/4;

     a2i:=(-k2+sqrt(sqr(k2) - 4*k1*k3))/(2*k1);
     a2j:=(-k2-sqrt(sqr(k2) - 4*k1*k3))/(2*k1);

     b2i:=m1*a2i+ya1-m1*xa1;
     b2j:=m1*a2j+ya1-m1*xa1;

     d1:=sqrt(sqr(a2i-xa1) + sqr(b2i-ya1));
     d2:=sqrt(sqr(a2j-xa1) + sqr(b2j-ya1));

     if (d1>d2) then
       begin
       xa2:=a2i;
       ya2:=b2i;
       end
     else
       begin
       xa2:=a2j;
       ya2:=b2j;
       end;             {com isso acham-se as coordenadas de A2}

     m2:=(4*alfa*beta+sqrt(3)*(sqr(alfa) + sqr(beta)))/(3*sqr(beta)-sqr(alfa));

     t1:=1+ sqr(m2);
     t2:=2*m2*(ya1-m2*xa1)-TamLado*(1+m2);
     t3:=(ya1-m2*xa1)*(ya1-m2*xa1)-TamLado*(ya1-m2*xa1)+(TamLado*TamLado)/4;

     a3i:=(-t2+sqrt(sqr(t2)-4*t1*t3))/(2*t1);
     a3j:=(-t2-sqrt(sqr(t2)-4*t1*t3))/(2*t1);

     b3i:=m2*a3i+ya1-m2*xa1;
     b3j:=m2*a3j+ya1-m2*xa1;


    d1:=sqrt(sqr(a3i-xa1) + sqr(b3i-ya1));
    d2:=sqrt(sqr(a3j-xa1) + sqr(b3j-ya1));

    if d1>d2 then
      begin
      xa3:=a3i;
      ya3:=b3i;
      end
    else
      begin
      xa3:=a3j;
      ya3:=b3j;
      end;
    end;                  {com isso acham-se as coordenadas de A3}

  AtribuiResultado;
end;

Function DistanciaEntre2Pontos(P1, P2: TPoint): Integer;
var a, b, c: Integer;
begin
  Result := Trunc(sqrt(sqr(p1.x - p2.x) + sqr(p1.y - p2.y)));
end;

Function DistanciaDeUmPonto_aUmaReta(Ponto, PR1, PR2: TPoint): Integer;
var a, b, c: Integer;
begin
  a := PR1.Y - PR2.Y;
  b := PR2.X - PR1.X;
  c := PR1.X * PR2.Y - PR2.X * PR1.Y;
  Result := Trunc( ABS( (a*Ponto.X + b*Ponto.Y + c) / SQRT(a*a + b*b) ) );
end;

procedure DesenhaSeta(Canvas: TCanvas; P1, P2: TPoint; Tam: Integer = 10; Dist_P2: Integer = 0);
var M, T, Q: TPoint;
    mr, r2: Real;
    sen_q, cos_q, x2barra, y2barra, xmlinha, ymlinha,
    xmbarra, ymbarra, x2linha, y2linha: Real;
begin
  Q.x := p2.x;
  Q.y := p2.y;

  if P2.x = P1.x then
     begin
     r2 := Tam * sqrt(2)/2;
     if P2.y > P1.y then
        begin
        p2.y := p2.y - Dist_p2;

        t.x := Trunc( P1.x - r2);
        t.y := Trunc( P2.y - r2);

        m.x := Trunc( P1.x + r2);
        m.y := t.y;
        end
     else
        begin
        p2.y := p2.y + Dist_p2;

        t.x := Trunc( P1.x - r2 );
        t.y := Trunc( P2.y + r2 );

        m.x := Trunc( P1.x + r2 );
        m.y := t.y;
        end
     end
  else
     begin
     mr := (p2.y - p1.y) / (p2.x - p1.x);   {tangente do ângulo _q }

     { seno e cosseno do ângulode rotação _q }
     r2 := sqrt(1+mr*mr);

     sen_q := mr / r2;
     cos_q := 1 / r2;

     if p2.x < p1.x then
        begin
        sen_q := -sen_q;
        cos_q := -cos_q;
        end;

     {translação de sistema,para que a nova origem colida com P1 }
     x2barra := p2.x - p1.x;
     y2barra := p2.y - p1.y;

     {rotação do sistema que já foi transladado: rotação de _q radianos }
     r2 := sqrt(2)/2;
     x2linha := x2barra*cos_q + y2barra*sen_q - Dist_P2;
     y2linha := y2barra*cos_q - x2barra*sen_q;

     x2barra := x2linha*cos_q - y2linha*sen_q;
     y2barra := x2linha*sen_q + y2linha*cos_q;

     p2.x := trunc(x2barra + p1.x);
     p2.y := trunc(y2barra + p1.y);

     xmlinha := x2linha - Tam*r2;
     ymlinha := Tam*r2;

     xmbarra := xmlinha*cos_q - ymlinha*sen_q;
     ymbarra := xmlinha*sen_q + ymlinha*cos_q;

     {valores de um dos pontos procurados:}
     m.x := Trunc(xmbarra + p1.x);
     m.y := Trunc(ymbarra + p1.y);

     {..................................................................}

     xmlinha := x2linha - Tam*r2;
     ymlinha := -Tam*r2;

     xmbarra := xmlinha*cos_q - ymlinha*sen_q;
     ymbarra := xmlinha*sen_q + ymlinha*cos_q;

     {valores do outro ponto procurado:}
     t.x := Trunc(xmbarra + p1.x);
     t.y := Trunc(ymbarra + p1.y);
     end;

  Canvas.MoveTo(p1.x, p1.y);
  Canvas.LineTo(p2.x, p2.y);
  Canvas.LineTo(T.x, T.y);
  Canvas.MoveTo(p2.x, p2.y);
  Canvas.LineTo(M.x, M.y);
  Canvas.MoveTo(p2.x, p2.y);
  Canvas.LineTo(Q.x, Q.y);
end;

procedure SalvarBitmapEmArquivo(Bitmap: TBitmap; Arquivo: TCustomIniFile; const Secao: String);
var i, j: integer;
    s   : String;
begin
  Arquivo.WriteInteger(Secao, 'Largura', Bitmap.Width);
  Arquivo.WriteInteger(Secao, 'Altura', Bitmap.Height);

  for i := 0 to Bitmap.Height-1 do
    begin
    s := '';
    for j := 0 to Bitmap.Width-1 do s := s + IntToHex(Bitmap.Canvas.Pixels[j, i], 6);
    Arquivo.WriteString(Secao, intToStr(i+1), s);
    end;
end;

function LerBitmapDoArquivo(Arquivo: TCustomIniFile; const Secao: String): TBitmap;
var L, A  : Integer;
    i, j  : Integer;
    k     : Integer;
    Linha : String;    // Linha que contém os códigos
    s     : String[7]; // cod. Hexadecimal que forma a cor de cada byte do bitmap
    Cor   : Longint;
begin
  Result := nil;
  L := Arquivo.ReadInteger(Secao, 'Largura', 0);
  A := Arquivo.ReadInteger(Secao, 'Altura', 0);

  if (A = 0) or (L = 0) then exit;
  Result := TBitmap.Create;
  Result.Height := A; Result.Width := L;

  for i := 0 to A-1 do
    begin
    s := '$';
    k := -1;
    Linha := Arquivo.ReadString(Secao, intToStr(i+1), '');
    if (L * 6) = Length(Linha) then
       for j := 1 to (L * 6) do
         begin
         s := s + Linha[j];
         if (j mod 6) = 0 then
            begin
            inc(k);
            if str2LongS(s, Cor) then
               Result.Canvas.Pixels[k, i] := Cor
            else
               Result.Canvas.Pixels[k, i] := clBlack;
            s := '$';
            end;
         end;
    end;
end;


end.
