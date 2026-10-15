
CREATE DATABASE spotify_db;
USE spotify_db;

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50),
    country VARCHAR(50),
    plan VARCHAR(20)
);

CREATE TABLE Artists (
    artist_id INT PRIMARY KEY,
    artist_name VARCHAR(100),
    genre VARCHAR(50)
);

CREATE TABLE Tracks (
    track_id INT PRIMARY KEY,
    track_name VARCHAR(100),
    artist_id INT,
    duration_sec INT,
    FOREIGN KEY (artist_id) REFERENCES Artists(artist_id)
);

CREATE TABLE Listening_History (
    play_id INT PRIMARY KEY,
    user_id INT,
    track_id INT,
    minutes_played INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (track_id) REFERENCES Tracks(track_id)
);

INSERT INTO Users (user_id, user_name, country, plan) VALUES
(1, 'Aditi', 'India', 'Premium'),
(2, 'Rahul', 'India', 'Free'),
(3, 'Emma', 'UK', 'Premium'),
(4, 'Noah', 'USA', 'Free'),
(5, 'Sofia', 'Spain', 'Premium'),
(6, 'Arjun', 'India', 'Free');

INSERT INTO Artists (artist_id, artist_name, genre) VALUES
(101, 'Arijit Singh', 'Bollywood'),
(102, 'Taylor Swift', 'Pop'),
(103, 'The Weeknd', 'Pop'),
(104, 'A. R. Rahman', 'Bollywood'),
(105, 'Ed Sheeran', 'Pop'),
(106, 'Imagine Dragons', 'Rock');

INSERT INTO Tracks (track_id, track_name, artist_id, duration_sec) VALUES
(201, 'Kesariya', 101, 268),
(202, 'Anti-Hero', 102, 200),
(203, 'Blinding Lights', 103, 200),
(204, 'Jai Ho', 104, 210),
(205, 'Shape of You', 105, 234),
(206, 'Believer', 106, 204),
(207, 'Perfect', 105, 263),
(208, 'Channa Mereya', 101, 290);

INSERT INTO Listening_History (play_id, user_id, track_id, minutes_played) VALUES
(1001, 1, 201, 4),
(1002, 1, 202, 3),
(1003, 2, 201, 4),
(1004, 2, 203, 3),
(1005, 3, 205, 4),
(1006, 3, 207, 4),
(1007, 4, 206, 3),
(1008, 4, 203, 3),
(1009, 5, 202, 3),
(1010, 5, 205, 4),
(1011, 6, 208, 5),
(1012, 6, 201, 4),
(1013, 1, 208, 5),
(1014, 2, 206, 3),
(1015, 3, 202, 3);

SELECT * FROM Users;
SELECT * FROM Artists;
SELECT * FROM Tracks;
SELECT * FROM Listening_History;

-- 1. List all available tracks along with their durations.
select * 
from tracks;

-- 2. Show all users who are subscribed to the Premium plan.
select *
from users
where plan = 'Premium';

-- 3. Find all tracks whose names contain the word “Lights”.
select *
from tracks
where track_name like '%Lights%';

-- 4. Find all tracks whose names start with the letter “B”.
select *
from tracks
where track_name like 'B%';

-- 5. Display track names and durations using meaningful column aliases.
select track_name as tracks, duration_sec as durations
from tracks;

-- 6. List all artists in alphabetical order.
select *
from artists
order by artist_name asc;

-- 7. Show all users from India who are on the Free plan.
select *
from users 
where country = 'India' and plan = 'Free';

-- 8. Calculate the number of tracks available in each genre.
select a.genre, count(t.track_id) as number_of_tracks
from artists a
join tracks t 
on a.artist_id = t.artist_id
group by genre;

-- 9. Find the total number of plays for each song.
select t.track_name as song, count(l.play_id) as number_of_play
from tracks t 
join listening_history l
on t.track_id = l.track_id
group by song;

-- 10. Identify the top 5 most-played songs.
select t.track_name as song, count(l.play_id) as number_of_play
from tracks t 
join listening_history l
on t.track_id = l.track_id
group by song
order by number_of_play desc
limit 5;

-- 11. Calculate the total listening minutes for each user.
select u.user_name, sum(l.minutes_played) as total_listening_minutes
from listening_history l
join users u
on l.user_id = u.user_id
group by user_name;

-- 12. Find artists whose songs have been played more than twice.
select a.artist_name, count(l.play_id) as play_count
from artists a
join tracks t
on a.artist_id = t.artist_id
join listening_history l
on l.track_id = t.track_id
group by artist_name
having play_count >2;

