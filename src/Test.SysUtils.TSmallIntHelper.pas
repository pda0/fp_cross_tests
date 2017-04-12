{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TSmallIntHelper;

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
  TestTSmallIntHelper = class(TTestCase)
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

{ TestTSmallIntHelper }

procedure TestTSmallIntHelper.TestMinValue;
begin
  CheckEquals(-32768, SmallInt.MinValue);
end;

procedure TestTSmallIntHelper.TestMaxValue;
begin
  CheckEquals(32767, SmallInt.MaxValue);
end;

procedure TestTSmallIntHelper.TestSize;
begin
  CheckEquals(SizeOf(SmallInt), SmallInt.Size);
end;

procedure TestTSmallIntHelper.TestToString1;
var
  Value: SmallInt;
begin
  Value := 0;
  CheckEquals('0', Value.ToString);

  Value := 500;
  CheckEquals('500', Value.ToString);

  Value := 32767;
  CheckEquals('32767', Value.ToString);

  Value := -500;
  CheckEquals('-500', Value.ToString);

  Value := -32768;
  CheckEquals('-32768', Value.ToString);
end;

procedure TestTSmallIntHelper.TestToString2;
begin
  CheckEquals('0', SmallInt.ToString(0));

  CheckEquals('500', SmallInt.ToString(500));

  CheckEquals('32767', SmallInt.ToString(32767));

  CheckEquals('-500', SmallInt.ToString(-500));

  CheckEquals('-32768', SmallInt.ToString(-32768));
end;

procedure TestTSmallIntHelper.TestToHexString1;
var
  Value: SmallInt;
begin
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := 0;
  CheckEquals('0000', Value.ToHexString);

  Value := 15;
  CheckEquals('000F', UpperCase(Value.ToHexString));

  Value := 255;
  CheckEquals('00FF', UpperCase(Value.ToHexString));

  Value := 4095;
  CheckEquals('0FFF', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := 0;
  CheckEquals('0', Value.ToHexString);

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString));

  Value := 255;
  CheckEquals('FF', UpperCase(Value.ToHexString));

  Value := 4095;
  CheckEquals('FFF', UpperCase(Value.ToHexString));
  {$IFEND}

  Value := 32767;
  CheckEquals('7FFF', UpperCase(Value.ToHexString));

  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := -15;
  CheckEquals('FFF1', UpperCase(Value.ToHexString));

  Value := -255;
  CheckEquals('FF01', UpperCase(Value.ToHexString));

  Value := -4095;
  CheckEquals('F001', UpperCase(Value.ToHexString));

  Value := -32768;
  CheckEquals('8000', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := -15;
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString));

  Value := -255;
  CheckEquals('FFFFFF01', UpperCase(Value.ToHexString));

  Value := -4095;
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString));

  Value := -32768;
  CheckEquals('FFFF8000', UpperCase(Value.ToHexString));
  {$IFEND}
end;

procedure TestTSmallIntHelper.TestToHexString2;
var
  Value: SmallInt;
