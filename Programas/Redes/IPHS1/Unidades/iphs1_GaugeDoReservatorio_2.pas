unit iphs1_GaugeDoReservatorio_2;

interface
uses IrregularGauge, Graphics;

type
  Tiphs1_ResGause = class(TIrregularGauge)
  private
    procedure Init; override;
  public
    procedure setColor(const Value: TColor);
  end;

implementation
uses Windows, SysUtils, Classes;

{ Tiphs1_ResGause }

procedure Tiphs1_ResGause.Init;
var i, ii: Integer;
begin
  ImageTop := 2;
  ImageHeight := 241 - ImageTop + 1;

  Canvas.Pen.Color := Windows.RGB(128, 0, 0);
  Canvas.Pen.Mode := pmXor;

  // dimensiona os arrays
  SetLength(FVerticalLines, ImageHeight + 1);
  for i := 0 to High(FVerticalLines) do
     begin
     if i < 30 then ii := 1 else
     if (i >= 30) and (i <= 40) then ii := 3 else
     if (i > 40) and (i < 212) then ii := 1 else
     if (i >= 212) and (i <= 223) then ii := 2 else ii := 1;
     SetLength(FVerticalLines[i], ii);
     end;

  // inicializa os array ---------------------------------------------------------------
  FVerticalLines[0][0].p1 := point(9, 2);  FVerticalLines[0][0].p2 := point(223, 2);
  FVerticalLines[1][0].p1 := point(13, 3);  FVerticalLines[1][0].p2 := point(223, 3);  
  FVerticalLines[2][0].p1 := point(17, 4);  FVerticalLines[2][0].p2 := point(223, 4);  
  FVerticalLines[3][0].p1 := point(19, 5);  FVerticalLines[3][0].p2 := point(223, 5);  
  FVerticalLines[4][0].p1 := point(21, 6);  FVerticalLines[4][0].p2 := point(223, 6);  
  FVerticalLines[5][0].p1 := point(23, 7);  FVerticalLines[5][0].p2 := point(223, 7);  
  FVerticalLines[6][0].p1 := point(25, 8);  FVerticalLines[6][0].p2 := point(223, 8);  
  FVerticalLines[7][0].p1 := point(27, 9);  FVerticalLines[7][0].p2 := point(223, 9);  
  FVerticalLines[8][0].p1 := point(28, 10);  FVerticalLines[8][0].p2 := point(223, 10);  
  FVerticalLines[9][0].p1 := point(29, 11);  FVerticalLines[9][0].p2 := point(223, 11);  
  FVerticalLines[10][0].p1 := point(31, 12);  FVerticalLines[10][0].p2 := point(223, 12);  
  FVerticalLines[11][0].p1 := point(32, 13);  FVerticalLines[11][0].p2 := point(223, 13);  
  FVerticalLines[12][0].p1 := point(33, 14);  FVerticalLines[12][0].p2 := point(223, 14);
  FVerticalLines[13][0].p1 := point(34, 15);  FVerticalLines[13][0].p2 := point(223, 15);  
  FVerticalLines[14][0].p1 := point(35, 16);  FVerticalLines[14][0].p2 := point(223, 16);  
  FVerticalLines[15][0].p1 := point(36, 17);  FVerticalLines[15][0].p2 := point(223, 17);  
  FVerticalLines[16][0].p1 := point(37, 18);  FVerticalLines[16][0].p2 := point(223, 18);  
  FVerticalLines[17][0].p1 := point(38, 19);  FVerticalLines[17][0].p2 := point(223, 19);  
  FVerticalLines[18][0].p1 := point(39, 20);  FVerticalLines[18][0].p2 := point(223, 20);  
  FVerticalLines[19][0].p1 := point(40, 21);  FVerticalLines[19][0].p2 := point(223, 21);  
  FVerticalLines[20][0].p1 := point(40, 22);  FVerticalLines[20][0].p2 := point(223, 22);  
  FVerticalLines[21][0].p1 := point(41, 23);  FVerticalLines[21][0].p2 := point(223, 23);  
  FVerticalLines[22][0].p1 := point(42, 24);  FVerticalLines[22][0].p2 := point(223, 24);  
  FVerticalLines[23][0].p1 := point(42, 25);  FVerticalLines[23][0].p2 := point(223, 25);  
  FVerticalLines[24][0].p1 := point(43, 26);  FVerticalLines[24][0].p2 := point(223, 26);  
  FVerticalLines[25][0].p1 := point(44, 27);  FVerticalLines[25][0].p2 := point(223, 27);  
  FVerticalLines[26][0].p1 := point(44, 28);  FVerticalLines[26][0].p2 := point(223, 28);  
  FVerticalLines[27][0].p1 := point(45, 29);  FVerticalLines[27][0].p2 := point(223, 29);  

  FVerticalLines[30][0].p1 := point(45, 30);  FVerticalLines[30][0].p2 := point(230, 30);  
  FVerticalLines[31][0].p1 := point(46, 31);  FVerticalLines[31][0].p2 := point(232, 31);  
  FVerticalLines[32][0].p1 := point(46, 32);  FVerticalLines[32][0].p2 := point(232, 32);  
  FVerticalLines[33][0].p1 := point(47, 33);  FVerticalLines[33][0].p2 := point(232, 33);  
  FVerticalLines[34][0].p1 := point(47, 34);  FVerticalLines[34][0].p2 := point(232, 34);  
  FVerticalLines[35][0].p1 := point(48, 35);  FVerticalLines[35][0].p2 := point(232, 35);  
  FVerticalLines[36][0].p1 := point(48, 36);  FVerticalLines[36][0].p2 := point(232, 36);  
  FVerticalLines[37][0].p1 := point(49, 37);  FVerticalLines[37][0].p2 := point(232, 37);  
  FVerticalLines[38][0].p1 := point(49, 38);  FVerticalLines[38][0].p2 := point(232, 38);  
  FVerticalLines[39][0].p1 := point(50, 39);  FVerticalLines[39][0].p2 := point(232, 39);  
  FVerticalLines[40][0].p1 := point(50, 40);  FVerticalLines[40][0].p2 := point(230, 40);  

  FVerticalLines[30][1].p1 := point(238, 30);  FVerticalLines[30][1].p2 := point(245, 30);  
  FVerticalLines[31][1].p1 := point(236, 31);  FVerticalLines[31][1].p2 := point(247, 31);
  FVerticalLines[32][1].p1 := point(236, 32);  FVerticalLines[32][1].p2 := point(247, 32);  
  FVerticalLines[33][1].p1 := point(236, 33);  FVerticalLines[33][1].p2 := point(247, 33);  
  FVerticalLines[34][1].p1 := point(236, 34);  FVerticalLines[34][1].p2 := point(247, 34);  
  FVerticalLines[35][1].p1 := point(236, 35);  FVerticalLines[35][1].p2 := point(247, 35);  
  FVerticalLines[36][1].p1 := point(236, 36);  FVerticalLines[36][1].p2 := point(247, 36);  
  FVerticalLines[37][1].p1 := point(236, 37);  FVerticalLines[37][1].p2 := point(247, 37);  
  FVerticalLines[38][1].p1 := point(236, 38);  FVerticalLines[38][1].p2 := point(247, 38);  
  FVerticalLines[39][1].p1 := point(236, 39);  FVerticalLines[39][1].p2 := point(247, 39);  
  FVerticalLines[40][1].p1 := point(238, 40);  FVerticalLines[40][1].p2 := point(244, 40);  

  FVerticalLines[30][2].p1 := point(253, 30);  FVerticalLines[30][2].p2 := point(281, 30);  
  FVerticalLines[31][2].p1 := point(251, 31);  FVerticalLines[31][2].p2 := point(281, 31);  
  FVerticalLines[32][2].p1 := point(251, 32);  FVerticalLines[32][2].p2 := point(282, 32);  
  FVerticalLines[33][2].p1 := point(251, 33);  FVerticalLines[33][2].p2 := point(282, 33);  
  FVerticalLines[34][2].p1 := point(251, 34);  FVerticalLines[34][2].p2 := point(282, 34);  
  FVerticalLines[35][2].p1 := point(251, 35);  FVerticalLines[35][2].p2 := point(282, 35);  
  FVerticalLines[36][2].p1 := point(251, 36);  FVerticalLines[36][2].p2 := point(282, 36);  
  FVerticalLines[37][2].p1 := point(251, 37);  FVerticalLines[37][2].p2 := point(282, 37);  
  FVerticalLines[38][2].p1 := point(251, 38);  FVerticalLines[38][2].p2 := point(283, 38);  
  FVerticalLines[39][2].p1 := point(251, 39);  FVerticalLines[39][2].p2 := point(283, 39);  
  FVerticalLines[40][2].p1 := point(253, 40);  FVerticalLines[40][2].p2 := point(283, 40);  

  FVerticalLines[41][0].p1 := point(51, 41);  FVerticalLines[41][0].p2 := point(223, 41);  
  FVerticalLines[42][0].p1 := point(51, 42);  FVerticalLines[42][0].p2 := point(223, 42);  
  FVerticalLines[43][0].p1 := point(52, 43);  FVerticalLines[43][0].p2 := point(223, 43);  
  FVerticalLines[44][0].p1 := point(52, 44);  FVerticalLines[44][0].p2 := point(223, 44);  
  FVerticalLines[45][0].p1 := point(52, 45);  FVerticalLines[45][0].p2 := point(223, 45);  
  FVerticalLines[46][0].p1 := point(52, 46);  FVerticalLines[46][0].p2 := point(223, 46);
  FVerticalLines[47][0].p1 := point(53, 47);  FVerticalLines[47][0].p2 := point(223, 47);  
  FVerticalLines[48][0].p1 := point(53, 48);  FVerticalLines[48][0].p2 := point(223, 48);
  FVerticalLines[49][0].p1 := point(53, 49);  FVerticalLines[49][0].p2 := point(223, 49);  
  FVerticalLines[50][0].p1 := point(54, 50);  FVerticalLines[50][0].p2 := point(223, 50);  
  FVerticalLines[51][0].p1 := point(54, 51);  FVerticalLines[51][0].p2 := point(223, 51);  
  FVerticalLines[52][0].p1 := point(54, 52);  FVerticalLines[52][0].p2 := point(223, 52);  
  FVerticalLines[53][0].p1 := point(54, 53);  FVerticalLines[53][0].p2 := point(223, 53);  
  FVerticalLines[54][0].p1 := point(55, 54);  FVerticalLines[54][0].p2 := point(223, 54);  
  FVerticalLines[55][0].p1 := point(55, 55);  FVerticalLines[55][0].p2 := point(223, 55);  
  FVerticalLines[56][0].p1 := point(55, 56);  FVerticalLines[56][0].p2 := point(223, 56);  
  FVerticalLines[57][0].p1 := point(55, 57);  FVerticalLines[57][0].p2 := point(223, 57);  
  FVerticalLines[58][0].p1 := point(56, 58);  FVerticalLines[58][0].p2 := point(223, 58);  
  FVerticalLines[59][0].p1 := point(56, 59);  FVerticalLines[59][0].p2 := point(223, 59);  
  FVerticalLines[60][0].p1 := point(56, 60);  FVerticalLines[60][0].p2 := point(223, 60);  
  FVerticalLines[61][0].p1 := point(56, 61);  FVerticalLines[61][0].p2 := point(223, 61);  
  FVerticalLines[62][0].p1 := point(56, 62);  FVerticalLines[62][0].p2 := point(223, 62);  
  FVerticalLines[63][0].p1 := point(57, 63);  FVerticalLines[63][0].p2 := point(223, 63);  
  FVerticalLines[64][0].p1 := point(57, 64);  FVerticalLines[64][0].p2 := point(223, 64);  
  FVerticalLines[65][0].p1 := point(57, 65);  FVerticalLines[65][0].p2 := point(223, 65);  
  FVerticalLines[66][0].p1 := point(57, 66);  FVerticalLines[66][0].p2 := point(223, 66);  
  FVerticalLines[67][0].p1 := point(57, 67);  FVerticalLines[67][0].p2 := point(223, 67);  
  FVerticalLines[68][0].p1 := point(57, 68);  FVerticalLines[68][0].p2 := point(223, 68);  
  FVerticalLines[69][0].p1 := point(58, 69);  FVerticalLines[69][0].p2 := point(223, 69);  
  FVerticalLines[70][0].p1 := point(58, 70);  FVerticalLines[70][0].p2 := point(223, 70);  
  FVerticalLines[71][0].p1 := point(58, 71);  FVerticalLines[71][0].p2 := point(223, 71);  
  FVerticalLines[72][0].p1 := point(58, 72);  FVerticalLines[72][0].p2 := point(223, 72);  
  FVerticalLines[73][0].p1 := point(59, 73);  FVerticalLines[73][0].p2 := point(223, 73);  
  FVerticalLines[74][0].p1 := point(59, 74);  FVerticalLines[74][0].p2 := point(223, 74);  
  FVerticalLines[75][0].p1 := point(59, 75);  FVerticalLines[75][0].p2 := point(223, 75);  
  FVerticalLines[76][0].p1 := point(59, 76);  FVerticalLines[76][0].p2 := point(223, 76);
  FVerticalLines[77][0].p1 := point(59, 77);  FVerticalLines[77][0].p2 := point(223, 77);  
  FVerticalLines[78][0].p1 := point(60, 78);  FVerticalLines[78][0].p2 := point(223, 78);
  FVerticalLines[79][0].p1 := point(60, 79);  FVerticalLines[79][0].p2 := point(223, 79);  
  FVerticalLines[80][0].p1 := point(60, 80);  FVerticalLines[80][0].p2 := point(223, 80);  
  FVerticalLines[81][0].p1 := point(60, 81);  FVerticalLines[81][0].p2 := point(223, 81);  
  FVerticalLines[82][0].p1 := point(60, 82);  FVerticalLines[82][0].p2 := point(223, 82);  
  FVerticalLines[83][0].p1 := point(60, 83);  FVerticalLines[83][0].p2 := point(223, 83);  
  FVerticalLines[84][0].p1 := point(60, 84);  FVerticalLines[84][0].p2 := point(223, 84);  
  FVerticalLines[85][0].p1 := point(61, 85);  FVerticalLines[85][0].p2 := point(223, 85);  
  FVerticalLines[86][0].p1 := point(61, 86);  FVerticalLines[86][0].p2 := point(223, 86);  
  FVerticalLines[87][0].p1 := point(61, 87);  FVerticalLines[87][0].p2 := point(223, 87);  
  FVerticalLines[88][0].p1 := point(61, 88);  FVerticalLines[88][0].p2 := point(223, 88);  
  FVerticalLines[89][0].p1 := point(61, 89);  FVerticalLines[89][0].p2 := point(223, 89);  
  FVerticalLines[90][0].p1 := point(61, 90);  FVerticalLines[90][0].p2 := point(223, 90);  
  FVerticalLines[91][0].p1 := point(62, 91);  FVerticalLines[91][0].p2 := point(223, 91);  
  FVerticalLines[92][0].p1 := point(62, 92);  FVerticalLines[92][0].p2 := point(223, 92);  
  FVerticalLines[93][0].p1 := point(62, 93);  FVerticalLines[93][0].p2 := point(223, 93);  
  FVerticalLines[94][0].p1 := point(62, 94);  FVerticalLines[94][0].p2 := point(223, 94);  
  FVerticalLines[95][0].p1 := point(62, 95);  FVerticalLines[95][0].p2 := point(223, 95);  
  FVerticalLines[96][0].p1 := point(62, 96);  FVerticalLines[96][0].p2 := point(223, 96);  
  FVerticalLines[97][0].p1 := point(62, 97);  FVerticalLines[97][0].p2 := point(223, 97);  
  FVerticalLines[98][0].p1 := point(63, 98);  FVerticalLines[98][0].p2 := point(223, 98);  
  FVerticalLines[99][0].p1 := point(63, 99);  FVerticalLines[99][0].p2 := point(223, 99);  
  FVerticalLines[100][0].p1 := point(63, 100);  FVerticalLines[100][0].p2 := point(223, 100);  
  FVerticalLines[101][0].p1 := point(63, 101);  FVerticalLines[101][0].p2 := point(223, 101);  
  FVerticalLines[102][0].p1 := point(63, 102);  FVerticalLines[102][0].p2 := point(223, 102);  
  FVerticalLines[103][0].p1 := point(63, 103);  FVerticalLines[103][0].p2 := point(223, 103);  
  FVerticalLines[104][0].p1 := point(63, 104);  FVerticalLines[104][0].p2 := point(223, 104);  
  FVerticalLines[105][0].p1 := point(64, 105);  FVerticalLines[105][0].p2 := point(223, 105);  
  FVerticalLines[106][0].p1 := point(64, 106);  FVerticalLines[106][0].p2 := point(223, 106);
  FVerticalLines[107][0].p1 := point(64, 107);  FVerticalLines[107][0].p2 := point(223, 107);  
  FVerticalLines[108][0].p1 := point(64, 108);  FVerticalLines[108][0].p2 := point(223, 108);
  FVerticalLines[109][0].p1 := point(64, 109);  FVerticalLines[109][0].p2 := point(223, 109);  
  FVerticalLines[110][0].p1 := point(64, 110);  FVerticalLines[110][0].p2 := point(223, 110);  
  FVerticalLines[111][0].p1 := point(64, 111);  FVerticalLines[111][0].p2 := point(223, 111);  
  FVerticalLines[112][0].p1 := point(64, 112);  FVerticalLines[112][0].p2 := point(223, 112);  
  FVerticalLines[113][0].p1 := point(65, 113);  FVerticalLines[113][0].p2 := point(223, 113);  
  FVerticalLines[114][0].p1 := point(65, 114);  FVerticalLines[114][0].p2 := point(223, 114);  
  FVerticalLines[115][0].p1 := point(65, 115);  FVerticalLines[115][0].p2 := point(223, 115);  
  FVerticalLines[116][0].p1 := point(65, 116);  FVerticalLines[116][0].p2 := point(223, 116);  
  FVerticalLines[117][0].p1 := point(65, 117);  FVerticalLines[117][0].p2 := point(223, 117);  
  FVerticalLines[118][0].p1 := point(66, 118);  FVerticalLines[118][0].p2 := point(223, 118);  
  FVerticalLines[119][0].p1 := point(66, 119);  FVerticalLines[119][0].p2 := point(223, 119);  
  FVerticalLines[120][0].p1 := point(66, 120);  FVerticalLines[120][0].p2 := point(223, 120);  
  FVerticalLines[121][0].p1 := point(66, 121);  FVerticalLines[121][0].p2 := point(223, 121);  
  FVerticalLines[122][0].p1 := point(66, 122);  FVerticalLines[122][0].p2 := point(223, 122);  
  FVerticalLines[123][0].p1 := point(66, 123);  FVerticalLines[123][0].p2 := point(223, 123);  
  FVerticalLines[124][0].p1 := point(66, 124);  FVerticalLines[124][0].p2 := point(223, 124);  
  FVerticalLines[125][0].p1 := point(67, 125);  FVerticalLines[125][0].p2 := point(223, 125);  
  FVerticalLines[126][0].p1 := point(67, 126);  FVerticalLines[126][0].p2 := point(223, 126);  
  FVerticalLines[127][0].p1 := point(67, 127);  FVerticalLines[127][0].p2 := point(223, 127);  
  FVerticalLines[128][0].p1 := point(67, 128);  FVerticalLines[128][0].p2 := point(223, 128);  
  FVerticalLines[129][0].p1 := point(67, 129);  FVerticalLines[129][0].p2 := point(223, 129);  
  FVerticalLines[130][0].p1 := point(68, 130);  FVerticalLines[130][0].p2 := point(223, 130);  
  FVerticalLines[131][0].p1 := point(68, 131);  FVerticalLines[131][0].p2 := point(223, 131);  
  FVerticalLines[132][0].p1 := point(69, 132);  FVerticalLines[132][0].p2 := point(223, 132);  
  FVerticalLines[133][0].p1 := point(69, 133);  FVerticalLines[133][0].p2 := point(223, 133);  
  FVerticalLines[134][0].p1 := point(69, 134);  FVerticalLines[134][0].p2 := point(223, 134);  
  FVerticalLines[135][0].p1 := point(69, 135);  FVerticalLines[135][0].p2 := point(223, 135);  
  FVerticalLines[136][0].p1 := point(69, 136);  FVerticalLines[136][0].p2 := point(223, 136);
  FVerticalLines[137][0].p1 := point(69, 137);  FVerticalLines[137][0].p2 := point(223, 137);  
  FVerticalLines[138][0].p1 := point(69, 138);  FVerticalLines[138][0].p2 := point(223, 138);
  FVerticalLines[139][0].p1 := point(70, 139);  FVerticalLines[139][0].p2 := point(223, 139);  
  FVerticalLines[140][0].p1 := point(70, 140);  FVerticalLines[140][0].p2 := point(223, 140);  
  FVerticalLines[141][0].p1 := point(70, 141);  FVerticalLines[141][0].p2 := point(223, 141);  
  FVerticalLines[142][0].p1 := point(70, 142);  FVerticalLines[142][0].p2 := point(223, 142);  
  FVerticalLines[143][0].p1 := point(71, 143);  FVerticalLines[143][0].p2 := point(223, 143);  
  FVerticalLines[144][0].p1 := point(71, 144);  FVerticalLines[144][0].p2 := point(223, 144);  
  FVerticalLines[145][0].p1 := point(71, 145);  FVerticalLines[145][0].p2 := point(223, 145);  
  FVerticalLines[146][0].p1 := point(71, 146);  FVerticalLines[146][0].p2 := point(223, 146);  
  FVerticalLines[147][0].p1 := point(71, 147);  FVerticalLines[147][0].p2 := point(223, 147);  
  FVerticalLines[148][0].p1 := point(71, 148);  FVerticalLines[148][0].p2 := point(223, 148);  
  FVerticalLines[149][0].p1 := point(72, 149);  FVerticalLines[149][0].p2 := point(223, 149);  
  FVerticalLines[150][0].p1 := point(72, 150);  FVerticalLines[150][0].p2 := point(223, 150);  
  FVerticalLines[151][0].p1 := point(73, 151);  FVerticalLines[151][0].p2 := point(223, 151);  
  FVerticalLines[152][0].p1 := point(73, 152);  FVerticalLines[152][0].p2 := point(223, 152);  
  FVerticalLines[153][0].p1 := point(73, 153);  FVerticalLines[153][0].p2 := point(223, 153);  
  FVerticalLines[154][0].p1 := point(74, 154);  FVerticalLines[154][0].p2 := point(223, 154);  
  FVerticalLines[155][0].p1 := point(74, 155);  FVerticalLines[155][0].p2 := point(223, 155);  
  FVerticalLines[156][0].p1 := point(74, 156);  FVerticalLines[156][0].p2 := point(223, 156);  
  FVerticalLines[157][0].p1 := point(74, 157);  FVerticalLines[157][0].p2 := point(223, 157);  
  FVerticalLines[158][0].p1 := point(74, 158);  FVerticalLines[158][0].p2 := point(223, 158);  
  FVerticalLines[159][0].p1 := point(75, 159);  FVerticalLines[159][0].p2 := point(223, 159);  
  FVerticalLines[160][0].p1 := point(75, 160);  FVerticalLines[160][0].p2 := point(223, 160);  
  FVerticalLines[161][0].p1 := point(75, 161);  FVerticalLines[161][0].p2 := point(223, 161);  
  FVerticalLines[162][0].p1 := point(75, 162);  FVerticalLines[162][0].p2 := point(223, 162);  
  FVerticalLines[163][0].p1 := point(76, 163);  FVerticalLines[163][0].p2 := point(223, 163);  
  FVerticalLines[164][0].p1 := point(76, 164);  FVerticalLines[164][0].p2 := point(223, 164);  
  FVerticalLines[165][0].p1 := point(76, 165);  FVerticalLines[165][0].p2 := point(223, 165);  
  FVerticalLines[166][0].p1 := point(77, 166);  FVerticalLines[166][0].p2 := point(223, 166);
  FVerticalLines[167][0].p1 := point(77, 167);  FVerticalLines[167][0].p2 := point(223, 167);  
  FVerticalLines[168][0].p1 := point(78, 168);  FVerticalLines[168][0].p2 := point(223, 168);
  FVerticalLines[169][0].p1 := point(78, 169);  FVerticalLines[169][0].p2 := point(223, 169);  
  FVerticalLines[170][0].p1 := point(79, 170);  FVerticalLines[170][0].p2 := point(223, 170);  
  FVerticalLines[171][0].p1 := point(79, 171);  FVerticalLines[171][0].p2 := point(223, 171);  
  FVerticalLines[172][0].p1 := point(79, 172);  FVerticalLines[172][0].p2 := point(223, 172);  
  FVerticalLines[173][0].p1 := point(79, 173);  FVerticalLines[173][0].p2 := point(223, 173);  
  FVerticalLines[174][0].p1 := point(80, 174);  FVerticalLines[174][0].p2 := point(223, 174);  
  FVerticalLines[175][0].p1 := point(80, 175);  FVerticalLines[175][0].p2 := point(223, 175);  
  FVerticalLines[176][0].p1 := point(81, 176);  FVerticalLines[176][0].p2 := point(223, 176);  
  FVerticalLines[177][0].p1 := point(81, 177);  FVerticalLines[177][0].p2 := point(223, 177);  
  FVerticalLines[178][0].p1 := point(81, 178);  FVerticalLines[178][0].p2 := point(223, 178);  
  FVerticalLines[179][0].p1 := point(82, 179);  FVerticalLines[179][0].p2 := point(223, 179);  
  FVerticalLines[180][0].p1 := point(83, 180);  FVerticalLines[180][0].p2 := point(223, 180);  
  FVerticalLines[181][0].p1 := point(83, 181);  FVerticalLines[181][0].p2 := point(223, 181);  
  FVerticalLines[182][0].p1 := point(84, 182);  FVerticalLines[182][0].p2 := point(223, 182);  
  FVerticalLines[183][0].p1 := point(84, 183);  FVerticalLines[183][0].p2 := point(223, 183);  
  FVerticalLines[184][0].p1 := point(85, 184);  FVerticalLines[184][0].p2 := point(223, 184);  
  FVerticalLines[185][0].p1 := point(85, 185);  FVerticalLines[185][0].p2 := point(223, 185);  
  FVerticalLines[186][0].p1 := point(86, 186);  FVerticalLines[186][0].p2 := point(223, 186);  
  FVerticalLines[187][0].p1 := point(87, 187);  FVerticalLines[187][0].p2 := point(223, 187);  
  FVerticalLines[188][0].p1 := point(87, 188);  FVerticalLines[188][0].p2 := point(223, 188);  
  FVerticalLines[189][0].p1 := point(88, 189);  FVerticalLines[189][0].p2 := point(223, 189);  
  FVerticalLines[190][0].p1 := point(88, 190);  FVerticalLines[190][0].p2 := point(223, 190);  
  FVerticalLines[191][0].p1 := point(88, 191);  FVerticalLines[191][0].p2 := point(223, 191);  
  FVerticalLines[192][0].p1 := point(89, 192);  FVerticalLines[192][0].p2 := point(223, 192);  
  FVerticalLines[193][0].p1 := point(90, 193);  FVerticalLines[193][0].p2 := point(223, 193);  
  FVerticalLines[194][0].p1 := point(91, 194);  FVerticalLines[194][0].p2 := point(223, 194);  
  FVerticalLines[195][0].p1 := point(91, 195);  FVerticalLines[195][0].p2 := point(223, 195);  
  FVerticalLines[196][0].p1 := point(92, 196);  FVerticalLines[196][0].p2 := point(223, 196);
  FVerticalLines[197][0].p1 := point(93, 197);  FVerticalLines[197][0].p2 := point(223, 197);  
  FVerticalLines[198][0].p1 := point(94, 198);  FVerticalLines[198][0].p2 := point(223, 198);
  FVerticalLines[199][0].p1 := point(95, 199);  FVerticalLines[199][0].p2 := point(223, 199);  
  FVerticalLines[200][0].p1 := point(95, 200);  FVerticalLines[200][0].p2 := point(223, 200);  
  FVerticalLines[201][0].p1 := point(96, 201);  FVerticalLines[201][0].p2 := point(223, 201);  
  FVerticalLines[202][0].p1 := point(96, 202);  FVerticalLines[202][0].p2 := point(223, 202);  
  FVerticalLines[203][0].p1 := point(97, 203);  FVerticalLines[203][0].p2 := point(223, 203);  
  FVerticalLines[204][0].p1 := point(98, 204);  FVerticalLines[204][0].p2 := point(223, 204);  
  FVerticalLines[205][0].p1 := point(99, 205);  FVerticalLines[205][0].p2 := point(223, 205);  
  FVerticalLines[206][0].p1 := point(99, 206);  FVerticalLines[206][0].p2 := point(223, 206);  
  FVerticalLines[207][0].p1 := point(100, 207);  FVerticalLines[207][0].p2 := point(223, 207);  
  FVerticalLines[208][0].p1 := point(101, 208);  FVerticalLines[208][0].p2 := point(223, 208);  
  FVerticalLines[209][0].p1 := point(102, 209);  FVerticalLines[209][0].p2 := point(223, 209);  
  FVerticalLines[210][0].p1 := point(103, 210);  FVerticalLines[210][0].p2 := point(223, 210);  
  FVerticalLines[211][0].p1 := point(105, 211);  FVerticalLines[211][0].p2 := point(223, 211);  

  FVerticalLines[212][0].p1 := point(106, 212);  FVerticalLines[212][0].p2 := point(217, 212);  
  FVerticalLines[213][0].p1 := point(107, 213);  FVerticalLines[213][0].p2 := point(217, 213);  
  FVerticalLines[214][0].p1 := point(108, 214);  FVerticalLines[214][0].p2 := point(217, 214);  
  FVerticalLines[215][0].p1 := point(109, 215);  FVerticalLines[215][0].p2 := point(217, 215);  
  FVerticalLines[216][0].p1 := point(109, 216);  FVerticalLines[216][0].p2 := point(217, 216);  
  FVerticalLines[217][0].p1 := point(110, 217);  FVerticalLines[217][0].p2 := point(217, 217);  
  FVerticalLines[218][0].p1 := point(111, 218);  FVerticalLines[218][0].p2 := point(217, 218);  
  FVerticalLines[219][0].p1 := point(113, 219);  FVerticalLines[219][0].p2 := point(217, 219);  
  FVerticalLines[220][0].p1 := point(114, 220);  FVerticalLines[220][0].p2 := point(217, 220);  
  FVerticalLines[221][0].p1 := point(116, 221);  FVerticalLines[221][0].p2 := point(217, 221);  
  FVerticalLines[222][0].p1 := point(116, 222);  FVerticalLines[222][0].p2 := point(217, 222);  
  FVerticalLines[223][0].p1 := point(118, 223);  FVerticalLines[223][0].p2 := point(217, 223);  

  FVerticalLines[212][1].p1 := point(317, 212);  FVerticalLines[212][1].p2 := point(326, 212);
  FVerticalLines[213][1].p1 := point(317, 213);  FVerticalLines[213][1].p2 := point(326, 213);  
  FVerticalLines[214][1].p1 := point(317, 214);  FVerticalLines[214][1].p2 := point(326, 214);
  FVerticalLines[215][1].p1 := point(317, 215);  FVerticalLines[215][1].p2 := point(326, 215);
  FVerticalLines[216][1].p1 := point(317, 216);  FVerticalLines[216][1].p2 := point(326, 216);
  FVerticalLines[217][1].p1 := point(317, 217);  FVerticalLines[217][1].p2 := point(326, 217);
  FVerticalLines[218][1].p1 := point(317, 218);  FVerticalLines[218][1].p2 := point(326, 218);
  FVerticalLines[219][1].p1 := point(317, 219);  FVerticalLines[219][1].p2 := point(326, 219);
  FVerticalLines[220][1].p1 := point(317, 220);  FVerticalLines[220][1].p2 := point(326, 220);
  FVerticalLines[221][1].p1 := point(317, 221);  FVerticalLines[221][1].p2 := point(326, 221);
  FVerticalLines[222][1].p1 := point(317, 222);  FVerticalLines[222][1].p2 := point(326, 222);
  FVerticalLines[223][1].p1 := point(317, 223);  FVerticalLines[223][1].p2 := point(326, 223);

  FVerticalLines[224][0].p1 := point(120, 224);  FVerticalLines[224][0].p2 := point(223, 224);
  FVerticalLines[225][0].p1 := point(121, 225);  FVerticalLines[225][0].p2 := point(223, 225);
  FVerticalLines[226][0].p1 := point(123, 226);  FVerticalLines[226][0].p2 := point(223, 226);
  FVerticalLines[227][0].p1 := point(125, 227);  FVerticalLines[227][0].p2 := point(223, 227);
  FVerticalLines[228][0].p1 := point(127, 228);  FVerticalLines[228][0].p2 := point(223, 228);
  FVerticalLines[229][0].p1 := point(130, 229);  FVerticalLines[229][0].p2 := point(223, 229);
  FVerticalLines[230][0].p1 := point(132, 230);  FVerticalLines[230][0].p2 := point(223, 230);
  FVerticalLines[231][0].p1 := point(134, 231);  FVerticalLines[231][0].p2 := point(223, 231);
  FVerticalLines[232][0].p1 := point(136, 232);  FVerticalLines[232][0].p2 := point(223, 232);
  FVerticalLines[233][0].p1 := point(138, 233);  FVerticalLines[233][0].p2 := point(223, 233);
  FVerticalLines[234][0].p1 := point(142, 234);  FVerticalLines[234][0].p2 := point(223, 234);
  FVerticalLines[235][0].p1 := point(144, 235);  FVerticalLines[235][0].p2 := point(223, 235);
  FVerticalLines[236][0].p1 := point(147, 236);  FVerticalLines[236][0].p2 := point(223, 236);
  FVerticalLines[237][0].p1 := point(150, 237);  FVerticalLines[237][0].p2 := point(223, 237);
  FVerticalLines[238][0].p1 := point(155, 238);  FVerticalLines[238][0].p2 := point(223, 238);
  FVerticalLines[239][0].p1 := point(161, 239);  FVerticalLines[239][0].p2 := point(223, 239);
  FVerticalLines[240][0].p1 := point(169, 240);  FVerticalLines[240][0].p2 := point(223, 240);
end;

procedure Tiphs1_ResGause.setColor(const Value: TColor);
begin
  Canvas.Pen.Color := Value;
end;

end.
