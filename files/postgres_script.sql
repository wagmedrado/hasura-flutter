drop table if exists comments;
drop table if exists posts;
drop table if exists users;

create table users (
  id serial not null primary key,
  name character varying(100) not null,
  email character varying(100) not null,
  register_date timestamp without time zone not null default now(),
  last_login timestamp without time zone
);

create table posts (
  id serial not null primary key,
  user_id integer not null references users(id) on delete restrict on update restrict,
  title character varying(100) not null,
  description text not null,
  insert_date timestamp without time zone not null default now()
);

create table comments (
  id serial not null primary key,
  post_id integer not null references posts(id) on delete restrict on update restrict,
  email character varying(100) not null,
  comment_text text not null,
  insert_date timestamp without time zone not null default now()
);

insert into users (name, email) values
('Wagne', 'wagmedrado@gmail.com'),
('Dion', 'dion@gmail.com'),
('Tony', 'tony@gmail.com'),
('Will', 'will@gmail.com');

insert into posts (user_id, title, description) values
(1, 'Post by Wagne', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'),
(1, 'Other post by Wagne', 'Apenas um teste ...');
insert into comments (post_id, email, comment_text) values
(2,'wagmedrado@gmail.com','Parabéns pelo excelente conteúdo!'),
(2,'w4gne@hotmail.com','Excelente post!');
