{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TCardinalHelper;

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
  TestTCardinalHelper = class(TTestCase)
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

{ TestTCardinalHelper }

procedure TestTCardinalHelper.TestMinValue;
begin
  CheckEquals(0, Cardinal.MinValue);
end;

procedure TestTCardinalHelper.TestMaxValue;
begin
  CheckEquals(4294967295, Cardinal.MaxValue);
end;

procedure TestTCardinalHelper.TestSize;
begin
  CheckEquals(SizeOf(Cardinal), Cardinal.Size);
end;

procedure TestTCardinalHelper.TestToString1;
var
  Value: Cardinal;
begin
  Value := 0;
  CheckEquals('0', Value.ToString);

  Value := 70000;
  CheckEquals('70000', Value.ToString);

  Value := 4294967295;
  CheckEquals('4294967295', Value.ToString);
end;

procedure TestTCardinalHelper.TestToString2;
begin
  CheckEquals('0', Cardinal.ToString(0));

  CheckEquals('70000', Cardinal.ToString(70000));

  CheckEquals('4294967295', Cardinal.ToString(4294967295));
end;

procedure TestTCardinalHelper.TestToHexString1;
var
  Value: Cardinal;
begin
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  Value := 0;
  CheckEquals('00000000', Value.ToHexString);

  Value := 15;
  CheckEquals('0000000F', UpperCase(Value.ToHexString));

  Value := 4095;
  CheckEquals('00000FFF', UpperCase(Value.ToHexString));

  Value := 16777215;
  CheckEquals('00FFFFFF', UpperCase(Value.ToHexString));
  {$ELSE}
  { Obsolete }
  Value := 0;
  CheckEquals('0', Value.ToHexString);

  Value := 15;
  CheckEquals('F', UpperCase(Value.ToHexString));

  Value := 4095;
  CheckEquals('FFF', UpperCase(Value.ToHexString));

  Value := 16777215;
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString));
  {$IFEND}

  Value := 4294967295;
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString));
end;

procedure TestTCardinalHelper.TestToHexString2;
var
  Value: Cardinal;
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
  CheckEquals('00000F', UpperCase(Value.ToHexString(6)));
  CheckEquals('000000F', UpperCase(Value.ToHexString(7)));
  CheckEquals('0000000F', UpperCase(Value.ToHexString(8)));
  CheckEquals('00000000F', UpperCase(Value.ToHexString(9)));

  Value := 4095;
  CheckEquals('FFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('0FFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('00FFF', UpperCase(Value.ToHexString(5)));
  CheckEquals('000FFF', UpperCase(Value.ToHexString(6)));
  CheckEquals('0000FFF', UpperCase(Value.ToHexString(7)));
  CheckEquals('00000FFF', UpperCase(Value.ToHexString(8)));
  CheckEquals('000000FFF', UpperCase(Value.ToHexString(9)));

  Value := 16777215;
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(5)));
  CheckEquals('FFFFFF', UpperCase(Value.ToHexString(6)));
  CheckEquals('0FFFFFF', UpperCase(Value.ToHexString(7)));
  CheckEquals('00FFFFFF', UpperCase(Value.ToHexString(8)));
  CheckEquals('000FFFFFF', UpperCase(Value.ToHexString(9)));

  Value := 4294967295;
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(0)));
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(1)));
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(2)));
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(3)));
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(4)));
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(5)));
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(6)));
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(7)));
  CheckEquals('FFFFFFFF', UpperCase(Value.ToHexString(8)));
  CheckEquals('0FFFFFFFF', UpperCase(Value.ToHexString(9)));
end;

procedure TestTCardinalHelper.TestToBoolean;
var
  Value: Cardinal;
begin
  Value := 0;
  CheckFalse(Value.ToBoolean);

  Value := 70000;
  CheckTrue(Value.ToBoolean);

  Value := 4294967295;
  CheckTrue(Value.ToBoolean);
end;

{$IF DECLARED(Single)}
procedure TestTCardinalHelper.TestToSingle;
var
  Value: Cardinal;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToSingle, Single.Epsilon);

  Value := 70000;
  CheckEquals(70000.0, Value.ToSingle, Single.Epsilon);

  Value := 4294967295;
  CheckEquals(4294967295.0, Value.ToSingle, 1); { Single is unable to fit this number }
