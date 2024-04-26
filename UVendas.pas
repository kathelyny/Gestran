unit UVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  DB, System.IOUtils,
  Vcl.StdCtrls, Data.FMTBcd, Data.SqlExpr, Datasnap.DBClient, System.StrUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.Mask,
  Vcl.DBCtrls,  Printers, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1id: TIntegerField;
    ClientDataSet1data: TDateTimeField;
    ClientDataSet1vendedor: TStringField;
    ClientDataSet1valor_venda: TCurrencyField;
    ClientDataSet1valor_desconto: TCurrencyField;
    ClientDataSet1valor_total: TCurrencyField;
    MaskEdit1: TMaskEdit;
    Label1: TLabel;
    MaskEdit2: TMaskEdit;
    Button2: TButton;
    Vendedor: TLabel;
    ComboBox1: TComboBox;
    Button4: TButton;
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    procedure Alimenta_Tabela;
    procedure CarregaCombo;
    procedure GerarPDF;


    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Tabela: TClientDataSet;
  Campo: TField;
  Campos: TStringList;


implementation

{$R *.dfm}

procedure TForm1.Alimenta_Tabela;
var
  CSV: TStringList;
  i, j: Integer;
begin
  Tabela := TClientDataSet.Create(nil);
  try
    Tabela.FieldDefs.Clear;

    Tabela.FieldDefs.Add('id', ftInteger);
    Tabela.FieldDefs.Add('Data', ftDate);
    Tabela.FieldDefs.Add('Vendedor', ftString, 30);
    Tabela.FieldDefs.Add('Valor_Venda', ftCurrency);
    Tabela.FieldDefs.Add('Valor_Desconto', ftCurrency);
    Tabela.FieldDefs.Add('Valor_Total', ftCurrency);
    Tabela.CreateDataSet;

    CSV := TStringList.Create;
    Campos := TStringList.Create;
    try
      CSV.LoadFromFile('C:\Gestran\Vendas.csv');

      for i := 1 to CSV.Count -1 do
      begin
        Tabela.Append;
        Campos.CommaText := CSV[i];
        Tabela.FieldByName('id').AsInteger:= StrToint(Campos[0]);
        Tabela.FieldByName('Data').AsString := Campos[1];
        Tabela.FieldByName('Vendedor').AsString := Campos[2] + ' ' + Campos[3];
        Tabela.FieldByName('Valor_Venda').AsCurrency := StrToFloat(StringReplace(Campos[4], '.', ',',  [rfReplaceAll]));
        Tabela.FieldByName('Valor_Desconto').AsCurrency := StrToFloat(StringReplace(Campos[5], '.', ',',  [rfReplaceAll]));
        Tabela.FieldByName('Valor_Total').AsCurrency := StrToFloat(StringReplace(Campos[6], '.', ',',  [rfReplaceAll]));
        Tabela.Post;
      end;
    finally
      CSV.Free;
      Campos.Free;
    end;
  finally
    DBGrid1.DataSource := DataSource1;
    DataSource1.DataSet := Tabela;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   GerarPDF;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  DataInicial, DataFinal: TDateTime;
  sVendedor: String;
begin
  DataInicial := StrTodate(MaskEdit1.Text);
  DataFinal := StrTodate(MaskEdit2.Text);
  if ComboBox1.Text <> 'Todos' then
     sVendedor:= ' AND vendedor = ' + QuotedStr(ComboBox1.Text);
  Tabela.Filtered := True;
  tabela.Filter :=   ' data >= ' + QuotedStr(DateToStr(DataInicial)) +
                     ' AND data <= ' + QuotedStr(DateToStr(DataFinal))+
                     sVendedor;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Tabela.Filtered := True;
  tabela.Filter :=   'vendedor = ' + QuotedStr(ComboBox1.Text);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Tabela.Filtered := fALSE;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
   GerarPDF;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Alimenta_Tabela;
end;

procedure TForm1.CarregaCombo;
var
  i: Integer;
  ListaValores: TStringList;
begin
  ListaValores := TStringList.Create;
  try
    tabela.First;
    while not tabela.Eof do
    begin
      ListaValores.Add(tabela.FieldByName('vendedor').AsString);
      tabela.Next;
    end;

    ListaValores.Sort;
    ListaValores.Duplicates := dupIgnore;

    ComboBox1.Items.Clear;

    for i := 0 to ListaValores.Count - 1 do
    begin
      ComboBox1.Items.Add(ListaValores[i]);
    end;
  finally
    ListaValores.Free;
  end;
end;

procedure TForm1.GerarPDF;
var
  Printer: TPrinter;
  Texto: TextFile;
  vendedor, data : string;
  valor: Currency;
begin
  Printer := TPrinter.Create;
  try
    valor := 0;
    Printer.PrinterIndex := Printer.Printers.IndexOf('Microsoft Print to PDF');
    AssignPrn(Texto);
    Rewrite(Texto);
    Writeln(Texto, '-------------------------------------------------------------------------------------------------------------------------------' );
    Writeln(Texto, '' );
    Writeln(Texto, 'Vendedor:' + ComboBox1.text);
    Writeln(Texto, '' );
    Writeln(Texto, '-------------------------------------------------------------------------------------------------------------------------------' );
    Writeln(Texto, '' );
    try
      tabela.First;
      while not tabela.Eof do
      begin
        Writeln(Texto, '' );
        valor := valor + tabela.FieldByName('Valor_Total').AsCurrency;
        Writeln(Texto, '             Vendedor:       '  + tabela.FieldByName('Vendedor').AsString +
                       '             Data:       '  + tabela.FieldByName('Data').AsString +
                       '             Valor:      '  + tabela.FieldByName('Valor_Total').AsString );
        //Writeln(Texto, '' );
        tabela.Next;
      end;
      Writeln(Texto, '' );
      Writeln(Texto, '------------------------------------------------------------------------------------------------------------------------------' );
      Writeln(Texto, '                                                                                                              Total: '  + CurrToStr(valor) );
    finally
      CloseFile(Texto);
    end;
  finally
    Printer.Free;
  end;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
   if RadioGroup1.itemindex = 0 then
      Tabela.IndexFieldNames := 'Data'
   else  if RadioGroup1.itemindex = 1 then
      Tabela.IndexFieldNames := 'Vendedor'
   else if RadioGroup1.itemindex = 2 then
      Tabela.IndexFieldNames := 'Valor_Total';
end;

end.
