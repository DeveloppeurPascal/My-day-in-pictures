(* C2PP
  ***************************************************************************

  My day in pictures

  Copyright 2023-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://mydayinpictures.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/My-day-in-pictures

  ***************************************************************************
  File last update : 2025-10-16T10:44:40.105+02:00
  Signature : 9177ba0bf349f4e9b0e5ca02c653cc04164f38b9
  ***************************************************************************
*)

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
