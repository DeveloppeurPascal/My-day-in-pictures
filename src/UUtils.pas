unit UUtils;

interface

function EnChiffres(s: string): string;

implementation

uses System.SysUtils;

function EnChiffres(s: string): string;
var
  i: integer;
  c: char;
begin
  result := '';
  for i := 0 to length(s) - 1 do
  begin
    c := s.Chars[i];
    if (c >= '0') and (c <= '9') then
      result := result + c;
  end;
end;

end.
