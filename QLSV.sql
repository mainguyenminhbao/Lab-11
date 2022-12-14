create database QLSV
use QLSV
create table Lop(
MaLop char(5) not null primary key,
TenLop nvarchar(20),
SiSo int)
create table Sinhvien(
MaSV char(5) not null primary key,
Hoten nvarchar(20),
Ngaysinh date,
MaLop char(5) constraint fk_malop references lop(malop))
create table MonHoc(
MaMH char(5) not null primary key,
TenMH nvarchar(20))
create table KetQua(
MaSV char(5) not null,
MaMH char(5) not null,
Diemthi float,
constraint fk_Masv foreign key(MaSV) references sinhvien(MaSV),
constraint fk_Mamh foreign key(MaMH) references Monhoc(MaMH),
constraint pk_Masv_Mamh primary key(Masv, mamh))
insert lop values
('a','lop a',0),
('b','lop b',0),
('c','lop c',0)
insert sinhvien values
('01','Le Minh','1999-1-1','a'),
('02','Le Hung','1999-11-1','a'),
('03','Le Tri','1999-12-12','a')
insert monhoc values
('PPLT','Phuong phap LT'),
('CSDL','Co so du lieu'),
('SQL','He quan tri CSDL'),
('PTW','Phat trien Web')
insert KetQua values
('01','PPLT',8),
('01','SQL',7),
('02','PPLT',8),
('01','CSDL',5),
('02','PTW',5)
go