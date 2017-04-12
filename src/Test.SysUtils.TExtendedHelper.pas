{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.SysUtils.TExtendedHelper;

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
  Classes, SysUtils, Test.TFloatHelper;

{$IF (DEFINED(FPC) AND DECLARED(Extended)) OR DEFINED(DELPHI_XE2_PLUS)}
  {$DEFINE RUN_TESTS}
{$IFEND}

{$IF DEFINED(FPC) AND DECLARED(Extended)}
  {$IF (SIZEOF(Extended) = 10)}
    {$IFNDEF CPUEXTENDED}{$DEFINE CPUEXTENDED}{$ENDIF}
  {$ELSEIF (SIZEOF(Extended) <> 8)}
  { According to Free Pascal docs (http://www.freepascal.org/docs-html/3.0.0/prog/progsu160.html)
    Extended type can be an alias to Single at machines without FPU. Will not
    test this case, at least for now. }
    {$IFDEF RUN_TESTS}{$UNDEF RUN_TESTS}{$ENDIF}
  {$IFEND}
{$IFEND}

type
  TestTExtendedHelper = class(TFloatHelper)
  private
    {$IFDEF RUN_TESTS}
    FBadString: string;
    FBadFormat: TFormatSettings;
    procedure PrepareValues(out Zero, NZero, SubNormalMin, SubNormalMid,
      SubNormalMax, NSubNormalMin, NSubNormalMid, NSubNormalMax, NormalMin,
      NormalMid, NormalMax, NNormalMin, NNormalMid, NNormalMax, Inf, NInf, NaN1,
      NaN2, NaN3, NaN4, NaN5, NaN6: Extended);
    procedure BytesRangeOverflow;
    procedure WordsRangeOverflow;
    procedure BadParse1;
    procedure BadParse2;
    {$ENDIF}
  published
    procedure TestEpsilon;
    procedure TestMaxValue;
    procedure TestMinValue;
    procedure TestPositiveInfinity;
    procedure TestNegativeInfinity;
    procedure TestNaN;
    procedure TestExponent;
    procedure TestFraction;
    procedure TestMantissa;
    procedure TestSign;
    procedure TestExp;
    procedure TestFrac;
    procedure TestSpecialType;
    procedure TestBuildUp;
    procedure TestToString1;
    procedure TestToString2;
    procedure TestToString3;
    procedure TestToString4;
    procedure TestIsNan;
    procedure TestIsInfinity;
    procedure TestIsNegativeInfinity;
    procedure TestIsPositiveInfinity;
    procedure TestBytes;
    procedure TestWords;
    procedure TestParse1;
    procedure TestParse2;
    procedure TestTryParse1;
    procedure TestTryParse2;
    procedure TestSize;
  end;

implementation

{$IFNDEF FPC}
uses
  System.SysConst;
{$ENDIF}

{ TestTExtendedHelper }

{$IFDEF RUN_TESTS}
procedure TestTExtendedHelper.PrepareValues(out Zero, NZero, SubNormalMin,
  SubNormalMid, SubNormalMax, NSubNormalMin, NSubNormalMid, NSubNormalMax,
  NormalMin, NormalMid, NormalMax, NNormalMin, NNormalMid, NNormalMax, Inf,
  NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Extended);
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00, $00, $00); { 0 000000000000000 0000000000000000000000000000000000000000000000000000000000000000 }
  Zero := Value;

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00, $00, $00); { 1 000000000000000 0000000000000000000000000000000000000000000000000000000000000000 }
  NZero := Value;

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00, $00, $01); { 0 000000000000000 0000000000000000000000000000000000000000000000000000000000000001 }
  SubNormalMin := Value;

  ValueArray := MakeExtended($00, $00, $80, $00, $00, $00, $00, $00, $00, $00); { 0 000000000000000 1000000000000000000000000000000000000000000000000000000000000000 }
  SubNormalMid := Value;

  ValueArray := MakeExtended($00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 000000000000000 1111111111111111111111111111111111111111111111111111111111111111 }
  SubNormalMax := Value;

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00, $00, $01); { 1 000000000000000 0000000000000000000000000000000000000000000000000000000000000001 }
  NSubNormalMax := Value;

  ValueArray := MakeExtended($80, $00, $80, $00, $00, $00, $00, $00, $00, $00); { 1 000000000000000 1000000000000000000000000000000000000000000000000000000000000000 }
  NSubNormalMid := Value;

  ValueArray := MakeExtended($80, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 000000000000000 1111111111111111111111111111111111111111111111111111111111111111 }
  NSubNormalMin := Value;

  ValueArray := MakeExtended($00, $01, $00, $00, $00, $00, $00, $00, $00, $00); { 0 000000000000001 0000000000000000000000000000000000000000000000000000000000000000 }
  NormalMin := Value;

  ValueArray := MakeExtended($3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 011111111111111 1111111111111111111111111111111111111111111111111111111111111111 }
  NormalMid := Value;

  ValueArray := MakeExtended($7f, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 111111111111110 1111111111111111111111111111111111111111111111111111111111111111 }
  NormalMax := Value;

  ValueArray := MakeExtended($80, $01, $00, $00, $00, $00, $00, $00, $00, $00); { 1 000000000000001 0000000000000000000000000000000000000000000000000000000000000000 }
  NNormalMax := Value;

  ValueArray := MakeExtended($bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 011111111111111 1111111111111111111111111111111111111111111111111111111111111111 }
  NNormalMid := Value;

  ValueArray := MakeExtended($ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 111111111111110 1111111111111111111111111111111111111111111111111111111111111111 }
  NNormalMin := Value;

  ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { 0 111111111111111 1000000000000000000000000000000000000000000000000000000000000000 }
  Inf := Value;

  ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { 1 111111111111111 1000000000000000000000000000000000000000000000000000000000000000 }
  NInf := Value;

  ValueArray := MakeExtended($7f, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { 0 111111111111111 1100000000000000000000000000000000000000000000000000000000000000 }
  NaN1 := Value;

  ValueArray := MakeExtended($ff, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { 1 111111111111111 1100000000000000000000000000000000000000000000000000000000000000 }
  NaN2 := Value;

  ValueArray := MakeExtended($7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 111111111111111 1111111111111111111111111111111111111111111111111111111111111111 }
  NaN3 := Value;

  ValueArray := MakeExtended($ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 111111111111111 1111111111111111111111111111111111111111111111111111111111111111 }
  NaN4 := Value;

  ValueArray := MakeExtended($7f, $ff, $d5, $55, $55, $55, $55, $55, $55, $55); { 0 111111111111111 1101010101010101010101010101010101010101010101010101010101010101 }
  NaN5 := Value;

  ValueArray := MakeExtended($ff, $ff, $d5, $55, $55, $55, $55, $55, $55, $55); { 0 111111111111111 1101010101010101010101010101010101010101010101010101010101010101 }
  NaN6 := Value;
  {$ELSE}
  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00); { 0 00000000000 0000000000000000000000000000000000000000000000000000 }
  Zero := Value;

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00); { 1 00000000000 0000000000000000000000000000000000000000000000000000 }
  NZero := Value;

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $01); { 0 00000000000 0000000000000000000000000000000000000000000000000001 }
  SubNormalMin := Value;

  ValueArray := MakeExtended($00, $08, $00, $00, $00, $00, $00, $00); { 0 00000000000 1000000000000000000000000000000000000000000000000000 }
  SubNormalMid := Value;

  ValueArray := MakeExtended($00, $0f, $ff, $ff, $ff, $ff, $ff, $ff); { 0 00000000000 1111111111111111111111111111111111111111111111111111 }
  SubNormalMax := Value;

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $01); { 1 00000000000 0000000000000000000000000000000000000000000000000001 }
  NSubNormalMax := Value;

  ValueArray := MakeExtended($80, $08, $00, $00, $00, $00, $00, $00); { 1 00000000000 1000000000000000000000000000000000000000000000000000 }
  NSubNormalMid := Value;

  ValueArray := MakeExtended($80, $0f, $ff, $ff, $ff, $ff, $ff, $ff); { 1 00000000000 1111111111111111111111111111111111111111111111111111 }
  NSubNormalMin := Value;

  ValueArray := MakeExtended($00, $10, $00, $00, $00, $00, $00, $00); { 0 00000000001 0000000000000000000000000000000000000000000000000000 }
  NormalMin := Value;

  ValueArray := MakeExtended($3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 01111111111 1111111111111111111111111111111111111111111111111111 }
  NormalMid := Value;

  ValueArray := MakeExtended($7f, $ef, $ff, $ff, $ff, $ff, $ff, $ff); { 0 11111111110 1111111111111111111111111111111111111111111111111111 }
  NormalMax := Value;

  ValueArray := MakeExtended($80, $10, $00, $00, $00, $00, $00, $00); { 1 00000000001 0000000000000000000000000000000000000000000000000000 }
  NNormalMax := Value;

  ValueArray := MakeExtended($bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 01111111111 1111111111111111111111111111111111111111111111111111 }
  NNormalMid := Value;

  ValueArray := MakeExtended($ff, $ef, $ff, $ff, $ff, $ff, $ff, $ff); { 1 11111111110 1111111111111111111111111111111111111111111111111111 }
  NNormalMin := Value;

  ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { 0 11111111111 0000000000000000000000000000000000000000000000000000 }
  Inf := Value;

  ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { 1 11111111111 0000000000000000000000000000000000000000000000000000 }
  NInf := Value;

  ValueArray := MakeExtended($7f, $f8, $00, $00, $00, $00, $00, $00); { 0 11111111111 1000000000000000000000000000000000000000000000000000 }
  NaN1 := Value;

  ValueArray := MakeExtended($ff, $f8, $00, $00, $00, $00, $00, $00); { 1 11111111111 1000000000000000000000000000000000000000000000000000 }
  NaN2 := Value;

  ValueArray := MakeExtended($7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 11111111111 1111111111111111111111111111111111111111111111111111 }
  NaN3 := Value;

  ValueArray := MakeExtended($ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 11111111111 1111111111111111111111111111111111111111111111111111 }
  NaN4 := Value;

  ValueArray := MakeExtended($7f, $fa, $aa, $aa, $aa, $aa, $aa, $aa); { 0 11111111111 1010101010101010101010101010101010101010101010101010 }
  NaN5 := Value;

  ValueArray := MakeExtended($ff, $fa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 11111111111 1010101010101010101010101010101010101010101010101010 }
  NaN6 := Value;
  {$ENDIF CPUEXTENDED}
end;
{$ENDIF RUN_TESTS}

