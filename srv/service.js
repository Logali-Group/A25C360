const cds = require('@sap/cds');

module.exports = class LogaliGroup extends cds.ApplicationService {

    async init () {

        const {Products, Inventories, BusinessPartner, CSuppliers, Customers} = this.entities;
        const cloud = await cds.connect.to("API_BUSINESS_PARTNER_CLOUD");
        const onpremise = await cds.connect.to("API_BUSINESS_PARTNER_ONPREMISE");

        this.on('READ', [BusinessPartner, CSuppliers], async (req)=>{
            return await cloud.tx(req).send({
                query: req.query,
                headers: {
                    apikey: "edRnI3BSo8UDDh4uxQyJn32cdmXdHtMM"
                }
            })
        });

        
        this.on('READ', Customers, async (req)=>{
            return await onpremise.tx(req).send({
                query: req.query,
                headers: {
                    Authorization: "Basic amJyaWNlbm86TG9nYWxpLjIwMjQ="
                }
            })
        });

        // this.on('READ', CSuppliers, async (req)=>{
        //     return await cloud.tx(req).send({
        //         query: req.query,
        //         headers: {
        //             apikey: "edRnI3BSo8UDDh4uxQyJn32cdmXdHtMM"
        //         }
        //     })
        // });


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
            } else {
                newMax = max + 1;
            }

            req.data.stockNumber = newMax.toString();
        });

        this.on('setStock', async (req)=>{
            const productId = req.params[0].ID;
            const inventoryId = req.params[1].ID;

            const resultAmount = await SELECT.one.from(Inventories).columns('quantity').where({ID:inventoryId});
            let newAmount = 0;

            //quantity = 0 --> OutOfStock
            //quantity > 0 <= 300 --> LowAvailability
            //quantity > 300 --> InStock

            if (req.data.option === 'A') {
                newAmount = resultAmount.quantity + req.data.amount;

                if (newAmount > 300) {
                    await UPDATE(Products).set({statu_code: 'InStock'}).where({ID: productId});
                }

                await UPDATE(Inventories).set({quantity: newAmount}).where({ID: inventoryId});
                return req.info(200,`The amount ${req.data.amount} has been added to the inventory`)
            } else if (resultAmount.quantity < req.data.amount) {
                req.error(400, `There is no availability for the requested quantity`);
            } else {
                newAmount = resultAmount.quantity - req.data.amount;

                if (newAmount > 0 && newAmount <= 300) {
                    await UPDATE(Products).set({statu_code: 'LowAvailability'}).where({ID: productId});
                } else if (newAmount === 0) {
                    await UPDATE(Products).set({statu_code: 'OutOfStock'}).where({ID: productId});
                }

                await UPDATE(Inventories).set({quantity: newAmount}).where({ID: inventoryId});
                req.info(200, `The amount ${req.data.amount} has been removed from the inventory`);
            }
            
        });

        return super.init();
    }
}