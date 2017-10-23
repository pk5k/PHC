#+tplLoadDict:
SELECT * FROM {{property:config.connection.table.name}};


#+tplCreateDictTable:
CREATE TABLE {{property:config.connection.table.name}}
(
	 {{property:config.connection.table.col.key}} VARCHAR(255) NOT NULL PRIMARY KEY,
	 {{property:config.connection.table.col.locale}} VARCHAR(255),
	 {{property:config.connection.table.col.value}} TEXT,
	 {{property:config.connection.table.col.comment}} TEXT
);

#+tplCreateDictEntry:
INSERT INTO {{property:config.connection.table.name}} VALUES ('{{arg:0}}', '{{arg:1}}', '{{arg:2}}', '{{arg:3}}')

#+tplUpdateDictEntry:
UPDATE {{property:config.connection.table.name}} SET {{property:config.connection.table.col.value}} = '{{arg:0}}', {{property:config.connection.table.col.comment}} = '{{arg:1}}' WHERE {{property:config.connection.table.col.key}} = '{{property:key}}' AND {{property:config.connection.table.col.locale}} = '{{property:locale}}'

#+tplDeleteDictEntry:
DELETE FROM {{property:config.connection.table.name}} WHERE {{property:config.connection.table.col.key}} = '{{property:key}}' AND {{property:config.connection.table.col.locale}} = '{{property:locale}}'

#+tplTruncate:
TRUNCATE TABLE {{property:config.connection.table.name}}

#+tplTruncateLocale:
DELETE FROM {{property:config.connection.table.name}} WHERE {{property:config.connection.table.col.locale}} = '{{arg:0}}'
