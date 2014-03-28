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

unit EasyAttributes.AttributeReader;

interface

uses
  Rtti, EasyAttributes.ValueAttribute;

type
  TCustomAttributeClass = class of TCustomAttribute;

  TAttributeReader = record
  strict private
    class function FindAttribute(AttribClass: TCustomAttributeClass;
      AttribList: TArray<TCustomAttribute>): TCustomAttribute; static;
    class function FindProperty(Owner: TClass; PropName: string;
      AContext: TRttiContext): TRttiProperty; static;
    class function GetPropertyValue(Attrib: TCustomAttribute; PropName: string;
      AContext: TRttiContext): TValue; static;
    class function GetValueFromAttribute(AttribClass: TCustomAttributeClass;
      AttribList: TArray<TCustomAttribute>; PropName: string;
      AContext: TRttiContext): TValue; static;

  public
    class function Value<T>(Owner: TClass;
      AttribClass: TCustomAttributeClass; PropName: string): T; overload; static;
    class function Value<T>(Owner: TClass;
      AttribClass: TCustomAttributeClass; PropName: string;
      AContext: TRttiContext): T; overload; static;
    class function Value(Owner: TClass;
      AttribClass: TCustomAttributeClass; PropName: string): TValue; overload; static;
    class function Value(Owner: TClass;
      AttribClass: TCustomAttributeClass; PropName: string;
      AContext: TRttiContext): TValue; overload; static;

    class function ValueFromMethod<T>(Owner: TClass;
      AttribClass: TCustomAttributeClass;
      MethodName, PropName: string): T; overload; static;
    class function ValueFromMethod<T>(Owner: TClass;
      AttribClass: TCustomAttributeClass; MethodName, PropName: string;
      AContext: TRttiContext): T; overload; static;
    class function ValueFromMethod(Owner: TClass;
      AttribClass: TCustomAttributeClass;
      MethodName, PropName: string): TValue; overload; static;
    class function ValueFromMethod(Owner: TClass;
      AttribClass: TCustomAttributeClass; MethodName, PropName: string;
      AContext: TRttiContext): TValue; overload; static;

    class function Value<T>(Attrib: TCustomAttribute; PropName: string): T; overload; static;
    class function Value<T>(Attrib: TCustomAttribute; PropName: string;
      AContext: TRttiContext): T; overload; static;
    class function Value(Attrib: TCustomAttribute; PropName: string): TValue; overload; static;
    class function Value(Attrib: TCustomAttribute; PropName: string;
      AContext: TRttiContext): TValue; overload; static;
  end;

  TCustomAttributeHelper = class helper(TValueAttributeHelper) for TCustomAttribute
    function Value(PropName: string): TValue; overload;
    function Value<T>(PropName: string): T; overload;
  end;

implementation

{ TAttributeReader }

class function TAttributeReader.Value<T>(Owner: TClass;
  AttribClass: TCustomAttributeClass; PropName: string): T;
begin
  Result := Value(Owner, AttribClass, PropName).AsType<T>;
end;

class function TAttributeReader.FindAttribute(AttribClass: TCustomAttributeClass;
  AttribList: TArray<TCustomAttribute>): TCustomAttribute;
var
  LAttrib: TCustomAttribute;
begin
  Result := nil;
  for LAttrib in AttribList do
    if LAttrib is AttribClass then
      Exit(LAttrib);
end;

class function TAttributeReader.FindProperty(Owner: TClass; PropName: string;
  AContext: TRttiContext): TRttiProperty;
var
  LType: TRttiType;
begin
  Result := nil;
  LType := AContext.GetType(Owner);
  if Assigned(LType) then
    Result := LType.GetProperty(PropName);
end;

class function TAttributeReader.GetPropertyValue(Attrib: TCustomAttribute;
  PropName: string; AContext: TRttiContext): TValue;
var
  LProp: TRttiProperty;
begin
  Result := nil;
  LProp := FindProperty(Attrib.ClassType, PropName, AContext);
  if Assigned(LProp) then
    Result := LProp.GetValue(Attrib)
end;

