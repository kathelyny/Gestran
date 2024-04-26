object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Vendas'
  ClientHeight = 446
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 72
    Top = 27
    Width = 84
    Height = 13
    Caption = 'Selecione Per'#237'odo'
  end
  object Vendedor: TLabel
    Left = 320
    Top = 30
    Width = 94
    Height = 13
    Caption = 'Selecione Vendedor'
  end
  object DBGrid1: TDBGrid
    Left = 56
    Top = 112
    Width = 625
    Height = 209
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'data'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'vendedor'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'valor_venda'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'valor_desconto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'valor_total'
        Visible = True
      end>
  end
  object MaskEdit1: TMaskEdit
    Left = 173
    Top = 26
    Width = 64
    Height = 21
    EditMask = '!99/99/00;1;_'
    MaxLength = 8
    TabOrder = 1
    Text = '01/01/23'
  end
  object MaskEdit2: TMaskEdit
    Left = 243
    Top = 26
    Width = 64
    Height = 21
    EditMask = '!99/99/00;1;_'
    MaxLength = 8
    TabOrder = 2
    Text = '06/01/23'
  end
  object Button2: TButton
    Left = 606
    Top = 24
    Width = 75
    Height = 21
    Caption = 'Filtrar'
    TabOrder = 3
    OnClick = Button2Click
  end
  object ComboBox1: TComboBox
    Left = 420
    Top = 24
    Width = 145
    Height = 21
    ItemIndex = 0
    TabOrder = 4
    Text = 'Todos'
    Items.Strings = (
      'Todos'
      'Vendedor 01'
      'Vendedor 02'
      'Vendedor 03')
  end
  object Button4: TButton
    Left = 606
    Top = 51
    Width = 75
    Height = 21
    Caption = 'Limpar Filtro'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button1: TButton
    Left = 296
    Top = 336
    Width = 153
    Height = 49
    Caption = 'Imprimir'
    TabOrder = 6
    OnClick = Button1Click
  end
  object RadioGroup1: TRadioGroup
    Left = 72
    Top = 46
    Width = 493
    Height = 43
    Caption = 'Agrupar por '
    Columns = 3
    Items.Strings = (
      'Data'
      'Vendedor'
      'Valor Total')
    TabOrder = 7
    OnClick = RadioGroup1Click
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 672
    Top = 344
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 592
    Top = 344
    object ClientDataSet1id: TIntegerField
      FieldName = 'id'
    end
    object ClientDataSet1data: TDateTimeField
      FieldName = 'data'
    end
    object ClientDataSet1vendedor: TStringField
      FieldName = 'vendedor'
      Size = 30
    end
    object ClientDataSet1valor_venda: TCurrencyField
      FieldName = 'valor_venda'
    end
    object ClientDataSet1valor_desconto: TCurrencyField
      FieldName = 'valor_desconto'
    end
    object ClientDataSet1valor_total: TCurrencyField
      FieldName = 'valor_total'
    end
  end
end
