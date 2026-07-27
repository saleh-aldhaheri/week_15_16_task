# SQL MERGE Statement

## What is MERGE?

`MERGE` is a SQL statement that compares a **source table** with a **target table** using a join condition, and then, based on the result of that comparison, performs **INSERT**, **UPDATE**, or **DELETE** operations on the target table.

**Example scenario:**
- **Target table:** the current employees stored in the database
- **Source table:** a new employee list just received from HR

`MERGE` compares the two tables and decides what to do row by row:

- If an employee exists in **both** tables → **UPDATE** their information in the target
- If an employee exists **only in the source** table → **INSERT** them as a new employee
- If an employee exists **only in the target** table → **DELETE** them (or handle it another way, depending on the business rule)

## Why Use MERGE?

The main purpose of `MERGE` is to keep the target table synchronized with the source table by comparing rows and applying only the changes that are actually needed.

It also brings a few practical benefits:
- It streamlines the whole synchronization process into a single SQL statement
- It makes the synchronization logic easier to read and maintain
- It removes the need to write separate INSERT, UPDATE, and DELETE statements by hand

**What synchronization looks like without MERGE:**

Without `MERGE`, keeping two tables in sync means writing three separate statements — one to insert new rows, one to update matching rows, and one to delete rows that no longer exist in the source. Since these are three independent statements, each one normally runs as its own transaction, meaning each commits on its own rather than as a single all-or-nothing unit. That's exactly the problem: if the INSERT and UPDATE succeed but the DELETE then fails, the target table is left half-updated — some changes went through, others didn't, and the data is now inconsistent.

To avoid that, all three statements have to be manually wrapped inside one transaction, so that if any one of them fails, everything rolls back together and the table never ends up in a half-synchronized state. `MERGE` gives you that same safety by design, in a single statement, without needing to manage the transaction logic yourself.

**Common use cases:**
1. Synchronizing two tables that are supposed to mirror each other
2. Data warehouse maintenance — typically as part of an **ETL** (Extract, Transform, Load) job that moves data from an operational system into a data warehouse, often used to maintain **Slowly Changing Dimensions (SCD)**

## The General Idea Behind MERGE Syntax

```sql
MERGE target_table AS target
USING source_table AS source

-- merge condition
ON target.id = source.id

-- actions based on the merge result
WHEN MATCHED THEN
    -- perform UPDATE or DELETE

WHEN NOT MATCHED BY TARGET THEN
    -- perform INSERT

WHEN NOT MATCHED BY SOURCE THEN
    -- perform DELETE or other action
```

In short:
- **WHEN MATCHED** — the row is found in both the target and the source
- **WHEN NOT MATCHED BY TARGET** — the row is in the source but doesn't exist in the target yet
- **WHEN NOT MATCHED BY SOURCE** — the row is in the target but no longer exists in the source

## Worked Example

**EMPLOYEE (Target table)**

| id | name  | occupation | salary |
|----|-------|------------|--------|
| 1  | John  | Developer  | 70000  |
| 2  | Sarah | Manager    | 90000  |
| 3  | Mike  | Designer   | 60000  |
| 4  | David | Analyst    | 65000  |
| 5  | Emma  | Tester     | 55000  |

**UPDATED (Source table)**

| id | name  | occupation        | salary |
|----|-------|--------------------|--------|
| 1  | John  | Senior Developer   | 85000  |
| 2  | Sarah | Manager            | 95000  |
| 3  | Mike  | Designer           | 60000  |
| 6  | Ali   | Database Admin     | 75000  |

**Walking through it:**
- **John** — in both tables, but his occupation and salary changed → **UPDATE**
- **Sarah** — in both tables, only her salary changed → **UPDATE**
- **Mike** — in both tables, nothing changed → no update actually needed
- **David** — was in the employee table, but isn't in the updated list anymore → **DELETE**
- **Emma** — same story as David, no longer in the updated list → **DELETE**
- **Ali** — brand new, appears only in the updated list → **INSERT**

**MERGE statement:**

```sql
MERGE employee AS t
USING updated AS s
ON t.id = s.id

-- If employee exists in both tables
WHEN MATCHED THEN
    UPDATE SET
        t.name = s.name,
        t.occupation = s.occupation,
        t.salary = s.salary

-- If employee exists in source but not in target
WHEN NOT MATCHED BY TARGET THEN
    INSERT (id, name, occupation, salary)
    VALUES (s.id, s.name, s.occupation, s.salary)

-- If employee exists in target but not in source
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
```

**Result — the employee table after MERGE:**

| id | name  | occupation        | salary |
|----|-------|--------------------|--------|
| 1  | John  | Senior Developer   | 85000  |
| 2  | Sarah | Manager            | 95000  |
| 3  | Mike  | Designer           | 60000  |
| 6  | Ali   | Database Admin     | 75000  |

---

**Reference**

GeeksforGeeks. *MERGE Statement in SQL Explained.* Retrieved from: http://geeksforgeeks.org/sql/merge-statement-sql-explained/