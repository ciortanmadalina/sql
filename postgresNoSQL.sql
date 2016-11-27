#http://blog.endpoint.com/2013/06/postgresql-as-nosql-with-data-validation.html
#https://www.postgresql.org/docs/9.5/static/functions-json.html

DROP TABLE reaction;
CREATE TABLE reaction(
    data JSONB,
    CONSTRAINT validate_id CHECK ((data->>'id')::integer >= 1 AND (data->>'id') IS NOT NULL ),
    CONSTRAINT validate_name CHECK (length(data->>'name') > 0 AND (data->>'name') IS NOT NULL )
);

CREATE UNIQUE INDEX reaction_id ON reaction((data->>'id'));
CREATE UNIQUE INDEX reaction_name ON reaction((data->>'name'));

INSERT INTO reaction(data) VALUES('{
    "id": 1,
    "name": "name1",
    "children":[2, 3],
    "type":"start"                             
}');
INSERT INTO reaction(data) VALUES('{
    "id": 2,
    "name": "name2",
    "children":[4],
    "type":"middle"                              
}');
INSERT INTO reaction(data) VALUES('{
    "id": 3,
    "name": "name3",
    "children":[4, 6],
    "type":"middle"                             
}');
INSERT INTO reaction(data) VALUES('{
    "id": 4,
    "name": "name4",
    "children":[5]
}');
INSERT INTO reaction(data) VALUES('{
    "id": 5,
    "name": "name5",
    "children":[],
    "type":"stop"                              
}');
INSERT INTO reaction(data) VALUES('{
    "id": 6,
    "name": "name6",
    "children":[],
    "type":"stop"                              
}');

select * from reaction;



WITH RECURSIVE findroot( parentid, path, childid )
AS
(
    SELECT r.data->>'id', 'Path ' || c  , c FROM reaction r, jsonb_array_elements_text(r.data->'children') c
    UNION ALL
    SELECT r.data->>'id', findroot.path || '->' || c, childid
    FROM reaction r, findroot, jsonb_array_elements_text(r.data->'children') c
    WHERE findroot.parentid = c
)
SELECT path || '->' || parentid, * 
FROM findroot 
WHERE parentid IN (select rp.data->>'id' from reaction rp where rp.data->>'type' = 'start')
and childid IN (select rp.data->>'id' from reaction rp where rp.data->>'type' = 'stop');










select * from node where data->>'id' = '2';

update node 
set data = jsonb_set(data, '{name}' , '"new string value"'::jsonb) ;

UPDATE node SET data = jsonb_set(data, 'name', '"my-other-name"') where data->>'id' = '2';

select version();

CREATE TABLE bla(
    data JSONB,
    CONSTRAINT validate_id CHECK ((data->>'id')::integer >= 1 AND (data->>'id') IS NOT NULL ),
    CONSTRAINT validate_name CHECK (length(data->>'name') > 0 AND (data->>'name') IS NOT NULL )
);

INSERT INTO bla(data) VALUES('{
    "id": 6,
    "name": "name6"
}');
INSERT INTO bla(data) VALUES('{
    "id": 5,
    "name": "name5"
}');
select * from bla;
select * from bla where data->>'id' = '6';
select b.data->'children' from bla b where b.data->>'id' = '6';

select c from bla b, jsonb_array_elements(b.data->'children') c

select i.data->'name' from bla i where i.data->'id' in ('5')
select i.data->'name' from bla i where i.data->'id' in (select c from bla b, jsonb_array_elements(b.data->'children') c)

jsonb_array_elements

UPDATE bla SET data = jsonb_set(data, '{children}', '[5]'::jsonb) ;

