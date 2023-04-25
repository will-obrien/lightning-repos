
//Hello world
public class Terrible{
	public Employee_Detail__c empDetail		{get;set;}
	public Employer__c employer				{get;set;}
	public Personal__c personal				{get;set;}
    public String prefix= Label.Package_Prefix;
	//START :: 10/12/2018 NPAY-651 Postgraduate loan deductions modified by Shiva
	// START :: 20/01/2016 NPAY-112 Payroll process changes in Payroll2. added by Farhan
	//public string LoanRepayOptionValue{get;set;} 
	public boolean finishedStudiesCheckbox{get;set;}
	public boolean displayPopup {get {
        if( displayPopup == null ) displayPopup = false;
        return displayPopup;
    } 
    set;}
	
  public void badIdea(String param){
  	 param = 'Hello World';
  }
	
	public static PagedResult findAll(String searchKey, Decimal minAlcohol, Decimal pageNumber) {
		Integer pageSize = 12;
		String key = '%' + searchKey + '%';
		Integer offset = ((Integer)pageNumber - 1) * pageSize;

		PagedResult r =  new PagedResult();     

		r.products = [SELECT Id, Name, Alcohol__c, Tags__c, Brewery__r.Name, Image__c FROM Beer__c
			    WHERE (Name LIKE :key OR Brewery__r.Name LIKE :key OR Tags__c LIKE :key ) WITH SECURITY_ENFORCED
			    AND Alcohol__c >= :minAlcohol
			    ORDER BY NAME LIMIT 12 OFFSET :offset]; 
		System.debug(r);
		return r;
	}


    public void execute(Database.BatchableContext BC, List<Financial_Reporting__c> scope)
    {
    	//START :: 31/07/2018 NPAY-529 Financial Reporting modified by Farhan
    	//check the scope for not empty along with not null
 		if(scope != null && !scope.isEmpty())
 		//END :: 31/07/2018 NPAY-529 Financial Reporting modified by Farhan
 		{
 			delete scope;
 		}
    }


