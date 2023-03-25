unit fListeCompositions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, Olf.FMX.AboutDialog,
  System.Actions, FMX.ActnList, FMX.StdActns;

type
  TfrmListeCompositions = class(TFrame)
    VertScrollBox1: TVertScrollBox;
    grille: TGridLayout;
    btnAddCompoImg: TPath;
    infoChargementSuite: TAniIndicator;
    background: TRectangle;
    btnAddCompo: TLayout;
    ToolBar1: TToolBar;
    btnAbout: TButton;
    OlfAboutDialog1: TOlfAboutDialog;
    procedure VertScrollBox1ViewportPositionChange(Sender: TObject;
      const OldViewportPosition, NewViewportPosition: TPointF;
      const ContentSizeChanged: Boolean);
    procedure btnAddCompoClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
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

uses uSVG, uConfig, System.IOUtils, fAjoutCompo, u_urlOpen, FMX.MediaLibrary;

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

procedure TfrmListeCompositions.btnAboutClick(Sender: TObject);
begin
  OlfAboutDialog1.execute;
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
    frm.btnAddCompoImg.Data.Data := svg_pluscircle;
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

procedure TfrmListeCompositions.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

procedure TfrmListeCompositions.PhotoClic(Sender: TObject);
var
  img: timage;
  ShareSheetSvc: IFMXShareSheetActionsService;
begin
  if Sender is timage then
    img := Sender as timage
  else
    img := nil;
  if assigned(img) then
    if SupportsPlatformService(IFMXShareSheetActionsService, ShareSheetSvc) then
      ShareSheetSvc.share(nil, '#MyDayInPictures', img.bitmap)
    else
      url_Open_In_Browser(img.TagString);
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
