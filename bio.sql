DROP DATABASE bio;
CREATE DATABASE bio;
\c bio
CREATE SEQUENCE test_id_seq;
CREATE TABLE test (
	id INTEGER DEFAULT NEXTVAL('test_id_seq') primary key,
    value varchar(20) NOT NULL
);

INSERT INTO test(value) VALUES ('value1');
SELECT * FROM test;
