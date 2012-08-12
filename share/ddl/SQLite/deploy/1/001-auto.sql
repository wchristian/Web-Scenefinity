-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Aug 12 18:40:00 2012
-- 

;
BEGIN TRANSACTION;
--
-- Table: video
--
CREATE TABLE video (
  video_id INTEGER PRIMARY KEY NOT NULL,
  yt_id text NOT NULL
);
CREATE UNIQUE INDEX video_yt_id ON video (yt_id);
COMMIT