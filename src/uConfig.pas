unit uConfig;

interface

Const
  CNomFichier = 'MyDayInPictures';
  CExtensionFichier = '.jpg'; // '.png';
  CLargeur = 500; // largeur du résultat
  CHauteur = 330; // haugeur du résultat
  CNombreModeles = 5; // nombre de présentations possibles du résultat

function getComposPath: string;

implementation

uses System.IOUtils;

function getComposPath: string;
var
  chemin: string;
begin
{$IFDEF DEBUG}
  chemin := tpath.Combine(tpath.GetDocumentsPath, 'MyDayInPictures-debug');
{$ELSE}
  // TODO : vérifier si enregistrement dans "MesImages" pour iOS+Android est opérationnel ou bloqué
  chemin := tpath.Combine(tpath.GetImagesPath, 'MyDayInPictures');
{$ENDIF}
  if not tdirectory.Exists(chemin) then
    tdirectory.CreateDirectory(chemin);
  Result := chemin;
end;

end.
