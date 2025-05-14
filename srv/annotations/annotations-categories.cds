using {LogaliGroup as service} from '../service';

annotate service.VH_Categories with {
    ID @title : 'Categories' @Common: {
        Text : category,
        TextArrangement : #TextOnly
    }
};
