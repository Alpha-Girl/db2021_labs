select reader.name
from reader
where reader.id not in (select reader_id from borrow);