-- 13. Calculate the total listening minutes for each country.
select u.country, sum(l.minutes_played) as total_listening_minutes
from listening_history l
join users u
on l.user_id = u.user_id
group by country;

-- 14. Find genres that contain more than one track.
select a.genre, count(t.track_id) as track
from artists a 
join tracks t
on a.artist_id = t.artist_id
group by genre
having track >1;

-- 15. Display each user's listening history along with the song title and artist name.
select u.user_name, l.*, t.track_name as song_title, a.artist_name
from users u 
join listening_history l
on u.user_id = l.user_id
join tracks t 
on t.track_id = l.track_id
join artists a
on a.artist_id = t.artist_id;
 
-- 16. Identify the artist with the highest number of plays.
select a.artist_name, count(l.play_id) as number_of_plays
from artists a 
join tracks t 
on a.artist_id = t.artist_id
join listening_history l 
on l.track_id = t.track_id 
group by artist_name 
order by number_of_plays desc 
limit 1 ;

-- 17. Compare total listening minutes across Free and Premium subscription plans.
select u.plan, sum(l.minutes_played) as total_listening_minutes
from listening_history l
join users u 
on u.user_id = l.user_id
group by plan;
 
-- 18. Identify the most popular genre based on total plays.
select a.genre, count(l.play_id) as total_plays
from artists a 
join tracks t 
on a.artist_id = t.artist_id 
join listening_history l 
on t.track_id = l.track_id 
group by genre 
order by total_plays desc 
limit 1;

-- 19. Find the top 3 users based on total listening minutes.
select u.user_name, sum(l.minutes_played) as total_listening_minutes
from users u 
join listening_history l 
on u.user_id = l.user_id 
group by user_name 
order by total_listening_minutes desc
limit 3;

-- 20. Identify songs that have been played more than twice.
select t.track_name as songs, count(l.play_id) as play_count
from listening_history l 
join tracks t 
on t.track_id = l.track_id 
group by songs 
having play_count > 2;

-- 21. Find artists with more than one distinct track.
select a.artist_name as Artist, count(distinct t.track_id) as Track_Count
from artists a
join tracks t 
on a.artist_id = t.artist_id
group by Artist
having Track_Count > 1;

-- 22. Calculate the average listening duration for each track.
select t.track_name as track, round(avg(l.minutes_played),2) as avg_listening_duration
from tracks t 
join listening_history l 
on t.track_id = l.track_id 
group by track;

-- 23. Find users who have listened to more than 8 minutes of music.
select u.user_name as users, sum(l.minutes_played) as total_minutes
from listening_history l
join users u 
on l.user_id = u.user_id
group by users 
having total_minutes > 8
order by total_minutes desc;

-- 24. Identify the country with the highest total listening time.
select u.country, sum(l.minutes_played) as total_listening_time
from users u 
join listening_history l 
on u.user_id = l.user_id 
group by country
order by total_listening_time desc
limit 1; 

-- 25. Determine which subscription plan has the highest average listening time per user.
select u.plan, avg(l.minutes_played) as avg_listening_time_per_user
from listening_history l 
join users u 
on u.user_id = l.user_id 
group by plan 
order by avg_listening_time_per_user desc 
limit 1;

-- 26. Which artist should Spotify consider featuring more prominently based on the sample listening data? Explain your reasoning.
select a.artist_name, sum(l.minutes_played) as listening_time
from artists a 
join tracks t 
on a.artist_id = t.artist_id 
join listening_history l 
on t.track_id = l.track_id 
group by artist_name 
order by listening_time desc
limit 1;

-- 27. Which genre could Spotify prioritize for personalized music recommendations?
select a.genre, sum(l.minutes_played) as listening_time
from artists a 
join tracks t 
on a.artist_id = t.artist_id 
join listening_history l 
on t.track_id = l.track_id 
group by genre 
order by listening_time desc
limit 1;

-- 28. What differences do you observe in listening behavior between Free and Premium users?
select u.plan, t.track_name, sum(l.minutes_played) as played_time
from users u 
join listening_history l 
on u.user_id = l.user_id 
join tracks t 
on l.track_id = t.track_id 
group by plan, track_name
order by played_time desc;

-- 29. How could Spotify use listening history to improve music discovery?
/* Ans. Spotify can leverage listening history in several impactful ways such as Personalized Recommendations,
Contextual Playlists, Cross-Genre Discovery, and Trend Spotting. */ 

-- 30. If you had to present one key recommendation to Spotify's leadership team, what would it be and why?
-- Ans. One key recommendation is to double down on listening- history- driven personalization. 
-- This will improve user engagement, spotlight diverse artists, and ensure Spotify remains the go-to platform for music discovery. 











