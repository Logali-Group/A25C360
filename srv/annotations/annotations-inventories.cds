using {LogaliGroup as service} from '../service';

annotate service.Inventories with {
    stockNumber @title: 'Stock Number';
    baseUnit    @title: 'Base Unit' @Common.IsUnit;
    department  @title: 'Department';
    quantity    @title: 'Quantity' @Measures.Unit : baseUnit;
    min         @title: 'Minimun';
    max         @title: 'Maximun';
    target      @title: 'Target';
};

annotate service.Inventories with {
    department @Common : { 
        Text : department.department,
        TextArrangement : #TextOnly
     }
};


annotate service.Inventories with @(
    UI.HeaderInfo  : {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Inventory',
        TypeNamePlural : 'Inventories',
        Title : {
            $Type : 'UI.DataField',
            Value : product.productName
        },
        Description : {
            $Type : 'UI.DataField',
            Value : product.product
        },
    },
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : stockNumber
        },
        {
            $Type : 'UI.DataField',
            Value : department_ID
        },
        {
            $Type : 'UI.DataField',
            Value : quantity
        },
        // {
        //     $Type : 'UI.DataFieldForAnnotation',
        //     Target : '@UI.Chart#Bullet',
        // },
    ],
    UI.FieldGroup #Inventory: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : stockNumber,
            },
            {
                $Type : 'UI.DataField',
                Value : department_ID,
            },
            {
                $Type : 'UI.DataField',
                Value : min,
            },
            {
                $Type : 'UI.DataField',
                Value : max,
            },
            {
                $Type : 'UI.DataField',
                Value : target,
            },
            {
                $Type : 'UI.DataField',
                Value : quantity,
            }
        ],
    },
    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Inventory',
            Label : 'Inventory Information'
        },
    ],
    UI.DataPoint: {
        $Type : 'UI.DataPointType',
        Value : target,
        MinimumValue : min,
        MaximumValue : max,
        CriticalityCalculation: {
            $Type : 'UI.CriticalityCalculationType',
            ImprovementDirection : #Maximize,
            ToleranceRangeLowValue : 300,
            DeviationRangeLowValue : 0
        }
    },
    UI.Chart #Bullet   : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bullet,
        Measures : [
            target
        ],
        MeasureAttributes : [
            {
                $Type : 'UI.ChartMeasureAttributeType',
                DataPoint : '@UI.DataPoint',
                Measure : target
            }
        ]
    }
);

