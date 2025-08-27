-- HMS base schema
CREATE DATABASE IF NOT EXISTS hms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hms;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(190) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(190) NOT NULL,
  role VARCHAR(50) NOT NULL DEFAULT "staff",
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS patients (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  mrn VARCHAR(50) UNIQUE,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  dob DATE,
  sex ENUM("M","F","O") DEFAULT "O",
  phone VARCHAR(50),
  address TEXT,
  emergency_contact JSON NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS problems (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  icd10_code VARCHAR(20),
  title VARCHAR(255) NOT NULL,
  status ENUM("active","resolved") DEFAULT "active",
  noted_at DATETIME,
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS medications (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  name VARCHAR(190) NOT NULL,
  dose VARCHAR(100),
  route VARCHAR(50),
  frequency VARCHAR(50),
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS allergies (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  allergen VARCHAR(190) NOT NULL,
  reaction VARCHAR(190),
  severity ENUM("mild","moderate","severe") DEFAULT "mild",
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS vitals (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  recorded_at DATETIME NOT NULL,
  systolic INT, diastolic INT, pulse INT, resp INT, temp_c DECIMAL(4,1), spo2 INT,
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS appointments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  provider_id BIGINT,
  starts_at DATETIME NOT NULL,
  ends_at DATETIME NOT NULL,
  status ENUM("scheduled","checked_in","completed","cancelled") DEFAULT "scheduled",
  notes TEXT,
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS prescriptions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  drug_name VARCHAR(190) NOT NULL,
  dose VARCHAR(100), route VARCHAR(50), frequency VARCHAR(50), duration VARCHAR(50),
  prescribed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM("new","dispensed","cancelled") DEFAULT "new",
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS inventory_drugs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(190) NOT NULL,
  batch VARCHAR(100),
  expires_on DATE,
  stock INT NOT NULL DEFAULT 0,
  reorder_level INT NOT NULL DEFAULT 0,
  price DECIMAL(10,2) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS inventory_txns (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  drug_id BIGINT NOT NULL,
  qty INT NOT NULL,
  type ENUM("in","out") NOT NULL,
  ref VARCHAR(100),
  occurred_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (drug_id) REFERENCES inventory_drugs(id)
);

CREATE TABLE IF NOT EXISTS lab_orders (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  test_code VARCHAR(50) NOT NULL,
  ordered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM("ordered","processing","completed") DEFAULT "ordered",
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS lab_results (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  parameter VARCHAR(100) NOT NULL,
  value VARCHAR(100), units VARCHAR(50),
  flag ENUM("N","L","H") DEFAULT "N",
  FOREIGN KEY (order_id) REFERENCES lab_orders(id)
);

CREATE TABLE IF NOT EXISTS imaging_orders (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  modality ENUM("XR","CT","MRI","US") NOT NULL,
  study VARCHAR(190) NOT NULL,
  ordered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM("scheduled","in_progress","reported") DEFAULT "scheduled",
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS imaging_reports (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  report TEXT,
  reported_at DATETIME,
  FOREIGN KEY (order_id) REFERENCES imaging_orders(id)
);

CREATE TABLE IF NOT EXISTS departments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(190) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS rooms (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  department_id BIGINT,
  name VARCHAR(100),
  type VARCHAR(50),
  rate DECIMAL(10,2) DEFAULT 0,
  FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE IF NOT EXISTS beds (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  room_id BIGINT,
  bed_no VARCHAR(20),
  status ENUM("vacant","occupied","cleaning") DEFAULT "vacant",
  FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE IF NOT EXISTS bills (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  patient_id BIGINT NOT NULL,
  status ENUM("open","finalized") DEFAULT "open",
  opened_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE IF NOT EXISTS bill_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  bill_id BIGINT NOT NULL,
  item_code VARCHAR(50),
  description VARCHAR(255),
  qty INT DEFAULT 1,
  price DECIMAL(10,2) DEFAULT 0,
  FOREIGN KEY (bill_id) REFERENCES bills(id)
);

CREATE TABLE IF NOT EXISTS payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  bill_id BIGINT NOT NULL,
  method ENUM("cash","card","online") NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  paid_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (bill_id) REFERENCES bills(id)
);

CREATE TABLE IF NOT EXISTS insurance_payers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(190) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS claims (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  bill_id BIGINT NOT NULL,
  payer_id BIGINT NOT NULL,
  status ENUM("draft","submitted","accepted","denied","paid") DEFAULT "draft",
  submitted_at DATETIME NULL,
  FOREIGN KEY (bill_id) REFERENCES bills(id),
  FOREIGN KEY (payer_id) REFERENCES insurance_payers(id)
);

CREATE TABLE IF NOT EXISTS claim_status_events (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  claim_id BIGINT NOT NULL,
  status VARCHAR(50) NOT NULL,
  reason VARCHAR(255),
  occurred_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (claim_id) REFERENCES claims(id)
);

