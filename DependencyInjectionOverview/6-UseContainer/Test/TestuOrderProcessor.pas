unit TestuOrderProcessor;

interface

uses
  TestFramework,
  uOrderInterfaces;

type
  TestTOrderProcessor = class(TTestCase)
  strict private
    FOrderProcessor: IOrderProcessor;
  strict protected
    procedure TestOrderEntryIsMock(const FOrderEntry: IOrderEntry); virtual;
    procedure TestOrderValidatorIsMock(const FOrderValidator: IOrderValidator); virtual;
  public
    procedure SetUp(); override;
  published
    procedure TestOrderEntryIsMock_ServiceLocator();
    procedure TestOrderEntryIsMock_ServiceLocator_TOrderEntryMockServiceName();
    procedure TestOrderValidatorIsMock_ServiceLocator();
    procedure TestOrderValidatorIsMock_ServiceLocator_TOrderValidatorMockServiceName();
    procedure TestProcessOrder();
  end;

implementation

uses
  System.SysUtils,
  uOrder,
  uOrderEntryMock,
  uOrderValidatorMock,
  uOrderProcessor,
  Spring.Container,
  Spring.Services,
  uRegisterMocks;

procedure TestTOrderProcessor.SetUp();
var
  FOrderValidator: IOrderValidator;
  FOrderEntry: IOrderEntry;
begin
  GlobalContainer.Build();

// Two ways of getting the Mock objects

// 1. Constructing them by hand.
  FOrderValidator :=  TOrderValidatorMock.Create();
  FOrderEntry := TOrderEntryMock.Create();

  // 2. Going throug the ServiceLocator with their unique names.
// Note that going through the ServiceLocator without the names will give you the regular implementations,
// which you want for the normal business code still to work:
//  FOrderValidator := ServiceLocator.GetService<IOrderValidator>();
//  FOrderEntry := ServiceLocator.GetService<IOrderEntry>();
// But retrieving them with their unique names gives back the Mock classes:
//  FOrderValidator := ServiceLocator.GetService<IOrderValidator>(TOrderValidatorMockServiceName);
//  FOrderEntry := ServiceLocator.GetService<IOrderEntry>(TOrderEntryMockServiceName);

  FOrderProcessor := TOrderProcessor.Create(FOrderValidator, FOrderEntry);
end;

procedure TestTOrderProcessor.TestOrderEntryIsMock(const FOrderEntry: IOrderEntry);
var
  OrderEntry: TObject;
begin
  OrderEntry := FOrderEntry as TObject; // as of Delphi 2010, you can do this; see http://stackoverflow.com/questions/4138211/how-to-cast-a-interface-to-a-object-in-delphi/11167316#11167316
  Check(OrderEntry.InheritsFrom(TOrderEntryMock),
    Format('OrderEntry class "%s" does not inherit from "%s"', [OrderEntry.QualifiedClassName, TOrderEntryMock.QualifiedClassName]));
end;

procedure TestTOrderProcessor.TestOrderEntryIsMock_ServiceLocator();
var
  FOrderEntry: IOrderEntry;
begin
// Note that going through the ServiceLocator without the names will give you the regular implementations,
// which you want for the normal business code still to work:
  FOrderEntry := ServiceLocator.GetService<IOrderEntry>();
  TestOrderEntryIsMock(FOrderEntry);
end;

procedure TestTOrderProcessor.TestOrderEntryIsMock_ServiceLocator_TOrderEntryMockServiceName();
var
  FOrderEntry: IOrderEntry;
begin
// But retrieving them with their unique names gives back the Mock classes:
  FOrderEntry := ServiceLocator.GetService<IOrderEntry>(RegisterMocks.TOrderEntryMockServiceName);
  TestOrderEntryIsMock(FOrderEntry);
end;

procedure TestTOrderProcessor.TestOrderValidatorIsMock(const FOrderValidator: IOrderValidator);
var
  OrderValidator: TObject;
begin
  OrderValidator := FOrderValidator as TObject; // as of Delphi 2010, you can do this; see http://stackoverflow.com/questions/4138211/how-to-cast-a-interface-to-a-object-in-delphi/11167316#11167316
  Check(OrderValidator.InheritsFrom(TOrderValidatorMock),
    Format('OrderEntry class "%s" does not inherit from "%s"', [OrderValidator.QualifiedClassName, TOrderValidatorMock.QualifiedClassName]));
end;

procedure TestTOrderProcessor.TestOrderValidatorIsMock_ServiceLocator();
var
  FOrderValidator: IOrderValidator;
begin
// Note that going through the ServiceLocator without the names will give you the regular implementations,
// which you want for the normal business code still to work:
  FOrderValidator := ServiceLocator.GetService<IOrderValidator>();
  TestOrderValidatorIsMock(FOrderValidator);
end;

procedure TestTOrderProcessor.TestOrderValidatorIsMock_ServiceLocator_TOrderValidatorMockServiceName();
var
  FOrderValidator: IOrderValidator;
begin
// But retrieving them with their unique names gives back the Mock classes:
  FOrderValidator := ServiceLocator.GetService<IOrderValidator>(RegisterMocks.TOrderValidatorMockServiceName);
  TestOrderValidatorIsMock(FOrderValidator);
end;

procedure TestTOrderProcessor.TestProcessOrder();
var
  Order: TOrder;
  ResultValue: Boolean;
begin
  Order := TOrder.Create();
  try
    ResultValue := FOrderProcessor.ProcessOrder(Order);
    Check(ResultValue);
  finally
    Order.Free;
  end;
end;

initialization
  RegisterTest(TestTOrderProcessor.Suite);
end.
