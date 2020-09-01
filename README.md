# `CTHelp_SwiftUI`

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)[![](http://img.shields.io/badge/language-SwiftUI-brightgreen.svg?color=orange)](https://developer.apple.com/swiftui)![](https://img.shields.io/github/tag/stewartlynch/CTHelp_SwiftUI?style=flat)![](https://img.shields.io/github/last-commit/StewartLynch/CTHelp_SwiftUI)

### What is this?

![CTHelp_SwiftUI](ReadMeImages/ScreenShot.png)

**CTHelp** is a customizable drop in Help solution.  Each one of your screen views can have its own set of 'help cards'.  You can also optionally include a card that links to your web site and one that will initiate an email to to whichever address you specify.

### Requirements

- iOS 14.0+
- SwiftUI
- Xcode 12.0+
### YouTube Video

For a detailed walkthrough of implementing CTHelp into a project, please watch this video. The instructions are outlined below and can be used as a future reference.

**Video coming soon**

##### Step 1 - Install CTHelp_SwiftUI using Swift Package Manager

1. From within Xcode 12 or later, choose **File > Swift Packages > Add Package Dependency**
2. At the next screen enter https://github.com/StewartLynch/CTHelp_SwiftUI when asked to choose a Package repository
3. Choose the latest available version.
4. Add the package to your target.

##### Step 2 - Create the Builder File

You can create a set of CTHelp cards for every different view.  To help you manage that content, it is highly recommended that you follow these suggestions here.

    1. Create a Helper File and enum

* Create a new helper swift file.  You can give it any name, but I call mine **CTHelpBuilder**
* change the import to *Import UIKit*
* Add `import CTHelp`
* Create an enum or struct called `CTHelpBuilder`

````swift
import UIKit
import CTHelp

enum CTHelpBuilder {
    
}
````

2. **Inside** this enum, create another enum called Page and create a case for each of the views for which you will be creating set of help cards.  For example, you may have two views; ContentView and DetailView.  In that case, I would create an enum like this:

````swift
enum Page {
  case contentView
  case detailView
}
````

3. Create a **static** function caled `getHelpItems`  that wll accept a `Page` as an argument and will return a `CTHelp` object.

````swift
static func getHelpItems(page: Page) -> CTHelp {
        
}
````

4. In the body of the function create a constant for the ctHelp object then create a switch block for each of the page enum.

````swift
static func getHelpItems(page: Page) -> CTHelp {
    let ctHelp = CTHelp()

    switch page {
    case .contentView:
        // create your CTHelpItems for this associated view
    case .detailView:
        // create your CTHelpItems for this associated view
    }
      return ctHelp
}
````

##### Step 3 - Create the CTHelpItems for each page

With the builder page created, each of the switch blocks are where you create your array of CTHelpItem cards.  A CThelpItem has 3 `String` properties; `title`, `helpText`and `imageName`

* If `imageName`is left as an empty string. no image will appear on the card.  If the string is not empty, there **must** be an image in your asset catalog with that name.

  * **Note:** Images must be created with dimensions that will fit within the help card.  The default dimensions of the card are 300 X 285.  See below regarding changing those dimensions.

    The images will **NOT** scale and will exceed the boundaries of the card if they are too large.

    The `helpText` field will scroll, but the maximum height for your image should only be used if you have no helpText otherwise the helpText may not be visible.

* If ` helpText`is an empty string, the assumption is that there is only an image so it should be designed accordingly.  if `helpText` is particularly long, it will scroll within the available space in the card.

* You can use Swift's multi-line strings, surrounding your text with triple quotes to create line breaks.

You use the CTHelp **new** function to add a CTItem to the array of cards.  Here is an example showing how the three different types of cards can be created within a case block and the image displays the final result.

![CTHelp_SwiftUI](ReadMeImages/SampleScreens.png)

````swift
case .contentView:
        // Card 1 is a card with only an image, no text
        ctHelp.new(CTHelpItem(title:"My Books",
                              helpText: "",
                              imageName:"MyBooksLogo"))

        // Card 2 is a card with no image and text only
        ctHelp.new(CTHelpItem(title:"List of books",
                              helpText: """
                    This screen shows a list of all of the books that you have read.
                    As you read more books you read more books you can add to this list.
                    You can also remove books from the list as well.  See the other help screens here for more information.
                    """,
                              imageName:""))

        // card 3 has an image and text
        ctHelp.new(CTHelpItem(title:"Adding a Book",
                              helpText: """
                    To add a book to your collection, tap on the '+' button on the navigation bar. To be taken to the add screen.
                    """,
                              imageName:"AddPlus"))

````

There are more options available for cards and customization that are covered later below.  But before you do that, you should test by implementing CTHelp on your views.

##### Step 4 - Create your instance variables

WIthin your parent screen view's struct, before the body,

1. Create an instance of CTHelp that will call the static getHelpItesms function using the corresponding Page enum value as an argument

````swift
let ctHelp = CTHelpBuilder.getHelpItems(page: .contentView)
````

2. Create a @State variable that will be toggled whenever you want to show or dismiss CTHelp

```swift
@State private var showCTHelp = false
```

##### Step 5 - Create a button with an action that will Toggle the showHelp state

Create a button that will toggle the state variable.  

This is often placed inside a **toolbar** as a **ToolbarItem**.  In my example, I am using a system image and since we also want the transition to the help screen to be smooth, embed the action body within a `withAnimation` block,

```swift
.toolbar {
    ToolbarItem {
        Button(action: {
            withAnimation {
                showCTHelp = true
            }
        }){
            Image(systemName: "questionmark.circle.fill")
                .font(.title)
        }
    }
}
```

##### Step 6 - Embed screen view in ZStack

CTHelp will be displayed as an overlay view on top of your existing screen views.  This is done when the **showCTHelp** value is set to true.

To enable this, you must embed your current set of screens view (in my case the List inside of the NavigationView) inside a **ZStack**. 

**NOTE**: Place the ZStack **inside** any NavigationView if you have one.

**Hint:**  To do this easily select your content and Command-Click and choose Embed in HStack (or VStack as there is no option to choose ZStack) then change it to a ZStack.

<img src="ReadMeImages/Embed.gif" alt="Embed" style="zoom:80%;" />

##### Step 7 - Add Conditional CTHelpView

As the last view of the **ZStack** (before the closing ZStack bracket), add the code to call the chHelp `showCTHelpScreens` function, passing in the binding to the `$showCTHelp` state variable and your instance of `ctHelp` as arguments

This will conditionally overlay your help cards only when the `showCTHelp` variable is set to true.

```swift
 // Last item in parent ZStack
if showCTHelp {
    ctHelp.showCTHelpScreens(isPresented: $showCTHelp, ctHelp: ctHelp)
}
```

##### Step 8 - Test

If you run your app now, you will have a fully functional implementation of CTHelp.

Repeat steps 4-7 for each of your views that will present a set of CTHelp Cards

## Optional Cards

##### Optional Cards appendDefaults()

There are 2 optional cards that may be included by calling the `appendDefaults` function to your instance of `CTHelp`.  

This function takes 5 parameters; `companyName` (String), `emailAddress` (String), `data` (data), `website` (String) and `companyImageName` (String)

###### Email Card

If you assign a non **nil** value to `emailAddress`, a new card will be created and presented, asking the users if he/she wishes to contact the developer. The email address specified will be the address to which the email is sent. 

If, prior to calling the `appendDefaults` function, you gather data for your application and assign it to a Data() object, you can assign that to the `data` parameter. If this parameter not **nil**, the user will also be asked if he/she would like to attach application data to the email.

###### Website Card

If you assign a non **nil** value to `webSite`, a card is displayed with an image using the name specified in `companyImageName` along with some text that asks the user to click on a button that will take the user to the company website defined in the `webSite` address. The image you use must be available as one of your assets.

If you do not wish to include a website card, assign **nil** to each of the three strings.

Here is an example displaying both cards after gathering data.

`ctHelp.appendDefaults` should be added at the end of your card creation function

```swift
// This gathers data from the application and encodes it as a JSON String
let books = BooksViewModel.retrieveBooks()
let encoder = JSONEncoder()
guard let bookData = try? encoder.encode(books) else {
    fatalError("Unable to encode data")
}
ctHelp.appendDefaults(companyName: "CreaTECH Solutions",
                      emailAddress: "books@createchsol.com",
                      data: bookData,
                      webSite: "https://www.createchsol.com",
                      companyImageName: "CreaTech")
```

**Note:** 

* If you are going to include these two cards on every screen, add the appendDefaults function **after** the switch block in your  **getHelpItems** function in **CTHelpBuilder** file, but **before** the return of `cthelp`

* If you wish to have different options presented for each screen, add the function as the last item in each case block

Test again and you will see the additional cards added to your help screens.

### Optional Arguments

As mentioned above there are two additional optional arguments that you can use when creating your instance of `CTHelp`.  

#### Custom Strings

All of the strings used in CTHelp are fully customizable and **all are optional** so you do not need to change every one of them.  To customize the strings, just create a new instance of  a `CTString` and povide a string value for one or more of the optional parameters.  For your reference, the example shown below duplicates the default strings used.

**Note:** in the example below **app name** and **company name** are just placeholders that, when using the default strings, will be replaced by the values provided by your application.  If you are replacing these strings, you must used the real values in your strings.

```swift
let myCTStrings = CTString(contactTitle: "Contact Developer",
                        contactButtonTitle: "Contact Developer",
                        webButtonTitle: "Visit Web Site",
                        dataAlertTitle: "Attach application data",
                        dataAlertMessage: "Would you like to attach your application data to this message to assist the developer in troubleshooting?",
                        dataAlertActionNo: "No",
                        dataAlertActionYes: "Yes",
                        emailSubject: "**app name** Issue",
                        emailBody:  "Please describe the issue you are having in as much detail as possible:",
                        emailAttachNote: "<b>Note:</b>**app Name** data is attached.",
                        contactHelpText: "**company name** would very much like to assist you if you are having issues with **app name**. Please tap button below to initiate an email to the developer.",
                        includeDataText: "  If you agree, your data will be compiled and sent to the developer for analysis.",
                        webHelpText: "**app name** is created by **company name**.  Please visit our website for more information about our company.")
         
```

**Note:** The instance of CTString and the assignment to your instance of cCTHelp must come **before you call the append function**, so create it **before your switch block** in your **getHelpItems** function in **CTHelpBuilder**

You can also just declare an instance of CTString and add in only the strings you wish to change like this:

```swift
let myCTStrings = CTString()
myCTStrings.contactTitle = "Bug Report"
myCTStrings.contactHelpText = "Please help us improve this application by submitting your bug reports."
```

Now you can pass this set of strings within your `createCTHelpItems` function

```swift
ctHelp.ctString = myCTStrings
```

#### Custom Colors

CTHelp's default colors are **all optional** and  are compatible with and support dark mode in iOS 13.. This is important to note as you will want to ensure that any custom colors you use have both a light and dark asset available.

To customize the colors, just create a new instance of  a `CTColors` and complete one or more of the optional parameters.  For your reference, the example shown below duplicates the default strings used.

```swift
let myCTColors = CTColors(bgViewColor: UIColor.systemBackground,
                    helpTextColor: UIColor.label,
                    titleColor: UIColor.label,
                    actionButtonBGColor: UIColor.systemBlue,
                    actionButtonTextColor: UIColor.white,
                    closeButtonBGColor: UIColor.systemGray
 )
```

Now you can pass this set of colors within your `createCTHelpItems` function

```swift
ctHelp.ctColors = myCTColors
```

**Note:** The instance of CTColors and the assignment to your instance of CTHelp must come **before you call the append function**, so create it **before your switch block** in your **getHelpItems** function in **CTHelpBuilder**

You can also just declare an instance of CTColors and add in only the colors you wish to change like this:

```swift
let myCTColors = CTColors()
myCTColors.titleColor = .red
myCTColors.helpTextColor = UIColor.darkGray
```

### Dimensions

By Default, the dimensions of the help card are width: 300 and height: 285.

You can change this when you create your CTHelp.

For example, if you have tall images or lengthy help text, you may wish to adjust the height.  

**Note:** Make sure you test your adjusted dimensions on all devices in both portrait and landscape mode as well as in split mode on an iPad or regular width class size on iOS.

````swift
ctHelp.height = 400
ctHelp.width = 200
````

**Note:** You must make sure that your image widths are less than the width for your card and you can set one or both of these options within your  **getHelpItems** function in **CTHelpBuilder** prior to the return statement.



### Feedback invited

CTHelp is open source and your feedback for improvements and enhancements is invited.

Please feel free to contact me at slynch@createchsol.com
