unit Scenarios.Script.Classes;

interface
uses psBASE, Rochedo.Component, Scenarios.Components;

  procedure API(Lib: TLib);

implementation

type

  TpsBase = class(TpsClass)
    procedure AddMethods; override;
    class procedure am_Name(Const Func_Name: String; Stack: TexeStack);
  end;

  TpsPC = class(TpsBase)
    procedure AddMethods; override;
    class procedure am_NextPC(Const Func_Name: String; Stack: TexeStack);
  end;

  TpsSCenario = class(TpsBase)
    procedure AddMethods; override;
    class procedure am_getAsFloat  (Const Func_Name: String; Stack: TexeStack);
    class procedure am_getAsString (Const Func_Name: String; Stack: TexeStack);
  end;

  TpsProject = class(TpsBase)
    procedure AddMethods; override;
    class procedure am_getObjectByName (Const Func_Name: String; Stack: TexeStack);
  end;

const
  cCategory = 'This Program';

procedure API(Lib: TLib);
begin
  TpsBase.Create(
      TComponent,
      nil,
      '',
      cCategory,
      [], [], [],
      False,
      Lib.Classes);

  TpsPC.Create(
        TPC,
        TComponent,
        '',
        cCategory,
        [], [], [],
        False,
        Lib.Classes);

  TpsProject.Create(
        TProject,
        TComponent,
        '',
        cCategory,
        [], [], [],
        False,
        Lib.Classes);
end;

{ TpsBase }

class procedure TpsBase.am_Name(const Func_Name: String; Stack: TexeStack);
var o: TComponent;
begin
  o := TComponent(Stack.getSelf);
  Stack.PushString(o.Name)
end;

procedure TpsBase.AddMethods();
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('Name',
        'Return the object''s name',
        '',
        [],
        [],
        [],
        pvtString,
        TObject,
        am_Name);
    end;
end;

{ TpsPC }

class procedure TpsPC.am_NextPC(const Func_Name: String; Stack: TexeStack);
var o: TPC;
begin
  o := TPC( Stack.getSelf() );
  Stack.PushObject(o.NextPC);
end;

procedure TpsPC.AddMethods;
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('NextPC',
        'Return the next PC or null',
        '',
        [],
        [],
        [],
        pvtObject,
        TPC,
        am_NextPC);
    end;
end;

{ TpsSCenario }

class procedure TpsSCenario.am_getAsFloat(const Func_Name: String; Stack: TexeStack);
var o: TSCenario;
begin
  o := TSCenario(Stack.getSelf);
  Stack.PushFloat(o.getPropAsFloat(Stack.AsString(1)))
end;

class procedure TpsSCenario.am_getAsString(const Func_Name: String; Stack: TexeStack);
var o: TSCenario;
begin
  o := TSCenario(Stack.getSelf);
  Stack.PushString(o.getPropAsString(Stack.AsString(1)))
end;

procedure TpsSCenario.AddMethods;
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('getPropAsFloat',
        'Use this method to get a property value of float type.'#13 +
        '  Ex: x := SCenario_1.getPropAsFloat("Result_1.1990.TotalYield")',
        '',
        [pvtString],
        [nil],
        [False],
        pvtReal,
        TObject,
        am_getAsFloat);

    Add('getPropAsString',
        'Use this method to get a property value of string type.'#13 +
        '  Ex: x := SCenario_1.getPropAsString("Result_1.Description")',
        '',
        [pvtString],
        [nil],
        [False],
        pvtString,
        TObject,
        am_getAsString);
    end;
end;

{ TpsProject }

class procedure TpsProject.am_getObjectByName(const Func_Name: String; Stack: TexeStack);
var o: TProject;
begin
  o := TProject( Stack.getSelf() );
  Stack.PushObject(o.getObjectByName(Stack.AsString(1)));
end;

procedure TpsProject.AddMethods();
begin
  with Procs do
    begin
    end;

  with Functions do
    begin
    Add('getObjectByName',
        'Return a object by your name or Null',
        '',
        [pvtString],
        [nil],
        [False],
        pvtObject,
        TObject,
        am_getObjectByName);
    end;
end;

end.