procedure TestTExtendedHelper.TestEpsilon;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  Value := Extended.Epsilon;
  SwapToBig(ValueArray);

  {$IFDEF CPUEXTENDED}
  CheckEquals($00, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  CheckEquals($00, ValueArray[8]);
  CheckEquals($01, ValueArray[9]);
  {$ELSE}
  CheckEquals($00, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($01, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestMaxValue;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  Value := Extended.MaxValue;
  SwapToBig(ValueArray);

  {$IFDEF CPUEXTENDED}
  CheckEquals($7f, ValueArray[0]);
  CheckEquals($fe, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);
  CheckEquals($ff, ValueArray[8]);
  CheckEquals($ff, ValueArray[9]);
  {$ELSE}
  CheckEquals($7f, ValueArray[0]);
  CheckEquals($ef, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestMinValue;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  Value := Extended.MinValue;
  SwapToBig(ValueArray);

  {$IFDEF CPUEXTENDED}
  CheckEquals($ff, ValueArray[0]);
  CheckEquals($fe, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);
  CheckEquals($ff, ValueArray[8]);
  CheckEquals($ff, ValueArray[9]);
  {$ELSE}
  CheckEquals($ff, ValueArray[0]);
  CheckEquals($ef, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestPositiveInfinity;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  Value := Extended.PositiveInfinity;
  SwapToBig(ValueArray);

  {$IFDEF CPUEXTENDED}
  CheckEquals($7f, ValueArray[0]);
  CheckEquals($ff, ValueArray[1]);
  CheckEquals($80, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  CheckEquals($00, ValueArray[8]);
  CheckEquals($00, ValueArray[9]);
  {$ELSE}
  CheckEquals($7f, ValueArray[0]);
  CheckEquals($f0, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestNegativeInfinity;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  Value := Extended.NegativeInfinity;
  SwapToBig(ValueArray);

  {$IFDEF CPUEXTENDED}
  CheckEquals($ff, ValueArray[0]);
  CheckEquals($ff, ValueArray[1]);
  CheckEquals($80, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  CheckEquals($00, ValueArray[8]);
  CheckEquals($00, ValueArray[9]);
  {$ELSE}
  CheckEquals($ff, ValueArray[0]);
  CheckEquals($f0, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestNaN;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
  i, StartIndex: Integer;
  Acc: Byte;
begin
  Value := Extended.NaN;
  SwapToBig(ValueArray);

  {$IFDEF CPUEXTENDED}
  CheckEquals($7f, ValueArray[0] and $7f);
  CheckEquals($ff, ValueArray[1]);
  CheckEquals($80, ValueArray[2] and $80);
  Acc := ValueArray[2] and $7f;
  StartIndex := 3;
  {$ELSE}
  CheckEquals($7f, ValueArray[0] and $7f);
  CheckEquals($f0, ValueArray[1] and $f0);
  Acc := ValueArray[1] and $0f;
  StartIndex := 2;
  {$ENDIF CPUEXTENDED}

  { The rest of bits can be be anything but zero. }
  for i := StartIndex to High(ValueArray) do
    Acc := Acc or ValueArray[i];
  CheckNotEquals(0, Acc);
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestExponent;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($d5, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 1 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals($1556, Value.Exponent);

  ValueArray := MakeExtended($55, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 0 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals($1556, Value.Exponent);

  ValueArray := MakeExtended($d5, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals($1556, Value.Exponent);

  ValueArray := MakeExtended($55, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals($1556, Value.Exponent);

  ValueArray := MakeExtended($d5, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 101010101010101 1010101010101010101010101010101010101010101010101010101010101010 }
  CheckEquals($1556, Value.Exponent);

  ValueArray := MakeExtended($55, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 0 101010101010101 1010101010101010101010101010101010101010101010101010101010101010 }
  CheckEquals($1556, Value.Exponent);

  ValueArray := MakeExtended($d5, $55, $55, $55, $55, $55, $55, $55, $55, $55); { 1 101010101010101 0101010101010101010101010101010101010101010101010101010101010101 }
  CheckEquals($1556, Value.Exponent);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55, $55, $55); { 0 101010101010101 0101010101010101010101010101010101010101010101010101010101010101 }
  CheckEquals($1556, Value.Exponent);
  {$ELSE}
  ValueArray := MakeExtended($d5, $50, $00, $00, $00, $00, $00, $00); { 1 10101010101 0000000000000000000000000000000000000000000000000000 }
  CheckEquals($0156, Value.Exponent);

  ValueArray := MakeExtended($55, $50, $00, $00, $00, $00, $00, $00); { 0 10101010101 0000000000000000000000000000000000000000000000000000 }
  CheckEquals($0156, Value.Exponent);

  ValueArray := MakeExtended($d5, $5f, $ff, $ff, $ff, $ff, $ff, $ff); { 1 10101010101 1111111111111111111111111111111111111111111111111111 }
  CheckEquals($0156, Value.Exponent);

  ValueArray := MakeExtended($55, $5f, $ff, $ff, $ff, $ff, $ff, $ff); { 0 10101010101 1111111111111111111111111111111111111111111111111111 }
  CheckEquals($0156, Value.Exponent);

  ValueArray := MakeExtended($d5, $55, $55, $55, $55, $55, $55, $55); { 1 10101010101 0101010101010101010101010101010101010101010101010101 }
  CheckEquals($0156, Value.Exponent);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55); { 0 10101010101 0101010101010101010101010101010101010101010101010101 }
  CheckEquals($0156, Value.Exponent);

  ValueArray := MakeExtended($d5, $5a, $aa, $aa, $aa, $aa, $aa, $aa); { 1 10101010101 1010101010101010101010101010101010101010101010101010 }
  CheckEquals($0156, Value.Exponent);

  ValueArray := MakeExtended($55, $5a, $aa, $aa, $aa, $aa, $aa, $aa); { 0 10101010101 1010101010101010101010101010101010101010101010101010 }
  CheckEquals($0156, Value.Exponent);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestFraction;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { +INF }
  CheckTrue(Value.Fraction.IsInfinity);

  ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { -INF }
  CheckTrue(Value.Fraction.IsInfinity);

  ValueArray := MakeExtended($7f, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { NaN }
  CheckTrue(Value.Fraction.IsNaN);

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00, $00, $00); { +0 }
  CheckEquals(0, Value.Fraction);

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00, $00, $00); { -0 }
  CheckEquals(0, Value.Fraction);

  ValueArray := MakeExtended($3f, $ff, $e0, $00, $00, $00, $00, $00, $00, $00); { 1.75, normal, > 1 }
  CheckEquals(1.75, Value.Fraction);

  ValueArray := MakeExtended($3f, $fd, $80, $00, $00, $00, $00, $00, $00, $00); { 0.25, normal, < 1 }
  CheckEquals(1, Value.Fraction);                                               { because of 0 011111111111101 1000000000000000000000000000000000000000000000000000000000000000 }

  ValueArray := MakeExtended($00, $00, $08, $00, $00, $00, $00, $00, $00, $00); { 2.10131446444506E-4933, denormal }
  CheckEquals(0.0625, Value.Fraction);
  {$ELSE}
  ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { +INF }
  CheckTrue(Value.Fraction.IsInfinity);

  ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { -INF }
  CheckTrue(Value.Fraction.IsInfinity);

  ValueArray := MakeExtended($7f, $f8, $00, $00, $00, $00, $00, $00); { NaN }
  CheckTrue(Value.Fraction.IsNaN);

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00); { +0 }
  CheckEquals(0, Value.Fraction);

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00); { -0 }
  CheckEquals(0, Value.Fraction);

  ValueArray := MakeExtended($3f, $fc, $00, $00, $00, $00, $00, $00); { 1.75, normal, > 1 }
  CheckEquals(1.75, Value.Fraction);

  ValueArray := MakeExtended($3f, $d0, $00, $00, $00, $00, $00, $00); { 0.25, normal, < 1 }
  CheckEquals(1, Value.Fraction);                                     { because of 0 01111111101 0000000000000000000000000000000000000000000000000000 }

  ValueArray := MakeExtended($00, $08, $00, $00, $00, $00, $00, $00); { 1.1125369292536E-308, denormal }
  CheckEquals(0.5, Value.Fraction);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestMantissa;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($aa, $aa, $00, $00, $00, $00, $00, $00, $00, $00); { 1 010101010101010 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Mantissa);

  ValueArray := MakeExtended($55, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 0 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Mantissa);

  ValueArray := MakeExtended($aa, $aa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 010101010101010 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($ffffffffffffffff), Value.Mantissa);

  ValueArray := MakeExtended($55, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($ffffffffffffffff), Value.Mantissa);


  ValueArray := MakeExtended($aa, $aa, $55, $55, $55, $55, $55, $55, $55, $55); { 1 010101010101010 1010101010101010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($5555555555555555), Value.Mantissa);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55, $55, $55); { 0 101010101010101 1010101010101010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($5555555555555555), Value.Mantissa);

  ValueArray := MakeExtended($aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 010101010101010 0101010101010101010101010101010101010101010101010101010101010101 }
  CheckEquals(UInt64($aaaaaaaaaaaaaaaa), Value.Mantissa);

  ValueArray := MakeExtended($55, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 0 101010101010101 0101010101010101010101010101010101010101010101010101010101010101 }
  CheckEquals(UInt64($aaaaaaaaaaaaaaaa), Value.Mantissa);


  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00, $00, $00); { 0 000000000000000 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Mantissa);

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00, $00, $00); { 1 000000000000000 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Mantissa);

  ValueArray := MakeExtended($7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 111111111111111 1111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($ffffffffffffffff), Value.Mantissa);

  ValueArray := MakeExtended($ff, $ff, $55, $55, $55, $55, $55, $55, $55, $55); { 1 111111111111111 1010101010101010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($5555555555555555), Value.Mantissa);
  {$ELSE}
  ValueArray := MakeExtended($aa, $a0, $00, $00, $00, $00, $00, $00); { 1 01010101010 0000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0010000000000000), Value.Mantissa);

  ValueArray := MakeExtended($55, $50, $00, $00, $00, $00, $00, $00); { 0 10101010101 0000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0010000000000000), Value.Mantissa);

  ValueArray := MakeExtended($aa, $af, $ff, $ff, $ff, $ff, $ff, $ff); { 1 01010101010 1111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($001fffffffffffff), Value.Mantissa);

  ValueArray := MakeExtended($55, $5f, $ff, $ff, $ff, $ff, $ff, $ff); { 0 10101010101 1111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($001fffffffffffff), Value.Mantissa);


  ValueArray := MakeExtended($aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 01010101010 1010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($001aaaaaaaaaaaaa), Value.Mantissa);

  ValueArray := MakeExtended($55, $5a, $aa, $aa, $aa, $aa, $aa, $aa); { 0 10101010101 1010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($001aaaaaaaaaaaaa), Value.Mantissa);

  ValueArray := MakeExtended($aa, $a5, $55, $55, $55, $55, $55, $55); { 1 01010101010 0101010101010101010101010101010101010101010101010101 }
  CheckEquals(UInt64($0015555555555555), Value.Mantissa);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55); { 0 10101010101 0101010101010101010101010101010101010101010101010101 }
  CheckEquals(UInt64($0015555555555555), Value.Mantissa);


  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00); { 0 00000000000 0000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Mantissa);

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00); { 1 00000000000 0000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Mantissa);

  ValueArray := MakeExtended($7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 11111111111 1111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($00fffffffffffff), Value.Mantissa);

  ValueArray := MakeExtended($ff, $fa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 11111111111 1010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($00aaaaaaaaaaaaa), Value.Mantissa);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestSign;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff);
  CheckTrue(Value.Sign);

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00, $00, $00);  { -0, btw }
  CheckTrue(Value.Sign);

  ValueArray := MakeExtended($aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa);
  CheckTrue(Value.Sign);

  ValueArray := MakeExtended($7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff);
  CheckFalse(Value.Sign);

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00, $00, $00);
  CheckFalse(Value.Sign);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55, $55, $55);
  CheckFalse(Value.Sign);

  ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { +INF }
  CheckFalse(Value.Sign);

  ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { -INF }
  CheckTrue(Value.Sign);

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00, $00, $00);
  Value.Sign := True;
  SwapToBig(ValueArray);
  CheckEquals($80, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  CheckEquals($00, ValueArray[8]);
  CheckEquals($00, ValueArray[9]);

  ValueArray := MakeExtended($ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff);
  Value.Sign := False;
  SwapToBig(ValueArray);
  CheckEquals($7f, ValueArray[0]);
  CheckEquals($ff, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);
  CheckEquals($ff, ValueArray[8]);
  CheckEquals($ff, ValueArray[9]);
  {$ELSE}
  ValueArray := MakeExtended($ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff);
  CheckTrue(Value.Sign);

  ValueArray := MakeExtended($80, $00, $00, $00, $00, $00, $00, $00);  { -0, btw }
  CheckTrue(Value.Sign);

  ValueArray := MakeExtended($aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa);
  CheckTrue(Value.Sign);

  ValueArray := MakeExtended($7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff);
  CheckFalse(Value.Sign);

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00);
  CheckFalse(Value.Sign);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55);
  CheckFalse(Value.Sign);

  ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { +INF }
  CheckFalse(Value.Sign);

  ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { -INF }
  CheckTrue(Value.Sign);

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00);
  Value.Sign := True;
  SwapToBig(ValueArray);
  CheckEquals($80, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);

  ValueArray := MakeExtended($ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff);
  Value.Sign := False;
  SwapToBig(ValueArray);
  CheckEquals($7f, ValueArray[0]);
  CheckEquals($ff, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestExp;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($d5, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 1 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals($5555, Value.Exp);

  ValueArray := MakeExtended($55, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 0 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals($5555, Value.Exp);

  ValueArray := MakeExtended($d5, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals($5555, Value.Exp);

  ValueArray := MakeExtended($55, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals($5555, Value.Exp);

  ValueArray := MakeExtended($d5, $55, $55, $55, $55, $55, $55, $55, $55, $55); { 1 101010101010101 0101010101010101010101010101010101010101010101010101010101010101 }
  CheckEquals($5555, Value.Exp);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55, $55, $55); { 0 101010101010101 0101010101010101010101010101010101010101010101010101010101010101 }
  CheckEquals($5555, Value.Exp);

  ValueArray := MakeExtended($d5, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 101010101010101 1010101010101010101010101010101010101010101010101010101010101010 }
  CheckEquals($5555, Value.Exp);

  ValueArray := MakeExtended($55, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 0 101010101010101 1010101010101010101010101010101010101010101010101010101010101010 }
  CheckEquals($5555, Value.Exp);


  ValueArray := MakeExtended($d5, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 1 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  Value.Exp := $2aaa;                                                           { 1 010101010101010 0000000000000000000000000000000000000000000000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]); CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]); CheckEquals($00, ValueArray[6]); CheckEquals($00, ValueArray[7]); CheckEquals($00, ValueArray[8]); CheckEquals($00, ValueArray[9]);

  ValueArray := MakeExtended($55, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 0 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  Value.Exp := $2aaa;                                                           { 0 010101010101010 0000000000000000000000000000000000000000000000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]); CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]); CheckEquals($00, ValueArray[6]); CheckEquals($00, ValueArray[7]); CheckEquals($00, ValueArray[8]); CheckEquals($00, ValueArray[9]);

  ValueArray := MakeExtended($d5, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  Value.Exp := $2aaa;                                                           { 1 010101010101010 1111111111111111111111111111111111111111111111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]); CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]); CheckEquals($ff, ValueArray[6]); CheckEquals($ff, ValueArray[7]); CheckEquals($ff, ValueArray[8]); CheckEquals($ff, ValueArray[9]);

  ValueArray := MakeExtended($55, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 0 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  Value.Exp := $2aaa;                                                           { 0 010101010101010 1111111111111111111111111111111111111111111111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]); CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]); CheckEquals($ff, ValueArray[6]); CheckEquals($ff, ValueArray[7]); CheckEquals($ff, ValueArray[8]); CheckEquals($ff, ValueArray[9]);

  ValueArray := MakeExtended($d5, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 101010101010101 1010101010101010101010101010101010101010101010101010101010101010 }
  Value.Exp := $2aaa;                                                           { 1 010101010101010 1010101010101010101010101010101010101010101010101010101010101010 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($aa, ValueArray[2]); CheckEquals($aa, ValueArray[3]); CheckEquals($aa, ValueArray[4]);
  CheckEquals($aa, ValueArray[5]); CheckEquals($aa, ValueArray[6]); CheckEquals($aa, ValueArray[7]); CheckEquals($aa, ValueArray[8]); CheckEquals($aa, ValueArray[9]);

  ValueArray := MakeExtended($55, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 0 101010101010101 1010101010101010101010101010101010101010101010101010101010101010 }
  Value.Exp := $2aaa;                                                           { 0 010101010101010 1010101010101010101010101010101010101010101010101010101010101010 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($aa, ValueArray[2]); CheckEquals($aa, ValueArray[3]); CheckEquals($aa, ValueArray[4]);
  CheckEquals($aa, ValueArray[5]); CheckEquals($aa, ValueArray[6]); CheckEquals($aa, ValueArray[7]); CheckEquals($aa, ValueArray[8]); CheckEquals($aa, ValueArray[9]);

  ValueArray := MakeExtended($d5, $55, $55, $55, $55, $55, $55, $55, $55, $55); { 1 101010101010101 0101010101010101010101010101010101010101010101010101010101010101 }
  Value.Exp := $2aaa;                                                           { 1 010101010101010 0101010101010101010101010101010101010101010101010101010101010101 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($55, ValueArray[2]); CheckEquals($55, ValueArray[3]); CheckEquals($55, ValueArray[4]);
  CheckEquals($55, ValueArray[5]); CheckEquals($55, ValueArray[6]); CheckEquals($55, ValueArray[7]); CheckEquals($55, ValueArray[8]); CheckEquals($55, ValueArray[9]);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55, $55, $55); { 0 101010101010101 0101010101010101010101010101010101010101010101010101010101010101 }
  Value.Exp := $2aaa;                                                           { 0 010101010101010 0101010101010101010101010101010101010101010101010101010101010101 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($55, ValueArray[2]); CheckEquals($55, ValueArray[3]); CheckEquals($55, ValueArray[4]);
  CheckEquals($55, ValueArray[5]); CheckEquals($55, ValueArray[6]); CheckEquals($55, ValueArray[7]); CheckEquals($55, ValueArray[8]); CheckEquals($55, ValueArray[9]);


  { Overflow protection }
  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00, $00, $00); { 0 000000000000000 0000000000000000000000000000000000000000000000000000000000000000 }
  Value.Exp := 32768;                                                           { 0 000000000000000 0000000000000000000000000000000000000000000000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($00, ValueArray[0]); CheckEquals($00, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]); CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]); CheckEquals($00, ValueArray[6]); CheckEquals($00, ValueArray[7]); CheckEquals($00, ValueArray[8]); CheckEquals($00, ValueArray[9]);

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00, $00, $00); { 0 000000000000000 0000000000000000000000000000000000000000000000000000000000000000 }
  Value.Exp := 32769;                                                           { 0 000000000000001 0000000000000000000000000000000000000000000000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($00, ValueArray[0]); CheckEquals($01, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]); CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]); CheckEquals($00, ValueArray[6]); CheckEquals($00, ValueArray[7]); CheckEquals($00, ValueArray[8]); CheckEquals($00, ValueArray[9]);
  {$ELSE}
  ValueArray := MakeExtended($d5, $50, $00, $00, $00, $00, $00, $00); { 1 10101010101 0000000000000000000000000000000000000000000000000000 }
  CheckEquals($0555, Value.Exp);

  ValueArray := MakeExtended($55, $50, $00, $00, $00, $00, $00, $00); { 0 10101010101 0000000000000000000000000000000000000000000000000000 }
  CheckEquals($0555, Value.Exp);

  ValueArray := MakeExtended($d5, $5f, $ff, $ff, $ff, $ff, $ff, $ff); { 1 10101010101 1111111111111111111111111111111111111111111111111111 }
  CheckEquals($0555, Value.Exp);

  ValueArray := MakeExtended($55, $5f, $ff, $ff, $ff, $ff, $ff, $ff); { 0 10101010101 1111111111111111111111111111111111111111111111111111 }
  CheckEquals($0555, Value.Exp);

  ValueArray := MakeExtended($d5, $55, $55, $55, $55, $55, $55, $55); { 1 10101010101 0101010101010101010101010101010101010101010101010101 }
  CheckEquals($0555, Value.Exp);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55); { 0 10101010101 0101010101010101010101010101010101010101010101010101 }
  CheckEquals($0555, Value.Exp);

  ValueArray := MakeExtended($d5, $5a, $aa, $aa, $aa, $aa, $aa, $aa); { 1 10101010101 1010101010101010101010101010101010101010101010101010 }
  CheckEquals(1365, Value.Exp);

  ValueArray := MakeExtended($55, $5a, $aa, $aa, $aa, $aa, $aa, $aa); { 0 10101010101 1010101010101010101010101010101010101010101010101010 }
  CheckEquals($0555, Value.Exp);


  ValueArray := MakeExtended($d5, $50, $00, $00, $00, $00, $00, $00); { 1 10101010101 0000000000000000000000000000000000000000000000000000 }
  Value.Exp := $02aa;                                                 { 1 01010101010 0000000000000000000000000000000000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($a0, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]); CheckEquals($00, ValueArray[5]); CheckEquals($00, ValueArray[6]); CheckEquals($00, ValueArray[7]);

  ValueArray := MakeExtended($55, $50, $00, $00, $00, $00, $00, $00); { 0 10101010101 0000000000000000000000000000000000000000000000000000 }
  Value.Exp := $02aa;                                                 { 0 01010101010 0000000000000000000000000000000000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($a0, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]); CheckEquals($00, ValueArray[5]); CheckEquals($00, ValueArray[6]); CheckEquals($00, ValueArray[7]);

  ValueArray := MakeExtended($d5, $5f, $ff, $ff, $ff, $ff, $ff, $ff); { 1 10101010101 1111111111111111111111111111111111111111111111111111 }
  Value.Exp := $02aa;                                                 { 1 01010101010 1111111111111111111111111111111111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($af, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]); CheckEquals($ff, ValueArray[5]); CheckEquals($ff, ValueArray[6]); CheckEquals($ff, ValueArray[7]);

  ValueArray := MakeExtended($55, $5f, $ff, $ff, $ff, $ff, $ff, $ff); { 0 10101010101 1111111111111111111111111111111111111111111111111111 }
  Value.Exp := $02aa;                                                 { 0 01010101010 1111111111111111111111111111111111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($af, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]); CheckEquals($ff, ValueArray[5]); CheckEquals($ff, ValueArray[6]); CheckEquals($ff, ValueArray[7]);

  ValueArray := MakeExtended($d5, $5a, $aa, $aa, $aa, $aa, $aa, $aa); { 1 10101010101 1010101010101010101010101010101010101010101010101010 }
  Value.Exp := $02aa;                                                 { 1 01010101010 1010101010101010101010101010101010101010101010101010 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($aa, ValueArray[2]); CheckEquals($aa, ValueArray[3]);
  CheckEquals($aa, ValueArray[4]); CheckEquals($aa, ValueArray[5]); CheckEquals($aa, ValueArray[6]); CheckEquals($aa, ValueArray[7]);

  ValueArray := MakeExtended($55, $5a, $aa, $aa, $aa, $aa, $aa, $aa); { 0 10101010101 1010101010101010101010101010101010101010101010101010 }
  Value.Exp := $02aa;                                                 { 0 01010101010 1010101010101010101010101010101010101010101010101010 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($aa, ValueArray[2]); CheckEquals($aa, ValueArray[3]);
  CheckEquals($aa, ValueArray[4]); CheckEquals($aa, ValueArray[5]); CheckEquals($aa, ValueArray[6]); CheckEquals($aa, ValueArray[7]);

  ValueArray := MakeExtended($d5, $55, $55, $55, $55, $55, $55, $55); { 1 10101010101 0101010101010101010101010101010101010101010101010101 }
  Value.Exp := $02aa;                                                 { 1 01010101010 0101010101010101010101010101010101010101010101010101 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($a5, ValueArray[1]); CheckEquals($55, ValueArray[2]); CheckEquals($55, ValueArray[3]);
  CheckEquals($55, ValueArray[4]); CheckEquals($55, ValueArray[5]); CheckEquals($55, ValueArray[6]); CheckEquals($55, ValueArray[7]);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55); { 0 10101010101 0101010101010101010101010101010101010101010101010101 }
  Value.Exp := $02aa;                                                 { 0 01010101010 0101010101010101010101010101010101010101010101010101 }
  SwapToBig(ValueArray);
  CheckEquals($2a, ValueArray[0]); CheckEquals($a5, ValueArray[1]); CheckEquals($55, ValueArray[2]); CheckEquals($55, ValueArray[3]);
  CheckEquals($55, ValueArray[4]); CheckEquals($55, ValueArray[5]); CheckEquals($55, ValueArray[6]); CheckEquals($55, ValueArray[7]);


  { Overflow protection }
  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00); { 0 00000000000 0000000000000000000000000000000000000000000000000000 }
  Value.Exp := 2048;                                                  { 0 00000000000 0000000000000000000000000000000000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($00, ValueArray[0]); CheckEquals($00, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]); CheckEquals($00, ValueArray[5]); CheckEquals($00, ValueArray[6]); CheckEquals($00, ValueArray[7]);

  ValueArray := MakeExtended($00, $00, $00, $00, $00, $00, $00, $00); { 0 00000000000 0000000000000000000000000000000000000000000000000000 }
  Value.Exp := 2049;                                                  { 0 00000000001 0000000000000000000000000000000000000000000000000000 }
  SwapToBig(ValueArray);
  CheckEquals($00, ValueArray[0]); CheckEquals($10, ValueArray[1]); CheckEquals($00, ValueArray[2]); CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]); CheckEquals($00, ValueArray[5]); CheckEquals($00, ValueArray[6]); CheckEquals($00, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestFrac;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($aa, $aa, $00, $00, $00, $00, $00, $00, $00, $00); { 1 010101010101010 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Frac);

  ValueArray := MakeExtended($55, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 0 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Frac);

  ValueArray := MakeExtended($aa, $aa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 010101010101010 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($ffffffffffffffff), Value.Frac);

  ValueArray := MakeExtended($d5, $55, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff); { 1 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($ffffffffffffffff), Value.Frac);

  ValueArray := MakeExtended($aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 010101010101010 1010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($aaaaaaaaaaaaaaaa), Value.Frac);

  ValueArray := MakeExtended($55, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 0 101010101010101 1010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($aaaaaaaaaaaaaaaa), Value.Frac);

  ValueArray := MakeExtended($aa, $aa, $55, $55, $55, $55, $55, $55, $55, $55); { 1 010101010101010 0101010101010101010101010101010101010101010101010101 }
  CheckEquals(UInt64($5555555555555555), Value.Frac);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55, $55, $55); { 0 101010101010101 0101010101010101010101010101010101010101010101010101 }
  CheckEquals(UInt64($5555555555555555), Value.Frac);


  ValueArray := MakeExtended($aa, $aa, $00, $00, $00, $00, $00, $00, $00, $00); { 1 010101010101010 0000000000000000000000000000000000000000000000000000000000000000 }
  Value.Frac := UInt64($ffffffffffffffff);                                      { 1 010101010101010 1111111111111111111111111111111111111111111111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($aa, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]); CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]); CheckEquals($ff, ValueArray[6]); CheckEquals($ff, ValueArray[7]); CheckEquals($ff, ValueArray[8]); CheckEquals($ff, ValueArray[9]);

  ValueArray := MakeExtended($55, $55, $00, $00, $00, $00, $00, $00, $00, $00); { 0 101010101010101 0000000000000000000000000000000000000000000000000000000000000000 }
  Value.Frac := UInt64($ffffffffffffffff);
  SwapToBig(ValueArray);                                                        { 0 101010101010101 1111111111111111111111111111111111111111111111111111111111111111 }
  CheckEquals($55, ValueArray[0]); CheckEquals($55, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]); CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]); CheckEquals($ff, ValueArray[6]); CheckEquals($ff, ValueArray[7]); CheckEquals($ff, ValueArray[8]); CheckEquals($ff, ValueArray[9]);
  {$ELSE}
  ValueArray := MakeExtended($aa, $a0, $00, $00, $00, $00, $00, $00); { 1 01010101010 0000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Frac);

  ValueArray := MakeExtended($55, $50, $00, $00, $00, $00, $00, $00); { 0 10101010101 0000000000000000000000000000000000000000000000000000 }
  CheckEquals(UInt64($0000000000000000), Value.Frac);

  ValueArray := MakeExtended($aa, $af, $ff, $ff, $ff, $ff, $ff, $ff); { 1 01010101010 1111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($000fffffffffffff), Value.Frac);

  ValueArray := MakeExtended($d5, $5f, $ff, $ff, $ff, $ff, $ff, $ff); { 1 10101010101 1111111111111111111111111111111111111111111111111111 }
  CheckEquals(UInt64($000fffffffffffff), Value.Frac);

  ValueArray := MakeExtended($aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa); { 1 01010101010 1010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($000aaaaaaaaaaaaa), Value.Frac);

  ValueArray := MakeExtended($55, $5a, $aa, $aa, $aa, $aa, $aa, $aa); { 0 10101010101 1010101010101010101010101010101010101010101010101010 }
  CheckEquals(UInt64($000aaaaaaaaaaaaa), Value.Frac);

  ValueArray := MakeExtended($aa, $a5, $55, $55, $55, $55, $55, $55); { 1 01010101010 0101010101010101010101010101010101010101010101010101 }
  CheckEquals(UInt64($0005555555555555), Value.Frac);

  ValueArray := MakeExtended($55, $55, $55, $55, $55, $55, $55, $55); { 0 10101010101 0101010101010101010101010101010101010101010101010101 }
  CheckEquals(UInt64($0005555555555555), Value.Frac);


  ValueArray := MakeExtended($aa, $a0, $00, $00, $00, $00, $00, $00); { 1 01010101010 0000000000000000000000000000000000000000000000000000 }
  Value.Frac := UInt64($000fffffffffffff);                            { 1 01010101010 1111111111111111111111111111111111111111111111111111 }
  SwapToBig(ValueArray);
  CheckEquals($aa, ValueArray[0]); CheckEquals($af, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]); CheckEquals($ff, ValueArray[5]); CheckEquals($ff, ValueArray[6]); CheckEquals($ff, ValueArray[7]);

  ValueArray := MakeExtended($55, $50, $00, $00, $00, $00, $00, $00); { 0 10101010101 0000000000000000000000000000000000000000000000000000 }
  Value.Frac := UInt64($000fffffffffffff);
  SwapToBig(ValueArray);                                              { 0 10101010101 1111111111111111111111111111111111111111111111111111 }
  CheckEquals($55, ValueArray[0]); CheckEquals($5f, ValueArray[1]); CheckEquals($ff, ValueArray[2]); CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]); CheckEquals($ff, ValueArray[5]); CheckEquals($ff, ValueArray[6]); CheckEquals($ff, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestSpecialType;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Extended;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  { fsZero }
  CheckTrue(      fsZero = Zero.SpecialType);
  CheckFalse(    fsNZero = Zero.SpecialType);
  CheckFalse( fsDenormal = Zero.SpecialType);
  CheckFalse(fsNDenormal = Zero.SpecialType);
  CheckFalse( fsPositive = Zero.SpecialType);
  CheckFalse( fsNegative = Zero.SpecialType);
  CheckFalse(      fsInf = Zero.SpecialType);
  CheckFalse(     fsNInf = Zero.SpecialType);
  CheckFalse(      fsNaN = Zero.SpecialType);

  { fsNZero }
  CheckFalse(     fsZero = NZero.SpecialType);
  CheckTrue(     fsNZero = NZero.SpecialType);
  CheckFalse( fsDenormal = NZero.SpecialType);
  CheckFalse(fsNDenormal = NZero.SpecialType);
  CheckFalse( fsPositive = NZero.SpecialType);
  CheckFalse( fsNegative = NZero.SpecialType);
  CheckFalse(      fsInf = NZero.SpecialType);
  CheckFalse(     fsNInf = NZero.SpecialType);
  CheckFalse(      fsNaN = NZero.SpecialType);

  { fsDenormal }
  CheckFalse(     fsZero = SubNormalMin.SpecialType);
  CheckFalse(    fsNZero = SubNormalMin.SpecialType);
  CheckTrue(  fsDenormal = SubNormalMin.SpecialType);
  CheckFalse(fsNDenormal = SubNormalMin.SpecialType);
  CheckFalse( fsPositive = SubNormalMin.SpecialType);
  CheckFalse( fsNegative = SubNormalMin.SpecialType);
  CheckFalse(      fsInf = SubNormalMin.SpecialType);
  CheckFalse(     fsNInf = SubNormalMin.SpecialType);
  CheckFalse(      fsNaN = SubNormalMin.SpecialType);

  CheckFalse(     fsZero = SubNormalMid.SpecialType);
  CheckFalse(    fsNZero = SubNormalMid.SpecialType);
  CheckTrue(  fsDenormal = SubNormalMid.SpecialType);
  CheckFalse(fsNDenormal = SubNormalMid.SpecialType);
  CheckFalse( fsPositive = SubNormalMid.SpecialType);
  CheckFalse( fsNegative = SubNormalMid.SpecialType);
  CheckFalse(      fsInf = SubNormalMid.SpecialType);
  CheckFalse(     fsNInf = SubNormalMid.SpecialType);
  CheckFalse(      fsNaN = SubNormalMid.SpecialType);

  CheckFalse(     fsZero = SubNormalMax.SpecialType);
  CheckFalse(    fsNZero = SubNormalMax.SpecialType);
  CheckTrue(  fsDenormal = SubNormalMax.SpecialType);
  CheckFalse(fsNDenormal = SubNormalMax.SpecialType);
  CheckFalse( fsPositive = SubNormalMax.SpecialType);
  CheckFalse( fsNegative = SubNormalMax.SpecialType);
  CheckFalse(      fsInf = SubNormalMax.SpecialType);
  CheckFalse(     fsNInf = SubNormalMax.SpecialType);
  CheckFalse(      fsNaN = SubNormalMax.SpecialType);

  { fsNDenormal }
  CheckFalse(     fsZero = NSubNormalMin.SpecialType);
  CheckFalse(    fsNZero = NSubNormalMin.SpecialType);
  CheckFalse( fsDenormal = NSubNormalMin.SpecialType);
  CheckTrue( fsNDenormal = NSubNormalMin.SpecialType);
  CheckFalse( fsPositive = NSubNormalMin.SpecialType);
  CheckFalse( fsNegative = NSubNormalMin.SpecialType);
  CheckFalse(      fsInf = NSubNormalMin.SpecialType);
  CheckFalse(     fsNInf = NSubNormalMin.SpecialType);
  CheckFalse(      fsNaN = NSubNormalMin.SpecialType);

  CheckFalse(     fsZero = NSubNormalMid.SpecialType);
  CheckFalse(    fsNZero = NSubNormalMid.SpecialType);
  CheckFalse( fsDenormal = NSubNormalMid.SpecialType);
  CheckTrue( fsNDenormal = NSubNormalMid.SpecialType);
  CheckFalse( fsPositive = NSubNormalMid.SpecialType);
  CheckFalse( fsNegative = NSubNormalMid.SpecialType);
  CheckFalse(      fsInf = NSubNormalMid.SpecialType);
  CheckFalse(     fsNInf = NSubNormalMid.SpecialType);
  CheckFalse(      fsNaN = NSubNormalMid.SpecialType);

  CheckFalse(     fsZero = NSubNormalMax.SpecialType);
  CheckFalse(    fsNZero = NSubNormalMax.SpecialType);
  CheckFalse( fsDenormal = NSubNormalMax.SpecialType);
  CheckTrue( fsNDenormal = NSubNormalMax.SpecialType);
  CheckFalse( fsPositive = NSubNormalMax.SpecialType);
  CheckFalse( fsNegative = NSubNormalMax.SpecialType);
  CheckFalse(      fsInf = NSubNormalMax.SpecialType);
  CheckFalse(     fsNInf = NSubNormalMax.SpecialType);
  CheckFalse(      fsNaN = NSubNormalMax.SpecialType);

  { fsPositive }
  CheckFalse(     fsZero = NormalMin.SpecialType);
  CheckFalse(    fsNZero = NormalMin.SpecialType);
  CheckFalse( fsDenormal = NormalMin.SpecialType);
  CheckFalse(fsNDenormal = NormalMin.SpecialType);
  CheckTrue(  fsPositive = NormalMin.SpecialType);
  CheckFalse( fsNegative = NormalMin.SpecialType);
  CheckFalse(      fsInf = NormalMin.SpecialType);
  CheckFalse(     fsNInf = NormalMin.SpecialType);
  CheckFalse(      fsNaN = NormalMin.SpecialType);

  CheckFalse(     fsZero = NormalMid.SpecialType);
  CheckFalse(    fsNZero = NormalMid.SpecialType);
  CheckFalse( fsDenormal = NormalMid.SpecialType);
  CheckFalse(fsNDenormal = NormalMid.SpecialType);
  CheckTrue(  fsPositive = NormalMid.SpecialType);
  CheckFalse( fsNegative = NormalMid.SpecialType);
  CheckFalse(      fsInf = NormalMid.SpecialType);
  CheckFalse(     fsNInf = NormalMid.SpecialType);
  CheckFalse(      fsNaN = NormalMid.SpecialType);

  CheckFalse(     fsZero = NormalMax.SpecialType);
  CheckFalse(    fsNZero = NormalMax.SpecialType);
  CheckFalse( fsDenormal = NormalMax.SpecialType);
  CheckFalse(fsNDenormal = NormalMax.SpecialType);
  CheckTrue(  fsPositive = NormalMax.SpecialType);
  CheckFalse( fsNegative = NormalMax.SpecialType);
  CheckFalse(      fsInf = NormalMax.SpecialType);
  CheckFalse(     fsNInf = NormalMax.SpecialType);
  CheckFalse(      fsNaN = NormalMax.SpecialType);

  { fsNegative }
  CheckFalse(     fsZero = NNormalMin.SpecialType);
  CheckFalse(    fsNZero = NNormalMin.SpecialType);
  CheckFalse( fsDenormal = NNormalMin.SpecialType);
  CheckFalse(fsNDenormal = NNormalMin.SpecialType);
  CheckFalse( fsPositive = NNormalMin.SpecialType);
  CheckTrue(  fsNegative = NNormalMin.SpecialType);
  CheckFalse(      fsInf = NNormalMin.SpecialType);
  CheckFalse(     fsNInf = NNormalMin.SpecialType);
  CheckFalse(      fsNaN = NNormalMin.SpecialType);

  CheckFalse(     fsZero = NNormalMid.SpecialType);
  CheckFalse(    fsNZero = NNormalMid.SpecialType);
  CheckFalse( fsDenormal = NNormalMid.SpecialType);
  CheckFalse(fsNDenormal = NNormalMid.SpecialType);
  CheckFalse( fsPositive = NNormalMid.SpecialType);
  CheckTrue(  fsNegative = NNormalMid.SpecialType);
  CheckFalse(      fsInf = NNormalMid.SpecialType);
  CheckFalse(     fsNInf = NNormalMid.SpecialType);
  CheckFalse(      fsNaN = NNormalMid.SpecialType);

  CheckFalse(     fsZero = NNormalMax.SpecialType);
  CheckFalse(    fsNZero = NNormalMax.SpecialType);
  CheckFalse( fsDenormal = NNormalMax.SpecialType);
  CheckFalse(fsNDenormal = NNormalMax.SpecialType);
  CheckFalse( fsPositive = NNormalMax.SpecialType);
  CheckTrue(  fsNegative = NNormalMax.SpecialType);
  CheckFalse(      fsInf = NNormalMax.SpecialType);
  CheckFalse(     fsNInf = NNormalMax.SpecialType);
  CheckFalse(      fsNaN = NNormalMax.SpecialType);

  { fsInf }
  CheckFalse(     fsZero = Inf.SpecialType);
  CheckFalse(    fsNZero = Inf.SpecialType);
  CheckFalse( fsDenormal = Inf.SpecialType);
  CheckFalse(fsNDenormal = Inf.SpecialType);
  CheckFalse( fsPositive = Inf.SpecialType);
  CheckFalse( fsNegative = Inf.SpecialType);
  CheckTrue(       fsInf = Inf.SpecialType);
  CheckFalse(     fsNInf = Inf.SpecialType);
  CheckFalse(      fsNaN = Inf.SpecialType);

  { fsNInf }
  CheckFalse(     fsZero = NInf.SpecialType);
  CheckFalse(    fsNZero = NInf.SpecialType);
  CheckFalse( fsDenormal = NInf.SpecialType);
  CheckFalse(fsNDenormal = NInf.SpecialType);
  CheckFalse( fsPositive = NInf.SpecialType);
  CheckFalse( fsNegative = NInf.SpecialType);
  CheckFalse(      fsInf = NInf.SpecialType);
  CheckTrue(      fsNInf = NInf.SpecialType);
  CheckFalse(      fsNaN = NInf.SpecialType);

  { fsNaN }
  CheckFalse(     fsZero = NaN1.SpecialType);
  CheckFalse(    fsNZero = NaN1.SpecialType);
  CheckFalse( fsDenormal = NaN1.SpecialType);
  CheckFalse(fsNDenormal = NaN1.SpecialType);
  CheckFalse( fsPositive = NaN1.SpecialType);
  CheckFalse( fsNegative = NaN1.SpecialType);
  CheckFalse(      fsInf = NaN1.SpecialType);
  CheckFalse(     fsNInf = NaN1.SpecialType);
  CheckTrue(       fsNaN = NaN1.SpecialType);

  CheckFalse(     fsZero = NaN2.SpecialType);
  CheckFalse(    fsNZero = NaN2.SpecialType);
  CheckFalse( fsDenormal = NaN2.SpecialType);
  CheckFalse(fsNDenormal = NaN2.SpecialType);
  CheckFalse( fsPositive = NaN2.SpecialType);
  CheckFalse( fsNegative = NaN2.SpecialType);
  CheckFalse(      fsInf = NaN2.SpecialType);
  CheckFalse(     fsNInf = NaN2.SpecialType);
  CheckTrue(       fsNaN = NaN2.SpecialType);

  CheckFalse(     fsZero = NaN3.SpecialType);
  CheckFalse(    fsNZero = NaN3.SpecialType);
  CheckFalse( fsDenormal = NaN3.SpecialType);
  CheckFalse(fsNDenormal = NaN3.SpecialType);
  CheckFalse( fsPositive = NaN3.SpecialType);
  CheckFalse( fsNegative = NaN3.SpecialType);
  CheckFalse(      fsInf = NaN3.SpecialType);
  CheckFalse(     fsNInf = NaN3.SpecialType);
  CheckTrue(       fsNaN = NaN3.SpecialType);

  CheckFalse(     fsZero = NaN4.SpecialType);
  CheckFalse(    fsNZero = NaN4.SpecialType);
  CheckFalse( fsDenormal = NaN4.SpecialType);
  CheckFalse(fsNDenormal = NaN4.SpecialType);
  CheckFalse( fsPositive = NaN4.SpecialType);
  CheckFalse( fsNegative = NaN4.SpecialType);
  CheckFalse(      fsInf = NaN4.SpecialType);
  CheckFalse(     fsNInf = NaN4.SpecialType);
  CheckTrue(       fsNaN = NaN4.SpecialType);

  CheckFalse(     fsZero = NaN5.SpecialType);
  CheckFalse(    fsNZero = NaN5.SpecialType);
  CheckFalse( fsDenormal = NaN5.SpecialType);
  CheckFalse(fsNDenormal = NaN5.SpecialType);
  CheckFalse( fsPositive = NaN5.SpecialType);
  CheckFalse( fsNegative = NaN5.SpecialType);
  CheckFalse(      fsInf = NaN5.SpecialType);
  CheckFalse(     fsNInf = NaN5.SpecialType);
  CheckTrue(       fsNaN = NaN5.SpecialType);

  CheckFalse(     fsZero = NaN6.SpecialType);
  CheckFalse(    fsNZero = NaN6.SpecialType);
  CheckFalse( fsDenormal = NaN6.SpecialType);
  CheckFalse(fsNDenormal = NaN6.SpecialType);
  CheckFalse( fsPositive = NaN6.SpecialType);
  CheckFalse( fsNegative = NaN6.SpecialType);
  CheckFalse(      fsInf = NaN6.SpecialType);
  CheckFalse(     fsNInf = NaN6.SpecialType);
  CheckTrue(       fsNaN = NaN6.SpecialType);
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestBuildUp;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  Value.BuildUp(False, 0, 16384);
  SwapToBig(ValueArray);

  CheckEquals($7f, ValueArray[0]);
  CheckEquals($ff, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  CheckEquals($00, ValueArray[8]);
  CheckEquals($00, ValueArray[9]);

  Value.BuildUp(True, UInt64($ffffffffffffffff), -16383);
  SwapToBig(ValueArray);

  CheckEquals($80, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);
  CheckEquals($ff, ValueArray[8]);
  CheckEquals($ff, ValueArray[9]);


  { Overflow }

  Value.BuildUp(False, 0, 16385);
  SwapToBig(ValueArray);

  CheckEquals($00, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  CheckEquals($00, ValueArray[8]);
  CheckEquals($00, ValueArray[9]);

  Value.BuildUp(False, 0, $7fffffff);
  SwapToBig(ValueArray);

  CheckEquals($3f, ValueArray[0]);
  CheckEquals($fe, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);
  CheckEquals($00, ValueArray[8]);
  CheckEquals($00, ValueArray[9]);

  { No final test, cause we can't owerflow 64-bit mantissa. :) }
  {$ELSE}
  Value.BuildUp(False, 0, 1024);
  SwapToBig(ValueArray);

  CheckEquals($7f, ValueArray[0]);
  CheckEquals($f0, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);

  Value.BuildUp(True, UInt64($000fffffffffffff), -1023);
  SwapToBig(ValueArray);

  CheckEquals($80, ValueArray[0]);
  CheckEquals($0f, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);


  { Overflow }

  Value.BuildUp(False, 0, 1025);
  SwapToBig(ValueArray);

  CheckEquals($00, ValueArray[0]);
  CheckEquals($00, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);

  Value.BuildUp(False, 0, $7fffffff);
  SwapToBig(ValueArray);

  CheckEquals($3f, ValueArray[0]);
  CheckEquals($e0, ValueArray[1]);
  CheckEquals($00, ValueArray[2]);
  CheckEquals($00, ValueArray[3]);
  CheckEquals($00, ValueArray[4]);
  CheckEquals($00, ValueArray[5]);
  CheckEquals($00, ValueArray[6]);
  CheckEquals($00, ValueArray[7]);

  Value.BuildUp(False, UInt64($ffffffffffffffff), -127);
  SwapToBig(ValueArray);

  CheckEquals($38, ValueArray[0]);
  CheckEquals($0f, ValueArray[1]);
  CheckEquals($ff, ValueArray[2]);
  CheckEquals($ff, ValueArray[3]);
  CheckEquals($ff, ValueArray[4]);
  CheckEquals($ff, ValueArray[5]);
  CheckEquals($ff, ValueArray[6]);
  CheckEquals($ff, ValueArray[7]);
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestToString1;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($3f, $ff, $e0, $00, $00, $00, $00, $00, $00, $00); { 1.75, normal }
  CheckEquals('1' + FormatSettings.DecimalSeparator + '75', Value.ToString);
  CheckEquals('1' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value));

  ValueArray := MakeExtended($bf, $fd, $80, $00, $00, $00, $00, $00, $00, $00); { -0.25, normal }
  CheckEquals('-0' + FormatSettings.DecimalSeparator + '25', Value.ToString);
  CheckEquals('-0' + FormatSettings.DecimalSeparator + '25', Extended.ToString(Value));

  (* Returns zero due Delphi bug RSP-17142
  ValueArray := MakeExtended($00, $00, $07, $fe, $b8, $08, $eb, $42, $c8, $00); { 2.1e-4933, subnormal }
  CheckEquals('2' + FormatSettings.DecimalSeparator + '1E-4933', UpperCase(Value.ToString));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '1E-4933', UpperCase(Extended.ToString(Value))); *)

  ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString));
  CheckEquals('INF', UpperCase(Extended.ToString(Value)));

  ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value)));

  ValueArray := MakeExtended($7f, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value)));
  {$ELSE}
  ValueArray := MakeExtended($3f, $fc, $00, $00, $00, $00, $00, $00); { 1.75, normal }
  CheckEquals('1' + FormatSettings.DecimalSeparator + '75', Value.ToString);
  CheckEquals('1' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value));

  ValueArray := MakeExtended($bf, $d0, $00, $00, $00, $00, $00, $00); { -0.25, normal }
  CheckEquals('-0' + FormatSettings.DecimalSeparator + '25', Value.ToString);
  CheckEquals('-0' + FormatSettings.DecimalSeparator + '25', Extended.ToString(Value));

  ValueArray := MakeExtended($00, $02, $b9, $70, $2e, $44, $00, $00); { 3.7887e-309, subnormal }
  CheckEquals('3' + FormatSettings.DecimalSeparator + '7887E-309', UpperCase(Value.ToString));
  CheckEquals('3' + FormatSettings.DecimalSeparator + '7887E-309', UpperCase(Extended.ToString(Value)));

  ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString));
  CheckEquals('INF', UpperCase(Extended.ToString(Value)));

  ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value)));

  ValueArray := MakeExtended($7f, $f8, $00, $00, $00, $00, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value)));
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestToString2;
{$IFDEF RUN_TESTS}
var
  LocalFormat: TFormatSettings;
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  LocalFormat := TFormatSettings.Create;
  LocalFormat.DecimalSeparator := ';';

  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($3f, $ff, $e0, $00, $00, $00, $00, $00, $00, $00); { 1.75, normal }
  CheckEquals('1;75', Value.ToString(LocalFormat));
  CheckEquals('1;75', Extended.ToString(Value, LocalFormat));

  ValueArray := MakeExtended($bf, $fd, $80, $00, $00, $00, $00, $00, $00, $00); { -0.25, normal }
  CheckEquals('-0;25', Value.ToString(LocalFormat));
  CheckEquals('-0;25', Extended.ToString(Value, LocalFormat));

  (* Returns zero due Delphi bug RSP-17142
  ValueArray := MakeExtended($00, $00, $07, $fe, $b8, $08, $eb, $42, $c8, $00); { 2.1e-4933, subnormal }
  CheckEquals('2;1E-4933', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('2;1E-4933', UpperCase(Extended.ToString(Value, LocalFormat))); *)

  ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, LocalFormat)));

  ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, LocalFormat)));

  ValueArray := MakeExtended($7f, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, LocalFormat)));
  {$ELSE}
  ValueArray := MakeExtended($3f, $fc, $00, $00, $00, $00, $00, $00); { 1.75, normal }
  CheckEquals('1;75', Value.ToString(LocalFormat));
  CheckEquals('1;75', Extended.ToString(Value, LocalFormat));

  ValueArray := MakeExtended($bf, $d0, $00, $00, $00, $00, $00, $00); { -0.25, normal }
  CheckEquals('-0;25', Value.ToString(LocalFormat));
  CheckEquals('-0;25', Extended.ToString(Value, LocalFormat));

  ValueArray := MakeExtended($00, $02, $b9, $70, $2e, $44, $00, $00); { 3.7887e-309, subnormal }
  CheckEquals('3;7887E-309', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('3;7887E-309', UpperCase(Extended.ToString(Value, LocalFormat)));

  ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, LocalFormat)));

  ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, LocalFormat)));

  ValueArray := MakeExtended($7f, $f8, $00, $00, $00, $00, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, LocalFormat)));
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestToString3;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
  TestStr: string;
