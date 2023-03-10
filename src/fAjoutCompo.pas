unit fAjoutCompo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, System.Actions,
  FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions, FMX.ExtCtrls,
  System.Generics.Collections;

type
  TfrmAjoutCompo = class(TFrame)
    background: TRectangle;
    btnBackImg: TPath;
    Layout1: TLayout;
    btnBack: TLayout;
    btnAjoutPhotoImg: TPath;
    btnAjoutPhoto: TLayout;
    ActionList1: TActionList;
    TakePhotoFromLibraryAction1: TTakePhotoFromLibraryAction;
    OpenDialog1: TOpenDialog;
    ImageFinale: TImageViewer;
    btnEnregistrerImg: TPath;
    btnEnregistrer: TLayout;
    btnRetraitPhotoImg: TPath;
    btnRetraitPhoto: TLayout;
    procedure btnBackClick(Sender: TObject);
    procedure btnAjoutPhotoClick(Sender: TObject);
    procedure TakePhotoFromLibraryAction1DidFinishTaking(Image: TBitmap);
    procedure btnEnregistrerClick(Sender: TObject);
    procedure btnRetraitPhotoClick(Sender: TObject);
  private
    { Déclarations privées }
    ListeImages: TObjectList<TBitmap>;
    FAjoutPhotoCallback: TProc<string>;
    procedure ajouteImage(ABitmap: TBitmap);
    procedure rafraichiImageFinale;
  public
    { Déclarations publiques }
    class procedure execute(AjoutPhotoCallback: TProc<string>);
    destructor Destroy; override;
  end;

implementation

{$R *.fmx}

uses uSVG, System.IOUtils, System.Permissions, FMX.DialogService, uConfig,
  System.Math, UUtils;

{ TfrmAjoutCompo }

procedure TfrmAjoutCompo.ajouteImage(ABitmap: TBitmap);
var
  max: integer;
  ratiow, ratioh: single;
begin
  if assigned(ABitmap) and (ABitmap.Width > 0) and (ABitmap.Height > 0) then
  begin
    if clargeur > chauteur then
      max := clargeur
    else
      max := chauteur;
    ratiow := ABitmap.Width / max;
    ratioh := ABitmap.Height / max;
    if (ratiow > ratioh) then
      ABitmap.Resize(ceil(ABitmap.Width / ratioh),
        ceil(ABitmap.Height / ratioh))
    else
      ABitmap.Resize(ceil(ABitmap.Width / ratiow),
        ceil(ABitmap.Height / ratiow));
    ListeImages.Add(ABitmap);
    rafraichiImageFinale;
  end;
end;

procedure TfrmAjoutCompo.btnAjoutPhotoClick(Sender: TObject);
{$IF Defined(IOS) or Defined(Android)}
const
  PermissionReadExternalStorage = 'android.permission.READ_EXTERNAL_STORAGE';
{$ELSE}
var
  nomFichier: string;
{$ENDIF}
begin
{$IF Defined(IOS) or Defined(Android)}
  PermissionsService.RequestPermissions([PermissionReadExternalStorage],
    procedure(const APermissions: TArray<string>;
      const AGrantResults: TArray<TPermissionStatus>)
    begin
      if (Length(AGrantResults) = 1) and
        (AGrantResults[0] = TPermissionStatus.Granted) then
        TakePhotoFromLibraryAction1.execute
      else
        tdialogservice.ShowMessage
          ('Pour utiliser les photos de votre librairie nous devons y avoir accès.');
    end);
{$ELSE}
  if OpenDialog1.execute then
  begin
    nomFichier := trim(OpenDialog1.FileName);
    if TFile.Exists(nomFichier) then
      ajouteImage(TBitmap.CreateFromFile(nomFichier));
  end;
{$ENDIF}
end;

procedure TfrmAjoutCompo.btnBackClick(Sender: TObject);
begin
  DisposeOf;
end;

procedure TfrmAjoutCompo.btnEnregistrerClick(Sender: TObject);
var
  nomFichier: string;
  dateheure: string;
begin
  if (ListeImages.Count > 0) then
  begin
    DateTimeToString(dateheure, 'yyyymmddhhnnss', now);
    nomFichier := System.IOUtils.TPath.Combine(getComposPath,
      CNomFichier + '-' + dateheure + CExtensionFichierFinal);
    ImageFinale.Bitmap.SaveToFile(nomFichier);
    if assigned(FAjoutPhotoCallback) then
      FAjoutPhotoCallback(nomFichier);
    DisposeOf;
  end;
end;

procedure TfrmAjoutCompo.btnRetraitPhotoClick(Sender: TObject);
begin
  if (ListeImages.Count > 0) then
  begin
    ListeImages.Delete(0);
    rafraichiImageFinale;
  end;
end;

