# Logly: Track Daily Activities

Logly is an all-in-one wellness, fitness, and lifestyle tracker that consolidates activity logging into a single app. Instead of using multiple apps for different activities, Logly lets you track everything in one place.

## Core Features

- Custom Activity Tracking - Log any activity you want, from workouts to habits to hobbies
- Streaks & Daily Insights - Track consistency and build habits
- Personalized Stats & Visual History - See your progress over time
- Health Platform Integration - Syncs with Apple Health and Google Fit

## What You Can Track

| Category  | Examples                                                                          |
|-----------|-----------------------------------------------------------------------------------|
| Fitness   | Home workouts, HIIT, CrossFit, strength training, running, cycling, yoga, pilates |
| Sports    | Golf, skiing, tennis, football, boxing, climbing, dancing                         |
| Wellness  | Meditation, sleep, doctor visits, blood work, massage therapy, weight tracking    |
| Lifestyle | Reading, studying, traveling, concerts, restaurants, vacation days                |
| Health    | Sickness/illness, symptoms tracking                                               |

## Key Differentiator

The app aims to be a centralized wellness platform not tied to any single ecosystem - your data travels with you across platforms via Apple Health and Google Fit integrations.

## IMPORTANT QUESTIONS

- Should we store activity date as a date or a timestamptz?
- Should we use pg_graphql or PostgREST?

## Features

### Intro Pager

[Page 1](./screenshots/intro-pager/page-1.png)

[Page 2](./screenshots/intro-pager/page-2.png)

[Page 3](./screenshots/intro-pager/page-3.png)

### Authentication

[Sign In Screen](./screenshots/sign-in-screen.png)

We do not differentiate between sign in and sign up. Only Google Sign-in and Apple Sign-in are supported. If the user is not already signed in, they will be prompted to sign in. If the user is already signed in, they will be redirected to the home screen.

### Onboarding

[Screenshot](./screenshots/onboarding/page-1-favorites.png)

This page gives the user an opportunity to select their favorite activities. These activities will be easily accessible on the Log Activity screen. The user can select as many or as few activities as they want. We suggest selecting at least 3 activities.

Regardless of the section, if a chip is selected as a favorite, it will be filled the color of the category of the activity. If it is not selected, it will have the default background color. Each section of chips will wrap to the next line as needed.

We will show a header of "Choose your favorite activities" and a subheader of "We recommend selecting at least 3 activities. You can edit this later in your settings."

Below the header, we will show a grid of their selected activities as chips. If there are less than three selected, then we will show an empty chip with a dotted border. The chips will be exactly the same size as the activity chips on the home screen. If they have 2 activities selected, they would see those two chips and an empty dotted line chip to make a total of 3 chips. If they have 3 or more activities selected, they would see 3 chips and no dotted line chips.

Below that is a section titled "Here are a few popular ones". Below the header will be a Wrap of the popular activities pulled from the database. If the user taps on one of these chips, it will be added to their selected activities and remain in the list, styled as a selected chip.

Below that section will be one section per category. Each section will have a header of the category name. Below the header will be a Wrap of the activities pulled from the database. If the user taps on one of these chips, it will be added to their selected activities and remain in the list, styled as a selected chip.

There will be a Continue button floating at the bottom of the screen. When tapped:

- if the device has Apple Health or Google Fit available, the user will be navigated to the Health Connect screen.
- if the device does not have Apple Health or Google Fit available, the user will be navigated to the Home screen.  

### Health Connect Screen

[Screenshot](./screenshots/onboarding/page-2-health-connect.png)

This page gives the user an opportunity to automatically sync their activities from Health Connect and Google Fit.

We will use the `health` flutter package to handle the Apple Health and Google Fit integrations.

We will show a header of "Connect with [Health Platform]" where Health Platform is either "Apple Health" or "Google Fit" depending on the device. Below the header will be a subheader of "This will allow activities from your watch and other sources to show up in Logly."

At the bottom of the screen will be a Continue button. When tapped:

- if the device has Apple Health or Google Fit available, we will request authorization for the following `health` permissions:
  - HealthDataType.WORKOUT
  - if Android, also request authorization for:
    - HealthDataType.DISTANCE_DELTA
    - HealthDataType.TOTAL_CALORIES_BURNED
- if the device does not have Apple Health or Google Fit available, the user will be navigated to the Home screen.

Below the Continue button will be a Skip for now button. When tapped, the user will be navigated directly to the Home screen.

### Home Screen

[Screenshot](./screenshots/home/home.png)

This will be a shell route for:

