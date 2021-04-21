delimiter $
create procedure re_define_book_id (IN old_book_id char(8),IN new_book_id char(8))
begin
	declare state int default 0;			# 状态
	declare count_borrow INT DEFAULT 0;		# borrow中book_id=old_book_id的记录数
	declare count_book INT default 0;		# book中id=old_book_id的记录数
    declare b_name varchar(10);				# 记录被更新id的书的信息
    declare b_author varchar(10);
    declare b_price int;
    declare b_status int;
	select count(book.id) from book where book.id=old_book_id into count_book; # 查找book中是否有id=old_book_id的记录
    if count_book=0 then
		set state=1;   # 未找到id=old_book_id的记录
	else
		select name,author,price,status into b_name,b_author,b_price,b_status from book where book.id=old_book_id; # 提取被更新id的书的信息 
        insert into book value(new_book_id,b_name,b_author,b_price,b_status); # 插入新id的书的信息
    end if;
    select count(borrow.book_id) from borrow where borrow.book_ID=old_book_id into count_borrow;
    if count_borrow>0 then
		update borrow
        set book_id=new_book_id
        where book_id=old_book_id;
    end if;
    delete from book where id=old_book_id;
end $
delimiter ;