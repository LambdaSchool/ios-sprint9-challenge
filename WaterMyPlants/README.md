iOS & Web: 

User can signup/create an account by providing a unique username, a valid mobile phoneNumber and a password.

User can log in to an authenticated session using the credentials provided at account creation/signup.

Authenticated user can Create, Update and Delete a plant object. At a minimum, each plant must have the following properties: id: Integer nickname: String species : String

h2oFrequency: Type determined by implementation image: optional

Authenticated user can view a list of created plants. A plant can be Deleted or selected to present user with a detail view where user can then update any property of the selected plant.

( iOS only ) Background refresh functionality: h2ofrequency can wake up device to remind user if they need to water their plants.

( iOS only ) User can employ the camera to capture a photo of their plant, collecting image data and pushing it to the API for "create a plant" flow. Still can be optional.

(iOS only) Set up application to allow local notifications.

Authenticated user can update their phoneNumber and password.

Stretch iOS & Web:

Authenticated user can set up Push Notifications to be triggered when an h2oFrequency of any plant arrives/has elapsed. Implement a feature that allows an Authenticated user can see an appropriate suggested h2oFrequency based on species using the API of your choice.

Authenticated user can upload images of a plant. If no user image is provided, a placeholder image of a plant of the same species populates the view.

( iOS & Unit 4 Web only ) Authenticated user can receive push notification on their mobile device when when a scheduled h2oFrequency is reached. At a minimum, this reminder/notification must display the nickname and a short description of the task. (APNS)
