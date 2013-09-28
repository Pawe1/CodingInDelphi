program StackDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  uStackDemo in 'uStackDemo.pas';

begin
  try
    if IsPalindrome('racecar') then
    begin
      WriteLn('"racecar" is indeed a palindrome');
    end else
    begin
      WriteLn('"racecar" is a palindrome, but the algorithm says it isn''t');
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  ReadLn;
end.
