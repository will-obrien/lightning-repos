##Build The AccountsList Component
#### What You'll do:

* Build a component that gets a list of accounts from the server
* Display a SLDS table to show the accounts.
* Use the **button** and **svg** components we built earlier in the list in each row of the table

##Step 1: Write an Apex Controller
Let's create a simple Apex class that returns a list of Account.

1. In Developer console, Click on **New > Create Apex Class**
2. Enter **AccountsController** as the name of the class.
3. Paste the below code

	```
	public class AccountsController {
	  @AuraEnabled
	  public static List<Account> getAccounts() {
	    return [SELECT Id, name, industry, Type, NumberOfEmployees, TickerSymbol, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode 
	            FROM Account ORDER BY createdDate ASC];
	  }   
	}
	```	

3. Save

##Step 2: Create the AccountsList Component
Lets now display the list of accounts by calling the **AccountsController** class we just created. We'll also show a **Details** button in each row. We'll also store the account record's id as the data (**data="{!account.Id}"**) so that we can see which account's detail button was clicked.


1. In Developer console, Click on **New > Lightning Components**.
2. Enter **AccountsList** as the name.
3. Paste the code below:
	
	```
	<aura:component controller="AccountsController">
	  <aura:attribute name="accounts" type="List" />
	  <aura:handler name="init" value="{!this}" action="{!c.doInit}" />
	  <!-- Use the Apex model and controller to fetch server side data -->
	  <table class="slds-table slds-table--bordered slds-table--striped">
	      <thead>
	        <tr>
				<th scope="col"><span class="slds-truncate">ID</span></th>
	          	<th scope="col"><span class="slds-truncate">Name</span></th>
	          	<th scope="col"><span class="slds-truncate">Type</span></th>
	          	<th scope="col"><span class="slds-truncate">Number Of Employees</span></th>
	          	<th scope="col"><span class="slds-truncate">Ticker Symbol</span></th>
	          	<th scope="col"><span class="slds-truncate">Phone</span></th>
	          	<th scope="col"><span class="slds-truncate">Details</span></th>  
	        </tr>
	      </thead>
	      <tbody>
	      <aura:iteration items="{!v.accounts}" var="account">
	       <tr>
	         <td>{!account.Id}</td>
	         <td>{!account.Name}</td>                 
	         <td>{!account.Type}</td>
	         <td>{!account.NumberOfEmployees}</td>                 
	         <td>{!account.TickerSymbol}</td>
	         <td>{!account.Phone}</td>
	         <td>
	            <c:button class="slds-button slds-button--neutral" 
	                 label="Details" 
	                 svgXlinkHref="/resource/slds080/assets/icons/standard-sprite/svg/symbols.svg#account" 
	                 svgClass="slds-icon slds-icon-text-default"
	                 onclick="{!c.showDetails}"
	                 data="{!account.Id}"
	    		/>
	          </td>
	       </tr>
	     </aura:iteration>
	   </tbody>
	 </table>
	</aura:component>
	```
4. Save the changes.

##Step 3: Create the JavaScript Controller
We'll now create a couple of JavaScript functions to fetch the list of accounts from the Apex controller.

1. Click on **CONTROLLER** on the right-hand panel.
2. Paste the code below
	
	```
	({
	     doInit : function(component, event, helper) {      
	        //Fetch the expense list from the Apex controller   
	        helper.getAccountList(component);
	    },
	    showDetails: function(component, event, helper) {
	        //Get data via "data-data" attribute
	        alert(event.target.getAttribute("data-data") + " was passed");
	    }
	})
	```
3. Save the changes.

##Step 4: Create a JavaScript Helper
A Helper is used to interact with the server.

1. Click on **HELPER** on the right-hand panel.
2. Paste the code below:

	```
	({
	     //Fetch the accounts from the Apex controller
	    getAccountList: function(component) {
	        var action = component.get("c.getAccounts");
	
	        //Set up the callback
	        var self = this;
	        action.setCallback(this, function(actionResult) {
	            component.set("v.accounts", actionResult.getReturnValue());            
	        });
	        $A.enqueueAction(action);
	    }   
	})
	```
3. Save the changes.

##Step 5:  Test it
1. Go back to the **AllAccounts.app** tab in the Developer Console.
2. Replace all the code with the one below
	```
	<aura:application>	
		<div class="slds" style="margin-top:10px;margin-left:10px;">
			<ltng:require styles="/resource/slds080/assets/styles/salesforce-lightning-design-system-vf.css" />
	        <c:AccountsList />
		</div>
	</aura:application>
	``` 
3. Click on any **details** button.
4. You should see:

<image src="images/accountsListWithAccounidAlert.png" />

Normally this button would take us to the Accounts Details page but that's beyond the scope of the this workshop due to time constraints and so we'll settle for displaying the Id to show it's done. 

##Summary
Using SLDS in Lightning Components is really easy and it makes components look beautiful and similar to Lightning Experience. Just to summarize, here are the things you did in this workshop:

1. You added SLDS as a static resource and loaded it using **ltng:require** component
2. You used a **&lt;div class="slds"&gt;** to wrap all your components to prevent CSS from affecting other non-SLDS components
3. You divided your application into four components
4. You wrote a wrapper **AllAccounts.app** and used it as a placeholder for other components, then built the innermost component (**svg**)first and eventally the outermost component (**AccountsList**)
5. You learnt how to map SLDS properties to Lightning Component attributes to create reusable components
6. You learnt about **render**, **Aura.Action** 
7. You also learnt how to pass small data via **data-*** attributes

##Resources
* <a target="_blank" href="https://developer.salesforce.com/trailhead/module/lightning_design_system">Salesforce Design System Module</a>
* <a target="_blank" href="https://developer.salesforce.com/trailhead/module/lightning_components">Lightning Components Module</a>
* You can find an open source project with more sample components <a href="https://github.com/ForceDotComLabs/sldsx" target="_blank">here</a>