- Daily activity list
- Profile screen
- Settings screen

All shell route navigation should do a .go with go_router

It will have a consistent app bar with:

- Left Aligned: Large Text of the route name (Activities, Profile, Settings)
- Right Aligned:
  - Globe Icon: Global Trending Activities Bottom Sheet
  - Settings Icon: Settings screen

It will have a consistent bottom navigation bar and each element will do a NoTransition navigation:

- Left aligned: User's profile picture, rounded. If there is not image, then use a placeholder icon
  - Tapping the profile picture will navigate to the Profile Screen and refresh all data on it
- Centered: Logly Icon
  - Tapping the Logly Icon will navigate to the Home Screen, refresh the daily activity list, and animate to the top of the list
- Right aligned: Rounded, filled plus icon
  - Tapping the plus icon will navigate to the Log Activity Screen which will be a full screen modal

### Global Trending Activities Bottom Sheet

[Screenshot](./screenshots/global-trending-activities-popup.png)

The bottom sheet displays a header of "Trending Activities"

Below it, a list of the most popular activities globally. The list is scrollable and should display the top 25 activities. Each row should display the activity icon, activity name, and a trending up/down/same icon to indicate if the activity is trending up, down, or has stayed the same in popularity during the time period.

### Daily activities list

[Screenshot](./screenshots/home/home.png)

Display a list of the user's activities in a consecutive order. If the user did not log anything on a specific day, the row will be empty. The day and date are displayed on the left of each row and should be the same width from row to row. Use the following format:

- 3 letter day of the week (smaller font)
- MM/DD (larger font)

Activity Chips:

- Chips are used to signify activities that were logged on a specific day. They will be a horizontally scrolling list that takes up the remaining space on the row. They will spill off the right side of the screen and be scrollable.
- The color of the chip is determined by the category of the activity.
- Tapping an activity chip will open the Activity Details screen in edit mode
- Tapping anywhere on the row outside of a chip will open the Log Activity screen for the date that was tapped
- There should always be an icon on the chip. The icon is determined by, in order of priority:

  1. If only one subactivity was selected, then the subactivity's icon
  2. If multiple subactivities were selected, or none, then the activity's icon
  3. If the activity has no icon, then the category's icon

### Settings Screen

[Screenshot](./screenshots/settings-screen.png)

### Profile Screen

Each section should be in a separate card with the title of the section displayed outside of the card to the top left and a rotating chevron to the right of the title. The chevron should point down when the section is expanded and up when the section is collapsed. Tapping the chevron should expand or collapse the section.

#### Streak

[Screenshot](./screenshots/profile/streak.png)

This number shows the current streak of days that the user has logged at least one activity.

#### Summary

[Screenshot](./screenshots/profile/summary.png)

This section shows the user's activities for a time period broken out by category. The time period is determined by the segmented control at the top of the card. The options are: 1W, 1M, 1Y, All

The categories are displayed as progress bars with the color being the color of the category. The length of the bar is determined by the percentage of activities in that category compared to the category with the most activities. Display each category as:

- Left Aligned: Category Name, Right Aligned: Number of activities
- The progress bar is displayed below the category name and number of activities

#### Activities in the last year

[Screenshot](./screenshots/profile/activities-last-year.png)

This section is a replica of GitHub's contribution graph. It shows the user's activities for the last year as a total per day. The color of the square is determined by the number of activities logged on that day. The color should be determined as:

- 0 activities: grey that will contrast with the card background
- <2 activities: #033A16
- <4 activities: #196C2E
- <6 activities: #2EA043
- 6+ activities: #56D364

The section places the most recent date on the left and the oldest date on the right. It should display 7 rows, one for each day of the week, with Sunday always on top. The days of the week should be displayed on the left of each row. For brevity, just show Mon, Wed, Fri. The months should be displayed along the top in 3-letter format, with the first letter being capitalized. The month should be left aligned with the column where the most recent day of that month is displayed.

Underneath the graph, display a legend of the colors and what they mean. It should have the word "Less" on the left and "More" on the right. The legend should be left aligned in the card and not be affescted by horizontal scrolling.

#### Last 12 months

[Screenshot](./screenshots/profile/last-12-months.png)

This section displays a category selector, followed by the trailing 12 months of activity totals per month. The most recent month is on the top and the oldest month is on the bottom.

The category selector is a two row horizontal list of chips, 3 categories per row. Each chiup should be outlined in the color of the category with the label being white. when a chip is selected, the label should be white, and the background should be the color of the category. By default, all categories are selected.

