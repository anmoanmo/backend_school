CREATE TABLE IF NOT EXISTS student_form_records (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    student_no VARCHAR(30) NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    age INTEGER,
    birthday DATE,
    phone VARCHAR(20),
    department VARCHAR(100),
    major VARCHAR(100),
    class_name VARCHAR(100),
    email VARCHAR(100),
    interests VARCHAR(255),
    introduction VARCHAR(1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS uploaded_file_records (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    original_file_name VARCHAR(255) NOT NULL,
    stored_file_name VARCHAR(255) NOT NULL,
    storage_path VARCHAR(600) NOT NULL,
    content_type VARCHAR(200),
    file_size BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
