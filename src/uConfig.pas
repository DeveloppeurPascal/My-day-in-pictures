unit uConfig;

interface

Const
  CNomFichier = 'MyDayInPictures';
  CExtensionFichier = '.png';
  CLargeur = 500; // largeur du résultat
  CHauteur = 330; // haugteur du résultat
  CNombreModeles = 5; // nombre de présentations possibles du résultat

function getComposPath: string;

implementation

uses System.IOUtils;

function getComposPath: string;
var
  chemin: string;
begin
  chemin := tpath.Combine(tpath.GetDocumentsPath, 'MyDayInPictures');
  if not tdirectory.Exists(chemin) then
    tdirectory.CreateDirectory(chemin);
  Result := chemin;
end;

end.
