CREATE VIEW View_User_Information AS
SELECT U.user_id, U.first_name, U.last_name, U.year_of_birth, U.month_of_birth, U.day_of_birth, U.gender, 
       C.city_name, C.state_name, C.country_name, 
       H.city_name AS hcity, H.state_name AS hstate, H.country_name AS hcountry, 
       P.institution, E.program_year, P.concentration, P.degree 
FROM users U 
LEFT JOIN user_current_cities CI ON CI.user_id = U.user_id
LEFT JOIN cities C ON C.city_id = CI.current_city_id
LEFT JOIN user_hometown_cities HI ON HI.user_id = U.user_id
LEFT JOIN cities H ON H.city_id = HI.hometown_city_id
LEFT JOIN education E ON E.user_id = U.user_id
LEFT JOIN programs P ON P.program_id = E.program_id;

CREATE VIEW View_Are_Friends AS
SELECT user1_id, user2_id
FROM friends;

CREATE VIEW View_Photo_Information AS
SELECT A.album_id, A.album_owner_id, A.cover_photo_id, A.album_name, A.album_created_time, A.album_modified_time, A.album_link, A.album_visibility, 
       P.photo_id, P.photo_caption, P.photo_created_time, P.photo_modified_time, P.photo_link
FROM albums A
INNER JOIN photos P ON A.album_id = P.album_id;

CREATE VIEW View_Event_Information AS
SELECT UE.event_id, UE.event_creator_id, UE.event_name, UE.event_tagline, UE.event_description, UE.event_host, UE.event_type, UE.event_subtype, UE.event_address, 
       C.city_name, C.state_name, C.country_name, 
       UE.event_start_time, UE.event_end_time
FROM user_events UE
INNER JOIN cities C ON C.city_id = UE.event_city_id;

CREATE VIEW View_Tag_Information AS
SELECT tag_photo_id, tag_subject_id, tag_created_time, tag_x, tag_y
FROM tags;
