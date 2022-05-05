unit iphs1_GaugeDoCanal;

interface
uses IrregularGauge, Graphics;

type
  Tiphs1_TD_Gause = class(TIrregularGauge)
  private
    procedure Init; override;
  public
    procedure setColor(const Value: TColor);
  end;

implementation
uses Windows, SysUtils, Classes;

{ Tiphs1_ResGause }

procedure Tiphs1_TD_Gause.Init;
var i, ii: Integer;
begin
  ImageTop := 0;
  ImageHeight := 126 - ImageTop + 1;

  Canvas.Pen.Color := Windows.RGB(128, 0, 0);
  Canvas.Pen.Mode := pmXor;

  // dimensiona os arrays
  SetLength(FVerticalLines, ImageHeight + 1);
  for i := 0 to High(FVerticalLines) do
     SetLength(FVerticalLines[i], 1);

  // inicializa os array ---------------------------------------------------------------
  FVerticalLines[0][0].p1 := point(0, 0);  FVerticalLines[0][0].p2 := point(240, 0);  
  FVerticalLines[1][0].p1 := point(0, 1);  FVerticalLines[1][0].p2 := point(240, 1);  
  FVerticalLines[2][0].p1 := point(0, 2);  FVerticalLines[2][0].p2 := point(240, 2);  
  FVerticalLines[3][0].p1 := point(0, 3);  FVerticalLines[3][0].p2 := point(240, 3);  
  FVerticalLines[4][0].p1 := point(0, 4);  FVerticalLines[4][0].p2 := point(240, 4);  
  FVerticalLines[5][0].p1 := point(0, 5);  FVerticalLines[5][0].p2 := point(240, 5);  
  FVerticalLines[6][0].p1 := point(0, 6);  FVerticalLines[6][0].p2 := point(240, 6);  
  FVerticalLines[7][0].p1 := point(0, 7);  FVerticalLines[7][0].p2 := point(240, 7);  
  FVerticalLines[8][0].p1 := point(0, 8);  FVerticalLines[8][0].p2 := point(240, 8);  
  FVerticalLines[9][0].p1 := point(0, 9);  FVerticalLines[9][0].p2 := point(240, 9);  
  FVerticalLines[10][0].p1 := point(0, 10);  FVerticalLines[10][0].p2 := point(240, 10);  
  FVerticalLines[11][0].p1 := point(0, 11);  FVerticalLines[11][0].p2 := point(240, 11);  
  FVerticalLines[12][0].p1 := point(0, 12);  FVerticalLines[12][0].p2 := point(240, 12);  
  FVerticalLines[13][0].p1 := point(0, 13);  FVerticalLines[13][0].p2 := point(240, 13);  
  FVerticalLines[14][0].p1 := point(0, 14);  FVerticalLines[14][0].p2 := point(240, 14);  
  FVerticalLines[15][0].p1 := point(0, 15);  FVerticalLines[15][0].p2 := point(240, 15);  
  FVerticalLines[16][0].p1 := point(0, 16);  FVerticalLines[16][0].p2 := point(240, 16);
  FVerticalLines[17][0].p1 := point(0, 17);  FVerticalLines[17][0].p2 := point(240, 17);  
  FVerticalLines[18][0].p1 := point(0, 18);  FVerticalLines[18][0].p2 := point(240, 18);  
  FVerticalLines[19][0].p1 := point(0, 19);  FVerticalLines[19][0].p2 := point(240, 19);  
  FVerticalLines[20][0].p1 := point(0, 20);  FVerticalLines[20][0].p2 := point(240, 20);  
  FVerticalLines[21][0].p1 := point(0, 21);  FVerticalLines[21][0].p2 := point(240, 21);  
  FVerticalLines[22][0].p1 := point(0, 22);  FVerticalLines[22][0].p2 := point(240, 22);  
  FVerticalLines[23][0].p1 := point(0, 23);  FVerticalLines[23][0].p2 := point(240, 23);  
  FVerticalLines[24][0].p1 := point(0, 24);  FVerticalLines[24][0].p2 := point(240, 24);  
  FVerticalLines[25][0].p1 := point(0, 25);  FVerticalLines[25][0].p2 := point(240, 25);  
  FVerticalLines[26][0].p1 := point(0, 26);  FVerticalLines[26][0].p2 := point(240, 26);  
  FVerticalLines[27][0].p1 := point(0, 27);  FVerticalLines[27][0].p2 := point(240, 27);  
  FVerticalLines[28][0].p1 := point(0, 28);  FVerticalLines[28][0].p2 := point(240, 28);  
  FVerticalLines[29][0].p1 := point(0, 29);  FVerticalLines[29][0].p2 := point(240, 29);  
  FVerticalLines[30][0].p1 := point(0, 30);  FVerticalLines[30][0].p2 := point(240, 30);  
  FVerticalLines[31][0].p1 := point(0, 31);  FVerticalLines[31][0].p2 := point(240, 31);  
  FVerticalLines[32][0].p1 := point(0, 32);  FVerticalLines[32][0].p2 := point(240, 32);  
  FVerticalLines[33][0].p1 := point(0, 33);  FVerticalLines[33][0].p2 := point(240, 33);  
  FVerticalLines[34][0].p1 := point(0, 34);  FVerticalLines[34][0].p2 := point(240, 34);  
  FVerticalLines[35][0].p1 := point(0, 35);  FVerticalLines[35][0].p2 := point(240, 35);  
  FVerticalLines[36][0].p1 := point(0, 36);  FVerticalLines[36][0].p2 := point(240, 36);  
  FVerticalLines[37][0].p1 := point(0, 37);  FVerticalLines[37][0].p2 := point(240, 37);  
  FVerticalLines[38][0].p1 := point(0, 38);  FVerticalLines[38][0].p2 := point(240, 38);
  FVerticalLines[39][0].p1 := point(0, 39);  FVerticalLines[39][0].p2 := point(240, 39);  
  FVerticalLines[40][0].p1 := point(0, 40);  FVerticalLines[40][0].p2 := point(240, 40);  
  FVerticalLines[41][0].p1 := point(0, 41);  FVerticalLines[41][0].p2 := point(240, 41);  
  FVerticalLines[42][0].p1 := point(0, 42);  FVerticalLines[42][0].p2 := point(240, 42);  
  FVerticalLines[43][0].p1 := point(0, 43);  FVerticalLines[43][0].p2 := point(240, 43);  
  FVerticalLines[44][0].p1 := point(0, 44);  FVerticalLines[44][0].p2 := point(240, 44);  
  FVerticalLines[45][0].p1 := point(0, 45);  FVerticalLines[45][0].p2 := point(240, 45);  
  FVerticalLines[46][0].p1 := point(0, 46);  FVerticalLines[46][0].p2 := point(240, 46);  
  FVerticalLines[47][0].p1 := point(40, 47);  FVerticalLines[47][0].p2 := point(201, 47);  
  FVerticalLines[48][0].p1 := point(40, 48);  FVerticalLines[48][0].p2 := point(201, 48);  
  FVerticalLines[49][0].p1 := point(40, 49);  FVerticalLines[49][0].p2 := point(201, 49);  
  FVerticalLines[50][0].p1 := point(40, 50);  FVerticalLines[50][0].p2 := point(201, 50);  
  FVerticalLines[51][0].p1 := point(40, 51);  FVerticalLines[51][0].p2 := point(201, 51);  
  FVerticalLines[52][0].p1 := point(40, 52);  FVerticalLines[52][0].p2 := point(201, 52);  
  FVerticalLines[53][0].p1 := point(40, 53);  FVerticalLines[53][0].p2 := point(201, 53);  
  FVerticalLines[54][0].p1 := point(40, 54);  FVerticalLines[54][0].p2 := point(201, 54);  
  FVerticalLines[55][0].p1 := point(40, 55);  FVerticalLines[55][0].p2 := point(201, 55);  
  FVerticalLines[56][0].p1 := point(40, 56);  FVerticalLines[56][0].p2 := point(201, 56);  
  FVerticalLines[57][0].p1 := point(40, 57);  FVerticalLines[57][0].p2 := point(201, 57);  
  FVerticalLines[58][0].p1 := point(40, 58);  FVerticalLines[58][0].p2 := point(201, 58);  
  FVerticalLines[59][0].p1 := point(40, 59);  FVerticalLines[59][0].p2 := point(201, 59);  
  FVerticalLines[60][0].p1 := point(40, 60);  FVerticalLines[60][0].p2 := point(201, 60);
  FVerticalLines[61][0].p1 := point(40, 61);  FVerticalLines[61][0].p2 := point(201, 61);  
  FVerticalLines[62][0].p1 := point(40, 62);  FVerticalLines[62][0].p2 := point(201, 62);  
  FVerticalLines[63][0].p1 := point(40, 63);  FVerticalLines[63][0].p2 := point(201, 63);  
  FVerticalLines[64][0].p1 := point(40, 64);  FVerticalLines[64][0].p2 := point(201, 64);  
  FVerticalLines[65][0].p1 := point(40, 65);  FVerticalLines[65][0].p2 := point(201, 65);  
  FVerticalLines[66][0].p1 := point(40, 66);  FVerticalLines[66][0].p2 := point(201, 66);  
  FVerticalLines[67][0].p1 := point(40, 67);  FVerticalLines[67][0].p2 := point(201, 67);  
  FVerticalLines[68][0].p1 := point(40, 68);  FVerticalLines[68][0].p2 := point(201, 68);  
  FVerticalLines[69][0].p1 := point(40, 69);  FVerticalLines[69][0].p2 := point(201, 69);  
  FVerticalLines[70][0].p1 := point(41, 70);  FVerticalLines[70][0].p2 := point(201, 70);  
  FVerticalLines[71][0].p1 := point(41, 71);  FVerticalLines[71][0].p2 := point(200, 71);  
  FVerticalLines[72][0].p1 := point(41, 72);  FVerticalLines[72][0].p2 := point(200, 72);  
  FVerticalLines[73][0].p1 := point(41, 73);  FVerticalLines[73][0].p2 := point(200, 73);  
  FVerticalLines[74][0].p1 := point(41, 74);  FVerticalLines[74][0].p2 := point(200, 74);  
  FVerticalLines[75][0].p1 := point(41, 75);  FVerticalLines[75][0].p2 := point(200, 75);  
  FVerticalLines[76][0].p1 := point(41, 76);  FVerticalLines[76][0].p2 := point(200, 76);  
  FVerticalLines[77][0].p1 := point(41, 77);  FVerticalLines[77][0].p2 := point(200, 77);  
  FVerticalLines[78][0].p1 := point(41, 78);  FVerticalLines[78][0].p2 := point(200, 78);  
  FVerticalLines[79][0].p1 := point(41, 79);  FVerticalLines[79][0].p2 := point(200, 79);  
  FVerticalLines[80][0].p1 := point(42, 80);  FVerticalLines[80][0].p2 := point(200, 80);  
  FVerticalLines[81][0].p1 := point(42, 81);  FVerticalLines[81][0].p2 := point(199, 81);  
  FVerticalLines[82][0].p1 := point(42, 82);  FVerticalLines[82][0].p2 := point(199, 82);
  FVerticalLines[83][0].p1 := point(42, 83);  FVerticalLines[83][0].p2 := point(199, 83);  
  FVerticalLines[84][0].p1 := point(42, 84);  FVerticalLines[84][0].p2 := point(199, 84);  
  FVerticalLines[85][0].p1 := point(42, 85);  FVerticalLines[85][0].p2 := point(199, 85);  
  FVerticalLines[86][0].p1 := point(42, 86);  FVerticalLines[86][0].p2 := point(199, 86);  
  FVerticalLines[87][0].p1 := point(42, 87);  FVerticalLines[87][0].p2 := point(199, 87);  
  FVerticalLines[88][0].p1 := point(42, 88);  FVerticalLines[88][0].p2 := point(199, 88);  
  FVerticalLines[89][0].p1 := point(42, 89);  FVerticalLines[89][0].p2 := point(199, 89);  
  FVerticalLines[90][0].p1 := point(43, 90);  FVerticalLines[90][0].p2 := point(199, 90);  
  FVerticalLines[91][0].p1 := point(43, 91);  FVerticalLines[91][0].p2 := point(198, 91);  
  FVerticalLines[92][0].p1 := point(43, 92);  FVerticalLines[92][0].p2 := point(198, 92);  
  FVerticalLines[93][0].p1 := point(43, 93);  FVerticalLines[93][0].p2 := point(198, 93);  
  FVerticalLines[94][0].p1 := point(43, 94);  FVerticalLines[94][0].p2 := point(198, 94);  
  FVerticalLines[95][0].p1 := point(43, 95);  FVerticalLines[95][0].p2 := point(198, 95);  
  FVerticalLines[96][0].p1 := point(43, 96);  FVerticalLines[96][0].p2 := point(198, 96);  
  FVerticalLines[97][0].p1 := point(43, 97);  FVerticalLines[97][0].p2 := point(198, 97);  
  FVerticalLines[98][0].p1 := point(43, 98);  FVerticalLines[98][0].p2 := point(198, 98);  
  FVerticalLines[99][0].p1 := point(43, 99);  FVerticalLines[99][0].p2 := point(198, 99);  
  FVerticalLines[100][0].p1 := point(44, 100);  FVerticalLines[100][0].p2 := point(198, 100);  
  FVerticalLines[101][0].p1 := point(44, 101);  FVerticalLines[101][0].p2 := point(197, 101);  
  FVerticalLines[102][0].p1 := point(44, 102);  FVerticalLines[102][0].p2 := point(197, 102);  
  FVerticalLines[103][0].p1 := point(44, 103);  FVerticalLines[103][0].p2 := point(197, 103);  
  FVerticalLines[104][0].p1 := point(44, 104);  FVerticalLines[104][0].p2 := point(197, 104);
  FVerticalLines[105][0].p1 := point(44, 105);  FVerticalLines[105][0].p2 := point(197, 105);  
  FVerticalLines[106][0].p1 := point(44, 106);  FVerticalLines[106][0].p2 := point(197, 106);  
  FVerticalLines[107][0].p1 := point(44, 107);  FVerticalLines[107][0].p2 := point(197, 107);  
  FVerticalLines[108][0].p1 := point(44, 108);  FVerticalLines[108][0].p2 := point(197, 108);  
  FVerticalLines[109][0].p1 := point(44, 109);  FVerticalLines[109][0].p2 := point(197, 109);  
  FVerticalLines[110][0].p1 := point(45, 110);  FVerticalLines[110][0].p2 := point(197, 110);  
  FVerticalLines[111][0].p1 := point(45, 111);  FVerticalLines[111][0].p2 := point(196, 111);  
  FVerticalLines[112][0].p1 := point(45, 112);  FVerticalLines[112][0].p2 := point(196, 112);  
  FVerticalLines[113][0].p1 := point(45, 113);  FVerticalLines[113][0].p2 := point(196, 113);  
  FVerticalLines[114][0].p1 := point(45, 114);  FVerticalLines[114][0].p2 := point(196, 114);  
  FVerticalLines[115][0].p1 := point(45, 115);  FVerticalLines[115][0].p2 := point(196, 115);  
  FVerticalLines[116][0].p1 := point(45, 116);  FVerticalLines[116][0].p2 := point(196, 116);  
  FVerticalLines[117][0].p1 := point(45, 117);  FVerticalLines[117][0].p2 := point(196, 117);  
  FVerticalLines[118][0].p1 := point(45, 118);  FVerticalLines[118][0].p2 := point(196, 118);  
  FVerticalLines[119][0].p1 := point(45, 119);  FVerticalLines[119][0].p2 := point(196, 119);  
  FVerticalLines[120][0].p1 := point(46, 120);  FVerticalLines[120][0].p2 := point(196, 120);  
  FVerticalLines[121][0].p1 := point(46, 121);  FVerticalLines[121][0].p2 := point(195, 121);  
  FVerticalLines[122][0].p1 := point(46, 122);  FVerticalLines[122][0].p2 := point(195, 122);  
  FVerticalLines[123][0].p1 := point(46, 123);  FVerticalLines[123][0].p2 := point(195, 123);  
  FVerticalLines[124][0].p1 := point(46, 124);  FVerticalLines[124][0].p2 := point(195, 124);  
  FVerticalLines[125][0].p1 := point(46, 125);  FVerticalLines[125][0].p2 := point(195, 125);  
  FVerticalLines[126][0].p1 := point(46, 126);  FVerticalLines[126][0].p2 := point(195, 126);
end;

procedure Tiphs1_TD_Gause.setColor(const Value: TColor);
begin
  Canvas.Pen.Color := Value;
end;

end.
