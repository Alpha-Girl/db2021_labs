select book.name,borrow.borrow_date 
from reader,book,borrow 
where reader.name='Rose' and book.id=borrow.book_ID and reader.id=borrow.Reader_ID;