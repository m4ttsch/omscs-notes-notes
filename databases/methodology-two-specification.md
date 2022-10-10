---
id: databases-methodology-two-specification
title: "Methodology II: Specification"
course: databases
lecture: methodology-two-specification
---

# Methodology II: Specification

## Requirements 6

The login screen has form fields for a user's email address and password, and
the registration screen has additional fields for first name and last name.
Furthermore, the customer requirements state that a user is uniquely identified
by their email address. Using this information, we can model a `User` entity
type with the following property types:
  
- `Email` - an identifying property type
- `Name` - a composite property type, composed of `FirstName` and `LastName`
- `Password` - a single-valued property type

## Use Attribute Names

The form fields in the edit profile screen show that several additional
attributes are necessary for our `User` entity type. The `Sex`, `BirthDate`,
`CurrentCity`, and `HomeTown` attributes all take single values, while
`Interests` is a multi-valued property type.

Notice that we are careful to use the names provided on the documents in the EER
diagram. For example, we translate the "Current City" form field into a
`CurrentCity` property type. By tying the EER diagram closely to the reality
expressed in the requirements, we create a high-quality model of that reality.

## Requirements 7

Here's another requirement: All GTOnline users except administrative users have
a profile. As it turns out, we have two types of users: regular and admin users.
The `User` entity type now becomes a supertype with two subtypes: `RegularUser`
and `AdminUser`.

An additional requirement says that admin users have some of the same
information as regular users - namely, email address, password, first name, and
last name - but not any of the details found in the profiles of regular users.
Therefore, we can keep the `Email`, `Password`, and `Name` property types on
`User` but must move the `Interests`, `Sex`, `BirthDate`, `CurrentCity`, and
`HomeTown` property types to the `RegularUser` entity type.

Furthermore, the requirements state that a user must be either an admin user or
a regular user, but never both. We can reflect this requirement in our diagram
by making the supertype-subtype relationship mandatory and adding the disjoint
marker.

Finally, we need to store the datetime of each admin user's last login. We can
add a `LastLogin` property type directly on the `AdminUser` entity type.

Here is the completed extended entity-relationship diagram expressing all of
these requirements.

