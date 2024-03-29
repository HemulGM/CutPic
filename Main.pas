unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ComCtrls, ExtCtrls, PanelExt, ExtDlgs, StdCtrls, Menus, Buttons,
  HGM.Controls.SpinEdit;

type
  TLines = array[1..6] of string;

  TFormMain = class(TForm)
    OpenPictureDialog: TOpenPictureDialog;
    Timer: TTimer;
    ScrollBox: TScrollBox;
    PanelMenu: TPanel;
    ButtonOpenPic: TButton;
    ButtonExe: TButton;
    GroupBoxSets: TGroupBox;
    SpinEditorStep: TlkSpinEdit;
    LabelStep: TLabel;
    LabelCount: TLabel;
    SpinEditorCount: TlkSpinEdit;
    MainMenu: TMainMenu;
    MenuItemFile: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemExit: TMenuItem;
    MenuItemTask: TMenuItem;
    MenuItemExe: TMenuItem;
    LabelDir: TLabel;
    EditDir: TEdit;
    ButtonOpenDir: TSpeedButton;
    DrawPanelInfo: TDrawPanel;
    GroupBoxSetSel: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    EditSet: TEdit;
    ButtonSet: TSpeedButton;
    DrawPanelPreview: TDrawPanel;
    PanelClient: TPanel;
    DrawPanel: TDrawPanel;
    Bevel: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure DrawPanelPaint(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure DrawPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DrawPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DrawPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ButtonOpenPicClick(Sender: TObject);
    procedure ButtonExeClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure ButtonOpenDirClick(Sender: TObject);
    procedure DrawPanelInfoPaint(Sender: TObject);
    procedure ButtonSetClick(Sender: TObject);
    procedure DrawPanelPreviewPaint(Sender: TObject);
  private
    AJPEG: TJPEGImage;
    AH, AW: Integer;
    OPos: TPoint;
    IsDown: Boolean;
    SelRect: TRect;
    DrawBMP: TBitmap;
    TextBMP: TBitmap;
    PrevBMP: TBitmap;
    NJPEG: TJPEGImage;
    MPos: TPoint;
    SLines: TLines;
    EPic: Boolean;
    procedure LoadPicture(FM: TFileName);
    function GetResultRect: TRect;
    procedure UpdateInfo;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

function GetNormalRect(ARect: TRect): TRect;

function DestRect(W, H: Integer; NLeft: Integer): TRect;

implementation

uses
  DeleteScans, HGM.Common.Utils, HGM.Winapi, Math;

{$R *.dfm}

function GetNormalRect(ARect: TRect): TRect;
begin
  Result.Left := Min(ARect.Left, ARect.Right);
  Result.Right := Max(ARect.Left, ARect.Right);
  Result.Top := Min(ARect.Top, ARect.Bottom);
  Result.Bottom := Max(ARect.Top, ARect.Bottom);
end;

function DestRect(W, H: Integer; NLeft: Integer): TRect;
var
  cw, ch: Integer;
  xyaspect: Double;
begin
  cw := 100;
  ch := 76;
  if (W = 0) or (H = 0) then
    Exit;
  xyaspect := W / H;
  if W > H then
  begin
    W := cw;
    H := Trunc(cw / xyaspect);
    if H > ch then  // woops, too big
    begin
      H := ch;
      W := Trunc(ch * xyaspect);
    end;
  end
  else
  begin
    H := ch;
    W := Trunc(ch * xyaspect);
    if W > cw then  // woops, too big
    begin
      W := cw;
      H := Trunc(cw / xyaspect);
    end;
  end;
  with Result do
  begin
    Left := NLeft;
    Top := 2;
    Right := Left + W;
    Bottom := Top + H;
  end;
 //OffsetRect(Result, (cw - w) div 2, (ch - h) div 2);
end;

procedure TFormMain.UpdateInfo;
begin
  if (AW = 0) or (AH = 0) then
    SLines[1] := '�����: ��� �����������'
  else
    SLines[1] := '�����: ' + IntToStr(AW) + 'x' + IntToStr(AH);
  SLines[2] := '������: [' + IntToStr(MPos.X) + ':' + IntToStr(MPos.Y) + ']';
  SLines[3] := '���������: [' + IntToStr(SelRect.Left) + ':' + IntToStr(SelRect.Top) + ']';
  SLines[4] := '�������: [' + IntToStr(Abs(SelRect.Right - SelRect.Left)) + ':' + IntToStr(Abs(SelRect.Bottom - SelRect.Top)) + ']';
end;

function TFormMain.GetResultRect: TRect;
begin
  Result := SelRect;
  Result.Left := Result.Left + 1;
  Result.Top := Result.Top + 1;
  Result.Right := Result.Right - 1;
  Result.Bottom := Result.Bottom - 1;
end;

procedure TFormMain.LoadPicture(FM: TFileName);
begin
  AJPEG.LoadFromFile(FM);
  AH := AJPEG.Height;
  AW := AJPEG.Width;
  PanelClient.Left := 0;
  PanelClient.Top := 0;
  PanelClient.Width := AW;
  PanelClient.Height := AH;
  DrawBMP.Width := AW;
  DrawBMP.Height := AH;
  EPic := True;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  AJPEG := TJPEGImage.Create;
  DrawBMP := TBitmap.Create;
  TextBMP := TBitmap.Create;
  TextBMP.Height := DrawPanelInfo.Height;
  TextBMP.Width := DrawPanelInfo.Width;
  TextBMP.Canvas.Font.Name := 'Segoe UI';
  PrevBMP := TBitmap.Create;
  PrevBMP.Height := DrawPanelPreview.Height;
  PrevBMP.Width := DrawPanelPreview.Width;
end;

procedure TFormMain.DrawPanelPaint(Sender: TObject);
var
  i: Integer;
  Rct: TRect;
begin
  DrawBMP.Canvas.Draw(0, 0, AJPEG);
  DrawBMP.Canvas.Brush.Style := bsClear;
  DrawBMP.Canvas.Pen.Style := psDot;
  DrawBMP.Canvas.Pen.Mode := pmNot;
  DrawBMP.Canvas.Rectangle(SelRect);
  Rct := SelRect;
  for i := 1 to SpinEditorCount.Value - 1 do
  begin
    Rct.Offset(SpinEditorStep.Value, 0);
    if Rct.Right > DrawBMP.Width then
    begin
      Break;
    end;
    DrawBMP.Canvas.Pen.Style := psSolid;
    DrawBMP.Canvas.Pen.Mode := pmBlack;

    DrawBMP.Canvas.Pen.Color := clBlack;
    DrawBMP.Canvas.Rectangle(Rct);
  end;
  DrawPanel.Canvas.Draw(0, 0, DrawBMP);
end;

procedure TFormMain.TimerTimer(Sender: TObject);
begin
  DrawPanel.Repaint;
  DrawPanelInfo.Repaint;
  DrawPanelPreview.Repaint;
end;

procedure TFormMain.DrawPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (X < AW) and (Y < AH) then
    IsDown := True;
  OPos := Point(X, Y);
end;

procedure TFormMain.DrawPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsDown := False;
end;

procedure TFormMain.DrawPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  TX, TY: Integer;
begin
  if IsDown then
  begin
    TX := X;
    TY := Y;
    if X > AW then
      TX := AW;
    if Y > AH then
      TY := AH;
    if X < 0 then
      TX := 0;
    if Y < 0 then
      TY := 0;
    SelRect := GetNormalRect(Rect(OPos.X, OPos.Y, TX, TY));
    DrawPanel.Repaint;
  end;
  MPos := Point(X, Y);
  UpdateInfo;
end;

procedure TFormMain.ButtonOpenPicClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
    LoadPicture(OpenPictureDialog.FileName);
end;

procedure TFormMain.ButtonExeClick(Sender: TObject);
var
  BMP, BMPJPEG: TBitmap;
  SRect: TRect;
  i: Word;
  IsBreak: Boolean;
  Dir: string;
begin
  BMP := TBitmap.Create;
  BMP.Width := Abs(SelRect.Right - SelRect.Left);
  BMP.Height := Abs(SelRect.Bottom - SelRect.Top);
  if (BMP.Height < 2) or (BMP.Width < 2) then
  begin
    MessageBox(Handle, '���������� ����� ������� ����!', '', MB_ICONWARNING or MB_OK);
    Exit;
  end;
  if DirectoryExists(EditDir.Text) then
    Dir := EditDir.Text
  else
    Dir := ExtractFilePath(ParamStr(0));
  IsBreak := False;
  BMPJPEG := TBitmap.Create;
  BMPJPEG.Assign(AJPEG);
  NJPEG := TJPEGImage.Create;
  SRect := SelRect;
  for i := 1 to SpinEditorCount.Value do
  begin
    if i <> 1 then
    begin
      SRect.Left := SRect.Left + SpinEditorStep.Value;
      SRect.Right := SRect.Left + BMP.Width;
    end;
    if SRect.Right > BMPJPEG.Width then
    begin
      IsBreak := True;
      Break;
    end;
    BMP.Canvas.CopyRect(Rect(0, 0, BMP.Width, BMP.Height), BMPJPEG.Canvas, SRect);
    NJPEG.Assign(BMP);
    NJPEG.SaveToFile(Dir + '\Result' + IntToStr(i) + '.jpg');
  end;
  NJPEG.Free;
  BMP.Free;
  BMPJPEG.Free;
  if not IsBreak then
    MessageBox(Handle, '������ ������� ���������!', '', MB_ICONINFORMATION or MB_OK)
  else
    MessageBox(Handle, '������ ���������, �� �� �� �����.' + #13#10 + ' ����������� ������� ����.', '', MB_ICONINFORMATION or MB_OK);
end;

procedure TFormMain.MenuItemExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.ButtonOpenDirClick(Sender: TObject);
var
  Dir: string;
begin
  if AdvSelectDirectory('�������� �������, � ������� ����� �������� ����� �����������', '', Dir, True, False, True) then
    EditDir.Text := Dir;
end;

procedure TFormMain.DrawPanelInfoPaint(Sender: TObject);
var
  i: Byte;
begin
  TextBMP.Canvas.Brush.Color := PanelMenu.Color;
  TextBMP.Canvas.FillRect(Rect(0, 0, TextBMP.Width, TextBMP.Height));
  for i := 1 to 6 do
  begin
    if SLines[i] <> '' then
      TextBMP.Canvas.TextOut(2, (i - 1) * TextBMP.Canvas.TextHeight(SLines[i]), SLines[i]);
  end;
  DrawPanelInfo.Canvas.Draw(0, 0, TextBMP);
end;

procedure TFormMain.ButtonSetClick(Sender: TObject);
var
  A1, A2, A3, A4, i, Old_I: Integer;
  AText: string;

  function DeleteSpace(SText: string): string;
  begin
    Result := SText;
    while Pos(' ', Result) <> 0 do
      Delete(Result, Pos(' ', Result), 1);
  end;

begin
  AText := DeleteSpace(EditSet.Text);
  A1 := -1;
  A2 := -1;
  A3 := -1;
  A4 := -1;
  Old_I := 0;
  for i := 1 to Length(AText) + 1 do
  begin
    if (AText[i + 1] = ',') or (i = Length(AText)) then
    begin
      if A1 = -1 then
        A1 := StrToInt(Copy(AText, Old_I + 1, (i) - Old_I))
      else if A2 = -1 then
        A2 := StrToInt(Copy(AText, Old_I + 1, (i) - Old_I))
      else if A3 = -1 then
        A3 := StrToInt(Copy(AText, Old_I + 1, (i) - Old_I))
      else if A4 = -1 then
        A4 := StrToInt(Copy(AText, Old_I + 1, (i) - Old_I))
      else
        Break;
      Old_I := i + 1;
    end;
  end;
  if RadioButton1.Checked then
    SelRect := Rect(A1, A2, A3, A4)
  else
    SelRect := Rect(A1, A2, A1 + A3, A2 + A4);
  UpdateInfo;
end;

procedure TFormMain.DrawPanelPreviewPaint(Sender: TObject);
var
  i: Byte;
  NRect, DRect: TRect;
  HW: Integer;
  MYBMP: TBitmap;
  CNT: Word;
  IsBreak: Boolean;
begin
  if AJPEG.Empty then
    Exit;
  IsBreak := False;
  MYBMP := TBitmap.Create;
  MYBMP.Assign(AJPEG);
  PrevBMP.Width := DrawPanelPreview.Width;
  PrevBMP.Canvas.Brush.Style := bsSolid;
  PrevBMP.Canvas.Brush.Color := clBlack;
  PrevBMP.Canvas.FillRect(Rect(0, 0, PrevBMP.Width, PrevBMP.Height));
  NRect := SelRect;
  HW := Abs(NRect.Left - NRect.Right);
  if SpinEditorCount.Value < (DrawPanelPreview.Width div 100) then
    CNT := SpinEditorCount.Value
  else
    CNT := (DrawPanelPreview.Width div 100);
  for i := 0 to CNT - 1 do
  begin
    NRect.Left := NRect.Left + SpinEditorStep.Value;
    NRect.Right := NRect.Left + HW;
    if NRect.Right > AW then
    begin
      IsBreak := True;
      Break;
    end;
    DRect := DestRect(Abs(NRect.Left - NRect.Right), Abs(NRect.Top - NRect.Bottom), (i * 102));
    PrevBMP.Canvas.CopyRect(DRect, MYBMP.Canvas, NRect);
    PrevBMP.Canvas.Font.Color := clWhite;
    PrevBMP.Canvas.TextOut(DRect.Left, DRect.Top, IntToStr(i + 1));
  end;
  if IsBreak then
    SLines[5] := '������: �������'
  else
    SLines[5] := '������: �����';
  UpdateInfo;
  MYBMP.Free;
  DrawPanelPreview.Canvas.Draw(0, 0, PrevBMP);
end;

end.

