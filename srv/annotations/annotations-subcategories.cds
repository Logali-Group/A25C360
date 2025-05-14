using {LogaliGroup as service} from '../service';

annotate service.VH_SubCategories with {
    ID @title : 'Sub-Categories' @Common: {
        Text : subCategory,
        TextArrangement : #TextOnly
    }
};
