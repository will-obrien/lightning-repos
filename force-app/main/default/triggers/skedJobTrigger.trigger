trigger skedJobTrigger on sked__Job__c (before insert, before update, after insert, after update, before delete) {
    if (Trigger.isBefore) {
        if(trigger.isInsert){
            skedJobHandler.beforeInsert(trigger.new);
        }
        else if (Trigger.isUpdate) {
            skedJobHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            skedJobHandler.afterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            skedJobHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}