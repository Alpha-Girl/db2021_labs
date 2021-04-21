#insert INTO borrow value('00000001','00000002','2021-02-28',null);
# delete from borrow where book_ID='00000001' and reader_id='00000002';
update borrow set return_date='2021-04-01' where book_ID='00000001' and reader_id='00000002';