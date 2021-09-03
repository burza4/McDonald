unit Unit9;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, System.Rtti,
  FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery,
  IBX.IBDatabase, FMX.Grid, FMX.ScrollBox, FMX.Menus, FMX.Edit, FMX.Ani,
  FMX.Layouts;

type
  Tpoczekalnia = class(TCustomGrid);
  TForm9 = class(TForm)
    StyleBook1: TStyleBook;
    panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    name: TLabel;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Edit1: TEdit;
    Rectangle1: TRectangle;
    searchAnim: TFloatAnimation;
    searchAnim2: TFloatAnimation;
    clr: TImage;
    koszykCount: TLabel;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    GridBindSourceDB1: TGrid;
    koszyk: TPanel;
    pokaz: TCornerButton;
    zloz: TCornerButton;
    dbMCD: TIBDatabase;
    transMCD: TIBTransaction;
    poczekalnia: TStringGrid;
    Element: TStringColumn;
    Ilosc: TStringColumn;
    X: TStringColumn;
    qry: TIBQuery;
    qryARTYKUL_ID: TIntegerField;
    qryARTYKUL_KOD: TIBStringField;
    qryARTYKUL_OPIS: TIBStringField;
    qryREALIZACJA: TIBStringField;
    qryILOSC_MAX: TFloatField;
    qryWGR_KOD: TIBStringField;
    qryATTACHMENT: TSmallintField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Label2: TLabel;
    Label3: TLabel;
    tb1: TTrackBar;
    Image9: TImage;
    Image10: TImage;
    Label4: TLabel;
    CornerButton1: TCornerButton;
    CornerButton2: TCornerButton;
    StyleBook2: TStyleBook;
    panIlosc: TPanel;
    CornerButton3: TCornerButton;
    CornerButton4: TCornerButton;
    procedure Image1Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure pokazClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure clrClick(Sender: TObject);
    procedure zlozClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure GridBindSourceDB1CellClick(const Column: TColumn;
      const Row: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure tb1Change(Sender: TObject);
    procedure CornerButton2Click(Sender: TObject);
    procedure CornerButton1Click(Sender: TObject);
    procedure poczekalniaCellClick(const Column: TColumn; const Row: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    dodaj:boolean;
    poczCount,z:Integer;

  end;

var
  Form9: TForm9;
  szt,i:Integer;
  txt:String;
  sw,kosz,dysp:boolean;
  x1,x2:Integer;
  mouse:TScreen;

implementation

{$R *.fmx}

uses Unit8, Unit2, Unit5, Unit6, Unit10;


procedure TForm9.Image10Click(Sender: TObject);
begin
  if tb1.value<>0 then
  begin
    tb1.value:=tb1.value-1;
    v:=tb1.Value.ToString.ToInteger;
    Label4.Text:= 'Iloœæ: ' + tb1.Value.ToString + '/' + m.ToString;
  end;
end;

procedure TForm9.Image1Click(Sender: TObject);
begin
  ModalResult:=mrOk;
end;
procedure TForm9.Image3Click(Sender: TObject);
begin
 mouse := TScreen.Create(Form9);
  PopupMenu1.Popup(mouse.MousePos.X, mouse.MousePos.Y);
end;


procedure TForm9.Image4Click(Sender: TObject);
begin

  if kosz then
  begin
    if koszyk.IsVisible then
    begin
      koszyk.Visible:=false;
    end
    else
    begin
      koszyk.Visible:=true;
    end;
  end
  else
  begin
    koszyk.Visible:=false;
  end;

end;

procedure TForm9.Image6Click(Sender: TObject);
begin
  TForm8.Create(Self).ShowModal;
end;

procedure TForm9.Image8Click(Sender: TObject);
begin
  if sw then
    begin
      searchAnim.Enabled:=false;
      searchAnim2.Enabled:=true;
      sw:=false
    end
  else
    begin
      searchAnim2.Enabled:=false;
      searchAnim.enabled:=true;
      sw:=true;
    end;
end;

procedure TForm9.Image9Click(Sender: TObject);
begin
  if tb1.value<>m then
  begin
    tb1.value:=tb1.value+1;
    v:=tb1.Value.ToString.ToInteger;
    Label4.Text:= 'Iloœæ: ' + tb1.Value.ToString + '/' + m.ToString;
  end;
end;

procedure TForm9.poczekalniaCellClick(const Column: TColumn;
  const Row: Integer);
begin
  if Column.Index=2 then
  begin
    poczekalnia.CellRect(0,Row);
  end;
end;

procedure TForm9.pokazClick(Sender: TObject);
begin
showMessage('Koszyk');
end;


procedure TForm9.tb1Change(Sender: TObject);
begin
  Label4.Text:= 'Iloœæ: ' + tb1.Value.ToString + '/' + m.ToString;
  v:=tb1.Value.ToString.ToInteger;
end;

procedure TForm9.Button1Click(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
  if Form2.sw then
  begin
    poczekalnia.RowCount:=poczekalnia.rowcount+1;
    poczekalnia.Cells[2,poczekalnia.RowCount-1]:='x'
  end;

end;

procedure TForm9.clrClick(Sender: TObject);
begin
  edit1.text:='';
  clr.Visible:=False;
end;


procedure TForm9.CornerButton1Click(Sender: TObject);
begin
  panIlosc.Visible:=false;
end;

procedure TForm9.CornerButton2Click(Sender: TObject);
begin
  begin
    poczekalnia.RowCount:=poczekalnia.rowcount+1;
    poczekalnia.Cells[0,poczekalnia.RowCount-1]:=qryRealizacja.Value;
    poczekalnia.Cells[1,poczekalnia.RowCount-1]:=v.ToString;
    poczekalnia.Cells[2,poczekalnia.RowCount-1]:='x';

  end;
end;


procedure TForm9.zlozClick(Sender: TObject);
begin
  TForm5.Create(self).ShowModal;
  if dysp then
  begin
    showMessage('Dyspozycja z³o¿ona');
  end;
end;

procedure TForm9.Edit1Click(Sender: TObject);
begin
  if not edit1.text.isEmpty then
  begin
    clr.Visible:=true;
  end
  else
  begin
    clr.Visible:=false;
  end;
end;

procedure TForm9.Edit1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  //Obs³uga backspace aby nie musiec wciskac przycisku na pustym edicie to schowania x
  if Key.ToString='8' then
  begin
    if edit1.text.Length=1 then
    begin
      clr.Visible:=false;
    end;
  end;

  if not edit1.text.isempty then
  begin
    clr.Visible:=true;
  end

  else
  begin
    clr.Visible:=false;
  end;
end;



procedure TForm9.FormCreate(Sender: TObject);
begin
  sw:=false;
  kosz:=true;
  i:=0;
  qry.Close;
  qry.ParamByName('param1').Value:=Form6.IBQuery3ID.AsString;
  qry.ParamByName('param2').Value:=Form6.IBQuery3RODZAJ.AsString;
  Label1.Text:=Form6.IBQuery3ID.AsString;
  qry.Open;
end;

procedure TForm9.GridBindSourceDB1CellClick(const Column: TColumn;
  const Row: Integer);
begin
  v:=0;
  Label2.Text:=qryARTYKUL_KOD.Value +' - '+ qryARTYKUL_OPIS.Value;
  Label3.Text:=qryREALIZACJA.Value;
  m:=qryILOSC_MAX.Value;
  tb1.Max:=m;
  Label4.Text:= 'Iloœæ: ' + tb1.Value.ToString + '/' + m.ToString;
  panIlosc.Visible:=true;

end;

end.
