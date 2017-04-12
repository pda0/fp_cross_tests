{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TByteHelper;

{$DEFINE TEST_UNIT}
{$IFDEF FPC}{$I fpc.inc}{$ELSE}{$I delphi.inc}{$ENDIF}
{$IFDEF DELPHI_XE4_PLUS}{$LEGACYIFEND ON}{$ENDIF}

interface

uses
  {$IFDEF FPC}
  fpcunit, testregistry,
  {$ELSE}
  TestFramework,
  {$ENDIF}
  Classes, SysUtils;

type
  TestTByteHelper = class(TTestCase)
  private
    FBadValue: string;
    procedure BadParse;
  published
    procedure TestMinValue;
    procedure TestMaxValue;
    procedure TestSize;
    procedure TestToString1;
    procedure TestToString2;
    procedure TestToHexString1;
    procedure TestToHexString2;
    procedure TestToBoolean;
    {$IF DECLARED(Single)}
    procedure TestToSingle;
    {$IFEND}
    {$IF DECLARED(Double)}
    procedure TestToDouble;
    {$IFEND}
    {$IF DECLARED(Extended)}
    procedure TestToExtended;
    {$IFEND}
    procedure TestParse;
    procedure TestTryParse;
  end;

implementation

{ TestTByteHelper }

procedure TestTByteHelper.TestMinValue;
begin
  CheckEquals(0, Byte.MinValue);
end;

procedure TestTByteHelper.TestMaxValue;
begin
  CheckEquals(255, Byte.MaxValue);
end;

procedure TestTByteHelper.TestSize;
begin
  CheckEquals(SizeOf(Byte), Byte.Size);
end;

procedure TestTByteHelper.TestToString1;
var
  Value: Byte;
begin
  Value := 0;
  CheckEquals('0', Value.ToString);

  Value := 100;
  CheckEquals('100', Value.ToString);

  Value := 255;
  CheckEquals('255', Value.ToString);
end;

procedure TestTByteHelper.TestToString2;
begin
  CheckEquals('0', Byte.ToString(0));

  CheckEquals('100', Byte.ToString(100));

  CheckEquals('255', Byte.ToString(255));
end;

procedure TestTByteHelper.TestToHexString1;
var
  Value: Byte;
begin
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := 0;
  CheckEquals('00', Value.ToHexString);

  Value := 15;
  CheckEquals('0F', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := 0;
  CheckEquals('0', Value.ToHexString);

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString));
  {$IFEND}

  Value := 100;
  CheckEquals('64', UpperCase(Value.ToHexString));

  Value := 255;
  CheckEquals('FF', UpperCase(Value.ToHexString));
end;

procedure TestTByteHelper.TestToHexString2;
var
  Value: Byte;
begin
  Value := 0;
  CheckEquals('0', Value.ToHexString(0));
  CheckEquals('0', Value.ToHexString(1));
  CheckEquals('00', Value.ToHexString(2));
  CheckEquals('000', Value.ToHexString(3));

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString(0)));
  CheckEquals('F', UpperCase(Value.ToHexString(1)));
  CheckEquals('0F', UpperCase(Value.ToHexString(2)));
  CheckEquals('00F', UpperCase(Value.ToHexString(3)));

  Value := 100;
  CheckEquals('64', UpperCase(Value.ToHexString(0)));
  CheckEquals('64', UpperCase(Value.ToHexString(1)));
  CheckEquals('64', UpperCase(Value.ToHexString(2)));
  CheckEquals('064', UpperCase(Value.ToHexString(3)));

  Value := 255;
  CheckEquals('FF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FF', UpperCase(Value.ToHexString(2)));
  CheckEquals('0FF', UpperCase(Value.ToHexString(3)));
end;

procedure TestTByteHelper.TestToBoolean;
var
  Value: Byte;
begin
  Value := 0;
  CheckFalse(Value.ToBoolean);

  Value := 100;
  CheckTrue(Value.ToBoolean);

  Value := 255;
  CheckTrue(Value.ToBoolean);
end;

{$IF DECLARED(Single)}
procedure TestTByteHelper.TestToSingle;
var
  Value: Byte;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToSingle, Single.Epsilon);

  Value := 100;
  CheckEquals(100.0, Value.ToSingle, Single.Epsilon);

  Value := 255;
  CheckEquals(255.0, Value.ToSingle, Single.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Double)}
