SELECT u.*, p.id FROM users as u JOIN (SELECT name FROM users) AS u2 ON u2.id != u.id JOIN preferences as p ON p.userid = u.id where u.id = :id AND not_id = :id
