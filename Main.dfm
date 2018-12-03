object FormMain: TFormMain
  Left = 337
  Top = 123
  Width = 846
  Height = 580
  VertScrollBar.Tracking = True
  Caption = 'Pic Cut'
  Color = clBtnFace
  Constraints.MinHeight = 580
  Constraints.MinWidth = 811
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox: TScrollBox
    Left = 177
    Top = 0
    Width = 653
    Height = 442
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    object DrawPanel: TDrawPanel
      Left = 24
      Top = 16
      Width = 618
      Height = 506
      Align = alCustom
      Caption = 'DrawPanel'
      TabOrder = 0
      OnMouseDown = DrawPanelMouseDown
      OnMouseMove = DrawPanelMouseMove
      OnMouseUp = DrawPanelMouseUp
      OnPaint = DrawPanelPaint
    end
  end
  object PanelMenu: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 442
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object LabelDir: TLabel
      Left = 8
      Top = 184
      Width = 111
      Height = 13
      Caption = #1050#1072#1090#1072#1083#1086#1075' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    end
    object ButtonOpenDir: TSpeedButton
      Left = 144
      Top = 199
      Width = 23
      Height = 22
      OnClick = ButtonOpenDirClick
    end
    object Bevel: TBevel
      Left = 168
      Top = 0
      Width = 9
      Height = 442
      Align = alRight
      Shape = bsRightLine
    end
    object ButtonOpenPic: TButton
      Left = 8
      Top = 8
      Width = 161
      Height = 25
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      TabOrder = 0
      OnClick = ButtonOpenPicClick
    end
    object ButtonExe: TButton
      Left = 8
      Top = 40
      Width = 161
      Height = 25
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1079#1072#1076#1072#1085#1080#1077
      TabOrder = 1
      OnClick = ButtonExeClick
    end
    object GroupBoxSets: TGroupBox
      Left = 8
      Top = 72
      Width = 161
      Height = 105
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
      TabOrder = 2
      object LabelStep: TLabel
        Left = 8
        Top = 16
        Width = 25
        Height = 13
        Caption = #1064#1072#1075':'
      end
      object LabelCount: TLabel
        Left = 8
        Top = 56
        Width = 75
        Height = 13
        Caption = #1050#1086#1083'-'#1074#1086' '#1096#1072#1075#1086#1074':'
      end
      object SpinEditorStep: TSpinEditor
        Left = 8
        Top = 32
        Width = 145
        Height = 22
        Alignment = taLeftJustify
        BorderStyle = bsSingle
        Margin = 0
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Text = '1 px'
        VerticalAlignment = vaMiddle
        AutoSelect = False
        ReadOnly = False
        ShowPreview = False
        Min = 1.000000000000000000
        Options = [eoAllowFloat, eoAllowSigns]
        Precision = 0
        TextAfter = ' px'
        Value = 1.000000000000000000
        Increment = 1.000000000000000000
      end
      object SpinEditorCount: TSpinEditor
        Left = 8
        Top = 72
        Width = 145
        Height = 22
        Alignment = taLeftJustify
        BorderStyle = bsSingle
        Margin = 0
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Text = '1'
        VerticalAlignment = vaMiddle
        AutoSelect = False
        ReadOnly = False
        ShowPreview = False
        Min = 1.000000000000000000
        Options = [eoAllowFloat, eoAllowSigns]
        Precision = 0
        Value = 1.000000000000000000
        Increment = 1.000000000000000000
      end
    end
    object EditDir: TEdit
      Left = 8
      Top = 200
      Width = 137
      Height = 21
      TabOrder = 3
    end
    object DrawPanelInfo: TDrawPanel
      Left = 8
      Top = 328
      Width = 161
      Height = 105
      Caption = 'DrawPanelInfo'
      TabOrder = 4
      OnPaint = DrawPanelInfoPaint
    end
    object GroupBoxSetSel: TGroupBox
      Left = 8
      Top = 232
      Width = 161
      Height = 89
      Caption = #1059#1082#1072#1079#1072#1090#1100' '#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1074#1099#1076#1077#1083'.'
      TabOrder = 5
      object ButtonSet: TSpeedButton
        Left = 130
        Top = 59
        Width = 23
        Height = 22
        OnClick = ButtonSetClick
      end
      object RadioButton1: TRadioButton
        Left = 8
        Top = 32
        Width = 153
        Height = 17
        Caption = #1057#1083#1077#1074', '#1057#1074#1077#1088#1093', '#1057#1087#1088#1072#1074', '#1057#1085#1080#1079
        TabOrder = 0
      end
      object RadioButton2: TRadioButton
        Left = 8
        Top = 16
        Width = 129
        Height = 17
        Caption = 'X, Y, '#1042#1099#1089#1086#1090#1072', '#1064#1080#1088#1080#1085#1072
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object EditSet: TEdit
        Left = 8
        Top = 60
        Width = 121
        Height = 21
        TabOrder = 2
        Text = '0,0,20,20'
      end
    end
  end
  object DrawPanelPreview: TDrawPanel
    Left = 0
    Top = 442
    Width = 830
    Height = 80
    Align = alBottom
    Caption = 'DrawPanelPreview'
    TabOrder = 2
    OnPaint = DrawPanelPreviewPaint
  end
  object XPManifest: TXPManifest
    Left = 304
    Top = 120
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 'JPEG Image File (*.jpeg)|*.jpeg; *.jpg'
    Left = 416
    Top = 69
  end
  object Timer: TTimer
    Interval = 1
    OnTimer = TimerTimer
    Left = 232
    Top = 61
  end
  object MainMenu: TMainMenu
    Left = 249
    Top = 144
    object MenuItemFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object MenuItemOpen: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = ButtonOpenPicClick
      end
      object MenuItemExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = MenuItemExitClick
      end
    end
    object MenuItemTask: TMenuItem
      Caption = #1047#1072#1076#1072#1095#1072
      object MenuItemExe: TMenuItem
        Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
        OnClick = ButtonExeClick
      end
    end
  end
end
