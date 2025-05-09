using {LogaliGroup as services} from '../service';

annotate services.Products with {
    product     @title: 'Product';
    productName @title: 'Product Name';
    description @title: 'Description';
    category    @title: 'Category';
    subCategory @title: 'Sub-Category';
    statu       @title: 'Statu';
    price       @title: 'Price' @Measures.ISOCurrency: currency;
    rating      @title: 'Rating';
    currency    @title: 'Currency' @Common.IsCurrency;
    supplier    @title: 'Supplier';
};

annotate services.Products with {
    productName @Common: {
        Text : product
    };
    statu @Common: {
        Text : statu.name,
        TextArrangement : #TextOnly
    };
    category @Common: {
        Text : category.category,
        TextArrangement : #TextOnly
    };
    subCategory @Common: {
        Text : subCategory.subCategory,
        TextArrangement : #TextOnly
    };
};


annotate services.Products with @(
    Common.SemanticKey  : [
        product
    ],
    UI.HeaderInfo  : {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Product',
        TypeNamePlural : 'Products',
    },
    UI.SelectionFields: [
        product,
        productName,
        supplier_ID,
        category_ID,
        subCategory_ID,
        statu_code
    ],
    UI.LineItem       : [
        {
            $Type: 'UI.DataField',
            Value: product
        },
        {
            $Type: 'UI.DataField',
            Value: productName
        },
        {
            $Type: 'UI.DataField',
            Value: description,
            ![@UI.Hidden]
        },
        {
            $Type: 'UI.DataField',
            Value: category_ID
        },
        {
            $Type: 'UI.DataField',
            Value: subCategory_ID
        },
        {
            $Type: 'UI.DataField',
            Value: statu_code,
            Criticality : statu.criticality
        },
        {
            $Type : 'UI.DataFieldForAnnotation',
            Target : '@UI.DataPoint#Rating',
            Label : 'Rating',
            ![@HTML5.CssDefaults] : {
                $Type : 'HTML5.CssDefaultsType',
                width : '10rem'
            },
        },
        {
            $Type: 'UI.DataField',
            Value: price
        }
    ],
    UI.DataPoint #Rating : {
        $Type : 'UI.DataPointType',
        Value : rating,
        Visualization : #Rating
    }
);
