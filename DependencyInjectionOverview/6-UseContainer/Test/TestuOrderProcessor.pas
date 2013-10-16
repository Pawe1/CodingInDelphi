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
    procedure TestInterfaceImplementedByClass(const FInterface: IInterface; const ClassType: TClass; const
        InstanceDescription: string); virtual;
    procedure TestOrderEntryIsClass(const FOrderEntry: IOrderEntry; const ClassType: TClass); virtual;
    procedure TestOrderValidatorIsClass(const FOrderValidator: IOrderValidator; const ClassType: TClass); virtual;
  public
    procedure SetUp(); override;
  published
    procedure TestOrderEntryIsRegular_ServiceLocator();
    procedure TestOrderEntryIsMock_ServiceLocator_TOrderEntryMockServiceName();
    procedure TestOrderValidatorIsRegular_ServiceLocator();
    procedure TestOrderValidatorIsMock_ServiceLocator_TOrderValidatorMockServiceName();
    procedure TestProcessOrder();
  end;

implementation

uses
  SysUtils,
  uOrder,
  uOrderEntry,
  uOrderEntryMock,
  uOrderValidator,
  uOrderValidatorMock,
  uOrderProcessor,
  Spring,
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

procedure TestTOrderProcessor.TestInterfaceImplementedByClass(const FInterface: IInterface; const ClassType: TClass;
    const InstanceDescription: string);
var
  Instance: TObject;
begin
  Instance := FInterface as TObject; // as of Delphi 2010, you can do this; see http://stackoverflow.com/questions/4138211/how-to-cast-a-interface-to-a-object-in-delphi/11167316#11167316
  Check(Instance.InheritsFrom(ClassType),
    Format('%s class "%s" does not inherit from "%s"', [InstanceDescription, GetQualifiedClassName(Instance), GetQualifiedClassName(ClassType)]));
end;

procedure TestTOrderProcessor.TestOrderEntryIsClass(const FOrderEntry: IOrderEntry; const ClassType: TClass);
begin
  TestInterfaceImplementedByClass(FOrderEntry, ClassType, 'OrderEntry');
end;

procedure TestTOrderProcessor.TestOrderEntryIsRegular_ServiceLocator();
var
  FOrderEntry: IOrderEntry;
begin
// Note that going through the ServiceLocator without the names will give you the regular implementations,
// which you want for the normal business code still to work:
  FOrderEntry := ServiceLocator.GetService<IOrderEntry>();
  TestOrderEntryIsClass(FOrderEntry, TOrderEntry);
end;

procedure TestTOrderProcessor.TestOrderEntryIsMock_ServiceLocator_TOrderEntryMockServiceName();
var
  FOrderEntry: IOrderEntry;
begin
// Retrieving the instances with the unique service names gives back the Mock classes:
  FOrderEntry := ServiceLocator.GetService<IOrderEntry>(RegisterMocks.TOrderEntryMockServiceName);
  TestOrderEntryIsClass(FOrderEntry, TOrderEntryMock);
end;

procedure TestTOrderProcessor.TestOrderValidatorIsClass(const FOrderValidator: IOrderValidator; const ClassType: TClass);
begin
  TestInterfaceImplementedByClass(FOrderValidator, ClassType, 'OrderValidator');
end;

procedure TestTOrderProcessor.TestOrderValidatorIsRegular_ServiceLocator();
var
  FOrderValidator: IOrderValidator;
begin
// Note that going through the ServiceLocator without the names will give you the regular implementations,
// which you want for the normal business code still to work:
  FOrderValidator := ServiceLocator.GetService<IOrderValidator>();
  TestOrderValidatorIsClass(FOrderValidator, TOrderValidator);
end;

procedure TestTOrderProcessor.TestOrderValidatorIsMock_ServiceLocator_TOrderValidatorMockServiceName();
var
  FOrderValidator: IOrderValidator;
begin
// Retrieving the instances with the unique service names gives back the Mock classes:
  FOrderValidator := ServiceLocator.GetService<IOrderValidator>(RegisterMocks.TOrderValidatorMockServiceName);
  TestOrderValidatorIsClass(FOrderValidator, TOrderValidatorMock);
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
