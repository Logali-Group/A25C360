using {LogaliGroup as service} from '../service';


annotate service.Reviews with {
    date       @title: 'Creation Date';
    user       @title: 'User';
    rating     @title: 'Rating';
    reviewText @title: 'Review Text';
};

annotate service.Reviews with @(
    UI.HeaderInfo: {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Review',
        TypeNamePlural: 'Reviews',
        Title : {
            $Type: 'UI.DataField',
            Value: product.productName,
        },
        Description : {
            $Type: 'UI.DataField',
            Value: product.product
        },
    },
    UI.LineItem  : [
        {
            $Type: 'UI.DataField',
            Value: date,
        },
        {
            $Type: 'UI.DataField',
            Value: user,
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#Rating2',
            Label : 'Rating',
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem',
            },
        },
        {
            $Type: 'UI.DataField',
            Value: reviewText,
        }
    ],
    UI.FieldGroup #Review : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: date,
            },
            {
                $Type: 'UI.DataField',
                Value: user,
            },
            {
                $Type: 'UI.DataField',
                Value: rating,
            },
            {
                $Type: 'UI.DataField',
                Value: reviewText,
            }
        ],
    },
    UI.Facets  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Review',
            Label : 'Review',
        },
    ],
    UI.DataPoint #Rating2 : {
        $Type: 'UI.DataPointType',
        Value: rating,
        Visualization: #Rating
    }
);
