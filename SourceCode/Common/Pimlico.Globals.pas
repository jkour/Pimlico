//****************************************************************************
// Copyright 2016 by John Kouraklis
// Email : j_kour@hotmail.com
//
// See License file for details
//
//****************************************************************************
unit Pimlico.Globals;

interface

uses
	System.SysUtils;

type

  TGlobals<T: IInterface> = class
  private
    class var fInstance: T;
  public
    class function Instance: T;
    class procedure createInstance(aCreateFunc: TFunc<T>);
  end;

implementation

{$REGION 'TGlobals<T>'}

class procedure TGlobals<T>.createInstance(aCreateFunc: TFunc<T>);
begin
  fInstance:=aCreateFunc;
end;

class function TGlobals<T>.Instance: T;
begin
  if not Assigned(fInstance) then
    raise  Exception.Create('Call createInstance first to instantiate');
  Result:=fInstance;
end;

{$ENDREGION}

end.
