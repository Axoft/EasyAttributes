//   Copyright 2014 Agustin Seifert
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

unit EasyAttributes.ValueAttribute;

interface

uses
  Rtti;

type
  TRawValueAttribute = class(TCustomAttribute)
  private
    FValue: TValue;
    function GetRawValue: TValue;
    procedure SetRawValue(const AValue: TValue);
  protected
    property Value: TValue read GetRawValue write SetRawValue;
  end;

  TValueAttribute<T> = class(TRawValueAttribute)
  private
    function GetValue: T;
    procedure SetValue(const AValue: T);
  public
    constructor Create(AValue: T); reintroduce;
    property Value: T read GetValue write SetValue;
  end;

  TBooleanAttribute = class(TValueAttribute<boolean>);
  TStringAttribute = class(TValueAttribute<string>);
  TInt64Attribute = class(TValueAttribute<Int64>);
  TIntegerAttribute = class(TValueAttribute<integer>);
  TClassAttribute = class(TValueAttribute<TClass>);

  TValueAttributeHelper = class helper for TCustomAttribute
    function Value: TValue; overload;
    function Value<T>: T; overload;

    function TryValue(out Value: TValue): boolean; overload;
    function TryValue<T>(out Value: T): boolean; overload;
  end;


implementation

uses
  EasyAttributes.ValueAttributeReader;
  
{ TValueAttribute }

constructor TValueAttribute<T>.Create(AValue: T);
begin
  Value := AValue;
end;

function TValueAttribute<T>.GetValue: T;
begin
  Result := GetRawValue.AsType<T>;
end;

procedure TValueAttribute<T>.SetValue(const AValue: T);
begin
  SetRawValue(TValue.From<T>(AValue));
end;

{ TRawValueAttribute }

function TRawValueAttribute.GetRawValue: TValue;
begin
  Result := FValue;
end;

procedure TRawValueAttribute.SetRawValue(const AValue: TValue);
begin
  FValue := AValue;
end;

{ TValueAttributeHelper }

function TValueAttributeHelper.TryValue(out Value: TValue): boolean;
begin
  Result := TBaseAttributeReader.TryValue(Self, Value);
end;

function TValueAttributeHelper.TryValue<T>(out Value: T): boolean;
begin
  Result := TBaseAttributeReader.TryValue<T>(Self, Value);
end;

function TValueAttributeHelper.Value: TValue;
begin
  Result := TBaseAttributeReader.Value(Self);
end;

function TValueAttributeHelper.Value<T>: T;
begin
  Result := TBaseAttributeReader.Value<T>(Self);
end;

end.