The months are displayed as progress bars with the length of the bar being determined by the percentage of activities in that month compared to the month with the most activities. The progress bar should be partitioned based on the selected categories and the width of each denotes the percentage of activities in that category for that month.

Display each month as:

- Left Aligned: Category Name, Right Aligned: Number of activities
- The progress bar is displayed below the category name and number of activities

When the selected categories change, the progress bars should animate to the new values using the same animation as the progress bars in the Summary section.

### Log Activity Flow

#### Activity Search Screen

[Screenshot](./screenshots/log-activity-flow/activity-selection.png)

The activity search screen is thae main point of selecting the activity you want to log.

Each activity will be displayed as a chip with the activity icon and name. Tapping any chip will navigate to the log activity screen with that activity selected.

The screen will be laid out as:

- Already Logged Activities
  - At the top if the screen will be a Wrap of the activities already logged for that day in ascending order of the created_at date.
  - Each activity will be displayed as a chip with the activity icon and name.
  - Tapping a chip will navigate to the log activity screen with that activity selected.
- Search Bar
  - The search bar will perform a search as the user types.
  - The placeholder will say "Search or create a new activity"
  - If there is a search query, the rest of the sections will be hidden and only the search results will be displayed.
- Search Results
  - The search results will be displayed below the search bar.
  - The search results will be a Wrap of the activities that match the search query in order of relevance.
- Create Activity List Tile
  - Title: the search query
  - Subtitle: "Create a custom activity"
  - The create activity button will navigate to the create custom activity screen.
- Favorite Activities
  - The section header will have a leading red heart icon, a title of "Favorite Activities", and a trailing chevron icon.
  - Tapping the chevron icon will expand or collapse the favorite activities section.
  - The favorite activities will be displayed below the section header.
  - The favorite activities will be a Wrap of the activities that are favorited in descending order of when it was favorited.
- Category Sections
  - The category sections will be displayed below the favorite activities section.
  - Each category section will have a leading category icon, a title of the category name, and a trailing chevron icon.
  - Tapping the chevron icon will expand or collapse the category section.
  - The activities in the category section will be displayed below the section header.
  - The activities in the category section will be a Wrap of the activities in that category in descending order of popularity.
  - There will be a View all chip underneath each category chip that will navigate to the category screen for that category. The chip will be outlined in the color of the category with the label the same color.

#### Search Results

[Screenshot](./screenshots/log-activity-flow/search-results.png)

The search results will replace the favorites and category sections when a search query is entered. If the search query is cleared, the favorites and category sections will be displayed. If there are no search results, a message will be displayed instead.

#### Log Activity Screen

[Screenshot](./screenshots/log-activity-flow/log-activity-screen.png)

The log activity screen will have a large title in the top left that says "Log Activity".

The app bar will have:

- leading cancel button that will pop the screen
- action icons:
  - heart icon to favorite the activity type. if the activity is favorited, then it should be filled in red
  - save text button which will save the activity. the only required fields for saving are the activity type and the date

based on the activity type, the screen will show various fields to fill out. The activity type will determine what fields are shown

All activities will show:

- the Custom Name field which is a text box that has a placeholder of "e.g. Morning Run". This field is optional.
- the Date field which is a date picker and defaults to today, unless the screen is opened with a different date
- Comments box which is a text area with a minimum of 5 lines. This field is optional.

Conditional fields based on activity detail type:

- Duration
  - Shows the label left aligned, and 3 input text boxes for hours, minutes, and seconds. The input boxes are right aligned with suffixes of "h", "m", and "s". They should be wide enough to show 2 digits using tabular numbers.
  - Below the inputs is a slider with a min and max value defined from the activity detail type. The slider and the inputs are in sync. The slider changes the input values and the inputs change the slider value.
- Numeric (integer or double)
  - Shows the label left aligned, and a single input text box for the value. The input box is right aligned.
  - Below the input is a slider with a min and max value defined from the activity detail type. The slider and the input are in sync. The slider changes the input value and the input changes the slider value.
  - if the type is integer, then the input should only allow integer values
  - if the type is double, then the input should only allow double values with 2 decimal points
- Environment (indoor or oudoor)
  - Shows the label left aligned, and a sliding segment control that allows the user to select the environment as Indoor or Outdoor.
  - The control defaults to having nothing selected
- Distance
  - Shows the label left aligned, and a single input text box for the value. Next to the input is a sliding segment control that allows the user to select the unit of measurement as defined by the activcity detail type.
  - Below the input is a slider with a min and max value defined from the activity detail type. The slider and the input are in sync. The slider changes the input value and the input changes the slider value.
  - when the unit of measurement changes, the slider and input should convert the value to the new unit of measurement.
