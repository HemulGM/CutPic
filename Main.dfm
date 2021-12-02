object FormMain: TFormMain
  Left = 337
  Top = 123
  VertScrollBar.Tracking = True
  Caption = 'Pic Cut'
  ClientHeight = 685
  ClientWidth = 962
  Color = clBtnFace
  Constraints.MinHeight = 580
  Constraints.MinWidth = 811
  DoubleBuffered = True
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
  object Bevel: TBevel
    Left = 177
    Top = 0
    Width = 1
    Height = 605
    Align = alLeft
    Shape = bsLeftLine
  end
  object ScrollBox: TScrollBox
    Left = 178
    Top = 0
    Width = 784
    Height = 605
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    object PanelClient: TPanel
      Left = 6
      Top = 3
      Width = 755
      Height = 596
      BevelOuter = bvNone
      Color = clSilver
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      object DrawPanel: TDrawPanel
        Left = 0
        Top = 0
        Width = 755
        Height = 596
        OnPaint = DrawPanelPaint
        DefaultPaint = False
        OnMouseDown = DrawPanelMouseDown
        OnMouseMove = DrawPanelMouseMove
        OnMouseUp = DrawPanelMouseUp
        Align = alClient
        BevelOuter = bvNone
        Color = clGray
        Ctl3D = True
        ParentBackground = False
        ParentCtl3D = False
        ShowCaption = False
        TabOrder = 0
        TabStop = True
      end
    end
  end
  object PanelMenu: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 605
    Align = alLeft
    BevelOuter = bvNone
    Color = clGray
    TabOrder = 1
    object LabelDir: TLabel
      Left = 8
      Top = 278
      Width = 111
      Height = 13
      Caption = #1050#1072#1090#1072#1083#1086#1075' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    end
    object ButtonOpenDir: TSpeedButton
      Left = 146
      Top = 293
      Width = 23
      Height = 22
      OnClick = ButtonOpenDirClick
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
      object SpinEditorStep: TlkSpinEdit
        Left = 8
        Top = 32
        Width = 145
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 100
        LightButtons = False
      end
      object SpinEditorCount: TlkSpinEdit
        Left = 8
        Top = 72
        Width = 145
        Height = 21
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 5
        LightButtons = False
      end
    end
    object EditDir: TEdit
      Left = 8
      Top = 294
      Width = 137
      Height = 21
      TabOrder = 3
    end
    object DrawPanelInfo: TDrawPanel
      Left = 0
      Top = 500
      Width = 177
      Height = 105
      OnPaint = DrawPanelInfoPaint
      DefaultPaint = False
      Align = alBottom
      ParentBackground = False
      TabOrder = 4
    end
    object GroupBoxSetSel: TGroupBox
      Left = 8
      Top = 183
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
        Width = 150
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
    Top = 605
    Width = 962
    Height = 80
    OnPaint = DrawPanelPreviewPaint
    DefaultPaint = False
    Align = alBottom
    ParentBackground = False
    TabOrder = 2
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
