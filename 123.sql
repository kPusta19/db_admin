INSERT INTO product(name, price, producer, article, rating, guarantee, weight) VALUES ('laptop',38599,'Сhina',9237521,4.5,12,1700),
('ssd m2 512gb',7099,'Сhina',5622101,5,60,9),
('washing machine',39999,'Сhina',1442147,3.8,12,59000),
('microwave',4499,'Сhina',1572257,4.7,12,10700),
('tablet',39999,'Сhina',3482234,3.0,12,485),
('smartphone',28299,'Сhina',2748933,4.8,12,215),
('hdd 1tb',4999,'Сhina',5416703,3.5,24,450),
('camera',50119,'Сhina',5416703,4.6,24,475);

INSERT INTO branch(address) VALUES   ('Ap #268-1485 Velit Road'),
  ('Ap #990-9762 Non Avenue'),
  ('Ap #609-8337 Fringilla St.'),
  ('927-5363 Phasellus Road'),
  ('Ap #474-368 Dolor Avenue');

INSERT INTO sclad(address) VALUES ('P.O. Box 321, 2294 Pharetra, St.'),
  ('Ap #642-8989 At, Avenue'),
  ('712-8995 Quam. Ave'),
  ('Ap #929-2012 Diam Ave'),
  ('7859 Dictum St.');

INSERT INTO staff(branch_id, name, passport, position) VALUES
  (1,'Scarlet Langley',3905902291,'store manager'),
  (1,'Larissa Britt',9822524016,'shop assistant'),
  (1,'Gwendolyn Jacobson',4234571289,'shop assistant'),
  (2,'Garth Williamson',8164869527,'store manager'),
  (2,'Cameron Norris',2075615743,'shop assistant'),
  (2,'Thaddeus Turner',2383481206,'shop assistant'),
  (3,'Lars Houston',5314633890,'store manager'),
  (3,'Morgan Blanchard',4008392488,'shop assistant'),
  (3,'Moana Snow',9314830526,'shop assistant'),
  (4,'Dale Price',8259316586,'store manager'),
  (4,'Drew Best',6082180651,'shop assistant'),
  (4,'Lydia Houston',5225542588,'shop assistant'),
  (5,'Burton Edwards',8739566903,'store manager'),
  (5,'Chanda Thompson',7543625600,'shop assistant'),
  (5,'Geoffrey Stevenson',8190089347,'shop assistant');

INSERT INTO buyer(name, telephone, cash, email, birthday) VALUES   ('Alice Baxter','79646458630',6884,'bium@icloud.net','2001-06-30'),
  ('Tanya Vaughn','79792467179',1431,'ac.mi@icloud.org','2000-02-02'),
  ('Lydia Klein','79073346678',2508,'tempor.bibendum@aol.org','2003-04-17'),
  ('Fulton Gould','79241243668',5634,'euismod.ac@icloud.ca','2001-03-17'),
  ('Thomas Sanford','79638384617',5416,'eleifend@hotmail.ca','2002-04-09');

INSERT INTO order_(buyer_id, branch_id) VALUES (1,2), (2,4), (3,1), (4,5), (5,3);

INSERT INTO branch_product(branch_id, product_id, amount) VALUES (1,1,115), (1,2,215), (2,3,98), (2,4,141), (3,5,207), (3,6,225), (4,7,179), (4,8,136), (5,1,126), (5,2,177);

INSERT INTO category(name) VALUES ('household appliances'),('computers'),('smartphones and gadgets'),('laptops'),('tablets'),('washing machines');

INSERT INTO product_category(product_id, category_id) VALUES (1,2),(1,4),(2,2),(3,1),(3,6),(4,1),(5,3),(5,5),(6,3),(7,2),(8,3);

INSERT INTO sclad_product(sclad_id, product_id, amount) VALUES (1,8,115), (1,7,215), (2,6,98), (2,5,141), (3,4,207), (3,3,225), (4,2,179), (4,1,136), (5,3,126), (5,7,177);

INSERT INTO order_product(order_id, product_id, amount) VALUES (1,3,1), (1,4,1), (2,8,1), (3,1,1), (3,2,1), (4,1,1), (4,2,1), (5,5,1);

