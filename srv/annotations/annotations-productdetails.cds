using {LogaliGroup as service} from '../service';

annotate service.ProductDetails with {
    baseUnit    @title: 'Base Unit'    @Common.IsUnit @Common.FieldControl : #ReadOnly;
    weight      @title: 'Weight'       @Measures.Unit: unitWeight;
    height      @title: 'Height'       @Measures.Unit: unitVolume;
    width       @title: 'Width'        @Measures.Unit: unitVolume;
    depth       @title: 'Depth'        @Measures.Unit: unitVolume;
    unitWeight  @title: 'Weight Unit'  @Common.IsUnit @Common.FieldControl : #ReadOnly;
    unitVolume  @title: 'Volume Unit'  @Common.IsUnit @Common.FieldControl : #ReadOnly;
};

annotate service.ProductDetails with @(
    UI.FieldGroup #Details: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: baseUnit
            },
            {
                $Type: 'UI.DataField',
                Value: height
            },
            {
                $Type: 'UI.DataField',
                Value: width
            },
            {
                $Type: 'UI.DataField',
                Value: depth
            },
            {
                $Type: 'UI.DataField',
                Value: weight
            }
        ]
    }
);
