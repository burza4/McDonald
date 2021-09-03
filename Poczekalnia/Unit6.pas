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
    DataSource1: TDataSource;
    qryMiniCart: TIBQuery;
    IconX: TImage;
    Rectangle1: TRectangle;
    AnimShowEdit: TFloatAnimation;
    AnimHideEdit: TFloatAnimation;
    PopupHambMenu: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    BtnMagazyny: TButton;
    BtnWydzialy: TButton;
    PanelMagazyny: TPanel;
    qryMiniCartELEMENT_KOD: TIBStringField;
    qryMiniCartELEMENT_NAZWA: TIBStringField;
    qryMiniCartJEDNOSTKI_KOD: TIBStringField;
    qryMiniCartILOSC_JEDNOSTKOWA: TFloatField;
    qryMiniCartILOSC_MAX: TFloatField;
    qryMiniCartWYDZIALY_KOD: TIBStringField;
    qryMiniCartMAGAZYNY_KOD: TIBStringField;
    PanelWydzialy: TPanel;
    CheckBoxSelectAllW: TCheckBox;
    CheckBoxSelectAll: TCheckBox;
    CheckBoxSelectAllM: TCheckBox;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    qryWydzialy: TIBQuery;
    qryMagazyny: TIBQuery;
    qryWydzialyWYDZIALY_KOD: TIBStringField;
    qryMagazynyMAGAZYNY_KOD: TIBStringField;
    ListView1: TListView;
    ClientDataSet1: TClientDataSet;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    BindSourceDB1: TBindSourceDB;
    ClientDataSetMag: TClientDataSet;
    ClientDataSetWydz: TClientDataSet;
    ListViewWydz: TListView;
    ListViewMag: TListView;
    BindSourceDB2: TBindSourceDB;
    LinkListControlToField2: TLinkListControlToField;
    BindSourceDB3: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    BtnSubmitOrder: TButton;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    DataSetProvider1: TDataSetProvider;
    qry: TIBQuery;
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
    procedure CheckBoxSelectAllWChange(Sender: TObject);
    procedure CheckBoxSelectAllMChange(Sender: TObject);
    procedure BtnMagazynyClick(Sender: TObject);
    procedure BtnWydzialyClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure ListViewWydzItemClick(const Sender: TObject;
      const AItem: TListViewItem);
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
  sqlStr: String;

implementation

{$R *.fmx}
function GenerateSQLWithFilters(ListViewWydz, ListViewMag: TListView): String;
  var sqlStr: String;
  var i, flag0: Integer;
begin
  if (ListViewWydz.Items.CheckedCount = ListViewWydz.Items.Count) and
  (ListViewMag.Items.CheckedCount = ListViewMag.Items.Count) then
  begin
    Result := 'select * from MCD_GET_ELEMENTY_WG(299, 1)';
    ShowMessage(Result);
    Exit;
  end;
  sqlStr := 'select * from MCD_GET_ELEMENTY_WG(299, 1) where ';
  if (ListViewWydz.Items.CheckedCount = 0) or (ListViewMag.Items.CheckedCount = 0) then
    begin
     Result := sqlStr + 'WYDZIALY_KOD = ''-1''';
     ShowMessage(Result);
     Exit;
    end;
    flag0 := 0;
  if (ListViewWydz.Items.CheckedCount <> ListViewWydz.Items.Count) then
  begin
    sqlStr := sqlStr + 'WYDZIALY_KOD IN (';
    for i := 0 to ListViewWydz.ItemCount-1 do
      begin
        if ListViewWydz.Items[i].Checked then
          begin
          sqlStr := sqlStr+ '''' + ListViewWydz.Items[i].Text + ''',';
          flag0 := 1;
      end;
    end;
    delete(sqlStr,length(sqlStr),1);
    sqlStr := sqlStr +') ';
  end;
  if (ListViewMag.Items.CheckedCount <> ListViewMag.Items.Count) then
  begin
  if flag0 = 1 then sqlStr := sqlStr + 'AND ';
    sqlStr := sqlStr + 'MAGAZYNY_KOD IN (';
    for i := 0 to ListViewMag.ItemCount-1 do
      begin
        if ListViewMag.Items[i].Checked then
          begin
          sqlStr := sqlStr+ '''' + ListViewMag.Items[i].Text + ''',';
      end;
    end;
    delete(sqlStr,length(sqlStr),1);
    sqlStr := sqlStr +') ';
  end;
  Result := sqlStr;
  ShowMessage(Result);
end;
procedure TForm6.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then
    ShowToolbar(not ToolbarPopup.IsOpen);
end;
procedure RefreshListView(ListView: TListView; sqlStr: String;
  query: TIBQuery; ClientDS: TClientDataSet; DataSP: TDataSetProvider);
begin
  query.Close;
  query.SQL.Text := sqlStr;
  query.Open;
  ClientDS.Data := DataSP.Data;
end;
procedure TForm6.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  PanelWydzialy.Visible := False;
  PanelMagazyny.Visible := False;
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

procedure TForm6.ListViewWydzItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  sqlStr := GenerateSQLWithFilters(ListViewWydz, ListViewMag);
  RefreshListView(ListView1, sqlStr, qryMiniCart, ClientDataSet1, DataSetProvider1);
end;

procedure TForm6.ToolbarCloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm6.BtnMagazynyClick(Sender: TObject);
begin
  PanelMagazyny.Visible := not PanelMagazyny.Visible;
end;

procedure TForm6.BtnWydzialyClick(Sender: TObject);
begin
  PanelWydzialy.Visible := not PanelWydzialy.Visible;
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

procedure TForm6.CheckBoxSelectAllMChange(Sender: TObject);
begin
  if CheckBoxSelectAllM.IsChecked then
  begin
    CheckBoxSelectAllM.Text := 'Zaznacz wszystkie';
    ListViewMag.Items.CheckAll(False);
  end
  else
  begin
    CheckBoxSelectAllM.Text := 'Odznacz wszystkie';
    ListViewMag.Items.CheckAll(True);
  end;
  sqlStr := GenerateSQLWithFilters(ListViewWydz, ListViewMag);
  RefreshListView(ListView1, sqlStr, qryMiniCart, ClientDataSet1, DataSetProvider1);
end;

procedure TForm6.CheckBoxSelectAllWChange(Sender: TObject);
begin
  if CheckBoxSelectAllW.IsChecked then
  begin
    CheckBoxSelectAllW.Text := 'Zaznacz wszystkie';
    ListViewWydz.Items.CheckAll(False);
  end
  else
  begin
    CheckBoxSelectAllW.Text := 'Odznacz wszystkie';
    ListViewWydz.Items.CheckAll(True);
  end;
  sqlStr := GenerateSQLWithFilters(ListViewWydz, ListViewMag);
  RefreshListView(ListView1, sqlStr, qryMiniCart, ClientDataSet1, DataSetProvider1);
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
  qryMiniCart.SQL.Text := 'select * from MCD_GET_ELEMENTY_WG(:user, :type) where WYROB_ID = :w_id1 OR WYROB_ID = :w_id2';
  qryMiniCart.ParamByName('user').Value := 299;
  qryMiniCart.ParamByName('type').Value := 1;
  qryMiniCart.ParamByName('w_id1').Value := 13525;
  qryMiniCart.ParamByName('w_id2').Value := 15150;
  qryMiniCart.Open;
  ClientDataSet1.Data := DataSetProvider1.Data;
  ListView1.Items.CheckAll(True);
  ListViewMag.Items.CheckAll(True);
  ListViewWydz.Items.CheckAll(True);
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
