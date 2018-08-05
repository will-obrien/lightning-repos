##Build A Button Component
#### What You'll do:

* Build reusable Lightning component buttons, adding JavaScript handlers and passing data.
* Basic button that has an icon used in SLDS looks like below. You'll build a **button** component to render it.


	```
	<button class="slds-button slds-button--neutral">
	  <svg aria-hidden="true" class="slds-icon slds-icon-text-default">
	    <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#account"></use>
	  </svg>
	  Details
	</button>
	```


Building a button component is very easy but to make it reusable, we need to map it's properties like label, icons, JavaScript handlers etc. to Lightning Component attributes and add some JavaScript code.

##Step 1: Create Component Markup
If you look the button markup above, it has an SVG icon embedded inside it. Button itself has **css** ("slds-button slds-button--neutral"), and **label** (**Details**) attributes that can change. **SVG** itself needs at least two more attributes (**xlink:href and class**). We just need to map all 4 attributes just like we did earlier.



Let's get started:

1. In Developer Console, Click on **New > Lightning Components**.
2. Add **button** as the name and **Save**.
3. Click on the **COMPONENT** button on the right-hand panel.
4. Replace everything with the following code:
	
	```
	<aura:component>
	     <!-- Attributes for the button -->
	    <aura:attribute name="label" type="String" description="This is the button label"/>
	    <aura:attribute name="class" type="String" description="SLDS class"/>
	
	    <!-- Attributes for SVG -->
		<aura:attribute name="svgXlinkHref" type="String" description="svgIcon's xlink-href"/>
	    <aura:attribute name="svgClass" type="String" description="svgIcon CSS classname"/>
	
		<button class="{!v.class}"><c:svg xlinkHref="{!v.svgXlinkHref}" class="{!v.svgClass}"  />{!v.label}</button>
	</aura:component>
	```
5. Save it.

##Step 2: Add JavaScript onClick Handler And Data Attribute
Button is useless if it doesn't do anything when we click. So, we need to add a JavaScript handler for the **onclick** attribute. To do that we need to add a component attribute of type **Aura.Action**
```
<aura:attribute name="onclick" type="Aura.Action" default="{!c.myAction}" description="This allows handling onClick events"/>
```

We'll need to add a **data** attribute to the button to allow us to pass small amounts of data (like Ids) via HTML5 data attributes. We'll use this feature in the next section.
```
<aura:attribute name="data" type="String" description="Any data to be passed via html5 data- attribute"/>
```

And finally we'll need to update the button's markup to use both **(onclick="{!v.onclick}" and data-data="{!v.data}")** attributes.

**Follow the steps below to add them:**

1. Replace everything with the following code:

	```
	<aura:component>
	     <!-- Attributes for the button -->
	    <aura:attribute name="label" type="String" description="This is the button label"/>
	    <aura:attribute name="class" type="String" description="SLDS class"/>
	    <aura:attribute name="onclick" type="Aura.Action" default="{!c.myAction}" description="This allows handling onClick events"/>
	   <aura:attribute name="data" type="String" description="Any data to be passed via html5 data- attribute"/>

	
	    <!-- Attributes for SVG -->
		<aura:attribute name="svgXlinkHref" type="String" description="svgIcon's xlink-href"/>
	    <aura:attribute name="svgClass" type="String" description="svgIcon CSS classname"/>
	
		<button class="{!v.class}"  onclick="{!v.onclick}" data-data="{!v.data}"><c:svg xlinkHref="{!v.svgXlinkHref}" class="{!v.svgClass}" />{!v.label}</button>
	</aura:component>
	```
2. Save it.
3. Click on the **CONTROLLER** button on the right-hand panel. 
	
	**Note:** This 3rd step is required to create a dummy JavaScript Controller with **myAction** function. We won't be using this function, but this will ignore any clicks (and avoids errors) if the application doesn't pass a handler.

##Step 3: Test the Button Component
1. Go back to the **AllAccounts.app** tab in Developer Console.
2. Replace all the code with the one below. 

	```
	<aura:application>	
	<div class="slds" style="margin-top:10px;margin-left:10px;">
		<ltng:require styles="/resource/slds080/assets/styles/salesforce-lightning-design-system-vf.css" />
        <c:button class="slds-button slds-button--neutral" 
                     label="Details" 
                     svgXlinkHref="/resource/slds080/assets/icons/standard-sprite/svg/symbols.svg#account" 
                     svgClass="slds-icon slds-icon-text-default"
                     onclick="{!c.showDetails}"
        />
	</div>
</aura:application>
```
3. Notice that we have **onclick="{!c.showDetails}"** as one of the attributes above. That tells the component to call a JavaScript controller. Let's add the controller function.
4. Click on the **CONTROLLER** button on the right hand panel.
5. Replace all the code with the one below:

	```
	({
		showDetails : function(component, event, helper) {
			alert("showing Details")
		}
	})
	``` 
6. Click on the button.
7. You'll see:

<image src="images/buttonWithAlert.png" />
