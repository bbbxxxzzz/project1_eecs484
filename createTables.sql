CREATE TABLE Users(
    user_id NUMBER PRIMARY KEY NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    year_of_birth INTEGER,
    month_of_birth INTEGER,
    day_of_month INTEGER,
    gender VARCHAR(100)
);

CREATE TABLE Friends(
    user1_id NUMBER NOT NULL,
    user2_id NUMBER NOT NULL,
    PRIMARY KEY(user1_id, user2_id),
    FOREIGN KEY(user1_id) REFERENCES Users(user_id),
    FOREIGN KEY(user2_id) REFERENCES Users(user_id)
);

CREATE OR REPLACE TRIGGER Order_Friend_Pairs
    BEFORE INSERT ON Friends
    FOR EACH ROW
        DECLARE temp NUMBER;
        BEGIN
            IF :NEW.user1_id > :NEW.user2_id THEN
                temp := :NEW.user2_id;
                :NEW.user2_id := :NEW.user1_id;
                :NEW.user1_id := temp;
            END IF ;
        END;
/

CREATE TABLE Cities(
    city_id INTEGER PRIMARY KEY NOT NULL,
    city_name VARCHAR2(100) NOT NULL,
    state_name VARCHAR2(100) NOT NULL,
    country_name VARCHAR2(100) NOT NULL,
    UNIQUE(city_name, state_name, country_name)
);


CREATE TABLE User_Current_Cities(
    user_id NUMBER NOT NULL,
    current_city_id INTEGER NOT NULL,
    PRIMARY KEY(user_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (current_city_id) REFERENCES Cities(city_id)
);

CREATE TABLE User_Hometown_Cities(
    user_id NUMBER NOT NULL,
    hometown_city_id INTEGER NOT NULL,
    PRIMARY KEY(user_id)
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (hometown_city_id) REFERENCES Cities(city_id),
);

CREATE TABLE Messages(
    message_id NUMBER PRIMARY KEY NOT NULL,
    sender_id NUMBER NOT NULL,
    receiver_id NUMBER NOT NULL,
    message_content VARCHAR2(2000) NOT NULL,
    sent_time TIMESTAMP NOT NULL,
    FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES Users(user_id)
);

CREATE TABLE Programs(
    program_id INTEGER PRIMARY KEY NOT NULL,
    institution VARCHAR2(100) NOT NULL,
    concentration VARCHAR2(100) NOT NULL,
    degree VARCHAR2(100) NOT NULL,
    UNIQUE(institution, concentration, degree)
);

CREATE TABLE Education(
    user_id NUMBER NOT NULL,
    program_id NUMBER NOT NULL,
    program_year INTEGER NOT NULL,
    PRIMARY KEY(user_id, program_id)
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (program_id) REFERENCES Programs(program_id)
);

CREATE TABLE User_Events (
    event_id NUMBER PRIMARY KEY NOT NULL,
    event_creator_id NUMBER NOT NULL,
    event_name VARCHAR2(100) NOT NULL,
    event_tagline VARCHAR2(100),
    event_description VARCHAR2(100),
    event_host VARCHAR2(100),
    event_type VARCHAR2(100),
    event_subtype VARCHAR2(100),
    event_address VARCHAR2(2000),
    event_city_id NUMBER NOT NULL,
    event_start_time TIMESTAMP,
    event_end_time TIMESTAMP,
    FOREIGN KEY (event_creator_id) REFERENCES Users(user_id),
    FOREIGN KEY (event_city_id) REFERENCES Cities(city_id)
);

CREATE TABLE Participants (
    event_id NUMBER NOT NULL,
    user_id NUMBER NOT NULL,
    confirmation VARCHAR2(100) NOT NULL,
    PRIMARY KEY (event_id, user_id),
    FOREIGN KEY (event_id) REFERENCES User_Events(event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CHECK (confirmation IN ('Attending', 'Declines', 'Unsure', 'Not_Replied'))
);

CREATE TABLE Albums (
    album_id NUMBER PRIMARY KEY NOT NULL,
    album_owner_id NUMBER NOT NULL,
    album_name VARCHAR2(100) NOT NULL,
    album_created_time TIMESTAMP NOT NULL,
    album_modified_time TIMESTAMP,
    album_link VARCHAR2(100) NOT NULL,
    album_visibility VARCHAR2(100) NOT NULL, 
    cover_photo_id NUMBER NOT NULL,
    FOREIGN KEY (album_owner_id) REFERENCES Users(user_id),
    CHECK (album_visibility IN ('Everyone', 'Friends', 'Friends_Of_Friends', 'Myself'))
);

CREATE TABLE Photos (
    photo_id NUMBER PRIMARY KEY NOT NULL,
    album_id NUMBER NOT NULL,
    photo_caption VARCHAR2(2000),
    photo_created_time TIMESTAMP NOT NULL,
    photo_modified_time TIMESTAMP,
    photo_link VARCHAR2(2000) NOT NULL
);

ALTER TABLE Albums
ADD CONSTRAINT cover_photo_constraint FOREIGN KEY (cover_photo_id) REFERENCES Photos(photo_id) INITIALLY DEFERRED DEFERRABLE;

ALTER TABLE Photos
ADD CONSTRAINT album_constraint FOREIGN KEY (album_id) REFERENCES Albums(album_id) INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE Tags (
    tag_photo_id NUMBER NOT NULL,
    tag_subject_id NUMBER NOT NULL,
    tag_created_time TIMESTAMP NOT NULL,
    tag_x NUMBER NOT NULL,
    tag_y NUMBER NOT NULL,
    PRIMARY KEY (tag_photo_id, tag_subject_id),
    FOREIGN KEY (tag_photo_id) REFERENCES Photos(photo_id),
    FOREIGN KEY (tag_subject_id) REFERENCES Users(user_id)
);

CREATE SEQUENCE city_sequence 
    START WITH 1 
    INCREMENT BY 1;

CREATE OR REPLACE TRIGGER generate_city_id
    BEFORE INSERT ON Cities 
    FOR EACH ROW
        BEGIN 
            SELECT city_sequence.NEXTVAL INTO :NEW.city_id FROM DUAL;
        END;
/

CREATE SEQUENCE program_sequence 
    START WITH 1 
    INCREMENT BY 1;

CREATE TRIGGER generate_program_id
    BEFORE INSERT ON Programs
    FOR EACH ROW
        BEGIN
            SELECT program_sequence.NEXTVAL INTO: NEW.program_id FROM DUAL;
        END;
/