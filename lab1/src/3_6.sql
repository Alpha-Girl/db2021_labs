select reader.name
from reader,
(select Reader_ID,count(book_id) as count_b 
from borrow 
group by Reader_ID) borrow2 
where reader.id=borrow2.reader_ID and count_b>3;