SELECT u.*, p.id FROM users as u JOIN preferences as p ON p.userid = u.id where u.id = :id AND not_id = :id
