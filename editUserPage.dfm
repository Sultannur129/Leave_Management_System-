object editUser: TeditUser
  Left = 0
  Top = 0
  Caption = 'Edit User'
  ClientHeight = 442
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object idBoxLabel: TLabel
    Left = 24
    Top = 64
    Width = 82
    Height = 15
    Caption = 'Enter id of user:'
  end
  object firstNameEditLabel: TLabel
    Left = 239
    Top = 187
    Width = 60
    Height = 15
    Caption = 'First Name:'
  end
  object lastNameEditLabel: TLabel
    Left = 240
    Top = 227
    Width = 59
    Height = 15
    Caption = 'Last Name:'
  end
  object phoneEditLabel: TLabel
    Left = 240
    Top = 267
    Width = 37
    Height = 15
    Caption = 'Phone:'
  end
  object departmentEditLabel: TLabel
    Left = 240
    Top = 307
    Width = 66
    Height = 15
    Caption = 'Department:'
  end
  object emailEditLabel: TLabel
    Left = 240
    Top = 349
    Width = 32
    Height = 15
    Caption = 'Email:'
  end
  object userGrid: TStringGrid
    Left = 24
    Top = 144
    Width = 193
    Height = 225
    ColCount = 2
    DefaultColWidth = 90
    DefaultRowHeight = 35
    RowCount = 6
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goFixedRowDefAlign]
    TabOrder = 0
  end
  object idBox: TEdit
    Left = 32
    Top = 96
    Width = 74
    Height = 23
    TabOrder = 1
  end
  object queryButton: TButton
    Left = 120
    Top = 95
    Width = 81
    Height = 25
    Caption = 'Find'
    TabOrder = 2
    OnClick = queryButtonClick
  end
  object firstNameBox: TEdit
    Left = 312
    Top = 184
    Width = 121
    Height = 23
    TabOrder = 3
  end
  object lastNameBox: TEdit
    Left = 312
    Top = 224
    Width = 121
    Height = 23
    TabOrder = 4
  end
  object phoneBox: TEdit
    Left = 312
    Top = 264
    Width = 121
    Height = 23
    TabOrder = 5
  end
  object departmentBox: TEdit
    Left = 312
    Top = 304
    Width = 121
    Height = 23
    TabOrder = 6
  end
  object emailBox: TEdit
    Left = 312
    Top = 346
    Width = 121
    Height = 23
    TabOrder = 7
  end
  object editButton: TButton
    Left = 336
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 8
    OnClick = editButtonClick
  end
end
