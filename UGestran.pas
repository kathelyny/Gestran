unit UGestran;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Classes, DB, DBF, CsvDocument,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure Alimenta_Tabela;
var
  CSV: TStringList;
  i, j: Integer;
  Tabela: TDBFTable;
  Campo: TDBFField;
begin
  // Criando e configurando a tabela em tempo de execução
  Tabela := TDBFTable.Create(nil);
  try
    Tabela.TableName := 'Vendas';
    Tabela.TableLevel := 7;
    Tabela.Exclusive := True;
    Tabela.FieldDefs.Clear;

    // Adicione os campos que deseja na tabela
    // Exemplo: campo1: Integer, campo2: String, campo3: Date
    Campo := Tabela.FieldDefs.AddFieldDef;
    Campo.Name := 'id';
    Campo.DataType := ftInteger;

    Campo := Tabela.FieldDefs.AddFieldDef;
    Campo.Name := 'data';
    Campo.DataType := ftDate;

    Campo := Tabela.FieldDefs.AddFieldDef;
    Campo.Name := 'Vendedor';
    Campo.DataType := ftString;
    Campo.Size := 20;


    Campo := Tabela.FieldDefs.AddFieldDef;
    Campo.Name := 'Valor_Venda';
    Campo.DataType := ft;
    Campo.Size := 20;



    Tabela.CreateTable;

    // Lendo o arquivo CSV
    CSV := TStringList.Create;
    try
      CSV.LoadFromFile('vendas.csv');

      // Iterando sobre as linhas do CSV
      for i := 0 to CSV.Count - 1 do
      begin
        Tabela.Append;
        // Separando os campos por vírgula e adicionando-os à tabela
        for j := 0 to CSV[i].Split(',').Length - 1 do
        begin
          Tabela.Fields[j].AsString := CSV[i].Split(',')[j];
        end;
        Tabela.Post;
      end;
    finally
      CSV.Free;
    end;
  finally
    Tabela.Free;
  end;
end;

end.
