using {com.logaligroup as entities} from '../db/schema';
using {API_BUSINESS_PARTNER_CLOUD as cloud} from './external/API_BUSINESS_PARTNER_CLOUD';
using {API_BUSINESS_PARTNER_ONPREMISE as onpremise} from './external/API_BUSINESS_PARTNER_ONPREMISE';

service LogaliGroup {

    type dialog {
        option : String(10);
        amount : Integer;
    };

    entity Products         as projection on entities.Products;
    entity ProductDetails   as projection on entities.ProductDetails;
    entity Suppliers        as projection on entities.Suppliers;
    entity Contacts         as projection on entities.Contacts;
    entity Reviews          as projection on entities.Reviews;

    entity Inventories      as projection on entities.Inventories
        actions {
            @Core.OperationAvailable: {
                $edmJson: {
                    $If: [
                        {
                            $Eq: [
                                {
                                    $Path: 'in/IsActiveEntity'
                                },
                                false
                            ]
                        },
                        false,
                        true
                    ]
                }
            }
            @Common: {
                SideEffects : {
                    $Type : 'Common.SideEffectsType',
                    TargetProperties : [
                        'in/quantity',
                    ],
                    TargetEntities : [
                        in.product
                    ],
                },
            }
            action setStock(
                in: $self,
                option : dialog : option,
                amount : dialog : amount
            )
        };

    entity Sales            as projection on entities.Sales;
    /** Code List */
    entity Status           as projection on entities.Status;
    /** Value Helps */
    entity VH_Categories    as projection on entities.Categories;
    entity VH_SubCategories as projection on entities.SubCategories;
    entity VH_Departments   as projection on entities.Departments;
    entity VH_Options       as projection on entities.Options;

    /** Servicios remotos */
    entity BusinessPartner as projection on cloud.A_BusinessPartner {
        key BusinessPartner as ID,
        BusinessPartnerCategory as Category,
        BusinessPartnerFullName as FullName,
        FirstName,
        LastName
    };

    entity CSuppliers as projection on cloud.A_Supplier {
        key Supplier as ID,
            SupplierName,
            SupplierFullName
    };

    entity Customers as projection on onpremise.A_Customer {
        key Customer as ID,
            CustomerFullName,
            CustomerName
    };
};
