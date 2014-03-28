## Description
EasyAttributes simplify the access to attributes.

## ValueAttribute
A simple way to query an attribute value:


    //TStringAttribute is declared in eDUtils.Attributes.ValueAttribute
    Description = class(TStringAttribute);

    [Description('Hi, im foo!')]
    TFoo = class
    public
      procedure ShowMyAttributes;
    end;
    
    ...

    procedure TFoo.ShowMyAttributes;
    var
      LRttiContext: TRttiContext;
      LAttribute: TCustomAttribute;
    begin
      LRttiContext := TRttiContext.Create;
      try
        for LAttribute in LRttiContext.GetType(Self.ClassType).GetAttributes do
        begin
          ShowMessage(LAttribute.Value.ToString);
          ShowMessage(LAttribute.Value<string>);
          
          //Both ways has the same result
          //Note: For using generic<T> overload you have to know the result type
          //in this example if my attribute isn't string raises EInvalidCast! 
        end;
      finally
        LRttiContext.Free
      end;
    end;

## License
EasyAttributes is released under version 2.0 of the [Apache License][].

[Apache License]: http://www.apache.org/licenses/LICENSE-2.0
