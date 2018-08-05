##Build A Basic SVG Icon Component
#### What You'll do

* Learn about SVG icons.
* Build a **svg** Lightning Component.

```
<svg aria-hidden="true" class="slds-icon slds-icon--small slds-icon-text-default">
    <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#announcement"></use>
</svg>
```



SVG icons are vector based images that can scale irrespective of the display size without becoming pixelated. So a single svg image can be used in devices of various sizes and resolution. Hence they are highly desired. Lightning Design System uses them extensively for all the icons in the framework. 

However, the Lightning Components framework does not directly support SVG icons at this point. So we need to do some work to use them. Instead of doing this work everywhere we use SVG images, we'll build a component called **svg** that we can reuse everywhere.



##Step 1: Create Component Markup
The **svg** tag has 3 attributes: **(aria-hidden, class and xlink:href)** that can change. In this step we'll simply map all three to three corresponding Lightning Component attributes.


Let's create an **svg** component and map the attributes.

1. In Developer Console, Click on **New > Lightning Components**.
2. Enter **svg** as component name.
3. Click on **COMPONENT** tab on the right if it's not open.
4. Copy and paste the code below:

	```
	<aura:component>
	    <aura:attribute name="class" type="String" description="CSS classname for the SVG element" />
	    <aura:attribute name="xlinkHref" type="String" description="SLDS icon path. Ex: /assets/icons/utility-sprite/svg/symbols.svg#download" />
	    <aura:attribute name="ariaHidden" type="String" default="true" description="aria-hidden true or false. defaults to true" />
	</aura:component>
	```
5. Save it.

##Step 2: Update renderer
The Lightning Components framework, as part of the component creation, calls a function called **render** to get DOM elements for the component being created. This is called before it renders the component itself. So we can override the **render** function to create our SVG element with all the attributes and simply return it as the DOM element for our component!

1. Click on **RENDERER** in the right hand pane.
2. Copy and paste the following code:

	```
	({
	    render: function(component, helper) {
	        //grab attributes from the component markup
	        var classname = component.get("v.class");
	        var xlinkhref = component.get("v.xlinkHref");
	        var ariaHidden = component.get("v.ariaHidden");
	        
	        //return an svg element w/ the attributes
	        var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
	        svg.setAttribute('class', classname);
	        svg.setAttribute('aria-hidden', ariaHidden);
	        svg.innerHTML = '<use xlink:href="'+xlinkhref+'"></use>';
	        return svg;
	    }
	})
	```
3. Save the changes.

##Step 3: Let's Test The SVG component
Let's see if we can show an **Account** icon. The raw SLDS markup for the account icon can be found <a href="https://www.lightningdesignsystem.com/components/icons#base&role=regular&status=all" target="_blank">here</a>. Only thing that's different is the **<c:svg...** line

1. Click on **AllAccounts.app**.
2. Copy and past the following code:

	```
	<aura:application>	
		<div class="slds" style="margin-top:10px;margin-left:10px;">
			<ltng:require styles="/resource/slds080/assets/styles/salesforce-lightning-design-system-vf.css" />
			<span class="slds-icon__container slds-icon-standard-account">
				<c:svg class="slds-icon" xlinkHref="/resource/slds080/assets/icons/standard-sprite/svg/symbols.svg#account" />
				<span class="slds-assistive-text">Account Icon</span>
			</span>
		</div>
	</aura:application>
	```
3. Save the changes.
4. Press **Update Preview**.
5. You should see the icon like below:

<image src="images/accountIcon.png" />
