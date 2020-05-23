# Calorie Tracker

Going to have to resubmit- I built the application in swiftUI instead of swift. 

## Instructions

**Please read this entire README to make sure you understand what is expected of you before you begin.**

This sprint challenge is designed to ensure that you are competent with the concepts taught throughout Sprint 9, Modularity.

Begin by forking this repository. Clone your forked repository to your machine. There is no starter project. Create a project for this challenge in this repository and commit as appropriate while you work. Push your final project to GitHub, then create a pull request back to this original repository.

**You will have 3 hours to complete this sprint challenge**

If you have any questions about the project requirements or expectations, ask your PM or instructor. Good luck!

## Screen Recording

Please view the screen recordings so you will know what your finished project should look like:

![](https://user-images.githubusercontent.com/16965587/45868114-3afdc180-bd42-11e8-8f0a-94378dd56d61.gif)

(The gif is fairly large in size. It may take a few seconds for it to appear)

## Requirements

The goal of this sprint challenge is to create a calorie tracking app. The app will allow you to enter in the calories that the user takes in every day and will create a chart to show them their calorie intake trends.

The requirements for this project are as follows:

1. A table view that will display a list of calorie intakes.
2. Persist the user's calorie intakes using Core Data.
3. Use the [SwiftChart](https://github.com/gpbl/SwiftChart#whats-included-in-swiftchart) library, chart the user's calorie intake per day. 
    1. There can be issues building the latest release of a dependency like Cocoapods. 
    2. Read the [Xcode 10 and Swift 4.2 fix Pull Request](https://github.com/gpbl/SwiftChart/pull/105)
    3. To fix a Swift 5 issue, make sure you update your Podfile to use the [bugfix for issue #112](https://github.com/gpbl/SwiftChart/issues/112)
    
        ```
        pod "SwiftChart", :git => 'https://github.com/gpbl/SwiftChart', :branch => 'master'
        ```
        
    4. IMPORTANT: You shouldn't make local source changes to a Cocoapod (don't unlock files), otherwise someone else who tries to `pod install` won't be able to build your project.    
4. Enforce code style with the [SwiftLint](https://github.com/realm/SwiftLint) tool as a "Run Script Phase" (Install with Homebrew)
    1. To exclude your "Pods" folder you may need to copy the ".swiftlint.yml" file from your top-level directory into your subdirectory in Terminal, otherwise you'll see code style errors about SwiftChart. 
  
        ```bash
        cp .swiftlint.yml CalorieTracker/.
        ```
  
    2. Fix any errors and warnings in your code based on the rules defined in the ".swiftLint.yml" file.
    3. If you have a lot of whitespace errors you can try using the autocorrect feature (IMPORTANT: commit any code changes before running autocorrect)
  
        ```bash
        swiftlint autocorrect
        ```
      
5. Use the Notification Pattern, update the chart and the table view when there are new calorie intakes.

## Go Further

1. Implement calorie tracking of multiple people and show a single chart that compares their calorie intake.
2. Add another third-party library to the application. (Refer to [this repo](https://github.com/vsouza/awesome-ios) for a good list of libraries to use)
3. Synchronize your data to a Firebase Database.