class function TAttributeReader.GetValueFromAttribute(
  AttribClass: TCustomAttributeClass; AttribList: TArray<TCustomAttribute>;
  PropName: string; AContext: TRttiContext): TValue;
var
  LAttrib: TCustomAttribute;
begin
  Result := Default(TValue);
  LAttrib := FindAttribute(AttribClass, AttribList);
  if Assigned(LAttrib) then
    Result := GetPropertyValue(LAttrib, PropName, AContext);
end;

class function TAttributeReader.Value<T>(Owner: TClass;
  AttribClass: TCustomAttributeClass; PropName: string;
  AContext: TRttiContext): T;
begin
  Result := Value(Owner, AttribClass, PropName, AContext).AsType<T>;
end;

class function TAttributeReader.ValueFromMethod<T>(Owner: TClass;
  AttribClass: TCustomAttributeClass; MethodName, PropName: string): T;
begin
  Result := ValueFromMethod(Owner, AttribClass, MethodName, PropName).AsType<T>;
end;

class function TAttributeReader.Value<T>(Attrib: TCustomAttribute;
  PropName: string): T;
begin
  Result := Value(Attrib, PropName).AsType<T>;
end;

class function TAttributeReader.Value(Owner: TClass;
  AttribClass: TCustomAttributeClass; PropName: string): TValue;
var
  LContext: TRttiContext;
begin
  LContext := TRttiContext.Create;
  try
    Result := Value(Owner, AttribClass, PropName, LContext);
  finally
    LContext.Free;
  end;
end;

class function TAttributeReader.Value(Owner: TClass;
  AttribClass: TCustomAttributeClass; PropName: string;
  AContext: TRttiContext): TValue;
var
  LType: TRttiType;
begin
  LType := AContext.GetType(Owner);
  Result := GetValueFromAttribute(AttribClass, LType.GetAttributes, PropName, AContext);
end;

class function TAttributeReader.Value<T>(Attrib: TCustomAttribute;
  PropName: string; AContext: TRttiContext): T;
begin
  Result := Value(Attrib, PropName, AContext).AsType<T>;
end;

class function TAttributeReader.ValueFromMethod(Owner: TClass;
  AttribClass: TCustomAttributeClass; MethodName, PropName: string): TValue;
var
  LContext: TRttiContext;
begin
  LContext := TRttiContext.Create;
  try
    Result := ValueFromMethod(Owner, AttribClass, MethodName, PropName, LContext);
  finally
    LContext.Free;
  end;
end;

class function TAttributeReader.ValueFromMethod(Owner: TClass;
  AttribClass: TCustomAttributeClass; MethodName, PropName: string;
  AContext: TRttiContext): TValue;
var
  LType: TRttiType;
  LMethod: TRttiMethod;
begin
  Result := Default(TValue);
  LType := AContext.GetType(Owner);
  LMethod := LType.GetMethod(MethodName);
  if Assigned(LMethod) then
    Result := GetValueFromAttribute(AttribClass, LMethod.GetAttributes, PropName, AContext);
end;

class function TAttributeReader.ValueFromMethod<T>(Owner: TClass;
  AttribClass: TCustomAttributeClass; MethodName, PropName: string;
  AContext: TRttiContext): T;
begin
  Result := ValueFromMethod(Owner, AttribClass, MethodName, PropName, AContext).AsType<T>;
end;

class function TAttributeReader.Value(Attrib: TCustomAttribute;
  PropName: string): TValue;
var
  LContext: TRttiContext;
begin
  LContext := TRttiContext.Create;
  try
    Result := Value(Attrib, PropName, LContext);
  finally
    LContext.Free;
  end;
end;

class function TAttributeReader.Value(Attrib: TCustomAttribute;
  PropName: string; AContext: TRttiContext): TValue;
begin
  Result := GetPropertyValue(Attrib, PropName, AContext);
end;

{ TCustomAttributeHelper }
function TCustomAttributeHelper.Value(PropName: string): TValue;
begin
  Result := TAttributeReader.Value(Self, PropName);
end;

function TCustomAttributeHelper.Value<T>(PropName: string): T;
begin
  Result := Value(PropName).AsType<T>;
end;

end.
