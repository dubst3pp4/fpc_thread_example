program threadexample;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  TCountDownThread = class(TThread)
  protected
    procedure Execute; override;
  public
    constructor Create(StartSuspended : boolean);
  end;

  { TThreadExample }

  TThreadExample = class(TCustomApplication)
  protected
    FThread : TCountDownThread;
    procedure DoRun; override;
  public
    constructor Create(TheOwner : TComponent); override;
    destructor Destroy; override;
  end;


{ TCountDownThread }

constructor TCountDownThread.Create(StartSuspended : boolean);
begin
  FreeOnTerminate := true;
  inherited Create(StartSuspended);
end;

procedure TCountDownThread.Execute;
var
  WaitSeconds, MaxSeconds, SecondCount : integer;
begin
  WaitSeconds := 1;
  MaxSeconds  := 10;
  SecondCount := MaxSeconds;
  repeat
    WriteLn(SecondCount);
    Sleep(WaitSeconds * 1000);
    SecondCount := SecondCount - 1;
  until SecondCount = 0;
  WriteLn(SecondCount);
end;

{ TThreadExample }

procedure TThreadExample.DoRun;
var
  ErrorMsg : String;
begin

  { add your program heore }
  FThread.Resume;

  while (not FThread.Finished) do
  begin
    WriteLn('waiting for thread to finish');
    Sleep(100);
  end;

  // stop program loop
  Terminate;
end;

constructor TThreadExample.Create(TheOwner : TComponent);
begin
  inherited Create(TheOwner);
  StopOnException := True;
  FThread := TCountDownThread.Create(true);
end;

destructor TThreadExample.Destroy;
begin
  inherited Destroy;
end;

var
  Application : TThreadExample;
begin
  Application := TThreadExample.Create(nil);
  Application.Title := 'Thread Example';
  Application.Run;
  Application.Free;
end.

