unit uConfig;

interface

Const
  CNomFichier = 'MyDayInPictures';
  CExtensionFichier = '.jpg'; // '.png';
  CLargeur = 500; // largeur du r�sultat
  CHauteur = 330; // haugeur du r�sultat
  CNombreModeles = 5; // nombre de pr�sentations possibles du r�sultat

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
  // TODO : v�rifier si enregistrement dans "MesImages" pour iOS+Android est op�rationnel ou bloqu�
  chemin := tpath.Combine(tpath.GetImagesPath, 'MyDayInPictures');
{$ENDIF}
  if not tdirectory.Exists(chemin) then
    tdirectory.CreateDirectory(chemin);
  Result := chemin;
end;

end.
