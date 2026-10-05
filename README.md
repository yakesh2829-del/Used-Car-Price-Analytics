# CarVista — Used Car Price Analytics

A complete R/Shiny project for used-car market analysis with a hand-drawn 2D sketch-inspired UI/UX.

## Highlights
- Overview dashboard with KPIs and market charts
- Explore Cars section
- Price Analysis section
- Automated market Insights
- Car Recommender based on budget, fuel, transmission, year and mileage
- Data Explorer with search/sort
- Filters for brand, model, fuel, transmission, owner, year, price and mileage
- CSV-ready bundled dataset
- Fully offline after R packages are installed
- No Python, JavaScript backend, React or external API required

## Requirements
- R 4.1+ (designed for R 4.6.1)
- Packages: shiny, ggplot2, dplyr, DT, scales

## Run on Windows / VS Code
From the project folder:

```powershell
& "C:\Program Files\R\R-4.6.1\bin\x64\Rscript.exe" requirements.R
& "C:\Program Files\R\R-4.6.1\bin\x64\Rscript.exe" run_app.R
```

Open:
http://127.0.0.1:8080

If port 8080 is already in use:

```powershell
& "C:\Program Files\R\R-4.6.1\bin\x64\Rscript.exe" -e "shiny::runApp('.', host='127.0.0.1', port=8081, launch.browser=TRUE)"
```

## Project structure
- app.R — UI and Shiny server
- run_app.R — launcher
- requirements.R — package installer
- data/used_cars.csv — 1,800 synthetic used-car records
- www/styles.css — custom 2D sketch-inspired frontend

The dataset is synthetic and intended for academic/demo use.
