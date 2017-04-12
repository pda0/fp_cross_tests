{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program delphi_cross_tests;

{$IFDEF FPC}{$I fpc.inc}{$ELSE}{$I delphi.inc}{$ENDIF}
{$IFDEF DELPHI_XE4_PLUS}{$LEGACYIFEND ON}{$ENDIF}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  System.SysConst,
  Test.SysUtils.TGuidHelper in 'src\Test.SysUtils.TGuidHelper.pas',
  Test.SysUtils.TUnicodeStringBuilder in 'src\Test.SysUtils.TUnicodeStringBuilder.pas',
  Test.TFloatHelper in 'src\Test.TFloatHelper.pas',
  Test.SysUtils.TSingleHelper in 'src\Test.SysUtils.TSingleHelper.pas',
  Test.SysUtils.TDoubleHelper in 'src\Test.SysUtils.TDoubleHelper.pas',
  Test.SysUtils.TExtendedHelper in 'src\Test.SysUtils.TExtendedHelper.pas',
  Test.SysUtils.TByteHelper in 'src\Test.SysUtils.TByteHelper.pas',
  Test.SysUtils.TShortIntHelper in 'src\Test.SysUtils.TShortIntHelper.pas',
  Test.SysUtils.TWordHelper in 'src\Test.SysUtils.TWordHelper.pas',
  Test.SysUtils.TSmallIntHelper in 'src\Test.SysUtils.TSmallIntHelper.pas',
  Test.SysUtils.TCardinalHelper in 'src\Test.SysUtils.TCardinalHelper.pas',
  Test.SysUtils.TIntegerHelper in 'src\Test.SysUtils.TIntegerHelper.pas',
  Test.SysUtils.TUInt64Helper in 'src\Test.SysUtils.TUInt64Helper.pas',
  Test.SysUtils.TInt64Helper in 'src\Test.SysUtils.TInt64Helper.pas';

{$R *.RES}

begin
  (*
  Test.SysUtils.TNativeIntHelper
  Test.SysUtils.TNativeUIntHelper
  Test.SysUtils.TBooleanHelper
  Test.SysUtils.TByteBoolHelper
  Test.SysUtils.TWordBoolHelper
  Test.SysUtils.TLongBoolHelper
  + Generics.Collections
  *)

  DUnitTestRunner.RunRegisteredTests;
end.

