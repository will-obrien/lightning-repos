({
	init : function(cmp, event, helper) {
        
        var name="$Resource." + cmp.get("v.imageName");
        cmp.set("v.imageSourceString", $A.get(name)); 
        helper.validateFlowNavigationInputs(cmp);
        
        var styleText = "";       
        styleText=styleText + "border-radius:" + cmp.get("v.styleBorderRadius") + ";";
        styleText=styleText + "border-style:" + cmp.get("v.styleBorderStyle") + ";";
        styleText=styleText + "border-width:" + cmp.get("v.styleBorderWidth") + ";";
		styleText=styleText + "border-color:" + cmp.get("v.styleBorderColor") + ";";
        
        styleText=styleText + "margin-top:" + cmp.get("v.styleMarginTop") + ";";
        styleText=styleText + "margin-right:" + cmp.get("v.styleMarginRight") + ";";
        styleText=styleText + "margin-bottom:" + cmp.get("v.styleMarginBottom") + ";";
        styleText=styleText + "margin-left:" + cmp.get("v.styleMarginLeft") + ";";
        styleText=styleText + "margin:" + cmp.get("v.styleMargin") + ";";
        
        styleText=styleText + "padding-top:" + cmp.get("v.stylePaddingTop") + ";";
        styleText=styleText + "padding-right:" + cmp.get("v.stylePaddingRight") + ";";
        styleText=styleText + "padding-bottom:" + cmp.get("v.stylePaddingBottom") + ";";
        styleText=styleText + "padding-left:" + cmp.get("v.stylePaddingLeft") + ";";      
        cmp.set("v.styleText", styleText);
        
        //normally the use of span elements instead of div elements in the markup
        //enables images to flow on the same screen.
        //sometimes, though, you want to use the entire width and do things like centering.
        //by setting this flag, the image span gets treated as a full-width block
        if(cmp.get("v.styleAsBlockFlag") == "true")
           styleText=styleText + "display:block;";
        
        styleText=styleText + "width:" + cmp.get("v.imageWidth") + ";height:" + cmp.get("v.imageHeight") + ";";
        cmp.set("v.styleText", styleText);
        
	},
    
    handleClick : function(cmp, event, helper) {
        helper.navigateFlow(cmp,helper);
    }
})