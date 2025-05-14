using {LogaliGroup as service} from '../service';

annotate service.Contacts with {
    fullName @title : 'Full Name';
    email    @title : 'Email'; 
    phoneNumber @title : 'Phone Number';
};

annotate service.Contacts with @(
    UI.FieldGroup #Contacts : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : fullName,
            },
            {
                $Type : 'UI.DataField',
                Value : email
            },
            {
                $Type : 'UI.DataField',
                Value : phoneNumber
            }
        ]
    },
);
