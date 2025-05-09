namespace com.logaligroup;

using {
    cuid,
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

entity Products : cuid, managed {
    product       : String(11);
    productName   : String(80);
    description   : LargeString;
    category      : Association to Categories; // category category_ID
    subCategory   : Association to SubCategories; // subCategory subCategory_ID
    statu         : Association to Status; // statu statu_code
    price         : Decimal(6, 2);
    rating        : Decimal(3, 2);
    currency      : String;
    detail        : Association to ProductDetails; // detail detail_ID
    supplier      : Association to Suppliers; //supplier supplier_ID
    toReviews     : Association to many Reviews
                        on toReviews.product = $self;
    toInventories : Association to many Inventories
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
    user : String(40);
    reviewText : LargeString;
    product    : Association to Products; //product product_ID
};

entity Inventories : cuid {
    stockNumber : String(12);
    department : Association to Departments;
    min         : Integer;
    max         : Integer;
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
            InStock         = 'In Stock';
            OutOfStock      = 'Out of Stock';
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
    category    : Association to Categories;
};

entity Departments : cuid {
    department : String(40);
}
