delimiter //
drop trigger if exists updateStatus;
create trigger updateStatus
after Insert
On borrow
for each row
begin
    update book set status=1 where id=new.book_id and new.return_date is null;
end //
