namespace com.logaligroup;

using {
    cuid,
    managed,
    sap.common.CodeList,
    sap.common.Currencies
} from '@sap/cds/common';

using {
    API_BUSINESS_PARTNER_CLOUD as cloud
} from '../srv/external/API_BUSINESS_PARTNER_CLOUD';

entity Products : cuid, managed {
    product       : String(11);
    productName   : String(80);
    image         : LargeBinary  @Core.MediaType: imageType  @Core.ContentDisposition.Filename: fileName;
    imageType     : String       @Core.IsMediaType;
    fileName      : String;
    description   : LargeString;
    category      : Association to Categories; // category category_ID
    subCategory   : Association to SubCategories; // subCategory subCategory_ID
    statu         : Association to Status; // statu statu_code
    price         : Decimal(6, 2);
    rating        : Decimal(3, 2);
    currency      : Association to Currencies;
    detail        : Composition of ProductDetails; // detail detail_ID
    supplier      : Association to Suppliers; //supplier supplier_ID
    supplierCloud : Association to cloud.A_Supplier;
    toReviews     : Association to many Reviews
                        on toReviews.product = $self;
    toInventories : Composition of  many Inventories
                        on toInventories.product = $self;
    toSales       : Association to many Sales
                        on toSales.product = $self;
};

entity ProductDetails : cuid {
    baseUnit   : String default 'EA';
    width      : Decimal(6, 3);
    height     : Decimal(6, 3);
    depth      : Decimal(6, 3);
    weight     : Decimal(6, 3);
    unitVolume : String default 'CM';
    unitWeight : String default 'KG';
};

entity Suppliers : cuid {
    supplier     : String(11);
    supplierName : String(40);
    webAddress   : String(250);
    contact      : Association to Contacts; // contact contact_ID
};

entity Contacts : cuid {
    fullName    : String(40);
    email       : String(80);
    phoneNumber : String(40);
};

entity Reviews : cuid {
    rating     : Decimal(3, 2);
    date       : Date;
    user       : String(40);
    reviewText : LargeString;
    product    : Association to Products; //product product_ID
};

entity Inventories : cuid {
    stockNumber : String(12);
    department  : Association to Departments;
    min         : Integer default 0;
    max         : Integer default 500;
    target      : Integer;
    quantity    : Decimal(6, 3);
    baseUnit    : String default 'EA';
    product     : Association to Products;
};

entity Sales : cuid {
    monthCode     : String(2);
    month         : String(20);
    year          : String(4);
    quantitySales : Integer;
    product       : Association to Products;
};

/** Code List */
entity Status : CodeList {
    key code        : String(20) enum {
            InStock = 'In Stock';
            OutOfStock = 'Out of Stock';
            LowAvailability = 'Low Availability';
        };
        criticality : Integer;
};

/**Value Helps */
entity Categories : cuid {
    category        : String(80);
    toSubCategories : Composition of many SubCategories
                          on toSubCategories.category = $self;
};

entity SubCategories : cuid {
    subCategory : String(80);
    category    : Association to Categories; //category category_ID
};

entity Departments : cuid {
    department : String(40);
};

entity Options: CodeList {
    key code : String(10) enum {
        A = 'Add';
        D = 'Discount'
    };
};
