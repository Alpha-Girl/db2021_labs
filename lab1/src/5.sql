delimiter $
drop function if exists check_status;
create function check_status()
Returns INT
Reads SQL data
begin
	declare result int default 0;
	select count(*) into result 
    from borrow,book 
    where borrow.book_id=book.id #连接
    and ((borrow.return_date is null and book.status<>1) # 未还且status不为1
		or(borrow.Return_Date is not null and book.status<>0) # 已还且status不为0
	);
    return result;
end $
delimiter ;