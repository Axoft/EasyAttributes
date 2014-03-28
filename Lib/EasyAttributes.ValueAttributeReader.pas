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

unit EasyAttributes.ValueAttributeReader;

interface

uses
  EasyAttributes.ValueAttribute, System.Rtti;

type

  TBaseAttributeReader = record
  private
  type
    TValueAttributeAccess = class(TRawValueAttribute);
  public
    class function Value(Attribute: TCustomAttribute): TValue; overload; static;
    class function Value<T>(Attribute: TCustomAttribute): T; overload; static;

    class function TryValue(Attribute: TCustomAttribute; out AValue: TValue): boolean; overload; static;
    class function TryValue<T>(Attribute: TCustomAttribute; out AValue: T): boolean; overload; static;
  end;

implementation

uses
  System.SysUtils, System.SysConst;

{ TBaseAttributeReader }

class function TBaseAttributeReader.TryValue(Attribute: TCustomAttribute;
  out AValue: TValue): boolean;
begin
  Result := Attribute is TRawValueAttribute;
  if Result then
    AValue := Value(Attribute);
end;

class function TBaseAttributeReader.TryValue<T>(Attribute: TCustomAttribute;
  out AValue: T): boolean;
begin
  Result := Attribute is TRawValueAttribute;
  if Result then
    AValue := Value<T>(Attribute);
end;

class function TBaseAttributeReader.Value(Attribute: TCustomAttribute): TValue;
begin
  if Attribute is TRawValueAttribute then
    Result := TValueAttributeAccess(Attribute).Value
  else
    raise EInvalidCast.CreateRes(@SInvalidCast);
end;

class function TBaseAttributeReader.Value<T>(Attribute: TCustomAttribute): T;
begin
  if Attribute is TRawValueAttribute then
    Result := TValueAttributeAccess(Attribute).Value.AsType<T>
  else
    raise EInvalidCast.CreateRes(@SInvalidCast);
end;

end.
