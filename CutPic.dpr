program CutPic;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  DeleteScans in 'DeleteScans.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
