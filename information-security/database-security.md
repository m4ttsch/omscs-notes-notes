---
id: information-security-database-security
title: Database Security
course: information-security
lecture: database-security
---

# Database Security

## Importance of Database Security
Databases store massive amounts of sensitive data. When hackers steal millions of customer records from a company - often containing data like social security numbers, addresses, and credit card numbers - they usually steal this information from one or more databases.

Data often has structure, and databases expose abstractions that help users store their data in structured ways. This data can then be accessed and manipulated using structured queries that we send to the database. **Structured Query Language** (SQL) is a common language for expressing these queries.

Databases store data that is persistent, and the integrity of this data is important. Running a partial query can leave a database in an inconsistent state, which can impact integrity. As a result, queries are often transactional, which means they either run completely or are completely undone.

For example, consider a query that moves money from one account to another account. Both the withdrawal and the deposit must succeed, otherwise both will have to be undone.

When a user executes a query, they can store the result in a virtual database called a **database view**.

For example, a user could query a database of employees and ask for a view that shows the name, address, and phone number, but not the salary, for each employee.

Database views are powerful tool for achieving access control. A database owner can extract some subset of the data and give other users access to only that subset.

## Database Threats Quiz
![](https://assets.omscs.io/notes/DF4376DB-23F1-4197-A713-0D67A365E539.png)

## Database Threats Quiz Solution
![](https://assets.omscs.io/notes/EEA0ABC9-F002-4A9D-8654-81E456D1921D.png)

[Source](http://www.oracle.com/us/products/database/2014-ioug-dba-security-superhero-2338955.pdf)

## Database Hacking Quiz
![](https://assets.omscs.io/notes/BC720089-2712-4976-B060-FF39DC587337.png)

## Database Hacking Quiz Solution
![](https://assets.omscs.io/notes/027DCEF8-3F17-4FD1-8D27-191328C18040.png)


## Relational Database Systems (RDBS) Part 1
Relational databases are widely used in real-world environments.

A relational database consists of **relations**. Relations are also referred to as tables. A table consists of rows and columns.

The columns of a given table describe the attributes of the data to be stored in that table. A database **schema** defines these columns.

For example, we may define the following columns for a table of employees:

- name
- DOB
- salary
- social security number

Tables also have rows. A given row contains a value for each of the attributes as defined by the schema. These rows are called **tuples**.

For example, the tuple for an employee named Bob might look like:

- Bob
- 1/1/1970
- 57,000
- 123-45-6789

Some of the columns in a table hold special values called **keys**. Keys uniquely identify a given tuple. For example, in the above table describing employees, the social security number column contains the key for each tuple since employees can be uniquely identified by this value.

## Relational Database Systems (RDBS) Part 2
Let's look at an example of a relation that contains information about employees.

![](https://assets.omscs.io/notes/66526878-6A01-4729-B187-6E1EB0FAC626.png)

This table defines the following columns:

- Employee name
- Department ID
- Salary Code
- Employee ID
- Employee phone number

Each employee will occupy one row in this table and will have data for each of the columns.

For example, Neil has an employee ID of 5088, a department ID of 13, a salary code of 12, and a phone number.

The employee ID is used to uniquely identify each employee in this table. The employee ID is the **primary key** for this relation.

Sometimes, you want to perform operations across tables.

For example, imagine there is a table of departments that has columns for a department ID and a department name. Suppose you wanted to create a query that selected the name of each employee and the department name (not ID) where each employee works.

We need a way of referencing the departments relation from the employees relation, so we can **join** the two and select the data we want. We can do this using the department ID.

In the employees table, the department ID is a **foreign key**. It references a primary key of another table: the departments table. Foreign keys are used to define relationships between tables and can be used to query those relationships.

## Relational Database Systems (RDBS) Part 3
There are many different operations that we can perform on tables.

We can *create* a table. We can *select* certain information out of a table. We can *insert* new tuples or columns. We can *update* attribute values for certain tuples. We can perform *join* operations to combine multiple tables. We can *delete* tuples, columns, tables, and entire databases.

The following is a SQL query - a selection - that retrieves all of the attribute values for each employee in the above employee relation that works in the department with ID 15.

```sql
SELECT * FROM Employee
WHERE DID = '15';
```

## Key Value Quiz
![](https://assets.omscs.io/notes/83E4EFF2-3CED-4058-AD08-39D3DEFC3A62.png)

## Key Value Quiz Solution
![](https://assets.omscs.io/notes/66B99FB2-D304-43C2-979E-BDA1CAD672A8.png)

A primary key uniquely identifies a row.

## Database Views Quiz
![](https://assets.omscs.io/notes/12C1B7B6-9B61-4C2A-B9CB-55D63FB07E0A.png)

## Database Views Quiz Solution
![](https://assets.omscs.io/notes/8046AD01-9F33-468B-9F3E-2A1D04087814.png)

## Database Access Control
There are two basic SQL commands for implementing database access control.

### Grant
The SQL command for granting privileges has the following syntax.

```bash
GRANT          { privileges | role }
[ON            TABLE]
TO				 { user | role | public }  
[IDENTIFIED BY password]
[WITH          GRANT OPTION]
```

The first line of the command describes what we would like to grant. We can grant either privileges - like `SELECT` - or an entire role, such as admin.

We can optionally scope our grant to a specific table.

Our grant must have a recipient, be it a particular user, role, or *public*. Public refers to the entirety of users/roles that interact with the database.

We can optionally require users to identify themselves using a certain password if they wish to revoke this grant.

Finally, we can optionally allow the grantee to further propagate their access with the `WITH GRANT OPTION`  clause.

For example, if we would like to grant Alice the ability to perform a `SELECT` on any table, and propagate that access to others, we could issue the following command:

```sql
GRANT SELECT ON ANY TABLE TO Alice WITH GRANT OPTION;
```

Alternatively, we could grant access for `INSERT`, `UPDATE` and/or `DELETE`.

### Revoke
The SQL command for revoking privileges has the following syntax.

```bash
REVOKE { privileges | role }
[ON    TABLE]
FROM	 { user | role | public }  
```

The first line of the command describes the privilege or role that we would like to revoke.

We can optionally scope our revocation to a specific table.

Finally, we must revoke access from a particular entity. This entity can be a user, role, or the general public.

For example, to revoke the access we just gave to Alice, we issue the following command:

```sql
REVOKE SELECT ON ANY TABLE FROM Alice;
```

## Database Access Control Quiz
![](https://assets.omscs.io/notes/7D499BB8-5C13-4A36-8CF3-0C3E8F301532.png)

## Database Access Control Quiz Solution
![](https://assets.omscs.io/notes/11C78BAE-41F8-42FC-8AFE-F234639D2D20.png)

## Cascading Authorizations Quiz
![](https://assets.omscs.io/notes/31AD71A2-E008-405D-8F49-8C4A9CA746D9.png)

## Cascading Authorizations Quiz Solution
![](https://assets.omscs.io/notes/4A856303-A0BB-473A-8E98-41306F1E2AE4.png)

## DAC or MAC Quiz
![](https://assets.omscs.io/notes/5947BE2E-48E7-4792-A77C-432EBC939BF2.png)

## DAC or MAC Quiz Solution
![](https://assets.omscs.io/notes/6AED63B6-5A43-4EF8-BDCF-3624B7789381.png)

## Attacks on Databases: SQL Injections Part 1
One famous attack that is carried out against databases is the SQL injection attack.

In an **SQL injection attack**, an attacker sends a malicious command to the database, which allows them to interact with database data in unauthorized ways. The results of this malicious query can result in unauthorized reading and/or writing of data.

These attacks can disclose large amounts of data - an attack on confidentiality - and they can also corrupt data - an attack on integrity.

Understanding how an SQL injection attack is carried out first requires some understanding of common application architecture.

Often, the database resides in the back-end of the system. The front-end of the system that the user interacts with is typically a web application.

The user will present data to the application, often via forms, and the application will translate this data into database queries.

The application will send these queries to the database and then present the results to the user in some informative way.

The SQL injection attack occurs as a result of the application not properly sanitizing the input received from the user before sending that input to the database.

## Attacks on Databases: SQL Injections Part 2
Consider a user interacting with a shipping platform.

Perhaps the application presents the user with a web form that asks them to enter a shipping city and then shows them all of the shipments destined for that city.

The script code might look something like this:

```php
var Shipcity;
Shipcity = Request.form("Shipcity");
var sql = "select * from OrdersTable where Shipcity = '" + Shipcity + "';
```

If the user submits "Redmond" on the form, the SQL query sent to the database becomes:

```sql
SELECT * from OrdersTable where Shipcity = 'Redmond';
```

What if the user submits "Redmond'; DROP table OrdersTable;"?

This SQL query will be sent to the database:

```sql
SELECT * from OrdersTable where Shipcity = 'Redmond'; DROP table OrdersTable;
```

In this case, the user is taking a simple text input field and is injecting SQL into that field to be sent to the database.

The `SELECT` statement will still be executed, but it will be followed by a `DROP table` statement, which will delete all of the orders.

The vulnerability that we have in the web application is that it is not checking input. It is accepting any input and passing it blindly back to the database.

## SQL Injection Defenses
As always, input checking remains a crucial defense for blocking SQL injection. If we assume all input is evil, we will be much more careful with that input before we send it to the database.

In addition, the Open Web Application Security Project (OWASP)  defines a list of [ten proactive controls](https://www.owasp.org/index.php/OWASP_Proactive_Controls) for guarding against common software vulnerabilities, including SQL injection.

## SQL Login Quiz
![](https://assets.omscs.io/notes/29ADEB96-538D-470A-85E1-28D2D25B40AC.png)

## SQL Login Quiz Solution
![](https://assets.omscs.io/notes/6FF291D3-98CE-4AD1-93D7-9A93431D5335.png)

## SQL Login Quiz 2
![](https://assets.omscs.io/notes/7BA1E896-52B9-43EB-A710-2EB5C7170141.png)

## SQL Login Quiz 2 Solution
![](https://assets.omscs.io/notes/87FB43B8-EEE7-4BB8-A3CE-10DFA9911FAE.png)

## Inference Attacks on Databases Part 1
**Inference attacks** occur when a user is able to make inferences about data that they are not authorized to access based on queries that they are authorized to execute.

## Inference Attacks on Databases Part 2
Consider a database of students with the following schema:

- student ID
- student standing (junior/senior)
- exam 1 score
- exam 2 score
- final exam score

Suppose that students are not authorized to execute a query that will reveal another student's exam grade. However, students are authorized to execute a query `Q` that returns the average grade for an exam across all students.

An attacker wants to gain access to the exact score of another student for a particular exam and may be able to infer the grade through via `Q`.

Inference attacks sometimes require some additional outside information. In this case, let's suppose that the attacker knows that the particular student takes the exam late.

The attacker can deduce the exam grade of this student by executing `Q` before the student takes the exam and then again after the student takes the exam.

For example, if there are 10 students in the class and the `Q` returns 100 before the student takes the exam, and 99 after, we can calculate the student's score as:

```bash
99 = (9 * 100 + x) / 10;
990 = 900 + x;
x = 90;
```

Again, the problem demonstrated here is that authorized queries like `Q` allow users to make inferences about data that they are not authorized to access.

## Inference Attacks on Databases Part 3
The previous example might be a little contrived, so let's consider another scenario.

Suppose that `Q` is augmented to allow users to constrain the group of students over which they want to see the average score calculated.

For example, since our database has a field for student year - either junior or senior - suppose `Q-senior` allows students to calculate the average of only seniors and `Q-junior` allows students to calculate the average of only juniors.

A junior might execute `Q-junior` as a way to compare themselves with their peers.

Of course, a problem arises when there are only two juniors present in the class. One junior executing `Q-junior` can easily deduce the score of the other junior.

## Defenses Against Inference Attacks
One way that we can guard against inference attacks is by preventing the access of aggregate information about a set of tuples when the size of that set is too small or too large.

In the most extreme case, aggregate information about a set containing one tuple is simply just the data present in that tuple.

For example, if a group containing one student has an average score of 90 on an exam, that one student scored a 90.

In addition, if you are selecting aggregate information about a set that is very large, the aggregate information roughly holds for everyone, and if it holds for everyone, it holds for a given user as well.

## Defenses Against Inference Attacks Process
We can further defend against inference attacks by removing identifying information from databases. We can **de-identify** the exam score table by dropping the student ID column.

Even with de-identification, inference attacks may still be possible.

For example, if we know that there is one junior in the class, we can still `SELECT` the tuple where the student year is "junior" to reveal information about that student. We must remove or change the student year column to **anonymize** this student.

In addition to de-identification and anonymization, we can use **generalization**. For example, we might generalize the data in the student year column to say either "upperclassmen" or "underclassmen" instead of revealing the exact year.

This still may not be sufficient to defend against inference attacks if the data is not diverse enough.

## SQL Inference Attack Quiz
![](https://assets.omscs.io/notes/972B9CAC-ECD3-40CF-9187-8CA4B3F1E280.png)

## SQL Inference Attack Quiz Solution
![](https://assets.omscs.io/notes/379AB37B-1684-45F6-AD8D-54C00A35629B.png)

## SQL Inference Attack Quiz 2
![](https://assets.omscs.io/notes/0C1BADC4-C735-4958-9274-F9F2DB3E9411.png)

## SQL Inference Attack Quiz 2 Solution
![](https://assets.omscs.io/notes/13759837-A50F-4319-9A86-FDD985C5EE27.png)

Consider the case where one student from a region containing two students retrieves the grade information about that region.
