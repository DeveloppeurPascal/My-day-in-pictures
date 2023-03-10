program MyDayInPictures;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uSVG in 'uSVG.pas',
  fListeCompositions in 'fListeCompositions.pas' {frmListeCompositions: TFrame},
  uConfig in 'uConfig.pas',
  fAjoutCompo in 'fAjoutCompo.pas' {frmAjoutCompo: TFrame},
  UUtils in 'UUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
