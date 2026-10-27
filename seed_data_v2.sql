-- ============================================================
-- QuizZone – Seed Data v2 (bổ sung thêm chủ đề CNTT)
-- Chạy SAU seed_data.sql:
--   mysql -u root -p quizzone_db < seed_data_v2.sql
-- ============================================================

USE quizzone_db;

-- ============================================================
-- STUDY SETS (5 bộ thẻ mới – set ID 9 → 13)
-- ============================================================
INSERT INTO study_sets (title, description, subject, owner_id, is_public) VALUES
('DevOps, Docker & Git',         'Container, CI/CD Pipeline, Git workflow, branching strategies',       'DevOps',           1, 1),
('Hệ điều hành (OS)',            'Process, Thread, Deadlock, Memory Management, Scheduling',            'OS',               2, 1),
('JavaScript & TypeScript',      'Closure, Event Loop, Promise, ES6+, TS types',                        'Web Dev',          4, 1),
('Kiến trúc hệ thống (System Design)', 'Scalability, Cache, Message Queue, Microservices, Circuit Breaker', 'Architecture', 3, 1),
('Spring Boot thực hành',        'Annotations, JPA, Security, REST, Exception Handling cho PRM393 BE',  'Java/Spring',      5, 1);

-- ============================================================
-- FLASHCARDS – Set 9: DevOps, Docker & Git (26 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(9, 'Docker Image',              'Template read-only chứa OS + dependencies + app. Được build từ Dockerfile. Chạy image → tạo Container.', 0),
(9, 'Docker Container',          'Instance đang chạy của một Image. Isolated, lightweight. Mỗi container có filesystem, network, process riêng.', 1),
(9, 'Dockerfile',                'Script text chứa các lệnh để build Image: FROM, RUN, COPY, EXPOSE, CMD. Mỗi lệnh tạo một layer mới.', 2),
(9, 'docker-compose',            'Tool quản lý nhiều container cùng lúc qua file YAML. Định nghĩa services, networks, volumes. Một lệnh khởi chạy toàn bộ.', 3),
(9, 'Docker Volume',             'Cơ chế lưu trữ persistent data ngoài container lifecycle. Data không mất khi container bị xoá hoặc restart.', 4),
(9, 'Container vs VM',           'VM: hardware virtualization, có OS riêng, nặng (~GB). Container: OS-level virtualization, share kernel, nhẹ (~MB), khởi động nhanh hơn.', 5),
(9, 'Docker Registry',           'Kho lưu Docker Images. Docker Hub là public registry. Private registry: AWS ECR, Google GCR, Harbor.', 6),
(9, 'Kubernetes (K8s)',          'Platform orchestration container: tự động deploy, scale, restart container. Pod là đơn vị nhỏ nhất, chứa 1+ container.', 7),
(9, 'CI/CD Pipeline',           'Continuous Integration/Continuous Delivery: tự động build → test → deploy mỗi khi có commit. GitHub Actions, Jenkins, GitLab CI.', 8),
(9, 'git init / clone',         'init: tạo repo mới tại thư mục hiện tại. clone: sao chép repo từ remote URL về máy local.', 9),
(9, 'git add / commit',         'add: đưa file vào staging area. commit: lưu snapshot staging area vào lịch sử với message. Không commit → không có history.', 10),
(9, 'git push / pull',          'push: đẩy commits local lên remote. pull = fetch + merge: tải commits từ remote về và merge vào branch hiện tại.', 11),
(9, 'git branch / checkout',    'branch: tạo nhánh phát triển song song. checkout: chuyển branch hoặc file. Nhánh main/master là production.', 12),
(9, 'git merge',                'Kết hợp lịch sử của hai branch. Fast-forward (không tạo merge commit) hoặc 3-way merge (tạo merge commit). --no-ff ép tạo commit.', 13),
(9, 'git rebase',               'Di chuyển/kết hợp commits lên đầu branch khác. Tạo lịch sử tuyến tính sạch hơn merge. KHÔNG rebase public branch.', 14),
(9, 'git cherry-pick',          'Áp dụng một commit cụ thể từ branch khác vào branch hiện tại mà không merge toàn bộ branch.', 15),
(9, 'git stash',                'Tạm lưu thay đổi chưa commit để chuyển sang việc khác. git stash pop để lấy lại. Dùng khi cần hotfix gấp.', 16),
(9, 'git revert vs reset',      'revert: tạo commit mới đảo ngược commit cũ, an toàn với remote. reset: xóa commit khỏi history, nguy hiểm với remote.', 17),
(9, 'Pull Request (PR)',         'Request merge code từ feature branch vào main. Code review, CI check trước khi merge. Best practice cho team dev.', 18),
(9, 'Git Flow',                  'Quy trình branching: main (production) ← develop ← feature branches. Thêm hotfix và release branches. Phù hợp versioned releases.', 19),
(9, 'GitHub Actions',           'CI/CD tích hợp vào GitHub: trigger khi push/PR, chạy jobs trong Docker container. File YAML trong .github/workflows/.', 20),
(9, '.gitignore',               'File liệt kê các file/folder git không theo dõi: build/, node_modules/, .env, *.class. Mỗi dự án có template riêng.', 21),
(9, 'Semantic Versioning',       'v1.2.3 = MAJOR.MINOR.PATCH. MAJOR: breaking change. MINOR: tính năng mới tương thích. PATCH: bug fix. Pre-release: 1.0.0-alpha.', 22),
(9, 'Infrastructure as Code (IaC)', 'Quản lý hạ tầng qua code thay vì thao tác thủ công. Terraform, Ansible, Pulumi. Version control, reproducible, tự động hóa.', 23),
(9, 'Blue-Green Deployment',    'Duy trì hai môi trường giống hệt (Blue=live, Green=new). Deploy lên Green, switch traffic sang Green. Zero-downtime, rollback nhanh.', 24),
(9, 'Environment Variables',    'Biến môi trường để cấu hình app mà không hardcode: DB_URL, JWT_SECRET, API_KEY. Không commit vào git. Dùng .env file local.', 25);

-- ============================================================
-- FLASHCARDS – Set 10: Hệ điều hành (23 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(10, 'Process (Tiến trình)',      'Chương trình đang thực thi với tài nguyên riêng: memory, file handles, PID. Giao tiếp qua IPC (pipe, socket, shared memory).', 0),
(10, 'Thread (Luồng)',            'Đơn vị thực thi trong process. Cùng share memory và tài nguyên với các thread khác trong process. Nhẹ hơn process.', 1),
(10, 'Process vs Thread',         'Process: isolated memory, tạo/hủy tốn kém, an toàn hơn. Thread: share memory, tạo/hủy nhanh, nguy cơ race condition.', 2),
(10, 'Context Switching',         'OS lưu state (registers, PC, stack) của process/thread hiện tại và load state của process/thread tiếp theo. Tốn overhead.', 3),
(10, 'Deadlock',                  'Hai hoặc nhiều process chờ nhau giải phóng tài nguyên, không ai tiến được. 4 điều kiện: Mutual Exclusion, Hold & Wait, No Preemption, Circular Wait.', 4),
(10, 'Mutex (Mutual Exclusion)',  'Lock đảm bảo chỉ một thread truy cập critical section tại một thời điểm. Lock → truy cập → unlock. Binary (0/1).', 5),
(10, 'Semaphore',                 'Biến đếm kiểm soát truy cập vào tài nguyên chia sẻ. Binary semaphore = mutex. Counting semaphore cho phép N thread cùng truy cập.', 6),
(10, 'Race Condition',            'Kết quả chương trình phụ thuộc vào thứ tự thực thi không xác định của nhiều thread. Gây bug khó reproduce. Giải bằng mutex/lock.', 7),
(10, 'Critical Section',          'Đoạn code truy cập tài nguyên chia sẻ, chỉ một thread được vào tại một thời điểm. Bảo vệ bằng mutex/lock.', 8),
(10, 'Virtual Memory',            'Kỹ thuật cấp cho mỗi process không gian địa chỉ ảo độc lập, lớn hơn RAM thực tế. Dùng paging để ánh xạ virtual → physical.', 9),
(10, 'Paging',                    'Chia virtual memory thành pages (4KB), RAM thành frames. Page Table ánh xạ page → frame. Giải quyết external fragmentation.', 10),
(10, 'Page Fault',                'Khi process truy cập page chưa có trong RAM → OS load từ disk vào RAM. Nhiều page fault → thrashing, hiệu năng giảm mạnh.', 11),
(10, 'Thrashing',                 'Hệ thống dành phần lớn thời gian swap pages vào/ra disk thay vì thực thi. Xảy ra khi quá nhiều process cạnh tranh RAM.', 12),
(10, 'FCFS Scheduling',           'First Come First Served: process nào đến trước được chạy trước. Đơn giản nhưng convoy effect (process dài block process ngắn).', 13),
(10, 'Round Robin Scheduling',    'Mỗi process được chạy một time quantum cố định theo vòng. Fair, responsive. Time quantum nhỏ → context switch nhiều. Dùng trong OS hiện đại.', 14),
(10, 'Priority Scheduling',       'Process có priority cao chạy trước. Starvation: process priority thấp có thể không bao giờ chạy. Giải bằng aging (tăng priority theo thời gian chờ).', 15),
(10, 'IPC – Inter-Process Communication', 'Các cơ chế giao tiếp giữa processes: Pipe (one-way), Named Pipe, Message Queue, Shared Memory, Socket. Shared memory nhanh nhất.', 16),
(10, 'System Call',               'Interface giữa user space và kernel. Process gọi OS services qua syscall: open(), read(), write(), fork(), exec(). Chuyển từ user mode sang kernel mode.', 17),
(10, 'User Mode vs Kernel Mode',  'User mode: process chạy với quyền hạn chế, không trực tiếp hardware. Kernel mode: OS chạy với quyền đầy đủ. Cô lập bảo vệ hệ thống.', 18),
(10, 'File System',               'Cách OS tổ chức dữ liệu trên disk. FAT32, NTFS (Windows), ext4 (Linux). Cung cấp: tên file, thư mục, permissions, metadata.', 19),
(10, 'Cache (CPU)',               '3 cấp: L1 (nhanh nhất, nhỏ nhất, trong core), L2 (giữa), L3 (chậm hơn, lớn hơn, share giữa cores). Giảm latency truy cập RAM.', 20),
(10, 'Thrashing giải pháp',       'Working Set Model: giữ lại tập pages đang active của mỗi process. Giảm degree of multiprogramming. Tăng RAM.', 21),
(10, 'Banker''s Algorithm',       'Thuật toán tránh deadlock: kiểm tra xem cấp tài nguyên có dẫn đến unsafe state không. Nếu unsafe → từ chối cấp.', 22);

-- ============================================================
-- FLASHCARDS – Set 11: JavaScript & TypeScript (22 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(11, 'Closure',                   'Function "nhớ" các biến trong scope cha ngay cả sau khi scope cha đã kết thúc. Dùng cho data privacy, memoization, factory functions.', 0),
(11, 'Hoisting',                  'JS đưa khai báo var và function lên đầu scope trước khi chạy. var được hoist (giá trị undefined), let/const không accessible (TDZ).', 1),
(11, 'Event Loop',                'Cơ chế JS xử lý async: Call Stack → Web APIs → Task Queue/Microtask Queue → Stack. Microtask (Promise) ưu tiên hơn Macrotask (setTimeout).', 2),
(11, 'Prototype Chain',           'Mỗi object JS có [[Prototype]]. Khi truy cập property không tồn tại, JS tìm lên chuỗi prototype. Object.prototype là đỉnh chuỗi.', 3),
(11, 'Promise',                   'Object đại diện cho giá trị async: pending → fulfilled/rejected. .then() xử lý thành công, .catch() xử lý lỗi, .finally() luôn chạy.', 4),
(11, 'async / await (JS)',        'Syntax sugar cho Promise. async function trả về Promise. await dừng thực thi trong function cho đến khi Promise resolve. Dùng try/catch cho lỗi.', 5),
(11, 'var vs let vs const',       'var: function-scoped, hoisted, có thể redeclare. let: block-scoped, không hoist, reassignable. const: block-scoped, không reassign (nhưng object/array vẫn mutable).', 6),
(11, 'Arrow Function',            '() => {} syntax ngắn gọn. Không có this riêng (kế thừa từ scope bao ngoài). Không dùng được làm constructor.', 7),
(11, 'Destructuring',             'Unpack giá trị từ array/object. const {name, age} = person. const [first, ...rest] = arr. Dùng với default value và rename.', 8),
(11, 'Spread / Rest Operator',    'Spread (...): mở rộng iterable thành từng phần tử. Rest (...): gom các argument/element còn lại vào array. Cùng ký hiệu, khác ngữ cảnh.', 9),
(11, 'Optional Chaining (?.)',    'Truy cập property/method mà không throw nếu null/undefined. user?.address?.city trả undefined thay vì throw TypeError.', 10),
(11, 'Nullish Coalescing (??)',   'Trả về vế phải nếu vế trái là null hoặc undefined (khác || trả về nếu falsy). name ?? "Anonymous" an toàn hơn name || "Anonymous".', 11),
(11, 'Map, Filter, Reduce',       'Array methods: map → transform mỗi phần tử. filter → lọc phần tử. reduce → tích lũy thành giá trị. Immutable (trả array mới).', 12),
(11, 'TypeScript là gì?',         'Superset của JavaScript: thêm static typing, interface, generic. Compile sang JS. Phát hiện lỗi type tại compile-time. Microsoft phát triển.', 13),
(11, 'TypeScript – Interface',    'Định nghĩa shape của object: {id: number; name: string; email?: string}. Không tạo runtime code. Dùng cho type-checking và documentation.', 14),
(11, 'TypeScript – Type vs Interface', 'Type: linh hoạt hơn (union, intersection, primitive alias). Interface: có thể extends, merge declaration. Convention: interface cho objects, type cho khác.', 15),
(11, 'TypeScript – Generic',      'Viết code với kiểu tham số hóa: function identity<T>(arg: T): T. API<Response> cho phép tái sử dụng với mọi kiểu.', 16),
(11, 'TypeScript – Enum',         'Tập hợp hằng số có tên: enum Status { Active = "ACTIVE", Inactive = "INACTIVE" }. Const enum không tạo runtime object.', 17),
(11, 'TypeScript – Utility Types', 'Partial<T>, Required<T>, Readonly<T>, Pick<T,K>, Omit<T,K>, Record<K,V>. Biến đổi type hiện có mà không viết lại.', 18),
(11, 'this trong JavaScript',     'Tham chiếu đến context gọi function. Thay đổi tùy cách gọi: method call (object), regular function (global/undefined strict), arrow (lexical).', 19),
(11, 'Debounce vs Throttle',      'Debounce: chỉ gọi function sau khi dừng trigger một khoảng thời gian (search input). Throttle: gọi tối đa một lần mỗi khoảng thời gian (scroll).', 20),
(11, 'localStorage vs sessionStorage', 'localStorage: lưu trên trình duyệt không hết hạn, share giữa tabs cùng origin. sessionStorage: mất khi đóng tab, không share. Cả hai đều đồng bộ.', 21);

-- ============================================================
-- FLASHCARDS – Set 12: Kiến trúc hệ thống (22 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(12, 'Vertical Scaling (Scale Up)',   'Tăng sức mạnh một server: thêm CPU, RAM, SSD. Đơn giản nhưng có giới hạn phần cứng và single point of failure.', 0),
(12, 'Horizontal Scaling (Scale Out)', 'Thêm nhiều server chạy song song. Cần Load Balancer phân phối traffic. Không giới hạn lý thuyết. Hệ thống phức tạp hơn.', 1),
(12, 'Load Balancer',                 'Phân phối traffic đến nhiều server. Algorithms: Round Robin, Least Connections, IP Hash. Nginx, AWS ALB. Layer 4 hoặc Layer 7.', 2),
(12, 'Caching',                       'Lưu kết quả tính toán tốn kém để tái sử dụng. Cache hit: trả từ cache (nhanh). Cache miss: tính toán lại + lưu cache. Redis, Memcached.', 3),
(12, 'Cache Invalidation',            'Khi nào xóa/cập nhật cache? TTL (time-based), Write-through, Write-behind, Cache-aside. Cache invalidation là một trong những vấn đề khó nhất CS.', 4),
(12, 'Redis',                         'In-memory data store: key-value, cực nhanh (<1ms). Dùng làm cache, session store, message broker, rate limiter, pub/sub.', 5),
(12, 'Message Queue',                 'Buffer bất đồng bộ giữa producer và consumer. Decoupling, retry, peak smoothing. RabbitMQ (AMQP), Apache Kafka, AWS SQS.', 6),
(12, 'Apache Kafka',                  'Distributed event streaming platform: publish/subscribe theo topic. High-throughput, durable (lưu disk), replay được. Dùng cho event sourcing, real-time analytics.', 7),
(12, 'Microservices',                 'Kiến trúc chia app thành services nhỏ, độc lập, deploy riêng. Pros: scale từng phần, tech stack linh hoạt. Cons: phức tạp hơn, network overhead.', 8),
(12, 'Monolith vs Microservices',     'Monolith: đơn giản, dễ dev, khó scale. Microservices: scale tốt, linh hoạt, nhưng cần giải quyết distributed systems problems.', 9),
(12, 'API Gateway',                   'Entry point duy nhất cho client, route đến các microservices. Xử lý auth, rate limiting, logging, SSL termination. Kong, AWS API Gateway.', 10),
(12, 'Circuit Breaker Pattern',       'Ngăn cascade failure: sau N lỗi liên tiếp, circuit "mở" → fail fast thay vì chờ timeout. Sau cooldown, thử lại (half-open). Hystrix, Resilience4j.', 11),
(12, 'Service Discovery',             'Microservices cần tìm địa chỉ nhau. Client-side (Eureka) hoặc Server-side (Consul + Load Balancer). Dynamic thay vì hardcode IP.', 12),
(12, 'Event Sourcing',                'Lưu trữ chuỗi events thay vì state hiện tại. Replay events để tái tạo state. Audit log tự nhiên, nhưng query phức tạp hơn.', 13),
(12, 'CQRS (Command Query Responsibility Segregation)', 'Tách model ghi (Command) và đọc (Query). Write DB tối ưu cho write, Read DB (có thể là projection/cache) tối ưu cho query.', 14),
(12, 'Saga Pattern',                  'Quản lý distributed transaction: chuỗi local transactions, mỗi bước publish event/message. Khi lỗi → compensating transactions. Choreography vs Orchestration.', 15),
(12, 'Rate Limiting',                 'Giới hạn số request từ một client trong khoảng thời gian. Ngăn abuse và DDoS. Algorithms: Token Bucket, Leaky Bucket, Fixed Window Counter.', 16),
(12, 'CDN (Content Delivery Network)', 'Mạng servers toàn cầu cache static content (JS, CSS, images) gần người dùng. Giảm latency, giảm tải origin server. Cloudflare, CloudFront.', 17),
(12, 'Database Connection Pool',      'Tái sử dụng DB connections thay vì tạo mới mỗi request. HikariCP (Spring Boot default): giảm overhead tạo kết nối, kiểm soát concurrency.', 18),
(12, 'Idempotency',                   'Thực hiện cùng một request nhiều lần cho cùng một kết quả. PUT và DELETE idempotent. POST thường không. Quan trọng trong retry logic.', 19),
(12, 'Health Check',                  'Endpoint /health để monitor system status. Liveness probe: container còn sống không? Readiness probe: sẵn sàng nhận traffic không? Kubernetes dùng cả hai.', 20),
(12, 'Observability (3 pillars)',      'Metrics (Prometheus/Grafana): số liệu hệ thống. Logs (ELK Stack): ghi nhận events. Traces (Jaeger/Zipkin): theo dõi request qua microservices.', 21);

-- ============================================================
-- FLASHCARDS – Set 13: Spring Boot thực hành (22 thẻ)
-- ============================================================
INSERT INTO flashcards (study_set_id, term, definition, position) VALUES
(13, '@SpringBootApplication',   'Kết hợp 3 annotation: @Configuration (bean config), @EnableAutoConfiguration (auto-configure), @ComponentScan (scan beans). Đặt ở main class.', 0),
(13, '@RestController',          '@Controller + @ResponseBody: tất cả method trả về data (JSON) thay vì view template. Dùng cho REST API.', 1),
(13, '@RequestMapping',          'Map HTTP request tới handler method. Kết hợp method + path. Shorthand: @GetMapping, @PostMapping, @PutMapping, @DeleteMapping, @PatchMapping.', 2),
(13, '@PathVariable',            'Lấy giá trị từ URL path: GET /users/{id} → @PathVariable Long id. Khác @RequestParam (query string: /users?id=1).', 3),
(13, '@RequestBody',             'Deserialize request body JSON thành Java object. Dùng với @Valid để trigger Bean Validation (@NotBlank, @Email, @Size).', 4),
(13, '@Service',                 'Đánh dấu class là business logic layer. Spring tự tạo bean và inject. Semantics rõ hơn @Component. Dùng kết hợp với @Transactional.', 5),
(13, '@Repository',              'Đánh dấu class là data access layer. Tự động translate DB exceptions thành Spring DataAccessException.', 6),
(13, '@Autowired vs Constructor Injection', '@Autowired: inject tự động (field/setter). Constructor Injection: inject qua constructor, được khuyến khích hơn (immutable, dễ test, tường minh).', 7),
(13, '@Transactional',           'Wrap method trong transaction. Rollback tự động khi RuntimeException. Attributes: propagation, isolation, readOnly, rollbackFor.', 8),
(13, 'Spring Data JPA – JpaRepository', 'Interface cung cấp CRUD sẵn: findById, findAll, save, delete. Tự generate SQL từ tên method: findByEmailAndStatus, countByUserId.', 9),
(13, '@Entity & @Table',         '@Entity: đánh dấu class là JPA entity (map tới table). @Table(name="users"): chỉ định tên bảng. @Column: cấu hình cột.', 10),
(13, '@Id & @GeneratedValue',    '@Id: đánh dấu primary key. @GeneratedValue(strategy=IDENTITY): auto-increment. @GeneratedValue(strategy=SEQUENCE): dùng sequence DB.', 11),
(13, '@OneToMany / @ManyToOne',  'Quan hệ 1-N. @OneToMany(mappedBy="user"): phía "1". @ManyToOne @JoinColumn(name="user_id"): phía "N", cột FK.', 12),
(13, 'FetchType LAZY vs EAGER',  'LAZY: load liên quan khi truy cập (default cho @OneToMany). EAGER: load ngay lập tức (default cho @ManyToOne). LAZY hiệu quả hơn, tránh N+1.', 13),
(13, '@Query (JPQL)',            'Viết custom query bằng JPQL (entity-oriented) hoặc native SQL (@Query(nativeQuery=true)). @Modifying cho UPDATE/DELETE.', 14),
(13, 'Spring Security FilterChain', 'Chuỗi filter xử lý security: authentication → authorization. Cấu hình qua SecurityFilterChain bean. Thay WebSecurityConfigurerAdapter (deprecated).', 15),
(13, 'JWT Filter trong Spring',  'OncePerRequestFilter: chạy một lần mỗi request. Extract token → validate → set SecurityContext. Đặt trước UsernamePasswordAuthenticationFilter.', 16),
(13, '@ExceptionHandler',        'Xử lý exception trong controller. @RestControllerAdvice: global exception handler cho tất cả controllers. Trả ResponseEntity với status code phù hợp.', 17),
(13, 'ResponseEntity<T>',        'Wrapper cho HTTP response: status code + headers + body. ResponseEntity.ok(data), ResponseEntity.status(201).body(data), ResponseEntity.notFound().build().', 18),
(13, 'springdoc-openapi (Swagger)', 'Tự động generate API documentation từ annotations. Swagger UI tại /swagger-ui.html. @Operation, @Parameter cho custom docs.', 19),
(13, 'application.properties vs YAML', '.properties: key=value, đơn giản. .yml: YAML cấu trúc cây, readable hơn. Profile-specific: application-dev.properties, application-prod.yml.', 20),
(13, 'Spring Actuator',          'Endpoint monitoring: /actuator/health, /actuator/metrics, /actuator/info. Tích hợp Prometheus, Micrometer. Bảo mật endpoint trước khi production.', 21);

-- ============================================================
-- QUIZ RESULTS bổ sung
-- ============================================================
INSERT INTO quiz_results (user_id, study_set_id, score, total_questions) VALUES
(1,  9, 20, 26), (1, 10, 17, 22), (1, 13, 19, 22),
(2, 10, 21, 22), (2, 12, 18, 22),
(3, 12, 20, 22), (3, 13, 22, 22),
(4, 11, 18, 22), (4,  9, 22, 26),
(5, 13, 21, 22), (5, 11, 19, 22);

-- ============================================================
-- NOTIFICATIONS bổ sung
-- ============================================================
INSERT INTO notifications (user_id, title, body, type) VALUES
(1, 'Streak 7 ngày! 🔥',         'Bạn đã học liên tiếp 7 ngày. Tiếp tục chuỗi streak nào!',                'ACHIEVEMENT'),
(2, 'Điểm cao kỷ lục!',           'Bạn đạt 21/22 trong "Hệ điều hành". Điểm cao nhất của bạn!',            'ACHIEVEMENT'),
(3, 'Nhắc nhở ôn tập',            '"Kiến trúc hệ thống" có 22 thẻ chưa ôn trong tuần này.',                 'STUDY_REMINDER'),
(4, 'Study set mới được thêm',    '"Spring Boot thực hành" vừa được tạo – 22 thẻ cho PRM393 BE!',           'SYSTEM'),
(5, 'Quiz hoàn thành!',           'Bạn đạt 21/22 trong "Spring Boot thực hành". Sẵn sàng code BE rồi!',    'ACHIEVEMENT');

-- ============================================================
-- MESSAGES bổ sung
-- ============================================================
INSERT INTO messages (study_set_id, sender_id, content) VALUES
(9,  4, 'Docker vs VM khác nhau điểm nào quan trọng nhất cho interview?'),
(9,  1, 'Điểm chính: Container share OS kernel nên nhẹ (~MB, khởi động giây) vs VM có OS riêng (~GB, khởi động phút). Container không cô lập tuyệt đối như VM.'),
(9,  3, 'Thêm điểm nữa: Docker portable hơn rất nhiều, build once run anywhere thật sự. VM thì environment vẫn có thể drift.'),
(12, 3, 'Circuit Breaker hoạt động như thế nào mọi người?'),
(12, 2, 'Giống cầu dao điện: bình thường CLOSED (cho qua). Sau N lỗi → OPEN (fail fast, không gọi service lỗi). Sau timeout → HALF-OPEN (thử vài request). Nếu OK → CLOSED lại.'),
(13, 5, '@Transactional đặt ở Service hay Repository?'),
(13, 3, 'Đặt ở Service vì một business operation thường gồm nhiều DB operations. Repository chỉ nên xử lý CRUD đơn. Để Spring quản lý transaction boundary ở service layer.');
