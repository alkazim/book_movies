# 🎬 Book Movies App

A simple Flutter app to explore movies using the **TMDB (The Movie Database) API** (free and open).

The app will have 4–5 screens including a splash, list, search, booking screen, and details.

---

## 🔹 Features & Screens

### 1. Splash Screen
- App logo with a small animation.
- Navigates to home after 2 seconds.

### 2. Home Screen & Listing (Movies List)
- Search bar for entering a movie title.
- Fetch movies from **OMDb API**.
- Display results in a scrollable list/grid with:
  - Poster (or placeholder if not available)
  - Title
  - Year
- Pagination support (`page=1,2,3...`) since OMDb only returns 10 results per page.

### 3. Movie Details Screen
- On tapping a movie, navigate to details.
- Show movie details such as:
  - Poster (if available)
  - Title
  - Year
  - Genre
  - Director
  - IMDb Rating
- Book a movie by choosing a date and time.

### 4. Booking Screen
- Show the information selected in booking.
- Display a **barcode** for the booked ticket.

---

## 🔹 API Endpoints (TMDB Free API)

- **List Movies**  
