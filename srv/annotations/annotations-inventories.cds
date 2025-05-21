using {LogaliGroup as service} from '../service';

annotate service.Inventories with {
    stockNumber @title: 'Stock Number' @Common.FieldControl : #ReadOnly;
    baseUnit    @title: 'Base Unit'  @Common.IsUnit @Common.FieldControl : #ReadOnly;
    department  @title: 'Department';
    quantity    @title: 'Quantity'   @Measures.Unit: baseUnit @Common.FieldControl : #ReadOnly;
    min         @title: 'Minimun' @Common.FieldControl : #ReadOnly;
    max         @title: 'Maximun' @Common.FieldControl : #ReadOnly;
    target      @title: 'Target';
};

annotate service.Inventories with {
    department @Common: {
        Text           : department.department,
        TextArrangement: #TextOnly
    }
};


annotate service.Inventories with @(
    UI.HeaderInfo           : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Inventory',
        TypeNamePlural: 'Inventories',
        Title         : {
            $Type: 'UI.DataField',
            Value: product.productName
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: product.product
        },
    },
    UI.LineItem             : [
        {
            $Type: 'UI.DataField',
            Value: stockNumber
        },
        {
            $Type: 'UI.DataField',
            Value: department_ID
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.Chart#Bullet',
            Label : '',
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem'
            }
        },
        {
            $Type: 'UI.DataField',
            Value: quantity
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'LogaliGroup.setStock',
            Label : 'Set Stock',
            Inline : true
        },
    ],
    UI.FieldGroup #Inventory: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: stockNumber,
            },
            {
                $Type: 'UI.DataField',
                Value: department_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: min,
            },
            {
                $Type: 'UI.DataField',
                Value: max,
            },
            {
                $Type: 'UI.DataField',
                Value: target,
            },
            {
                $Type: 'UI.DataField',
                Value: quantity,
            }
        ],
    },
    UI.Facets               : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.FieldGroup#Inventory',
            Label : 'Inventory Information'
        }
    ],
    UI.DataPoint  : {
        $Type : 'UI.DataPointType',
        Value : quantity,
        Title : 'Quantity Status',
        MinimumValue: min,
        MaximumValue : max,
        CriticalityCalculation : {
            $Type : 'UI.CriticalityCalculationType',
            ImprovementDirection : #Maximize,
            ToleranceRangeLowValue : 300,
            DeviationRangeLowValue : 100
        }
    },
    UI.Chart #Bullet : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bullet,
        Measures : [
            quantity
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                DataPoint : '@UI.DataPoint',
                Measure : quantity
            }
        ]
    }
);
