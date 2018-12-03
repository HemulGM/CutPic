unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, XPMan, jpeg, ComCtrls, ToolWin, ExtCtrls, PanelExt, ExtDlgs,
  CellEditors, StdCtrls, Menus, Buttons;

type
  TFormMain = class(TForm)
    XPManifest: TXPManifest;
    OpenPictureDialog: TOpenPictureDialog;
    Timer: TTimer;
    ScrollBox: TScrollBox;
    DrawPanel: TDrawPanel;
    PanelMenu: TPanel;
    ButtonOpenPic: TButton;
    ButtonExe: TButton;
    GroupBoxSets: TGroupBox;
    SpinEditorStep: TSpinEditor;
    LabelStep: TLabel;
    LabelCount: TLabel;
    SpinEditorCount: TSpinEditor;
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
    Bevel: TBevel;
    GroupBoxSetSel: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    EditSet: TEdit;
    ButtonSet: TSpeedButton;
    DrawPanelPreview: TDrawPanel;
    procedure FormCreate(Sender: TObject);
    procedure DrawPanelPaint(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure DrawPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ButtonOpenPicClick(Sender: TObject);
    procedure ButtonExeClick(Sender: TObject);
    procedure MenuItemExitClick(Sender: TObject);
    procedure ButtonOpenDirClick(Sender: TObject);
    procedure DrawPanelInfoPaint(Sender: TObject);
    procedure ButtonSetClick(Sender: TObject);
    procedure DrawPanelPreviewPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TLines = array[1..6] of string;

var
  FormMain: TFormMain;
  AJPEG:TJPEGImage;
  AH, AW:Integer;
  OPos:TPoint;
  IsDown:Boolean;
  SelRect:TRect;
  DrawBMP:TBitmap;
  TextBMP:TBitmap;
  PrevBMP:TBitmap;
  NJPEG:TJPEGImage;
  MPos:TPoint;
  SLines:TLines;
  EPic:Boolean;

function GetNormalRect(ARect:TRect):TRect;
function DestRect(W, H:Integer; NLeft:Integer): TRect;


implementation
 uses ToolUnit, DeleteScans;

{$R *.dfm}

procedure Info;
begin
 with FormMain do
  begin
   if (AW = 0) or (AH = 0) then SLines[1]:='Холст: Нет изображения'
   else SLines[1]:='Холст: '+IntToStr(AW)+'x'+IntToStr(AH);
   SLines[2]:='Курсор: ['+IntToStr(MPos.X)+':'+IntToStr(MPos.Y)+']';
   SLines[3]:='Выделение: ['+IntToStr(SelRect.Left)+':'+IntToStr(SelRect.Top)+']';
   SLines[4]:='Размеры: ['+IntToStr(Abs(SelRect.Right-SelRect.Left))+':'+IntToStr(Abs(SelRect.Bottom-SelRect.Top))+']';
  end;
end;

function GetResultRect:TRect;
begin
 Result:=SelRect;
 Result.Left:=Result.Left+1;
 Result.Top:=Result.Top+1;
 Result.Right:=Result.Right-1;
 Result.Bottom:=Result.Bottom-1;
end;

procedure LoadPicture(FM:TFileName);
begin
 AJPEG.LoadFromFile(FM);
 AH:=AJPEG.Height;
 AW:=AJPEG.Width;
 FormMain.DrawPanel.Width:=AW;
 FormMain.DrawPanel.Height:=AH;
 DrawBMP.Width:=AW;
 DrawBMP.Height:=AH;
 EPic:=True;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
 AJPEG:=TJPEGImage.Create;
 DrawBMP:=TBitmap.Create;
 TextBMP:=TBitmap.Create;
 TextBMP.Height:=DrawPanelInfo.Height;
 TextBMP.Width:=DrawPanelInfo.Width;
 TextBMP.Canvas.Font.Name:='Segoe UI';
 PrevBMP:=TBitmap.Create;
 PrevBMP.Height:=DrawPanelPreview.Height;
 PrevBMP.Width:=DrawPanelPreview.Width;
end;

procedure TFormMain.DrawPanelPaint(Sender: TObject);
begin
 DrawBMP.Canvas.Draw(0, 0, AJPEG);
 DrawBMP.Canvas.Brush.Style:=bsClear;
 DrawBMP.Canvas.Pen.Style:=psDot;
 DrawBMP.Canvas.Pen.Mode:=pmNot;
 DrawBMP.Canvas.Rectangle(SelRect);
 DrawPanel.Canvas.Draw(0, 0, DrawBMP);
end;

procedure TFormMain.TimerTimer(Sender: TObject);
begin
 DrawPanel.Repaint;
 DrawPanelInfo.Repaint;
 DrawPanelPreview.Repaint;
end;

procedure TFormMain.DrawPanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (X < AW) and (Y < AH) then IsDown:=True;
 OPos:=Point(X, Y);
end;

procedure TFormMain.DrawPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 IsDown:=False;
end;

procedure TFormMain.DrawPanelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var TX, TY:Integer;
begin
 if IsDown then
  begin
   TX:=X;
   TY:=Y;
   if X > AW then TX:=AW;
   if Y > AH then TY:=AH;
   if X < 0 then TX:=0;
   if Y < 0 then TY:=0;
   SelRect:=GetNormalRect(Rect(OPos.X, OPos.Y, TX, TY));
   DrawPanel.Repaint;
  end;
 MPos:=Point(X, Y);
 Info;
end;

procedure TFormMain.ButtonOpenPicClick(Sender: TObject);
begin
 if OpenPictureDialog.Execute then LoadPicture(OpenPictureDialog.FileName);
end;

procedure TFormMain.ButtonExeClick(Sender: TObject);
var BMP, BMPJPEG:TBitmap;
 SRect:TRect;
 i:Word;
 IsBreak:Boolean;
 Dir:string;
begin
 BMP:=TBitmap.Create;
 BMP.Width:=Abs(SelRect.Right-SelRect.Left);
 BMP.Height:=Abs(SelRect.Bottom-SelRect.Top);
 if (BMP.Height < 2) or (BMP.Width < 2) then
  begin
   MessageBox(Handle, 'Выделенная часть слишком мала!', '', MB_ICONWARNING or MB_OK);
   Exit;
  end;
 if DirectoryExists(EditDir.Text) then Dir:=EditDir.Text else Dir:=ExtractFilePath(ParamStr(0));
 IsBreak:=False;
 BMPJPEG:=TBitmap.Create;
 BMPJPEG.Assign(AJPEG);
 NJPEG:=TJPEGImage.Create;
 SRect:=SelRect;
 for i:=1 to SpinEditorCount.AsInteger do
  begin
   if i <> 1 then
    begin
     SRect.Left:=SRect.Left+SpinEditorStep.AsInteger;
     SRect.Right:=SRect.Left+BMP.Width;
    end;
   if SRect.Right > BMPJPEG.Width then
    begin
     IsBreak:=True;
     Break;
    end;
   BMP.Canvas.CopyRect(Rect(0, 0, BMP.Width, BMP.Height), BMPJPEG.Canvas, SRect);
   NJPEG.Assign(BMP);
   NJPEG.SaveToFile(Dir+'\Result'+IntToStr(i)+'.jpg');
  end;
 NJPEG.Free;
 BMP.Free;
 BMPJPEG.Free;
 if not IsBreak then MessageBox(Handle, 'Задача успешно выполнена!', '', MB_ICONINFORMATION or MB_OK)
 else MessageBox(Handle, 'Задача выполнена, но не до конца.'+#13#10+' Изображение слишком мало.', '', MB_ICONINFORMATION or MB_OK);
end;

procedure TFormMain.MenuItemExitClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TFormMain.ButtonOpenDirClick(Sender: TObject);
var Dir:string;
begin
 if AdvSelectDirectory('Выберите каталог, в который будут помещены части изображения', '', Dir, True, False, True) then
  EditDir.Text:=Dir;
end;

function GetNormalRect(ARect:TRect):TRect;
begin
 Result.Left:=Min(ARect.Left, ARect.Right);
 Result.Right:=Max(ARect.Left, ARect.Right);
 Result.Top:=Min(ARect.Top, ARect.Bottom);
 Result.Bottom:=Max(ARect.Top, ARect.Bottom);
end;

procedure TFormMain.DrawPanelInfoPaint(Sender: TObject);
var i:Byte;
begin
 TextBMP.Canvas.Brush.Color:=PanelMenu.Color;
 TextBMP.Canvas.FillRect(Rect(0, 0, TextBMP.Width, TextBMP.Height));
 for i:=1 to 6 do
  begin
   if SLines[i] <> '' then TextBMP.Canvas.TextOut(2, (i-1)*TextBMP.Canvas.TextHeight(SLines[i]), SLines[i]);
  end;
 DrawPanelInfo.Canvas.Draw(0, 0, TextBMP);
end;

procedure TFormMain.ButtonSetClick(Sender: TObject);
var A1, A2, A3, A4, i, Old_I:Integer;
 AText:string;

function DeleteSpace(SText:string):String;
begin
 Result:=SText;
 while Pos(' ', Result) <> 0 do Delete(Result, Pos(' ', Result), 1);
end;

begin
 AText:=DeleteSpace(EditSet.Text);
 A1:=-1;
 A2:=-1;
 A3:=-1;
 A4:=-1;
 Old_I:=0;
 for i:=1 to Length(AText)+1 do
  begin
   if (AText[i+1] = ',') or (i = Length(AText)) then
    begin
     if A1 = -1 then A1:=StrToInt(Copy(AText, Old_I+1, (i)-Old_I)) else       //Old_I = 2 i=4
      if A2 = -1 then A2:=StrToInt(Copy(AText, Old_I+1, (i)-Old_I)) else
       if A3 = -1 then A3:=StrToInt(Copy(AText, Old_I+1, (i)-Old_I)) else
        if A4 = -1 then A4:=StrToInt(Copy(AText, Old_I+1, (i)-Old_I)) else Break;
     Old_I:=i+1;
    end;
  end;
 if RadioButton1.Checked then SelRect:=Rect(A1, A2, A3, A4) else SelRect:=Rect(A1, A2, A1+A3, A2+A4);
 Info;
end;

function DestRect(W, H:Integer; NLeft:Integer): TRect;
var cw, ch: Integer;
    xyaspect: Double;
begin
 cw:=100;
 ch:=76;
 if (W = 0) or (H = 0) then Exit; 
 xyaspect:=w/h;
 if w > h then
  begin
   w:=cw;
   h:=Trunc(cw/xyaspect);
   if h > ch then  // woops, too big
    begin
     h:=ch;
     w:=Trunc(ch * xyaspect);
    end;
  end
 else
  begin
   h:=ch;
   w:=Trunc(ch * xyaspect);
   if w > cw then  // woops, too big
    begin
     w:=cw;
     h:=Trunc(cw/xyaspect);
    end;
  end;
 with Result do
  begin
   Left:=NLeft;
   Top:=2;
   Right:=Left+w;
   Bottom:=Top+h;
  end;
 //OffsetRect(Result, (cw - w) div 2, (ch - h) div 2);
end;

procedure TFormMain.DrawPanelPreviewPaint(Sender: TObject);
var i:Byte;
 NRect, DRect:TRect;
 HW:Integer;
 MYBMP:TBitmap;
 CNT:Word;
 IsBreak:Boolean;
begin
 if AJPEG.Empty then Exit;
 IsBreak:=False;
 MYBMP:=TBitmap.Create;
 MYBMP.Assign(AJPEG);
 PrevBMP.Width:=DrawPanelPreview.Width;
 PrevBMP.Canvas.Brush.Style:=bsSolid;
 PrevBMP.Canvas.Brush.Color:=clBlack;
 PrevBMP.Canvas.FillRect(Rect(0, 0, PrevBMP.Width, PrevBMP.Height));
 NRect:=SelRect;
 HW:=Abs(NRect.Left-NRect.Right);
 if SpinEditorCount.AsInteger < (DrawPanelPreview.Width div 100) then CNT:=SpinEditorCount.AsInteger
 else CNT:=(DrawPanelPreview.Width div 100);
 for i:=0 to CNT-1 do
  begin
   NRect.Left:=NRect.Left+SpinEditorStep.AsInteger;
   NRect.Right:=NRect.Left+HW;
   if NRect.Right > AW then
    begin
     IsBreak:=True;
     Break;
    end;
   DRect:=DestRect(Abs(NRect.Left-NRect.Right), Abs(NRect.Top-NRect.Bottom), (i*102));
   PrevBMP.Canvas.CopyRect(DRect, MYBMP.Canvas, NRect);
   PrevBMP.Canvas.Font.Color:=clWhite;
   PrevBMP.Canvas.TextOut(DRect.Left, DRect.Top, IntToStr(i+1));
  end;
 if IsBreak then SLines[5]:='Статус: Неудача' else SLines[5]:='Статус: Успех';
 Info;
 MYBMP.Free;
 DrawPanelPreview.Canvas.Draw(0, 0, PrevBMP);
end;

end.
