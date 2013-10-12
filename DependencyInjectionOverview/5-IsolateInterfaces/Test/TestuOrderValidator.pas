unit TestuOrderValidator;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit 
  being tested.

}

interface

uses
  TestFramework, uOrder, uOrderValidator, uOrderInterfaces;

type
  // Test methods for class TOrderValidator

  TestTOrderValidator = class(TTestCase)
  strict private
    FOrderValidator: IOrderValidator;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestValidateOrder;
  end;

implementation

procedure TestTOrderValidator.SetUp;
begin
  FOrderValidator := TOrderValidator.Create;
end;

procedure TestTOrderValidator.TearDown;
begin

end;

procedure TestTOrderValidator.TestValidateOrder;
var
  ReturnValue: Boolean;
  aOrder: TOrder;
begin
  // TODO: Setup method call parameters  \
  aOrder := TOrder.Create;
  try
    ReturnValue := FOrderValidator.ValidateOrder(aOrder);
    Check(ReturnValue);
  finally
    aOrder.Free;
  end;
  // TODO: Validate method results
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTOrderValidator.Suite);
end.