- Liquid Volume
  - Shows the label left aligned, and a single input text box for the value. Next to the input is a sliding segment control that allows the user to select the unit of measurement as defined by the activcity detail type.
  - Below the input is a slider with a min and max value defined from the activity detail type. The slider and the input are in sync. The slider changes the input value and the input changes the slider value.
  - when the unit of measurement changes, the slider and input should convert the value to the new unit of measurement.
- Weight
  - Shows the label left aligned, and a single input text box for the value. Next to the input is a sliding segment control that allows the user to select the unit of measurement as defined by the activcity detail type.
  - Below the input is a slider with a min and max value defined from the activity detail type. The slider and the input are in sync. The slider changes the input value and the input changes the slider value.
  - when the unit of measurement changes, the slider and input should convert the value to the new unit of measurement.
- Pace
  - If the activiy has a Duration detail type and a distance detail type, then display a read-only pace field that is calculated from the duration and distance. The pace should be displayed in the unit of measurement defined by the distance detail type.
  - the activity type will have a field called pace_type that defines how it should be calculated:
    - minutesPerUom e.g. 10:05 min/mi or 10:05 min/km
    - minutesPer100Uom e.g. 1:05 min/100m or 1:05 min/100yrd
    - minutesPer500m e.g. 2:05 min/500m
    - floorsPerMinute e.g. 1 floor/min

#### Create Custom Activity Screen

[Initial State](./screenshots/log-activity-flow/create-custom-activity-1.png)

the top section will be a card with the Category Selector in it. The category selector will be the same as the one used on the Log Activity screen. Only one category can be selected. This is a required field and should display an error message if no category is selected.

When the user is navigated to this screen, the search query that they had when they tapped the list tile will be used to populate the activity name field. This is a required field and should display an error message if no activity name is entered. This will be in it's own card with the label "Activity Name" to the left, and an input field to the right.

These are optional activity details that the user can add to the activity. each is in its own card with the label to the left and a toggle switch to the right. If the toggle is switched on, then the activity detail will be added to the activity and the card will expand down to show the rest of the fields for that activity detail.

- Title: Number, Subtitle: Track a count - Reps, Sets, Laps, etc
  - Label text of "Label" to the left, and an input field to the right.
  - Label text of "Maximum" to the left, and an input field to the right. It should only allow integer values.
- Title: Environment, Subtitle: Indoor/Outdoor
  - no additional fields
- Title: Duration
  - Label text of "Label" to the left, and an input field to the right. Input field defaults to "Duration".
  - Label text of "Maximum" to the left, and the same time inputs as the duration field.
- Title: Distance
  - Segmented control with options of "Short (m/yd)" and "Long (km/mi)"
  - Label text of "Label" to the left, and an input field to the right. Input field defaults to "Distance".
  - Label text of "Maximum" to the left, and an input box to the right with a suffix depebding on the segmented control selection as well as the users unit of measurement preference.
- Title: Pace
  - no additional fields
  - show an error message if a distance or a duration field has not been toggled on
  - show a subtitle of minPerUom based on the distance unit of measurement preference and the user's unit of measurement preference.

[Missing required fields](./screenshots/log-activity-flow/create-custom-activity-2.png)

[Ready to save](./screenshots/log-activity-flow/create-custom-activity-3.png)

When all the required fields have been met, the save button in the app bar will be enabled. Create the new record in the dataabse and wait for the response which will be an activity record. Once the record is received, navigate the user to the Log Activity screen with the newly created activity pre-selected.

### Edit Logged Activity Flow

[Screen 1](./screenshots/edit-logged-activity-screen.png)

When the Edit Logged Activity screen is opened, the user will be presented with a screen that allows them to edit the activity they logged. The screen will have the same feel as the Log Activity screen, but with the following differences:

- The app bar will have:
  - Cancel button which will close the screen. if there was an edit to the activity, the user will be presented with a confirmation dialog to confirm the cancellation
  - Action icons:
    - Graph icon which will open the statistics screen for that activity type
    - Delete icon which will delete the activity. the user will be presented with a ocnfirmation dialog to confirm the deletion
    - Save icon which will save the activity. The icon will change color when there is an edit to the activity
- The user will be unable to change the activity type. Instead, the activity type will be displayed in the top left of the screen in large text
- all of the widgets used for the log activity screen will be used for the edit logged activity screen
