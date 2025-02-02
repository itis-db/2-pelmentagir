CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE recipes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE ingredients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    recipe_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    quantity VARCHAR(50) NOT NULL,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id)
);

INSERT INTO users (username, email, registered_at)
SELECT 
    CONCAT('chef_', i) AS username,
    CONCAT('chef_', i, '@example.com') AS email,
    NOW() - (RANDOM() * INTERVAL '365 days') AS registered_at
FROM generate_series(1, 50) AS s(i);

INSERT INTO recipes (user_id, title, description, created_at)
SELECT 
    u.id AS user_id,
    CONCAT('Recipe Title ', s.i) AS title,
    CONCAT('This is the description of recipe number ', s.i, '.') AS description,
    NOW() - (RANDOM() * INTERVAL '30 days') AS created_at
FROM generate_series(1, 150) AS s(i),
     (SELECT id FROM users ORDER BY RANDOM() LIMIT 50) AS u;

	 INSERT INTO ingredients (recipe_id, name, quantity)
SELECT 
    r.id AS recipe_id,
    CONCAT('Ingredient_', s.i) AS name,
    CONCAT(FLOOR(RANDOM() * 500 + 1), ' grams') AS quantity
FROM generate_series(1, 300) AS s(i),
     (SELECT id FROM recipes ORDER BY RANDOM() LIMIT 100) AS r;

SELECT * FROM users;

SELECT r.*, u.username
FROM recipes r
JOIN users u ON r.user_id = u.id;

SELECT i.*, r.title
FROM ingredients i
JOIN recipes r ON i.recipe_id = r.id;