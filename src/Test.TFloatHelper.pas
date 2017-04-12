{**********************************************************************
    Copyright(c) 2017 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.TFloatHelper;

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


{$IF (DEFINED(FPC) AND (DECLARED(Single) OR DECLARED(Double) OR DECLARED(Extended))) OR DEFINED(DELPHI_XE2_PLUS)}
  {$DEFINE RUN_TESTS}
{$IFEND}

type
  TFloatHelper = class(TTestCase)
  {$IFDEF RUN_TESTS}
  protected type
    {$IF DECLARED(Single)}
    TSingleArray = packed array [0..SizeOf(Single) - 1] of Byte;
    {$IFEND}
    {$IF DECLARED(Double)}
    TDoubleArray = packed array [0..SizeOf(Double) - 1] of Byte;
    {$IFEND}
    {$IF DECLARED(Extended)}
    TExtendedArray = packed array [0..SizeOf(Extended) - 1] of Byte;
    {$IFEND}
  protected
    {$IF DECLARED(Single)}
    class procedure SwapToBig(var SingleArray: TSingleArray); overload; static;
    class function MakeSingle(a, b, c, d: Byte): TSingleArray; static;
    {$IFEND}
    {$IF DECLARED(Double)}
    class procedure SwapToBig(var DoubleArray: TDoubleArray); overload; static;
    class function MakeDouble(a, b, c, d, e, f, g, h: Byte): TDoubleArray; static;
    {$IFEND}
    {$IF DECLARED(Extended)}
    class procedure SwapToBig(var ExtendedArray: TExtendedArray); overload; static;
      {$IF SIZEOF(Extended) = 10}
    class function MakeExtended(a, b, c, d, e, f, g, h, i, j: Byte): TExtendedArray; static;
      {$ELSE}
    class function MakeExtended(a, b, c, d, e, f, g, h: Byte): TExtendedArray; static;
      {$IFEND}
    {$IFEND}
  {$ENDIF RUN_TESTS}
  protected
  {$IFDEF FPC}
    class procedure CheckEquals(Expected, Actual: Int64; msg: string = ''); overload;
    class procedure CheckEquals(Expected, Actual: UInt64; msg: string = ''); overload;
  {$ELSE}
    procedure Ignore(msg: string);
  {$ENDIF}
  end;

implementation

{ TFloatHelper }

{$IFDEF RUN_TESTS}
{$IF DECLARED(Single)}
class procedure TFloatHelper.SwapToBig(var SingleArray: TSingleArray);
var
  Value: Cardinal absolute SingleArray;
begin
  {$IFDEF ENDIAN_LITTLE}
  Value := ((Value shl 8) and $ff00ff00) or ((Value shr 8) and $00ff00ff);
  Value := (Value shl 16) or (Value shr 16);
  {$ENDIF}
end;

class function TFloatHelper.MakeSingle(a, b, c, d: Byte): TSingleArray;
begin
  Result[0] := d; Result[1] := c; Result[2] := b; Result[3] := a;
  {$IFDEF ENDIAN_BIG}
  SwapToBig(Result);
  {$ENDIF}
end;
{$IFEND}

{$IF DECLARED(Double)}
class procedure TFloatHelper.SwapToBig(var DoubleArray: TDoubleArray);
var
  Value: UInt64 absolute DoubleArray;
begin
  Value := ((Value shl 8) and $ff00ff00ff00ff00) or
            ((Value shr 8) and $00ff00ff00ff00ff);
  Value := ((Value shl 16) and $ffff0000ffff0000) or
            ((Value shr 16) and $0000ffff0000ffff);
  Value := (Value shl 32) or ((Value shr 32));
end;

class function TFloatHelper.MakeDouble(a, b, c, d, e, f, g, h: Byte): TDoubleArray;
begin
  Result[4] := d; Result[5] := c; Result[6] := b; Result[7] := a;
  Result[0] := h; Result[1] := g; Result[2] := f; Result[3] := e;
  {$IFDEF ENDIAN_BIG}
  SwapToBig(Result);
  {$ENDIF}
end;
{$IFEND}

{$IF DECLARED(Extended)}
class procedure TFloatHelper.SwapToBig(var ExtendedArray: TExtendedArray);
var
  Value: UInt64 absolute ExtendedArray;
{$IF SIZEOF(Extended) = 10}
  x, y: Byte;
begin
  x := ExtendedArray[8];
  y := ExtendedArray[9];
{$ELSE}
begin
{$IFEND}
  Value := ((Value shl 8) and $ff00ff00ff00ff00) or
            ((Value shr 8) and $00ff00ff00ff00ff);
  Value := ((Value shl 16) and $ffff0000ffff0000) or
            ((Value shr 16) and $0000ffff0000ffff);
  Value := (Value shl 32) or ((Value shr 32));
  {$IF SIZEOF(Extended) = 10}
  Move(ExtendedArray[0], ExtendedArray[2], 8);
  ExtendedArray[0] := y;
  ExtendedArray[1] := x;
  {$IFEND}
end;

{$IF SIZEOF(Extended) = 10}
class function TFloatHelper.MakeExtended(a, b, c, d, e, f, g, h, i, j: Byte): TExtendedArray;
begin
  Result[5] := e; Result[6] := d; Result[7] := c; Result[8] := b; Result[9] := a;
  Result[0] := j; Result[1] := i; Result[2] := h; Result[3] := g; Result[4] := f;
{$ELSE}
class function TFloatHelper.MakeExtended(a, b, c, d, e, f, g, h: Byte): TExtendedArray;
begin
  Result[4] := d; Result[5] := c; Result[6] := b; Result[7] := a;
  Result[0] := h; Result[1] := g; Result[2] := f; Result[3] := e;
{$IFEND}
  {$IFDEF ENDIAN_BIG}
  SwapToBig(Result);
  {$ENDIF}
end;
{$IFEND}
{$ENDIF RUN_TESTS}

{$IFDEF FPC}
class procedure TFloatHelper.CheckEquals(Expected, Actual: Int64; msg: string = '');
begin
  AssertTrue(ComparisonMsg(msg, IntToStr(Expected), IntToStr(Actual)), Expected = Actual, CallerAddr);
end;

class procedure TFloatHelper.CheckEquals(Expected, Actual: UInt64; msg: string = '');
begin
  AssertTrue(ComparisonMsg(msg, IntToStr(Expected), IntToStr(Actual)), Expected = Actual, CallerAddr);
end;
{$ELSE}
procedure TFloatHelper.Ignore(msg: string);
begin
  Fail(msg);
end;
{$ENDIF FPC}

end.
