using {LogaliGroup as service} from '../service';

annotate service.Suppliers with {
    ID           @title: 'Suppliers'  @Common: {
        Text           : supplierName,
        TextArrangement: #TextOnly
    };
    supplier     @title: 'Supplier';
    supplierName @title: 'Supplier Name';
    webAddress   @title: 'Web Address';
};
