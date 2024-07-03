/**
 * Created by jbarker on 12/19/18.
 */

trigger CaptureCCPaymentOnFulfillmentInsert on Fulfillment__c (after insert) {
    system.debug('@@@PHSS_TriggerSettings__c.getOrgDefaults().FulfillmentTriggerDisabled__c: '+PHSS_TriggerSettings__c.getOrgDefaults().FulfillmentTriggerDisabled__c);
    if(!PHSS_TriggerSettings__c.getOrgDefaults().FulfillmentTriggerDisabled__c){
        for (Fulfillment__c fulfillment : trigger.new) {
            if (fulfillment.CC_Transaction_Payment__c != null) {
                ccrz__E_TransactionPayment__c transactionPayment = [
                        SELECT Id, ccrz__AccountType__c, ccrz__Amount__c
                        FROM ccrz__E_TransactionPayment__c
                        WHERE Id = :fulfillment.CC_Transaction_Payment__c
                        LIMIT 1
                ];

                if (transactionPayment != null) {
                    if (transactionPayment.ccrz__AccountType__c == 'cc') {
                        if (transactionPayment.ccrz__Amount__c < 0) {
                            system.debug('@@@executing phss_cc_CyberSourceCreditUtil.creditFulfillment(...)');
                            phss_cc_CyberSourceCreditUtil.createRefundTransactionPayment(transactionPayment.Id);
                            phss_cc_CyberSourceCreditUtil.creditFulfillment(fulfillment.Id);
                        }
                        else if (transactionPayment.ccrz__Amount__c > 0) {
                            
                            phss_cc_FulfillmentUtil.capturePayment(fulfillment);
                            phss_cc_CyberSourceCaptureUtil.capturePayment(fulfillment.Id);
                        }
                    }
                }
            }
        }
    }
}