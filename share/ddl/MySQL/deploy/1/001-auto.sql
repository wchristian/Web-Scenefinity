-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sun Aug 12 18:40:00 2012
-- 
;
SET foreign_key_checks=0;
--
-- Table: `video`
--
CREATE TABLE `video` (
  `video_id` integer NOT NULL auto_increment,
  `yt_id` text NOT NULL,
  PRIMARY KEY (`video_id`),
  UNIQUE `video_yt_id` (`yt_id`)
);
SET foreign_key_checks=1