using {LogaliGroup as services} from '../service';

using from './annotations-suppliers';
using from './annotations-productdetails';
using from './annotations-reviews';
using from './annotations-inventories';
using from './annotations-sales';

annotate services.Products with @odata.draft.enabled;


annotate services.Products with {
    product     @title: 'Product';
    productName @title: 'Product Name';
    description @title: 'Description' @UI.MultiLineText;
    category    @title: 'Category';
    subCategory @title: 'Sub-Category';
    statu       @title: 'Statu';
    price       @title: 'Price' @Measures.ISOCurrency: currency_code;
    rating      @title: 'Rating';
    currency    @title: 'Currency' @Common.IsCurrency;
    supplier    @title: 'Supplier';
    image @title : 'Image' @UI.IsImage;
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
        TextArrangement : #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_Categories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : category_ID,
                    ValueListProperty : 'ID'
                }
            ]
        }
    };
    subCategory @Common: {
        Text : subCategory.subCategory,
        TextArrangement : #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_SubCategories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterIn',      //Filter
                    LocalDataProperty : category_ID,            //Products
                    ValueListProperty : 'category_ID'           //SubCategories
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : subCategory_ID,
                    ValueListProperty : 'ID'
                }
            ]
        }
    };
    supplier @Common: {
        Text : supplier.supplierName,
        TextArrangement : #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Suppliers',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : supplier_ID,
                    ValueListProperty : 'ID'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'supplier'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'webAddress'
                }
            ]
        }
    }
};


annotate services.Products with @(
    // Common.SemanticKey  : [
    //     product
    // ],
    Common.SideEffects: {
        $Type : 'Common.SideEffectsType',
        SourceProperties : [
            supplier_ID
        ],
        TargetEntities : [
            supplier
        ],
    },
    UI.HeaderInfo  : {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Product',
        TypeNamePlural : 'Products',
        Title : {
            $Type : 'UI.DataField',
            Value : productName
        },
        Description : {
            $Type : 'UI.DataField',
            Value : product
        },
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
            $Type : 'UI.DataField',
            Value : image,
        },
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
    },
    UI.FieldGroup #Image: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : image,
                Label : ''
            }
        ]
    },
    UI.FieldGroup #SupplierAndCategory : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : supplier_ID
            },
            {
                $Type : 'UI.DataField',
                Value : category_ID
            },
            {
                $Type : 'UI.DataField',
                Value : subCategory_ID
            }
        ]
    },
    UI.FieldGroup #Description: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : description,
                Label : ''
            }
        ]
    },
    UI.FieldGroup #Availability: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : statu_code,
                Criticality : statu.criticality,
                Label : '',
                ![@Common.FieldControl] : {
                    $edmJson: {
                        $If:[
                            {
                                $Eq:[
                                    {
                                        $Path: 'IsActiveEntity'
                                    },
                                    false
                                ]
                            },
                            1,
                            3
                        ]
                    }
                },
            }
        ],        
    },
    UI.FieldGroup #Price: {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : price,
                Label : ''
            }
        ]
    },
    UI.HeaderFacets  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Image',
            Label : '',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#SupplierAndCategory',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Description',
            Label : 'Product Information'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Availability',
            Label : 'Availability'            
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Price',
            Label : 'Price'
        }
    ],
    UI.Facets  : [
        {
            $Type : 'UI.CollectionFacet',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'supplier/@UI.FieldGroup#Supplier',
                    Label : 'Information'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target : 'supplier/contact/@UI.FieldGroup#Contacts',
                    Label : 'Contact Person'
                }
            ],
            Label : 'Supplier Information',
            ID : 'SupplierInformation'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'detail/@UI.FieldGroup#Details',
            Label : 'Product Information',
            ID : 'ProductInformation'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toReviews/@UI.LineItem',
            Label : 'Reviews',
            ID : 'toReviews'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toInventories/@UI.LineItem',
            Label : 'Inventory Information',
            ID : 'toInventories'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toSales/@UI.Chart#ChartLine',
            Label : 'Sales',
            ID : 'toSales'
        }
    ]
);
