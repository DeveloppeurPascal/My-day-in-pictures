unit fListeCompositions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts;

type
  TfrmListeCompositions = class(TFrame)
    VertScrollBox1: TVertScrollBox;
    grille: TGridLayout;
    btnAddCompo: TPath;
    infoChargementSuite: TAniIndicator;
    background: TRectangle;
    btnAddCompoClickZone: TLayout;
    procedure VertScrollBox1ViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure btnAddCompoClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure PhotoClic(Sender: TObject);
  public
    { Déclarations publiques }
    class procedure execute;
    procedure initialiseListe;
    procedure chargePhotosSuivantes;
    procedure ajoutePhoto(nom: string);
  end;

implementation

{$R *.fmx}

uses uSVG, uConfig, System.IOUtils, fAjoutCompo;

{ TfrmListeCompositions }

procedure TfrmListeCompositions.ajoutePhoto(nom: string);
var
  img: timage;
begin
  img := timage.Create(Self);
  try
    img.TagString := nom;
    img.Parent := grille;
    img.margins.Left := 5;
    img.margins.Top := 5;
    img.margins.Right := 5;
    img.margins.Bottom := 5;
    img.OnClick := PhotoClic;
    if (grille.height < img.position.y + img.height + img.margins.Top +
      img.margins.Bottom) then
      grille.height := img.position.y + img.height + img.margins.Top +
        img.margins.Bottom + 10;
    img.bitmap.LoadFromFile(System.IOUtils.TPath.Combine(getComposPath,
      img.TagString));
  finally
  end;
end;

procedure TfrmListeCompositions.btnAddCompoClick(Sender: TObject);
begin
  TfrmAjoutCompo.execute(ajoutePhoto);
end;

procedure TfrmListeCompositions.chargePhotosSuivantes;
var
  listePhotos: TStringDynArray;
  fichierPhoto: string;
  i: integer;
  debutNom: string;
  trouve: Boolean;
begin
  infoChargementSuite.Enabled := infoChargementSuite.Visible;
  listePhotos := tdirectory.getfiles(getComposPath);
  debutNom := System.IOUtils.TPath.Combine(getComposPath, CNomFichier);
  i := 0;
  while ((i < length(listePhotos)) and (infoChargementSuite.height -
    VertScrollBox1.ViewportPosition.y < VertScrollBox1.height +
    grille.itemheight)) do
  begin
    fichierPhoto := listePhotos[i];
    if fichierPhoto.StartsWith(debutNom) and
      (fichierPhoto.EndsWith(CExtensionFichier1) or
      fichierPhoto.EndsWith(CExtensionFichier2)) then
    begin
      trouve := false;
      if assigned(grille.Children) then
        for var c in grille.Children do
          if (c is timage) and ((c as timage).TagString = fichierPhoto) then
          begin
            trouve := true;
            break;
          end;
      if (not trouve) then
        ajoutePhoto(fichierPhoto);
    end;
    inc(i);
  end;
  if (i >= length(listePhotos)) then
    infoChargementSuite.Visible := false;
  infoChargementSuite.Enabled := false;
end;

class procedure TfrmListeCompositions.execute;
var
  frm: TfrmListeCompositions;
begin
  frm := TfrmListeCompositions.Create(application.MainForm);
  try
    frm.Parent := application.MainForm;
    frm.BringToFront;
    frm.btnAddCompo.Data.Data := svg_pluscircle;
    frm.initialiseListe;
  except
    FreeAndNil(frm);
  end;
end;

procedure TfrmListeCompositions.initialiseListe;
begin
  grille.DeleteChildren;
  infoChargementSuite.Visible := true;
  infoChargementSuite.Enabled := true;
  chargePhotosSuivantes;
end;

procedure TfrmListeCompositions.PhotoClic(Sender: TObject);
begin
  if Sender is timage then
    showmessage((Sender as timage).TagString);
end;

procedure TfrmListeCompositions.VertScrollBox1ViewportPositionChange
  (Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF;
  const ContentSizeChanged: Boolean);
begin
  infoChargementSuite.Enabled := (infoChargementSuite.Visible) and
    (infoChargementSuite.height - NewViewportPosition.y <
    VertScrollBox1.height);
end;

end.
