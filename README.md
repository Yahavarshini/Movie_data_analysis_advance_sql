# Movie Dataset Analysis - Advanced SQL

## Project Overview
This project focuses on analyzing a movie dataset using **advanced SQL techniques**. The dataset includes various tables containing information about movies, ratings, actors, and genres. The goal is to uncover insights into movie trends, audience preferences, and factors contributing to highly rated films.

## Objectives
- Analyze trends in movie production over time.
- Examine the relationship between movie duration and performance.
- Explore movie ratings and audience engagement.
- Investigate the impact of actors and directors on movie success.
- Identify key insights for filmmakers and industry professionals.

## Dataset Overview
The dataset consists of multiple tables, including:
- **Movies**: Contains movie titles, release years, and genres.
- **Ratings**: Stores audience ratings and vote counts.
- **Actors**: Information about actors and their associated movies.
- **Genres**: Categorization of movies based on their genres.

## Key Insights
### 🎬 Trends in Movie Production
- Movie production peaked during specific periods due to industry trends and global events.
- **USA & India** were the top movie producers in **2019**.
- Most produced genres: **Drama and Action**.

### ⏳ Movie Duration and Performance
- Different genres have varying average durations, impacting audience engagement.
- The number of critically well-received movies varies over time.

### ⭐ Movie Ratings and Trends
- Highly rated movies often have **strong storylines** or **big-name actors**.
- **Seasonal trends** affect ratings, with certain months showing higher ratings due to **award seasons**.

### 📊 Movie Popularity Trends
- Drama had **16 movies** with over **1,000 votes**.
- **German movies** received more votes on average than **Italian movies**.

### 🎭 Actor and Director Performance
- Some actors are box-office stars, while others tend to appear in low-rated movies.
- Directors' consistency influences movie ratings significantly.

### 🗣️ Audience Engagement
- Higher votes **≠** higher ratings; some movies are controversial but widely discussed.
- Large studios get more votes, but indie films may have better ratings.

## SQL Techniques Used
- **Joins (INNER, LEFT, RIGHT, FULL OUTER)**
- **Aggregations (SUM, AVG, COUNT, GROUP BY)**
- **Subqueries and CTEs (WITH clause)**
- **Window Functions (ROW_NUMBER, RANK, DENSE_RANK)**
- **CASE Statements for Conditional Analysis**
- **Indexes and Performance Optimization**

## Conclusion
Understanding audience preferences and industry trends can help filmmakers create content that resonates with viewers. Data-driven decisions enable better storytelling, improved audience targeting, and strategic movie production.

## Getting Started
### Prerequisites
- SQL database software (PostgreSQL, MySQL, or any other SQL-based system)
- Basic knowledge of SQL

### Installation & Execution
1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/movie-dataset-analysis.git
   ```
2. Load the dataset into your SQL environment.
3. Run the provided SQL queries to explore insights.

## Repository Structure
```
📂 Movie-Dataset-Analysis
│-- 📄 README.md (This file)
│-- 📄 Reinforcement.sql (SQL scripts)
│-- 📄 Dataset.csv (Movie dataset in CSV format)
│-- 📂 Analysis (Contains reports and insights)
```
