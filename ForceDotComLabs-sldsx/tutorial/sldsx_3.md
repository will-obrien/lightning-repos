##Build the Lightning App

#### What You'll do
* Build an **AllAccounts** Lightning App.
* Load the SLDS framework.


##Step 1. Build the Lightning App
First, we'll build our 'container' app that holds all the components. We'll also load the CSS from our static resource using the standard **ltng:require** component. Finally, we will create a **div** with CSS class **slds** to prevent the CSS of the SLDS framework from affecting other components.

1. Click on **{your name} > Developer Console** on the top right corner of your Developer Edition.
2. Click on **File > New > Lightning Application**.
3. Enter **AllAccounts** in the **Name** field.
4. Replace all the code with the one below

	```
	<aura:application>
		<ltng:require styles="/resource/slds080/assets/styles/salesforce-lightning-design-system-vf.css" />
		<div class="slds">
	 		//This is where components will live
		</div>	
	</aura:application>
	```
5. Click **Save**.

**Note:** This assumes that the SLDS CSS framework is loaded in a static resource named **SLDS080**

##Resources
* You can find open-source sample components <a href="https://github.com/ForceDotComLabs/sldsx" target="_blank">here</a>
