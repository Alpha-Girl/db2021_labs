delimiter $$
drop trigger if exists updateStatus_1;
create trigger updateStatus_1
after Update
On borrow
for each row
begin
    update book set status=0 where id=new.book_id and new.return_date is not null;
end $$
