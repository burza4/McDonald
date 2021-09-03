unit Unit6;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Objects, FMX.ListBox, FMX.Edit,
  Data.DB, IBX.IBCustomDataSet, IBX.IBTable, IBX.IBDatabase, IBX.IBQuery,
  IBX.IBUpdateSQL, FMX.Menus, System.Rtti, FMX.Grid.Style, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.Grid, FMX.ScrollBox,
  FMX.Grid, Data.Bind.DBScope, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, Datasnap.DBClient, FMX.ListView, Datasnap.Provider;

type
  TForm6 = class(TForm)
    StyleBook1: TStyleBook;
    ToolbarHolder: TLayout;
    ToolbarPopup: TPopup;
    ToolbarPopupAnimation: TFloatAnimation;
    ToolBar1: TToolBar;
    ToolbarApplyButton: TButton;
    ToolbarCloseButton: TButton;
    ToolbarAddButton: TButton;
    BtnAddToCart: TButton;
    Panel1: TPanel;
    IconLogo: TImage;
    IconCart: TImage;
    IconHambMenu: TImage;
    IconSearch: TImage;
    IconCartDot: TImage;
    IconLeftArrow: TImage;
    IconMenu: TImage;
    LabelUser: TLabel;
    LabelModel: TLabel;
    EditSearch: TEdit;
    Label3: TLabel;
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBUpdateSQL1: TIBUpdateSQL;
    qryMiniCart: TIBQuery;
    IconX: TImage;
    Rectangle1: TRectangle;
    AnimShowEdit: TFloatAnimation;
    AnimHideEdit: TFloatAnimation;
    PopupHambMenu: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    BtnDelete: TButton;
    qryMiniCartELEMENT_KOD: TIBStringField;
    qryMiniCartELEMENT_NAZWA: TIBStringField;
    qryMiniCartJEDNOSTKI_KOD: TIBStringField;
    qryMiniCartILOSC_MAX: TFloatField;
    CheckBoxSelectAll: TCheckBox;
    ListView1: TListView;
    ClientDataSet1: TClientDataSet;
    BtnSubmitOrder: TButton;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    PopupDelete: TPopupMenu;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    DataSource1: TDataSource;
    BindingsList1: TBindingsList;
    BindSourceDB1: TBindSourceDB;
    LinkListControlToField1: TLinkListControlToField;
    procedure ToolbarCloseButtonClick(Sender: TObject);
    procedure FormGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure IconSearchClick(Sender: TObject);
    procedure IconXClick(Sender: TObject);
    procedure EditSearchKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure IconHambMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxSelectAllChange(Sender: TObject);
    procedure BtnSubmitOrderClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
  private
    FGestureOrigin: TPointF;
    FGestureInProgress: Boolean;
    { Private declarations }
    procedure ShowToolbar(AShow: Boolean);
  public
    { Public declarations }
  end;

var
  Form6: TForm6;
  isEditVisible: Boolean = False;
  mousePosition: TScreen;

implementation

{$R *.fmx}

procedure TForm6.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then
    ShowToolbar(not ToolbarPopup.IsOpen);
end;

procedure TForm6.IconHambMenuClick(Sender: TObject);
begin
  mousePosition := TScreen.Create(Form6);
  PopupHambMenu.Popup(mousePosition.MousePos.X, mousePosition.MousePos.Y);
end;

procedure TForm6.IconSearchClick(Sender: TObject);
begin
  if isEditVisible then
  begin
    AnimHideEdit.Enabled := True;
    AnimShowEdit.Enabled := False;
    isEditVisible := False;
  end
  else
  begin
    AnimHideEdit.Enabled := False;
    AnimShowEdit.Enabled := True;
    isEditVisible := True;
  end;
end;


procedure TForm6.IconXClick(Sender: TObject);
begin
  EditSearch.Text := '';
  IconX.Visible := False;
end;

procedure TForm6.MenuItem4Click(Sender: TObject);
begin
  //usuwa wszystkie elementy z koszyka
end;

procedure TForm6.MenuItem5Click(Sender: TObject);
begin
    //usuwa zaznaczone elementy z koszyka
end;

procedure TForm6.ToolbarCloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm6.BtnDeleteClick(Sender: TObject);
begin
  mousePosition := TScreen.Create(Form6);
  PopupDelete.Popup(mousePosition.MousePos.X, mousePosition.MousePos.Y);
end;

procedure TForm6.BtnSubmitOrderClick(Sender: TObject);
var strList: TStringList;
var i: Integer;
begin
 if ListView1.Items.CheckedCount = 0 then
 begin
   ShowMessage('Nie zaznaczono ¿adnych elementów.');
 end;
 strList := TStringList.Create;
 try
   for i := 0 to ListView1.ItemCount-1 do
     begin
       if ListView1.Items[i].Checked then
         strList.Add(ListView1.Items[i].Text);
     end;
     ShowMessage(strList.CommaText);
 finally
   strList.Free;
 end;

end;

procedure TForm6.CheckBoxSelectAllChange(Sender: TObject);
begin
  if CheckBoxSelectAll.IsChecked then
  begin
    CheckBoxSelectAll.Text := 'Zaznacz wszystkie';
    ListView1.Items.CheckAll(False);
  end
  else
  begin
    CheckBoxSelectAll.Text := 'Odznacz wszystkie';
    ListView1.Items.CheckAll(True);
  end;
end;

procedure TForm6.EditSearchKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if EditSearch.Text = '' then
    begin
      IconX.Visible := False;
    end
  else
    begin
      IconX.Visible := True;
    end;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  ListView1.Items.CheckAll(True);
  qryMiniCart.Open;

end;

procedure TForm6.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  DX, DY : Single;
begin
  if EventInfo.GestureID = igiPan then
  begin
    if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags)
      and ((Sender = ToolbarPopup)
        or (EventInfo.Location.Y > (ClientHeight - 70))) then
    begin
      FGestureOrigin := EventInfo.Location;
      FGestureInProgress := True;
    end;

    if FGestureInProgress and (TInteractiveGestureFlag.gfEnd in EventInfo.Flags) then
    begin
      FGestureInProgress := False;
      DX := EventInfo.Location.X - FGestureOrigin.X;
      DY := EventInfo.Location.Y - FGestureOrigin.Y;
      if (Abs(DY) > Abs(DX)) then
        ShowToolbar(DY < 0);
    end;
  end
end;

procedure TForm6.ShowToolbar(AShow: Boolean);
begin
  ToolbarPopup.Width := ClientWidth;
  ToolbarPopup.PlacementRectangle.Rect := TRectF.Create(0, ClientHeight-ToolbarPopup.Height, ClientWidth-1, ClientHeight-1);
  ToolbarPopupAnimation.StartValue := ToolbarPopup.Height;
  ToolbarPopupAnimation.StopValue := 0;

  ToolbarPopup.IsOpen := AShow;
end;

end.
