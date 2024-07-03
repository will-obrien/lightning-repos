/************************************************************************************************************************************
** Author: Salesforce Services
************************************************************************************************************************************/
trigger CCOrderItemTrigger on ccrz__E_OrderItem__c (before insert, before update, after insert) {
	if (!PHSS_TriggerSettings__c.getOrgDefaults().CCOrderItemTrigger_Disabled__c) {
        CCOrderItemTriggerHandler handler = new CCOrderItemTriggerHandler();
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.onBeforeInsert(Trigger.new);
            handler.populateILTClass(Trigger.new);
        } else if (Trigger.isBefore && Trigger.isUpdate) {
            handler.onBeforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        } else if (trigger.isAfter && Trigger.isInsert) {
            //handler.populateILTClass(Trigger.new);
        }
	}
}