    //END :: 10/12/2018 NPAY-651 Postgraduate loan deductions modified by Shiva
	/* START :: 19/3/2016 NPAY-116 payroll issue list commented by Farhan
	public string StudentLoanCheckboxValue{get;set;}
		END :: 19/3/2016 NPAY-116 payroll issue list commented by Farhan */
	public List<selectOption> getLoanRepayPicklistValues()
    {
      	List<selectOption> options = new List<selectOption>();
      	options.add(new selectOption('None','-None-'));
        options.add(new selectOption('Yes','Yes')); 
        options.add(new selectOption('No','No'));
        return options;
    }   
    // END :: 20/01/2016 NPAY-112 Payroll process changes in Payroll2. added by Farhan
	//Begin: Constructor
	public NewPayrollEmployeeController(apexPages.Standardcontroller stdController)
	{
		//Checking for a CRUD security
		DataSelector.isCreateable('xcdhcm__Employee_Detail__c');
        DataSelector.isCreateable('xcdhcm__Employer__c');
		DataSelector.isCreateable('xcdhcm__Personal__c');
		DataSelector.isAccessible('xcdhcm__Employee_Detail__c');
        DataSelector.isAccessible('xcdhcm__Employer__c');
		DataSelector.isAccessible('xcdhcm__Personal__c');
		DataSelector.isUpdateable('xcdhcm__Employee_Detail__c');
        DataSelector.isUpdateable('xcdhcm__Employer__c');
		DataSelector.isUpdateable('xcdhcm__Personal__c');
        
        string soql;
        empDetail = (Employee_Detail__c)stdController.getRecord();
        
        try
        {
        	//BEGIN : Geting the Employer record 
            if(empDetail.Company__c!=null)
            {
            	String fieldsAPIname = DataSelector.getObjectFields('xcdhcm__Employer__c');
            	if(empDetail.Company__r.Parent_Company__c == null)
            	{
              		soql = 'Select '+fieldsAPIname+' from Employer__c where Company__c=\''+String.escapeSingleQuotes(empDetail.Company__c)+'\'limit 1';
            	}
            	else
            	{
            		soql = 'Select '+fieldsAPIname+' from Employer__c where Company__c=\''+String.escapeSingleQuotes(empDetail.Company__r.Parent_Company__c)+'\'limit 1';
            	}
              //soql = 'Select '+fieldsAPIname+' from Employer__c where Company__c=\''+String.escapeSingleQuotes(empDetail.Company__r.Parent_Company__c)+'\'limit 1';
                list<Employer__c> employerList = new list<Employer__c>();
                employerList = Database.query(soql);
                
                if(!employerList.isEmpty())
                {
                	employer = employerList.get(0);
                }
            }
            //END : Geting the Employer record
            
            //BEGIN : Geting the personal record 
            List<Personal__c> PersonalValsTempList = EmployeeService.getPersonal(empDetail.id);
            
            if(!PersonalValsTempList.isEmpty())
            {  
                for(Personal__c per:PersonalValsTempList) 
                {	
                    personal=per; 
                    personal.P45_previous_employer__c = true;
                    //START :: 09/08/2018 NPAY-524 Payroll Setup Improvements added by Farhan
                    //Payment method default value should be BACS. Since we have a validation rule on the personal object(BACS requires account details), we can not set BACS as default value in the field level. 
                    if(personal.Payment_method__c == null)
                    {
                    	personal.Payment_method__c = 'BACS';
                    }
                    //END :: 09/08/2018 NPAY-524 Payroll Setup Improvements added by Farhan
                }
            }
            //END : Getting the personal record 
        }
        catch(Exception err)
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,err.getMessage()));
        }
    }
    //End: Constructor
    
    //Begin: Upserting Employee,Personal and Employer object record with new value.
    public pageReference saveEmpPayroll()
    {   
    	//START :: 09/08/2018 NPAY-524 Payroll Setup Improvements added by Farhan
    	//Check if the tax code is in the correct format. Copied below code from FetchPersonalDataService class
    	String taxCode = personal.Tax_code__c;
    	if(taxCode != null && (taxCode.startsWith('S') || taxCode.startsWith('s')))
		{
		    if(taxCode.startsWith('S'))
		    {
		        taxCode = taxCode.substringAfter('S');
		    }
		    else
		    {
		        taxCode = taxCode.substringAfter('s');
		    }			    
		}
		//START :: 12/12/2018 NPAY-665 RTI Annual Update 2019/20 added/modified by Tutu.
		else if(taxCode.startsWith('C') || taxCode.startsWith('c'))
		{
		    if(taxCode.startsWith('C'))
		    {
		        taxCode = taxCode.substringAfter('C');
		    }
		    else
		    {
		        taxCode = taxCode.substringAfter('c');
		    }			    
		}
		//END :: 12/12/2018 NPAY-665 RTI Annual Update 2019/20 added/modified by Tutu.
		if(personal.Tax_code__c == null || !(Pattern.matches('([1-9][0-9]{0,5}[LMNPTY])|(BR)|(0T)|(NT)|(FT)|(D[01])|([K][1-9][0-9]{0,5})', taxCode)))
   		{
   			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.NewPayrollEmployeeEMTaxCodeValidation));
   			return null;
   		}
   		//END :: 09/08/2018 NPAY-524 Payroll Setup Improvements added by Farhan
        
        //Sort code should be in 11-22-33 format, Format the code if it is not in a required format.
        String sortCode = personal.P_Sort_code__c;
        Pattern sortCodePattern = Pattern.compile('^[0-9]{2}[-][0-9]{2}[-][0-9]{2}$');
        Matcher regMatcher = sortCodePattern.matcher(sortCode);
        //check if the sort code in not in XX-XX-XX format and if input is 6 digit numberic value.
        if(!regMatcher.matches() && Pattern.matches('\\d{6}?',sortCode))
        {
        	sortCode = sortCode.subString(0,2)+'-'+sortCode.subString(2,4)+'-'+sortCode.subString(4,6);
        	personal.P_Sort_code__c = sortCode;
        }
        //END :: 09/08/2018 NPAY-524 Payroll Setup Improvements added by Farhan
        //START :: 10/12/2018 NPAY-651 Postgraduate loan deductions modified by Shiva
        /*
        if(personal.Student_loan__c == true && LoanRepayOptionValue == 'None')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,+'Please select the value in the Student loan section'));
            return null;
        }
        */
        if(personal.Student_loan__c == true && finishedStudiesCheckbox== true && personal.Student_loan_plan__c == null && personal.Postgraduate_loan_plan__c == null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,+'Please select the Student and / or Postgraduate loan plan'));
            return null;
        }
        // END :: 19/3/2016 NPAY-116 payroll issue list modified by Farhan
        /*
        if( personal.Student_loan__c == false || LoanRepayOptionValue == 'Yes')
        {
            personal.Student_loan_plan__c='';   
        }
        */
        //END :: 10/12/2018 NPAY-651 Postgraduate loan deductions modified by Shiva
        // END :: 20/01/2016 NPAY-112 Payroll process changes in Payroll2. added by Farhan
        try
        {
            upsert personal;
            if(empDetail!=null)
            {
                upsert empDetail;
            }
            if(employer!=null)
            {
                upsert employer;
            }
            //START:: 08/06/2017 New Lightning UI Modified by Ranjeet
            //pageReference pageRef = new PageReference('/apex/Employee?id='+empDetail.id);
            String retURL = getRetURL('Save');
            PageReference pageRef = new PageReference(retURL);
            //END:: 08/06/2017 New Lightning UI Modified by Ranjeet
            pageRef.setRedirect(true);
            return ApexPages.hasMessages() ? null : pageRef;
        }
        catch(Exception err)
        {
            //START :: 29/01/2019 Regression issue winter2018 added by Shiva
        	if(err.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION,'))
        	{
        		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,err.getMessage().substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,').remove(': []')));
        	}
        	else
        	{
        		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,err.getMessage()));
        	}
            //END :: 29/01/2019 Regression issue winter2018 added by shiva
            return null;
        }
    }
    //End: Upserting Employee,Personal and Employer object record with new value.
    
    //Begin: Upsert Employee,Personal and Employer object record with new value and redirecting to std attachment page.
    public pageReference saveAndAttachp45()
    {
    	//START :: 09/08/2018 NPAY-524 Payroll Setup Improvements added by Farhan
    	//Check if the tax code is in the correct format. Copied below code from FetchPersonalDataService class
    	String taxCode = personal.Tax_code__c;
    	if(taxCode != null && (taxCode.startsWith('S') || taxCode.startsWith('s')))
		{
		    if(taxCode.startsWith('S'))
		    {
		        taxCode = taxCode.substringAfter('S');
		    }
		    else
		    {
		        taxCode = taxCode.substringAfter('s');
		    }			    
		}
		if(personal.Tax_code__c == null || !(Pattern.matches('([1-9][0-9]{0,5}[LMNPTY])|(BR)|(0T)|(NT)|(FT)|(D[01])|([K][1-9][0-9]{0,5})', taxCode)))
   		{
   			Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.NewPayrollEmployeeEMTaxCodeValidation));
   			return null;
   		}
   		//END :: 09/08/2018 NPAY-524 Payroll Setup Improvements added by Farhan
   		//
        //Sort code should be in 11-22-33 format, Format the code if it is not in a required format.
        String sortCode = personal.P_Sort_code__c;
        Pattern sortCodePattern = Pattern.compile('^[0-9]{2}[-][0-9]{2}[-][0-9]{2}$'); 
        Matcher regMatcher = sortCodePattern.matcher(sortCode);
        //check if the sort code in not in XX-XX-XX format and if input is 6 digit numberic value.
        if(!regMatcher.matches() && Pattern.matches('\\d{6}?',sortCode))
        {
        	sortCode = sortCode.subString(0,2)+'-'+sortCode.subString(2,4)+'-'+sortCode.subString(4,6);
        	personal.P_Sort_code__c = sortCode;
        }
        //END :: 09/08/2018 NPAY-524 Payroll Setup Improvements added by Farhan
        //START :: 10/12/2018 NPAY-651 Postgraduate loan deductions modified by Shiva
        /*
        if(personal.Student_loan__c == true && LoanRepayOptionValue == 'None')
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,+'Please select the value in the Student loan section'));
            return null;
        }
        */
        if(personal.Student_loan__c == true && finishedStudiesCheckbox== true && personal.Student_loan_plan__c == null && personal.Postgraduate_loan_plan__c == null)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,+'Please select the Student and / or Postgraduate loan plan'));
            return null;
        }
        // END :: 19/3/2016 NPAY-116 payroll issue list modified by Farhan
        /*
        if( personal.Student_loan__c == false || LoanRepayOptionValue == 'Yes')
        {
            personal.Student_loan_plan__c='';   
        }
        */
        //END :: 10/12/2018 NPAY-651 Postgraduate loan deductions modified by Shiva
        // END :: 20/01/2016 NPAY-112 Payroll process changes in Payroll2. added by Farhan
        try
        {
            if(empDetail!=null)
            {
                upsert empDetail;
            }
            if(employer!=null)
            {
                upsert employer;
            }
            upsert personal;
            
            //START:: 08/06/2017 New Lightning UI Modified by Ranjeet
            //pageReference pageRef = new PageReference('/p/attach/NoteAttach?pid='+personal.id+'&retURL=/apex/employee?id='+empDetail.Id);
            String retURL = getRetURL('Save & attachment');
            //PageReference pageRef = new PageReference('/p/attach/NoteAttach?pid=' + personal.id + '&retURL=' + EncodingUtil.urlEncode(retURL, 'UTF-8'));       
            PageReference pageRef = new PageReference(retURL);
            //END:: 08/06/2017 New Lightning UI Modified by Ranjeet
            
            pageRef.setRedirect(true);     
            return ApexPages.hasMessages() ? null : pageRef;
        }
        catch(Exception err)
        {
            //START :: 29/01/2019 Regression issue winter2018 added by shiva
            if(err.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION,'))
        	{
        		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,err.getMessage().substringAfter('FIELD_CUSTOM_VALIDATION_EXCEPTION,').remove(': []')));
        	}
        	else
        	{
        		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,err.getMessage()));
        	}
            //END :: 29/01/2019 Regression issue winter2018 added by shiva
            return null;
        }
    }
    //End: Upsert Employee,Personal and Employer object record with new value and redirecting to std attachment page.
    //START :: 10/12/2018 NPAY-651 Postgraduate loan deductions modified by Shiva
    public PageReference finishedStudiesCheck()
    {
    	if(personal.Student_loan__c == true)
    	{
    		finishedStudiesCheckbox = true;
    	}
    	return null;
    }
    
    public PageReference showPopup()
    {
    	if(finishedStudiesCheckbox == false)
    	{
    		displayPopup = true;
    	}
    	return null;
    }
    
    public PageReference closePopup()
    {
    	displayPopup = false;
    	return null;
    }
    
    public PageReference popupClickOk()
    {
    	if(finishedStudiesCheckbox == false)
    	{
	    	personal.Student_loan_plan__c = '';
	        personal.Postgraduate_loan_plan__c = ''; 
	        personal.Student_loan__c = false;
	        displayPopup = false;  
    	}
        return null;
    }
    //END :: 10/12/2018 NPAY-651 Postgraduate loan deductions modified by Shiva
    //Begin: Aborting the operations.
    public pageReference CancelEmpPayroll()
    {
        //START:: 08/06/2017 New Lightning UI Modified by Ranjeet
        //pageReference pageRef = new PageReference('/apex/Employee?id='+empDetail.id);
        String retURL = getRetURL('Cancel');
        PageReference pageRef = new PageReference(retURL);
        //END:: 08/06/2017 New Lightning UI Modified by Ranjeet
        pageRef.setRedirect(true);
        return pageRef;
    }
    //End: Aborting the operations. 
    
    //START:: 08/06/2017 New Lightning UI Added by Ranjeet
    public String getRetURL(String actionType)
    {
        String parentPage = ApexPages.currentPage().getParameters().get('parentPage');
        String permissionLevel = ApexPages.currentPage().getParameters().get('permissionLevel');
        String tab = ApexPages.currentPage().getParameters().get('tab');
        
        /*
        if(parentPage == null)
        {
            if(permissionLevel == 'AdminView')
            {
                parentPage = 'AdminView';
            }
            else if(permissionLevel == 'ManagerView')
            {
                parentPage = 'EmployeeManagerView';
            }
            else
            {
                parentPage = 'Employee';
            }
        }*/
        
        String url = null;
		if(parentPage != null && parentPage != 'null' && !parentPage.containsIgnoreCase('xcdhcm__'))
		{
			parentPage = 'xcdhcm__'+parentPage;
		}        
		//START :: 19/04/2018 NPPD-1635 CompanyNews performance Improvement added by Anil : The parent page name is changed from companyNewsLite to CompanyNews        
        if(parentPage != null && parentPage != 'null' && (parentPage.containsIgnoreCase('MyHRLite') || parentPage.containsIgnoreCase('CompanyNews')))
        {
            url = '/apex/' + parentPage;
            String hsID = ApexPages.currentPage().getParameters().get('hsID');
            if(hsID != null)
            {
                url += '?hsID=' + hsID;
            }
        }
        else
        {
        	//START :: 04/12/2018 NPPD-1815 Employee page loading issue modified by Anil
            url = '/lightning/cmp/xcdhcm__EmployeeView?'+prefix +'recordId=' + empDetail.Id;
            if(actionType == 'Save')
            {
            	url += '&'+prefix +'selectedTab=payroll';
            }
            else if(actionType == 'Cancel')
            {
            	url += '&'+prefix +'selectedTab='+tab;
            }
            //END :: 04/12/2018 NPPD-1815 Employee page loading issue modified by Anil
            //Save & attach document
            else
            {
            	url = '/apex/xcdhcm__PrivateAttachment?empid=' + empDetail.id + '&pid=' + personal.id + '&isPrivate=No&empTab=payroll';
            }
            if(parentPage != null && parentPage != 'null')
            {
            	url += '&parentPage=' + parentPage;
            }
			if(permissionLevel != null && permissionLevel != 'null')
            {
            	url += '&permissionLevel=' + permissionLevel;
            }
        }
        return url;     

    } 
	
    public void newMethods(Integer param){
      param=5;
    }
    
    public void newMethods2(Integer param){
      param=5;
    }
    public void newMethods3(Integer param){
      param=5;
    }
    //END:: 08/06/2017 New Lightning UI Added by Ranjeet
    
}
