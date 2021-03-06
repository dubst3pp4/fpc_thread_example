program threadexample;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp,
  { you can add units after this }
  FPTimer;

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
    FTimer  : TFPTimer;
    procedure DoRun; override;
    procedure CreateAndStartThread;
    procedure OnTimerTick( Sender : TObject);
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
    WriteLn('Thread: ' + IntToStr(SecondCount));
    Sleep(WaitSeconds * 1000);
    SecondCount := SecondCount - 1;
  until SecondCount = 0;
  WriteLn('Thread: ' + IntToStr(SecondCount));
end;

{ TThreadExample }

procedure TThreadExample.DoRun;
var
  ErrorMsg : String;
begin

  { add your program heore }
  CreateAndStartThread;
  FTimer.StartTimer;

  while FTimer.Enabled do
  begin
    WriteLn('Main: waiting...');
    CheckSynchronize;
    Sleep(500);
  end;

  // stop program loop
  Terminate;
end;

constructor TThreadExample.Create(TheOwner : TComponent);
begin
  inherited Create(TheOwner);
  StopOnException := True;

  FTimer := TFPTimer.Create(self);
  FTimer.Enabled  := false;
  FTimer.Interval := 5000;
  FTimer.OnTimer  := @OnTimerTick;
end;

destructor TThreadExample.Destroy;
begin
  inherited Destroy;
end;

procedure TThreadExample.CreateAndStartThread;
begin
  if Assigned(FThread) and (not FThread.Finished) then
    raise Exception.Create('Timer: Thread is already running.');
  if Assigned(FThread) and FThread.Finished then
    FThread := nil;
  FThread := TCountDownThread.Create(true);
  FThread.Resume;
  WriteLn('Timer: Thread started');
end;

procedure TThreadExample.OnTimerTick(Sender : TObject);
begin
  WriteLn('--- Tick ---');
  try
    WriteLn('Timer: trying to start Thread');
    CreateAndStartThread;
  except
    on e : Exception do
      WriteLn(e.Message);
  end;
end;

var
  Application : TThreadExample;
begin
  Application := TThreadExample.Create(nil);
  Application.Title := 'Thread Example';
  Application.Run;
  Application.Free;
end.

