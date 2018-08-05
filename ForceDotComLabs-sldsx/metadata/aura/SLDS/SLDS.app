<aura:application access="GLOBAL">
  <ltng:require styles="/resource/slds/assets/styles/salesforce-lightning-design-system-ltng.css"/>
  <div class="slds">
    <sldsx:grid class="topHeader" wrap="true">
      <sldsx:col lgSize="1-of-12" mdSize="1-of-12" size="1-of-1">
        <img label="logo" size="large" src="https://developer.salesforce.com/resource/images/salesforce-developer-network-logo_1.png"/>
      </sldsx:col>
      <sldsx:col lgSize="10-of-12" mdSize="10-of-12" size="1-of-1">
        <h1 class="slds-text-heading--large slds-truncate">Salesforce Lightning Design System</h1>
      </sldsx:col>
    </sldsx:grid>
    <sldsx:grid style="margin-right:100px" wrap="true">
      <sldsx:col class="sidebar" lgSize="2-of-12" mdSize="2-of-12" size="1-of-1">

        <sldsx:list direction="block">
          <sldsx:listItem itemClass="item">
            <a data-href="#breadCrumbs" onclick="{!c.scroll}">Bread Crumbs</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#buttonGroups" onclick="{!c.scroll}">Button Groups</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#buttons" onclick="{!c.scroll}">Buttons</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#gridSystem" onclick="{!c.scroll}">Grid System</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#images" onclick="{!c.scroll}">Images</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#badges" onclick="{!c.scroll}">Badges</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#lists" onclick="{!c.scroll}">Lists</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#mediaObjects" onclick="{!c.scroll}">Media Objects</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#pills" onclick="{!c.scroll}">Pills</a>
          </sldsx:listItem>
          <sldsx:listItem itemClass="item">
            <a data-href="#tabs" onclick="{!c.scroll}">Tabs</a>
          </sldsx:listItem>
        </sldsx:list>
      </sldsx:col>
      <sldsx:col lgSize="10-of-12" mdSize="10-of-12" size="1-of-1">
        <sldsx:docHeader anchorName="breadCrumbs" name="Bread Crumbs" top="false"/>
        <sldsx:breadCrumbsDoc/>
        <a name="buttonGroups"></a>
        <sldsx:docHeader anchorName="buttonGroups" name="Button Groups"/>
        <sldsx:buttonGroupsDoc/>
        <sldsx:docHeader anchorName="buttons" name="Buttons"/>
        <sldsx:buttonsDoc/>
        <sldsx:docHeader anchorName="gridSystem" name="Grid System"/>
        <sldsx:gridDoc/>
        <sldsx:docHeader anchorName="images" name="Images"/>
        <sldsx:imagesDoc/>
        <sldsx:docHeader anchorName="badges" name="Labels"/>
        <sldsx:badgesDoc/>
        <sldsx:docHeader anchorName="lists" name="Lists"/>
        <sldsx:listsDoc/>
        <sldsx:docHeader anchorName="mediaObjects" name="Media Objects"/>
        <sldsx:mediaObjectsDoc/>
        <sldsx:docHeader anchorName="pills" name="Pills"/>
        <sldsx:pillsDoc/>
        <sldsx:docHeader anchorName="tabs" name="Tabs"/>
        <sldsx:tabsDoc/>
      </sldsx:col>
    </sldsx:grid>
  </div>
</aura:application>