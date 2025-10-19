(* C2PP
  ***************************************************************************

  My day in pictures

  Copyright 2023-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://mydayinpictures.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/My-day-in-pictures

  ***************************************************************************
  File last update : 2025-10-16T10:44:40.112+02:00
  Signature : 050b180bcbd604868dd13f1344e5c1aec67e73ea
  ***************************************************************************
*)

unit uConfig;

interface

Const
  CNomFichier = 'MyDayInPictures';
  CExtensionFichier1 = '.jpg';
  CExtensionFichier2 = '.png';
  CExtensionFichierFinal = '.jpg';
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
  chemin := tpath.Combine(tpath.GetPicturesPath, 'MyDayInPictures');
{$ENDIF}
  if not tdirectory.Exists(chemin) then
    tdirectory.CreateDirectory(chemin);
  Result := chemin;
end;

end.
