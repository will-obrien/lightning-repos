public class SQLInjectionFalsePos {
//trigger

    public static List <Contact> getContacts(String name,String city, String country, string org, string orgId) {   
        string nameFilter;
        if (string.isNotBlank(name)) {
            string[] nameVals = name.split(' ');
            List<string> finalNameVals = new List<string>();
            for (string s : nameVals) {
                if (string.isNotBlank(s)) { finalNameVals.add(s); }
            }

            if (finalNameVals.size() > 2) {
                nameFilter = string.escapeSingleQuotes('%' + finalNameVals[0] + '%' + finalNameVals[finalNameVals.size() - 1] + '%');
            }

            else if (finalNameVals.size() == 2) {
                nameFilter = string.escapeSingleQuotes('%' + finalNameVals[0] + '%' + finalNameVals[1] + '%');
            }
            else {
                nameFilter = '%'+String.escapeSingleQuotes(name)+ '%';
            }
        }

        String query='SELECT Id, Name, Account.Name,AccountId,MailingCity,MailingCountry,MailingState,MailingStreet,MailingPostalCode FROM Contact WHERE Status__c = \'Active\' and IsDeleted=false';
        if (string.isNotBlank(nameFilter)) {
            query += ' AND Name like \'%' + String.escapeSingleQuotes(nameFilter)+ '%\'';
        }
        if (string.isNotBlank(orgId)) {
            query=query+' AND AccountId = '+'\''+String.escapeSingleQuotes(orgId)+ '\'';
        }
        if (string.isNotBlank(org)) {
            query=query+' AND Account.Name like '+'\'%'+String.escapeSingleQuotes(org)+ '%\'';
        }
        if (string.isNotBlank(city)) {
            query=query+' AND MailingCity like '+'\'%'+String.escapeSingleQuotes(city)+ '%\'';
        }
        if (string.isNotBlank(country)) {
            query=query+' AND MailingCountry like '+'\'%'+String.escapeSingleQuotes(country)+ '%\'';
        }

        query=query+' ORDER BY Name ASC Limit 15'; 
        system.debug('contact query = ' + query);

        return Database.query(query);
    } 
    
    public void bad(String param){
        param = 'Will';
    }
}
