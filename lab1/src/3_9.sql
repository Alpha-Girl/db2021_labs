# create view borrow_view(读者号,姓名,图书号,书名,借期)
# as select reader.id,reader.name,book.id,book.name,borrow.borrow_date
# from reader,book,borrow
# where reader.id=borrow.Reader_ID and book.id=borrow.book_ID;

select v.读者号,count(图书号) as 借阅的不同图书数 
from borrow_view v 
where floor(year(now())-year(借期)+1/1000*(dayofyear(now())-dayofyear(借期)))<1
group by 读者号;
