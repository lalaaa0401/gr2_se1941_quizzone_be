-- ============================================================
-- QuizZone – Seed Data (IT / Computer Science)
-- Chạy SAU init.sql:
--   mysql -u root -p quizzone_db < seed_data.sql
-- ============================================================

USE quizzone_db;

-- ============================================================
-- USERS (password tất cả: "12345678")
-- ============================================================
INSERT INTO users (email, password, full_name, avatar_url) VALUES
('an.nguyen@fpt.edu.vn',    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Nguyễn Văn An',    NULL),
('binh.tran@fpt.edu.vn',    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Trần Thị Bình',    NULL),
('cuong.le@fpt.edu.vn',     '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lê Hoàng Cường',   NULL),
('duyen.pham@fpt.edu.vn',   '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Phạm Thị Duyên',   NULL),
('em.hoang@fpt.edu.vn',     '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Hoàng Minh Em',    NULL);

-- ============================================================
-- STUDY SETS (8 bộ thẻ CNTT)
-- ============================================================
INSERT INTO study_sets (title, description, subject, owner_id, is_public) VALUES
('Cấu trúc dữ liệu cơ bản',     'Array, Linked List, Stack, Queue, Tree, Graph, Hash Table',           'Data Structures',  1, 1),
('Giải thuật & Độ phức tạp',     'Big O Notation, Sorting, Searching, Dynamic Programming',             'Algorithms',       2, 1),
('Lập trình hướng đối tượng',    'Encapsulation, Inheritance, Polymorphism, Abstraction, SOLID',        'OOP',              1, 1),
('Cơ sở dữ liệu',                'SQL, Normalization, ACID, Transactions, Indexes, NoSQL',              'Database',         3, 1),
('Mạng máy tính & Giao thức',    'OSI Model, TCP/IP, HTTP, DNS, DHCP, Firewall, REST API',              'Networking',       2, 1),
('Design Patterns (GoF)',        'Creational, Structural, Behavioral – 23 patterns cổ điển',            'Software Design',  4, 1),
('Bảo mật thông tin',            'Encryption, Hashing, JWT, XSS, CSRF, SQL Injection, OAuth 2.0',      'Security',         3, 1),
('Flutter & Dart cơ bản',        'Widget, Provider, Async/Await, State Management cho PRM393',          'Mobile Dev',       5, 1);

-- ============================================================
-- FLASHCARDS – Set 1: Cấu trúc dữ liệu (28 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(1, 'Array (Mảng)',             'Cấu trúc dữ liệu lưu trữ các phần tử cùng kiểu tại các vị trí bộ nhớ liên tiếp. Truy cập O(1), thêm/xoá O(n).', 0),
(1, 'Linked List (Danh sách liên kết)', 'Dãy các node, mỗi node chứa dữ liệu và con trỏ tới node tiếp theo. Thêm/xoá đầu O(1), tìm kiếm O(n).', 1),
(1, 'Singly Linked List',       'Danh sách liên kết đơn: mỗi node chỉ có con trỏ NEXT, duyệt được một chiều từ Head đến Tail.', 2),
(1, 'Doubly Linked List',       'Danh sách liên kết đôi: mỗi node có cả PREV và NEXT, duyệt được hai chiều.', 3),
(1, 'Stack (Ngăn xếp)',         'Cấu trúc LIFO (Last In First Out). Hai thao tác chính: push() thêm vào đỉnh, pop() lấy ra từ đỉnh.', 4),
(1, 'Queue (Hàng đợi)',         'Cấu trúc FIFO (First In First Out). enqueue() thêm vào cuối, dequeue() lấy từ đầu. Dùng trong BFS, print queue.', 5),
(1, 'Deque (Double-ended Queue)','Queue hai đầu: có thể thêm/xoá ở cả hai đầu. Kết hợp tính chất Stack và Queue.', 6),
(1, 'Priority Queue',           'Queue có độ ưu tiên: phần tử có độ ưu tiên cao nhất được lấy ra trước. Thường cài bằng Heap.', 7),
(1, 'Tree (Cây)',               'Cấu trúc phân cấp gồm các node. Node gốc (root), node lá (leaf), các node cha-con. Không có vòng.', 8),
(1, 'Binary Tree',              'Cây mà mỗi node có tối đa 2 con: left child và right child.', 9),
(1, 'BST (Binary Search Tree)', 'Cây nhị phân tìm kiếm: node trái < node hiện tại < node phải. Tìm/thêm/xoá trung bình O(log n).', 10),
(1, 'AVL Tree',                 'BST tự cân bằng: chiều cao của cây con trái và phải chênh nhau không quá 1. Đảm bảo O(log n) trong mọi trường hợp.', 11),
(1, 'Heap',                     'Cây nhị phân hoàn chỉnh. Max-Heap: cha >= con. Min-Heap: cha <= con. Dùng trong Priority Queue và Heap Sort.', 12),
(1, 'Graph (Đồ thị)',           'Tập hợp đỉnh (vertex) và cạnh (edge). Directed/Undirected, Weighted/Unweighted. Dùng trong GPS, mạng xã hội.', 13),
(1, 'Hash Table',               'Cấu trúc dùng hàm băm để ánh xạ key → index. Tìm/thêm/xoá trung bình O(1). Xử lý collision bằng chaining hoặc open addressing.', 14),
(1, 'Collision (Hash)',         'Khi hai key khác nhau được băm ra cùng một index. Giải quyết bằng Chaining (linked list tại slot) hoặc Linear Probing.', 15),
(1, 'BFS (Breadth-First Search)', 'Duyệt đồ thị theo chiều rộng, dùng Queue. Tìm đường đi ngắn nhất trong đồ thị không trọng số. O(V+E).', 16),
(1, 'DFS (Depth-First Search)', 'Duyệt đồ thị theo chiều sâu, dùng Stack hoặc đệ quy. Dùng trong topological sort, phát hiện chu trình. O(V+E).', 17),
(1, 'Trie (Prefix Tree)',       'Cây dùng để lưu trữ chuỗi. Mỗi node đại diện một ký tự. Dùng trong autocomplete, từ điển. Tìm O(L) với L là độ dài chuỗi.', 18),
(1, 'Segment Tree',             'Cây dùng để trả lời truy vấn range (min, max, sum) trong O(log n). Xây dựng O(n), cập nhật O(log n).', 19),
(1, 'B-Tree',                   'Cây cân bằng nhiều nhánh, mỗi node có thể có nhiều key. Dùng trong database index (MySQL InnoDB dùng B+Tree).', 20),
(1, 'Circular Queue',           'Queue dạng vòng: tail kết nối với head. Giải quyết vấn đề lãng phí không gian của Queue tuyến tính.', 21),
(1, 'Adjacency Matrix',         'Ma trận biểu diễn đồ thị: adj[i][j] = 1 nếu có cạnh giữa i và j. Không gian O(V²), kiểm tra cạnh O(1).', 22),
(1, 'Adjacency List',           'Danh sách biểu diễn đồ thị: mỗi đỉnh lưu danh sách các đỉnh kề. Không gian O(V+E), hiệu quả hơn cho đồ thị thưa.', 23),
(1, 'Spanning Tree',            'Cây khung của đồ thị: cây con nối tất cả đỉnh với số cạnh tối thiểu (V-1 cạnh). Prim và Kruskal tìm Minimum Spanning Tree.', 24),
(1, 'Topological Sort',         'Sắp xếp các đỉnh của DAG sao cho với mỗi cạnh u→v, u xuất hiện trước v. Dùng Kahn hoặc DFS.', 25),
(1, 'Dynamic Array',            'Mảng có thể thay đổi kích thước tự động (ArrayList, Vector). Khi đầy, tạo mảng mới gấp đôi và copy. Thêm cuối amortized O(1).', 26),
(1, 'Space Complexity',         'Lượng bộ nhớ thuật toán cần dùng theo kích thước input. Phân tích cả bộ nhớ phụ trợ, không tính input.', 27);

-- ============================================================
-- FLASHCARDS – Set 2: Giải thuật & Big O (24 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(2, 'Big O Notation',        'Ký hiệu mô tả giới hạn trên (worst case) của thời gian/không gian thuật toán theo kích thước input n.', 0),
(2, 'O(1) – Constant',       'Độ phức tạp hằng số: không phụ thuộc n. Ví dụ: truy cập mảng theo index, push/pop Stack.', 1),
(2, 'O(log n) – Logarithmic','Mỗi bước giảm bài toán đi một nửa. Ví dụ: Binary Search, thao tác trên BST cân bằng.', 2),
(2, 'O(n) – Linear',         'Tỉ lệ thuận với n. Ví dụ: duyệt mảng, Linear Search, tính tổng.', 3),
(2, 'O(n log n)',             'Chia để trị hoặc dùng cây. Ví dụ: Merge Sort, Heap Sort, Quick Sort (average).', 4),
(2, 'O(n²) – Quadratic',     'Vòng lặp lồng nhau. Ví dụ: Bubble Sort, Selection Sort, Insertion Sort, so sánh mọi cặp.', 5),
(2, 'O(2ⁿ) – Exponential',   'Mỗi bước tăng gấp đôi. Ví dụ: bài toán tập con (subset), Fibonacci đệ quy không memoization.', 6),
(2, 'O(n!) – Factorial',     'Tệ nhất: thử mọi hoán vị. Ví dụ: Brute-force Travelling Salesman, bài toán permutation.', 7),
(2, 'Bubble Sort',           'So sánh và đổi chỗ cặp kề nhau, "nổi bọt" phần tử lớn về cuối. O(n²) worst/avg. Stable sort.', 8),
(2, 'Selection Sort',        'Mỗi lần chọn phần tử nhỏ nhất còn lại, đặt vào vị trí đúng. O(n²) mọi trường hợp. Unstable.', 9),
(2, 'Insertion Sort',        'Chèn từng phần tử vào đúng vị trí trong phần đã sắp. O(n²) worst, O(n) best (gần sorted). Stable.', 10),
(2, 'Merge Sort',            'Chia đôi → sort từng nửa → merge. O(n log n) mọi trường hợp. Stable. Cần O(n) bộ nhớ thêm.', 11),
(2, 'Quick Sort',            'Chọn pivot, chia về 2 phía < pivot và > pivot, đệ quy. O(n log n) avg, O(n²) worst. In-place.', 12),
(2, 'Heap Sort',             'Xây Max-Heap → liên tục extract max ra cuối. O(n log n) mọi trường hợp. In-place. Unstable.', 13),
(2, 'Binary Search',         'Tìm kiếm trên mảng đã sắp xếp: so sánh với mid, loại bỏ nửa không thể chứa key. O(log n).', 14),
(2, 'Dynamic Programming',   'Tối ưu bằng cách lưu kết quả bài toán con (memoization/tabulation). Áp dụng khi có overlapping subproblems + optimal substructure.', 15),
(2, 'Memoization (Top-down)','DP từ trên xuống: đệ quy + cache kết quả đã tính. Dễ cài đặt hơn, có thể gây stack overflow với n lớn.', 16),
(2, 'Tabulation (Bottom-up)', 'DP từ dưới lên: dùng vòng lặp, điền bảng từ bài toán nhỏ nhất. Không bị stack overflow, thường nhanh hơn.', 17),
(2, 'Greedy Algorithm',       'Luôn chọn phương án tốt nhất tại bước hiện tại (local optimum). Không luôn cho global optimum. Ví dụ: Dijkstra, Kruskal, Activity Selection.', 18),
(2, 'Divide and Conquer',    'Chia bài toán thành sub-problems nhỏ hơn, giải độc lập, kết hợp. Ví dụ: Merge Sort, Quick Sort, FFT.', 19),
(2, 'Dijkstra',              'Tìm đường đi ngắn nhất từ một nguồn trong đồ thị có trọng số không âm. O((V+E) log V) với Priority Queue.', 20),
(2, 'Amortized Analysis',    'Phân tích chi phí trung bình qua nhiều thao tác liên tiếp, dù một thao tác đơn lẻ có thể tốn. VD: Dynamic Array thêm cuối amortized O(1).', 21),
(2, 'Backtracking',          'Tìm giải pháp bằng cách thử → quay lui nếu sai. Ví dụ: Sudoku Solver, N-Queens, tìm mọi hoán vị.', 22),
(2, 'Two Pointers',          'Kỹ thuật dùng 2 con trỏ di chuyển trong mảng để giải bài O(n) thay vì O(n²). Ví dụ: Two Sum (sorted), bài toán container with most water.', 23);

-- ============================================================
-- FLASHCARDS – Set 3: OOP (22 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(3, 'Encapsulation (Đóng gói)',    'Ẩn dữ liệu bên trong class, chỉ cho phép truy cập qua phương thức public. Dùng private field + getter/setter.', 0),
(3, 'Inheritance (Kế thừa)',       'Class con thừa hưởng thuộc tính và phương thức từ class cha. Giảm code lặp, tạo quan hệ IS-A.', 1),
(3, 'Polymorphism (Đa hình)',      'Cùng một interface, nhiều cách thực thi khác nhau. Bao gồm Overloading (compile-time) và Overriding (runtime).', 2),
(3, 'Abstraction (Trừu tượng)',    'Ẩn chi tiết cài đặt, chỉ hiển thị giao diện cần thiết. Cài qua Abstract Class hoặc Interface.', 3),
(3, 'Abstract Class',             'Class không thể khởi tạo trực tiếp, có thể có cả abstract method và concrete method. Dùng từ khóa abstract.', 4),
(3, 'Interface',                  'Hợp đồng quy định class phải implement những method nào. Java/Dart: class có thể implement nhiều interface (đa kế thừa giao diện).', 5),
(3, 'Method Overloading',         'Cùng tên method nhưng khác signature (số lượng hoặc kiểu tham số). Resolved tại compile-time.', 6),
(3, 'Method Overriding',          'Class con định nghĩa lại method đã có ở class cha với cùng signature. Resolved tại runtime (dynamic dispatch).', 7),
(3, 'Constructor',                'Phương thức đặc biệt gọi khi khởi tạo object. Cùng tên với class, không có kiểu trả về. Có thể overload.', 8),
(3, 'S – Single Responsibility',  '[SOLID] Mỗi class chỉ có một lý do để thay đổi, chỉ đảm nhiệm một trách nhiệm duy nhất.', 9),
(3, 'O – Open/Closed Principle',  '[SOLID] Class nên mở để mở rộng (extension) nhưng đóng với sửa đổi (modification). Dùng kế thừa hoặc interface.', 10),
(3, 'L – Liskov Substitution',    '[SOLID] Object của class con phải dùng được thay thế cho class cha mà không làm hỏng chương trình.', 11),
(3, 'I – Interface Segregation',  '[SOLID] Không nên ép class implement interface với method nó không dùng. Tách interface lớn thành nhỏ.', 12),
(3, 'D – Dependency Inversion',   '[SOLID] Module cấp cao không phụ thuộc module cấp thấp; cả hai phụ thuộc Abstraction. Inject dependency qua constructor.', 13),
(3, 'Composition',                'Quan hệ HAS-A: class chứa instance của class khác. Ưu tiên Composition hơn Inheritance khi không có quan hệ IS-A rõ ràng.', 14),
(3, 'Coupling (Độ ghép nối)',      'Mức độ phụ thuộc giữa các module. Loose coupling = tốt: dễ thay đổi, test độc lập. Tight coupling = xấu.', 15),
(3, 'Cohesion (Độ kết dính)',      'Mức độ các phần trong một module liên quan với nhau. High cohesion = tốt: một module làm tốt một việc.', 16),
(3, 'Static Method/Field',        'Thuộc về class, không thuộc instance. Gọi qua tên class. Không truy cập được non-static member.', 17),
(3, 'Generics (Kiểu tổng quát)',   'Cho phép viết code không phụ thuộc kiểu dữ liệu cụ thể. VD: List<T>, Map<K,V>. Type safety tại compile-time.', 18),
(3, 'Immutable Object',           'Object không thể thay đổi sau khi tạo. Thread-safe, dễ debug. Ví dụ: String trong Java, const trong Dart.', 19),
(3, 'Dependency Injection',       'Truyền dependency vào object từ bên ngoài thay vì tự tạo bên trong. Giảm coupling, dễ test bằng mock.', 20),
(3, 'Design by Contract',         'Quy định rõ precondition (input hợp lệ), postcondition (output đảm bảo), và invariant (điều kiện luôn đúng) cho method.', 21);

-- ============================================================
-- FLASHCARDS – Set 4: Cơ sở dữ liệu (24 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(4, 'Primary Key',               'Cột hoặc tổ hợp cột xác định duy nhất mỗi hàng trong bảng. Không NULL, không trùng. Tự động tạo index.', 0),
(4, 'Foreign Key',               'Cột tham chiếu tới Primary Key của bảng khác. Đảm bảo referential integrity: không thể tham chiếu tới bản ghi không tồn tại.', 1),
(4, 'Index (Chỉ mục)',           'Cấu trúc dữ liệu giúp tìm kiếm nhanh hơn (thường là B+Tree). Tăng tốc SELECT nhưng làm chậm INSERT/UPDATE/DELETE.', 2),
(4, '1NF – First Normal Form',   'Mỗi cột chứa giá trị nguyên tử (không phân chia được). Không có nhóm lặp. Bảng có Primary Key.', 3),
(4, '2NF – Second Normal Form',  'Đạt 1NF + mọi non-key attribute phụ thuộc đầy đủ vào toàn bộ Primary Key (loại bỏ partial dependency).', 4),
(4, '3NF – Third Normal Form',   'Đạt 2NF + không có transitive dependency: non-key attribute không phụ thuộc vào non-key attribute khác.', 5),
(4, 'ACID – Atomicity',          'Một transaction phải thực hiện toàn bộ hoặc không thực hiện gì. Nếu lỗi giữa chừng, rollback về trạng thái trước.', 6),
(4, 'ACID – Consistency',        'Database phải ở trạng thái hợp lệ trước và sau transaction. Mọi constraint (FK, CHECK, UNIQUE) phải được thỏa mãn.', 7),
(4, 'ACID – Isolation',          'Các transaction đồng thời không ảnh hưởng lẫn nhau. 4 mức cô lập: READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE.', 8),
(4, 'ACID – Durability',         'Sau khi transaction commit, dữ liệu được lưu vĩnh viễn dù hệ thống crash. Đảm bảo bởi write-ahead logging (WAL).', 9),
(4, 'INNER JOIN',                'Trả về các hàng có giá trị khớp ở cả hai bảng. Hàng không có cặp bị loại bỏ.', 10),
(4, 'LEFT JOIN',                 'Trả về tất cả hàng bảng trái + hàng khớp bảng phải. Bảng phải không khớp → NULL.', 11),
(4, 'Stored Procedure',          'Tập hợp câu SQL được lưu sẵn trong DB, có thể gọi nhiều lần. Giảm network round-trip, tái sử dụng logic.', 12),
(4, 'View',                      'Bảng ảo được định nghĩa bởi câu SELECT. Không lưu dữ liệu thực. Đơn giản hóa query phức tạp, bảo mật data.', 13),
(4, 'Trigger',                   'Procedure tự động chạy khi có INSERT/UPDATE/DELETE trên bảng. Dùng để audit log, enforce business rules.', 14),
(4, 'Transaction',               'Đơn vị công việc gồm nhiều câu SQL, xử lý như một khối. BEGIN → COMMIT (thành công) hoặc ROLLBACK (thất bại).', 15),
(4, 'Deadlock',                  'Hai transaction chờ nhau giải phóng lock, dẫn đến tắc nghẽn vĩnh viễn. DB phát hiện và rollback một trong hai.', 16),
(4, 'CAP Theorem',               'Distributed DB chỉ đảm bảo được 2/3: Consistency, Availability, Partition Tolerance. Không thể có cả ba.', 17),
(4, 'SQL vs NoSQL',              'SQL: schema cố định, ACID, query mạnh (JOIN), scale vertical. NoSQL: schema linh hoạt, scale horizontal, CAP tradeoff.', 18),
(4, 'Sharding',                  'Phân mảnh dữ liệu ngang (horizontal partitioning) ra nhiều server để scale out. Mỗi shard chứa một tập con dữ liệu.', 19),
(4, 'Replication',               'Nhân bản dữ liệu sang nhiều node. Master-Slave: master ghi, slave đọc. Tăng availability và read performance.', 20),
(4, 'ORM (Object-Relational Mapping)', 'Ánh xạ giữa object trong code và table trong DB. Ví dụ: Hibernate (Java), SQLAlchemy (Python). Giảm SQL viết tay.', 21),
(4, 'N+1 Query Problem',         'Anti-pattern: 1 query lấy N bản ghi, sau đó N query con để lấy data liên quan. Giải bằng JOIN hoặc Eager Loading.', 22),
(4, 'Composite Index',           'Index trên nhiều cột. Hiệu quả khi query filter nhiều điều kiện. Thứ tự cột quan trọng (leftmost prefix rule).', 23);

-- ============================================================
-- FLASHCARDS – Set 5: Mạng máy tính (22 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(5, 'OSI Model – Layer 7: Application',  'Tầng ứng dụng: giao diện giữa user và mạng. HTTP, HTTPS, FTP, SMTP, DNS, DHCP.', 0),
(5, 'OSI Model – Layer 4: Transport',    'Tầng vận chuyển: đảm bảo truyền data end-to-end. TCP (reliable) và UDP (unreliable). Port number.', 1),
(5, 'OSI Model – Layer 3: Network',      'Tầng mạng: định tuyến (routing) gói tin giữa các mạng khác nhau. IP Address, Router, Subnet.', 2),
(5, 'OSI Model – Layer 2: Data Link',    'Tầng liên kết dữ liệu: truyền frame trong cùng mạng nội bộ. MAC Address, Switch, Ethernet, Wi-Fi.', 3),
(5, 'TCP (Transmission Control Protocol)', 'Giao thức tin cậy: 3-way handshake (SYN→SYN-ACK→ACK), đảm bảo thứ tự, kiểm soát lỗi. Dùng cho HTTP, email.', 4),
(5, 'UDP (User Datagram Protocol)',      'Giao thức không kết nối, không đảm bảo. Nhanh hơn TCP. Dùng cho streaming video, gaming, DNS lookup.', 5),
(5, 'IP Address (IPv4)',                 'Địa chỉ 32-bit, dạng A.B.C.D, chia thành Network ID và Host ID. Có 5 lớp: A, B, C, D, E.', 6),
(5, 'Subnet Mask',                       'Xác định phần nào của IP là network, phần nào là host. Ví dụ: /24 = 255.255.255.0 = 254 host.', 7),
(5, 'DNS (Domain Name System)',           'Hệ thống phân giải tên miền thành IP. Truy vấn đệ quy qua Root → TLD → Authoritative server.', 8),
(5, 'DHCP',                              'Dynamic Host Configuration Protocol: tự động cấp phát IP, subnet mask, gateway, DNS cho thiết bị kết nối mạng.', 9),
(5, 'HTTP vs HTTPS',                     'HTTP: truyền văn bản thuần, không mã hóa, port 80. HTTPS = HTTP + TLS/SSL, mã hóa, port 443, bảo mật hơn.', 10),
(5, 'HTTP Methods',                      'GET (lấy data), POST (tạo mới), PUT (cập nhật toàn bộ), PATCH (cập nhật một phần), DELETE (xoá).', 11),
(5, 'HTTP Status Codes',                 '2xx: thành công. 3xx: redirect. 4xx: lỗi client (404 Not Found, 401 Unauthorized, 403 Forbidden). 5xx: lỗi server.', 12),
(5, 'REST API',                          'Kiến trúc API stateless: dùng HTTP methods + URL để thao tác tài nguyên. Mỗi request phải tự chứa đủ thông tin.', 13),
(5, 'Stateless vs Stateful',             'Stateless: server không lưu trạng thái giữa các request (REST, HTTP). Stateful: server nhớ ngữ cảnh (TCP connection).', 14),
(5, 'Firewall',                          'Kiểm soát lưu lượng mạng vào/ra dựa trên rules. Packet filter (IP/port), Stateful inspection, Application firewall.', 15),
(5, 'Proxy Server',                      'Server trung gian giữa client và server. Forward Proxy: ẩn client. Reverse Proxy: ẩn server, load balancing (Nginx).', 16),
(5, 'Load Balancer',                     'Phân phối traffic đến nhiều server backend. Thuật toán: Round Robin, Least Connections, IP Hash.', 17),
(5, 'CDN (Content Delivery Network)',    'Mạng phân phối nội dung: cache static content ở nhiều server gần người dùng, giảm latency.', 18),
(5, 'WebSocket',                         'Giao thức full-duplex qua TCP: server và client có thể gửi message bất kỳ lúc nào sau khi kết nối. Dùng cho chat, real-time apps.', 19),
(5, 'SSL/TLS Handshake',                 'Quá trình xác lập kết nối HTTPS: trao đổi certificate, đàm phán cipher suite, tạo session key để mã hóa.', 20),
(5, 'NAT (Network Address Translation)', 'Cho phép nhiều thiết bị trong mạng nội bộ (private IP) chia sẻ một public IP khi ra internet.', 21);

-- ============================================================
-- FLASHCARDS – Set 6: Design Patterns (21 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(6, 'Design Pattern là gì?',    'Giải pháp tái sử dụng cho các vấn đề thiết kế phần mềm phổ biến. Chia 3 nhóm: Creational, Structural, Behavioral.', 0),
(6, 'Singleton',                '[Creational] Đảm bảo chỉ có một instance trong suốt vòng đời app. Private constructor, static getInstance(). Cẩn thận với thread-safety.', 1),
(6, 'Factory Method',           '[Creational] Định nghĩa interface để tạo object nhưng để class con quyết định class cụ thể nào được tạo. Tách code tạo object ra.', 2),
(6, 'Abstract Factory',         '[Creational] Factory tạo ra nhiều loại object liên quan theo "gia đình". VD: UIFactory tạo Button, TextField theo nền tảng (Web/Mobile).', 3),
(6, 'Builder',                  '[Creational] Tách xây dựng object phức tạp thành từng bước. Dùng khi constructor có quá nhiều tham số (telescoping constructor problem).', 4),
(6, 'Prototype',                '[Creational] Tạo object mới bằng cách clone object hiện có thay vì new. Dùng khi tạo object tốn kém.', 5),
(6, 'Adapter',                  '[Structural] Cho phép hai interface không tương thích làm việc cùng nhau bằng cách bọc class này quanh class kia.', 6),
(6, 'Decorator',                '[Structural] Thêm hành vi cho object mà không thay đổi class. Bọc object trong wrapper, mỗi wrapper thêm một tính năng.', 7),
(6, 'Facade',                   '[Structural] Cung cấp interface đơn giản cho subsystem phức tạp. Che giấu sự phức tạp bên trong. VD: API Gateway.', 8),
(6, 'Proxy',                    '[Structural] Object đại diện cho object khác để kiểm soát truy cập. Dùng cho lazy loading, caching, access control, logging.', 9),
(6, 'Composite',                '[Structural] Xây dựng cấu trúc cây, mỗi node có thể là leaf hoặc composite. Client thao tác đồng nhất với đơn lẻ và nhóm.', 10),
(6, 'Observer',                 '[Behavioral] Một subject, nhiều observer. Khi subject thay đổi → tự động notify tất cả observer. Pub/Sub pattern. Flutter Provider dựa trên này.', 11),
(6, 'Strategy',                 '[Behavioral] Định nghĩa nhóm thuật toán, đóng gói từng cái, có thể hoán đổi khi runtime. Thay if-else bằng đa hình.', 12),
(6, 'Command',                  '[Behavioral] Đóng gói request thành object. Hỗ trợ queue, undo/redo, log operations. VD: transaction trong DB.', 13),
(6, 'Template Method',          '[Behavioral] Định nghĩa skeleton của algorithm trong base class, để subclass override từng bước cụ thể.', 14),
(6, 'Iterator',                 '[Behavioral] Cung cấp cách duyệt qua collection mà không expose cấu trúc bên trong. for-each loop dựa trên pattern này.', 15),
(6, 'State',                    '[Behavioral] Cho phép object thay đổi hành vi khi trạng thái nội tại thay đổi. Trông như object thay đổi class.', 16),
(6, 'Chain of Responsibility',  '[Behavioral] Truyền request dọc theo chuỗi handler, mỗi handler quyết định xử lý hay truyền tiếp. VD: middleware pipeline.', 17),
(6, 'MVVM Pattern',             'Model – View – ViewModel: ViewModel giữ state và logic, View bind vào ViewModel. Dùng trong Flutter (Provider), Android (LiveData).', 18),
(6, 'Repository Pattern',       'Tách layer truy cập data ra khỏi business logic. Service chỉ gọi Repository interface, không biết cài đặt cụ thể (SQLite/API/Cache).', 19),
(6, 'Dependency Injection Container', 'Framework quản lý việc tạo và inject dependency tự động. Spring IoC Container, Koin (Android). Giảm boilerplate, dễ test.', 20);

-- ============================================================
-- FLASHCARDS – Set 7: Bảo mật thông tin (20 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(7, 'Symmetric Encryption',     'Mã hóa đối xứng: dùng cùng một key để mã hóa và giải mã. Nhanh hơn asymmetric. VD: AES-256. Vấn đề: trao đổi key an toàn.', 0),
(7, 'Asymmetric Encryption',    'Mã hóa bất đối xứng: public key mã hóa, private key giải mã. Chậm hơn. VD: RSA, ECC. Dùng trong HTTPS handshake.', 1),
(7, 'AES (Advanced Encryption Standard)', 'Thuật toán mã hóa đối xứng chuẩn hiện nay. Key 128/192/256 bit. Dùng trong HTTPS, file encryption, JWT.', 2),
(7, 'RSA',                      'Thuật toán mã hóa bất đối xứng dựa trên bài toán phân tích số nguyên tố. Key 2048/4096 bit. Dùng cho trao đổi key, chữ ký số.', 3),
(7, 'Hashing (Băm)',             'Hàm một chiều: input → fixed-size digest. Không thể đảo ngược. Dùng để lưu password (bcrypt, scrypt) và checksum.', 4),
(7, 'MD5 / SHA-256',             'MD5 (128-bit): đã lỗi thời, bị collision. SHA-256 (256-bit): an toàn hiện tại. SHA-3: thế hệ mới nhất. Dùng trong Git, certificate.', 5),
(7, 'Salt (Password Hashing)',   'Chuỗi ngẫu nhiên thêm vào password trước khi hash. Ngăn rainbow table attack và đảm bảo hai password giống nhau có hash khác nhau.', 6),
(7, 'JWT (JSON Web Token)',      'Token gồm Header.Payload.Signature, mã hóa Base64. Stateless authentication. Payload chứa claims (user_id, exp). Verify bằng secret.', 7),
(7, 'SQL Injection',             'Tấn công chèn SQL vào input để thao túng DB. Phòng chống: parameterized query (prepared statement), không ghép chuỗi SQL.', 8),
(7, 'XSS (Cross-Site Scripting)', 'Tấn công chèn script độc hại vào trang web. Stored XSS, Reflected XSS. Phòng chống: escape output, Content Security Policy.', 9),
(7, 'CSRF (Cross-Site Request Forgery)', 'Lừa browser người dùng gửi request không mong muốn. Phòng chống: CSRF token, SameSite cookie, kiểm tra Origin header.', 10),
(7, 'Man-in-the-Middle Attack',  'Kẻ tấn công chặn giữa client và server. Phòng chống: HTTPS (TLS), certificate pinning, HSTS.', 11),
(7, 'OAuth 2.0',                 'Framework ủy quyền (authorization): cho phép app bên thứ ba truy cập tài nguyên của user mà không cần biết password. 4 grant types.', 12),
(7, 'OpenID Connect (OIDC)',     'Layer authentication trên OAuth 2.0: cung cấp ID Token (JWT) xác nhận danh tính người dùng. Dùng trong "Login with Google".', 13),
(7, 'HTTPS / TLS',               'TLS (Transport Layer Security): mã hóa dữ liệu truyền qua mạng. Certificate xác thực danh tính server. Ngăn eavesdropping.', 14),
(7, 'Brute Force Attack',        'Thử mọi tổ hợp có thể để tìm password/key. Phòng chống: rate limiting, CAPTCHA, account lockout, dùng key dài.', 15),
(7, 'Principle of Least Privilege', 'Mỗi component/user chỉ được quyền tối thiểu cần thiết để hoàn thành công việc. Giảm attack surface.', 16),
(7, 'OWASP Top 10',              'Danh sách 10 lỗ hổng web phổ biến nhất: Injection, Broken Auth, XSS, IDOR, Security Misconfiguration, Vulnerable Components,...', 17),
(7, 'Two-Factor Authentication (2FA)', 'Xác thực 2 bước: something you know (password) + something you have (OTP, hardware key). Tăng độ bảo mật đáng kể.', 18),
(7, 'Certificate Pinning',       'App kiểm tra certificate server phải khớp với certificate được hardcode. Ngăn MITM dù attacker có CA certificate hợp lệ.', 19);

-- ============================================================
-- FLASHCARDS – Set 8: Flutter & Dart (20 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(8, 'Widget',                    'Thành phần cơ bản nhất trong Flutter UI. Mọi thứ đều là Widget: text, button, layout, padding, animation.', 0),
(8, 'StatelessWidget',           'Widget không có trạng thái nội tại. build() được gọi một lần. Dùng cho UI tĩnh không thay đổi (text, icon, image).', 1),
(8, 'StatefulWidget',            'Widget có state có thể thay đổi. setState() trigger rebuild. Gồm 2 class: MyWidget (immutable) và _MyWidgetState (mutable).', 2),
(8, 'BuildContext',              'Handle tới vị trí widget trong widget tree. Dùng để tìm Provider, Navigator, Theme. Không lưu context sau async gap.', 3),
(8, 'setState()',                'Báo cho Flutter rebuild widget và con của nó. Chỉ gọi trong StatefulWidget. Tránh gọi trong dispose() hoặc sau async.', 4),
(8, 'Provider (package)',        'State management library: InheritedWidget đơn giản hóa. ChangeNotifierProvider + Consumer/context.watch() để rebuild khi state đổi.', 5),
(8, 'ChangeNotifier',            'Mixin cung cấp notifyListeners(). ViewModel kế thừa hoặc mixin này. Khi notifyListeners() → Consumer và context.watch() rebuild.', 6),
(8, 'Future<T>',                 'Đại diện cho giá trị có thể có trong tương lai (async operation). Dùng với async/await hoặc .then()/.catchError().', 7),
(8, 'Stream<T>',                 'Chuỗi các sự kiện bất đồng bộ theo thời gian. Dùng FutureBuilder cho Future, StreamBuilder cho Stream.', 8),
(8, 'async / await',             'async: đánh dấu function bất đồng bộ, trả về Future. await: chờ Future hoàn thành. Không block UI thread.', 9),
(8, 'Hot Reload vs Hot Restart', 'Hot Reload: inject code mới vào VM, giữ state, nhanh (~1s). Hot Restart: restart hoàn toàn, xóa state (~3s).', 10),
(8, 'pubspec.yaml',              'File cấu hình Flutter project: tên app, version, dependencies, assets (ảnh, font). Chạy flutter pub get sau khi sửa.', 11),
(8, 'MaterialApp & Scaffold',    'MaterialApp: root widget, cung cấp theme/navigation. Scaffold: layout cơ bản: AppBar, body, floatingActionButton, bottomNavBar.', 12),
(8, 'Navigator & go_router',     'Navigator: quản lý stack màn hình. go_router: routing declarative theo URL, hỗ trợ deep link và nested navigation.', 13),
(8, 'FutureBuilder',             'Widget build UI dựa trên trạng thái của Future: loading → data/error. Dùng cho one-time async fetch.', 14),
(8, 'Dio (HTTP Client)',         'HTTP library mạnh cho Dart/Flutter. Hỗ trợ interceptor (gắn JWT header), timeout, FormData, response parsing.', 15),
(8, 'Null Safety (Sound)',       'Dart 2.12+: biến không thể null trừ khi khai báo với ?. Phát hiện NullPointerException tại compile-time.', 16),
(8, 'const vs final',            'const: giá trị cố định lúc compile-time, share instance. final: gán một lần lúc runtime. Dùng const nhiều → tối ưu rebuild.', 17),
(8, 'Isolate',                   'Đơn vị concurrency trong Dart: chạy code song song, không share memory (giao tiếp qua message). Dùng cho task nặng tránh jank.', 18),
(8, 'Flutter Release APK',       'flutter build apk --release: tạo APK được tối ưu, obfuscated, không có debug info. Cần keystore để sign trước khi lên Play Store.', 19);

-- ============================================================
-- QUIZ RESULTS (dữ liệu mẫu)
-- ============================================================
INSERT INTO quiz_results (user_id, study_set_id, score, total_questions) VALUES
(1, 1, 18, 20), (1, 2, 15, 20), (1, 3, 20, 22), (1, 4, 16, 20),
(2, 1, 20, 20), (2, 5, 18, 22), (2, 6, 14, 20),
(3, 4, 22, 24), (3, 7, 17, 20),
(4, 6, 19, 21), (4, 3, 18, 22),
(5, 8, 20, 20), (5, 1, 16, 20);

-- ============================================================
-- NOTIFICATIONS (dữ liệu mẫu)
-- ============================================================
INSERT INTO notifications (user_id, title, body, type) VALUES
(1, 'Quiz hoàn thành!',        'Bạn đạt 18/20 trong "Cấu trúc dữ liệu cơ bản". Xuất sắc!',        'ACHIEVEMENT'),
(1, 'Nhắc nhở ôn tập',         '"Giải thuật & Độ phức tạp" đã 3 ngày chưa ôn. Học ngay nào!',      'STUDY_REMINDER'),
(2, 'Quiz hoàn thành!',        'Bạn đạt 20/20 trong "Cấu trúc dữ liệu cơ bản". Hoàn hảo! 🎯',    'ACHIEVEMENT'),
(3, 'Study set mới',           '"Bảo mật thông tin" có 20 thẻ mới sẵn sàng để học!',               'SYSTEM'),
(5, 'Quiz hoàn thành!',        'Bạt đạt 20/20 trong "Flutter & Dart cơ bản". Chuẩn bị PRM393!',   'ACHIEVEMENT');

-- ============================================================
-- MESSAGES (chat mẫu)
-- ============================================================
INSERT INTO messages (study_set_id, sender_id, content) VALUES
(8, 5, 'Mọi người học Flutter chưa? Bài Provider mình chưa hiểu lắm'),
(8, 1, 'Provider dùng ChangeNotifier, khi gọi notifyListeners() thì widget Consumer sẽ rebuild. Bạn xem lại video bài 5 nhé!'),
(8, 2, 'Mình recommend xem Flutter docs về state management, rõ lắm. Link: https://docs.flutter.dev/development/data-and-backend/state-mgmt'),
(1, 2, 'BST worst case O(n) khi cây lệch phải không? Vì sao AVL Tree tốt hơn?'),
(1, 1, 'Đúng rồi! BST lệch thành linked list trong trường hợp input đã sorted. AVL tự cân bằng sau mỗi insert/delete nên luôn O(log n).');
