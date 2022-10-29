---
id: databases-methodology-three-design
title: "Methodology III: Design"
course: databases
lecture: methodology-three-design
---

# Methodology III: Design

## Design

As a result of the specification phase of the database application development
methodology, we generated an extended entity-relationship (EER) diagram together
with a set of task decompositions and associated abstract code specifying what
the tasks would do relative to the EER diagram.

Our next phase of the methodology is the design phase. We first concentrate on
data, translating our EER diagram into a relational schema. We then take the
abstract code for the tasks and translate that into abstract code with embedded
SQL that will do to the relational schema what the task was specified to do
through the EER diagram.

![Moving forward from the specification phase to the design
phase.](https://assets.omscs.io/notes/20221027220514.png)

## EER Diagram Review 1

Here is the extended entity-relationship diagram we generated during the
specification phase of the database application development methodology.

![The complete EER diagram for
GTOnline.](https://assets.omscs.io/notes/20221028065440.png)

Users come in two disjoint subtypes, regular and admin users, each of which
inherits property types from the user supertype. All users have a uniquely
identifying email address, a password, and a name - a composite property type
consisting of first and last names. Admin users additionally have a last login
property type, while regular users have several property types: sex, birth date,
current city, hometown, and multi-valued property type interests.

The system contains many schools and employers, uniquely identified by school
and property names. Regular users may attend many schools and work for many
employers. Since a regular user may work for a single employer in different
capacities, each employment has an associated job title. Furthermore, a user may
attend the same school for multiple degrees, so each enrollment has an
associated graduation year.

A regular user can request a friendship with another user who can accept that
friendship. A particular user has a set of friendships they have requested and a
set they have accepted.

Our task in the design phase of the database application development methodology
is to take this extended entity-relationship model and translate it into a
relational database.

## EER Diagram Review 2

Let's concentrate on mapping the portion of the extended entity-relationship
diagram that ties regular users to the schools they attended and the employers
for whom they worked.

![Transforming a segment of the EER diagram into relational database
tables.](https://assets.omscs.io/notes/20221028072906.png)

The entity type `SchoolType` maps to a relation `SchoolType` with a single
column, the primary key `TypeName`. The `School` entity type has an identifying
property type, `SchoolName`, and must be associated with a `SchoolType`. The
relation `School` therefore has a primary key `SchoolName` and a `Type` column
that is a foreign key on `TypeName` in `SchoolType`.

The `Attends` relationship type is a many-many relationship type. In many-many
relationships, the combination of identifying property types from the
participating entity types forms the key in the table. We need `Email` to
identify the regular user and `SchoolName` to identify the school. We can create
an `Attends` relation containing `Email` and `SchoolName`.

Since the `Attends` relationship type has a property type, `YearGraduated`, we
must also incorporate this property into our schema. We can represent this
multi-value by adding a `YearGraduated` column in `Attends`. Thus, the three
columns in the table constitute the key, as each combination of `Email`,
`SchoolName`, and `YearGraduated` is unique.

For example, suppose a student went to Georgia Tech for their undergraduate and
graduate studies. We can represent this in the `Attends` table as two rows:

- user@gatech.edu, Georgia Tech, 2016
- user@gatech.edu, Georgia Tech, 2020

The `Employment` relationship type is also a many-many relationship type. The
structure of this relationship is almost identical to what we just saw with
`School`: the `Employment` relation contains `Email`, `EmployerName`, and
`JobTitle` columns. As we saw with schools, the three columns in `Employment`
constitute its primary key.

For example, suppose a student worked at Google as an engineer and a manager. We
can represent this in the `Employment` table as two rows:

- user@gatech.edu, Google, Software Engineer
- user@gatech.edu, Google, Manager

Notice that in the `Attends` relation, `SchoolName` is a foreign key on
`SchoolName` in the `School` relation. Similarly, `EmployerName` in the
`Employment` relation is a foreign key on `EmployerName` in the `Employer`
relation. In both relations, `Email` is a foreign key on the `Email` column in
the `RegularUser` table.

## Mapping the Super/Subtype

Let's concentrate on the super/subtype relationship connecting users, regular
users, and admin users. We've seen different options for mapping inheritance
relationships based on the parameters of the relationship. Here, we choose to
create a relation for each entity type.

![Transforming a super/subtype relationship into the corresponding relational
database tables.](https://assets.omscs.io/notes/20221028102027.png)

The `User` relation has a primary key, `Email`, along with columns `Password`,
`First Name`, and `Last Name`. Remember that we lose composite property types
when transforming entities into relations, so there is no `Name` column.

We must create the `AdminUser` and `RegularUser` relations and connect them to
the `User` relation. We can accomplish this by adding the `Email` primary key to
both tables, which allows us to join with the `User` table on `Email` to
retrieve the inherited values. Additionally, the `AdminUser` relation has a
`LastLogin` column.

The `RegularUser` table has an additional four columns corresponding to the
property types of the entity: `Sex`, `BirthDate`, `CurrentCity`, and `HomeTown`.
We map the multi-valued property type `Interests` to a new relation, `Interest`,
with `Email` and `Interest` columns. We can represent multiple interests for a
single user as multiple rows in this table. The combination of `Interest` and
`Email` forms the primary key.

Notice that on `AdminUser` and `RegularUser`, the `Email` column is a primary
key, and also, a foreign key on the `Email` column of `User`. It is impossible
to have an `AdminUser` or `RegularUser` who is not also a `User`. Since only
regular users have interests, the `Email` column on `Interest` is a foreign key
on the `Email` column in `RegularUser`.

## Weak Entity Type Mapping

Finally, let's consider how we would incorporate the weak entity type,
`Friendship`, into our relational database schema.

![Mapping the weak entity type friendship to the corresponding database
tables.](https://assets.omscs.io/notes/20221028104345.png)

We have a strong entity type, `RegularUser`, and a weak entity type,
`Friendship`, connected by identifying relationships `Request` and `Accept`. To
uniquely identify an instance of a friendship, we need two references to
`RegularUser`: the email of the user extending the request and the email of the
user receiving the request.

The `Friendship` relation contains an `Email` column that holds the requesting
user's email and a `FriendEmail` column storing the requested user's email.
Furthermore, the `Friendship` entity type has `Relationship` and `DateConnected`
property types, so we add those columns to the table. Initially, `DateConnected`
is `NULL`, only being set when an extended friend request is accepted.

Notice that the `Email` and `FriendEmail` columns are foreign keys on the
`Email` column of `RegularUser`, and the combination of these columns comprises
the key for the `Friendship` table. As we saw in the project description, only
regular users can participate in these friendships.

## Relational Schema

Here is a side-by-side depiction of the original extended entity-relationship
diagram and the resulting relational database schema.

![The final relational database schema and the extended entity-relationship
diagram from which we derived
it.](https://assets.omscs.io/notes/20221028105218.png)
