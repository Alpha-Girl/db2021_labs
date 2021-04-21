#select check_status();
select * 
from borrow,book 
where borrow.book_id=book.id;