procedure TestTByteHelper.TestToDouble;
var
  Value: Byte;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToDouble, Double.Epsilon);

  Value := 100;
  CheckEquals(100.0, Value.ToDouble, Double.Epsilon);

  Value := 255;
  CheckEquals(255.0, Value.ToDouble, Double.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Extended)}
procedure TestTByteHelper.TestToExtended;
var
  Value: Byte;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToExtended, Extended.Epsilon);

  Value := 100;
  CheckEquals(100.0, Value.ToExtended, Extended.Epsilon);

  Value := 255;
  CheckEquals(255.0, Value.ToExtended, Extended.Epsilon);
end;
{$IFEND}

procedure TestTByteHelper.BadParse;
begin
  Byte.Parse(FBadValue);
end;

procedure TestTByteHelper.TestParse;
begin
  CheckEquals(0, Byte.Parse('0'));
  CheckEquals(0, Byte.Parse('000'));
  CheckEquals(0, Byte.Parse('+000'));
  CheckEquals(0, Byte.Parse('-000'));

  CheckEquals(100, Byte.Parse('100'));
  CheckEquals(100, Byte.Parse('0100'));
  CheckEquals(100, Byte.Parse('+100'));
  CheckEquals(100, Byte.Parse('+0100'));

  CheckEquals(255, Byte.Parse('255'));

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  FBadValue := '-1';
  CheckException(BadParse, EConvertError);

  FBadValue := '256';
  CheckException(BadParse, EConvertError);
  {$IFEND}

  FBadValue := '';
  CheckException(BadParse, EConvertError);

  FBadValue := '+';
  CheckException(BadParse, EConvertError);

  FBadValue := '-';
  CheckException(BadParse, EConvertError);

  FBadValue := 'INF';
  CheckException(BadParse, EConvertError);

  FBadValue := '+INF';
  CheckException(BadParse, EConvertError);

  FBadValue := '-INF';
  CheckException(BadParse, EConvertError);

  FBadValue := 'NAN';
  CheckException(BadParse, EConvertError);

  FBadValue := '**INVALID**';
  CheckException(BadParse, EConvertError);

  FBadValue := '1' + FormatSettings.DecimalSeparator + '0';
  CheckException(BadParse, EConvertError);
end;

procedure TestTByteHelper.TestTryParse;
var
  CheckValue: Byte;
begin
  CheckTrue(Byte.TryParse('0', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Byte.TryParse('000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Byte.TryParse('+000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Byte.TryParse('-000', CheckValue));
  CheckEquals(0, CheckValue);

  CheckTrue(Byte.TryParse('100', CheckValue));
  CheckEquals(100, CheckValue);
  CheckTrue(Byte.TryParse('0100', CheckValue));
  CheckEquals(100, CheckValue);
  CheckTrue(Byte.TryParse('+100', CheckValue));
  CheckEquals(100, CheckValue);
  CheckTrue(Byte.TryParse('+0100', CheckValue));
  CheckEquals(100, CheckValue);

  CheckTrue(Byte.TryParse('255', CheckValue));
  CheckEquals(255, CheckValue);

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  CheckFalse(Byte.TryParse('-1', CheckValue));
  CheckFalse(Byte.TryParse('256', CheckValue));
  {$IFEND}
  CheckFalse(Byte.TryParse('', CheckValue));
  CheckFalse(Byte.TryParse('+', CheckValue));
  CheckFalse(Byte.TryParse('-', CheckValue));
  CheckFalse(Byte.TryParse('INF', CheckValue));
  CheckFalse(Byte.TryParse('+INF', CheckValue));
  CheckFalse(Byte.TryParse('-INF', CheckValue));
  CheckFalse(Byte.TryParse('NAN', CheckValue));
  CheckFalse(Byte.TryParse('**INVALID**', CheckValue));
  CheckFalse(Byte.TryParse('1' + FormatSettings.DecimalSeparator + '0', CheckValue));
end;

initialization
  RegisterTest('System.SysUtils', TestTByteHelper.Suite);

end.

