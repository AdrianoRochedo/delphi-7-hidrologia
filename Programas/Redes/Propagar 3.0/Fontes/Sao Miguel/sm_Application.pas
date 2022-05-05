unit sm_Application;

{
  A instancia desta aplicacao esta no ascendente pr_Application e eh iniciada
  no projeto.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Application_Class, pr_Application, ProjectManager;

type
  TsmApplication = class(TprApplication)
  private
    FPM: TProjectManager;
  protected
    procedure BeforeRun(); override;  
  public
    constructor Create(const Title, Version, PersonalReg: string);
    destructor Destroy(); override;
  end;

  function Applic(): TsmApplication;

implementation

{$R *.dfm}

function Applic(): TsmApplication;
begin
  result := TsmApplication( TSystem.getAppInstance() );
end;

{ TsmApplication }

procedure TsmApplication.BeforeRun();
begin
  inherited BeforeRun();

  // Le o arquivo de teste
  FPM.LoadFromFile(self.AppDir + 'Cenarios\Alagoas\Bacias.smf', false);

  // Le a imagem que sera mostrada no painel a direita
  FPM.LoadImage(self.AppDir + 'Cenarios\Alagoas\SaoMiguel-Jequia.bmp');

  // Mostra o Gerenciador
  FPM.ShowManager();
end;

constructor TsmApplication.Create(const Title, Version, PersonalReg: string);
var p: TProject;
begin
  inherited Create(Title, Version, PersonalReg);

  // Cria o gerenciador
  FPM := TProjectManager.Create();
end;

destructor TsmApplication.Destroy;
begin
  FPM.Free();
  inherited;
end;

end.
