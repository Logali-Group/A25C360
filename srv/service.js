const cds = require('@sap/cds');

module.exports = class LogaliGroup extends cds.ApplicationService {

    init () {

        const {Products, Inventories} = this.entities;

        this.before('NEW', Products.drafts, async (req)=>{
            req.data.detail??= {
                baseUnit: 'EA',
                width: null,
                height: null,
                depth: null,
                weight: null,
                unitVolume: 'CM',
                unitWeight: 'KG'
            }
        });

        this.before('NEW', Inventories.drafts, async (req)=>{
            let result = await SELECT.one.from(Inventories).columns('max(stockNumber) as max');         //360
            let result2 = await SELECT.one.from(Inventories.drafts).columns('max(stockNumber) as max'); //361
            
            let max = parseInt(result.max);     //360
            let max2 = parseInt(result2.max);   //361
            let newMax = 0;

            if (isNaN(max2)) {
                newMax = max + 1;
            } else if (max < max2) {
                newMax = max2 + 1;
            } 
            
            req.data.stockNumber = newMax.toString();
        });


        return super.init();
    }
}