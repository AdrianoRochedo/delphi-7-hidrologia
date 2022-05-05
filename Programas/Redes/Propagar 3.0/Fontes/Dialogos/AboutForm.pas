unit AboutForm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, jpeg;

const
  cAlturaBitmap = 400;

type
  TShowAbout_1 = procedure;

  TprDialogo_About = class(TForm)
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
    { Private declarations }
    Timer1 : TTimer;
    Bitmap : TBitmap;
    i : Integer;
    Altura : Integer;
    Procedure MostraCreditos;
  public
    { Public declarations }
  end;

implementation
uses pr_Const, pr_Vars, pr_Application;

{$R *.DFM}

procedure TprDialogo_About.FormActivate(Sender: TObject);
begin
  MostraCreditos;
End;

Procedure TprDialogo_About.MostraCreditos;
Var R : TRect;
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
  Timer1.Interval := 100;
  Bitmap := TBitmap.Create;
  With Bitmap do Begin
    Width := PBCreditos.Width;
    With Canvas do Begin
      Brush.Color := clBlack;
      R := Rect(0,0,Width,Altura);
      FillRect(R);
      Height := cAlturaBitmap;

      Inicio := 85;
      WritePB('Arial', 18, clWhite, 'Propagar 2000 para Windows');

      Inc(Inicio,28);
      WritePB('System', 12, clSilver, Applic.Version);

      Inc(Inicio,30);
      WritePB('Arial', 14, clWhite, 'Desenvolvedores');

      Inc(Inicio,30);
      WritePB('System', 10, clSilver, 'Adriano Rochedo Conceição');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'rochedo@ufpel.tche.br');

      Inc(Inicio,22);
      WritePB('System', 10, clSilver, 'João Soares Viegas Filho');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'jviegas@conesul.com.br');

      Inc(Inicio,30);
      WritePB('Arial', 18, clWhite, 'Propagar Versão DOS');

      Inc(Inicio,35);
      WritePB('Arial', 14, clWhite, 'Desenvolvedor');

      Inc(Inicio,30);
      WritePB('System', 10, clSilver, 'Antonio Eduardo Lanna');

      Inc(Inicio,16);
      WritePB('Arial', 10, clSilver, 'lanna@if.ufrgs.br');

      Inc(Inicio,30);
      WritePB('Arial', 8, clRed, StringOfChar(' ', 65) + 'Todos os direitos reservados.');
    End;
  End;
End;

procedure TprDialogo_About.FormDeactivate(Sender: TObject);
begin
  Timer1.Free;
  Bitmap.Free;
end;

procedure TprDialogo_About.Timer1Timer(Sender : TObject);
Begin
  PBCreditos.Canvas.Draw(0,-i,Bitmap);
  Inc(i,1);
  If i > cAlturaBitmap Then i := -20;
End;

procedure TprDialogo_About.FormCreate(Sender: TObject);
begin
  If Screen.PixelsPerInch <> 96 Then
     ScaleBy(96, Screen.PixelsPerInch);
end;

procedure TprDialogo_About.btnMaisInfoClick(Sender: TObject);
//var hDLL: THandle;
begin
{
  SetCurrentDirectory(PChar(gExePath));
  hDLL := LoadLibrary('..\Comum\li_Equipe.dll');
  if hDLL <> 0 then
     begin
     @ShowAbout_1 := GetProcAddress(hDLL,'ShowAbout_1');
     if @ShowAbout_1 <> nil then ShowAbout_1;
     FreeLibrary(hDLL);
     end;
}     
end;

end.
