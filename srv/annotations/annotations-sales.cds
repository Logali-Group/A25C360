using {LogaliGroup as service} from '../service';

annotate service.Sales with {
    month         @title: 'Month'       @Common.IsCalendarMonth;
    monthCode     @title: 'Month Code'  @Common.IsCalendarMonth;
    year          @title: 'Year'        @Common.IsCalendarYear;
    quantitySales @title: 'Quantiy Sales';
};

annotate service.Sales with @(
    Analytics.AggregatedProperty #sum : {
        Name: 'Sales',
        AggregationMethod : 'sum',
        AggregatableProperty : 'quantitySales'   
    },
    Aggregation.ApplySupported  : {
        $Type : 'Aggregation.ApplySupportedType',
        Transformations : [
            'aggregate',
            'topcount',
            'bottomcount',
            'identity',
            'concat',
            'groupby',
            'filter',
            'concat',
            'top',
            'skip',
            'orderby',
            'search'
        ],
        Rollup : #None,
        GroupableProperties : [
            year,
            month,
            monthCode
        ],
        AggregatableProperties : [
            {
                $Type : 'Aggregation.AggregatablePropertyType',
                Property : quantitySales
            }
        ],
    },
    UI.Chart  #ChartLine: {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Line,
        Dimensions : [
            year,
            month
        ],
        DynamicMeasures: ['@Analytics.AggregatedProperty#sum']
    },
);
