# Smart-Seat: Automated Exam Hall Allocator 🧩

**Smart-Seat** is a web-based automated Exam Seating Arrangement system designed to eliminate manual efforts and ensure fairness during exams. [cite: 2026-01-05]

## 🚀 Features
* **Bulk Import:** Upload student data directly via CSV/Excel files. [cite: 2026-01-05]
* **Branch Shuffling:** Automatically mixes 2 to 3 different branches on the same bench to prevent copying. [cite: 2026-01-05]
* **Dynamic Hall Mapping:** Efficiently manages hall capacities and student strength. [cite: 2026-01-05]

## ⚙️ The Core Logic: Vertical Allocation
Unlike traditional horizontal filling, this system uses a **Vertical Allocation** algorithm. [cite: 2026-01-05] 

### How it works:
1. The system fills **one entire column** of benches first. [cite: 2026-01-05]
2. Once the column is full, it shifts to the **next column**. [cite: 2026-01-05]
3. Students from different branches are shuffled and placed in a pattern that maximizes distance between classmates. [cite: 2026-01-05]
