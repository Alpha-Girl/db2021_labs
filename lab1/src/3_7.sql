select distinct reader.id,reader.name  # 去掉选出来的Reader_ID 
from reader,borrow
where reader.id=borrow.Reader_ID and 
borrow.Reader_ID not in ( # 把有李林借过的书的记录的Reader_ID选出来
select borrow.reader_id 
from borrow 
where borrow.book_id in( # 李林借的书的id
select borrow.book_id 
from borrow,reader 
where reader.id=borrow.reader_id and reader.name='李林'));