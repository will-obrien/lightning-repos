##Decompose The App Into Components
#### What You'll do

* Decompose the app into components.
* Learn the order in which to build the components.

##Step 1. Decompose The App
The first step of building an app in Lightning is to divide it into smaller components. In our app, we have the following components:

1. The App itself (it's also a component but with .app extension).
2. List Component.
3. Button Component.
4. Icon (SVG) Component.

<image src="images/allAccountsApp.png" />
##Step 2. Order Of Component Development
The general idea is to build a shell/dummy app that wraps all the components so that we can test other components inside it and then start building the smallest and the innermost components first and then build the outermost components later. 

We'll build components in the following order.

1. The App itself - This is the wrapper component.
2. Icon (SVG) Component - This is the innermost component.
3. Button Component.
4. List Component.
