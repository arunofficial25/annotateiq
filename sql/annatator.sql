CREATE DATABASE Annotation

USE Annotation

CREATE TABLE annotators (
    annotator_id       INT PRIMARY KEY IDENTITY(1,1),
    name               NVARCHAR(100),
    age                INT,
    education_level    NVARCHAR(20)  CHECK (education_level IN ('illiterate', 'primary', 'secondary', 'graduate')),
    region             NVARCHAR(100),
    years_experience   DECIMAL(4,1),
    hourly_rate_inr    DECIMAL(8,2),
    date_joined        DATE,
    employment_type    NVARCHAR(20)  CHECK (employment_type IN ('full_time', 'part_time', 'contract', 'gig'))
);

--Data Insertion
INSERT INTO annotators (name, age, education_level, region, years_experience, hourly_rate_inr, date_joined, employment_type)
VALUES
('Ravi Kumar',        28, 'secondary',  'Punjab',         2.0, 120.00, '2022-03-15', 'full_time'),
('Sunita Devi',       34, 'primary',    'Bihar',          1.5,  95.00, '2022-07-01', 'contract'),
('Amit Sharma',       26, 'graduate',   'Delhi',          3.0, 180.00, '2021-11-20', 'full_time'),
('Priya Patel',       29, 'secondary',  'Gujarat',        2.5, 130.00, '2022-01-10', 'full_time'),
('Mohammed Rafiq',    31, 'primary',    'Uttar Pradesh',  1.0,  90.00, '2023-02-14', 'gig'),
('Lakshmi Naidu',     27, 'graduate',   'Andhra Pradesh', 3.5, 175.00, '2021-06-05', 'full_time'),
('Deepak Yadav',      35, 'secondary',  'Rajasthan',      4.0, 140.00, '2020-09-12', 'full_time'),
('Anjali Singh',      24, 'graduate',   'Maharashtra',    1.0, 160.00, '2023-05-18', 'part_time'),
('Ramesh Gupta',      42, 'illiterate', 'Bihar',          0.5,  75.00, '2023-08-01', 'gig'),
('Fatima Shaikh',     30, 'secondary',  'Maharashtra',    2.0, 125.00, '2022-04-22', 'contract'),
('Suresh Babu',       38, 'primary',    'Tamil Nadu',     1.5,  98.00, '2022-10-30', 'gig'),
('Kavya Reddy',       25, 'graduate',   'Telangana',      2.0, 170.00, '2022-06-15', 'full_time'),
('Harpreet Kaur',     32, 'secondary',  'Punjab',         3.0, 135.00, '2021-08-20', 'full_time'),
('Mohan Lal',         45, 'illiterate', 'Uttar Pradesh',  0.5,  72.00, '2023-09-05', 'gig'),
('Pooja Mishra',      27, 'graduate',   'Madhya Pradesh', 2.5, 165.00, '2022-02-28', 'full_time'),
('Arjun Nair',        29, 'secondary',  'Kerala',         2.0, 128.00, '2022-05-11', 'contract'),
('Geeta Kumari',      36, 'primary',    'Jharkhand',      1.0,  88.00, '2023-03-17', 'gig'),
('Vikram Chauhan',    31, 'secondary',  'Haryana',        3.5, 142.00, '2021-12-01', 'full_time'),
('Nisha Verma',       28, 'graduate',   'Uttar Pradesh',  1.5, 158.00, '2022-09-25', 'part_time'),
('Santosh Patil',     40, 'primary',    'Karnataka',      2.0, 105.00, '2022-08-08', 'contract');