begin
  Value := 0;
  CheckEquals('0', Value.ToHexString(0));
  CheckEquals('0', Value.ToHexString(1));
  CheckEquals('00', Value.ToHexString(2));
  CheckEquals('000', Value.ToHexString(3));
  CheckEquals('0000', Value.ToHexString(4));
  CheckEquals('00000', Value.ToHexString(5));

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString(0)));
  CheckEquals('F', UpperCase(Value.ToHexString(1)));
  CheckEquals('0F', UpperCase(Value.ToHexString(2)));
  CheckEquals('00F', UpperCase(Value.ToHexString(3)));
  CheckEquals('000F', UpperCase(Value.ToHexString(4)));
  CheckEquals('0000F', UpperCase(Value.ToHexString(5)));

  Value := 255;
  CheckEquals('FF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FF', UpperCase(Value.ToHexString(2)));
  CheckEquals('0FF', UpperCase(Value.ToHexString(3)));
  CheckEquals('00FF', UpperCase(Value.ToHexString(4)));
  CheckEquals('000FF', UpperCase(Value.ToHexString(5)));

  Value := 4095;
  CheckEquals('FFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('0FFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('00FFF', UpperCase(Value.ToHexString(5)));

  Value := 32767;
  CheckEquals('7FFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('7FFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('7FFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('7FFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('7FFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('07FFF', UpperCase(Value.ToHexString(5)));

  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := -15;
  CheckEquals('F1', UpperCase(Value.ToHexString(0)));
  CheckEquals('F1', UpperCase(Value.ToHexString(1)));
  CheckEquals('F1', UpperCase(Value.ToHexString(2)));
  CheckEquals('FF1', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFF1', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFF1', UpperCase(Value.ToHexString(5)));

  Value := -255;
  CheckEquals('F01', UpperCase(Value.ToHexString(0)));
  CheckEquals('F01', UpperCase(Value.ToHexString(1)));
  CheckEquals('F01', UpperCase(Value.ToHexString(2)));
  CheckEquals('F01', UpperCase(Value.ToHexString(3)));
  CheckEquals('FF01', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFF01', UpperCase(Value.ToHexString(5)));

  Value := -4095;
  CheckEquals('F001', UpperCase(Value.ToHexString(0)));
  CheckEquals('F001', UpperCase(Value.ToHexString(1)));
  CheckEquals('F001', UpperCase(Value.ToHexString(2)));
  CheckEquals('F001', UpperCase(Value.ToHexString(3)));
  CheckEquals('F001', UpperCase(Value.ToHexString(4)));
  CheckEquals('FF001', UpperCase(Value.ToHexString(5)));

  Value := -32768;
  CheckEquals('8000', UpperCase(Value.ToHexString(0)));
  CheckEquals('8000', UpperCase(Value.ToHexString(1)));
  CheckEquals('8000', UpperCase(Value.ToHexString(2)));
  CheckEquals('8000', UpperCase(Value.ToHexString(3)));
  CheckEquals('8000', UpperCase(Value.ToHexString(4)));
  CheckEquals('F8000', UpperCase(Value.ToHexString(5)));
  {$ELSE}
  { Obsolete }
  Value := -15;
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFFFFF1', UpperCase(Value.ToHexString(5)));

  Value := -255;
  CheckEquals('FFFFFF01', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFFF01', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFFF01', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFFF01', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFFFF01', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFFFF01', UpperCase(Value.ToHexString(5)));

  Value := -4095;
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFFF001', UpperCase(Value.ToHexString(5)));

  Value := -32768;
  CheckEquals('FFFF8000', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFF8000', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFF8000', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFF8000', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFF8000', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFF8000', UpperCase(Value.ToHexString(5)));
  {$IFEND}
end;

procedure TestTSmallIntHelper.TestToBoolean;
var
  Value: SmallInt;
begin
  Value := 0;
  CheckFalse(Value.ToBoolean);

  Value := 500;
  CheckTrue(Value.ToBoolean);

  Value := 32767;
  CheckTrue(Value.ToBoolean);

  Value := -500;
  CheckTrue(Value.ToBoolean);

  Value := -32768;
  CheckTrue(Value.ToBoolean);
end;

{$IF DECLARED(Single)}
procedure TestTSmallIntHelper.TestToSingle;
var
  Value: SmallInt;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToSingle, Single.Epsilon);

  Value := 500;
  CheckEquals(500.0, Value.ToSingle, Single.Epsilon);

  Value := 32767;
  CheckEquals(32767.0, Value.ToSingle, Single.Epsilon);

  Value := -500;
  CheckEquals(-500.0, Value.ToSingle, Single.Epsilon);

  Value := -32768;
  CheckEquals(-32768.0, Value.ToSingle, Single.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Double)}
procedure TestTSmallIntHelper.TestToDouble;
var
  Value: SmallInt;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToDouble, Double.Epsilon);

  Value := 500;
  CheckEquals(500.0, Value.ToDouble, Double.Epsilon);

  Value := 32767;
  CheckEquals(32767.0, Value.ToDouble, Double.Epsilon);

  Value := -500;
  CheckEquals(-500.0, Value.ToDouble, Double.Epsilon);

  Value := -32768;
  CheckEquals(-32768.0, Value.ToDouble, Double.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Extended)}
procedure TestTSmallIntHelper.TestToExtended;
var
  Value: SmallInt;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToExtended, Extended.Epsilon);

  Value := 500;
  CheckEquals(500.0, Value.ToExtended, Extended.Epsilon);

  Value := 32767;
  CheckEquals(32767.0, Value.ToExtended, Extended.Epsilon);

  Value := -500;
  CheckEquals(-500.0, Value.ToExtended, Extended.Epsilon);

  Value := -32768;
  CheckEquals(-32768.0, Value.ToExtended, Extended.Epsilon);
end;
{$IFEND}

procedure TestTSmallIntHelper.BadParse;
begin
  SmallInt.Parse(FBadValue);
end;

procedure TestTSmallIntHelper.TestParse;
begin
  CheckEquals(0, SmallInt.Parse('0'));
  CheckEquals(0, SmallInt.Parse('000'));
  CheckEquals(0, SmallInt.Parse('+000'));
  CheckEquals(0, SmallInt.Parse('-000'));

  CheckEquals(500, SmallInt.Parse('500'));
  CheckEquals(500, SmallInt.Parse('0500'));
  CheckEquals(500, SmallInt.Parse('+500'));
  CheckEquals(500, SmallInt.Parse('+0500'));

  CheckEquals(32767, SmallInt.Parse('32767'));

  CheckEquals(-500, SmallInt.Parse('-500'));
  CheckEquals(-500, SmallInt.Parse('-0500'));

  CheckEquals(-32768, SmallInt.Parse('-32768'));

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  FBadValue := '-32769';
  CheckException(BadParse, EConvertError);

  FBadValue := '32768';
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

procedure TestTSmallIntHelper.TestTryParse;
var
  CheckValue: SmallInt;
begin
  CheckTrue(SmallInt.TryParse('0', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(SmallInt.TryParse('000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(SmallInt.TryParse('+000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(SmallInt.TryParse('-000', CheckValue));
  CheckEquals(0, CheckValue);

  CheckTrue(SmallInt.TryParse('500', CheckValue));
  CheckEquals(500, CheckValue);
  CheckTrue(SmallInt.TryParse('0500', CheckValue));
  CheckEquals(500, CheckValue);
  CheckTrue(SmallInt.TryParse('+500', CheckValue));
  CheckEquals(500, CheckValue);
  CheckTrue(SmallInt.TryParse('+0500', CheckValue));
  CheckEquals(500, CheckValue);

  CheckTrue(SmallInt.TryParse('32767', CheckValue));
  CheckEquals(32767, CheckValue);

  CheckTrue(SmallInt.TryParse('-500', CheckValue));
  CheckEquals(-500, CheckValue);
  CheckTrue(SmallInt.TryParse('-0500', CheckValue));
  CheckEquals(-500, CheckValue);

  CheckTrue(SmallInt.TryParse('-32768', CheckValue));
  CheckEquals(-32768, CheckValue);

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  CheckFalse(SmallInt.TryParse('-32769', CheckValue));
  CheckFalse(SmallInt.TryParse('32768', CheckValue));
  {$IFEND}
  CheckFalse(SmallInt.TryParse('', CheckValue));
  CheckFalse(SmallInt.TryParse('+', CheckValue));
  CheckFalse(SmallInt.TryParse('-', CheckValue));
  CheckFalse(SmallInt.TryParse('INF', CheckValue));
  CheckFalse(SmallInt.TryParse('+INF', CheckValue));
  CheckFalse(SmallInt.TryParse('-INF', CheckValue));
  CheckFalse(SmallInt.TryParse('NAN', CheckValue));
  CheckFalse(SmallInt.TryParse('**INVALID**', CheckValue));
  CheckFalse(SmallInt.TryParse('1' + FormatSettings.DecimalSeparator + '0', CheckValue));
end;

initialization
  RegisterTest('System.SysUtils', TestTSmallIntHelper.Suite);

end.