destructor TfrmAjoutCompo.Destroy;
begin
  if assigned(ListeImages) then
    FreeAndNil(ListeImages);
  inherited;
end;

class procedure TfrmAjoutCompo.execute(AjoutPhotoCallback: TProc<string>);
var
  frm: TfrmAjoutCompo;
begin
  frm := TfrmAjoutCompo.Create(Application.MainForm);
  try
    frm.ListeImages := TObjectList<TBitmap>.Create;
    frm.parent := Application.MainForm;
    frm.BringToFront;
    frm.btnBackImg.Data.Data := SVG_ArrowLeft;
    frm.btnAjoutPhotoImg.Data.Data := SVG_PlusCircleOutline;
    frm.btnAjoutPhoto.enabled := true;
    frm.btnRetraitPhotoImg.Data.Data := SVG_MinusCircleOutline;
    frm.btnRetraitPhoto.enabled := false;
    frm.btnEnregistrerImg.Data.Data := SVG_Save;
    frm.btnEnregistrer.enabled := false;
    frm.FAjoutPhotoCallback := AjoutPhotoCallback;
  except
    FreeAndNil(frm);
  end;
end;

procedure TfrmAjoutCompo.rafraichiImageFinale;
var
  // pour la manipulation des images
  btm1, btm2: TBitmap;
  // ratios de l'image par rapport de départ à l'image finale
  ratiow, ratioh: single;
  // compteurs
  i, j: integer;
  // taille finale de chaque image dans la composition
  w, h: integer;
  // pour jouer sur les formes affichées
  ellipse: TEllipse;
  bmpscale: single;