![The GTOnline EER diagram with admin users and regular users inheriting from a
user supertype.](https://assets.omscs.io/notes/20220922142348.png)

## Requirements 8

Let's turn to the education section of the edit profile screen. The requirements
document says that the system administrator maintains the list of schools from
which the user can select, and the school names must be unique. From this
information, we can create a `School` entity type with a `SchoolName`
identifying property type.

A regular user can attend zero or more schools. Likewise, a school can have zero
or more users in attendance, so we create an N-M relationship type connecting
the `RegularUser` and `School` entity types. Each unique instance of a
relationship between a regular user and a school has an associated graduation
year. Since a regular user may attend the same school for different levels of
education - bachelor's and master's, for example - this `YearGraduated` property
type is multi-valued.

There are four types of schools currently: elementary school, middle school,
high school, and college/university. Thus, we have a `SchoolType` entity with a
`TypeName` identifying property type. Since one `SchoolType` can describe many
`School`s and one `School` may have multiple `SchoolType`s, the two entity types
are in an N-M relationship.

## Requirements 8.1

Let's now look at the professional section of the edit profile screen. The
requirements document says that the system administrator maintains the list of
employers from which the user can select, and the employer names must be unique.
From this information, we can create an `Employer` entity type with an
`EmployerName` identifying property type.

A regular user can work for zero or more employers. Likewise, an employer can
employ zero or more regular users, so we create an N-M relationship type
connecting the `RegularUser` and `Employer` entity types. Each unique instance
of a relationship between a regular user and an employer has an associated job
title. Since a regular user may hold different roles at the same employer -
engineer and manager, for example - this `JobTitle` property type is
multi-valued.

## Requirements 9

A regular user can send friend requests to other regular users. We can create an
entity type called `Friendship` and connect it back to the `RegularUser` via a
`Request` relationship. Since a single user can issue many friend requests, this
relationship has a 1-N cardinality. Notice that `Friendship` is a weak entity
type since it cannot exist without a `RegularUser`.

The pending requests section shows the list of users that have sent us friend
requests and the list of users with whom we have requested to be friends. The
`Accept` relationship connects a `RegularUser` to a recently accepted
`Friendship`. One regular user may accept friend requests from multiple users,
so the cardinality of the `Accept` relationship is also 1-N.

The requirements ask us to record the date the two friends connected and the
name of the relationship so we can add the `DateConnected` and `Relationship`
property types to `Friendship`. Interestingly, our requirements say that
friendships are not reciprocal; because Emily is friends with Sarah, this does
not imply that Sarah is friends with Emily.

## EER Mapping

Here is the complete extended entity-relationship diagram for GTOnline.

![The complete EER diagram for the GTOnline system.](https://assets.omscs.io/notes/20220925231028.png)

We have a collection of users who are uniquely identified by their email
addresses. Users also have passwords and names, the latter of which is composed
of first name and last name. A user must either be a regular user or an admin
user, but not both, as we can see from the disjoint constraint.

Regular users have profiles that contain information about their sex, birthday,
current city, hometown, and interests. The only information we save about admin
users is their last login time.

A regular user may have attended multiple schools, and a school may have
multiple regular users enrolled. The school's name is identifying, and each
school must have a school type, identified by a school type name.

A regular user may have worked for many employers, and a single employer may
employ many regular users. A particular employee may hold multiple job title
names for a particular employer. Employer names are unique.

Regular users can request and accept multiple friendships. We record the
acceptance date and the name of the relationship - coworker, friend, husband,
etc. - for each friendship.

## Reading EER Diagrams

Our summary of the extended entity-relationship model was quite mechanical. We
could write a program that would take an EER diagram as input and then output
its meaning in English. When we talk with our customers about a database
specification, they will not be able to understand the EER diagram, but they
might understand its representation in English. Of course, we must carefully
consider every word in that summary.

## Data Formats: Beg, Steal, Borrow

We have now specified the database using an extended entity-relationship
diagram. Let's next consider which data formats we need since we will eventually
need to implement our diagram using concrete data types inside a relational
database.

Let's start with formatting the `User` entity type. `Email` is a string with up
to 36 characters. `Password` is also a string with some lower bound and a
maximum of 20 characters. We constrain `FirstName` to be at most 25 characters
and `LastName` to a max of 40 characters. We expect `BirthDate` in 'YYYY-MM-DD'
format. `Sex` can be either 'M' or 'F'. `CurrentCity` and `HomeTown` can have up
to 20 characters each, and each `Interest` can have up to 16 characters.

> Some data formats, such as addresses, are not so easy to discern. The USPS
> issued a 200+ page guideline for formatting addresses across the world.
> Specifications like these take specialists a long time to develop. If someone
> has already thought about this problem long and hard, why would we too?
> Instead of reinventing the wheel, Professor Mark says that the basic concepts
> of data formatting are "beg", "steal", and "borrow".

To determine the data formats, we need to examine the input and output
documents, and we might need to consult with our customers to understand their
needs further. The formats we just defined were for example purposes only, as
they were not precisely stated in the requirements document we read previously.

## Constraints

We already expressed some constraints in the extended entity-relationship
diagram and others in the data formatting exercise. We should not reiterate
those constraints here. What we have left to specify are the rules that we
cannot express in database logic or data formats alone. The application program
must enforce these rules, such as:

- The `DateConnected` property type must be `NULL` until a friend request is
  accepted.
- You cannot be friends with yourself; a friendship cannot be between you and
  you.
- You can only comment on the status of friends. The application system should
  reject incoming comments on non-friend statuses.

## Task Decomposition

Let's now turn our attention to the specification of tasks. For each task we
identified in the information flow diagram, we need to decide whether it's a
single task or needs to be decomposed into subtasks.

Let's look at some rules of thumb. From a database management perspective,
there's a big difference between a task involving only database lookups and one
modifying the database through insertion, deletion, or update. If many different
things are taking place in a task, we ought to decompose it.

The second rule of thumb concerns how large of a portion of the database is
involved in the operation. The larger the slice, the harder it is to acquire all
the locks needed to support the concurrent execution of transactions on the
database. If many schema constructs are involved, we might want to decompose the
task.

The next rule of thumb looks at the enabling conditions for different portions
of a task. The smaller the portions of a task that can run, the easier it is to
schedule the task. If some portion of a task can run now, why not let it proceed
instead of waiting until later when there might not be resources available?

The next rule of thumb focuses on the frequencies of the operations performed by
the task. If the task mixes high and low-frequency operations, it is a good idea
to split these operations apart. High-frequency tasks should be indexed to run
fast, whereas low-frequency tasks do not need such optimizations.

The next rule of thumb concerns database consistency. Is it essential that we
complete all pieces of a task in one transaction, or is it okay if we spread out
operations over time? For example, consider transferring money between bank
accounts. We must subtract from the balance of the sending account and add to
the balance of the receiving account in one transaction to maintain consistency.

The final rule of thumb concerns whether a mother task is needed to control
subtasks. The banking example above certainly needs a mother task, though not
all tasks have this requirement.

## Web Apps Vs. Traditional Apps

Before we look at some examples of task decomposition, let's briefly compare
web-based and traditional applications.

Traditionally, web-based applications are almost entirely stateless. The amount
of state may be as little as the login information for the session user and a
small stream of click data. Such applications are changing, and with new
technologies such as AJAX, it is now possible to add much more state to these
applications. As a result, they are beginning to resemble traditional
applications.

Traditional applications have a much easier time managing local state separate
from the database. Unlike web apps, which need to take a round trip to the
database every time something changes, traditional apps can collect many changes
before submitting them to the database management system for execution.
Traditional applications also support better control of ACID transaction
execution.

Fortunately, web app technology is moving closer to traditional app technology.
Understanding the differences between web and traditional apps is crucial as we
consider examples of task decomposition.

## Task Decomposition: View Profile

Let's use our rules of thumb to potentially decompose the view profile task that
supports the view profile screen.

The screen involves three lookups: a personal, educational, and professional
information lookup for a regular user. All three lookups are read-only and do
not involve any modifications to the database. They are enabled by a user's
login or a friend's lookup, and they all have the same frequency.

As we can see from the extended entity-relationship diagram, this task involves
many schema constructs. Consistency is not critical for this task, as it doesn't
matter if we see the absolute most up-to-date version of this information.

Furthermore, the system can complete the three lookup tasks in any order, not
necessarily in the order in which they appear on the screen. However, we need
all three lookups to display the information on the screen, so we need a
coordinating mother task.

Most of these observations indicate that we should split this task into three
subtasks. Thus, the view profile task becomes the view personal, view education,
and view professional subtasks.

## Abstract Code: View Profile

The first step in the view profile task is to find the current user via their
email. With the current user in hand, we can display their name on the view
profile output document. Using the user email again, we can look up the
`RegularUser` entity type instance and display the user's sex, birth date,
current city, hometown, and interests in that output document.

Next, we have to find each school that the user has attended. We display the
school name, the associated school type name, and the graduation year for each
school. Additionally, we have to find each job that the user has had. For each
of the `N` employers the user has worked for, we display the employer name and
the job titles.

While the abstract code doesn't have a specific syntax, we try to enumerate the
steps that must occur as precisely as possible. This abstract code is the
penultimate step before writing queries in SQL against an actual relational
database.

## Task Decomposition: Edit Profile

Let's look at decomposing the edit profile task, which supports the edit profile
input/output document. The only enabling condition for this task is that the
user is logged in.

We first have to look up the user's personal, educational, and professional
information before we can start editing it. Fortunately, we just specified the
view profile task, which we can reuse for this task. Additionally, we must look
up the reference lists of schools and employers in the database. Without this
data, we cannot populate the dropdown menus.

The edit profile task may involve editing a user's personal, educational, or
professional information or some combination therein. Database insertions and
deletions are possible if the user adds or removes a school or employer. If the
user edits some information, such as their current city, the system must update
that value in the database. This task can touch several different schema
constructs.

The distinct operations in this task occur with slightly different frequencies.
Some information will not change, like sex and birth date, but the interests and
current city might. The education information won't change too often, but the
job history may change over time.

Consistency here is not critical. If someone else is looking up this profile as
the owner is updating it, they don't need to see the most recent version in
real-time.

A mother task is needed here, as there's some sequencing of what needs to take
place. For example, the system needs to first lookup reference information
(schools/employers) and only then be available to receive edits or perform
additional lookups. As a result, we should decompose this task into the
following subtasks:

- a read-only view profile subtask
- an update personal information subtask
- an add/delete schools subtask
- an add/delete jobs subtask

Updating the personal information impacts the user only, while adding or
deleting a school impacts both the user and school, and adding or deleting an
employer impacts both the user and employer.

## Abstract Code: Edit Profile

The first step in this task is to execute the view profile task, which will
populate the user's details and the reference data in the school and employer
dropdown lists. The next step is to: do nothing. As long as the user doesn't
click any add/save/delete buttons, we don't need to do anything.

If the user clicks the save personal information button, we update the personal
information and re-run the view profile task to display the new state.

If the user clicks the add school button, we re-run the view profile task and
display the screen with room to add another school. If they click the save
school button, we add the school to the database, re-run the view profile task,
and display the edit profile screen. If the user clicks the delete school
button, we delete the school and run the view profile task to redisplay this
screen.

If they click the add job button, re-run the view profile task and display the
screen with room to add another job. If they click the save job button, then run
the add job task and re-run the view profile task to see the new information. If
they click the delete job button, then we delete the job and re-run the view
profile task.

Finally, if the user presses cancel, we run the view profile task for the
current user and display that screen.

## Task Decomposition: Friend Requests

Let's quickly examine task decomposition for friend requests. We can extract a
create friend request subtask that updates the database with the new request and
supports the request new friend form. The view, cancel, accept, and reject
friend request subtasks support the friend requests view and the actions taken
therein. The view request subtask supports reading user and friendship
information, and the accept, reject and cancel request subtasks update the
friendship relationship type in the database.

## Specification

We have now completed the specification phase of our database development
methodology. We have generated an extended entity-relationship diagram, looked
at data formats and constraints, decomposed tasks, and wrote abstract code for
the tasks. In the next phase, design, we translate our extended
entity-relationship diagram and abstract code into a relational database schema
and SQL code, respectively.