end;
{$IFEND}

{$IF DECLARED(Double)}
procedure TestTCardinalHelper.TestToDouble;
var
  Value: Cardinal;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToDouble, Double.Epsilon);

  Value := 70000;
  CheckEquals(70000.0, Value.ToDouble, Double.Epsilon);

  Value := 4294967295;
  CheckEquals(4294967295.0, Value.ToDouble, Double.Epsilon);
end;
{$IFEND}

{$IF DECLARED(Extended)}
procedure TestTCardinalHelper.TestToExtended;
var
  Value: Cardinal;
begin
  Value := 0;
  CheckEquals(0.0, Value.ToExtended, Extended.Epsilon);

  Value := 70000;
  CheckEquals(70000.0, Value.ToExtended, Extended.Epsilon);

  Value := 4294967295;
  CheckEquals(4294967295.0, Value.ToExtended, Extended.Epsilon);
end;
{$IFEND}

procedure TestTCardinalHelper.BadParse;
begin
  Cardinal.Parse(FBadValue);
end;

procedure TestTCardinalHelper.TestParse;
begin
  CheckEquals(0, Cardinal.Parse('0'));
  CheckEquals(0, Cardinal.Parse('000'));
  CheckEquals(0, Cardinal.Parse('+000'));
  CheckEquals(0, Cardinal.Parse('-000'));

  CheckEquals(70000, Cardinal.Parse('70000'));
  CheckEquals(70000, Cardinal.Parse('070000'));
  CheckEquals(70000, Cardinal.Parse('+70000'));
  CheckEquals(70000, Cardinal.Parse('+070000'));

  // DELPHI BUG CheckEquals(4294967295, Cardinal.Parse('4294967295'));

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  FBadValue := '-1';
  CheckException(BadParse, EConvertError);

  FBadValue := '4294967296';
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

procedure TestTCardinalHelper.TestTryParse;
var
  CheckValue: Cardinal;
begin
  CheckTrue(Cardinal.TryParse('0', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Cardinal.TryParse('000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Cardinal.TryParse('+000', CheckValue));
  CheckEquals(0, CheckValue);
  CheckTrue(Cardinal.TryParse('-000', CheckValue));
  CheckEquals(0, CheckValue);

  CheckTrue(Cardinal.TryParse('70000', CheckValue));
  CheckEquals(70000, CheckValue);
  CheckTrue(Cardinal.TryParse('070000', CheckValue));
  CheckEquals(70000, CheckValue);
  CheckTrue(Cardinal.TryParse('+70000', CheckValue));
  CheckEquals(70000, CheckValue);
  CheckTrue(Cardinal.TryParse('+070000', CheckValue));
  CheckEquals(70000, CheckValue);

  CheckTrue(Cardinal.TryParse('4294967295', CheckValue));
  CheckEquals(4294967295, CheckValue);

  { Strange and invalid values }
  {$IF DEFINED(FPC) OR DEFINED(DELPHI_TOKYO_PLUS)}
  CheckFalse(Cardinal.TryParse('-1', CheckValue));
  CheckFalse(Cardinal.TryParse('4294967296', CheckValue));
  {$IFEND}
  CheckFalse(Cardinal.TryParse('', CheckValue));
  CheckFalse(Cardinal.TryParse('+', CheckValue));
  CheckFalse(Cardinal.TryParse('-', CheckValue));
  CheckFalse(Cardinal.TryParse('INF', CheckValue));
  CheckFalse(Cardinal.TryParse('+INF', CheckValue));
  CheckFalse(Cardinal.TryParse('-INF', CheckValue));
  CheckFalse(Cardinal.TryParse('NAN', CheckValue));
  CheckFalse(Cardinal.TryParse('**INVALID**', CheckValue));
  CheckFalse(Cardinal.TryParse('1' + FormatSettings.DecimalSeparator + '0', CheckValue));
end;

initialization
  RegisterTest('System.SysUtils', TestTCardinalHelper.Suite);

end.
