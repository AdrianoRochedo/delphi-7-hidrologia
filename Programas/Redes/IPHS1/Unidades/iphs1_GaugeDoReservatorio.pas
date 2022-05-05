unit iphs1_GaugeDoReservatorio;

interface
uses IrregularGauge;

type
  Tiphs1_ResGause = class(TIrregularGauge)
  private
    procedure Init; override;
  end;

implementation
uses Windows, SysUtils, Classes, Graphics;

{ Tiphs1_ResGause }

procedure Tiphs1_ResGause.Init;
var i: Integer;
begin
  ImageTop := 128;
  ImageHeight := 146;

  Canvas.Pen.Color := Windows.RGB(0, 128, 255);

  // dimensiona os arrays
  SetLength(FVerticalLines, ImageHeight + 1);
  for i := 0 to High(FVerticalLines) do
    if i < 32 then
       SetLength(FVerticalLines[i], 3)
    else
       SetLength(FVerticalLines[i], 1);

  // inicializa os array ---------------------------------------------------------------
  FVerticalLines[0][0].p1 := point(61, 128);  FVerticalLines[0][0].p2 := point(163, 128);
  FVerticalLines[1][0].p1 := point(61, 129);  FVerticalLines[1][0].p2 := point(163, 129);
  FVerticalLines[2][0].p1 := point(61, 130);  FVerticalLines[2][0].p2 := point(163, 130);
  FVerticalLines[3][0].p1 := point(61, 131);  FVerticalLines[3][0].p2 := point(163, 131);
  FVerticalLines[4][0].p1 := point(61, 132);  FVerticalLines[4][0].p2 := point(163, 132);
  FVerticalLines[5][0].p1 := point(62, 133);  FVerticalLines[5][0].p2 := point(163, 133);
  FVerticalLines[6][0].p1 := point(62, 134);  FVerticalLines[6][0].p2 := point(163, 134);
  FVerticalLines[7][0].p1 := point(62, 135);  FVerticalLines[7][0].p2 := point(163, 135);
  FVerticalLines[8][0].p1 := point(62, 136);  FVerticalLines[8][0].p2 := point(163, 136);
  FVerticalLines[9][0].p1 := point(62, 137);  FVerticalLines[9][0].p2 := point(163, 137);
  FVerticalLines[10][0].p1 := point(62, 138);  FVerticalLines[10][0].p2 := point(163, 138);
  FVerticalLines[11][0].p1 := point(62, 139);  FVerticalLines[11][0].p2 := point(163, 139);
  FVerticalLines[12][0].p1 := point(62, 140);  FVerticalLines[12][0].p2 := point(163, 140);
  FVerticalLines[13][0].p1 := point(62, 141);  FVerticalLines[13][0].p2 := point(163, 141);
  FVerticalLines[14][0].p1 := point(62, 142);  FVerticalLines[14][0].p2 := point(163, 142);
  FVerticalLines[15][0].p1 := point(62, 143);  FVerticalLines[15][0].p2 := point(163, 143);
  FVerticalLines[16][0].p1 := point(62, 144);  FVerticalLines[16][0].p2 := point(163, 144);  
  FVerticalLines[17][0].p1 := point(62, 145);  FVerticalLines[17][0].p2 := point(164, 145);  
  FVerticalLines[18][0].p1 := point(62, 146);  FVerticalLines[18][0].p2 := point(164, 146);  
  FVerticalLines[19][0].p1 := point(60, 147);  FVerticalLines[19][0].p2 := point(164, 147);  
  FVerticalLines[20][0].p1 := point(60, 148);  FVerticalLines[20][0].p2 := point(164, 148);  
  FVerticalLines[21][0].p1 := point(60, 149);  FVerticalLines[21][0].p2 := point(164, 149);  
  FVerticalLines[22][0].p1 := point(61, 150);  FVerticalLines[22][0].p2 := point(164, 150);  
  FVerticalLines[23][0].p1 := point(62, 151);  FVerticalLines[23][0].p2 := point(164, 151);  
  FVerticalLines[24][0].p1 := point(63, 152);  FVerticalLines[24][0].p2 := point(164, 152);  
  FVerticalLines[25][0].p1 := point(63, 153);  FVerticalLines[25][0].p2 := point(164, 153);  
  FVerticalLines[26][0].p1 := point(64, 154);  FVerticalLines[26][0].p2 := point(164, 154);  
  FVerticalLines[27][0].p1 := point(65, 155);  FVerticalLines[27][0].p2 := point(164, 155);  
  FVerticalLines[28][0].p1 := point(65, 156);  FVerticalLines[28][0].p2 := point(164, 156);  
  FVerticalLines[29][0].p1 := point(65, 157);  FVerticalLines[29][0].p2 := point(164, 157);  
  FVerticalLines[30][0].p1 := point(66, 158);  FVerticalLines[30][0].p2 := point(164, 158);  
  FVerticalLines[31][0].p1 := point(66, 159);  FVerticalLines[31][0].p2 := point(164, 159);  

  FVerticalLines[0][1].p1 := point(174, 128);  FVerticalLines[0][1].p2 := point(305, 128);  
  FVerticalLines[1][1].p1 := point(174, 129);  FVerticalLines[1][1].p2 := point(305, 129);  
  FVerticalLines[2][1].p1 := point(174, 130);  FVerticalLines[2][1].p2 := point(305, 130);  
  FVerticalLines[3][1].p1 := point(174, 131);  FVerticalLines[3][1].p2 := point(305, 131);  
  FVerticalLines[4][1].p1 := point(174, 132);  FVerticalLines[4][1].p2 := point(305, 132);
  FVerticalLines[5][1].p1 := point(174, 133);  FVerticalLines[5][1].p2 := point(305, 133);  
  FVerticalLines[6][1].p1 := point(174, 134);  FVerticalLines[6][1].p2 := point(305, 134);  
  FVerticalLines[7][1].p1 := point(174, 135);  FVerticalLines[7][1].p2 := point(305, 135);  
  FVerticalLines[8][1].p1 := point(174, 136);  FVerticalLines[8][1].p2 := point(305, 136);  
  FVerticalLines[9][1].p1 := point(174, 137);  FVerticalLines[9][1].p2 := point(306, 137);  
  FVerticalLines[10][1].p1 := point(174, 138);  FVerticalLines[10][1].p2 := point(306, 138);  
  FVerticalLines[11][1].p1 := point(174, 139);  FVerticalLines[11][1].p2 := point(306, 139);  
  FVerticalLines[12][1].p1 := point(174, 140);  FVerticalLines[12][1].p2 := point(306, 140);  
  FVerticalLines[13][1].p1 := point(174, 141);  FVerticalLines[13][1].p2 := point(306, 141);  
  FVerticalLines[14][1].p1 := point(174, 142);  FVerticalLines[14][1].p2 := point(307, 142);  
  FVerticalLines[15][1].p1 := point(174, 143);  FVerticalLines[15][1].p2 := point(307, 143);  
  FVerticalLines[16][1].p1 := point(174, 144);  FVerticalLines[16][1].p2 := point(307, 144);  
  FVerticalLines[17][1].p1 := point(174, 145);  FVerticalLines[17][1].p2 := point(307, 145);  
  FVerticalLines[18][1].p1 := point(174, 146);  FVerticalLines[18][1].p2 := point(307, 146);  
  FVerticalLines[19][1].p1 := point(174, 147);  FVerticalLines[19][1].p2 := point(307, 147);  
  FVerticalLines[20][1].p1 := point(174, 148);  FVerticalLines[20][1].p2 := point(308, 148);  
  FVerticalLines[21][1].p1 := point(174, 149);  FVerticalLines[21][1].p2 := point(308, 149);  
  FVerticalLines[22][1].p1 := point(174, 150);  FVerticalLines[22][1].p2 := point(308, 150);  
  FVerticalLines[23][1].p1 := point(174, 151);  FVerticalLines[23][1].p2 := point(308, 151);  
  FVerticalLines[24][1].p1 := point(174, 152);  FVerticalLines[24][1].p2 := point(308, 152);  
  FVerticalLines[25][1].p1 := point(174, 153);  FVerticalLines[25][1].p2 := point(308, 153);  
  FVerticalLines[26][1].p1 := point(174, 154);  FVerticalLines[26][1].p2 := point(308, 154);
  FVerticalLines[27][1].p1 := point(174, 155);  FVerticalLines[27][1].p2 := point(308, 155);  
  FVerticalLines[28][1].p1 := point(174, 156);  FVerticalLines[28][1].p2 := point(308, 156);  
  FVerticalLines[29][1].p1 := point(174, 157);  FVerticalLines[29][1].p2 := point(308, 157);  
  FVerticalLines[30][1].p1 := point(174, 158);  FVerticalLines[30][1].p2 := point(308, 158);  
  FVerticalLines[31][1].p1 := point(174, 159);  FVerticalLines[31][1].p2 := point(308, 159);  

  FVerticalLines[0][2].p1 := point(318, 128);  FVerticalLines[0][2].p2 := point(396, 128);  
  FVerticalLines[1][2].p1 := point(318, 129);  FVerticalLines[1][2].p2 := point(396, 129);  
  FVerticalLines[2][2].p1 := point(318, 130);  FVerticalLines[2][2].p2 := point(395, 130);  
  FVerticalLines[3][2].p1 := point(318, 131);  FVerticalLines[3][2].p2 := point(395, 131);  
  FVerticalLines[4][2].p1 := point(318, 132);  FVerticalLines[4][2].p2 := point(395, 132);  
  FVerticalLines[5][2].p1 := point(318, 133);  FVerticalLines[5][2].p2 := point(395, 133);  
  FVerticalLines[6][2].p1 := point(318, 134);  FVerticalLines[6][2].p2 := point(394, 134);  
  FVerticalLines[7][2].p1 := point(318, 135);  FVerticalLines[7][2].p2 := point(394, 135);  
  FVerticalLines[8][2].p1 := point(318, 136);  FVerticalLines[8][2].p2 := point(394, 136);  
  FVerticalLines[9][2].p1 := point(318, 137);  FVerticalLines[9][2].p2 := point(393, 137);  
  FVerticalLines[10][2].p1 := point(318, 138);  FVerticalLines[10][2].p2 := point(393, 138);  
  FVerticalLines[11][2].p1 := point(318, 139);  FVerticalLines[11][2].p2 := point(393, 139);  
  FVerticalLines[12][2].p1 := point(318, 140);  FVerticalLines[12][2].p2 := point(393, 140);  
  FVerticalLines[13][2].p1 := point(318, 141);  FVerticalLines[13][2].p2 := point(393, 141);  
  FVerticalLines[14][2].p1 := point(318, 142);  FVerticalLines[14][2].p2 := point(393, 142);  
  FVerticalLines[15][2].p1 := point(318, 143);  FVerticalLines[15][2].p2 := point(393, 143);
  FVerticalLines[16][2].p1 := point(318, 144);  FVerticalLines[16][2].p2 := point(392, 144);  
  FVerticalLines[17][2].p1 := point(318, 145);  FVerticalLines[17][2].p2 := point(392, 145);  
  FVerticalLines[18][2].p1 := point(318, 146);  FVerticalLines[18][2].p2 := point(392, 146);  
  FVerticalLines[19][2].p1 := point(318, 147);  FVerticalLines[19][2].p2 := point(391, 147);  
  FVerticalLines[20][2].p1 := point(318, 148);  FVerticalLines[20][2].p2 := point(391, 148);  
  FVerticalLines[21][2].p1 := point(318, 149);  FVerticalLines[21][2].p2 := point(391, 149);  
  FVerticalLines[22][2].p1 := point(318, 150);  FVerticalLines[22][2].p2 := point(391, 150);  
  FVerticalLines[23][2].p1 := point(318, 151);  FVerticalLines[23][2].p2 := point(391, 151);  
  FVerticalLines[24][2].p1 := point(318, 152);  FVerticalLines[24][2].p2 := point(391, 152);  
  FVerticalLines[25][2].p1 := point(318, 153);  FVerticalLines[25][2].p2 := point(390, 153);  
  FVerticalLines[26][2].p1 := point(318, 154);  FVerticalLines[26][2].p2 := point(390, 154);  
  FVerticalLines[27][2].p1 := point(318, 155);  FVerticalLines[27][2].p2 := point(390, 155);  
  FVerticalLines[28][2].p1 := point(318, 156);  FVerticalLines[28][2].p2 := point(390, 156);  
  FVerticalLines[29][2].p1 := point(318, 157);  FVerticalLines[29][2].p2 := point(389, 157);  
  FVerticalLines[30][2].p1 := point(318, 158);  FVerticalLines[30][2].p2 := point(388, 158);  
  FVerticalLines[31][2].p1 := point(318, 159);  FVerticalLines[31][2].p2 := point(385, 159);  

  FVerticalLines[32][0].p1 := point(67, 160);  FVerticalLines[32][0].p2 := point(384, 160);  
  FVerticalLines[33][0].p1 := point(67, 161);  FVerticalLines[33][0].p2 := point(384, 161);  
  FVerticalLines[34][0].p1 := point(68, 162);  FVerticalLines[34][0].p2 := point(384, 162);  
  FVerticalLines[35][0].p1 := point(69, 163);  FVerticalLines[35][0].p2 := point(384, 163);  
  FVerticalLines[36][0].p1 := point(69, 164);  FVerticalLines[36][0].p2 := point(384, 164);
  FVerticalLines[37][0].p1 := point(70, 165);  FVerticalLines[37][0].p2 := point(384, 165);  
  FVerticalLines[38][0].p1 := point(70, 166);  FVerticalLines[38][0].p2 := point(383, 166);  
  FVerticalLines[39][0].p1 := point(71, 167);  FVerticalLines[39][0].p2 := point(383, 167);  
  FVerticalLines[40][0].p1 := point(71, 168);  FVerticalLines[40][0].p2 := point(383, 168);  
  FVerticalLines[41][0].p1 := point(72, 169);  FVerticalLines[41][0].p2 := point(383, 169);  
  FVerticalLines[42][0].p1 := point(72, 170);  FVerticalLines[42][0].p2 := point(383, 170);  
  FVerticalLines[43][0].p1 := point(72, 171);  FVerticalLines[43][0].p2 := point(383, 171);  
  FVerticalLines[44][0].p1 := point(72, 172);  FVerticalLines[44][0].p2 := point(382, 172);  
  FVerticalLines[45][0].p1 := point(72, 173);  FVerticalLines[45][0].p2 := point(382, 173);  
  FVerticalLines[46][0].p1 := point(72, 174);  FVerticalLines[46][0].p2 := point(381, 174);  
  FVerticalLines[47][0].p1 := point(73, 175);  FVerticalLines[47][0].p2 := point(381, 175);  
  FVerticalLines[48][0].p1 := point(73, 176);  FVerticalLines[48][0].p2 := point(381, 176);  
  FVerticalLines[49][0].p1 := point(73, 177);  FVerticalLines[49][0].p2 := point(381, 177);  
  FVerticalLines[50][0].p1 := point(73, 178);  FVerticalLines[50][0].p2 := point(380, 178);  
  FVerticalLines[51][0].p1 := point(74, 179);  FVerticalLines[51][0].p2 := point(380, 179);  
  FVerticalLines[52][0].p1 := point(75, 180);  FVerticalLines[52][0].p2 := point(380, 180);  
  FVerticalLines[53][0].p1 := point(76, 181);  FVerticalLines[53][0].p2 := point(379, 181);  
  FVerticalLines[54][0].p1 := point(76, 182);  FVerticalLines[54][0].p2 := point(379, 182);  
  FVerticalLines[55][0].p1 := point(77, 183);  FVerticalLines[55][0].p2 := point(378, 183);  
  FVerticalLines[56][0].p1 := point(78, 184);  FVerticalLines[56][0].p2 := point(377, 184);  
  FVerticalLines[57][0].p1 := point(78, 185);  FVerticalLines[57][0].p2 := point(377, 185);  
  FVerticalLines[58][0].p1 := point(79, 186);  FVerticalLines[58][0].p2 := point(376, 186);
  FVerticalLines[59][0].p1 := point(80, 187);  FVerticalLines[59][0].p2 := point(376, 187);  
  FVerticalLines[60][0].p1 := point(81, 188);  FVerticalLines[60][0].p2 := point(376, 188);  
  FVerticalLines[61][0].p1 := point(82, 189);  FVerticalLines[61][0].p2 := point(375, 189);  
  FVerticalLines[62][0].p1 := point(83, 190);  FVerticalLines[62][0].p2 := point(375, 190);  
  FVerticalLines[63][0].p1 := point(83, 191);  FVerticalLines[63][0].p2 := point(374, 191);  
  FVerticalLines[64][0].p1 := point(84, 192);  FVerticalLines[64][0].p2 := point(374, 192);  
  FVerticalLines[65][0].p1 := point(84, 193);  FVerticalLines[65][0].p2 := point(373, 193);  
  FVerticalLines[66][0].p1 := point(85, 194);  FVerticalLines[66][0].p2 := point(373, 194);  
  FVerticalLines[67][0].p1 := point(86, 195);  FVerticalLines[67][0].p2 := point(373, 195);  
  FVerticalLines[68][0].p1 := point(87, 196);  FVerticalLines[68][0].p2 := point(373, 196);  
  FVerticalLines[69][0].p1 := point(88, 197);  FVerticalLines[69][0].p2 := point(372, 197);  
  FVerticalLines[70][0].p1 := point(89, 198);  FVerticalLines[70][0].p2 := point(372, 198);  
  FVerticalLines[71][0].p1 := point(90, 199);  FVerticalLines[71][0].p2 := point(372, 199);  
  FVerticalLines[72][0].p1 := point(91, 200);  FVerticalLines[72][0].p2 := point(372, 200);  
  FVerticalLines[73][0].p1 := point(93, 201);  FVerticalLines[73][0].p2 := point(371, 201);  
  FVerticalLines[74][0].p1 := point(95, 202);  FVerticalLines[74][0].p2 := point(371, 202);  
  FVerticalLines[75][0].p1 := point(95, 203);  FVerticalLines[75][0].p2 := point(371, 203);  
  FVerticalLines[76][0].p1 := point(95, 204);  FVerticalLines[76][0].p2 := point(371, 204);  
  FVerticalLines[77][0].p1 := point(95, 205);  FVerticalLines[77][0].p2 := point(371, 205);  
  FVerticalLines[78][0].p1 := point(95, 206);  FVerticalLines[78][0].p2 := point(371, 206);  
  FVerticalLines[79][0].p1 := point(97, 207);  FVerticalLines[79][0].p2 := point(371, 207);  
  FVerticalLines[80][0].p1 := point(99, 208);  FVerticalLines[80][0].p2 := point(371, 208);
  FVerticalLines[81][0].p1 := point(99, 209);  FVerticalLines[81][0].p2 := point(371, 209);  
  FVerticalLines[82][0].p1 := point(99, 210);  FVerticalLines[82][0].p2 := point(371, 210);  
  FVerticalLines[83][0].p1 := point(99, 211);  FVerticalLines[83][0].p2 := point(370, 211);  
  FVerticalLines[84][0].p1 := point(99, 212);  FVerticalLines[84][0].p2 := point(370, 212);  
  FVerticalLines[85][0].p1 := point(101, 213);  FVerticalLines[85][0].p2 := point(370, 213);  
  FVerticalLines[86][0].p1 := point(102, 214);  FVerticalLines[86][0].p2 := point(370, 214);  
  FVerticalLines[87][0].p1 := point(103, 215);  FVerticalLines[87][0].p2 := point(369, 215);  
  FVerticalLines[88][0].p1 := point(104, 216);  FVerticalLines[88][0].p2 := point(369, 216);  
  FVerticalLines[89][0].p1 := point(104, 217);  FVerticalLines[89][0].p2 := point(368, 217);  
  FVerticalLines[90][0].p1 := point(105, 218);  FVerticalLines[90][0].p2 := point(367, 218);  
  FVerticalLines[91][0].p1 := point(106, 219);  FVerticalLines[91][0].p2 := point(367, 219);  
  FVerticalLines[92][0].p1 := point(107, 220);  FVerticalLines[92][0].p2 := point(366, 220);  
  FVerticalLines[93][0].p1 := point(107, 221);  FVerticalLines[93][0].p2 := point(366, 221);  
  FVerticalLines[94][0].p1 := point(108, 222);  FVerticalLines[94][0].p2 := point(366, 222);  
  FVerticalLines[95][0].p1 := point(109, 223);  FVerticalLines[95][0].p2 := point(366, 223);  
  FVerticalLines[96][0].p1 := point(110, 224);  FVerticalLines[96][0].p2 := point(365, 224);  
  FVerticalLines[97][0].p1 := point(111, 225);  FVerticalLines[97][0].p2 := point(364, 225);  
  FVerticalLines[98][0].p1 := point(112, 226);  FVerticalLines[98][0].p2 := point(363, 226);  
  FVerticalLines[99][0].p1 := point(113, 227);  FVerticalLines[99][0].p2 := point(363, 227);  
  FVerticalLines[100][0].p1 := point(113, 228);  FVerticalLines[100][0].p2 := point(362, 228);  
  FVerticalLines[101][0].p1 := point(114, 229);  FVerticalLines[101][0].p2 := point(362, 229);  
  FVerticalLines[102][0].p1 := point(115, 230);  FVerticalLines[102][0].p2 := point(362, 230);
  FVerticalLines[103][0].p1 := point(115, 231);  FVerticalLines[103][0].p2 := point(361, 231);  
  FVerticalLines[104][0].p1 := point(116, 232);  FVerticalLines[104][0].p2 := point(361, 232);  
  FVerticalLines[105][0].p1 := point(117, 233);  FVerticalLines[105][0].p2 := point(361, 233);  
  FVerticalLines[106][0].p1 := point(118, 234);  FVerticalLines[106][0].p2 := point(360, 234);  
  FVerticalLines[107][0].p1 := point(118, 235);  FVerticalLines[107][0].p2 := point(360, 235);  
  FVerticalLines[108][0].p1 := point(119, 236);  FVerticalLines[108][0].p2 := point(360, 236);  
  FVerticalLines[109][0].p1 := point(119, 237);  FVerticalLines[109][0].p2 := point(360, 237);  
  FVerticalLines[110][0].p1 := point(120, 238);  FVerticalLines[110][0].p2 := point(360, 238);  
  FVerticalLines[111][0].p1 := point(120, 239);  FVerticalLines[111][0].p2 := point(359, 239);  
  FVerticalLines[112][0].p1 := point(121, 240);  FVerticalLines[112][0].p2 := point(359, 240);  
  FVerticalLines[113][0].p1 := point(121, 241);  FVerticalLines[113][0].p2 := point(357, 241);  
  FVerticalLines[114][0].p1 := point(122, 242);  FVerticalLines[114][0].p2 := point(356, 242);  
  FVerticalLines[115][0].p1 := point(122, 243);  FVerticalLines[115][0].p2 := point(354, 243);  
  FVerticalLines[116][0].p1 := point(123, 244);  FVerticalLines[116][0].p2 := point(353, 244);  
  FVerticalLines[117][0].p1 := point(123, 245);  FVerticalLines[117][0].p2 := point(352, 245);  
  FVerticalLines[118][0].p1 := point(123, 246);  FVerticalLines[118][0].p2 := point(351, 246);  
  FVerticalLines[119][0].p1 := point(124, 247);  FVerticalLines[119][0].p2 := point(350, 247);  
  FVerticalLines[120][0].p1 := point(124, 248);  FVerticalLines[120][0].p2 := point(349, 248);  
  FVerticalLines[121][0].p1 := point(125, 249);  FVerticalLines[121][0].p2 := point(347, 249);  
  FVerticalLines[122][0].p1 := point(126, 250);  FVerticalLines[122][0].p2 := point(346, 250);  
  FVerticalLines[123][0].p1 := point(127, 251);  FVerticalLines[123][0].p2 := point(329, 251);  
  FVerticalLines[124][0].p1 := point(128, 252);  FVerticalLines[124][0].p2 := point(327, 252);
  FVerticalLines[125][0].p1 := point(129, 253);  FVerticalLines[125][0].p2 := point(326, 253);  
  FVerticalLines[126][0].p1 := point(130, 254);  FVerticalLines[126][0].p2 := point(326, 254);  
  FVerticalLines[127][0].p1 := point(131, 255);  FVerticalLines[127][0].p2 := point(326, 255);  
  FVerticalLines[128][0].p1 := point(131, 256);  FVerticalLines[128][0].p2 := point(326, 256);  
  FVerticalLines[129][0].p1 := point(132, 257);  FVerticalLines[129][0].p2 := point(326, 257);  
  FVerticalLines[130][0].p1 := point(133, 258);  FVerticalLines[130][0].p2 := point(326, 258);  
  FVerticalLines[131][0].p1 := point(133, 259);  FVerticalLines[131][0].p2 := point(326, 259);  
  FVerticalLines[132][0].p1 := point(134, 260);  FVerticalLines[132][0].p2 := point(326, 260);  
  FVerticalLines[133][0].p1 := point(135, 261);  FVerticalLines[133][0].p2 := point(326, 261);  
  FVerticalLines[134][0].p1 := point(135, 262);  FVerticalLines[134][0].p2 := point(326, 262);  
  FVerticalLines[135][0].p1 := point(135, 263);  FVerticalLines[135][0].p2 := point(326, 263);  
  FVerticalLines[136][0].p1 := point(136, 264);  FVerticalLines[136][0].p2 := point(326, 264);  
  FVerticalLines[137][0].p1 := point(136, 265);  FVerticalLines[137][0].p2 := point(326, 265);  
  FVerticalLines[138][0].p1 := point(137, 266);  FVerticalLines[138][0].p2 := point(326, 266);  
  FVerticalLines[139][0].p1 := point(138, 267);  FVerticalLines[139][0].p2 := point(326, 267);  
  FVerticalLines[140][0].p1 := point(139, 268);  FVerticalLines[140][0].p2 := point(319, 268);  
  FVerticalLines[141][0].p1 := point(139, 269);  FVerticalLines[141][0].p2 := point(319, 269);  
  FVerticalLines[142][0].p1 := point(140, 270);  FVerticalLines[142][0].p2 := point(318, 270);  
  FVerticalLines[143][0].p1 := point(141, 271);  FVerticalLines[143][0].p2 := point(318, 271);  
  FVerticalLines[144][0].p1 := point(141, 272);  FVerticalLines[144][0].p2 := point(317, 272);  
  FVerticalLines[145][0].p1 := point(141, 273);  FVerticalLines[145][0].p2 := point(317, 273);
end;

end.
