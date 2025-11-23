# Weather App

A simple and fast Flutter application for checking weather conditions around the world.  
The app uses the OpenWeatherMap API to display real-time weather data with a clean and minimal UI.

---

## 🌤️ Features

- Display **current weather** information  
- Fetch **5-day / 3-hour forecast** data  
- Show details such as:
  - Temperature  
  - Humidity  
  - Wind Speed  
  - Sunrise & Sunset  
- Search weather by **any city name**  
- Display **weather icons** (clear, rain, clouds, etc.)

---

## 🌐 API

This app uses the **OpenWeatherMap API**:  
https://openweathermap.org/

You must provide your own API key to run the project.

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.9.0
  progress_indicators: ^1.0.0
  intl: ^0.20.2
▶️ How to Run

Clone the repository

git clone https://github.com/cyrus4u/<your-repo-name>.git



Install dependencies

flutter pub get


Add your API key
Create a file named api_key.dart and insert:

const String apiKey = "YOUR_API_KEY_HERE";


Run the app

flutter run
📸 Screenshots
Add your screenshots inside a folder like:
assets/screenshots/

Then reference them in README:
![Home Screen](weatherapp/images/weatherApp.png)



🔮 Future Improvements


Add state management (Bloc / Provider / Riverpod)


Better UI animations


Weekly forecast


Favorite cities


Air quality index


Dark Mode



👤 Author
GitHub: cyrus4u

---

If you want, I can also:  
✅ generate badges (Flutter version, license, stars, forks)  
✅ design an improved description  
✅ help you create the API key file structure  
Just tell me!


