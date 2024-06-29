INSERT INTO Users (user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender)
SELECT DISTINCT user_id, first_name, last_name, year_of_birth, month_of_birth, day_of_birth, gender
FROM project1.Public_User_Information;

INSERT INTO Cities (city_name, state_name, country_name)
SELECT DISTINCT current_city, current_state, current_country
FROM project1.Public_User_Information
WHERE (current_city, current_state, current_country) NOT IN (
    SELECT city_name, state_name, country_name FROM Cities
);

INSERT INTO Cities (city_name, state_name, country_name)
SELECT DISTINCT hometown_city, hometown_state, hometown_country
FROM project1.Public_User_Information
WHERE (hometown_city, hometown_state, hometown_country) NOT IN (
    SELECT city_name, state_name, country_name FROM Cities
);

INSERT INTO User_Current_Cities (user_id, current_city_id)
SELECT DISTINCT PUI.user_id, C.city_id
FROM project1.Public_User_Information PUI
INNER JOIN Cities C
ON PUI.current_city = C.city_name
AND PUI.current_state = C.state_name
AND PUI.current_country = C.country_name;

INSERT INTO User_Hometown_Cities (user_id, hometown_city_id)
SELECT DISTINCT PUI.user_id, C.city_id
FROM project1.Public_User_Information PUI
INNER JOIN Cities C
ON PUI.hometown_city = C.city_name
AND PUI.hometown_state = C.state_name
AND PUI.hometown_country = C.country_name;

INSERT INTO Programs (institution, concentration, degree)
SELECT DISTINCT PUI.institution_name, PUI.program_concentration, PUI.program_degree
FROM project1.Public_User_Information PUI
WHERE PUI.institution_name IS NOT NULL;

INSERT INTO Education (user_id, program_id, program_year)
SELECT DISTINCT PUI.user_id, prog.program_id, PUI.program_year
FROM project1.Public_User_Information PUI
INNER JOIN Programs prog
ON prog.institution = PUI.institution_name
AND prog.concentration = PUI.program_concentration
AND prog.degree = PUI.program_degree
WHERE PUI.institution_name IS NOT NULL;

INSERT INTO Friends (user1_id, user2_id)
SELECT DISTINCT PAF.user1_id, PAF.user2_id
FROM project1.Public_Are_Friends PAF
WHERE (PAF.user1_id, PAF.user2_id) NOT IN (
    SELECT user1_id, user2_id FROM Friends
)
AND PAF.user1_id < PAF.user2_id;

INSERT INTO Albums (album_id, album_owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id)
SELECT DISTINCT album_id, owner_id, album_name, album_created_time, album_modified_time, album_link, album_visibility, cover_photo_id
FROM project1.Public_Photo_Information;

INSERT INTO Photos (photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link)
SELECT photo_id, album_id, photo_caption, photo_created_time, photo_modified_time, photo_link
FROM project1.Public_Photo_Information;

INSERT INTO Tags (tag_photo_id, tag_subject_id, tag_created_time, tag_x, tag_y)
SELECT photo_id, tag_subject_id, tag_created_time, tag_x_coordinate, tag_y_coordinate
FROM project1.Public_Tag_Information;

INSERT INTO User_Events (event_id, event_creator_id, event_name, event_tagline, event_description, event_host, event_type, event_subtype, event_address, event_city_id, event_start_time, event_end_time)
SELECT DISTINCT PEI.event_id, PEI.event_creator_id, PEI.event_name, PEI.event_tagline, PEI.event_description, PEI.event_host, PEI.event_type, PEI.event_subtype, PEI.event_address, C.city_id, PEI.event_start_time, PEI.event_end_time
FROM project1.Public_Event_Information PEI
INNER JOIN Cities C
ON PEI.event_city = C.city_name
AND PEI.event_state = C.state_name
AND PEI.event_country = C.country_name;
