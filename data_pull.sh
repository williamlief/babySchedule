sqlite3 /Users/$USER/Library/Messages/chat.db << END_SQL
.mode csv
.header ON
.output messages.csv
SELECT message.text,
    datetime(substr(message.date, 1, 9) + 978307200, 'unixepoch', 'localtime') as date,
    handle.id
FROM message
LEFT JOIN handle
ON message.handle_id = handle.ROWID;
END_SQL
