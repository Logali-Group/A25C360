using {LogaliGroup as service} from '../service';

annotate service.Status with {
    code  @title: 'Status'  @Common: {
        Text           : name,
        TextArrangement: #TextOnly
    };
};
