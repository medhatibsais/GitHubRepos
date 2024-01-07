**GitHub Repositories App**
    
The app is responsible for displaying repositories from GitHub depending on creation date

- Features:
  - Ability to filter on specific periods (month, day, week)
  - Search functionality
  - Ability to add repositories to favorite list and cahce them locally
  - Check the repository link and open it in your default browser

- Technical:
  - UserDefault used to cache facorite data, CoreData also can be used, but here the data is quite simple and small so UserDefaults can handle this instead of creating special models for CoreData and create own Database
  - Alamofire used to request the data, URLSession can be used and customized, but Alamofire, can now be better for fast implementation, instead of building networking layer from scratch
  - SDWebImage used to load images from URL, also URLSession can be used, but this library responsible for caching images instead of building caching manager and integrate this with the app
 
- Some enhancement can be implemented
  - Add skeleton for data while requesting the API
  - Support dark mode
  - Add option to the user to select what data from the repository he needs to search for.
