{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$IFDEF FPC}
  {$IFDEF WITH_UNICODE}{$MODE DELPHIUNICODE}{$ELSE}{$MODE DELPHI}{$ENDIF}{$H+}
  {$CODEPAGE UTF8}

  {$IF (FPC_VERSION>3) OR ((FPC_VERSION=3) AND (FPC_RELEASE>=1))}
  {$ELSE}
  {$FATAL 'Too old compiller version. Free Pascal 3.1+ is required.'}
  {$IFEND}

  {$MODESWITCH ADVANCEDRECORDS}
  {$MODESWITCH TYPEHELPERS}
{$ENDIF FPC}
