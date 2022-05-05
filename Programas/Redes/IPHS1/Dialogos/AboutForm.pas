unit AboutForm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, jpeg, About;

const
  cAlturaBitmap = 700;

type
  TShowAbout_1 = procedure;

  Tiphs1_Form_About = class(TForm)
    Bevel1: TBevel;
    Panel1: TPanel;
    btnFechar: TBitBtn;
    PBCreditos: TPaintBox;
    TFrame_About1: TFrame_About;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Timer1 : TTimer;
    Bitmap : TBitmap;
    i : Integer;
    //Altura : Integer;
    ShowAbout_1 : TShowAbout_1;
    Procedure MostraCreditos;
  public
    { Public declarations }
  end;

implementation
uses Hidro_Variaveis,
     iphs1_Constantes,
     LanguageControl;

{$R *.DFM}

procedure Tiphs1_Form_About.FormActivate(Sender: TObject);
begin
  MostraCreditos;
End;

Procedure Tiphs1_Form_About.MostraCreditos;
Var R : TRect;
    Centro : Integer;
    Inicio : Integer;

    Procedure WritePB(NF : String; T : Byte; C : TColor; S : String);
    Var Centro : Integer;
    Begin
      With Bitmap, Canvas do
        Begin
        Font.Name := NF;
        Font.Size := T;
        Font.Color := C;
        Centro := Width div 2 - TextWidth(S) div 2;
        TextOut(Centro,Inicio,S);
        End;
    End;

begin
  i := 0;
  Timer1 := TTimer.Create(Self);
  Timer1.OnTimer := Timer1Timer;
  Timer1.Interval := 50;
  Bitmap := TBitmap.Create;
  With Bitmap do
    Begin
    Width := PBCreditos.Width;
    With Canvas do
      Begin
      Brush.Color := clBlack;
      R := Rect(0,0,Width, cAlturaBitmap);
      FillRect(R);
      Height := cAlturaBitmap;

      Inicio := 85;
      WritePB('Arial', 18, clWhite, 'IPHS1 para Windows');

      Inc(Inicio,28);
      WritePB('Arial', 12, clSilver, 'Versão ' + gVersao);

      // Console

      Inc(Inicio,30);
      WritePB('Arial', 18, clAqua, 'Modelagem Hidrológica e Hidráulica');

      Inc(Inicio,35);
      WritePB('Arial', 16, clYellow, 'IPH - Instituto de Pesquisas Hidráulicas - UFRGS');

      Inc(Inicio,35);
      WritePB('Arial', 8, clSilver, 'Coordenador do Projeto pelo IPH - Autor do IPHS1 versão Console');

      Inc(Inicio,14);
      WritePB('Arial', 10, clWhite, 'Carlos Eduardo Morelli Tucci');

      Inc(Inicio,30);
      WritePB('Arial', 14, clWhite, 'Desenvolvedores do Núcleo em FORTRAN');

      Inc(Inicio,30);
      WritePB('Arial', 10, clWhite, 'Adolfo Villanueva');

      Inc(Inicio,16);
      WritePB('Arial', 10, clWhite, 'Daniel Allasia');

      Inc(Inicio,16);
      WritePB('Arial', 10, clWhite, 'Marcus Cruz');

      Inc(Inicio,16);
      WritePB('Arial', 10, clWhite, 'Marllus das Neves');

      Inc(Inicio,16);
      WritePB('Arial', 10, clWhite, 'Rutinéia Tassi');

      Inc(Inicio,16);
      WritePB('Arial', 10, clWhite, 'Walter Collischonn');

      // Windows

      Inc(Inicio,30);
      WritePB('Arial', 18, clAqua, 'Modelagem Orientada a Objetos da Versão Windows');

      Inc(Inicio,35);
      WritePB('Arial', 16, clYellow, 'FEA - Faculdade de Engenharia Agrícola - UFPel');

      Inc(Inicio,25);
      WritePB('Arial', 16, clYellow, 'Agência para o Desenvolvimento da Lagoa Mirim - UFPel');

      Inc(Inicio,35);
      WritePB('Arial', 8, clSilver, 'Coordenador de Desenvolvimento pela UFPel');

      Inc(Inicio,14);
      WritePB('Arial', 10, clWhite, 'João Soares Viegas Filho');

      Inc(Inicio,24);
      WritePB('Arial', 8, clSilver, 'Analista de Sistemas - Programador');

      Inc(Inicio,14);
      WritePB('Arial', 10, clWhite, 'Adriano Rochedo Conceição');

      Inc(Inicio,24);
      WritePB('Arial', 8, clSilver, 'Colaboradora de Desenvolvimento pela UFPel');

      Inc(Inicio,14);
      WritePB('Arial', 10, clWhite, 'Rita de Cássia Fraga Damé');

      // Final

      Inc(Inicio,30);
      WritePB('Arial', 16, clYellow, 'IPHS1 para Windows é uma evolução do sistema desenvolvido por');

      Inc(Inicio,30);
      WritePB('Arial', 10, clWhite, 'Carlos Eduardo Morelli Tucci');

      Inc(Inicio,16);
      WritePB('Arial', 10, clWhite, 'Eduardo A. Zamanillo');

      Inc(Inicio,16);
      WritePB('Arial', 10, clWhite, 'Hugo D. Pasinato');
    End;
  End;
End;

procedure Tiphs1_Form_About.FormDeactivate(Sender: TObject);
begin
  Timer1.Free;
  Bitmap.Free;
end;

procedure Tiphs1_Form_About.Timer1Timer(Sender : TObject);
Begin
  PBCreditos.Canvas.Draw(0,-i,Bitmap);
  Inc(i,1);
  If i > cAlturaBitmap Then i := -20;
End;

procedure Tiphs1_Form_About.FormCreate(Sender: TObject);
begin
  If Screen.PixelsPerInch <> 96 Then
     ScaleBy(96, Screen.PixelsPerInch);
end;

end.
