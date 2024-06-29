DROP TABLE Tags;

ALTER TABLE Photos DROP CONSTRAINT album_constraint;
ALTER TABLE Albums DROP CONSTRAINT cover_photo_constraint;

DROP TABLE Photos;
DROP TABLE Albums;

DROP TABLE Participants;
DROP TABLE User_Events;
DROP TABLE Education;

DROP TRIGGER generate_program_id;
DROP SEQUENCE program_sequence;
DROP TABLE Programs;

DROP TABLE Messages;

DROP TABLE User_Hometown_Cities;
DROP TABLE User_Current_Cities;

DROP TRIGGER generate_city_id;
DROP SEQUENCE city_sequence;
DROP TABLE Cities;

DROP TRIGGER order_friends_pairs;
DROP TABLE Friends;

DROP TABLE 
