({
	fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
    onClickYes : function(component, event, helper)
    {
        var qty		  = component.get("v.qty");
        var originalQty = component.get("v.originalQty");
        
        console.log("originalQty%%%%"+originalQty);
        console.log("qty$$$"+qty);
        
        if(qty <= originalQty)
        {
            component.set("v.spinner", 'true');
            
            var odrAdjTps = component.get("v.objDetail.Adjustment_Types__c");
            var rsnCods	  = component.get("v.objDetail.Reason_Codes__c");
            var explntn	  = component.get("v.explnation");
            
            var orderId   = component.get("v.recordId");
            
            var action    = component.get("c.replaceOI");
            
            action.setParams({ 'orderId'     		: orderId,
                               'qty'	     		: qty,
                               'orderAdjustmentType': odrAdjTps,
                               'reasonCodes' 		: rsnCods,
                               'explanation' 		: explntn});
            
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title"   : "Success!",
                        "message" : "Order Item Replaced Successfully.",
                        "type"    : "success"
                    });
                    toastEvent.fire();
                    $A.get("e.force:refreshView").fire();
                    component.set("v.stepNumber", "Zero");
                }
                
            });
            
            $A.enqueueAction(action);
        }else{
            component.set("v.qtyError",true);
        }
    }
})