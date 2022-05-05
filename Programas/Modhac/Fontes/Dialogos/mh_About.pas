unit mh_About;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Led, wsRotinasUteis, jpeg;

type

  TShowAbout_1 = procedure;

  TDLG_Info = class(TForm)
    Bevel1: TBevel;
    Panel1: TPanel;
    btnFechar: TBitBtn;
    PBCreditos: TPaintBox;
    Panel2: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Image1: TImage;
    Image2: TImage;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMaisInfoClick(Sender: TObject);
  private
    Timer1      : TTimer;
    Bitmap      : TBitmap;
    i           : Integer;
    Altura      : Integer;
    ShowAbout_1 : TShowAbout_1;

    Procedure MostraCreditos;
  public
    { Public declarations }
  end;

var
  DLG_Info: TDLG_Info;

implementation

{$R *.DFM}

const
  cAlturaBitmap = 545;

procedure TDLG_Info.FormActivate(Sender: TObject);
begin
  MostraCreditos;
End;

Procedure TDLG_Info.MostraCreditos;
Var R : TRect;
    Centro : Integer;
    Inicio : Integer;

    Procedure WritePB(NF : String; T : Byte; C : TColor; S : String);
    Var Centro : Integer;
    Begin
      With Bitmap do
        With Canvas Do Begin
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
  Timer1.Interval := 100;
  Bitmap := TBitmap.Create;
  With Bitmap do Begin
    Width := PBCreditos.Width;
    Altura := cAlturaBitmap;
    With Canvas do Begin
      Brush.Color := clBlack;
      R := Rect(0,0,Width,Altura);
      FillRect(R);
      Height := Altura;

      Inicio := 85;
      WritePB('Arial', 18, clWhite, 'MODHAC 2000 para Windows');

      Inc(Inicio,28);
      WritePB('System', 12, clSilver, 'Versão 1.7');

      Inc(Inicio,30);
      WritePB('Arial', 14, clWhite, 'Desenvolvedores');

      Inc(Inicio,30);
      WritePB('System', 10, clSilver, 'Adriano Rochedo Conceição');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'rochedo@ufpel.tche.br');

      Inc(Inicio,22);
      WritePB('System', 10, clSilver, 'Anderson Priebe Ferrugem');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'sandman@ufpel.tche.br');

      Inc(Inicio,22);
      WritePB('System', 10, clSilver, 'João Soares Viegas Filho');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'jsviegas@uol.com.br');

      Inc(Inicio,30);
      WritePB('Arial', 18, clWhite, 'MODHAC para DOS');

      Inc(Inicio,35);
      WritePB('Arial', 14, clWhite, 'Desenvolvedores');

      Inc(Inicio,30);
      WritePB('System', 10, clSilver, 'Antonio Eduardo Lanna');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'lanna@if.ufrgs.br');

      Inc(Inicio,22);
      WritePB('System', 10, clSilver, 'Jaildo dos Santos Pereira');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'pegaso@if.ufrgs.br');

      Inc(Inicio,30);
      WritePB('Arial', 14, clWhite, 'Apoio:');

      Inc(Inicio,30);
      WritePB('System', 10, clSilver, 'Amauri de Almeida Machado');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'amachado@ufpel.tche.br');

      Inc(Inicio,30);
      WritePB('Arial', 8, clRed, StringOfChar(' ', 65) + 'Todos os direitos reservados.');
    End;
  End;
End;

procedure TDLG_Info.FormDeactivate(Sender: TObject);
begin
  Timer1.Free;
  Bitmap.Free;
end;

procedure TDLG_Info.Timer1Timer(Sender : TObject);
Begin
  PBCreditos.Canvas.Draw(0,-i,Bitmap);
  Inc(i, 2);
  If i > cAlturaBitmap Then i := -20;
End;

procedure TDLG_Info.FormCreate(Sender: TObject);
begin
  If Screen.PixelsPerInch <> 96 Then
     ScaleBy(96, Screen.PixelsPerInch);
end;

Type TProc = procedure;

procedure TDLG_Info.btnMaisInfoClick(Sender: TObject);
var hDLL: THandle;
    ShowAbout_1: TProc;
begin
  SetCurrentDirectory(PChar(ExtractFilePath(Application.ExeName)));
  hDLL := LoadLibrary('li_Equipe.dll');
  if hDLL <> 0 then
     begin
     @ShowAbout_1 := GetProcAddress(hDLL,'ShowAbout_1');
     if @ShowAbout_1 <> nil then ShowAbout_1;
     FreeLibrary(hDLL);
     end;
end;

end.
