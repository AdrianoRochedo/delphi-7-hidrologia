program Diarizador;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  SpreadSheetBook;

var
  p1, p2: TSpreadSheetBook;
  i, j, k, m: integer;
  d1, d2: TDateTime;
  s1, s2: string;
begin
  p1 := TSpreadSheetBook.Create();
  p2 := TSpreadSheetBook.Create();
  p1.LoadFromFile('sequencia unica.xls');

  k := 3;
  j := p1.ActiveSheet.RowCount;
  for i := 3 to j do
    begin
    s1 := p1.ActiveSheet.GetDisplayText(i, 1);
    if s1 <> '----' then
       begin
       p2.ActiveSheet.Write(k, 1, s1);
       p2.ActiveSheet.Write(k, 2, p1.ActiveSheet.GetDisplayText(i, 2));
       inc(k);
       end
    else
       begin
       d1 := StrToDate(p1.ActiveSheet.GetDisplayText(i-1, 1));
       d2 := StrToDate(p1.ActiveSheet.GetDisplayText(i+1, 1));
       for m := (trunc(d1) + 1) to (trunc(d2) - 1) do
         begin
         p2.ActiveSheet.Write(k, 1, DateToStr(m));
         p2.ActiveSheet.Write(k, 2, 0);
         inc(k);
         end;
       end;
    end;

  p2.SaveToFile('sequencia unica diarizada.xls');
  p1.Free();
  p2.Free();
end.
