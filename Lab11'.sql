--1.Viết hàm diemtb dạng Scarlar function tính điểm trung bình của một sinh viên bất kỳ
go
create function diemtb (@msv char(5))
returns float
as
begin
 declare @tb float
 set @tb = (select avg(Diemthi)
 from KetQua
where MaSV=@msv)
 return @tb
end
go
select dbo.diemtb ('01')
--2.Viết hàm bằng 2 cách (table – value fuction và multistatement value function) tính điểm trung bình của
cả lớp, thông tin gồm MaSV, Hoten, ĐiemTB, sử dụng hàm diemtb ở câu 1
go
--cách 1
create function trbinhlop(@malop char(5))
returns table
as
return
 select s.masv, Hoten, trungbinh=dbo.diemtb(s.MaSV)
 from Sinhvien s join KetQua k on s.MaSV=k.MaSV
 where MaLop=@malop

 group by s.masv, Hoten
--cách 2
go
create function trbinhlop1(@malop char(5))
returns @dsdiemtb table (masv char(5), tensv nvarchar(20), dtb float)
as
begin
 insert @dsdiemtb
 select s.masv, Hoten, trungbinh=dbo.diemtb(s.MaSV)
 from Sinhvien s join KetQua k on s.MaSV=k.MaSV
 where MaLop=@malop
 group by s.masv, Hoten
 return
end
go
select*from trbinhlop1('a')
--3.Viết một thủ tục kiểm tra một sinh viên đã thi bao nhiêu môn, tham số là MaSV, (VD sinh viên có MaSV=01
thi 3 môn) kết quả trả về chuỗi thông báo “Sinh viên 01 thi 3 môn” hoặc “Sinh viên 01 không thi môn
nào”
go
create proc ktra @msv char(5)
as
begin
 declare @n int
 set @n=(select count(*) from ketqua where Masv=@msv)
 if @n=0
 print 'sinh vien '+@msv + 'khong thi mon nao'
 else
 print 'sinh vien '+ @msv+ 'thi '+cast(@n as char(2))+ 'mon'
end
go
exec ktra '01'
--4.Viết một trigger kiểm tra sỉ số lớp khi thêm một sinh viên mới vào danh sách sinh viên thì hệ thống cập
nhật lại siso của lớp, mỗi lớp tối đa 10SV, nếu thêm vào >10 thì thông báo lớp đầy và hủy giao dịch
go
create trigger updatesslop
on sinhvien
for insert
as
begin
 declare @ss int
 set @ss=(select count(*) from sinhvien s
 where malop in(select malop from inserted))
 if @ss>10
 begin
 print 'Lop day'
 rollback tran
 end
 else
 begin
 update lop
 set SiSo=@ss
 where malop in (select malop from inserted)
 end
--5.Tạo 2 login user1 và user2 đăng nhập vào sql, tạo 2 user tên user1 và user2
--trên CSDL Quản lý Sinh viên tương ứng với 2 login vừa tạo.
--tao login
create login user1 with password = '123'
create login user2 with password = '456'
--hoac
sp_addlogin 'user1','123'
--tao user
create user user1 for login user1
create user user2 for login user2

--hoac
sp_adduser 'user1','user1'
go
--6.Gán quyền cho user 1 các quyền Insert, Update, trên bảng sinhvien,
--gán quyền select cho user2 trên bảng sinhvien
grant Insert, Update on sinhvien to user1
grant select on sinhvien to user2
--7.Tạo một role tên Quanly với đầy đủ các quyền, sau đó thêm use1 và user2
--vào Role này
go
use QLSV --Chọn cơ sở dữ liệu
go
Create role Quanly
Grant select, insert, update to Quanly
exec Sp_AddRoleMember 'Quanly', 'user1'
exec Sp_AddRoleMember 'Quanly', 'user2'
--8.Đăng nhập vào sql bằng login user1, Viết câu lệnh Backup full CSDL,
--sau đó chèn thêm một sinh viên mới vào bảng sinh viên
BACKUP DATABASE QLSV
TO DISK = 'C:\BACKUP\QLSV.Bak'
WITH NOINIT, NAME = 'Full Backup of QLSV'
-----
insert sinhvien values
('12','Le Minh','1999-1-1','B')
--9.Viết câu lệnh backup different CSDL,
BACKUP DATABASE QLSV
 TO DISK = 'C:\BACKUP\QLSV_DIFF.Bak'
 WITH DIFFERENTIAL
--10.Viết câu lệnh xóa CSDL, sau đó viết câu lệnh phục hồi hoàn toàn cơ sở
--dữ liệu
DROP DATABASE QLSV
RESTORE DATABASE QLSV
 FROM DISK = 'C:\BACKUP\QLSV.Bak'

SELECT*FROM SINHVIEN