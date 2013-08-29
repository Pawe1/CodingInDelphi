program RttiContext_GetTypes_vs_GetType_on_Interfaces_ConsoleProject;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  RttiContext_GetTypes_vs_GetType_on_Interfaces_ConsoleUnit in 'RttiContext_GetTypes_vs_GetType_on_Interfaces_ConsoleUnit.pas',
  System.SysUtils,
  RttiHelpers in '..\RttiHelpers.pas';

begin
  try
    Main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