begin
  {$IFDEF CPUEXTENDED}
  Value := 2.4e310;
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E310', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E310', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '400000E+310', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '400000E+310', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E310', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E310', UpperCase(Extended.ToString(Value, ffFixed, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E310', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E310', UpperCase(Extended.ToString(Value, ffNumber, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E310', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E310', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeExtended($bf, $ff, $e0, $00, $00, $00, $00, $00, $00, $00); { -1.75 }
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffGeneral, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value, ffGeneral, 7, 2));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750000E+00', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750000E+00', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffFixed, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value, ffFixed, 7, 2));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750', Value.ToString(ffFixed, 7, 3));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750', Extended.ToString(Value, ffFixed, 7, 3));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffNumber, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value, ffNumber, 7, 2));

  ValueArray := MakeExtended($c0, $12, $f4, $24, $0c, $00, $00, $00, $00, $00); { -1000000.75 }
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '001' + FormatSettings.DecimalSeparator + '00', Value.ToString(ffNumber, 7, 2));
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '001' + FormatSettings.DecimalSeparator + '00', Extended.ToString(Value, ffNumber, 7, 2));

  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffNumber, 9, 2));
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value, ffNumber, 9, 2));

  ValueArray := MakeExtended($3f, $ff, $e0, $00, $00, $00, $00, $00, $00, $00); { 1.75 }
  case FormatSettings.CurrencyFormat of
    0:
      TestStr := FormatSettings.CurrencyString + '1' + FormatSettings.DecimalSeparator + '75';
    1:
      TestStr := '1' + FormatSettings.DecimalSeparator + '75' + FormatSettings.CurrencyString;
    2:
      TestStr := FormatSettings.CurrencyString + ' 1' + FormatSettings.DecimalSeparator + '75';
    3:
      TestStr := '1' + FormatSettings.DecimalSeparator + '75 ' + FormatSettings.CurrencyString;
    else
      Fail('Unexpected FormatSettings.CurrencyFormat');
  end;
  CheckEquals(TestStr, UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals(TestStr, UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeExtended($c0, $12, $f4, $24, $0c, $00, $00, $00, $00, $00); { -1000000.75 }
  TestStr := '1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75';
  case FormatSettings.NegCurrFormat of
    0:
      TestStr := '(' + FormatSettings.CurrencyString + TestStr +')';
    1:
      TestStr := '-' + FormatSettings.CurrencyString + TestStr;
    2:
      TestStr := '' + FormatSettings.CurrencyString + '-' + TestStr;
    3:
      TestStr := '' + FormatSettings.CurrencyString + TestStr + '-';
    4:
      TestStr := '(' + TestStr + FormatSettings.CurrencyString + ')';
    5:
      TestStr := '-' + TestStr + FormatSettings.CurrencyString;
    6:
      TestStr := TestStr +'-' + FormatSettings.CurrencyString;
    7:
      TestStr := TestStr + FormatSettings.CurrencyString + '-';
    8:
      TestStr := '-' + TestStr + ' ' + FormatSettings.CurrencyString;
    9:
      TestStr := '-' + FormatSettings.CurrencyString + ' ' + TestStr;
    10:
      TestStr := TestStr +' ' + FormatSettings.CurrencyString + '-';
    11:
      TestStr := FormatSettings.CurrencyString + ' ' + TestStr + '-';
    12:
      TestStr := FormatSettings.CurrencyString + ' -' + TestStr;
    13:
      TestStr := TestStr +'- ' + FormatSettings.CurrencyString;
    14:
      TestStr := '(' + FormatSettings.CurrencyString + ' ' + TestStr + ')';
    15:
      TestStr := '(' + TestStr + ' ' + FormatSettings.CurrencyString + ')';
    else
      Fail('Unexpected FormatSettings.NegCurrFormat');
  end;
  CheckEquals(TestStr, UpperCase(Value.ToString(ffCurrency, 9, 2)));
  CheckEquals(TestStr, UpperCase(Extended.ToString(Value, ffCurrency, 9, 2)));

  ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeExtended($7f, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));
  {$ELSE}
  Value := 2.4e68;
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E68', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E68', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '400000E+68', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '400000E+68', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E68', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E68', UpperCase(Extended.ToString(Value, ffFixed, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E68', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E68', UpperCase(Extended.ToString(Value, ffNumber, 7, 2)));

  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E68', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('2' + FormatSettings.DecimalSeparator + '4E68', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeExtended($bf, $fc, $00, $00, $00, $00, $00, $00); { -1.75 }
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffGeneral, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value, ffGeneral, 7, 2));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750000E+00', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750000E+00', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffFixed, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value, ffFixed, 7, 2));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750', Value.ToString(ffFixed, 7, 3));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '750', Extended.ToString(Value, ffFixed, 7, 3));

  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffNumber, 7, 2));
  CheckEquals('-1' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value, ffNumber, 7, 2));

  ValueArray := MakeExtended($c1, $2e, $84, $81, $80, $00, $00, $00); { -1000000.75 }
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '001' + FormatSettings.DecimalSeparator + '00', Value.ToString(ffNumber, 7, 2));
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '001' + FormatSettings.DecimalSeparator + '00', Extended.ToString(Value, ffNumber, 7, 2));

  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75', Value.ToString(ffNumber, 9, 2));
  CheckEquals('-1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75', Extended.ToString(Value, ffNumber, 9, 2));

  ValueArray := MakeExtended($3f, $fc, $00, $00, $00, $00, $00, $00); { 1.75 }
  case FormatSettings.CurrencyFormat of
    0:
      TestStr := FormatSettings.CurrencyString + '1' + FormatSettings.DecimalSeparator + '75';
    1:
      TestStr := '1' + FormatSettings.DecimalSeparator + '75' + FormatSettings.CurrencyString;
    2:
      TestStr := FormatSettings.CurrencyString + ' 1' + FormatSettings.DecimalSeparator + '75';
    3:
      TestStr := '1' + FormatSettings.DecimalSeparator + '75 ' + FormatSettings.CurrencyString;
    else
      Fail('Unexpected FormatSettings.CurrencyFormat');
  end;
  CheckEquals(TestStr, UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals(TestStr, UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeExtended($c1, $2e, $84, $81, $80, $00, $00, $00); { -1000000.75 }
  TestStr := '1' + FormatSettings.ThousandSeparator + '000' + FormatSettings.ThousandSeparator + '000' + FormatSettings.DecimalSeparator + '75';
  case FormatSettings.NegCurrFormat of
    0:
      TestStr := '(' + FormatSettings.CurrencyString + TestStr +')';
    1:
      TestStr := '-' + FormatSettings.CurrencyString + TestStr;
    2:
      TestStr := '' + FormatSettings.CurrencyString + '-' + TestStr;
    3:
      TestStr := '' + FormatSettings.CurrencyString + TestStr + '-';
    4:
      TestStr := '(' + TestStr + FormatSettings.CurrencyString + ')';
    5:
      TestStr := '-' + TestStr + FormatSettings.CurrencyString;
    6:
      TestStr := TestStr +'-' + FormatSettings.CurrencyString;
    7:
      TestStr := TestStr + FormatSettings.CurrencyString + '-';
    8:
      TestStr := '-' + TestStr + ' ' + FormatSettings.CurrencyString;
    9:
      TestStr := '-' + FormatSettings.CurrencyString + ' ' + TestStr;
    10:
      TestStr := TestStr +' ' + FormatSettings.CurrencyString + '-';
    11:
      TestStr := FormatSettings.CurrencyString + ' ' + TestStr + '-';
    12:
      TestStr := FormatSettings.CurrencyString + ' -' + TestStr;
    13:
      TestStr := TestStr +'- ' + FormatSettings.CurrencyString;
    14:
      TestStr := '(' + FormatSettings.CurrencyString + ' ' + TestStr + ')';
    15:
      TestStr := '(' + TestStr + ' ' + FormatSettings.CurrencyString + ')';
    else
      Fail('Unexpected FormatSettings.NegCurrFormat');
  end;
  CheckEquals(TestStr, UpperCase(Value.ToString(ffCurrency, 9, 2)));
  CheckEquals(TestStr, UpperCase(Extended.ToString(Value, ffCurrency, 9, 2)));

  ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));

  ValueArray := MakeExtended($7f, $f8, $00, $00, $00, $00, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(ffGeneral, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffExponent, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffExponent, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffFixed, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffFixed, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffNumber, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffNumber, 7, 2)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2)));
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestToString4;
{$IFDEF RUN_TESTS}
var
  LocalFormat: TFormatSettings;
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
  i: Byte;
