-- Database: E_MUNICIPALITY
https://ahmeti.com.tr/postgresql-turkce-karakter-hatasinin-cozumleri

SELECT * FROM pg_collation;

#Docker container psotgres_db içinde
# Mevcut paketleri listeliyoruz.
locale -a

# Yukarıdaki listede tr_TR veya tr_TR.UTF-8 yoksa ekliyoruz.
sudo locale-gen tr_TR
sudo locale-gen tr_TR.UTF-8

# Son olarak güncelleme yapıyoruz.
sudo update-locale

#CANLI VERITABANI OLUŞTURMAK İÇİN
CREATE DATABASE "E_MUNICIPALITY_LIVE" OWNER='otunctan' ENCODING='UTF-8' LC_COLLATE='tr_TR.UTF-8' LC_CTYPE='tr_TR.UTF-8' TEMPLATE=template0;


SELECT * FROM pg_collation;


create collation "tr_TR.UTF-8" (LOCALE="tr_TR.UTF-8");