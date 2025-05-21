using {LogaliGroup as service} from '../service';

annotate service.CSuppliers with {
    ID @title: 'Suppliers' @Common: {
        Text: SupplierFullName,
        TextArrangement : #TextOnly
    }
}