begin
  LocalFormat := TFormatSettings.Create;
  LocalFormat.ThousandSeparator := '~';
  LocalFormat.DecimalSeparator := ';';
  LocalFormat.CurrencyString := '[@]';
  LocalFormat.CurrencyDecimals := 1;
  LocalFormat.CurrencyFormat := 0;
  LocalFormat.NegCurrFormat := 0;

  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($c0, $12, $f4, $24, $0c, $00, $00, $00, $00, $00); { -1000000.75 }

  CheckEquals('-1000000;75', Value.ToString(ffGeneral, 9, 2, LocalFormat));
  CheckEquals('-1000000;75', Extended.ToString(Value, ffGeneral, 9, 2, LocalFormat));

  CheckEquals('-1;00000075E+06', UpperCase(Value.ToString(ffExponent, 9, 2, LocalFormat)));
  CheckEquals('-1;00000075E+06', UpperCase(Extended.ToString(Value, ffExponent, 9, 2, LocalFormat)));

  CheckEquals('-1000000;75', Value.ToString(ffFixed, 9, 2, LocalFormat));
  CheckEquals('-1000000;75', Extended.ToString(Value, ffFixed, 9, 2, LocalFormat));

  CheckEquals('-1000000;750', Value.ToString(ffFixed, 9, 3, LocalFormat));
  CheckEquals('-1000000;750', Extended.ToString(Value, ffFixed, 9, 3, LocalFormat));

  CheckEquals('-1~000~000;75', Value.ToString(ffNumber, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75', Extended.ToString(Value, ffNumber, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 15;
  CheckEquals('(1~000~000;75 [@])', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('(1~000~000;75 [@])', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 14;
  CheckEquals('([@] 1~000~000;75)', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('([@] 1~000~000;75)', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 13;
  CheckEquals('1~000~000;75- [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75- [@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 12;
  CheckEquals('[@] -1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] -1~000~000;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 11;
  CheckEquals('[@] 1~000~000;75-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] 1~000~000;75-', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 10;
  CheckEquals('1~000~000;75 [@]-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75 [@]-', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 9;
  CheckEquals('-[@] 1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-[@] 1~000~000;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 8;
  CheckEquals('-1~000~000;75 [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75 [@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 7;
  CheckEquals('1~000~000;75[@]-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75[@]-', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 6;
  CheckEquals('1~000~000;75-[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75-[@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 5;
  CheckEquals('-1~000~000;75[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75[@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 4;
  CheckEquals('(1~000~000;75[@])', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('(1~000~000;75[@])', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 3;
  CheckEquals('[@]1~000~000;75-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]1~000~000;75-', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 2;
  CheckEquals('[@]-1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]-1~000~000;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 1;
  CheckEquals('-[@]1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-[@]1~000~000;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 0;
  CheckEquals('([@]1~000~000;75)', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('([@]1~000~000;75)', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  ValueArray := MakeExtended($3f, $ff, $e0, $00, $00, $00, $00, $00, $00, $00); { 1.75 }

  LocalFormat.CurrencyFormat := 3;
  CheckEquals('1;75 [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1;75 [@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 2;
  CheckEquals('[@] 1;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] 1;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 1;
  CheckEquals('1;75[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1;75[@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 0;
  CheckEquals('[@]1;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]1;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));


  ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffNumber, 7, 2, LocalFormat)));

  ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffNumber, 7, 2, LocalFormat)));

  ValueArray := MakeExtended($7f, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffNumber, 7, 2, LocalFormat)));


  for i := 3 downto 0 do
  begin
    LocalFormat.CurrencyFormat := i;

    ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { +INF }
    CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { -INF }
    CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeExtended($7f, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { NaN }
    CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));
  end;

  for i := 15 downto 0 do
  begin
    LocalFormat.NegCurrFormat := i;

    ValueArray := MakeExtended($7f, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { +INF }
    CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeExtended($ff, $ff, $80, $00, $00, $00, $00, $00, $00, $00); { -INF }
    CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeExtended($7f, $ff, $c0, $00, $00, $00, $00, $00, $00, $00); { NaN }
    CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));
  end;
  {$ELSE}
  ValueArray := MakeExtended($c1, $2e, $84, $81, $80, $00, $00, $00); { -1000000.75 }

  CheckEquals('-1000000;75', Value.ToString(ffGeneral, 9, 2, LocalFormat));
  CheckEquals('-1000000;75', Extended.ToString(Value, ffGeneral, 9, 2, LocalFormat));

  CheckEquals('-1;00000075E+06', UpperCase(Value.ToString(ffExponent, 9, 2, LocalFormat)));
  CheckEquals('-1;00000075E+06', UpperCase(Extended.ToString(Value, ffExponent, 9, 2, LocalFormat)));

  CheckEquals('-1000000;75', Value.ToString(ffFixed, 9, 2, LocalFormat));
  CheckEquals('-1000000;75', Extended.ToString(Value, ffFixed, 9, 2, LocalFormat));

  CheckEquals('-1000000;750', Value.ToString(ffFixed, 9, 3, LocalFormat));
  CheckEquals('-1000000;750', Extended.ToString(Value, ffFixed, 9, 3, LocalFormat));

  CheckEquals('-1~000~000;75', Value.ToString(ffNumber, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75', Extended.ToString(Value, ffNumber, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 15;
  CheckEquals('(1~000~000;75 [@])', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('(1~000~000;75 [@])', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 14;
  CheckEquals('([@] 1~000~000;75)', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('([@] 1~000~000;75)', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 13;
  CheckEquals('1~000~000;75- [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75- [@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 12;
  CheckEquals('[@] -1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] -1~000~000;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 11;
  CheckEquals('[@] 1~000~000;75-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] 1~000~000;75-', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 10;
  CheckEquals('1~000~000;75 [@]-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75 [@]-', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 9;
  CheckEquals('-[@] 1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-[@] 1~000~000;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 8;
  CheckEquals('-1~000~000;75 [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75 [@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 7;
  CheckEquals('1~000~000;75[@]-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75[@]-', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 6;
  CheckEquals('1~000~000;75-[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1~000~000;75-[@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 5;
  CheckEquals('-1~000~000;75[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-1~000~000;75[@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 4;
  CheckEquals('(1~000~000;75[@])', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('(1~000~000;75[@])', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 3;
  CheckEquals('[@]1~000~000;75-', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]1~000~000;75-', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 2;
  CheckEquals('[@]-1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]-1~000~000;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 1;
  CheckEquals('-[@]1~000~000;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('-[@]1~000~000;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.NegCurrFormat := 0;
  CheckEquals('([@]1~000~000;75)', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('([@]1~000~000;75)', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  ValueArray := MakeExtended($3f, $fc, $00, $00, $00, $00, $00, $00); { 1.75 }

  LocalFormat.CurrencyFormat := 3;
  CheckEquals('1;75 [@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1;75 [@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 2;
  CheckEquals('[@] 1;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@] 1;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 1;
  CheckEquals('1;75[@]', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('1;75[@]', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));

  LocalFormat.CurrencyFormat := 0;
  CheckEquals('[@]1;75', Value.ToString(ffCurrency, 9, 2, LocalFormat));
  CheckEquals('[@]1;75', Extended.ToString(Value, ffCurrency, 9, 2, LocalFormat));


  ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { +INF }
  CheckEquals('INF', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('INF', UpperCase(Extended.ToString(Value, ffNumber, 7, 2, LocalFormat)));

  ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { -INF }
  CheckEquals('-INF', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffNumber, 7, 2, LocalFormat)));

  ValueArray := MakeExtended($7f, $f8, $00, $00, $00, $00, $00, $00); { NaN }
  CheckEquals('NAN', UpperCase(Value.ToString(ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffGeneral, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffExponent, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffExponent, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffFixed, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffFixed, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Value.ToString(ffNumber, 7, 2, LocalFormat)));
  CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffNumber, 7, 2, LocalFormat)));


  for i := 3 downto 0 do
  begin
    LocalFormat.CurrencyFormat := i;

    ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { +INF }
    CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { -INF }
    CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeExtended($7f, $f8, $00, $00, $00, $00, $00, $00); { NaN }
    CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));
  end;

  for i := 15 downto 0 do
  begin
    LocalFormat.NegCurrFormat := i;

    ValueArray := MakeExtended($7f, $f0, $00, $00, $00, $00, $00, $00); { +INF }
    CheckEquals('INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeExtended($ff, $f0, $00, $00, $00, $00, $00, $00); { -INF }
    CheckEquals('-INF', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('-INF', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));

    ValueArray := MakeExtended($7f, $f8, $00, $00, $00, $00, $00, $00); { NaN }
    CheckEquals('NAN', UpperCase(Value.ToString(ffCurrency, 7, 2, LocalFormat)));
    CheckEquals('NAN', UpperCase(Extended.ToString(Value, ffCurrency, 7, 2, LocalFormat)));
  end;
  {$ENDIF CPUEXTENDED}
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestIsNan;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Extended;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  CheckFalse(Zero.IsNan);
  CheckFalse(NZero.IsNan);
  CheckFalse(SubNormalMin.IsNan);
  CheckFalse(SubNormalMid.IsNan);
  CheckFalse(SubNormalMax.IsNan);
  CheckFalse(NSubNormalMin.IsNan);
  CheckFalse(NSubNormalMid.IsNan);
  CheckFalse(NSubNormalMax.IsNan);
  CheckFalse(NormalMin.IsNan);
  CheckFalse(NormalMid.IsNan);
  CheckFalse(NormalMax.IsNan);
  CheckFalse(NNormalMin.IsNan);
  CheckFalse(NNormalMid.IsNan);
  CheckFalse(NNormalMax.IsNan);
  CheckFalse(Inf.IsNan);
  CheckFalse(NInf.IsNan);
  CheckTrue(NaN1.IsNan);
  CheckTrue(NaN2.IsNan);
  CheckTrue(NaN3.IsNan);
  CheckTrue(NaN4.IsNan);
  CheckTrue(NaN5.IsNan);
  CheckTrue(NaN6.IsNan);

  CheckFalse(Extended.IsNan(Zero));
  CheckFalse(Extended.IsNan(NZero));
  CheckFalse(Extended.IsNan(SubNormalMin));
  CheckFalse(Extended.IsNan(SubNormalMid));
  CheckFalse(Extended.IsNan(SubNormalMax));
  CheckFalse(Extended.IsNan(NSubNormalMin));
  CheckFalse(Extended.IsNan(NSubNormalMid));
  CheckFalse(Extended.IsNan(NSubNormalMax));
  CheckFalse(Extended.IsNan(NormalMin));
  CheckFalse(Extended.IsNan(NormalMid));
  CheckFalse(Extended.IsNan(NormalMax));
  CheckFalse(Extended.IsNan(NNormalMin));
  CheckFalse(Extended.IsNan(NNormalMid));
  CheckFalse(Extended.IsNan(NNormalMax));
  CheckFalse(Extended.IsNan(Inf));
  CheckFalse(Extended.IsNan(NInf));
  CheckTrue(Extended.IsNan(NaN1));
  CheckTrue(Extended.IsNan(NaN2));
  CheckTrue(Extended.IsNan(NaN3));
  CheckTrue(Extended.IsNan(NaN4));
  CheckTrue(Extended.IsNan(NaN5));
  CheckTrue(Extended.IsNan(NaN6));
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestIsInfinity;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Extended;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  CheckFalse(Zero.IsInfinity);
  CheckFalse(NZero.IsInfinity);
  CheckFalse(SubNormalMin.IsInfinity);
  CheckFalse(SubNormalMid.IsInfinity);
  CheckFalse(SubNormalMax.IsInfinity);
  CheckFalse(NSubNormalMin.IsInfinity);
  CheckFalse(NSubNormalMid.IsInfinity);
  CheckFalse(NSubNormalMax.IsInfinity);
  CheckFalse(NormalMin.IsInfinity);
  CheckFalse(NormalMid.IsInfinity);
  CheckFalse(NormalMax.IsInfinity);
  CheckFalse(NNormalMin.IsInfinity);
  CheckFalse(NNormalMid.IsInfinity);
  CheckFalse(NNormalMax.IsInfinity);
  CheckTrue(Inf.IsInfinity);
  CheckTrue(NInf.IsInfinity);
  CheckFalse(NaN1.IsInfinity);
  CheckFalse(NaN2.IsInfinity);
  CheckFalse(NaN3.IsInfinity);
  CheckFalse(NaN4.IsInfinity);
  CheckFalse(NaN5.IsInfinity);
  CheckFalse(NaN6.IsInfinity);

  CheckFalse(Extended.IsInfinity(Zero));
  CheckFalse(Extended.IsInfinity(NZero));
  CheckFalse(Extended.IsInfinity(SubNormalMin));
  CheckFalse(Extended.IsInfinity(SubNormalMid));
  CheckFalse(Extended.IsInfinity(SubNormalMax));
  CheckFalse(Extended.IsInfinity(NSubNormalMin));
  CheckFalse(Extended.IsInfinity(NSubNormalMid));
  CheckFalse(Extended.IsInfinity(NSubNormalMax));
  CheckFalse(Extended.IsInfinity(NormalMin));
  CheckFalse(Extended.IsInfinity(NormalMid));
  CheckFalse(Extended.IsInfinity(NormalMax));
  CheckFalse(Extended.IsInfinity(NNormalMin));
  CheckFalse(Extended.IsInfinity(NNormalMid));
  CheckFalse(Extended.IsInfinity(NNormalMax));
  CheckTrue(Extended.IsInfinity(Inf));
  CheckTrue(Extended.IsInfinity(NInf));
  CheckFalse(Extended.IsInfinity(NaN1));
  CheckFalse(Extended.IsInfinity(NaN2));
  CheckFalse(Extended.IsInfinity(NaN3));
  CheckFalse(Extended.IsInfinity(NaN4));
  CheckFalse(Extended.IsInfinity(NaN5));
  CheckFalse(Extended.IsInfinity(NaN6));
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestIsNegativeInfinity;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Extended;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  CheckFalse(Zero.IsNegativeInfinity);
  CheckFalse(NZero.IsNegativeInfinity);
  CheckFalse(SubNormalMin.IsNegativeInfinity);
  CheckFalse(SubNormalMid.IsNegativeInfinity);
  CheckFalse(SubNormalMax.IsNegativeInfinity);
  CheckFalse(NSubNormalMin.IsNegativeInfinity);
  CheckFalse(NSubNormalMid.IsNegativeInfinity);
  CheckFalse(NSubNormalMax.IsNegativeInfinity);
  CheckFalse(NormalMin.IsNegativeInfinity);
  CheckFalse(NormalMid.IsNegativeInfinity);
  CheckFalse(NormalMax.IsNegativeInfinity);
  CheckFalse(NNormalMin.IsNegativeInfinity);
  CheckFalse(NNormalMid.IsNegativeInfinity);
  CheckFalse(NNormalMax.IsNegativeInfinity);
  CheckFalse(Inf.IsNegativeInfinity);
  CheckTrue(NInf.IsNegativeInfinity);
  CheckFalse(NaN1.IsNegativeInfinity);
  CheckFalse(NaN2.IsNegativeInfinity);
  CheckFalse(NaN3.IsNegativeInfinity);
  CheckFalse(NaN4.IsNegativeInfinity);
  CheckFalse(NaN5.IsNegativeInfinity);
  CheckFalse(NaN6.IsNegativeInfinity);

  CheckFalse(Extended.IsNegativeInfinity(Zero));
  CheckFalse(Extended.IsNegativeInfinity(NZero));
  CheckFalse(Extended.IsNegativeInfinity(SubNormalMin));
  CheckFalse(Extended.IsNegativeInfinity(SubNormalMid));
  CheckFalse(Extended.IsNegativeInfinity(SubNormalMax));
  CheckFalse(Extended.IsNegativeInfinity(NSubNormalMin));
  CheckFalse(Extended.IsNegativeInfinity(NSubNormalMid));
  CheckFalse(Extended.IsNegativeInfinity(NSubNormalMax));
  CheckFalse(Extended.IsNegativeInfinity(NormalMin));
  CheckFalse(Extended.IsNegativeInfinity(NormalMid));
  CheckFalse(Extended.IsNegativeInfinity(NormalMax));
  CheckFalse(Extended.IsNegativeInfinity(NNormalMin));
  CheckFalse(Extended.IsNegativeInfinity(NNormalMid));
  CheckFalse(Extended.IsNegativeInfinity(NNormalMax));
  CheckFalse(Extended.IsNegativeInfinity(Inf));
  CheckTrue(Extended.IsNegativeInfinity(NInf));
  CheckFalse(Extended.IsNegativeInfinity(NaN1));
  CheckFalse(Extended.IsNegativeInfinity(NaN2));
  CheckFalse(Extended.IsNegativeInfinity(NaN3));
  CheckFalse(Extended.IsNegativeInfinity(NaN4));
  CheckFalse(Extended.IsNegativeInfinity(NaN5));
  CheckFalse(Extended.IsNegativeInfinity(NaN6));
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestIsPositiveInfinity;
{$IFDEF RUN_TESTS}
var
  Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
  NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
  NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6: Extended;
begin
  PrepareValues(
    Zero, NZero, SubNormalMin, SubNormalMid, SubNormalMax, NSubNormalMin,
    NSubNormalMid, NSubNormalMax, NormalMin, NormalMid, NormalMax, NNormalMin,
    NNormalMid, NNormalMax, Inf, NInf, NaN1, NaN2, NaN3, NaN4, NaN5, NaN6
  );

  CheckFalse(Zero.IsPositiveInfinity);
  CheckFalse(NZero.IsPositiveInfinity);
  CheckFalse(SubNormalMin.IsPositiveInfinity);
  CheckFalse(SubNormalMid.IsPositiveInfinity);
  CheckFalse(SubNormalMax.IsPositiveInfinity);
  CheckFalse(NSubNormalMin.IsPositiveInfinity);
  CheckFalse(NSubNormalMid.IsPositiveInfinity);
  CheckFalse(NSubNormalMax.IsPositiveInfinity);
  CheckFalse(NormalMin.IsPositiveInfinity);
  CheckFalse(NormalMid.IsPositiveInfinity);
  CheckFalse(NormalMax.IsPositiveInfinity);
  CheckFalse(NNormalMin.IsPositiveInfinity);
  CheckFalse(NNormalMid.IsPositiveInfinity);
  CheckFalse(NNormalMax.IsPositiveInfinity);
  CheckTrue(Inf.IsPositiveInfinity);
  CheckFalse(NInf.IsPositiveInfinity);
  CheckFalse(NaN1.IsPositiveInfinity);
  CheckFalse(NaN2.IsPositiveInfinity);
  CheckFalse(NaN3.IsPositiveInfinity);
  CheckFalse(NaN4.IsPositiveInfinity);
  CheckFalse(NaN5.IsPositiveInfinity);
  CheckFalse(NaN6.IsPositiveInfinity);

  CheckFalse(Extended.IsPositiveInfinity(Zero));
  CheckFalse(Extended.IsPositiveInfinity(NZero));
  CheckFalse(Extended.IsPositiveInfinity(SubNormalMin));
  CheckFalse(Extended.IsPositiveInfinity(SubNormalMid));
  CheckFalse(Extended.IsPositiveInfinity(SubNormalMax));
  CheckFalse(Extended.IsPositiveInfinity(NSubNormalMin));
  CheckFalse(Extended.IsPositiveInfinity(NSubNormalMid));
  CheckFalse(Extended.IsPositiveInfinity(NSubNormalMax));
  CheckFalse(Extended.IsPositiveInfinity(NormalMin));
  CheckFalse(Extended.IsPositiveInfinity(NormalMid));
  CheckFalse(Extended.IsPositiveInfinity(NormalMax));
  CheckFalse(Extended.IsPositiveInfinity(NNormalMin));
  CheckFalse(Extended.IsPositiveInfinity(NNormalMid));
  CheckFalse(Extended.IsPositiveInfinity(NNormalMax));
  CheckTrue(Extended.IsPositiveInfinity(Inf));
  CheckFalse(Extended.IsPositiveInfinity(NInf));
  CheckFalse(Extended.IsPositiveInfinity(NaN1));
  CheckFalse(Extended.IsPositiveInfinity(NaN2));
  CheckFalse(Extended.IsPositiveInfinity(NaN3));
  CheckFalse(Extended.IsPositiveInfinity(NaN4));
  CheckFalse(Extended.IsPositiveInfinity(NaN5));
  CheckFalse(Extended.IsPositiveInfinity(NaN6));
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

{$IFDEF RUN_TESTS}
{$IFDEF FPC}{$PUSH}{$WARNINGS OFF}{$ENDIF}
procedure TestTExtendedHelper.BytesRangeOverflow;
var
  Value: Extended;
begin
  Value.Bytes[SizeOf(Extended)] := 1;
end;
{$IFDEF FPC}{$POP}{$ENDIF}
{$ENDIF RUN_TESTS}

procedure TestTExtendedHelper.TestBytes;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($c0, $00, $c9, $0f, $da, $a2, $21, $68, $c2, $39); { -pi. why "-"? because of sign bit. }

  {$IFDEF ENDIAN_LITTLE}
  CheckEquals($39, Value.Bytes[0]);
  CheckEquals($c2, Value.Bytes[1]);
  CheckEquals($68, Value.Bytes[2]);
  CheckEquals($21, Value.Bytes[3]);
  CheckEquals($a2, Value.Bytes[4]);
  CheckEquals($da, Value.Bytes[5]);
  CheckEquals($0f, Value.Bytes[6]);
  CheckEquals($c9, Value.Bytes[7]);
  CheckEquals($00, Value.Bytes[8]);
  CheckEquals($c0, Value.Bytes[9]);
  {$ELSE}
  CheckEquals($c0, Value.Bytes[0]);
  CheckEquals($00, Value.Bytes[1]);
  CheckEquals($c9, Value.Bytes[2]);
  CheckEquals($0f, Value.Bytes[3]);
  CheckEquals($da, Value.Bytes[4]);
  CheckEquals($a2, Value.Bytes[5]);
  CheckEquals($21, Value.Bytes[6]);
  CheckEquals($68, Value.Bytes[7]);
  CheckEquals($c2, Value.Bytes[8]);
  CheckEquals($39, Value.Bytes[9]);
  {$ENDIF}

  {$IFDEF ENDIAN_LITTLE}
  Value.Bytes[0] := $9d;
  Value.Bytes[1] := $4a;
  Value.Bytes[2] := $bb;
  Value.Bytes[3] := $a2;
  Value.Bytes[4] := $58;
  Value.Bytes[5] := $54;
  Value.Bytes[6] := $f8;
  Value.Bytes[7] := $ad;
  Value.Bytes[8] := $00;
  Value.Bytes[9] := $40;
  {$ELSE}
  Value.Bytes[0] := $40;
  Value.Bytes[1] := $00;
  Value.Bytes[2] := $ad;
  Value.Bytes[3] := $f8;
  Value.Bytes[4] := $54;
  Value.Bytes[5] := $58;
  Value.Bytes[6] := $a2;
  Value.Bytes[7] := $bb;
  Value.Bytes[8] := $4a;
  Value.Bytes[9] := $9d;
  {$ENDIF}

  SwapToBig(ValueArray);
  CheckEquals($40, ValueArray[0]);  { e }
  CheckEquals($00, ValueArray[1]);
  CheckEquals($ad, ValueArray[2]);
  CheckEquals($f8, ValueArray[3]);
  CheckEquals($54, ValueArray[4]);
  CheckEquals($58, ValueArray[5]);
  CheckEquals($a2, ValueArray[6]);
  CheckEquals($bb, ValueArray[7]);
  CheckEquals($4a, ValueArray[8]);
  CheckEquals($9d, ValueArray[9]);
  {$ELSE}
  ValueArray := MakeExtended($c0, $09, $21, $fb, $54, $44, $2d, $18); { -pi. why "-"? because of sign bit. }

  {$IFDEF ENDIAN_LITTLE}
  CheckEquals($18, Value.Bytes[0]);
  CheckEquals($2d, Value.Bytes[1]);
  CheckEquals($44, Value.Bytes[2]);
  CheckEquals($54, Value.Bytes[3]);
  CheckEquals($fb, Value.Bytes[4]);
  CheckEquals($21, Value.Bytes[5]);
  CheckEquals($09, Value.Bytes[6]);
  CheckEquals($c0, Value.Bytes[7]);
  {$ELSE}
  CheckEquals($c0, Value.Bytes[0]);
  CheckEquals($09, Value.Bytes[1]);
  CheckEquals($21, Value.Bytes[2]);
  CheckEquals($fb, Value.Bytes[3]);
  CheckEquals($54, Value.Bytes[4]);
  CheckEquals($44, Value.Bytes[5]);
  CheckEquals($2d, Value.Bytes[6]);
  CheckEquals($18, Value.Bytes[7]);
  {$ENDIF}

  {$IFDEF ENDIAN_LITTLE}
  Value.Bytes[0] := $69;
  Value.Bytes[1] := $57;
  Value.Bytes[2] := $14;
  Value.Bytes[3] := $8b;
  Value.Bytes[4] := $0a;
  Value.Bytes[5] := $bf;
  Value.Bytes[6] := $05;
  Value.Bytes[7] := $40;
  {$ELSE}
  Value.Bytes[0] := $40;
  Value.Bytes[1] := $05;
  Value.Bytes[2] := $bf;
  Value.Bytes[3] := $0a;
  Value.Bytes[4] := $8b;
  Value.Bytes[5] := $14;
  Value.Bytes[6] := $57;
  Value.Bytes[7] := $69;
  {$ENDIF}

  SwapToBig(ValueArray);
  CheckEquals($40, ValueArray[0]);  { e }
  CheckEquals($05, ValueArray[1]);
  CheckEquals($bf, ValueArray[2]);
  CheckEquals($0a, ValueArray[3]);
  CheckEquals($8b, ValueArray[4]);
  CheckEquals($14, ValueArray[5]);
  CheckEquals($57, ValueArray[6]);
  CheckEquals($69, ValueArray[7]);
  {$ENDIF CPUEXTENDED}

  CheckException(BytesRangeOverflow, ERangeError);
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

{$IFDEF RUN_TESTS}
{$IFDEF FPC}{$PUSH}{$WARNINGS OFF}{$ENDIF}
procedure TestTExtendedHelper.WordsRangeOverflow;
var
  Value: Extended;
begin
  Value.Words[SizeOf(Extended) div SizeOf(Word)] := 1;
end;
{$IFDEF FPC}{$POP}{$ENDIF}
{$ENDIF RUN_TESTS}

procedure TestTExtendedHelper.TestWords;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
  ValueArray: TExtendedArray absolute Value;
begin
  {$IFDEF CPUEXTENDED}
  ValueArray := MakeExtended($c0, $00, $c9, $0f, $da, $a2, $21, $68, $c2, $39); { -pi. why "-"? because of sign bit. }

  {$IFDEF ENDIAN_LITTLE}
  CheckEquals($c239, Value.Words[0]);
  CheckEquals($2168, Value.Words[1]);
  CheckEquals($daa2, Value.Words[2]);
  CheckEquals($c90f, Value.Words[3]);
  CheckEquals($c000, Value.Words[4]);
  {$ELSE}
  CheckEquals($c000, Value.Words[0]);
  CheckEquals($c90f, Value.Words[1]);
  CheckEquals($daa2, Value.Words[2]);
  CheckEquals($2168, Value.Words[3]);
  CheckEquals($c239, Value.Words[4]);
  {$ENDIF}

  {$IFDEF ENDIAN_LITTLE}
  Value.Words[0] := $4a9d;
  Value.Words[1] := $a2bb;
  Value.Words[2] := $5458;
  Value.Words[3] := $adf8;
  Value.Words[4] := $4000;
  {$ELSE}
  Value.Words[0] := $4000;
  Value.Words[1] := $adf8;
  Value.Words[2] := $5458;
  Value.Words[3] := $a2bb;
  Value.Words[4] := $4a9d;
  {$ENDIF}

  SwapToBig(ValueArray);
  CheckEquals($40, ValueArray[0]);  { e }
  CheckEquals($00, ValueArray[1]);
  CheckEquals($ad, ValueArray[2]);
  CheckEquals($f8, ValueArray[3]);
  CheckEquals($54, ValueArray[4]);
  CheckEquals($58, ValueArray[5]);
  CheckEquals($a2, ValueArray[6]);
  CheckEquals($bb, ValueArray[7]);
  CheckEquals($4a, ValueArray[8]);
  CheckEquals($9d, ValueArray[9]);
  {$ELSE}
  ValueArray := MakeExtended($c0, $09, $21, $fb, $54, $44, $2d, $18); { -pi. why "-"? because of sign bit. }

  {$IFDEF ENDIAN_LITTLE}
  CheckEquals($2d18, Value.Words[0]);
  CheckEquals($5444, Value.Words[1]);
  CheckEquals($21fb, Value.Words[2]);
  CheckEquals($c009, Value.Words[3]);
  {$ELSE}
  CheckEquals($c009, Value.Words[0]);
  CheckEquals($21fb, Value.Words[1]);
  CheckEquals($5444, Value.Words[2]);
  CheckEquals($2d18, Value.Words[3]);
  {$ENDIF}

  {$IFDEF ENDIAN_LITTLE}
  Value.Words[0] := $5769;
  Value.Words[1] := $8b14;
  Value.Words[2] := $bf0a;
  Value.Words[3] := $4005;
  {$ELSE}
  Value.Words[0] := $4005;
  Value.Words[1] := $bf0a;
  Value.Words[2] := $8b14;
  Value.Words[3] := $5769;
  {$ENDIF}

  SwapToBig(ValueArray);
  CheckEquals($40, ValueArray[0]);  { e }
  CheckEquals($05, ValueArray[1]);
  CheckEquals($bf, ValueArray[2]);
  CheckEquals($0a, ValueArray[3]);
  CheckEquals($8b, ValueArray[4]);
  CheckEquals($14, ValueArray[5]);
  CheckEquals($57, ValueArray[6]);
  CheckEquals($69, ValueArray[7]);
  {$ENDIF CPUEXTENDED}

  CheckException(WordsRangeOverflow, ERangeError);
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

{$IFDEF RUN_TESTS}
procedure TestTExtendedHelper.BadParse1;
begin
  Extended.Parse(FBadString);
end;
{$ENDIF RUN_TESTS}

procedure TestTExtendedHelper.TestParse1;
{$IFDEF RUN_TESTS}
begin
  CheckEquals('0', UpperCase(Extended.Parse('0').ToString(TFormatSettings.Invariant)));
  CheckEquals('10', UpperCase(Extended.Parse('10').ToString(TFormatSettings.Invariant)));

  {$IFDEF CPUEXTENDED}
  CheckEquals('2.400000E+310', UpperCase(Extended.Parse('2' + FormatSettings.DecimalSeparator + '4e310').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('2.400000E+310', UpperCase(Extended.Parse('2' + FormatSettings.DecimalSeparator + '4E310').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckEquals('-2.400000E-310', UpperCase(Extended.Parse('-2' + FormatSettings.DecimalSeparator + '4e-310').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('-2.400000E-310', UpperCase(Extended.Parse('-2' + FormatSettings.DecimalSeparator + '4E-310').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  {$ELSE}
  CheckEquals('2.400000E+68', UpperCase(Extended.Parse('2' + FormatSettings.DecimalSeparator + '4e68').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('2.400000E+68', UpperCase(Extended.Parse('2' + FormatSettings.DecimalSeparator + '4E68').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckEquals('-2.400000E-68', UpperCase(Extended.Parse('-2' + FormatSettings.DecimalSeparator + '4e-68').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('-2.400000E-68', UpperCase(Extended.Parse('-2' + FormatSettings.DecimalSeparator + '4E-68').ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  {$ENDIF CPUEXTENDED}

  CheckEquals('-1.75', UpperCase(Extended.Parse('-1' + FormatSettings.DecimalSeparator + '75').ToString(TFormatSettings.Invariant)));
  CheckEquals('1.75', UpperCase(Extended.Parse('1' + FormatSettings.DecimalSeparator + '75').ToString(TFormatSettings.Invariant)));

  CheckEquals('0', UpperCase(Extended.Parse(FormatSettings.DecimalSeparator).ToString(TFormatSettings.Invariant)));
  CheckEquals('0', UpperCase(Extended.Parse('-' + FormatSettings.DecimalSeparator).ToString(TFormatSettings.Invariant)));
  CheckEquals('0', UpperCase(Extended.Parse('+' + FormatSettings.DecimalSeparator).ToString(TFormatSettings.Invariant)));

  FBadString := '';
  CheckException(BadParse1, EConvertError);

  FBadString := '-';
  CheckException(BadParse1, EConvertError);

  FBadString := '+';
  CheckException(BadParse1, EConvertError);

  FBadString := '1 0000 000.0';
  CheckException(BadParse1, EConvertError);

  FBadString := '#';
  CheckException(BadParse1, EConvertError);

  FBadString := 'f';
  CheckException(BadParse1, EConvertError);

  FBadString := '10#';
  CheckException(BadParse1, EConvertError);

  FBadString := '10f';
  CheckException(BadParse1, EConvertError);

  FBadString := '1,2.3';
  CheckException(BadParse1, EConvertError);

  FBadString := '1.2,3';
  CheckException(BadParse1, EConvertError);

  FBadString := '1' + FormatSettings.DecimalSeparator + '2' + FormatSettings.DecimalSeparator + '3';
  CheckException(BadParse1, EConvertError);

  FBadString := 'INF';
  CheckException(BadParse1, EConvertError);

  FBadString := '+INF';
  CheckException(BadParse1, EConvertError);

  FBadString := '-INF';
  CheckException(BadParse1, EConvertError);

  FBadString := 'NAN';
  CheckException(BadParse1, EConvertError);
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

{$IFDEF RUN_TESTS}
procedure TestTExtendedHelper.BadParse2;
begin
  Extended.Parse(FBadString, FBadFormat);
end;
{$ENDIF RUN_TESTS}

procedure TestTExtendedHelper.TestParse2;
{$IFDEF RUN_TESTS}
var
  LocalFormat: TFormatSettings;
begin
  LocalFormat := TFormatSettings.Create;
  LocalFormat.ThousandSeparator := ' ';
  LocalFormat.DecimalSeparator := ';';

  CheckEquals('0', UpperCase(Extended.Parse('0', LocalFormat).ToString(TFormatSettings.Invariant)));
  CheckEquals('10', UpperCase(Extended.Parse('10', LocalFormat).ToString(TFormatSettings.Invariant)));

  {$IFDEF CPUEXTENDED}
  CheckEquals('2.400000E+310', UpperCase(Extended.Parse('2;4e310', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('2.400000E+310', UpperCase(Extended.Parse('2;4E310', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckEquals('-2.400000E-310', UpperCase(Extended.Parse('-2;4e-310', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('-2.400000E-310', UpperCase(Extended.Parse('-2;4E-310', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  {$ELSE}
  CheckEquals('2.400000E+68', UpperCase(Extended.Parse('2;4e68', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('2.400000E+68', UpperCase(Extended.Parse('2;4E68', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckEquals('-2.400000E-68', UpperCase(Extended.Parse('-2;4e-68', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckEquals('-2.400000E-68', UpperCase(Extended.Parse('-2;4E-68', LocalFormat).ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  {$ENDIF CPUEXTENDED}

  CheckEquals('-1.75', UpperCase(Extended.Parse('-1;75', LocalFormat).ToString(TFormatSettings.Invariant)));
  CheckEquals('1.75', UpperCase(Extended.Parse('+1;75', LocalFormat).ToString(TFormatSettings.Invariant)));

  CheckEquals('0', UpperCase(Extended.Parse(';', LocalFormat).ToString(TFormatSettings.Invariant)));
  CheckEquals('0', UpperCase(Extended.Parse('-;', LocalFormat).ToString(TFormatSettings.Invariant)));
  CheckEquals('0', UpperCase(Extended.Parse('+;', LocalFormat).ToString(TFormatSettings.Invariant)));

  FBadString := '';
  FBadFormat := LocalFormat;
  CheckException(BadParse2, EConvertError);

  FBadString := '-';
  CheckException(BadParse2, EConvertError);

  FBadString := '+';
  CheckException(BadParse2, EConvertError);

  FBadString := '1 0000 000;0';
  CheckException(BadParse2, EConvertError);

  FBadString := '#';
  CheckException(BadParse2, EConvertError);

  FBadString := 'f';
  CheckException(BadParse2, EConvertError);

  FBadString := '10#';
  CheckException(BadParse2, EConvertError);

  FBadString := '10f';
  CheckException(BadParse2, EConvertError);

  FBadString := '1;2.3';
  CheckException(BadParse2, EConvertError);

  FBadString := '1;2.3';
  CheckException(BadParse2, EConvertError);

  FBadString := '1;2;3';
  CheckException(BadParse2, EConvertError);

  FBadString := 'INF';
  CheckException(BadParse2, EConvertError);

  FBadString := '+INF';
  CheckException(BadParse2, EConvertError);

  FBadString := '-INF';
  CheckException(BadParse2, EConvertError);

  FBadString := 'NAN';
  CheckException(BadParse2, EConvertError);
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestTryParse1;
{$IFDEF RUN_TESTS}
var
  Value: Extended;
begin
  CheckTrue(Extended.TryParse('0', Value));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('10', Value));
  CheckEquals('10', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  {$IFDEF CPUEXTENDED}
  CheckTrue(Extended.TryParse('2' + FormatSettings.DecimalSeparator + '4e310', Value));
  CheckEquals('2.400000E+310', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Extended.TryParse('2' + FormatSettings.DecimalSeparator + '4E310', Value));
  CheckEquals('2.400000E+310', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('-2' + FormatSettings.DecimalSeparator + '4e-310', Value));
  CheckEquals('-2.400000E-310', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Extended.TryParse('-2' + FormatSettings.DecimalSeparator + '4E-310', Value));
  CheckEquals('-2.400000E-310', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  {$ELSE}
  CheckTrue(Extended.TryParse('2' + FormatSettings.DecimalSeparator + '4e68', Value));
  CheckEquals('2.400000E+68', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Extended.TryParse('2' + FormatSettings.DecimalSeparator + '4E68', Value));
  CheckEquals('2.400000E+68', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('-2' + FormatSettings.DecimalSeparator + '4e-68', Value));
  CheckEquals('-2.400000E-68', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Extended.TryParse('-2' + FormatSettings.DecimalSeparator + '4E-68', Value));
  CheckEquals('-2.400000E-68', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  {$ENDIF CPUEXTENDED}

  CheckTrue(Extended.TryParse('-1' + FormatSettings.DecimalSeparator + '75', Value));
  CheckEquals('-1.75', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('+1' + FormatSettings.DecimalSeparator + '75', Value));
  CheckEquals('1.75', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse(FormatSettings.DecimalSeparator, Value));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('-' + FormatSettings.DecimalSeparator, Value));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('+' + FormatSettings.DecimalSeparator, Value));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckFalse(Extended.TryParse('', Value));
  CheckFalse(Extended.TryParse('-', Value));
  CheckFalse(Extended.TryParse('+', Value));
  CheckFalse(Extended.TryParse('1 0000 000.0', Value));
  CheckFalse(Extended.TryParse('#', Value));
  CheckFalse(Extended.TryParse('f', Value));
  CheckFalse(Extended.TryParse('10#', Value));
  CheckFalse(Extended.TryParse('10f', Value));
  CheckFalse(Extended.TryParse('1;2.3', Value));
  CheckFalse(Extended.TryParse('1;2,3', Value));
  CheckFalse(Extended.TryParse('1;2;3', Value));
  CheckFalse(Extended.TryParse('INF', Value));
  CheckFalse(Extended.TryParse('+INF', Value));
  CheckFalse(Extended.TryParse('-INF', Value));
  CheckFalse(Extended.TryParse('NAN', Value));
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestTryParse2;
{$IFDEF RUN_TESTS}
var
  LocalFormat: TFormatSettings;
  Value: Extended;
begin
  LocalFormat := TFormatSettings.Create;
  LocalFormat.ThousandSeparator := ' ';
  LocalFormat.DecimalSeparator := ';';

  CheckTrue(Extended.TryParse('0', Value, LocalFormat));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('10', Value, LocalFormat));
  CheckEquals('10', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  {$IFDEF CPUEXTENDED}
  CheckTrue(Extended.TryParse('2;4e310', Value, LocalFormat));
  CheckEquals('2.400000E+310', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Extended.TryParse('2;4E310', Value, LocalFormat));
  CheckEquals('2.400000E+310', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('-2;4e-310', Value, LocalFormat));
  CheckEquals('-2.400000E-310', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Extended.TryParse('-2;4E-310', Value, LocalFormat));
  CheckEquals('-2.400000E-310', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  {$ELSE}
  CheckTrue(Extended.TryParse('2;4e68', Value, LocalFormat));
  CheckEquals('2.400000E+68', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Extended.TryParse('2;4E68', Value, LocalFormat));
  CheckEquals('2.400000E+68', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('-2;4e-68', Value, LocalFormat));
  CheckEquals('-2.400000E-68', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  CheckTrue(Extended.TryParse('-2;4E-68', Value, LocalFormat));
  CheckEquals('-2.400000E-68', UpperCase(Value.ToString(ffExponent, 7, 2, TFormatSettings.Invariant)));
  {$ENDIF CPUEXTENDED}

  CheckTrue(Extended.TryParse('-1;75', Value, LocalFormat));
  CheckEquals('-1.75', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('+1;75', Value, LocalFormat));
  CheckEquals('1.75', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse(';', Value, LocalFormat));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('-;', Value, LocalFormat));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckTrue(Extended.TryParse('+;', Value, LocalFormat));
  CheckEquals('0', UpperCase(Value.ToString(TFormatSettings.Invariant)));

  CheckFalse(Extended.TryParse('', Value, LocalFormat));
  CheckFalse(Extended.TryParse('-', Value, LocalFormat));
  CheckFalse(Extended.TryParse('+', Value, LocalFormat));
  CheckFalse(Extended.TryParse('1 0000 000;0', Value, LocalFormat));
  CheckFalse(Extended.TryParse('#', Value, LocalFormat));
  CheckFalse(Extended.TryParse('f', Value, LocalFormat));
  CheckFalse(Extended.TryParse('10#', Value, LocalFormat));
  CheckFalse(Extended.TryParse('10f', Value, LocalFormat));
  CheckFalse(Extended.TryParse('1,2.3', Value, LocalFormat));
  CheckFalse(Extended.TryParse('1.2,3', Value, LocalFormat));
  CheckFalse(Extended.TryParse('1' + FormatSettings.DecimalSeparator + '2' + FormatSettings.DecimalSeparator + '3', Value, LocalFormat));
  CheckFalse(Extended.TryParse('INF', Value, LocalFormat));
  CheckFalse(Extended.TryParse('+INF', Value, LocalFormat));
  CheckFalse(Extended.TryParse('-INF', Value, LocalFormat));
  CheckFalse(Extended.TryParse('NAN', Value, LocalFormat));
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

procedure TestTExtendedHelper.TestSize;
{$IFDEF RUN_TESTS}
begin
  CheckEquals(SizeOf(Extended), Extended.Size);
{$ELSE}
begin
  Ignore('Extended type is not supported.');
{$ENDIF RUN_TESTS}
end;

initialization
  RegisterTest('System.SysUtils', TestTExtendedHelper.Suite);

end.
