unit TestuOrderEntry;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, uOrder, uOrderEntry;

type
  // Test methods for class TOrderEntry

  TestTOrderEntry = class(TTestCase)
  strict private
    FOrderEntry: IOrderEntry;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestEnterOrderIntoDatabase;
  end;

implementation

procedure TestTOrderEntry.SetUp;
begin
  FOrderEntry := TOrderEntry.Create;
end;

procedure TestTOrderEntry.TearDown;
begin

end;

procedure TestTOrderEntry.TestEnterOrderIntoDatabase;
var
  aOrder: TOrder;
begin
  // TODO: Setup method call parameters
  aOrder := TOrder.Create;
  try
    Check(FOrderEntry.EnterOrderIntoDatabase(aOrder));
  finally
    aOrder.Free;
  end;
  // TODO: Validate method results
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTOrderEntry.Suite);
end.