begin
  btnAjoutPhoto.enabled := ListeImages.Count < CNombreModeles;
  btnRetraitPhoto.enabled := ListeImages.Count > 0;
  btnEnregistrer.enabled := ListeImages.Count > 0;
  if (ListeImages.Count > 0) then
  begin
    ImageFinale.BeginUpdate;
    try
      ImageFinale.Bitmap.SetSize(clargeur, chauteur); // TODO : BitmapScale ?
{$IFDEF DEBUG}
      ImageFinale.Bitmap.Clear(talphacolors.red);
{$ELSE}
      ImageFinale.Bitmap.Clear(talphacolors.White);
{$ENDIF}
      case ListeImages.Count of
        1: // une image => redimensionnement pour en prendre une portion
          begin
            w := clargeur; // 1 colonne
            h := chauteur; // 1 ligne
            btm1 := TBitmap.Create(ListeImages[0].Width, ListeImages[0].Height);
            try
              btm1.CopyFromBitmap(ListeImages[0]);
              ratiow := btm1.Width / w;
              ratioh := btm1.Height / h;
              if (ratiow > ratioh) then
                btm1.Resize(ceil(btm1.Width / ratioh),
                  ceil(btm1.Height / ratioh))
              else
                btm1.Resize(ceil(btm1.Width / ratiow),
                  ceil(btm1.Height / ratiow));
              ImageFinale.Bitmap.CopyFromBitmap(btm1,
                trect.Create((btm1.Width - w) div 2, (btm1.Height - h) div 2,
                ((btm1.Width - w) div 2) + w, ((btm1.Height - h) div 2) +
                h), 0, 0);
            finally
              FreeAndNil(btm1);
            end;
          end;
        2: // deux images => affichage d'une moitié de chaque image en bandes horizontales
          begin
            w := clargeur; // 1 colonne
            h := chauteur div 2; // 2 lignes
            i := 0;
            for btm2 in ListeImages do
            begin
              btm1 := TBitmap.Create(btm2.Width, btm2.Height);
              try
                btm1.CopyFromBitmap(btm2);
                ratiow := btm1.Width / w;
                ratioh := btm1.Height / h;
                if (ratiow > ratioh) then
                  btm1.Resize(ceil(btm1.Width / ratioh),
                    ceil(btm1.Height / ratioh))
                else
                  btm1.Resize(ceil(btm1.Width / ratiow),
                    ceil(btm1.Height / ratiow));
                ImageFinale.Bitmap.CopyFromBitmap(btm1,
                  trect.Create((btm1.Width - w) div 2, (btm1.Height - h) div 2,
                  ((btm1.Width - w) div 2) + w, ((btm1.Height - h) div 2) + h),
                  0, h * i);
              finally
                FreeAndNil(btm1);
              end;
              inc(i);
            end;
          end;
        3: // trois images => affichage d'un tiers de chaque image en bandes verticales
          begin
            w := clargeur div 3; // 3 colonnes
            h := chauteur; // 1 ligne
            i := 0;
            for btm2 in ListeImages do
            begin
              btm1 := TBitmap.Create(btm2.Width, btm2.Height);
              try
                btm1.CopyFromBitmap(btm2);
                ratiow := btm1.Width / w;
                ratioh := btm1.Height / h;
                if (ratiow > ratioh) then
                  btm1.Resize(ceil(btm1.Width / ratioh),
                    ceil(btm1.Height / ratioh))
                else
                  btm1.Resize(ceil(btm1.Width / ratiow),
                    ceil(btm1.Height / ratiow));
                ImageFinale.Bitmap.CopyFromBitmap(btm1,
                  trect.Create((btm1.Width - w) div 2, (btm1.Height - h) div 2,
                  ((btm1.Width - w) div 2) + w, ((btm1.Height - h) div 2) + h),
                  w * i, 0);
              finally
                FreeAndNil(btm1);
              end;
              inc(i);
            end;
          end;
        4: // quatre images => affichage des photos en mosaique
          begin
            w := clargeur div 2; // 2 colonnes
            h := chauteur div 2; // 2 lignes
            i := 0;
            j := 0;
            for btm2 in ListeImages do
            begin
              btm1 := TBitmap.Create(btm2.Width, btm2.Height);
              try
                btm1.CopyFromBitmap(btm2);
                ratiow := btm1.Width / w;
                ratioh := btm1.Height / h;
                if (ratiow > ratioh) then
                  btm1.Resize(ceil(btm1.Width / ratioh),
                    ceil(btm1.Height / ratioh))
                else
                  btm1.Resize(ceil(btm1.Width / ratiow),
                    ceil(btm1.Height / ratiow));
                ImageFinale.Bitmap.CopyFromBitmap(btm1,
                  trect.Create((btm1.Width - w) div 2, (btm1.Height - h) div 2,
                  ((btm1.Width - w) div 2) + w, ((btm1.Height - h) div 2) + h),
                  w * i, h * j);
              finally
                FreeAndNil(btm1);
              end;
              inc(i);
              if (i >= 2) then
              begin
                i := 0;
                inc(j);
              end;
            end;
          end;
        5: // cinq images => affichage des photos en mosaique pour les 4 premières et la dernière par dessus, centrée en elipse
          begin
            w := clargeur div 2; // 2 colonnes
            h := chauteur div 2; // 2 lignes
            i := 0; // Colonne
            j := 0; // Ligne
            for btm2 in ListeImages do
            begin
              btm1 := TBitmap.Create(btm2.Width, btm2.Height);
              try
                btm1.CopyFromBitmap(btm2);
                ratiow := btm1.Width / w;
                ratioh := btm1.Height / h;
                if (ratiow > ratioh) then
                  btm1.Resize(ceil(btm1.Width / ratioh),
                    ceil(btm1.Height / ratioh))
                else
                  btm1.Resize(ceil(btm1.Width / ratiow),
                    ceil(btm1.Height / ratiow));
                if (j > 1) then
                // deuxième ligne, donc théoriquement 2 x 2 images +1
                begin
                  ellipse := TEllipse.Create(Self);
                  try
                    bmpscale := scene.GetSceneScale;
                    ellipse.parent := Self;
                    ellipse.Width := w / bmpscale;
                    ellipse.Height := h / bmpscale;
                    ellipse.Fill.Kind := tbrushkind.Bitmap;
                    ellipse.Fill.Bitmap.WrapMode := twrapmode.TileOriginal;
                    ellipse.Fill.Bitmap.Bitmap.Assign(btm1);
                    ellipse.Stroke.Kind := tbrushkind.None;
                    ImageFinale.Bitmap.Canvas.BeginScene;
                    try
                      ellipse.PaintTo(ImageFinale.Bitmap.Canvas,
                        trectf.Create((w / 2) / bmpscale, (h / 2) / bmpscale,
                        ((w / 2) + w) / bmpscale, ((h / 2) + h) / bmpscale));
                    finally
                      ImageFinale.Bitmap.Canvas.EndScene;
                    end;
                  finally
                    FreeAndNil(ellipse);
                  end;
                end
                else
                  ImageFinale.Bitmap.CopyFromBitmap(btm1,
                    trect.Create((btm1.Width - w) div 2,
                    (btm1.Height - h) div 2, ((btm1.Width - w) div 2) + w,
                    ((btm1.Height - h) div 2) + h), w * i, h * j);
              finally
                FreeAndNil(btm1);
              end;
              inc(i);
              if (i >= 2) then // 2 images sur la ligne, on passe à la suivante
              begin
                i := 0;
                inc(j);
              end;
            end;
          end;
      end;
    finally
      ImageFinale.EndUpdate;
    end;
    ImageFinale.BestFit;
  end
  else
{$IFDEF DEBUG}
    ImageFinale.Bitmap.Clear(talphacolors.red);
{$ELSE}
    ImageFinale.Bitmap.Clear(talphacolors.White);
{$ENDIF}
end;

procedure TfrmAjoutCompo.TakePhotoFromLibraryAction1DidFinishTaking
  (Image: TBitmap);
begin
  ajouteImage(Image);
end;

end.
