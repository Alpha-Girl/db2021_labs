select book.id,book.name
from book,reader,borrow
where book.id=borrow.book_ID and 
reader.id=borrow.Reader_ID and 
reader.name='李林' and 
borrow.Return_Date is null;