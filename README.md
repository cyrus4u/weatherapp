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
